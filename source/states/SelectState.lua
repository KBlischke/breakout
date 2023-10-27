-- Select state for breakout game

SelectState = Class{__includes = BaseState}

-- Objects for selection
local currentBall = 1
local currentPaddle = 1

-- Method to enter into select state
function SelectState:enter(parameters) -- Input parameters from start state

    -- Initialize state with inputed parameters
    self.highscores = parameters.highscores

    -- Current selected selection
    self.select = 1
end

-- Method for applying behaviour to select state
function SelectState:update(dt)

    if love.keyboard.wasPressed("up") then -- Check if up key was pressed
        if self.select == 1 then -- Check if selection is first selection if so
            gSounds.select:play() -- Play select sound if so
            self.select = 2 -- Change current selection to last selection if so
        else -- Check if current selection is not first selection if so
            gSounds.select:play() -- Play select sound if so
            self.select = self.select - 1 -- Decrement current selection if so
        end
    elseif love.keyboard.wasPressed("down") then -- Check if down key was pressed
        if self.select == 2 then -- Check if selection is last selection if so
            gSounds.select:play() -- Play select sound if so
            self.select = 1 -- Change current selection to first selection if so
        else -- Check if current selection is not last selection if so
            gSounds.select:play() -- Play select sound if so
            self.select = self.select + 1 -- Incrementcurrent selection if so
        end
    end

    if love.keyboard.wasPressed("left") then -- Check if left key was pressed
        if self.select == 1 then -- Check if current selection is first selection
            if currentBall == 1 then -- Check if current ball is first ball if so
                gSounds.select:play() -- Play select sound if so
                currentBall = 7 -- Change current ball to last ballif so
            else -- Check if current ball is not first ball if so
                gSounds.select:play() -- Play select sound if so
                currentBall = currentBall - 1 -- Decrement current ball if so
            end
        elseif self.select == 2 then -- Check if current selection is last selection
            if currentPaddle == 1 then -- Check if current paddle is first paddle if so
                gSounds.select:play() -- Play select sound if so
                currentPaddle = 4 -- Change current paddle to last paddle if so
            else -- Check if current paddle is not first paddle if so
                gSounds.select:play() -- Play select sound if so
                currentPaddle = currentPaddle - 1 -- Decrement current paddle if so
            end
        end
    elseif love.keyboard.wasPressed("right") then -- Check if right key was pressed
        if self.select == 1 then -- Check if current selection is first selection
            if currentBall == 7 then -- Check if current ball is last ball if so
                gSounds.select:play() -- Play select sound if so
                currentBall = 1 -- Change current ball to first ball if so
            else -- Check if current ball is not last ball if so
                gSounds.select:play() -- Play select sound if so
                currentBall = currentBall + 1 -- Increment current ball if so
            end
        elseif self.select == 2 then -- Check if current selection is last selection
            if currentPaddle == 4 then -- Check if current paddle is last paddle if so
                gSounds.select:play() -- Play select sound if so
                currentPaddle = 1 -- Change current paddle to first paddle if so
            else -- Check if current paddle is not last paddle if so
                gSounds.select:play() -- Play select sound if so
                currentPaddle = currentPaddle + 1 -- Increment current paddle if so
            end
        end
    end

    -- Select current paddle and ball
    if love.keyboard.wasPressed("space") then -- Check if space was pressed

        gSounds.confirm:play() -- Play confirmation sound if so

        -- Create new brick layout
        newBricks = LevelMaker.createMap(1)

        gStateMachine:change("serve", { -- Change from start state to serve state
            paddle = Paddle(currentPaddle), -- Enter serve state with selected paddle
            ball = Ball( -- Enter serve state with selected ball
                currentBall, 
                VIRTUAL_WIDTH / 2 - PADDLE_WIDTH / 2 + PADDLE_WIDTH / 2 - BALL_WIDTH / 2, 
                VIRTUAL_HEIGHT - PADDLE_WIDTH / 2 - BALL_HEIGHT),
            bricks = newBricks, -- Enter serve state with generated brick layout
            powerups = loadKeys(newBricks), -- Enter play state with loaded keys
            health = 3, -- Enter serve state with 3 health points
            score = 0, -- Enter serve state with no score
            highscores = self.highscores,-- Enter serve state with current highscores
            level = 1, -- Enter serve state with current highscores
        })
    end

    -- Check if escape was pressed
    if love.keyboard.wasPressed("escape") then

        gSounds.confirm:play() -- Play confirmation sound if so
        gStateMachine:change("start", { -- Change from select state to start state
            highscores = self.highscores, -- Enter start state with current highscores
        })
    end
end

-- Method to render select state
function SelectState:draw()

    -- Display Instructions
    love.graphics.setFont(gFonts.middle)
    love.graphics.printf("Select your ball and paddle", 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, "center") -- Display Instructions
    love.graphics.setFont(gFonts.small)
    love.graphics.printf("Press Space to continue", 0, VIRTUAL_HEIGHT / 4 + 20, VIRTUAL_WIDTH, "center") -- Display instructions to continue
    
    -- Display ball selection
    if self.select == 1 then -- Check if first selection is selected
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255) -- Fully render graphics if so
    else -- Check if first selection is not selected
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255) -- Obscure graphics if so
    end
    love.graphics.draw(gTextures.arrows, gSprites.arrows[1], VIRTUAL_WIDTH / 4 + 40, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3 - 40)
    love.graphics.draw(gTextures.arrows, gSprites.arrows[2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4 - 64, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3 - 40)
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255) -- Fully render ball
    love.graphics.draw(gTextures.main, gSprites.balls[currentBall], VIRTUAL_WIDTH / 2 - BALL_WIDTH / 2, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3 + 12 - BALL_HEIGHT / 2 - 40)

    -- Display paddle selection
    if self.select == 2 then -- Check if second selection is selected
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255) -- Fully render graphics if so
    else -- Check if first selection is not selected
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255) -- Obscure graphics if so
    end
    love.graphics.draw(gTextures.arrows, gSprites.arrows[1], VIRTUAL_WIDTH / 4 + 40, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
    love.graphics.draw(gTextures.arrows, gSprites.arrows[2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4 - 64, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255) -- Fully render paddle
    love.graphics.draw(gTextures.main, gSprites.paddles[2 + 4 * (currentPaddle - 1)], VIRTUAL_WIDTH / 2 - PADDLE_WIDTH / 2, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3 + 12 - PADDLE_HEIGHT / 2)
end
