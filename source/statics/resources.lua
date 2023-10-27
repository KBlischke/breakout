-- Resources for breakout game

-- Initialize state machine
gStateMachine = StateMachine{
    ["start"] = function() return StartState() end, -- Add start state to state machine
    ["select"] = function() return SelectState() end, -- Add select state to state machine
    ["serve"] = function() return ServeState() end, -- Add serve state to state machine
    ["play"] = function() return PlayState() end, -- Add play state to state machine
    ["gameOver"] = function() return GameOverState() end, -- Add game over state to state machine
    ["victory"] = function() return VictoryState() end, -- Add victory state to state machine
    ["enterHighscore"] = function() return EnterHighscoreState() end, -- Add enter highscore state to state machine
    ["highscore"] = function() return HighscoreState() end -- Add highscore state to state machine
}

-- Load textures
gTextures = { -- Initialize table with loaded textures
    ["background"] = love.graphics.newImage("graphics/background.png"), -- Add background texture
    ["main"] = love.graphics.newImage("graphics/main.png"), -- Add main texture
    ["hearts"] = love.graphics.newImage("graphics/hearts.png"), -- Add heart texture
    ["arrows"] = love.graphics.newImage("graphics/arrows.png"), -- Add arrow texture
    ["particle"] = love.graphics.newImage("graphics/particle.png") -- Add particle texture
}

-- Load sprites
gSprites = { -- Initialize table with loaded sprites
    ["paddles"] = generateQuadPaddles(gTextures.main), -- Add paddle sprites
    ["balls"] = generateQuadBalls(gTextures.main), -- Add ball sprites
    ["bricks"] = generateQuadBricks(gTextures.main), -- Add brick sprites
    ["powerups"] = generateQuadPowerups(gTextures.main), -- Add powerup sprites
    ["hearts"] = generateQuads(gTextures.hearts, 10, 9), -- Add heart sprites
    ["arrows"] = generateQuads(gTextures.arrows, 24, 24) -- Add arrow sprites
}

-- Load sounds
gSounds = { -- Initialize table with loaded sounds
    ["paddle_hit"] = love.audio.newSource("sounds/paddle_hit.wav", "static"), -- Add paddle hit sound
    ["wall_hit"] = love.audio.newSource("sounds/wall_hit.wav", "static"), -- Add wall hit sound
    ["brick_hit_1"] = love.audio.newSource("sounds/brick_hit_1.wav", "static"), -- Add second brick hit sound
    ["brick_hit_2"] = love.audio.newSource("sounds/brick_hit_2.wav", "static"), -- Add second brick hit sound
    ["metal_hit"] = love.audio.newSource("sounds/metal_hit.wav", "static"), -- Add smetal hit sound
    ["hurt"] = love.audio.newSource("sounds/hurt.wav", "static"), -- Add hurt sound
    ["power"] = love.audio.newSource("sounds/power.wav", "static"), -- Add power sound
    ["pause"] = love.audio.newSource("sounds/pause.wav", "static"), -- Add pause sound
    ["victory"] = love.audio.newSource("sounds/victory.wav", "static"), -- Add victory sound
    ["select"] = love.audio.newSource("sounds/select.wav", "static"), -- Add select sound
    ["confirm"] = love.audio.newSource("sounds/confirm.wav", "static"), -- Add confirmation sound
    ["highscore"] = love.audio.newSource("sounds/highscore.wav", "static") -- Add confirmation sound
}

-- Load Music
gMusic = { -- Initialize table with loaded music tracks
    ["background"] = love.audio.newSource("music/background.wav", "stream") -- Add background music
}

-- Load new fonts
gFonts = {
    ["small"] = love.graphics.newFont("fonts/font.ttf", 8), -- Add small font
    ["middle"] = love.graphics.newFont("fonts/font.ttf", 16), -- Add middle font
    ["large"] = love.graphics.newFont("fonts/font.ttf", 32) -- Add large font
}
