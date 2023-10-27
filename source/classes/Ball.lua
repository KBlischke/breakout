-- Ball class for breakout game

-- Initialize ball class
Ball = Class{}

-- Initialize dimensions for ball class
ballWidth = 8
ballHeight = 8

-- Constructor for ball class
function Ball:init(skin, x, y)

    -- Setup position of ball
    self.x = x
    self.y = y

    -- Setup dimensions of ball
    self.width = ballWidth
    self.height = ballHeight

    -- Setup velocity of ball
    self.dx = 0
    self.dy = 0

    -- Setup skin of ball
    self.skin = skin
end

-- Method to aplly movement to ball
function Ball:update(dt) -- Input delta time

    -- Move ball according to its velocity
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- Apply bouncing of from walls to ball
    if self.x <= 0 then -- Check if ball hits left wall
        self.x = 0 -- Reset balls x-position unto wall if so
        self.dx = -self.dx -- Invert balls horizontal movement if so
        gSounds.wall_hit:play() -- Play wall hit
    elseif self.x >= VIRTUAL_WIDTH- 8 then -- Check if ball hits right wall
        self.x = VIRTUAL_WIDTH - 8 -- Reset balls x-position unto wall if so
        self.dx = -self.dx -- Invert balls horizontal movement if so
        gSounds.wall_hit:play() -- Play wall hit
    elseif self.y <= 0 then -- Check if ball hits topt wall
        self.y = 0 -- Reset balls x-position unto wall if so
        self.dy = -self.dy -- Invert balls vertical movement if so
        gSounds.wall_hit:play() -- Play wall hit
    end
end

-- Method to render ball
function Ball:draw()

    -- Render ball from ball table according to skin
    love.graphics.draw(gTextures.main, gSprites.balls[self.skin], self.x, self.y)
end

-- Method to check if ball collides with obstacle
function Ball:collides(obstacle)

    -- Check if balls right side is bigger then obstacles left side and if balls left side is smaller then obstacles right side
    if self.x + self.width >= obstacle.x and self.x <= obstacle.x + obstacle.width then
        
        -- Check if balls bottom side is bigger then obstacles top side and if balls topside is smaller then obstacles bottom side
        if self.y + self.height >= obstacle.y and self.y <= obstacle.y + obstacle.height then

            -- Return true if so
            return true
        end
    end

    -- Return false otherwise
    return false
end

-- Method to reset ball
function Ball:reset()

    -- Reset position of ball
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2

    -- Reset velocity of ball
    self.dx = 0
    self.dy = 0
end
