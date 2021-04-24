--[[
    GD50
    Breakout Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state the game is in when we've just started; should
    simply display "Breakout" in large text, as well as a message to press
    Enter to begin.
]]

-- the "__includes" bit here means we're going to inherit all of the methods
-- that BaseState has, so it will have empty versions of all StateMachine methods
-- even if we don't override them ourselves; handy to avoid superfluous code!
StartState = Class{__includes = BaseState}

function StartState:enter(params)
    --self.FishInPlay = getFishFromFile()
    local userData = readUtilFromFile()

    love.audio.stop()
    gSounds['menu-music']:play()
    gSounds['menu-music']:setLooping(true)

    eButton = Button(10, 10, 20, 10, "Exit", love.event.quit, 0, 0, 0, 1)
    oButton = Button(10, 30, 35, 10, "Options", StartState.callOptions, 0, 0, 0, 1)
    pButton = Button(40, 0, VIRTUAL_WIDTH - 40, VIRTUAL_HEIGHT,
                    "", StartState.callViewing, 0, 0, 0, 0)
    currCurrency = userData[1]
    lastRecordedTime = userData[2]

end

function StartState:update(dt)
    -- we no longer have this globally, so include here
    eButton:update()
    oButton:update()
    pButton:update()
--    if love.mouse.isDown(1) then
--        params = {}
--        params.FishInPlay = self.FishInPlay
--        gStateMachine:change('viewing', params)
--    end

end

function StartState:render()
    -- title
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['Title'])
    love.graphics.printf("Idle Aquarium", 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Click anywhere to play", 0, (VIRTUAL_HEIGHT / 3) * 2,
        VIRTUAL_WIDTH, 'center')
    
    eButton:draw()
    oButton:draw()
    pButton:draw()
end

function StartState:callOptions()
    params = {}
    params.callingState = 'start'
    gStateMachine:change('settings', params)
end

function StartState:callViewing()
    params = {}
    params.FishInPlay = getFishFromFile()
    gStateMachine:change('viewing', params)
end