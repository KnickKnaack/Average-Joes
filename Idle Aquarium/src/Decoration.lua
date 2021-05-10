Decoration = Class{}

function Decoration:init(t)
    self.texture = t
    self.width = gTextures[t]:getWidth()
    self.height = gTextures[t]:getHeight()
end

function Decoration:insert()
    for k, data in pairs(ownedDecorations) do
        if(data == self.texture) then
            return
        end
    end

    table.insert(ownedDecorations, self)
end