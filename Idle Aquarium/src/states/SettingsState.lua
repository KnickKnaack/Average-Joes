
SettingsState = Class{__includes = BaseState}

function SettingsState:enter(params) 
    self.FishInPlay = params.fishtable
    self.currCurrency = params.currency
    self.lastRecordedTime = params.lastRecordedTime
    self.callingState = params.callingState
    
    -- volume slider instantiation
    volumeSlider = newSlider(216, 60, 100, 0, 0, 1.0,
                            function (v) love.audio.setVolume(v) end)
end

function SettingsState:update(dt)
    
    -- update slider
    volumeSlider:update(love.mouse.getX(), love.mouse.getY(), love.mouse.isDown(1))

    if love.keyboard.wasPressed('escape') then
        params = {}
        params.fishtable = self.FishInPlay
        params.currency = self.currCurrency
        params.lastRecordedTime = self.lastRecordedTime
        gStateMachine:change(self.callingState, params)
    end
end

function SettingsState:render()

    -- render state header
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Options", 0, 10, VIRTUAL_WIDTH, 'center')
    
    -- volume setting
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("VOLUME", 0, 45, VIRTUAL_WIDTH, 'center')
    love.graphics.setLineWidth(1)
    volumeSlider:draw()
    volumeSlider:update()
    
end