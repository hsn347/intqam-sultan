local CommonBigContextView = class("commonBigContextView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("commonBigContextView")
	end
	return target
end)
function CommonBigContextView:ctor()
	self.imgBody = SoraDGetChildByName(self, "Image_body")
	self.scroll = SoraDGetChildByName(self, "ScrollView_container")
	self.imgBody:setFillType(1)
end
function CommonBigContextView:initView(nodeWithOcx, height)
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, height)
	nodeWithOcx:setPosition(sSize.width / 2, sH)
	nodeWithOcx:addTo(self.scroll)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
end
return CommonBigContextView
