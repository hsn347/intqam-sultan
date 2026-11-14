local worldMapFaceToDistance = class("worldMapFaceToDistance", function()
	return SoraDCreateBasePanel("worldMapFaceToDistance")
end)
function worldMapFaceToDistance:ctor()
	self:setAnchorPoint(cc.p(0.5, 0.5))
	self:setContentSize(cc.size(110, 110))
	self.distanceText = SoraDGetChildByName(self, "Text_distance")
	self.nodeArrow = SoraDGetChildByName(self, "node_arrow")
	self.spArrow = SoraDGetChildByName(self, "sp_arrow")
end
local strKM = "%d KM"
function worldMapFaceToDistance:updateData(distance)
	local distanceString = string.format(strKM, distance)
	self.distanceText:setString(distanceString)
end
function worldMapFaceToDistance:setArrowRotation(rotation)
	self.nodeArrow:setRotation(rotation)
	if math.abs(rotation) < 90 then
		self.spArrow:setFlippedX(false)
	else
		self.spArrow:setFlippedX(true)
	end
end
return worldMapFaceToDistance
