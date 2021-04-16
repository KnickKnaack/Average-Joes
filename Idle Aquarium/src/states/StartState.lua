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
    self.fishtable = getFishFromFile()
    local userData = readUtilFromFile()
    self.currency = userData[1]
    self.lastRecordedTime = userData[2]
end

function StartState:update(dt)
    -- we no longer have this globally, so include here
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.mouse.isDown(1) then
        params = {}
        params.fishtable = self.fishtable
        params.currency = self.currency
        params.lastRecordedTime = self.lastRecordedTime
        gStateMachine:change('viewing', params)
    end

    if love.keyboard.wasPressed('o') then
        params = {}
        params.callingState = 'start'
        gStateMachine:change('settings', params)
    end

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

    
end