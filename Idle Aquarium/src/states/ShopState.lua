
ShopState = Class{__includes = BaseState}

function ShopState:enter(params) 
    self.FishInPlay = params.fishtable
    self.currCurrency = params.currency
    self.lastRecordedTime = params.lastRecordedTime
end

function ShopState:update(dt)

    if love.keyboard.wasPressed('o') then
        params = {}
        params.callingState = 'shop'
        gStateMachine:change('settings', params)
    end

    if love.keyboard.wasPressed('escape') then
        params = {}
        params.fishtable = self.FishInPlay
        params.currency = self.currCurrency
        params.lastRecordedTime = self.lastRecordedTime
        gStateMachine:change('viewing', params)
    end
end

function ShopState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("SHOP", 0, 10, VIRTUAL_WIDTH, 'center')
end