-- Serve state for breakout game

-- Initialize start state as subclass of base state
ServeState = Class{__includes = BaseState}

-- Method to enter into serve state
function ServeState:enter(parameters) -- Input parameters from start state

    -- Initialize state with inputed parameters
    self.paddle = parameters.paddle
    self.ball = parameters.ball
    self.bricks = parameters.bricks
    self.powerups = parameters.powerups
    self.health = parameters.health
    self.score = parameters.score
    self.highscores = parameters.highscores
    self.level = parameters.level
end

-- Method to aplly behaviour to serve state
function ServeState:update(dt) -- Input delta time

    -- Apply movement to player
    self.paddle:update(dt)

    -- Stick ball on paddle
    self.ball.x = self.paddle.x + self.paddle.width / 2 - self.ball.width / 2
    self.ball.y = self.paddle.y - self.ball.height

    -- Enter play state
    if love.keyboard.wasPressed("space") then -- Check if space was pressed

        gStateMachine:change("play", { -- Change from serve state to play state
            paddle = self.paddle, -- Enter play state with paddle of serve state
            ball = self.ball, -- Enter play state with ball of serve state
            bricks = self.bricks, -- Enter play state with bricks of serve state
            powerups = self.powerups, -- Enter play state with loaded keys
            health = self.health, -- Enter play state with health of serve state
            score = self.score, -- Enter play state with score of serve state
            highscores = self.highscores, -- Enter play state with highscores of serve state
            level = self.level, -- Enter play state with level of serve state
        })
        gSounds.paddle_hit:play() -- Play paddle hit sound
    end

    -- Leave serve state
    if love.keyboard.wasPressed("escape") then -- Check if escape was pressed
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

-- Method to render serve state
function ServeState:draw()

    -- Render player paddle
    self.paddle:draw()

    -- Render ball
    self.ball:draw()

    -- Render bricks in bricks table
    for j, brick in pairs(self.bricks) do
        brick:draw()
    end

    -- Render keys in powerups table
    for i = #self.powerups, 1, -1 do
        if self.powerups[i].mode == "key" then
            self.powerups[i]:draw(dt)
        end
    end

    -- Render score
    renderScore(self.score)

    -- Render health
    renderHealth(self.health)

    -- Render level
    renderLevel(self.level)

    love.graphics.setFont(gFonts.middle)
    love.graphics.printf("Press Space to start", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, "center") -- Display Instruction to start
end
