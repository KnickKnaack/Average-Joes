
BreedingState = Class{}

function BreedingState:init() 


end



function BreedingState:enter(params) 
    self.FishInPlay = params.FishInPlay
end



function BreedingState:exit() 


end



function BreedingState:update(dt) 
    if love.keyboard.wasPressed('escape') then
        params = {}
        params.FishInPlay = self.FishInPlay
        gStateMachine:change('viewing', params)
    end
end



function BreedingState:render() 
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("BREEDING", 0, 10, VIRTUAL_WIDTH, 'center')
end