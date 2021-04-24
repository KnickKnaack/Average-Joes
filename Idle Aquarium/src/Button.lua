Button = Class {}

--[[
    x: x position of top left corner
    y: y position of top left corner
    width: total width (horizontal)
    height: total height (vertical)
    text: text on button
    action: what happens when you click
    r: red value of RGB
    g: green
    b: blue
    o: opacity
    image: optional image for shop/breeding states
]]
function Button:init(x, y, width, height, text, action, r, g, b, o, image)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.midY = y + height / 2
    self.maxX = x + width
    self.maxY = y + height

    self.text = text
    self.action = action

    self.r = r
    self.g = g
    self.b = b
    self.o = o

    self.clicked = false
    self.counter = 10
    self.image = image
end

function Button:update()
    -- mouse data
    local mouseX = love.mouse.getX() / (80/27)
    local mouseY = love.mouse.getY() / (80/27)
    local down = false
    
    if (self.counter < 1) then
        down = love.mouse.isDown(1)
    else
        self.counter = self.counter - 1
    end

    -- FIXME: this will probably need to be expanded later -SH
    if down and not self.clicked then
        if (mouseX > self.x and mouseX < self.maxX and mouseY > self.y and mouseY < self.maxY) then
            self.action()
            self.clicked = true
        end
    end
end

function Button:draw()
    --set graphics
    love.graphics.setLineWidth(1)
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(self.r, self.g, self.b, self.o)

    -- draw
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.printf(self.text, self.x, self.midY - 3, self.width, 'center')
end