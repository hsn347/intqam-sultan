local size_zero = cc.size(0, 0)
local worldMapTroopInstance = include("worldMapTroopInstance")
local troopsMini = class("troopsMini", function()
	local view = worldMapTroopInstance.new(size_zero)
	return view
end)
function troopsMini:ctor()
	self.soldier = nil
end
function troopsMini:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, toObjectType, data, toObjectID, setRadius, userData)
	self.beginPoint = beginPoint
	self.endPoint = endPoint
	self.beginTilePoint = beginTilePoint
	self.endTilePoint = endTilePoint
	local rotation = -SoraDGetAngleByPos(beginPoint, endPoint)
	self.rotation = rotation
	local soldier = display.newSpriteNoChild("#March_sign.png")
	soldier:setScale(0.5)
	local flipX
	if self.rotation >= 0 then
		flipX = self.rotation <= 90
	else
		flipX = self.rotation > -90
	end
	soldier:setFlippedX(flipX)
	self.soliderNode:addChild(soldier, 1)
	self.soldier = soldier
	self:initCheckVisible()
end
function troopsMini:checkClickMoveLine(pos)
	return false
end
function troopsMini:beginWork(delayTime)
	worldMapTroopInstance.beginWork(self, delayTime)
	if self.soldier then
		self.soldier:setVisible(false)
	end
end
return troopsMini
