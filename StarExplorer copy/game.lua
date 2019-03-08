
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require("physics")
physics.start()
physics.setGravity(0,0)
 
local sheetOptions=
{
                frames =
                {
                                {-- astroid 1
                                x =0,
                                y=0,
                                width =102,
                                height =85
                                },
                                {--astroid 2
                                x=0,
                                y=85,
                                width=90,
                                height=83
                                },
                                {--astroid 3
                                x = 0,
                                y = 168,
                                width = 100,
                                height = 97
                                },
                                {--ship
                                x=0,
                                y=265,
                                width=98,
                                height= 79
                                },
                                {--laser
                                x=98,
                                y=265,
                                width =14,
                                height =40
                                },
                },
}
local objectSheet = graphics.newImageSheet("gameObjects.png", sheetOptions)

local lives = 3
local score = 0
local died = false
 
local astroidsTable ={}
 
local ship
local gameLoopTimmer
local livesText
local scoreText

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()
 
 
local function updateText()
                livesText.text = "Lives:"..lives
                scoreText.text = "Score:"..score
                end
local function createAstroid()
 
                local newAstroid = display.newImageRect(mainGroup, objectSheet, 1, 102, 85)
                table.insert(astroidsTable, newAstroid)
                physics.addBody(newAstroid, "dynamic", {radius=40,bounce=0.8})
                newAstroid.myName = "astroid"
               
                local wherefrom = math.random(3)
               
                if (wherefrom == 1) then
                                newAstroid.x= -60
                                newAstroid.y = math.random(500)
                                newAstroid:setLinearVelocity(math.random(40,120), math.random(20,60))
                elseif (wherefrom == 2) then
                                newAstroid.x = math.random(display.contentWidth)
                                newAstroid.y = -60
                                newAstroid:setLinearVelocity(math.random(-40,40), math.random(40,120))
                else
                                newAstroid.x = display.contentWidth + 60
                                newAstroid.y = math.random(500)
                                newAstroid:setLinearVelocity(math.random(-120,-40), math.random(20,60))
                end
                newAstroid:applyTorque(math.random(-10,6))
end
 
 
local function fireLaser()
 
                local newLaser = display.newImageRect(mainGroup, objectSheet, 5,14,40)
                physics.addBody(newLaser,"dynamic",{isSensor = true})
                newLaser.isBullet = true
                newLaser.myName = "laser"
                newLaser.x = ship.x
                newLaser.y = ship.y
                newLaser:toBack()
               
                transition.to(newLaser, {y=-40,time =500,
                                onComplete = function() display.remove(newLaser) end})
               
end

function dragShip(event)
               
                local ship = event.target
                local phase= event.phase
               
                if ("began" == phase) then
                                display.currentStage:setFocus(ship)
                                ship.touchOffsetX = event.x - ship.x
               
                elseif ("moved" == phase) then
                                ship.x = event.x-ship.touchOffsetX
                               
                elseif ("ended" == phase or "canceled" == phase) then
                                display.currentStage:setFocus(nil)
                end
                return true
end

local function gameLoop()
 
                createAstroid()
                for i = #astroidsTable,1,-1 do
                local thisAstroid = astroidsTable[i]
               
                if (thisAstroid.x < -100 or thisAstroid.x > display.contentWidth + 100 
                or thisAstroid.y < -100 or thisAstroid.y > display.contentHeight + 100)
                then
                	display.remove(thisAsteroid)
                	table.remove(astroidsTable, i)
                end
        end
end

local function restoreShip()

	ship.isBodyActive = false
	ship.x = display.contentCenterX
	ship.y = display.contentHeight - 100
	
	transition.to(ship, {alpha=1, time = 4000, 
	onComplete = function() ship.isBodyActive = true died = false 
	end})
end

local function endGame()
	composer.gotoScene("menu", {time = 800, effect = "crossFade"})
end


local function onCollision(event)
	
	if event.phase == "began" then
	local obj1 = event.object1
	local obj2 = event.object2
	
	
		if (obj1.myName == "laser" and obj2.myName == "astroid") 
		or (obj1.myName == "astroid" and obj2.myName == "laser")
		then
	
		display.remove(obj1)
		display.remove(obj2)
		
		for i = #astroidsTable, 1, -1 do
				if (astroidsTable[i] == obj1 or astroidsTable[i] == obj2)
				then
				table.remove(astroidsTable, i)
				break
				end
			end
		
			score = score + 100
			scoreText.text = "Score:"..score
		
		elseif (obj1.myName == "ship" and obj2.myName == "astroid") 
		or (obj1.myName == "astroid" and obj2.myName == "ship")
		then
			if died == false
			then died = true
			
			lives = lives - 1
			livesText.text = "Lives:"..lives
			
			if lives == 0 then
			display.remove(ship)
			timer.performWithDelay(2000, endGame)
			else
			ship.alpha = 0
			timer.performWithDelay(1000, restoreShip)
			end
		
			end	
		end
	end
end




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	physics.pause()
	
	
	local backGroup = display.newGroup()
	sceneGroup:insert(backGroup)
	local mainGroup = display.newGroup()
	sceneGroup:insert(mainGroup)
	local uiGroup = display.newGroup()
	sceneGroup:insert(uiGroup)
	
	local background = display.newImageRect(backGroup, "background.png",800,1400)
	background.x= display.contentCenterX
	background.y= display.contentCenterY


	ship = display.newImageRect(mainGroup, objectSheet ,4,98,79)
	ship.x= display.contentCenterX
	ship.y =display.contentHeight-100
	physics.addBody(ship, {radius=30, isSensor=true})
	ship.myName = "ship"
	
	
	livesText = display.newText(uiGroup, "Lives:" .. lives,650,40,native.systemFont,36)
	scoreText = display.newText(uiGroup, "Score:" .. score,100,40,native.systemFont,36)
	
	
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		
		Runtime:addEventListener("collision", onCollision)
		gameLoopTimer = timer.performWithDelay(500, gameLoop, 0)
		ship:addEventListener("touch", dragShip)
		ship:addEventListener("tap", fireLaser)
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel(gameLoopTimer)
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener("collision", onCollision)
		physics.pause()
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
