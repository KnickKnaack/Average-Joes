
ShopState = Class{__includes = BaseState}

function ShopState:enter(params) 
    self.FishInPlay = params.FishInPlay
    escButton = Button(10, 10, 36, 10, "Escape", function () self:callViewing() end, 0, 0, 0, 1)
end

function ShopState:update(dt)

    updateCurrency(self.FishInPlay)
    escButton:update()

    if love.keyboard.wasPressed('o') then
        params = {}
        params.FishInPlay = self.FishInPlay
        params.callingState = 'shop'
        gStateMachine:change('settings', params)
    end
    
    -- Check if item is clicked
    if love.mouse.isDown(1) then
        local w, h = love.graphics.getDimensions()
        widthScaleFactor = w/VIRTUAL_WIDTH
        heightScaleFactor = h/VIRTUAL_HEIGHT
        x, y = love.mouse.getPosition()
        if(x > widthScaleFactor*VIRTUAL_WIDTH/10 and x < widthScaleFactor*(VIRTUAL_WIDTH - VIRTUAL_WIDTH/10)) then
            if(y > 42*heightScaleFactor and y < 82*heightScaleFactor) then
                if(currCurrency > item1.price) then
                    if(not item1Purchased) then
                        currCurrency = currCurrency - item1.price
                        item1Purchased = true
                    end
                end
                self:renderItems()
            elseif(y > 92*heightScaleFactor and y < 132*heightScaleFactor) then
                if(currCurrency > item2.price) then
                    if(not item2Purchased) then
                        currCurrency = currCurrency - item2.price
                        item2Purchased = true
                    end
                end
                self:renderItems()
            elseif(y > 142*heightScaleFactor and y < 182*heightScaleFactor) then
                if(currCurrency > item3.price) then
                    if(not item3Purchased) then
                        currCurrency = currCurrency - item3.price
                        item3Purchased = true
                    end
                end
                self:renderItems()
            end
        end
    end
end

