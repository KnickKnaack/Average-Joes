--[[
    GD50
    Breakout Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Originally developed by Atari in 1976. An effective evolution of
    Pong, Breakout ditched the two-player mechanic in favor of a single-
    player game where the player, still controlling a paddle, was tasked
    with eliminating a screen full of differently placed bricks of varying
    values by deflecting a ball back at them.

    This version is built to more closely resemble the NES than
    the original Pong machines or the Atari 2600 in terms of
    resolution, though in widescreen (16:9) so it looks nicer on 
    modern systems.

    Credit for graphics (amazing work!):
    https://opengameart.org/users/buch

    Credit for music (great loop):
    http://freesound.org/people/joshuaempyre/sounds/251461/
    http://www.soundcloud.com/empyreanma
]]

require 'src/Dependencies'

mouse = {}
fish = {'src/Fish'}

lastRecordedTime = 0
currCurrency = 0

--[[
    Called just once at the beginning of the game; used to set up
    game objects, variables, etc. and prepare the game world.
]]
function love.load()
    -- set love's default filter to "nearest-neighbor", which essentially
    -- means there will be no filtering of pixels (blurriness), which is
    -- important for a nice crisp, 2D look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    -- set the application title bar
    love.window.setTitle('Idle Aquarium')

    -- initialize our nice-looking retro text fonts
    gFonts = {
        ['Title'] = love.graphics.newFont('fonts/APOLLO.otf', 38),
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }
    love.graphics.setFont(gFonts['small'])

    -- load up the graphics we'll be using throughout our states
    gTextures = {
        ['background'] = love.graphics.newImage('graphics/backgrounds/background.png'),
        ['background1'] = love.graphics.newImage('graphics/backgrounds/Background_1.png'), 
        ['background2'] = love.graphics.newImage('graphics/backgrounds/Background_2.png'), 
        ['background3'] = love.graphics.newImage('graphics/backgrounds/Background_3.png'), 
        ['Common1'] = love.graphics.newImage('graphics/fish/Common_1-4.png'),
        ['Common2'] = love.graphics.newImage('graphics/fish/Common_5-8.png'),
        ['Common3'] = love.graphics.newImage('graphics/fish/Common_9-12.png'),
        ['Common4'] = love.graphics.newImage('graphics/fish/Common_13-16.png'),
        ['Common5'] = love.graphics.newImage('graphics/fish/Common_17-20.png'),
        ['Coral'] = love.graphics.newImage('graphics/decoration/Coral.png'),
        ['Rare1'] = love.graphics.newImage('graphics/fish/Rare12.png'),
        ['Rare2'] = love.graphics.newImage('graphics/fish/Rare34.png'),
        ['Rare3'] = love.graphics.newImage('graphics/fish/Rare56.png'),
        ['Rare4'] = love.graphics.newImage('graphics/fish/Rare78.png'),
        ['Rare5'] = love.graphics.newImage('graphics/fish/Rare910.png')
    }

    -- Quads we will generate for all of our textures; Quads allow us
    -- to show only part of a texture and not the entire thing
    gFrames = {
        ['Common1'] = GenerateQuads(gTextures['Common1'], FISH_TYPE_DATA_TABLE['Common1'][2], FISH_TYPE_DATA_TABLE['Common1'][3]),
        ['Common2'] = GenerateQuads(gTextures['Common2'], FISH_TYPE_DATA_TABLE['Common2'][2], FISH_TYPE_DATA_TABLE['Common2'][3]),
        ['Common3'] = GenerateQuads(gTextures['Common3'], FISH_TYPE_DATA_TABLE['Common3'][2], FISH_TYPE_DATA_TABLE['Common3'][3]),
        ['Common4'] = GenerateQuads(gTextures['Common4'], FISH_TYPE_DATA_TABLE['Common4'][2], FISH_TYPE_DATA_TABLE['Common4'][3]),
        ['Common5'] = GenerateQuads(gTextures['Common5'], FISH_TYPE_DATA_TABLE['Common5'][2], FISH_TYPE_DATA_TABLE['Common5'][3]),
        ['Rare1'] = GenerateQuads(gTextures['Rare1'], FISH_TYPE_DATA_TABLE['Rare1'][2], FISH_TYPE_DATA_TABLE['Rare1'][3]),
        ['Rare2'] = GenerateQuads(gTextures['Rare2'], FISH_TYPE_DATA_TABLE['Rare2'][2], FISH_TYPE_DATA_TABLE['Rare2'][3]),
        ['Rare3'] = GenerateQuads(gTextures['Rare3'], FISH_TYPE_DATA_TABLE['Rare3'][2], FISH_TYPE_DATA_TABLE['Rare3'][3]),
        ['Rare4'] = GenerateQuads(gTextures['Rare4'], FISH_TYPE_DATA_TABLE['Rare4'][2], FISH_TYPE_DATA_TABLE['Rare4'][3]),
        ['Rare5'] = GenerateQuads(gTextures['Rare5'], FISH_TYPE_DATA_TABLE['Rare5'][2], FISH_TYPE_DATA_TABLE['Rare5'][3])
    }

    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- set up our sound effects; later, we can just index this table and
    -- call each entry's `play` method
    gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['play-music'] = love.audio.newSource('sounds/play_music.wav', 'static'),
        ['menu-music'] = love.audio.newSource('sounds/menu_music.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/music.wav', 'static')
    }

    -- the state machine we'll be using to transition between various states
    -- in our game instead of clumping them together in our update and draw
    -- methods
    --
    -- our current game state can be any of the following:
    -- 1. 'start' (the beginning of the game, where we're told to press Enter)
    -- 2. 'paddle-select' (where we get to choose the color of our paddle)
    -- 3. 'serve' (waiting on a key press to serve the ball)
    -- 4. 'play' (the ball is in play, bouncing between paddles)
    -- 5. 'victory' (the current level is over, with a victory jingle)
    -- 6. 'game-over' (the player has lost; display score and allow restart)
    gStateMachine = StateMachine ({
        ['start'] = function()
          love.audio.setVolume(0.25)
          love.audio.stop()
          gSounds['menu-music']:play()
          gSounds['menu-music']:setLooping(true)
          return StartState()
        end,
        ['viewing'] = function()
          love.audio.stop()
          gSounds['play-music']:play()
          gSounds['play-music']:setLooping(true)
          return ViewingState()
        end,
        ['shop'] = function() return ShopState() end,
        ['settings'] = function() return SettingsState() end,
        
        ['minigame'] = function()
          love.audio.stop()
          gSounds['music']:play()
          gSounds['music']:setLooping(true)
          -- add code to change background
          return MiniGameState()
        end
    })
    gStateMachine:change('start')
    
    -- a table we'll use to keep track of which keys have been pressed this
    -- frame, to get around the fact that LÖVE's default callback won't let us
    -- test for input from within other functions
    love.keyboard.keysPressed = {}


    --File folder to store data files in 
    love.filesystem.setIdentity('Idle Aquarium')


    --Item purchased flags
    --STORE IN FILE LATER
    item1Purchased = false;
    item2Purchased = false;
    item3Purchased = false;


end
--[[
    Called whenever we change the dimensions of our window, as by dragging
    out its bottom corner, for example. In this case, we only need to worry
    about calling out to `push` to handle the resizing. Takes in a `w` and
    `h` variable representing width and height, respectively.
]]
function love.resize(w, h)
    push:resize(w, h)
end

--[[
    Called every frame, passing in `dt` since the last frame. `dt`
    is short for `deltaTime` and is measured in seconds. Multiplying
    this by any changes we wish to make in our game will allow our
    game to perform consistently across all hardware; otherwise, any
    changes we make will be applied as fast as possible and will vary
    across system hardware.
]]
function love.update(dt)
    -- this time, we pass in dt to the state object we're currently using
    gStateMachine:update(dt)

    -- reset keys pressed
    love.keyboard.keysPressed = {}
end

--[[
    A callback that processes key strokes as they happen, just the once.
    Does not account for keys that are held down, which is handled by a
    separate function (`love.keyboard.isDown`). Useful for when we want
    things to happen right away, just once, like when we want to quit.
]]
function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
end

--[[
    A custom function that will let us test for individual keystrokes outside
    of the default `love.keypressed` callback, since we can't call that   logic
    elsewhere by default.
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

--[[
    Called each frame after update; is responsible simply for
    drawing all of our game objects and more to the screen.
]]
function love.draw()
    -- begin drawing with push, in our virtual resolution
    push:apply('start')

    -- background should be drawn regardless of state, scaled to fit our
    -- virtual resolution
    local backgroundWidth = gTextures['background3']:getWidth()
    local backgroundHeight = gTextures['background3']:getHeight()

    love.graphics.draw(gTextures['background3'], 
        -- draw at coordinates 0, 0
        0, 0, 
        -- no rotation
        0,
        -- scale factors on X and Y axis so it fills the screen
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))
    
    -- use the state machine to defer rendering to the current state we're in
    gStateMachine:render()
    
    -- display FPS for debugging; simply comment out to remove
    -- displayFPS()
    push:apply('end')
  
end

--[[
    This method will allow us to test for indiviudal mouse presses
    of the default love.mousepressed callback. We can pass the following
    parameters:
    - 'x', mouse x position in pixels
    - 'y', mouse y position in pixels
    - 'button', the button index that was pressed
    - 'istouch', true if the mouse button press originated from
      a touch screen
    - 'presses' - number of times mouse clicked, simulates double-click
      triple click, etc.
]]
function love.mousepressed(x, y, button)
  if button == "1" and x == fish.x and y == fish.y then love.audio.play(gSounds['brick-hit-1'])
  end
end -- end function love.mousepressed

--[[
    Renders the current FPS.
]]
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end

function getFishFromFile()
    fishToReturn = {}

    if (not love.filesystem.getInfo('FishInPlay.csv')) then
        local start = ''
        for i = 1, 3 do
            start = start .. 'Common1' .. ',' .. math.random(4) .. '\n'
        end

        love.filesystem.write('FishInPlay.csv', start)
    end


    for line in love.filesystem.lines('FishInPlay.csv') do
        local indexOfLast = 0
        local indexOfNext = string.find(line, ",")
        local FishData = {}


        while (indexOfNext ~= nil) do
            table.insert(FishData, string.sub(line, indexOfLast + 1, indexOfNext - 1))
            indexOfLast = indexOfNext
            indexOfNext = string.find(line, ",", indexOfLast + 1)
        end

        table.insert(FishData, string.sub(line, indexOfLast + 1))

        table.insert(fishToReturn, Fish(FishData))
    end

    return fishToReturn
end


function writeFishToFile(fish)
    local toWrite = ''
    
    for k, f in pairs(fish)do
        toWrite = toWrite .. tostring(f.skin) .. ","
        toWrite = toWrite .. tostring(f.color) .. "\n"
    end

    love.filesystem.write('FishInPlay.csv', toWrite)

end


function readUtilFromFile()
    if (not love.filesystem.getInfo('Util.csv')) then
        start = '0\n'
        start = start .. tostring(os.time())..'\n'
        love.filesystem.write('Util.csv', start)
    end

    toReturn = {}

    for line in love.filesystem.lines('Util.csv') do
        table.insert(toReturn, tonumber(line))
    end

    return toReturn

end

function writeUtilToFile(data)
    local toWrite = ''

    for k, item in pairs(data) do
        toWrite = toWrite .. tostring(item) .. "\n"
    end

    love.filesystem.write('Util.csv', toWrite)
end


function initializeShopFile()
    itemList = "Common Fish 1,1000,Earns 5 coins/second,Common1,3\n"
    itemList = itemList .. "New Background,2000,Offers bonus to clownfish.,background1\n"
    itemList = itemList .. "Coral decoration,500,Earns 15 coins/second,Coral\n"
    love.filesystem.write("FullShopList.csv", itemList)
end


function updateCurrency(FishInPlay) 
    local diff = os.time() - lastRecordedTime

    if (diff >= 1) then
        currCurrency = currCurrency + 1
        for k, f in pairs(FishInPlay) do
            currCurrency = currCurrency + FISH_TYPE_DATA_TABLE[f.skin][1] * diff
        end
        lastRecordedTime = os.time()
    end

end


--[[
    Split function retrieved from https://love2d.org/forums/viewtopic.php?f=4&t=85549
]]
function split(s, delimiter)
    local result = {};
    i = 0
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, i, match);
        i = i + 1
    end
    return result;
end

--Revised version of what is found here: https://gist.github.com/abursuc/51185d11ddd946f433e1299489ed2c07
function math.randomchoice(t) --Selects a random item from a table
    local keys = {}
    local size = 0
    for key, value in pairs(t) do
        keys[size+1] = key --Store keys in another table
        size = size + 1
    end

    return keys[math.random(1, size)]
end


function renderCoins(x, y, limit, align)
    love.graphics.setFont(gFonts['medium'])

    if (currCurrency < 1000) then
        love.graphics.printf(tostring(currCurrency) .. " Coins", x, y, limit, align)

    elseif (currCurrency >= 1000 and currCurrency < 1000000) then
        love.graphics.printf(string.format("%.2f", currCurrency/1000) .. "K Coins", x, y, limit, align)

    elseif (currCurrency >= 1000000 and currCurrency < 1000000000) then
        love.graphics.printf(string.format("%.2f", currCurrency/1000000) .. "M Coins", x, y, limit, align)

    else
        love.graphics.printf(string.format("%.2f", currCurrency/1000000000) .. "B Coins", x, y, limit, align)
    end

end