-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
display.setStatusBar(display.HiddenStatusBar)

local physics = require("physics")
physics.start()
physics.setGravity(0,15)

local sky = display.newImageRect("background sky.png", 2000, 1000)
sky.x = display.contentCenterX
sky.y = display.contentCenterY

local score = 0
local ammo = 100
local ammoText
local scoreText

ammoText = display.newText("Ammo: "..ammo, 900, 40, native.systemFont, 36)
scoreText = display.newText("Score: "..score, 100, 40, native.systemFont, 36)



local grass = display.newImageRect("grass.png", 1024, 300)
grass.x = display.contentCenterX
grass.y = display.contentHeight
physics.addBody(grass, "static")

local box = display.newImageRect("crate.png", 100, 100)

physics.addBody(box, "dynamic", {box = 50, 50, 0, 0, 0, bounce = 0})
box.myName = "box"
box.y = 300
local function boxDrag()
if math.random(1,2) == 1 then
box.x = 0
box.y = math.random(450,550)
transition.to(box, {x = display.contentWidth + 50, time = 1000})
else
box.x = display.contentWidth
box.y = math.random(450, 550)
transition.to(box, {x = -50, time = 1000})
end
end



local aim = display.newImageRect("recticle.png", 70, 70)
aim.x = display.contentCenterX
aim.y = display.contentCenterY
aim.myName = "recticle"
physics.addBody(aim, "dynamic", {radius = 35, bounce = 0})
aim.isBodyActive = false
aim.gravityScale = 0


local gameLoopTimer
gameLoopTimer = timer.performWithDelay(1005, boxDrag, 0)


function aiming(event)
               
                local aim = event.target
                local phase = event.phase
               
                if ("began" == phase) then
                                display.currentStage:setFocus(recticle)
                                aim.touchOffsetX = event.x - aim.x
                                aim.touchOffsetY = event.y - aim.y               
                elseif ("moved" == phase) then
                                aim.x = event.x-aim.touchOffsetX
                                aim.y = event.y-aim.touchOffsetY
                               
                elseif ("ended" == phase or "canceled" == phase) then
                                display.currentStage:setFocus(nil)
                end
                return true
end
aim:addEventListener("touch", aiming)

local function fire()
	if ammo > 0 then
	ammo = ammo - 1
	ammoText.text = "Ammo: "..ammo
	aim.isBodyActive = true
	timer.performWithDelay(20, function () aim.isBodyActive = false end)
	
	end
end

local function onCollision(event)
	
	if event.phase == "began" then
	local obj1 = event.object1
	local obj2 = event.object2
	
		if obj1.myName == "box" and obj2.myName == "recticle" 
		or obj2.myName == "box" and obj1.myName == "recticle" then
		
		score = score + 1
		scoreText.text = "Score: "..score
		end
	
	end
end

aim:addEventListener("tap", fire)
Runtime:addEventListener("collision", onCollision)



