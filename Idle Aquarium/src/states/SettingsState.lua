SettingsState = Class{__includes = BaseState}
function SettingsState:enter(params) 
    self.FishInPlay = params.fishtable
    self.currCurrency = params.currency
    self.lastRecordedTime = params.lastRecordedTime
    self.callingState = params.callingState
end

function SettingsState:update(dt)
    if love.keyboard.wasPressed('escape') then
        params = {}
        params.fishtable = self.FishInPlay
        params.currency = self.currCurrency
        params.lastRecordedTime = self.lastRecordedTime
        gStateMachine:change(self.callingState, params)
    end
end

function SettingsState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("SETTINGS", 0, 10, VIRTUAL_WIDTH, 'center')
end