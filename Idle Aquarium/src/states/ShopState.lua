
ShopState = Class{__includes = BaseState}

function ShopState:enter(params) 
    self.FishInPlay = params.FishInPlay
end

function ShopState:update(dt)

    updateCurrency(self.FishInPlay)

    if love.keyboard.wasPressed('o') then
        params = {}
        params.FishInPlay = self.FishInPlay
        params.callingState = 'shop'
        gStateMachine:change('settings', params)
    end

    if love.keyboard.wasPressed('escape') then
        params = {}
        params.FishInPlay = self.FishInPlay
        gStateMachine:change('viewing', params)
    end
    
    -- Check if item is clicked
    if love.mouse.isDown(1) then
        local w, h = love.graphics.getDimensions()
        widthScaleFactor = w/VIRTUAL_WIDTH
        heightScaleFactor = h/VIRTUAL_HEIGHT
        x, y = love.mouse.getPosition()
        if(x > widthScaleFactor*VIRTUAL_WIDTH/10 and x < widthScaleFactor*(VIRTUAL_WIDTH - VIRTUAL_WIDTH/10)) then
            if(y > 42*heightScaleFactor and y < 82*heightScaleFactor) then
                if(currCurrency > tonumber(item1[1])) then
                    if(not item1Purchased) then
                        currCurrency = currCurrency - tonumber(item1[1])
                    end
                    item1Purchased = true
                end
                self:renderItems()
            elseif(y > 92*heightScaleFactor and y < 132*heightScaleFactor) then
                if(currCurrency > tonumber(item2[1])) then
                    if(not item2Purchased) then
                        currCurrency = currCurrency - tonumber(item2[1])
                    end
                    item2Purchased = true
                end
                self:renderItems()
            elseif(y > 142*heightScaleFactor and y < 182*heightScaleFactor) then
                if(currCurrency > tonumber(item3[1])) then
                    if(not item3Purchased) then
                        currCurrency = currCurrency - tonumber(item3[1])
                    end
                    item3Purchased = true
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

    if (not love.filesystem.getInfo("FullShopList.csv")) then
        initializeShopFile()
    end

    self.lines = {}
    i = 0
    for line in love.filesystem.lines("FullShopList.csv") do
        table.insert(self.lines, i, line)
        i = i + 1
    end

    self:renderItems()


end


