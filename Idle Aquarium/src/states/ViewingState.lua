--[[
    State for user to view the fish they have bought/bred
]]

ViewingState = Class{__includes = BaseState}

function ViewingState:init() 
end

function ViewingState:enter(params)

    self.currCurrency = params.currency
    self.FishInPlay = params.FishInPlay
    self.lastRecordedTime = params.lastRecordedTime
    self.test = math

    love.audio.stop()
    gSounds['play-music']:play()
    gSounds['play-music']:setLooping(true)

    escButton = Button(10, 10, 36, 10, "Escape", function () self:callStart() end, 0, 0, 0, 1)
    optButton = Button(10, 30, 36, 10, "Options", function () self:callOptions() end, 0, 0, 0, 1)
    shopButton = Button(10, 50, 36, 10, "Shop", function () self:callShop() end, 0, 0, 0, 1)
    miniButton = Button(10, 70, 36, 10, "Minigame", function() self:callMini() end, 0, 0, 0, 1)
    --[[
    -- CHANGE params.lastRecordedTime WHEN FILE MANIP IS WORKING --
    self.diff = os.time() - params.lastRecordedTime
    for k, f in pairs(self.FishInPlay) do
        self.currCurrency = params.currency + f.currRate * self.diff
    end
    --]]

end

function ViewingState:exit() 
end

function ViewingState:update(dt) 
    escButton:update()
    optButton:update()
    shopButton:update()
    miniButton:update()
    
    for k, f in pairs(self.FishInPlay) do
        f:update(dt)
    end

    updateCurrency(self.FishInPlay)

    if love.keyboard.wasPressed('=') then
        table.insert(self.FishInPlay, Fish({math.randomchoice(FISH_TYPE_DATA_TABLE), math.random(4)}))
    end

    if love.keyboard.wasPressed('-') then
        table.remove(self.FishInPlay)
    end

    if love.keyboard.wasPressed('p') then
        currCurrency = currCurrency + 1000000
    end

    if love.keyboard.wasPressed('b') then
        params = {}
        params.FishInPlay = self.FishInPlay
        gStateMachine:change('breeding', params)
    end

    if love.keyboard.wasPressed('/') then
        currCurrency = 0
    end
    
end

function ViewingState:render() 
    for k, f in pairs(self.FishInPlay) do
        f:render()
    end

    love.graphics.setFont(gFonts['medium'])

    renderCoins(5, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH, 'left')

    escButton:draw()
    optButton:draw()
    shopButton:draw()
    miniButton:draw()
end

function ViewingState:callStart()
    writeFishToFile(self.FishInPlay)
    writeUtilToFile({currCurrency, lastRecordedTime})
    params = {}
    params.FishInPlay = self.FishInPlay
    gStateMachine:change('start', params)
end

function ViewingState:callOptions()
    params = {}
    params.FishInPlay = self.FishInPlay
    params.callingState = 'viewing'
    gStateMachine:change('settings', params)
end

function ViewingState:callShop()
    params = {}
    params.FishInPlay = self.FishInPlay
    gStateMachine:change('shop', params)
end

function ViewingState:callMini()
    params = {}
    params.FishInPlay = self.FishInPlay
    gStateMachine:change('minigame', params)
end