--[[
    GD50 2018
    Breakout Remake

    -- constants --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Some global constants for our application.
]]

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243


-- Fish behaviour
MAX_VER_FISH_SPEED = 80
MAX_HOR_FISH_SPEED = 25

FISH_VER_ACC = 1.5
FISH_HOR_ACC = 0.5

MIN_TIME_FLIP = 0.75

CLOSE_TO_EDGE_MULTIPLIER = 1.75
EDGE_CUTOFF_VER =  VIRTUAL_HEIGHT / 5  --fraction of VIRTUAL_HEIGHT
EDGE_CUTOFF_HOR =  VIRTUAL_WIDTH / 6  --fraction of VIRTUAL_WIDTH