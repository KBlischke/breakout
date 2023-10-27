-- Brick class for breakout game

-- Initialize brick class
Brick = Class{}

-- Constructor for brick class
function Brick:init(x, y)

    -- Setup position of brick
    self.x = x
    self.y = y

    -- Setup dimensions of brick
    self.width = BRICK_WIDTH
    self.height = BRICK_HEIGHT

    -- Setup color of brick
    self.color = 1

    -- Setup tier of brick
    self.tier = 0

    -- Setup status of brick
    self.destroyed = false

    -- Setup locked brick
    self.lockBrick = false
    self.locked = true

    -- Setup particle system for brick
    self.particles = love.graphics.newParticleSystem(gTextures.particle, 20) -- Initialize particles
    self.particles:setParticleLifetime(0.5, 1) -- Initialize lifetime of particles
    self.particles:setLinearAcceleration(-15, 0, 15, 80) -- Initialze spawn area of particles
    self.particles:setEmissionArea("normal", 10, 5) -- Initialize movement of particles
end

-- Method to execute if brick gets hit
function Brick:hit()

    -- Set color of particles of brick according to its color
    self.particles:setColors(
        gColorPalette[self.color].r, 
        gColorPalette[self.color].g, 
        gColorPalette[self.color].b, 
        10 * (self.tier + 1),
        gColorPalette[self.color].r, 
        gColorPalette[self.color].g, 
        gColorPalette[self.color].b, 
        0
    )

    -- Activate particles of brick
    self.particles:emit(20)

    gSounds.brick_hit_2:stop() -- Stop playing second brick hit sound
    gSounds.brick_hit_2:play() -- Play second brick hit sound

    -- Reduce brick
    if self.tier > 0 then -- Check if tier of brick is bigger than 0

        if self.color == 1 then -- Check if color of brick is base color if so
            self.tier = self.tier - 1 -- Decrement tier of brick if so
            self.color = 5 -- Update color of brick to highest color
        else -- Check if tier of brick is 0 if so
            self.color = self.color - 1 -- Decrement color of brick if so
        end

    else -- Check if tier of brick is 0
        
        if self.color == 1 then -- Check if color of brick is base color if so
            self.destroyed = true -- Set brick to destroyed if so
            gSounds.brick_hit_1:stop() -- Stop playing first brick hit sound
            gSounds.brick_hit_1:play() -- Play first brick hit sound
        else -- Check if tier of brick is bigger than 0 if so
            self.color = self.color - 1 -- Decrement color of brick if so
        end
    end
end

function Brick:update(dt)
    self.particles:update(dt)
end

-- Method to render brick
function Brick:draw()

    -- Check if brick is not destroyed
    if not self.destroyed and self.lockBrick then
        love.graphics.draw(gTextures.main, gSprites.bricks[self.locked and 24 or 21], self.x, self.y) -- Render locked brick from table
    elseif not self.destroyed then
        love.graphics.draw(gTextures.main, gSprites.bricks[1 + ((self.color - 1) * 4) + self.tier], self.x, self.y) -- Render brick from table according to color and tier
    end
end

function Brick:renderParticles()
    love.graphics.draw(self.particles, self.x + self.width / 2, self.y + self.height / 2)
end
