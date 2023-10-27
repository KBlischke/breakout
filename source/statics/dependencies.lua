-- Dependencies for breakout game

-- Required libraries for program
Class = require "libraries.class" -- Get class functionality
push = require "libraries.push" -- Handle resolution scaling

-- Required states for program
require "source.states.StateMachine" -- Get state machine for state handling
require "source.states.BaseState" -- Get template for game states
require "source.states.StartState" -- Get start state for game start
require "source.states.SelectState" -- Get select state for selecting paddle and ball
require "source.states.ServeState" -- Get serve state for game initialization
require "source.states.PlayState" -- Get play state for playing game
require "source.states.GameOverState" -- Get game over state for handling loosing
require "source.states.VictoryState" -- Get victory state for handling winning
require "source.states.EnterHighscoreState" -- Get enter highscore state for entering scores
require "source.states.HighscoreState" -- Get highscore state for displaying scores

-- Required helpers for program
require "source.helpers.functions" -- Get helper functions
require "source.helpers.QuadMaker" -- Get quad maker class for generating sprites
require "source.helpers.LevelMaker" -- Get level maker class for generating bricks

-- Required statics for program
require "source.statics.constants" -- Get global constants
require "source.statics.resources" -- Get global resources
require "source.statics.colorPalette" -- Get global color palette

-- Required classes for program
require "source.classes.Paddle" -- Get paddle class
require "source.classes.Ball" -- Get ball class
require "source.classes.Brick" -- Get brick class
require "source.classes.Powerup" -- Get powerup class
