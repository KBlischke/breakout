-- Victory state for breakout game

-- Initialize victory state as subclass of base state
VictoryState = Class{__includes = BaseState}

-- Method to enter into victory state
function VictoryState:enter(parameters) -- Input parameters from play state
    self.paddle = parameters.paddle
    self.ball = parameters.ball
    self.health = parameters.health
    self.score = parameters.score
    self.highscores = parameters.highscores
    self.level = parameters.level
end

-- Method to aplly behaviour to victory state
function VictoryState:update(dt) -- Input delta time

    -- Apply movement to player
    self.paddle:update(dt)

    -- Stick ball on paddle
    self.ball.x = self.paddle.x + self.paddle.width / 2 - self.ball.width / 2
    self.ball.y = self.paddle.y - self.ball.height

    -- Check if space was pressed
    if love.keyboard.wasPressed("space") then

        gSounds.confirm:play() -- Play confirmation sound

        -- Create upgradedbrick layout
        newBricks = LevelMaker.createMap(self.level + 1)

        gStateMachine:change("serve", { -- Change from victory state to serve state
            paddle = self.paddle, -- Enter serve state with paddle of victory state
            ball = self.ball, -- Enter serve state with ball of victory state
            bricks = newBricks, -- Enter serve state with generated brick layout
            powerups = loadKeys(newBricks), -- Enter serve state with generated keys
            health = self.health, -- Enter serve state with health of victory state
            score = self.score, -- Enter serve state with score of victory state
            highscores = self.highscores, -- Enter serve state with current highscores
            level = self.level + 1, -- Enter serve state with incremented level of victory state
        })
    end

    -- Check if escape was pressed
    if love.keyboard.wasPressed("escape") then
        
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

            gSounds["highscore"]:play() -- Play highscore sound
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
end

-- Method to render victory state
function VictoryState:draw()

    -- Render player paddle
    self.paddle:draw()

    -- Render ball
    self.ball:draw()

    -- Render score
    renderScore(self.score)

    -- Render health
    renderHealth(self.health)

    love.graphics.setFont(gFonts.large)
    love.graphics.printf("Level " .. tostring(self.level) .. " complete!", 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, "center") -- Display current level
    love.graphics.setFont(gFonts.middle)
    love.graphics.printf("Press Space to continue", 0,VIRTUAL_HEIGHT / 2,VIRTUAL_WIDTH, "center") -- Display instruction to continue
    love.graphics.printf("Press Escape to return", 0,VIRTUAL_HEIGHT / 2 + 20,VIRTUAL_WIDTH, "center") -- Display instruction to quit
end
