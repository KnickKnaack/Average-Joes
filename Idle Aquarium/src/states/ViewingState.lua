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

    if love.keyboard.wasPressed('s') then
        params = {}
        params.FishInPlay = self.FishInPlay
        gStateMachine:change('shop', params)
    end

    if love.keyboard.wasPressed('/') then
        currCurrency = 0
    end
    
    if love.keyboard.wasPressed('m') then
        params = {}
        params.FishInPlay = self.FishInPlay
        gStateMachine:change('minigame', params)
    end

    if love.keyboard.wasPressed('o') then
        params = {}
        params.FishInPlay = self.FishInPlay
        params.callingState = 'viewing'
        gStateMachine:change('settings', params)
    end

    if love.keyboard.wasPressed('escape') then
        writeFishToFile(self.FishInPlay)
        writeUtilToFile({currCurrency, lastRecordedTime})
        params = {}
        params.FishInPlay = self.FishInPlay
        gStateMachine:change('start', params)
    end

end

function ViewingState:render() 
    for k, f in pairs(self.FishInPlay) do
        f:render()
    end

    love.graphics.setFont(gFonts['medium'])

    renderCoins(5, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH, 'left')
end
