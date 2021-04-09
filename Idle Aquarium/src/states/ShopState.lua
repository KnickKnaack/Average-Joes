
ShopState = Class{__includes = BaseState}

function ShopState:enter(params) 
    self.FishInPlay = params.fishtable
    self.currCurrency = params.currency
    self.lastRecordedTime = params.lastRecordedTime
end

function ShopState:update(dt)

    if love.keyboard.wasPressed('o') then
        params = {}
        params.fishtable = self.FishInPlay
        params.currency = self.currCurrency
        params.lastRecordedTime = self.lastRecordedTime
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

    if (not love.filesystem.getInfo("FullShopList.csv")) then
        initializeShopFile()
    end

    local lines = {}
    i = 0
    for line in love.filesystem.lines("FullShopList.csv") do
        table.insert(lines, i, line)
        i = i + 1
    end

    -- FIRST ITEM
    lineValues = split(lines[0], ',')
    love.graphics.setColor(50/255, 168/255, 162/255)
    love.graphics.rectangle("fill", VIRTUAL_WIDTH/10, 40, VIRTUAL_WIDTH-2*VIRTUAL_WIDTH/10, 40)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(lineValues[0], VIRTUAL_WIDTH/10 + 5, 42, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
    love.graphics.printf(lineValues[1], VIRTUAL_WIDTH/10 + 5, 62, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')

    -- SECOND ITEM
    lineValues = split(lines[1], ',')
    love.graphics.setColor(50/255, 168/255, 162/255)
    love.graphics.rectangle("fill", VIRTUAL_WIDTH/10, 90, VIRTUAL_WIDTH-2*VIRTUAL_WIDTH/10, 40)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(lineValues[0], VIRTUAL_WIDTH/10 + 5, 92, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
    love.graphics.printf(lineValues[1], VIRTUAL_WIDTH/10 + 5, 112, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')

    -- THIRD ITEM
    lineValues = split(lines[2], ',')
    love.graphics.setColor(50/255, 168/255, 162/255)
    love.graphics.rectangle("fill", VIRTUAL_WIDTH/10, 140, VIRTUAL_WIDTH-2*VIRTUAL_WIDTH/10, 40)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(lineValues[0], VIRTUAL_WIDTH/10 + 5, 142, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
    love.graphics.printf(lineValues[1], VIRTUAL_WIDTH/10 + 5, 162, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
end