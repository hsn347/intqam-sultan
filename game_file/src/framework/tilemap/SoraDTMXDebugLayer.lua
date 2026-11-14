local m = class("SoraDTMXDebugLayer", function(...)
	local target = display.newNode()
	return target
end)
function m:ctor(worldMapCell)
	self:setName("SoraDTMXDebugLayer")
	self.worldMapCell = worldMapCell
	local worldMapWarDef = include("worldMapWarDef")
	local max = worldMapWarDef.getMaxCoordinateByKid() + 1
	self.objPool, _ENV, self.objMap, _ENV, self.__tileSize = cc.size(max, max), cc.size(max, max), cc.size(max, max), cc.size(max, max), cc.size(max, max)
	self:initWithTilesetInfo()
end
function m:initWithTilesetInfo(...)
	local drawNode = cc.DrawNode:create()
	drawNode:addTo(self)
	self.drawNode = drawNode
	local max = self.__tileSize.width
	for i = 0, max do
		self:drawLine(cc.p(i, 0), cc.p(i, max))
		self:drawLine(cc.p(0, i), cc.p(max, i))
	end
end
function m:drawLine(beginTilePoint, endTilePoint)
	local beginPoint = self.worldMapCell:getPointWithTile(cc.p(beginTilePoint.x - 0.5, beginTilePoint.y - 0.5))
	local endPoint = self.worldMapCell:getPointWithTile(cc.p(endTilePoint.x - 0.5, endTilePoint.y - 0.5))
	self.drawNode:drawLine(beginPoint, endPoint, cc.c4f(1, 1, 1, 0.2))
end
function m:updateTile(rect)
	self:hideUnuseNode(rect)
	for y = 0, rect.height do
		for x = 0, rect.width do
			local tilePos = cc.p(rect.x + x, rect.y + y)
			if not self:getChildByPos(tilePos) then
				self:addLabel(tilePos)
			end
		end
	end
end
function m:addLabel(tilePos)
	local str = string.format("(%d,%d)", tilePos.x, tilePos.y)
	local label
	if self:isUnuseNodeEmpty() then
		_ENV = self
		self.text = str
		self.size = 24
		label = SoraDCreateLabelNoChild(self)
		label:setOpacity(128)
		label:addTo(self)
	else
		label = self:getUnuseNode()
		label:setString(str)
		label:setVisible(true)
	end
	local posNode = self.worldMapCell:getPointWithTile(tilePos)
	label:setPosition(posNode)
	self:setChildByPos(label, tilePos)
end
function m:getChildByPos(tilePos)
	local key = self:getKeyByPos(tilePos)
	return self.objMap[key]
end
function m:setChildByPos(obj, tilePos)
	local key = self:getKeyByPos(tilePos)
	self.objMap[key] = obj
end
function m:getKeyByPos(tilePos)
	return tilePos.x .. "," .. tilePos.y
end
function m:getPosByKey(key)
	local params = string.split(key, ",")
	return cc.p(tonumber(params[1]), tonumber(params[2]))
end
function m:isUnuseNodeEmpty(...)
	return #self.objPool <= 0
end
function m:getUnuseNode(...)
	return table.remove(self.objPool)
end
function m:hideUnuseNode(rect)
	for key, obj in pairs(self.objMap) do
		local tilePos = self:getPosByKey(key)
		if not cc.rectContainsPoint(rect, tilePos) then
			obj:setVisible(false)
			table.insert(self.objPool, obj)
			self.objMap[key] = nil
		end
	end
end
return m
