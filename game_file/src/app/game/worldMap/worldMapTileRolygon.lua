local worldMapTileRolygon = class("worldMapTileRolygon", function(color)
	color = color or cc.c3b(255, 255, 255)
	local tileRolygon = display.newSprite("#world_tile_white.png")
	tileRolygon:setColor(color)
	return tileRolygon
end)
function worldMapTileRolygon:ctor()
	self:setNodeEventEnabled(true)
	self.isCanTransfer = true
	self.tilePoint = nil
	self.enableToggle3D = true
	self:doAnimation()
	self:toggle3D()
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_TOGGLE_3D", handler(self, self.toggle3D))
end
function worldMapTileRolygon:toggle3D()
	if not self.enableToggle3D then
		return
	end
	if gEnableWorldMap3D then
		self:setRotation3D(gWorldMapRotation3DBack)
	else
		self:setRotation3D(gWorldMapRotation2D)
	end
end
function worldMapTileRolygon:disableToggle3D()
	self.enableToggle3D = false
	self:setRotation3D(gWorldMapRotation2D)
end
function worldMapTileRolygon:doAnimation()
	local _ENV, actionsArray
	actionsArray[#actionsArray + 1] = cc.FadeTo:create(1.0, 50)
	actionsArray[#actionsArray + 1] = cc.FadeTo:create(1.0, 200)
	local action = transition.sequence(actionsArray)
	self:setOpacity(150)
	self:stopAllActions()
	self:runAction(cc.RepeatForever:create(action))
end
function worldMapTileRolygon:onExit()
	SoraDRemoveMessageByTarget(self)
end
function worldMapTileRolygon:doAnimationOnce()
	local _ENV, actionsArray
	actionsArray[#actionsArray + 1] = cc.FadeTo:create(1.0, 50)
	actionsArray[#actionsArray + 1] = cc.FadeTo:create(1.0, 200)
	actionsArray[#actionsArray + 1] = cc.FadeTo:create(1.0, 150)
	local action = transition.sequence(actionsArray)
	self:setOpacity(150)
	self:stopAllActions()
	self:runAction(action)
end
return worldMapTileRolygon
