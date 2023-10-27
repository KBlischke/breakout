-- Enter highscore state for breakout game

-- Initialize enter highscore state as subclass of base state
EnterHighscoreState = Class{__includes = BaseState}

-- Characters for choosing name of highscore
local characters = {
    [1] = 65, 
    [2] = 65, 
    [3] = 65
}

-- Current highlighted character
local highlighted = 1

-- Method to enter into enter highscore state
function EnterHighscoreState:enter(parameters) -- Input parameters from start state
    self.highscores = parameters.highscores
    self.score = parameters.score
    self.scoreIndex = parameters.scoreIndex
end

-- Method to aplly behaviour to highscore state
function EnterHighscoreState:update(dt) -- Input delta time

    -- Handle keyboard input
    if love.keyboard.wasPressed("space") then -- Check if space was pressed
       
        -- Assign characters to name
        local name = string.char(characters[1]) .. string.char(characters[2]) .. string.char(characters[3])

        -- Create new highscore
        newHighscore = {
            name = name,
            score = self.score
        }

        -- Insert new highscore to highscore table
        table.insert(self.highscores, self.scoreIndex, newHighscore) -- Insert new highscore at according index
        table.remove(self.highscores, 11) -- Remove last highscore from table

        -- Initialize variable to store highscores
        local scores = ""

        for i = 1, 10, 1 do -- Iterate through highscores
            scores = scores .. self.highscores[i].name .. "\n" -- Append name to highscore variable
            scores = scores .. tostring(self.highscores[i].score) .. "\n" -- Append score to highscore variable
        end

        love.filesystem.write("breakout.lst", scores) -- Write highscore variable to file

        gStateMachine:change("highscore", { -- Change from enter highscore state to highscores state
            highscores = self.highscores -- Enter highscore state with current highscores
        })

    elseif love.keyboard.wasPressed("escape") then -- Check if escape was pressed

        gSounds.confirm:play() -- Play confirmation sound
        gStateMachine:change("start", { -- Change from highscore state to start state
            highscores = self.highscores -- Enter start state with dhighscores of highscore state
        })
    end

    -- Scroll through character slots
    if love.keyboard.wasPressed("left") and highlighted > 1 then -- Check if left key was pressed and highlighted character is bigger than 1
        highlighted = highlighted - 1 -- Decrement highlighted character if so
        gSounds["select"]:play() -- Play select sound if so
    elseif love.keyboard.wasPressed("right") and highlighted < 3 then -- Check if right key was pressed and highlighted character is smaller than 3
        highlighted = highlighted + 1 -- Increment highlighted character if so
        gSounds["select"]:play() -- Play select sound if so
    end

    -- Scroll through characters
    if love.keyboard.wasPressed("up") then -- Check if up key was pressed
        characters[highlighted] = characters[highlighted] + 1 -- Increment ASCII value of character
        if characters[highlighted] > 90 then -- Check if ASCII value of character is bigger than 90
            characters[highlighted] = 65 -- Invert ASCII value of character to 65 if so
        end
        gSounds["select"]:play() -- Play select sound if so
    elseif love.keyboard.wasPressed("down") then -- Check if down key was pressed
        characters[highlighted] = characters[highlighted] - 1 -- Decrement ASCII value of character
        if characters[highlighted] < 65 then -- Check if ASCII value of character is smaller than 65
            characters[highlighted] = 90 -- Invert ASCII value of character to 90 if so
        end
        gSounds["select"]:play() -- Play select sound if so
    end
end

-- Method to render enter highscore state
function EnterHighscoreState:draw()

    love.graphics.setFont(gFonts.middle)
    love.graphics.printf("Your score: " .. tostring(self.score), 0, 30, VIRTUAL_WIDTH, "center") -- Display current score

    love.graphics.setFont(gFonts.large)

    if highlighted == 1 then -- Check if first character is highlighted
        love.graphics.setColor(103/255, 255/255, 255/255, 255/255) -- Highlight first character if so
    end
    love.graphics.print(string.char(characters[1]), VIRTUAL_WIDTH / 2 - 30, VIRTUAL_HEIGHT / 2) -- Display first character
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255) -- Reset color of character

    if highlighted == 2 then -- Check if second character is highlighted
        love.graphics.setColor(103/255, 255/255, 255/255, 255/255) -- Highlight first character if so
    end
    love.graphics.print(string.char(characters[2]), VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2) -- Display second character
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255) -- Reset color of character

    if highlighted == 3 then -- Check if third character is highlighted
        love.graphics.setColor(103/255, 255/255, 255/255, 255/255) -- Highlight first character if so
    end
    love.graphics.print(string.char(characters[3]), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 2) -- Display third character
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255) -- Reset color of character
    
    love.graphics.setFont(gFonts.small)
    love.graphics.printf("Press Space to confirm", 0, VIRTUAL_HEIGHT - 30, VIRTUAL_WIDTH, 'center') -- Display instruction to confirm
    love.graphics.printf("Press Escape to quit", 0, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH, 'center') -- Display instruction to quit
end
