-- Level maker for bricks in breakout game

-- Initialize level maker class
LevelMaker = Class{}

-- Method to procedural generate brick layouts
function LevelMaker.createMap(level)

    -- Initialize table to store bricks
    local bricks = {}

    -- Initialize randomised size of brick layout
    local rows = math.random(2, 5)
    local columns = math.random(7, 13)
    columns = columns % 2 == 0 and (columns + 1) or columns -- Ensure number of columns is odd

    -- Initialize highest possible values of bricks
    local highestColor = math.min(5, level % 5 + 3) -- Highest possible color of bricks
    local highestTier = math.min(3, math.floor(level / 5)) -- Highest possible tier of bricks

    -- Create brick layout
    for y = 1, rows do -- Iterate through randomised rows

        -- Handle skipping of bricks in brick layout
        skipBrick = math.random(1, 2) == 1 and true or false -- Randomly activate skipping

        if skipBrick then -- Check if skipping brick was activated
            skipFlag = math.random(1, 2) == 1 and true or false -- Randomly activate skipping flag if so
        end

        -- Handle color alternation of bricks in brick layout
        alternateBrick = math.random(1, 2) == 1 and true or false -- Randomly activate alternating

        if alternateBrick then -- Check if alternating brick was activated

            alternateColor1 = math.random(1, highestColor) -- Randomly choose first color to alternate if so
            alternateColor2 = math.random(1, highestColor) -- Randomly choose second color to alternate if so
            alternateTier1 = math.random(0, highestTier) -- Randomly choose first tier to alternate if so
            alternateTier2 = math.random(0, highestTier) -- Randomly choose second tier to alternate if so

            alternateFlag = math.random(1, 2) == 1 and true or false -- Randomly set alternation flag if so
        
        else -- Check if alternating brick was not choosen
            solidColor = math.random(1, highestColor) -- Randomly choose color to set
            solidTier = math.random(0, highestTier) -- Randomly choose tier to set
        end

        for x = 1, columns do -- Iterate through randomised columns

            -- Skip bricks if activated
            if skipBrick and skipFlag then -- Check if skipping bricks is activated and skipping flag on brick is activated
                skipFlag = false -- Set skipping flag to false for next iteration
                goto continue -- Skip iteration for to apply skiping bricks
            elseif skipBrick and not skipFlag then -- Check if skipping bricks is activated and skipping flag on brick is deactivated
                skipFlag = true -- Set skipping flag to false for next iteration
            end

            brick = Brick( -- Initialize a brick object
                (x - 1) * BRICK_WIDTH + 8 + (13 - columns) * 16, -- Center bricks on x-axis
                y * BRICK_HEIGHT -- Y-axis of bricks
            )

            -- Alternate bricks if activated
            if not alternateBrick then -- Check if alternating bricks is deactivated
                brick.color = solidColor -- Set color of brick to solid color if so
                brick.tier = solidTier -- Set tier of brick to solid tier if so
            elseif alternateBrick and alternateFlag then -- Check if alternating bricks is activated and alternating flag on brick is activated
                brick.color = alternateColor1 -- Set bricks color to first color alternation
                brick.tier = alternateTier1 -- Set bricks tier to first tier alternation
                alternateFlag = false -- Set alternating flag to false for next iteration
            elseif alternateBrick and not alternateFlag then -- Check if alternating bricks is activated and alternating flag on brick is deactivated
                brick.color = alternateColor2 -- Set bricks color to second color alternation
                brick.tier = alternateTier2 -- Set bricks tier to second tier alternation
                alternateFlag = true -- Set alternating flag to true for next iteration
            end

             -- Randomly spawn locked bricks
            lockSpawner = math.random(1, 100)
            if lockSpawner <= math.min(level, 20) then -- Scale locked bricks spawning according to level
                brick.lockBrick = true
            end

            table.insert(bricks, brick) -- Insert brick object in bricks table

            ::continue:: -- Skipping point
        end
    end

    -- Return bricks table
    return bricks
end
