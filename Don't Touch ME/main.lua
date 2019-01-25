-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar(display.HiddenStatusBar)

-- Variable and Lives and Score Text
local lives = 3
local livesText
local score = 0
local scoreText
local died = false

livesText = display.newText("Lives:" .. lives,650,40,native.systemFont,36)
scoreText = display.newText("Score:" .. score,100,40,native.systemFont,36)

--Physics
local physics = require("physics")
physics.start()
physics.setGravity(0,0)


-- Object Defining
local redBlock = display.newImageRect("redBlock.png", 74, 74)
redBlock.x = 600
redBlock.y = 800
physics.addBody(redBlock, "dynamic", {box = 37, 37, 0, 0, 0})
redBlock.myName = "block"

local blueBlock = display.newImageRect("blueBlock.png", 74, 74)
blueBlock.x = display.contentWidth/2
blueBlock.y = display.contentHeight/2
physics.addBody(blueBlock, "dynamic", {box = 37, 37, 0, 0, 0})
blueBlock.myName = "block"
blueBlock:setLinearVelocity(100,100)



local function restore()

	redBlock.isBodyActive = false
	redBlock.x = display.contentWidth - 100
	redBlock.y = display.contentHeight/2
	
	blueBlock.x = display.contentWidth/2
	blueBlock.y = display.contentHeight/2
	
	redBlock:setLinearVelocity(0,0)
	blueBlock:setLinearVelocity(0,0)
	
	transition.to(blueBlock, {alpha=1, time = 3000})	
	
	transition.to(redBlock, {alpha=1, time = 3000, 
	onComplete = function() redBlock.isBodyActive = true died = false 
	end})
end

local chaseText -- Tracking Text
local chaseDir = ""
chaseText = display.newText(chaseDir, 400, 40, native.systemFont, 36)


local function chase()

if died == false then
local a = (redBlock.x - blueBlock.x)
local b = (redBlock.y - blueBlock.y)

if b == 0 then -- /0 prevention
b = b + 1
end

-- Variable Calculations
local z = a/b -- Ratio of x/y, used to set x and y velocities in the correct ratio
local v = math.sqrt(a^2+b^2) / 1.2 + score/((4-lives)*100) -- Velocity Calculation
if v < 200 then -- Minimum Speed
v = 200

end

-- Tracking and Calculation of Velocities

if a < 0 and b < 0 then -- Top Left
chaseDir = "TL"
chaseText.text = chaseDir
local x = -z * (v/(z+1))
local y = x - v
blueBlock:setLinearVelocity(x,y)

elseif b < 0 and a > 0 then -- Top Right
chaseDir = "TR"
chaseText.text = chaseDir
local x = z * (v/(z-1))
local y = x - v
blueBlock:setLinearVelocity(x,y)

elseif a < 0 and b >= 0 then -- Bottom Left
chaseDir = "BL"
chaseText.text = chaseDir
local y = z * (v/(z-1))
local x = y - v
blueBlock:setLinearVelocity(x,y)


elseif a > -5 and a < 5 then -- Horizontal/Vertical Cases
chaseDir = "V"
chaseText.text = chaseDir
blueBlock:setLinearVelocity(0,b)
elseif b > -5 and b < 5 then
chaseDir = "H"
chaseText.text = chaseDir
blueBlock:setLinearVelocity(a,0)

else -- Bottom Right
chaseDir = "BR"
chaseText.text = chaseDir
local y = z * (v/(z+1))
local x = v - y
blueBlock:setLinearVelocity(x,y)

end
if died == false then -- Score Updater
score = score + 1
scoreText.text = "Score: "..score
end
end
end

	
local gameLoopTimer
gameLoopTimer = timer.performWithDelay(10, chase, 0)


local function onCollision(event)
	
	if event.phase == "began" then
	local obj1 = event.object1
	local obj2 = event.object2
	
	if died == false
	then died = true
			
	lives = lives - 1
	livesText.text = "Lives:"..lives
			end
	if lives == 0 then
		display.remove(redBlock)
	else
		redBlock.alpha = 0
		blueBlock.alpha = 0
		timer.performWithDelay(1000,restore)
			
		end	
	end
end


Runtime:addEventListener("collision", onCollision)






function dragBlock(event)
               
                local redBlock = event.target
                local phase = event.phase
               
                if ("began" == phase) then
                                display.currentStage:setFocus(block)
                                redBlock.touchOffsetX = event.x - redBlock.x
                                redBlock.touchOffsetY = event.y - redBlock.y               
                elseif ("moved" == phase) then
                                redBlock.x = event.x-redBlock.touchOffsetX
                                redBlock.y = event.y-redBlock.touchOffsetY
                               
                elseif ("ended" == phase or "canceled" == phase) then
                                display.currentStage:setFocus(nil)
                end
                return true
end
redBlock:addEventListener("touch", dragBlock)
 