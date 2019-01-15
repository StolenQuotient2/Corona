local TapCount = 0
local a = 0
local b = 0
local c = 0

local background = display.newImageRect("background.png", 360, 570)
background.x = display.contentCenterX
background.y = display.contentCenterY

local platform = display.newImageRect("platform.png", 300, 50)
platform.x = display.contentCenterX
platform.y = display.contentHeight-25

local balloon = display.newImageRect("balloon.png", 112, 112)
balloon.x = display.contentCenterX
balloon.y = display.contentCenterY
balloon.alpha = 0.8

local physics = require("physics")
physics.start()

physics.addBody(platform, "static")
physics.addBody(balloon, "dynamic", {radius = 55, bounce = 0.3})

local tapText = display.newText(TapCount, display.contentCenterX, 20, native.systemFont, 40)
tapText:setFillColor(0,0,0)

local function pushBalloon()
	balloon:applyLinearImpulse(0, -0.75, balloon.x, balloon.y)
	TapCount = TapCount + 1
	tapText.text = TapCount
	if TapCount%5 == 0 then
		tapText:setFillColor(100,100,100)
	end
	if TapCount%5 ~= 0 then
		tapText:setFillColor(a,b,c)
	end
	if TapCount == 25 then
		a = 100
		tapText:setFillColor(a,b,c)
	end
	if TapCount == 50 then
		b = 100
		a = 0
		tapText:setFillColor(a,b,c)
	end
	if TapCount == 100 then
		c = 100
		b = 0
		a = 0
	end
	if TapCount == 150 then
		b = 100
	end
	if TapCount == 200 then 
		b = 0
		a = 100
	end
end

balloon:addEventListener("tap", pushBalloon)