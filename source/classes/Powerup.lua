-- Powerup class for breakout game

-- Initialize powerup class
Powerup = Class{}

-- Constructor for powerup class
function Powerup:init(mode, x, y, falling)

    -- Setup position of powerup
    self.x = x
    self.y = y

    -- Setup dimensions of powerup
    self.width = POWERUP_WIDTH
    self.height = POWERUP_HEIGHT

    -- Setup velocity of powerup
    self.dx = 0
    self.falling = falling -- Initialize variable to controll velocity

    -- Setup mode of powerup
    self.mode = mode

    -- Setup modes
    self.modes = {
        ["grow"] = 2,
        ["heal"] = 3,
        ["double"] = 9,
        ["key"] = 10
    }
end

-- Method to aplly movement to powerup
function Powerup:update(dt) -- Input delta time

    -- Change velocity according to falling variable
    if self.falling then
        self.dy = 100
    else
        self.dy = 0
    end

    -- Move powerup according to its velocity
    self.y = self.y + self.dy * dt
end

-- Method to render powerup
function Powerup:draw()

    -- Render powerup from powerup table according to skin
    love.graphics.draw(gTextures.main, gSprites.powerups[self.modes[self.mode]], self.x, self.y)
end

-- Method to check if powerup collides with obstacle
function Powerup:collides(obstacle)

    -- Check if powerups right side is bigger then obstacles left side and if powerups left side is smaller then obstacles right side
    if self.x + self.width > obstacle.x and self.x < obstacle.x + obstacle.width then
        
        -- Check if powerups bottom side is bigger then obstacles top side and if powerups topside is smaller then obstacles bottom side
        if self.y + self.height > obstacle.y and self.y < obstacle.y + obstacle.height then

            -- Return true if so
            return true
        end
    end

    -- Return false otherwise
    return false
end
