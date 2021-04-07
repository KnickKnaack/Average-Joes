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
        ['background'] = love.graphics.newImage('graphics/background.png'), 
        ['ClownFish'] = love.graphics.newImage('graphics/ClownFish.png'),
        ['Blue'] = love.graphics.newImage('graphics/Blue.png'),
        ['Sparkle'] = love.graphics.newImage('graphics/Sparkle.png')
    }

    --[[
    -- Quads we will generate for all of our textures; Quads allow us
    -- to show only part of a texture and not the entire thing
    gFrames = {
        ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),
        ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
        ['balls'] = GenerateQuadsBalls(gTextures['main']),
        ['bricks'] = GenerateQuadsBricks(gTextures['main']),
        ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9)
    }
    ]]

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
        ['play-music'] =love.audio.newSource('sounds/play_music.wav', 'static'),
        ['menu-music'] =love.audio.newSource('sounds/menu_music.wav', 'static'),
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
          love.audio.setVolume(0)
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
        ['settings'] = function() return SettingsState() end
    })
    gStateMachine:change('start')
    
    -- a table we'll use to keep track of which keys have been pressed this
    -- frame, to get around the fact that LÖVE's default callback won't let us
    -- test for input from within other functions
    love.keyboard.keysPressed = {}
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
    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'], 
        -- draw at coordinates 0, 0
        0, 0, 
        -- no rotation
        0,
        -- scale factors on X and Y axis so it fills the screen
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))
    
    -- use the state machine to defer rendering to the current state we're in
    gStateMachine:render()
    
    -- display FPS for debugging; simply comment out to remove
    displayFPS()
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

function readFishInPlay()
    fishToReturn = {}
    love.filesystem.setIdentity('Idle Aquarium')

    if (not love.filesystem.getInfo('FishInPlay.csv')) then
        start = ''
        for i = 1, 3 do
            start = start .. math.random(3) .. ','
        end

        love.filesystem.write('FishInPlay.csv', start)
    end

    
    File = love.filesystem.read('FishInPlay.csv')
    nextSec = 0
    while (string.sub(File, nextSec, nextSec + 1) == ',') do
        table.insert(fishToReturn, Fish(tonumber(string.sub(line, nextSec + 1, nextSec + 2))))
        nextSec = nextSec + 2
    end

    table.insert(fishToReturn, Fish(3))

    return fishToReturn
end