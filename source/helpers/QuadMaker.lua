-- Utility file for breakout game

-- Function to generate quad paddles
function generateQuadPaddles(atlas) -- Input atlas

    -- Set dimensions of paddle
    local paddleWidth = 32
    local paddleHeight = 16

    -- Set starting position of paddle sprites
    local position = 64

    -- Create paddle quad table
    local counter = 1 -- counter for paddle quads
    local quads = {} -- Table for paddle quads

    -- Iterate through paddles of atlas
    for i = 0, 3 do

        -- Smallest paddle
        quads[counter] = love.graphics.newQuad(
            paddleWidth * 0, -- X-position of paddle in atlas
            position, -- Y-position of paddle in atlas
            paddleWidth, -- Width of paddle
            paddleHeight, -- Height of paddle
            atlas:getDimensions() -- Dimensons of atlas
        )
        counter = counter + 1 -- Increment paddle counter

        -- Medium paddle
        quads[counter] = love.graphics.newQuad(
            paddleWidth * 1, -- X-position of paddle in atlas
            position, -- Y-position of paddle in atlas
            paddleWidth * 2, -- Width of paddle
            paddleHeight, -- Height of paddle
            atlas:getDimensions() -- Dimensons of atlas
        )
        counter = counter + 1 -- Increment paddle counter

        -- Large paddle
        quads[counter] = love.graphics.newQuad(
            paddleWidth * 3, -- X-position of paddle in atlas
            position, -- Y-position of paddle in atlas
            paddleWidth * 3, -- Width of paddle
            paddleHeight, -- Height of paddle
            atlas:getDimensions() -- Dimensons of atlas
        )
        counter = counter + 1 -- Increment paddle counter

        -- Huge paddle
        quads[counter] = love.graphics.newQuad(
            paddleWidth * 0, -- X-position of paddle in atlas
            position + paddleHeight, -- Y-position of paddle in atlas
            paddleWidth * 4, -- Width of paddle
            paddleHeight, -- Height of paddle
            atlas:getDimensions() -- Dimensons of atlas
        )
        counter = counter + 1 -- Increment paddle counter

        position = position + 32
    end

    -- Return paddle quads out of atlas
    return quads
end

-- Function to generate quad balls
function generateQuadBalls(atlas) -- Input atlas

    -- Set position of ball
    local x = 96
    local y = 48

    -- Create ball quad table
    local counter = 1 -- counter for ball quads
    local quads = {} -- Table for ball quads

    -- Iterate through first row of balls in atlas
    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(
            x, -- X-position of ball in atlas
            y, -- Y-position of ball in atlas
            BALL_WIDTH, -- Width of ball
            BALL_HEIGHT, -- Height of ball
            atlas:getDimensions() -- Dimensons of atlas
        )
        x = x + BALL_WIDTH -- Update x-position of new ball quad
        counter = counter + 1 -- Increment ball counter
    end

    -- Update position of ball quads
    x = 96
    y = y + BALL_HEIGHT

    -- Iterate through second row of balls in atlas
    for i = 0, 2 do
        quads[counter] = love.graphics.newQuad(
            x, -- X-position of ball in atlas
            y, -- Y-position of ball in atlas
            8, -- Width of ball
            8, -- Height of ball
            atlas:getDimensions() -- Dimensons of atlas
        )
        x = x + BALL_WIDTH -- Update x-position of new ball quad
        counter = counter + 1 -- Increment ball counter
    end

    -- Return ball quads out of atlas
    return quads
end

-- Function to generate quads out of image
function generateQuads(atlas, tileWidth, tileHeight) -- Input atlas with sprites and dimensions if tile

    -- Get dimensions of spritesheet
    local sheetWidth = atlas:getWidth() / tileWidth -- Number of columns of spritesheet
    local sheetHeight = atlas:getHeight() / tileHeight -- Number of rows of spritesheet

    -- Create spritesheet table
    local sheetCounter = 1 -- Index of sprites in spritesheet
    local spritesheet = {} -- Table for sprites

    -- Iterate through entire atlas
    for y = 0, sheetHeight - 1 do -- Iterate through sheet columns
        for x = 0, sheetWidth - 1 do -- Iterate through sheet rows
            spritesheet[sheetCounter] = love.graphics.newQuad( -- Append new sprite to spritesheet from atlas
                x * tileWidth, y * tileHeight, -- Set x and y position according to index
                tileWidth, tileHeight, -- Set quad dimensions according tile dimensions
                atlas:getDimensions() -- Get dimensions of atlas
            )

            sheetCounter = sheetCounter + 1 -- Increment index of spritesheet
        end
    end

    -- Return spritesheet
    return spritesheet
end

-- Function to slice tables
function sliceTable(table, first, last, step) -- Input table, its first and laste lement and the steps between them

    -- Table for sliced elements
    local slicedTable = {}

    -- Iterate through table according to input
    for i = first or 1, last or #table, step or 1 do
        slicedTable[#slicedTable + 1] = table[i] -- Append sliced element of table to sliced table
    end

    -- Return sliced Table
    return slicedTable
end

-- Function to generate quad bricks
function generateQuadBricks(atlas) -- Input atlas
    return sliceTable(generateQuads(atlas, BRICK_WIDTH, BRICK_HEIGHT), 1, 24) -- Return brick quads out of atlas
end

-- Function to generate quad powerups
function generateQuadPowerups(atlas)
    return sliceTable(generateQuads(atlas, POWERUP_WIDTH, POWERUP_HEIGHT), 145, 155) -- Return powerup quads out of atlas
end
