-----------------------------------------------------------------------------------------
--
-- level3.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )


local objectX = 0
local jumped = false
local died = false

local sceneNumber = "1"

local function endfunction()
	timer.pause(gameLoopTimer)
	if died == false then
	timer.performWithDelay(1000, function()composer.gotoScene("level4")end)
	else
	objectX = 0 
	composer.setVariable("SceneNumber", sceneNumber)
	
	timer.performWithDelay(1000, function() composer.gotoScene("menu") end)
	end
end







--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.setGravity(0,5)
	physics.pause()
	
	local background = display.newImageRect("sky.jpeg", 2000, 1000)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local block = display.newImageRect("Block.png", 2000, 200)
	block.x = 1000
	block.y = display.contentHeight - 100
	block.myName = "Floor"

	 block1 = display.newImageRect("Block.png", 100, 100)
	block1Initial = 1000
	block1.x = block2Initial
	block1.y = display.contentHeight - 240
	block1.myName = "Small Block"

	 block2 = display.newImageRect("Block.png", 100, 100)
	block2Initial = 1800
	block2.x = block2Initial
	block2.y = display.contentHeight - 240
	block2.myName = "Small Block"

	 block3 = display.newImageRect("Block.png", 100, 100)
	block3Initial = 3200
	block3.x = block3Initial
	block3.y = display.contentHeight - 325
	block3.myName = "Small Block"

	 block4 = display.newImageRect("Block.png", 100, 100)
	block4Initial = 3800
	block4.x = block4Initial
	block4.y = display.contentHeight - 325
	block4.myName = "Small Block"


	 block7 = display.newImageRect("Block.png", 200, 200)
	block7Initial = 2300
	block7.x = block7Initial
	block7.y = display.contentHeight - 280
	block7.myName = "Large Block"


	 block8 = display.newImageRect("Block.png", 200, 200)
	block8Initial = 2700
	block8.x = block8Initial
	block8.y = display.contentHeight - 280
	block8.myName = "Large Block"

	 block9 = display.newImageRect("Block.png", 600, 100)
	block9Initial = 3850
	block9.x = block9Initial
	block9.y = display.contentHeight - 325
	block9.myName = "Long Block"

	 circle = display.newImageRect("Angry Circle.png", 72, 72)
	circle.x = display.contentCenterX
	circle.y = display.contentCenterY




	--Body defining
		--FLoor
	physics.addBody(block, "static", {box = 1000, 100, 0, 0, 0})
		--Obstacles
			--small blocks
	physics.addBody(block1, "static", {box = 50, 50, 0, 0, 0})
	physics.addBody(block2, "static", {box = 50, 50, 0, 0, 0})
	physics.addBody(block3, "static", {box = 50, 50, 0, 0, 0})
	physics.addBody(block4, "static", {box = 50, 50, 0, 0, 0})
			--large blocks
	physics.addBody(block7, "static", {box = 99, 99, 0, 0,0})
	physics.addBody(block8, "static", {box = 99, 99, 0, 0,0})
			-- Special Blocks
	physics.addBody(block9, "static", {box = 300, 50, 0, 0, 0})
		--Player
	physics.addBody(circle, "dynamic", {radius = 36})

	
		-- all display objects must be inserted into group
		sceneGroup:insert(background)
		sceneGroup:insert(block)
		sceneGroup:insert(block1)
		sceneGroup:insert(block2)
		sceneGroup:insert(block3)
		sceneGroup:insert(block4)
		sceneGroup:insert(block7)
		sceneGroup:insert(block8)
		sceneGroup:insert(block9)
		sceneGroup:insert(circle)
		
	test = ""
	testText = display.newText(test, display.contentCenterX, 100, native.systemFont, 44)
	
	sceneGroup:insert(testText)

	end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		
		
		local function gameLoop()
			objectX = objectX - 4

			block1.x = objectX + block1Initial
			block2.x = objectX + block2Initial
			block3.x = objectX + block3Initial
			block4.x = objectX + block4Initial
		
			block7.x = objectX + block7Initial
			block8.x = objectX + block8Initial
			block9.x = objectX + block9Initial
	
			if jumped == false then
			circle:applyLinearImpulse(0, .00001)
			circle:applyTorque(.01)
			end

			if objectX < -4000 then
			died = false
			endfunction()
			testText.text = "You Won! Next Level;"
			end
			if circle.x < -20 then
			died = true
			endfunction()
			testText.text = "You Died. Restarting;"
			end
		end
		
		
		gameLoopTimer = timer.performWithDelay(10, gameLoop, 0)
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	display.remove(circle)
	display.remove(block)
	display.remove(block1)
	display.remove(block2)
	display.remove(block3)
	display.remove(block4)
	display.remove(block7)
	display.remove(block8)
	display.remove(block9)
	
	timer.remove(gameLoopTimer)
	
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene