-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------


-- include the Corona "composer" module
local composer = require "composer"
local scene = composer.newScene()

local background = display.newImageRect("Block.png", 1000, 1000)

local sceneNumber = composer.getVariable("SceneNumber")

timer.performWithDelay(1000, function()composer.gotoScene("level"..sceneNumber)end)

