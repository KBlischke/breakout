# Breakout

This is a remake of the game "Breakout" by Atari from 1971. It was implemented with the Löve2D framework in Lua.  

## Dependencies

- [LOVE](https://love2d.org/) (11.0 or higher)  
  - Download from their website includes Lua 5.1  
- [Lua](https://www.lua.org/) (5.0 or higher)  

## Usage

The game can be started in two ways:  

- Navigate with the console inside the directory where the game directory is located and type `love breakout`  
- Execute the file `Breakout.love` located in the game's root directory  
  - This file is an executable implementation of the game and can be moved to and executed from anywhere  

## Gameplay

The goal of the game is the destruction of all bricks displayed on the screen with a ball. This ball damages a brick on contact and destroys it, when enough damage was caused.  

The ball bounces off from every surface, including the screen edges, bricks and the paddle. Every time the paddle bounces off a surface, its speed increases slightly. The paddle sits at the bottom of the screen and can be moved horizontally by the player. When the paddle reached the edge of the screen, it can't be moved further into the direction of the edge.  

When the ball touches the bottom of the screen, the player loses one healthpoint out of three. If a lifepoint is lost, the paddle shrinks and the ball has to be set by the player. If all healthpoints are lost, the game is lost.  

When all bricks on the screen are destroyed, a new level with higher difficulty is automatically generated. The player start this new level or leave the game. When the player loses or leaves the game and has a new high score, a new entry in the high score table can be created. The high score table contains the ten games with the top most scores.  

Some bricks will produce power-ups when they're damaged. These are recognizable as little icons, that move downwards to the bottom of the screen. If the paddle touches them, the power-up takes effect. This effect can be one of the following: giving a healthpoint, producing an additional ball, widening the paddle. When multiple balls are in play, balls will be deleted when they touch the bottom of the screen, without affecting the lifeponts of the player.  

Some bricks are locked and can only be damaged when a brick with a key is destroyed. Locked bricks are recognizable by their grey color and the display of a key on them. Bricks with keys are recognizable by key icons on them.  

## Controls

- **Arrow keys**: menu navigation & paddle movement  
- **Space**: menu selection, confirmation & de- and activating pause  
- **escape**: returning, quitting  
