

local physics = require("physics")
physics.start()
physics.setGravity(0,0)
	
local a = 50
local hits = 0
local hitsText
hitsText = display.newText("Collisions: "..hits, display.contentWidth/2, 60, native.systemFont, 40)


local block1 = display.newImageRect("untitled drawing.png", 60, 60)
block1.x = display.contentWidth/2 - 300
block1.y = display.contentHeight/2
physics.addBody(block1, "dynamic", {box = 30, 30, 0, 0, 0, bounce = 1})
block1.myName = "block"
block1:setLinearVelocity(50, 0)

local block2 = display.newImageRect("untitled drawing.png", 60, 60)
block2.x = display.contentWidth/2 + 300
block2.y = display.contentHeight/2 
physics.addBody(block2, "dynamic", {box = 30, 30, 0, 0, 0, bounce = 1})
block2.myName = "block"
block2:setLinearVelocity(-50, 0)


local wall1 = display.newImageRect("untitled drawing.png", 2000, 100)
wall1.x = display.contentWidth/2
wall1.y = display.contentHeight + 30
physics.addBody(wall1, "static")

local wall2 = display.newImageRect("untitled drawing.png", 50, 1500)
wall2.x = display.contentWidth
wall2.y = display.contentHeight/2
physics.addBody(wall2, "static")

local wall3 = display.newImageRect("untitled drawing.png", 2000, 100)
wall3.x = display.contentWidth/2
wall3.y = 0
physics.addBody(wall3, "static")

local wall4 = display.newImageRect("untitled drawing.png", 50, 1500)
wall4.x = 0
wall4.y = display.contentHeight/2
physics.addBody(wall4, "static")

local function onCollision(event)
	
	
	
	if event.phase == "began" then
	local obj1 = event.object1
	local obj2 = event.object2
	
	
		
	
		if (obj1.myName and obj2.myName == "block")
		then
		
		if hits <= 50 then
		a = a*2
		end
		
		
	
		
		if obj1.x > 500 then
		obj1:setLinearVelocity(a, 0)
		obj2:setLinearVelocity(-a, 0)
		hits = hits + 1
		hitsText.text = "Collisions: "..hits
		else
		
		obj1:setLinearVelocity(-a, 0)
		obj2:setLinearVelocity(a, 0)
		hits = hits + 1
		hitsText.text = "Collisions: "..hits
		end
		if hits >= 7 then
		obj1:applyTorque(math.random(1,6))
		obj2:applyTorque(-1*math.random(1,6))
		end
		
		
		end
		if hits == 1337 or hits == 9001 then
		
		obj1:setLinearVelocity(0,0)
		obj2:setLinearVelocity(0,0)
		
		
		local leetText 
		leetText = display.newText("YEET", display.contentWidth/2, display.contentHeight/2, native.systemFont, 96)
		leetText:setFillColor(256,0,0)
		
		
		timer.performWithDelay(1000, fix)
		
		end
		end
		
end

local function fix()
	block1.x = block1.x - 10
	block2.x = block2.x + 10
	block1:setLinearVelocity(a, 0)
	block2:setLinearVelocity(-a, 0)
	display.remove(leetText)

end

Runtime:addEventListener("collision", onCollision)
block1:addEventListener("tap", fix)
block2:addEventListener("tap", fix)