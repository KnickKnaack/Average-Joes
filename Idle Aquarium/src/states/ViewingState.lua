--[[
    State for user to view the fish they have bought/bred
]]

ViewingState = Class{__includes = BaseState}

function ViewingState:init() 
end

function ViewingState:enter()
    self.Fish = Fish()
end

function ViewingState:exit() 
end

function ViewingState:update(dt) 
    self.Fish:update(dt)
end

function ViewingState:render() 
    self.Fish:render()
end