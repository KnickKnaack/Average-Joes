Item = Class{}

function Item:init(itemLine)
    self.dataValues = split(itemLine, ',')
    self.name = self.dataValues[0]
    self.price = tonumber(self.dataValues[1])
    self.description = self.dataValues[2]
    self.texture = self.dataValues[3]
    self.subTexture = tonumber(self.dataValues[4])


    if (string.find(self.name, "Fish")) then
        _, _, self.width, _ = gFrames[self.texture][self.subTexture]:getViewport()
        _, _, _, self.height = gFrames[self.texture][self.subTexture]:getViewport()
    else
        self.width = gTextures[self.texture]:getWidth()
        self.height = gTextures[self.texture]:getHeight()
    end

end