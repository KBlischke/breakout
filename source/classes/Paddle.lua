-- Paddle class for breakout game

-- Initialize paddle class
Paddle = Class{}

-- Constructor for paddle class
function Paddle:init(skin)

    -- Setup position of paddle
    self.x = VIRTUAL_WIDTH / 2 - PADDLE_WIDTH / 2
    self.y = VIRTUAL_HEIGHT - PADDLE_WIDTH / 2

    -- Setup dimensions of paddle
    self.width = PADDLE_WIDTH
    self.height = PADDLE_HEIGHT

    -- Setup velocity of paddle
    self.dx = 0

    -- Setup skin of paddle
    self.skin = skin

    -- Setup size of paddle
    self.size = 2
end

-- Method to aplly movement to paddle
function Paddle:update(dt) -- Input delta time

    -- Move paddle according to key input
    if love.keyboard.isDown("left") then -- Check if left was pressed
        self.dx = -PADDLE_SPEED -- Move paddle to the left if so
    elseif love.keyboard.isDown("right") then -- Check if right was pressed
        self.dx = PADDLE_SPEED -- Move paddle to the right if so
    else -- Check if no key was pressed
        self.dx = 0 -- Stop moving of paddle if so
    end

    -- Apply borders to paddle
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt) -- Change position of paddle according to speed scaled by delta time and limited by window
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt) -- Change position of paddle according to speed scaled by delta time and limited by window
    end
end

-- Method to render paddle
function Paddle:draw()

    -- Render paddle from paddle table according to skin and size
    love.graphics.draw(gTextures.main, gSprites.paddles[self.size + 4 * (self.skin - 1)], self.x, self.y)
end
