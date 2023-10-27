-- Start state for breakout game

-- Initialize start state as subclass of base state
StartState = Class{__includes = BaseState}

-- Initialize variables for select menu
local highlighted = 1 -- Keep track of highlighted option
local options = 3 -- Keep track of number of options

-- Method to enter into start state
function StartState:enter(parameters) -- Input parameters from start state

    -- Initialize state with inputed parameters
    self.highscores = parameters.highscores
end

-- Method to aplly behaviour to start state
function StartState:update(dt) -- Input delta time

    -- Handle controller for menu
    if love.keyboard.wasPressed("up") then -- Check if up was pressed

        if highlighted > 1 then -- Check if highlighted is not at minimum if so
            highlighted = highlighted - 1 -- Decrement highlighted if so
        else -- Check if highlighted is at minimum if so
            highlighted = options -- Reverse highlighted if so
        end
        gSounds.paddle_hit:play() -- Play paddle hit sound

    elseif love.keyboard.wasPressed("down") then -- Check if up was pressed

        if highlighted < options then -- Check if highlighted is not at maximum if so
            highlighted = highlighted + 1 -- Increment highlighted if so
        else -- Check if highlighted is at maximum if so
            highlighted = 1 -- Reverse highlighted if so
        end
        gSounds.paddle_hit:play() -- Play paddle hit sound
    end

    -- Handle option input
    if love.keyboard.wasPressed("space") then -- Check if space was pressed and first option is highlighted
        if highlighted == 1 then -- Check if first option is highlighted

            gSounds.confirm:play() -- Play confirmation sound
            gStateMachine:change("select", { -- Change from start state to select state
                highscores = self.highscores, -- Enter select state with current highscores
            })

        elseif highlighted == 2 then -- Check if second option is highlighted
            gSounds.confirm:play() -- Play confirmation sound
            gStateMachine:change("highscore", { -- Change from start state to highscore state
                highscores = self.highscores -- Enter highscore state with current highscores
            })
            
        elseif highlighted == 3 then -- Check if third option is highlighted
            gSounds.confirm:play() -- Play confirmation sound
            love.event.quit() -- Quit game if so
        end
    end

    -- Check if escape was pressed
    if love.keyboard.wasPressed("escape") then
        gSounds.confirm:play() -- Play confirmation sound
        love.event.quit() -- Quit game if so
    end
end

-- Method to render start state
function StartState:draw()

    -- Display title
    love.graphics.setFont(gFonts.large)
    love.graphics.printf("Breakout", 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, "center")

    -- Display select menu
    love.graphics.setFont(gFonts.middle)

    if highlighted == 1 then -- Check if first option is highlighted
        love.graphics.setColor(103/255, 255/255, 255/255, 255/255) -- Focus option if so
    end
    love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 20, VIRTUAL_WIDTH, "center") -- Display option
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255) -- Reset focus

    if highlighted == 2 then -- Check if second option is highlighted
        love.graphics.setColor(103/255, 255/255, 255/255, 255/255) -- Focus option if so
    end
    love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 40, VIRTUAL_WIDTH, "center") -- Display option
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255) -- Reset focus

    if highlighted == 3 then -- Check if third option is highlighted
        love.graphics.setColor(103/255, 255/255, 255/255, 255/255) -- Focus option if so
    end
    love.graphics.printf("QUIT", 0, VIRTUAL_HEIGHT / 2 + 60, VIRTUAL_WIDTH, "center") -- Display option
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255) -- Reset focus
end
