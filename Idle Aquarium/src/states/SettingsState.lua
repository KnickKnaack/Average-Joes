
SettingsState = Class{__includes = BaseState}

function SettingsState:enter(params) 
    self.FishInPlay = params.FishInPlay
    self.callingState = params.callingState
    
    -- volume slider instantiation
    volumeSlider = Slider(162, 55, 100, love.audio.getVolume(), 0, 1.0, function (v) love.audio.setVolume(v) end)
    retButton = Button(10, 10, 35, 10, "Return", SettingsState.ret, 0, 0, 0, 1)
end

function SettingsState:update(dt)
    -- update slider and button
    volumeSlider:update()
    retButton:update()
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
    retButton:draw()
end

function SettingsState:ret()
    gStateMachine:change(params.callingState, params)
end