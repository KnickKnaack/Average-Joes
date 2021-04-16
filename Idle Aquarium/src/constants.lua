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

-- for rendering fish until a better method is formed
FISH_SKIN_TABLE = {[1]='Common1',   [2]='Common2',   [3]='Common3',   [4]='Common4', [5]='Common5',
                    [6]='Rare1',   [7]='Rare2',   [8]='Rare3',   [9] = 'Rare4',    [10]='Rare5'}
--Fish data with skins [Rate, xsize, ysize]
FISH_TYPE_DATA_TABLE = {['Common1']={1, 23, 11}, ['Common2']={2, 15, 15}, ['Common3']={3, 18, 11}, ['Common4']={4, 17, 17}, ['Common5']={5, 34, 20},
                        ['Rare1']={6, 30, 23}, ['Rare2']={7, 38, 17}, ['Rare3']={8, 31, 24}, ['Rare4']={9, 42, 48}, ['Rare5']={10, 27, 35} }


-- Fish behaviour
MAX_VER_FISH_SPEED = 80
MAX_HOR_FISH_SPEED = 25

FISH_VER_ACC = 1.5
FISH_HOR_ACC = 0.5

MIN_TIME_FLIP = 0.75

CLOSE_TO_EDGE_MULTIPLIER = 1.75
EDGE_CUTOFF_VER =  VIRTUAL_HEIGHT / 5  --fraction of VIRTUAL_HEIGHT
EDGE_CUTOFF_HOR =  VIRTUAL_WIDTH / 6  --fraction of VIRTUAL_WIDTH