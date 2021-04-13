--[[ 
    State for user to view various mini games
    and accessed desired game. Ability to exit 
    out of a game as well as enter.
    *Phase 0 = There is no menu option yet,
    a new background is loaded in and fish will be loaded
    in as well.
]]

MiniGameState = Class{__includes = BaseState}

function MiniGameState:enter(params)
    self.FishInPlay = params.fishtable
    self.currCurrency = params.currency
    self.lastRecordedTime = params.lastRecordedTime
    
    remainingTime = 15
    gameOver = false
end

function MiniGameState:update(dt)
  -- while in mini games these key presses are registered:
  -- *o = settings
  -- *escape = takes you back to viewing area
    if love.keyboard.wasPressed('o') then
        params = {}
        params.fishtable = self.FishInPlay
        params.currency = self.currCurrency
        params.lastRecordedTime = self.lastRecordedTime
        params.callingState = 'shop'
        gStateMachine:change('settings', params)
    end
    
    if love.keyboard.wasPressed('escape') then
      params = {}
      params.fishtable = self.FishInPlay
      params.currency = self.currCurrency
      params.lastRecordedTime = self.lastRecordedTime
      gStateMachine:change('viewing', params)
    end
    
    for k, f in pairs(self.FishInPlay) do
        f:update(dt)
    end
    
    x, y = love.mouse.getPosition()
    fishX = fish.x
    fishY = fish.y
    
    if love.mouse.isDown(1) then -- and x == fishX and y == fishY then
      self.currCurrency = self.currCurrency + 50;
      love.audio.play(gSounds['brick-hit-1'])
    end
    
    remainingTime = remainingTime - dt
    if remainingTime <= 0 then
        gameOver = true
    end
end

function MiniGameState:render()
    -- love.graphics.printf("Which mini game would you like to play?", 0, 10, VIRTUAL_WIDTH, 'center')
    -- love.graphics.printf("Press '0' to play \"Fish Feeding Frenzy\"", VIRTUAL_WIDTH/10 + 2, 62, VIRTUAL_WIDTH-VIRTUAL_WIDTH/10 - 2, 'left')
    
    local backgroundWidth = gTextures['background1']:getWidth()
    local backgroundHeight = gTextures['background1']:getHeight()
    
    love.graphics.draw(gTextures['background1'], 
    -- draw at coordinates 0, 0
    0, 0, 
    -- no rotation
    0,
    -- scale factors on X and Y axis so it fills the screen
    VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))
    
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Tap on the fish to collect monies!\n Collect as much as you can before timer runs out!", 0, 10, VIRTUAL_WIDTH, 'center')
    
    for k, f in pairs(self.FishInPlay) do
      f:render()
    end
    
    renderCoins(self.currCurrency, 5, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH, 'left')
    
    if (gameOver == true) then
      love.graphics.clear()
      love.graphics.printf("Game Over! Press 'esc' to return to main screen.", 0, 100, VIRTUAL_WIDTH, 'center')
    end
    
end