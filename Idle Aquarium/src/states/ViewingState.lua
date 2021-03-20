--[[
    State for user to view the fish they have bought/bred
]]

ViewingState = Class{__includes = BaseState}

function ViewingState:init() 
end

function ViewingState:enter()
    
    self.FishInPlay = {}
    
    for i = 1, 3 do
        table.insert(self.FishInPlay, Fish(math.random(3)))
    end



    self.currCurrency = 0
    self.lastRecordedTime = os.time()

end

function ViewingState:exit() 
end

function ViewingState:update(dt) 
    for k, f in pairs(self.FishInPlay) do
        f:update(dt)
    end

    self.diff = os.time() - self.lastRecordedTime

    if (self.diff >= 1) then
        for k, f in pairs(self.FishInPlay) do
            self.currCurrency = self.currCurrency + f.currRate * self.diff
        end
        self.lastRecordedTime = os.time()
    end

    if love.keyboard.wasPressed('=') then
        table.insert(self.FishInPlay, Fish(math.random(3)))
    end

    if love.keyboard.wasPressed('-') then
        table.remove(self.FishInPlay)
    end

end

function ViewingState:render() 
    for k, f in pairs(self.FishInPlay) do
        f:render()
    end

    

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Monies: " .. tostring(self.currCurrency), 5, VIRTUAL_HEIGHT - 20,
        VIRTUAL_WIDTH, 'left')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("^", VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT - 20,
        VIRTUAL_WIDTH, 'left')

end