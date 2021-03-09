--[[
    State for user to view the fish they have bought/bred
]]

ViewingState = Class{__includes = BaseState}

function ViewingState:init() 
end

function ViewingState:enter()
    self.Fish1 = Fish()
    self.Fish2 = Fish()
    self.Fish3 = Fish()
    self.Fish4 = Fish()
    self.Fish5 = Fish()
    self.Fish6 = Fish()

end

function ViewingState:exit() 
end

function ViewingState:update(dt) 
    self.Fish1:update(dt)
    self.Fish2:update(dt)
    self.Fish3:update(dt)
    self.Fish4:update(dt)
    self.Fish5:update(dt)
    self.Fish6:update(dt)
end

function ViewingState:render() 
    self.Fish1:render()
    self.Fish2:render()
    self.Fish3:render()
    self.Fish4:render()
    self.Fish5:render()
    self.Fish6:render()
end