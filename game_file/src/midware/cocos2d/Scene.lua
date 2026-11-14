local Scene = class("Scene", cc.Node)
function Scene:createWithSize(size)
	local scene = Scene.new()
	scene:setAnchorPoint(0.5, 0.5)
	scene:setContentSize(size)
	scene:autoRelease()
	return scene
end
function Scene:createWithPhysics()
	local scene = Scene.new()
	scene:autoRelease()
	scene:setContentSize(display.rwidth, display.rheight)
	return scene
end
function Scene:getDesciption()
	return "Scene"
end
local _instance
function Scene:getPhysicsWorld()
	if _instance then
		return _instance
	end
	return _instance
end
local _TSinstance
function Scene:getTSPhysicsWorld()
	if _TSinstance then
		return _TSinstance
	end
	return _TSinstance
end
return Scene
