--[[
Copyright (c) 2016 George Prosser

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
]]

--[[
    Downloaded by:      Shannon Head
    Date of download:   5 April 2021
    Source:             https://love2d.org/forums/viewtopic.php?t=80711
    Changes made:       - Rewrote as a class for consistency with other code
                        - Removed unneccesary code and rewrote sections to 
                        better fit our purpose
                        - Renamed some variables
                        - Added additional comments for clarity. 
]]

Slider = Class{}

--[[
    x: x position of top left corner
    y: y position of top left corner
    width = total width of slider (horizontal)
    value = current value held
    min = minimum possible value
    max = maximum possible value
    setter = function affected by slider value
]]
function Slider:init(x, y, width, value, min, max, setter)
    self.x = x
    self.y = y
    self.width = width
    self.value = value
    self.min = min
    self.max = max
    self.setter = setter

    self.height = width * 0.1
    self.grabbed = false
    self.wasDown = true

    self.knobX = x + width * value
    self.knobY = y

    self.dx = 0
    self.dy = 0
end

function Slider:update()
    -- mouse data; accounts for the ratio of virtual width/height
    local x = love.mouse.getX() / (80 / 27)
    local y = love.mouse.getY() / (80 / 27)
    local down = love.mouse.isDown(1)    

    -- distance from cursor to knob coordinates
    local dx = x - self.knobX
    local dy = y - self.knobY

    -- change in distance (how far knob was dragged)
    local cx = dx - self.dx
    
    
    if down then
        if self.grabbed then
            self.value = self.value + cx / self.width
        elseif (dx > 0 and dx < 10 and dy > 0 and dy < 10) then
            self.dx = dx
            self.dy = dy
            self.grabbed = true
        end

    else
        self.grabbed = false
    end 
    -- set value within boundaries of slider
    self.value = math.max(0, math.min(0.9, self.value))
    self.knobX = self.x + self.width * self.value
    self.setter(self.value)
end

function Slider:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.draw(gTextures['Common1'], gFrames['Common1'][3], self.knobX - 6, self.y)

    -- uncomment if we get rid of the fish knob
    -- love.graphics.rectangle('fill', self.knobX, self.y, self.height, self.height)
end