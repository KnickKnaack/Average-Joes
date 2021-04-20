Button = Class {}

--[[
    x: x position of top left corner
    y: y position of top left corner
    width: total width (horizontal)
    height: total height (vertical)
    text: text on button
    r: red value of RGB
    g: green
    b: blue
    o: opacity
]]
function Button:init(x, y, width, height, text, r, g, b, o)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.midX = x + width / 2
    self.midY = y + height / 2

    self.text = text
    self.r = r
    self.g = g
    self.b = b
    self.o = o
end

function Button:update()

end

function Button:draw()
    --set graphics
    love.graphics.setLineWidth(1)
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(self.r, self.g, self.b, self.o)

    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.printf(self.text, self.x, self.midY - 3, self.width, 'center')
end