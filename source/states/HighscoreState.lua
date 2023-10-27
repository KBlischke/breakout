-- Highscore state for breakout game

-- Initialize highscore state as subclass of base state
HighscoreState = Class{__includes = BaseState}

-- Method to enter into highscore state
function HighscoreState:enter(parameters) -- Input parameters from start state
    self.highscores = parameters.highscores
end

-- Method to aplly behaviour to highscore state
function HighscoreState:update(dt) -- Input delta time

    if love.keyboard.wasPressed("space") or love.keyboard.wasPressed("escape") then -- Check if space or escape was pressed

        gSounds.confirm:play() -- Play confirmation sound
        gStateMachine:change("start", { -- Change from highscore state to start state
            highscores = self.highscores -- Enter start state with dhighscores of highscore state
        })
    end
end

-- Method to render highscore state
function HighscoreState:draw()

    love.graphics.setFont(gFonts.large)
    love.graphics.printf("High Scores", 0, 20, VIRTUAL_WIDTH, "center") -- Display highscore title

    love.graphics.setFont(gFonts.middle)

    -- Iterate over all highscores in highscore table
    for i = 1, 10, 1 do
        local name = self.highscores[i].name or "---"
        local score = self.highscores[i].score or "---"

        -- Highscore ranks from 1 to 10
        love.graphics.printf(tostring(i) .. ".", VIRTUAL_WIDTH / 4, 60 + i * 13, 50, "left") -- Display rank

        -- Highscore names
        love.graphics.printf(name, VIRTUAL_WIDTH / 4 + 38, 60 + i * 13, 50, "right") -- Display name
        
        -- Highscore values
        love.graphics.printf(tostring(score), VIRTUAL_WIDTH / 2, 60 + i * 13, 100, "right")
    end

    love.graphics.setFont(gFonts.small)
    love.graphics.printf("Press Space or Escape to return to the main menu", 0, VIRTUAL_HEIGHT - 18, VIRTUAL_WIDTH, "center") -- Display instructions to return
end
