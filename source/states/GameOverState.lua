-- Game over state for breakout game

-- Initialize game over state as subclass of base state
GameOverState = Class{__includes = BaseState}

-- Method to enter into game over state
function GameOverState:enter(parameters) -- Input parameters from play state
    self.score = parameters.score
    self.highscores = parameters.highscores
end

-- Method to aplly behaviour to game over state
function GameOverState:update(dt) -- Input delta time

    -- Check if space was pressed
    if love.keyboard.wasPressed("space") then

        -- Set flag for checking of new highscore
        local highscore = false
        
        -- Keep track of ordered index of score inside highscores
        local scoreIndex = 11

        -- Iterate through highscores
        for i = 10, 1, -1 do
            if self.score > self.highscores[i].score then -- Check if highscore at index is smaller than current score
                self.scoreIndex = i -- Set index of score to current index of highscores
                highscore = true -- Activate flag for new highscore
            end
        end

        if highscore then -- Check if new highscore flag is activated
            
            gSounds.highscore:play() -- Play highscore sound
            gStateMachine:change("enterHighscore", { -- Change from game over state to enter highscore state
                highscores = self.highscores,  -- Enter enter highscore state with current highscores
                score = self.score,  -- Enter enter highscore state with current score
                scoreIndex = self.scoreIndex  -- Enter enter highscore state with current score index of score
            }) 
        else -- Check if new highscore flag is deactivated
            gSounds.confirm:play() -- Play confirmation sound
            gStateMachine:change("start", { -- Change from game over state to enter highscore state if so
                highscores = self.highscores -- Enter enter highscore state with current highscores
            }) 
        end
    end

    -- Check if escape was pressed
    if love.keyboard.wasPressed("escape") then
        gSounds.confirm:play() -- Play confirmation sound
        love.event.quit() -- Quit game if so
    end
end

-- Method to render start state
function GameOverState:draw()

    love.graphics.setFont(gFonts.large)
    love.graphics.printf("GAME OVER", 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, "center") -- Display game overmessage
    love.graphics.setFont(gFonts.middle)
    love.graphics.printf("Final Score: " .. tostring(self.score), 0, VIRTUAL_HEIGHT / 4 + 40, VIRTUAL_WIDTH, "center") -- Display current score
    love.graphics.printf("Press Space to continue", 0,VIRTUAL_HEIGHT / 2 + 40,VIRTUAL_WIDTH, "center") -- Display instruction to continue
end
