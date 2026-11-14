local mailItemDetailTowerInfo = class("mailItemDetailTowerInfo", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("mailItemDetailTowerInfo"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function mailItemDetailTowerInfo:ctor()
	self:setCascadeOpacityEnabled(true)
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	if self.layout_content then
		self.layout_content:setSwallowTouches(false)
	end
	self.build1 = SoraDGetExtendChildFromCCSByName(self, "CCS_mailItemBuildBox_node1")
	self.build2 = SoraDGetExtendChildFromCCSByName(self, "CCS_mailItemBuildBox_node2")
	local itemSize = self.layout_content:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailItemDetailTowerInfo:initWithData(data)
	local item1 = data[1]
	local item2 = data[2]
	if item1 ~= nil then
		_UPVALUE0_ = nil
		;(nil).id = item1.bid
		;(nil).lv = item1.lv
		self.build1:initWithData(nil)
	end
	if item2 ~= nil then
		_UPVALUE0_ = nil
		;(nil).id = item2.bid
		;(nil).lv = item2.lv
		self.build2:initWithData(nil)
	end
end
function mailItemDetailTowerInfo:getItemWidth()
	return self.itemWidth
end
function mailItemDetailTowerInfo:getItemHeight()
	return self.itemHeight
end
return mailItemDetailTowerInfo
