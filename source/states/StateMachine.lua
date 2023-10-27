-- State machine for breakout game

-- Initialize state machine
StateMachine = Class{}

-- Constructor for state machine
function StateMachine:init(states) -- Input states of stae machine

    -- Set empty functions as placeholder
    self.empty = {
        draw = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }

    -- Handle inputed states
    self.states = states or {} -- Store states
    self.current = self.empty -- Display current state
end

-- Method to change current state of state machine
function StateMachine:change(state, parameters) -- Input state and parameters for it
    assert(self.states[state]) -- Check if state exists
    self.current:exit() -- Call exit method of current state
    self.current = self.states[state]() -- Set inputed state to current state
    self.current:enter(parameters) -- Call enter method of inputed state with inputed parameters
end

-- Method to aplly behaviour to current state
function StateMachine:update(dt) -- Input delta time
    self.current:update(dt)
end

-- Method to render current state
function StateMachine:draw()
    self.current:draw()
end
