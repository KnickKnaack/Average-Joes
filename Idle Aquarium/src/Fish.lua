
Fish = Class{}

function Fish:init(skin)
    -- simple positional and dimensional variables
    self.width = 22
    self.height = 11

    self.skin = skin

    self.currRate = self.skin
    
    self.dy = math.random(-10, 10)
    self.dx = math.random(-20, 20)
    self.x = math.random(5, VIRTUAL_WIDTH - (self.width + 5))
    self.y = math.random(5, VIRTUAL_HEIGHT - (self.height + 5))

    if (self.dx >= 0) then
        self.dxPOS = true
    else
        self.dxPOS = false
    end

    self.timeSinceFlip = 0
    self.waitDirection = 1

    self.skins = {[1]='ClownFish', [2]='Blue', [3]='Sparkle'}

end

-- if something needs collide logic with a fish
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
    self.dy = math.random(-10, 10)
    self.dx = math.random(-20, 20)
    self.x = math.random(5, VIRTUAL_WIDTH - (self.width + 5))
    self.y = math.random(5, VIRTUAL_HEIGHT - (self.height + 5))
end

function Fish:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    
    if self.x < EDGE_CUTOFF_HOR then
        self.xWarn = -1
    elseif self.x > VIRTUAL_WIDTH - EDGE_CUTOFF_HOR then
        self.xWarn = 1
    else
        self.xWarn = 0
    end

    if self.y < EDGE_CUTOFF_VER then
        self.yWarn = -1
    elseif self.y > VIRTUAL_HEIGHT - EDGE_CUTOFF_VER then
        self.yWarn = 1
    else
        self.yWarn = 0
    end



    --update dy and make sure it is less than the max velocity and tending to go away form edges
    if (self.dy > 0) then
        if (self.yWarn < 0) then
            self.dy = math.min(self.dy + math.random(-FISH_HOR_ACC, FISH_HOR_ACC * CLOSE_TO_EDGE_MULTIPLIER), MAX_HOR_FISH_SPEED)
        elseif (self.yWarn > 0) then
            self.dy = math.min(self.dy + math.random(-FISH_HOR_ACC * CLOSE_TO_EDGE_MULTIPLIER, FISH_HOR_ACC), MAX_HOR_FISH_SPEED)
        else
            self.dy = math.min(self.dy + math.random(-FISH_HOR_ACC, FISH_HOR_ACC), MAX_HOR_FISH_SPEED)
        end
    else
        if (self.yWarn < 0) then
            self.dy = math.max(self.dy + math.random(-FISH_HOR_ACC, FISH_HOR_ACC * CLOSE_TO_EDGE_MULTIPLIER), -MAX_HOR_FISH_SPEED)
        elseif (self.yWarn > 0) then
            self.dy = math.max(self.dy + math.random(-FISH_HOR_ACC * CLOSE_TO_EDGE_MULTIPLIER, FISH_HOR_ACC), -MAX_HOR_FISH_SPEED)
        else
            self.dy = math.max(self.dy + math.random(-FISH_HOR_ACC, FISH_HOR_ACC), -MAX_HOR_FISH_SPEED)
        end
    end



    --update dx and make sure it is less than the max velocity and tending to go away form edges
    if (self.dxPOS) then
        if (self.xWarn < 0) then
            self.dx = math.min(self.dx + math.random(-FISH_VER_ACC, FISH_VER_ACC * CLOSE_TO_EDGE_MULTIPLIER), MAX_VER_FISH_SPEED)
        elseif (self.xWarn > 0) then
            self.dx = math.min(self.dx + math.random(-FISH_VER_ACC * CLOSE_TO_EDGE_MULTIPLIER, FISH_VER_ACC), MAX_VER_FISH_SPEED)
        else
            self.dx = math.min(self.dx + math.random(-FISH_VER_ACC, FISH_VER_ACC), MAX_VER_FISH_SPEED)
        end
    else
        if (self.xWarn < 0) then
            self.dx = math.max(self.dx + math.random(-FISH_VER_ACC, FISH_VER_ACC * CLOSE_TO_EDGE_MULTIPLIER), -MAX_VER_FISH_SPEED)
        elseif (self.xWarn > 0) then
            self.dx = math.max(self.dx + math.random(-FISH_VER_ACC * CLOSE_TO_EDGE_MULTIPLIER, FISH_VER_ACC), -MAX_VER_FISH_SPEED)
        else
            self.dx = math.max(self.dx + math.random(-FISH_VER_ACC, FISH_VER_ACC), -MAX_VER_FISH_SPEED)
        end
    end
        

    --used for rendering when fish change direction
    self.timeSinceFlip = self.timeSinceFlip + dt


    --keep test for a change in dx polarity for smoother rendering
    -- (if a fish changes direction within the before MIN_TIME_FLIP seconds have passed it will still be rendered the same)
    if (self.dx > 0 and (not self.dxPOS) and self.timeSinceFlip > MIN_TIME_FLIP) then
        self.timeSinceFlip = 0
        self.dxPOS = true
    elseif (self.dx < 0 and self.dxPOS and self.timeSinceFlip > MIN_TIME_FLIP) then
        self.timeSinceFlip = 0
        self.dxPOS = false
    end



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
    if (not self.dxPOS) then
        love.graphics.draw(gTextures[self.skins[self.skin]] , self.x, self.y)
    else
        love.graphics.draw(gTextures[self.skins[self.skin]] , self.x + self.width, self.y, 0, -1, 1)
    end
end