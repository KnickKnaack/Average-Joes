
Fish = Class{}

function Fish:init()
    -- simple positional and dimensional variables
    self.width = 22
    self.height = 11

    
    self.dy = math.random(10, 20)
    self.dx = math.random(50, 80)
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
end

--[[
    Expects an argument with a bounding box, be that a paddle or a brick,
    and returns true if the bounding boxes of this and the argument overlap.
]]
function Fish:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end


function Fish:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dy = math.random(10, 20)
    self.dx = math.random(50, 80)
end

function Fish:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    self.dy = self.dy + math.random(-0.5, 0.5)
    self.dx = self.dx + math.random(-3, 3)

    -- allow Fish to bounce off walls
    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
    end

    if self.x >= VIRTUAL_WIDTH - self.width then
        self.x = VIRTUAL_WIDTH - self.width
        self.dx = -self.dx
    end

    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
    end

    if self.y >= VIRTUAL_HEIGHT - self.height then
        self.y = VIRTUAL_HEIGHT - self.height
        self.dy = -self.dy
    end

end

function Fish:render()
    if (self.dx <= 0) then
        love.graphics.draw(gTextures['ClownFish'] , self.x, self.y)
    else
        love.graphics.draw(gTextures['ClownFish'] , self.x + self.width, self.y, 0, -1, 1)
    end
end