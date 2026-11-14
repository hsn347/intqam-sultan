local worldMapTilesRolygon = class("worldMapTilesRolygon", function()
	return display.newNode()
end)
function worldMapTilesRolygon:ctor(scale, style)
	self.scale = scale or 1.0
	self.style = style or 1
end
function worldMapTilesRolygon:doAnimation(opacity)
	if self.style == 2 then
		local size = cc.size(256 * self.scale.width, 256 * self.scale.height)
		local diamondNode = SoraDCreateActionRectangleNode(size, true, self.color, opacity)
		diamondNode:addTo(self, 2)
		return
	end
	local boderNode = SoraDCreateActionDiamondNode(256 * self.scale, false, self.color, opacity)
	boderNode:addTo(self, 1)
	local diamondNode = SoraDCreateActionDiamondNode(256 * self.scale, true, self.color, opacity)
	diamondNode:addTo(self, 2)
end
function worldMapTilesRolygon:setRolygonColor(color, opacity)
	self.color = color or display.COLOR_WHITE
	self:doAnimation(opacity)
end
function worldMapTilesRolygon:changeRolygonColor(color)
	for __, widget in ipairs(self:getChildren()) do
		for __, v in ipairs(widget:getChildren()) do
			for __, line in ipairs(v:getChildren()) do
				line:setColor(color)
			end
		end
	end
end
return worldMapTilesRolygon
