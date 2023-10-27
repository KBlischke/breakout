-- Helper functions for breakout game

-- Add functionality for key input
function love.keypressed(key)

    -- Assign pressed keys as true in table
    love.keyboard.keysPressed[key] = true
end

-- Check for pressed keys in keyboard tables
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key] -- Return boolean according to status of pressed key
end

-- Display current health
function renderHealth(health) -- Input health

    -- Position of health rendering
    local healthX = VIRTUAL_WIDTH - 100

    -- Render current health
    for i = 1, health do -- Iterate through health
        love.graphics.draw(gTextures.hearts, gSprites.hearts[1], healthX, 4) -- Render full hearts
        healthX = healthX + 11 -- Update x-position of heart
    end

    -- Render missing health
    for i = 1, HEALTH_MAXIMUM - health do -- Iterate through missing health
        love.graphics.draw(gTextures.hearts, gSprites.hearts[2], healthX, 4) -- Render empty hearts
        healthX = healthX + 11 -- Update x-position of heart
    end
end

-- Display current score
function renderScore(score)
    love.graphics.setFont(gFonts.small) -- Set small font for score
    love.graphics.printf("Score: ", 0, 5, VIRTUAL_WIDTH - 30, "right") -- Print score to screen
    love.graphics.print(tostring(score), VIRTUAL_WIDTH - 25, 5) -- Print score to screen
end

-- Display current level
function renderLevel(level)
    love.graphics.setFont(gFonts.small) -- Set small font for level
    love.graphics.print("Level " .. tostring(level), 5, 5) -- Print level to screen
end

-- Display current FPS
function renderFPS()
    love.graphics.setColor(255/255, 0/255, 0/255, 255/255) -- Set font color of FPS
    love.graphics.setFont(gFonts.small) -- Set small font for FPS
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), VIRTUAL_WIDTH - 35, VIRTUAL_HEIGHT - 10) -- Print FPS to screen
end

-- Method to check if level is cleared
function checkVictory(bricks)

    for m, brick in pairs(bricks) do -- Iterate through bricks in bricks table
        if not brick.destroyed then -- Check if brick is not destroyed
            return false -- Return false if so
        end
    end

    -- Return true if every brick is destroyed
    return true
end

-- Loading highscores from file in system
function loadHighscores()

    -- Set directory to load files
    love.filesystem.setIdentity("Breakout")

    -- Create placeholder highscores
    if not love.filesystem.getInfo("Breakout.lst") then -- Check if file does not exist

        local scores = "" -- Initialize variable to store highscores if so

        for i = 10, 1, -1 do -- Iterate 10 times through placeholders
            scores = scores .. "---\n" -- Append placeholder name to variable
            scores = scores .. tostring(i * 0) .. "\n" -- Append placeholder score to variable
        end

        love.filesystem.write("Breakout.lst", scores) -- Write variable to file if so
    end

    -- initialize table for highscores
    local scores = {}

    -- Create placeholder entries for highscore table
    for i = 1, 10, 1 do
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    -- Initialize variables for file reading
    local name = true -- Name flag for lines
    local counter = 1 -- Index for highscore entries in file

    -- Assign highscores and names from file to highscore table
    for line in love.filesystem.lines("Breakout.lst") do -- Itrerate through file

        if name then -- Check if name flag is activated
            scores[counter].name = string.sub(line, 1, 3) -- Assign name on line to highscore table if so
        else -- Check if name flag is deactivated
            scores[counter].score = tonumber(line)  -- Assign score on line to highscore table if so
            counter = counter + 1 -- Increment counter
        end

        -- flip name flag
        name = not name
    end

    -- Return highscore table
    return scores
end

-- Initialize key powerup if there are locked bricks
function loadKeys(brickTable)

    keys = {} -- Initialize table for keys

    for i, brick in pairs(brickTable) do -- Iterate through bricks
        if brick.lockBrick then -- Check for bricks with locks

            while true do -- Iterate until stoped
                keyPlacement = math.random(1, #brickTable) -- Randomly choose brick
                if not brickTable[keyPlacement].lockBrick then -- Check if choosen brick is not locked
                    table.insert(keys, Powerup( -- Insert new key in keys table
                        "key", 
                        brickTable[keyPlacement].x + brickTable[keyPlacement].width / 2 - POWERUP_WIDTH / 2, 
                        brickTable[keyPlacement].y, 
                        false
                    ))

                    -- Stop loop
                    break
                end
            end

            -- Stop loop
            break
        end
    end

    -- Return keys table
    return keys
end

-- Scale resizing of window
function love.resize(w, h)
    push:resize(w, h)
end
