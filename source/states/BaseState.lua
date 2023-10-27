-- Blueprint for states in breakout game

-- Initialize base state
BaseState = Class{}

-- Initialize blueprint methods for states
function BaseState:enter() end -- Method for entering state
function BaseState:init() end -- Method for construction
function BaseState:update(dt) end -- Method for applying behaviour
function BaseState:draw() end -- Method for rendering
function BaseState:exit() end -- Method for exiting state
