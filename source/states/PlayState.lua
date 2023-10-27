-- Play state for breakout game

-- Initialize play state as subclass of base state
PlayState = Class{__includes = BaseState}

-- Method to enter into serve state
function PlayState:enter(parameters) -- Input parameters from serve state

    -- Initialize state with inputed parameters
    self.paddle = parameters.paddle
    self.ball = parameters.ball
    self.bricks = parameters.bricks
    self.powerups = parameters.powerups
    self.health = parameters.health
    self.score = parameters.score
    self.highscores = parameters.highscores
    self.level = parameters.level

    -- Give ball starting velocity
    self.ball.dx = 0
    self.ball.dy = -150

    -- Initialize table for multiple bals
    self.balls = {
        self.ball
    }

    -- Initialize variable to controll pausing
    self.paused = false
end

-- Method for applying behaviour to play state
function PlayState:update(dt)

    -- Handle pausing
    if not self.paused and love.keyboard.wasPressed("space") then -- Check if space was pressed and game is not paused
        self.paused = true -- Activate pause if so
        gSounds.pause:play() -- Play pause sound if so
    elseif self.paused and love.keyboard.wasPressed("space") then -- Check if space was pressed and game is paused
        self.paused = false -- Deativate pause if so
        gSounds.pause:play() -- Play pause sound if so
    end

    -- Execute if pause is disabled
    if not self.paused then

        -- Apply movement to player
        self.paddle:update(dt)

        -- Apply behaviour to balls in balls table
        for i = #self.balls, 1, -1 do

            -- Apply movement to balls in balls table
            self.balls[i]:update(dt)

            -- Check for collision between paddle and ball
            if self.balls[i]:collides(self.paddle) then

                self.balls[i].dy = -self.balls[i].dy -- Invert vertical movement of ball
                self.balls[i].y = self.paddle.y - self.balls[i].height -- Reset balls y-position unto paddle

                -- Change angle of ball bouncing according to paddle
                if self.paddle.dx < 0 then -- Check if paddle hits ball while moving left
                    self.balls[i].dx = -(4.5 * (self.paddle.x + self.paddle.width - self.balls[i].x))
                elseif self.paddle.dx > 0 then -- Check if paddle hits ball while moving right
                    self.balls[i].dx = 4.5 * math.abs(self.paddle.x - self.balls[i].x)
                elseif self.balls[i].x < self.paddle.x + self.paddle.width / 2 then -- Check if ball hits left side of paddle
                    self.balls[i].dx = -(4 * (self.paddle.x + self.paddle.width / 2 - self.balls[i].x))
                elseif self.balls[i].x > self.paddle.x + self.paddle.width / 2 then -- Check if ball hits right side of paddle
                    self.balls[i].dx = 4 * math.abs(self.paddle.x + self.paddle.width / 2 - self.balls[i].x)
                end

                gSounds.paddle_hit:play() -- Play paddle hit sound
            end

            -- Check if ball hits bottom of screen
            if self.balls[i].y >= VIRTUAL_HEIGHT and #self.balls == 1 then
                self.health = self.health - 1 -- Decrement health if so
                gSounds.hurt:play() -- Play hurt sound if so

                -- Check if health is 0
                if self.health == 0 then
                    gStateMachine:change("gameOver", { -- Change from play state to game over state
                        score = self.score, -- Enter game over state with no score
                        highscores = self.highscores -- Enter game over state with current highscores
                    })

                -- Check if health is not 0
                else

                    if self.paddle.size == 3 then -- Check if paddle is grown
                        self.paddle.size = 2 -- Shrink size of paddle sprite
                        self.paddle.width = self.paddle.width - PADDLE_WIDTH / 2 -- Shrink size of paddle width
                    end

                    gStateMachine:change("serve", { -- Change from play state to serve state
                        paddle = self.paddle, -- Enter serve state with current paddle
                        ball = self.ball, -- Enter serve state with current ball
                        bricks = self.bricks, -- Enter serve state with current brick layout
                        powerups = self.powerups, -- Enter serve state with current powerups
                        health = self.health, -- Enter serve state with current health points
                        score = self.score, -- Enter serve state with current score
                        highscores = self.highscores, -- Enter serve state with current highscores
                        level = self.level, -- Enter serve state with current level
                    })
                end
            elseif self.balls[i].y >= VIRTUAL_HEIGHT and #self.balls > 1 then
                table.remove(self.balls, i) -- Delete ball
            end
        end

        -- Apply interaction between bricks in bricks table and balls in balls table
        for j, brick in pairs(self.bricks) do

            -- Check for activation of particles of bricks in bricks table
            brick:update(dt)

            -- Check for collision between bricks and ball
            for k = #self.balls, 1, -1 do

                if not brick.destroyed and self.balls[k]:collides(brick) then -- Check if brick is not destroyed and gets hit by ball

                    -- Check from which side brick is hit
                    if self.balls[k].x + 2 < brick.x and self.balls[k].dx > 0 then -- Check if ball hits left side of brick
                        self.balls[k].x = brick.x - self.balls[k].width -- Reset balls position unto left side of brick
                        self.balls[k].dx = -self.balls[k].dx -- Invert x-movement of ball
                    elseif self.balls[k].x + 6 > brick.x + brick.width and self.balls[k].dx < 0 then -- Check if ball hits right side of brick
                        self.balls[k].x = brick.x + brick.width -- Reset balls position unto right side of brick
                        self.balls[k].dx = -self.balls[k].dx -- Invert x-movement of ball
                    elseif self.balls[k].y + self.balls[k].width / 2 < brick.y then -- Check if ball hits top side of brick
                        self.balls[k].y = brick.y - self.balls[k].height -- Reset balls position unto top side of brick
                        self.balls[k].dy = -self.balls[k].dy -- Invert y-movement of ball
                    else  -- Check if ball hits bottom side of brick
                        self.balls[k].y = brick.y + brick.height -- Reset balls position unto top side of brick
                        self.balls[k].dy = -self.balls[k].dy -- Invert y-movement of ball
                    end

                    -- Slightly scale balls movement by every hit
                    self.balls[k].dy = self.balls[k].dy * MOMENTUM

                    if brick.lockBrick then -- Check if brick needs key
                        gSounds.metal_hit:play() -- Play metal hit sound
                        if not brick.locked then -- Check if brick is not locked
                            brick.lockBrick = false -- Display brick as normal brick
                            self.score = self.score + 250 -- Update score according to its status as locked brick
                        end

                    else -- Check if key does not need key
                        self.score = self.score + (brick.tier * 25 + brick.color * 5) -- Update score according to its color and tier if so
                        
                        brick:hit() -- Damage brick if so

                        -- Spawn powerups from hit bricks
                        powerupSpawner = math.random(1, 100) -- Randomly spawn powerups
                        spawnedPowerup = math.random(1, 10) -- Randomly select powerup
                        if powerupSpawner <= 5 and spawnedPowerup <= 5 then -- Create healpowerup
                            table.insert(self.powerups, Powerup("heal", brick.x + brick.width / 2 - POWERUP_WIDTH / 2, brick.y, true))
                        elseif powerupSpawner <= 5 and spawnedPowerup > 5 and spawnedPowerup <= 8 then -- Create doubling powerup
                            table.insert(self.powerups, Powerup("double", brick.x + brick.width / 2 - POWERUP_WIDTH / 2, brick.y, true))
                        elseif powerupSpawner <= 5 and spawnedPowerup > 8 then -- Create growing powerup
                            table.insert(self.powerups, Powerup("grow", brick.x + brick.width / 2 - POWERUP_WIDTH / 2, brick.y, true))    
                        end

                        -- Check if every brick is destroyed
                        if checkVictory(self.bricks) then

                            gSounds.victory:play() -- Play victory sound

                            gStateMachine:change("victory", { -- Change from play state to victory state
                                paddle = self.paddle, -- Enter victory state with paddle of play state
                                ball = self.ball, -- Enter victory state with ball of play state
                                health = self.health, -- Enter victory state with health of play state
                                score = self.score, -- Enter victory state with score of play state
                                highscores = self.highscores, -- Enter victory state with highscores of play state
                                level = self.level, -- Enter victory state with level of play state
                            })
                        end
                    end

                    -- Only check colliding with one brick
                    break
                end
            end

            -- Make key powerups collectable
            for l = #self.powerups, 1, -1 do -- Iterate through bricks of bricks table

                if self.powerups[l].mode == "key" and self.powerups[l]:collides(brick) and brick.destroyed  then -- Check if powerup is key and collides with brick
                    table.remove(self.powerups, l) -- Remove powerup from powerups table if so
                    for z, brick in pairs(self.bricks) do
                        if brick.lockBrick then -- Check for bricks with locks
                            brick.locked = false -- Unlock bricks if so
                        end
                    end
                    gSounds.power:play() -- Play power sound if so
                end
            end
        end

        -- Apply behaviour to powerups
        for l = #self.powerups, 1, -1 do -- Iterate through powerups in powerups table

            -- Apply movement to powerups in powerups table
            self.powerups[l]:update(dt)

            -- Make powerups collectable
            if self.powerups[l]:collides(self.paddle) then -- Check if powerup collides with paddle

                if self.powerups[l].mode == "heal" and self.health < 3 then -- Check if powerup is healing
                    table.remove(self.powerups, l) -- Remove powerup from powerups table
                    self.health = self.health + 1 -- Recover health
                    gSounds.power:play() -- Play power sound
                
                elseif self.powerups[l].mode == "grow" and self.paddle.size == 2 then -- Check if powerup is growing
                    table.remove(self.powerups, l) -- Remove powerup from powerups table
                    self.paddle.size = 3 -- Grow size of paddle sprite
                    self.paddle.width = self.paddle.width + PADDLE_WIDTH / 2 -- Grow size of paddle width
                    gSounds.power:play() -- Play power sound

                elseif self.powerups[l].mode == "double" then -- Check if powerup is doubling
                    table.remove(self.powerups, l) -- Remove powerup from powerups table
                    table.insert(self.balls, Ball( -- Insert new ball to balls table
                        self.ball.skin, 
                        self.paddle.x  + self.paddle.width / 2,
                        self.paddle.y - BALL_HEIGHT
                    ))
                    self.balls[#self.balls].dy = -150 -- Set vertical velocity of new ball
                    gSounds.power:play() -- Play power sound
                end
            end
        end
    end

    -- Leave play state
    if love.keyboard.wasPressed("escape") then -- Check if escape was pressed

        -- Set flag for checking of new highscore
        local highscore = false
        
        -- Keep track of ordered index of score inside highscores
        local scoreIndex = 11

        -- Iterate through highscores
        for n = 10, 1, -1 do
            if self.score > self.highscores[n].score then -- Check if highscore at index is smaller than current score
                self.scoreIndex = n -- Set index of score to current index of highscores
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

-- Method to render play state
function PlayState:draw()

    -- Render player paddle
    self.paddle:draw()

    -- Render balls in balls table
    for o = #self.balls, 1, -1 do
        self.balls[o]:draw()
    end

    -- Render bricks and its particles in bricks table
    for p, brick in pairs(self.bricks) do
        brick:draw() 
        brick:renderParticles()
    end

    -- Render all powerups in powerups table
    for q = #self.powerups, 1, -1 do
        self.powerups[q]:draw(dt)
    end

    -- Render score
    renderScore(self.score)

    -- Render health
    renderHealth(self.health)

    -- Render level
    renderLevel(self.level)

    -- Display pause if paused
    if self.paused then
        love.graphics.setFont(gFonts.large)
        love.graphics.printf("Pause", 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, "center") -- Display pause

        love.graphics.setFont(gFonts.middle)
        love.graphics.printf("Press Space to continue", 0, VIRTUAL_HEIGHT / 4 + 40, VIRTUAL_WIDTH, "center") -- Display instruction for continuing
        love.graphics.printf("Press Escape to quit", 0, VIRTUAL_HEIGHT / 4 + 60, VIRTUAL_WIDTH, "center") -- Display instruction for quitting
     end
end