function ShopState:renderItems()
        -- FIRST ITEM
        if(not item1Purchased) then
            item1 = split(self.lines[0], ',')
            love.graphics.setColor(64/255, 207/255, 199/255, 0.55)
            love.graphics.rectangle("fill", VIRTUAL_WIDTH/10, 40, VIRTUAL_WIDTH-2*VIRTUAL_WIDTH/10, 40)
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf(item1[0], VIRTUAL_WIDTH/10 + 50, 42, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            love.graphics.printf(string.format("%d coins", tonumber(item1[1])), VIRTUAL_WIDTH/10 + 50, 62, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            _, _, itemWidth, _ = gFrames[item1[3]][tonumber(item1[4])]:getViewport()
            _, _, _, itemHeight = gFrames[item1[3]][tonumber(item1[4])]:getViewport()
            love.graphics.setColor(1, 1, 1);
            love.graphics.draw(gTextures[item1[3]], gFrames[item1[3]][tonumber(item1[4])], VIRTUAL_WIDTH/10 + 5, 45, 0, 40/itemWidth, 30/itemHeight)
        else
            item1 = split(self.lines[0], ',')
            love.graphics.setColor(22/255, 107/255, 103/255, 0.45)
            love.graphics.rectangle("fill", VIRTUAL_WIDTH/10, 40, VIRTUAL_WIDTH-2*VIRTUAL_WIDTH/10, 40)
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf("Purchased", VIRTUAL_WIDTH/10 + 50, 42, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            _, _, itemWidth, _ = gFrames[item1[3]][tonumber(item1[4])]:getViewport()
            _, _, _, itemHeight = gFrames[item1[3]][tonumber(item1[4])]:getViewport()
            love.graphics.setColor(90/255, 90/255, 90/255);
            love.graphics.draw(gTextures[item1[3]], gFrames[item1[3]][tonumber(item1[4])], VIRTUAL_WIDTH/10 + 5, 45, 0, 40/itemWidth, 30/itemHeight)
            love.graphics.setColor(1, 1, 1);
        end
    
    
        -- SECOND ITEM
        if(not item2Purchased) then
            item2 = split(self.lines[1], ',')
            love.graphics.setColor(64/255, 207/255, 199/255, 0.55)
            love.graphics.rectangle("fill", VIRTUAL_WIDTH/10, 90, VIRTUAL_WIDTH-2*VIRTUAL_WIDTH/10, 40)
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf(item2[0], VIRTUAL_WIDTH/10 + 50, 92, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            love.graphics.printf(string.format("%d coins", tonumber(item2[1])), VIRTUAL_WIDTH/10 + 50, 112, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            itemWidth = gTextures[item2[3]]:getWidth()
            itemHeight = gTextures[item2[3]]:getHeight()
            love.graphics.setColor(1, 1, 1);
            love.graphics.draw(gTextures[item2[3]], VIRTUAL_WIDTH/10 + 5, 95, 0, 40/itemWidth, 30/itemHeight)
        else
            item2 = split(self.lines[1], ',')
            love.graphics.setColor(22/255, 107/255, 103/255, 0.45)
            love.graphics.rectangle("fill", VIRTUAL_WIDTH/10, 90, VIRTUAL_WIDTH-2*VIRTUAL_WIDTH/10, 40)
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf("Purchased", VIRTUAL_WIDTH/10 + 50, 92, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            itemWidth = gTextures[item2[3]]:getWidth()
            itemHeight = gTextures[item2[3]]:getHeight()
            love.graphics.setColor(90/255, 90/255, 90/255);
            love.graphics.draw(gTextures[item2[3]], VIRTUAL_WIDTH/10 + 5, 95, 0, 40/itemWidth, 30/itemHeight)
            love.graphics.setColor(1, 1, 1);
        end
    
        -- THIRD ITEM
        if(not item3Purchased) then
            item3 = split(self.lines[2], ',')
            love.graphics.setColor(64/255, 207/255, 199/255, 0.55)
            love.graphics.rectangle("fill", VIRTUAL_WIDTH/10, 140, VIRTUAL_WIDTH-2*VIRTUAL_WIDTH/10, 40)
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf(item3[0], VIRTUAL_WIDTH/10 + 50, 142, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            love.graphics.printf(string.format("%d coins", tonumber(item3[1])), VIRTUAL_WIDTH/10 + 50, 162, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            itemWidth = gTextures[item3[3]]:getWidth()
            itemHeight = gTextures[item3[3]]:getHeight()
            love.graphics.setColor(1, 1, 1);
            love.graphics.draw(gTextures[item3[3]], VIRTUAL_WIDTH/10 + 5, 145, 0, 40/itemWidth, 30/itemHeight)
        else
            item3 = split(self.lines[2], ',')
            love.graphics.setColor(22/255, 107/255, 103/255, 0.45)
            love.graphics.rectangle("fill", VIRTUAL_WIDTH/10, 140, VIRTUAL_WIDTH-2*VIRTUAL_WIDTH/10, 40)
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf("Purchased", VIRTUAL_WIDTH/10 + 50, 142, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 5, 'left')
            itemWidth = gTextures[item3[3]]:getWidth()
            itemHeight = gTextures[item3[3]]:getHeight()
            love.graphics.setColor(90/255, 90/255, 90/255);
            love.graphics.draw(gTextures[item3[3]], VIRTUAL_WIDTH/10 + 5, 145, 0, 40/itemWidth, 30/itemHeight)
            love.graphics.setColor(1, 1, 1);
        end
end