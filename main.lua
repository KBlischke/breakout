-- Main file for breakout game

-- Load content to game
function love.load()

    -- Setup window of breakout game
    love.window.setTitle("Breakout") -- Setup title
    love.window.setIcon(love.image.newImageData("graphics/icon.png")) -- Setup icon

    -- Generate always changing seed for RNG
    math.randomseed(os.time())

    -- Set default filter to make pixels instead of blurr by minimizing and magnifying objects
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Required modules for program
    require "source.statics.dependencies"

    -- Set dimensions of window
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { -- Create virtual window to upscale to normal window dimensions
        fullscreen = false, -- Activate fullscreen
        resizable = true, -- Disable resizability of wondow
        vsync = true -- Enable v-sync for game
    })
    love.window.maximize() -- Maximize window

    -- Initialize empty table to check for pressed keys
    love.keyboard.keysPressed = {}

    -- Activate start state
    gStateMachine:change("start", {
        highscores = loadHighscores() -- Enter start state with loaded highscores
    })

    -- Play background music on loop
    gMusic.background:play()
    gMusic.background:setLooping(true)
    mute = false
end

-- Update game 
function love.update(dt) -- Input delta time

    -- Apply behaviour for current state
    gStateMachine:update(dt)

    -- Handle music muting
    if love.keyboard.wasPressed("m") and not mute then
        gMusic.background:pause()
        mute = true
    elseif love.keyboard.wasPressed("m") and mute then
        gMusic.background:play()
        mute = false
    end

    -- Reset table for checking of pressed keys
    love.keyboard.keysPressed = {}
end

-- Render content to screen
function love.draw()

    -- Apply virtual window scaling
    push:start()

    -- Render background for game
    love.graphics.draw(
        gTextures.background, -- Select background
        0, 0, -- Place at corner of screen
        0, -- No rotation
        VIRTUAL_WIDTH / (gTextures.background:getWidth() - 1), -- Scale according to screen on x
        VIRTUAL_HEIGHT / (gTextures.background:getHeight() - 1) -- Scale according to screen on y
    )

    -- Render content of current state
    gStateMachine:draw()

    -- Render current FPS
    renderFPS()

    -- End virtual window scaling
    push:finish()
end