function ShopState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("SHOP", 0, 10, VIRTUAL_WIDTH, 'center')

    renderCoins(5, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH, 'left')

    if (not love.filesystem.getInfo("BackgroundShopList.csv") and not love.filesystem.getInfo("DecorationShopList.csv") and not love.filesystem.getInfo("FishShopList.csv")) then
        initializeShopFiles()
    end
    
    self.contents = {}
    self.s = ""
    if (not love.filesystem.getInfo("CurrentShopItems.csv")) then
        for line in love.filesystem.lines("FishShopList.csv") do
            table.insert(self.contents, line)
        end

        self.s = self.contents[math.random(#self.contents)] .. "\n"

        self.contents = {}
        for line in love.filesystem.lines("BackgroundShopList.csv") do
            table.insert(self.contents, line)
        end

        self.s = self.s .. self.contents[math.random(#self.contents)] .. "\n"

        self.contents = {}
        for line in love.filesystem.lines("DecorationShopList.csv") do
            table.insert(self.contents, line)
        end
 
        self.s = self.s .. self.contents[math.random(#self.contents)] .. "\n"

        love.filesystem.write('CurrentShopItems.csv', self.s)
    end


    self.lines = {}
    i = 0
    for line in love.filesystem.lines("CurrentShopItems.csv") do
        table.insert(self.lines, i, line)
        i = i + 1
    end

    item1 = Item(self.lines[0])
    item2 = Item(self.lines[1])
    item3 = Item(self.lines[2])

    self:renderItems()
    escButton:draw()

end


function ShopState:renderItems()
        -- FIRST ITEM
        if(not item1Purchased) then
            love.graphics.setColor(64/255, 207/255, 199/255, 0.55)
            love.graphics.rectangle("fill", VIRTUAL_WIDTH/10, 40, VIRTUAL_WIDTH-2*VIRTUAL_WIDTH/10, 40)
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf(item1.name, VIRTUAL_WIDTH/10 + 50, 42, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            love.graphics.printf(string.format("%d coins", item1.price), VIRTUAL_WIDTH/10 + 50, 62, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            love.graphics.setColor(1, 1, 1);
            love.graphics.draw(gTextures[item1.texture], gFrames[item1.texture][item1.subTexture], VIRTUAL_WIDTH/10 + 5, 45, 0, 40/item1.width, 30/item1.height)
        else
            love.graphics.setColor(22/255, 107/255, 103/255, 0.45)
            love.graphics.rectangle("fill", VIRTUAL_WIDTH/10, 40, VIRTUAL_WIDTH-2*VIRTUAL_WIDTH/10, 40)
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf("Purchased", VIRTUAL_WIDTH/10 + 50, 42, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            love.graphics.setColor(90/255, 90/255, 90/255);
            love.graphics.draw(gTextures[item1.texture], gFrames[item1.texture][item1.subTexture], VIRTUAL_WIDTH/10 + 5, 45, 0, 40/item1.width, 30/item1.height)
            love.graphics.setColor(1, 1, 1);
        end
    
    
        -- SECOND ITEM
        if(not item2Purchased) then
            love.graphics.setColor(64/255, 207/255, 199/255, 0.55)
            love.graphics.rectangle("fill", VIRTUAL_WIDTH/10, 90, VIRTUAL_WIDTH-2*VIRTUAL_WIDTH/10, 40)
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf(item2.name, VIRTUAL_WIDTH/10 + 50, 92, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            love.graphics.printf(string.format("%d coins", item2.price), VIRTUAL_WIDTH/10 + 50, 112, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            love.graphics.setColor(1, 1, 1);
            love.graphics.draw(gTextures[item2.texture], VIRTUAL_WIDTH/10 + 5, 95, 0, 40/item2.width, 30/item2.height)
        else
            love.graphics.setColor(22/255, 107/255, 103/255, 0.45)
            love.graphics.rectangle("fill", VIRTUAL_WIDTH/10, 90, VIRTUAL_WIDTH-2*VIRTUAL_WIDTH/10, 40)
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf("Purchased", VIRTUAL_WIDTH/10 + 50, 92, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            love.graphics.setColor(90/255, 90/255, 90/255);
            love.graphics.draw(gTextures[item2.texture], VIRTUAL_WIDTH/10 + 5, 95, 0, 40/item2.width, 30/item2.height)
            love.graphics.setColor(1, 1, 1);
        end
    
        -- THIRD ITEM
        if(not item3Purchased) then
            love.graphics.setColor(64/255, 207/255, 199/255, 0.55)
            love.graphics.rectangle("fill", VIRTUAL_WIDTH/10, 140, VIRTUAL_WIDTH-2*VIRTUAL_WIDTH/10, 40)
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf(item3.name, VIRTUAL_WIDTH/10 + 50, 142, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            love.graphics.printf(string.format("%d coins", item3.price), VIRTUAL_WIDTH/10 + 50, 162, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            love.graphics.setColor(1, 1, 1);
            love.graphics.draw(gTextures[item3.texture], VIRTUAL_WIDTH/10 + 5, 145, 0, 40/item3.width, 30/item3.height)
        else
            love.graphics.setColor(22/255, 107/255, 103/255, 0.45)
            love.graphics.rectangle("fill", VIRTUAL_WIDTH/10, 140, VIRTUAL_WIDTH-2*VIRTUAL_WIDTH/10, 40)
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf("Purchased", VIRTUAL_WIDTH/10 + 50, 142, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            love.graphics.setColor(90/255, 90/255, 90/255);
            love.graphics.draw(gTextures[item3.texture], VIRTUAL_WIDTH/10 + 5, 145, 0, 40/item3.width, 30/item3.height)
            love.graphics.setColor(1, 1, 1);
        end
end

function ShopState:callViewing()
    params = {}
    params.FishInPlay = self.FishInPlay
    gStateMachine:change('viewing', params)
end