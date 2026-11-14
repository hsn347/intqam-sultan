local itemDesRead = include("itemDesRead")
local mailFunctions = include("mailFunctions")
local publicRead = include("publicRead")
local mailRewardItem = class("mailRewardItem", function(target)
	return ccui.Layout:create()
end)
function mailRewardItem:ctor()
	self:setAnchorPoint(cc.p(0.5, 0.5))
	self:setContentSize(cc.size(100, 100))
	self:setSwallowTouches(false)
	self:setCascadeOpacityEnabled(true)
	self.itemBox = include("commonItemAward").new()
	self.itemBox:addTo(self)
	self.itemBox:setCascadeOpacityEnabled(true)
	self.itemBox:setPosition(cc.p(50, 50))
	self.itemBox:setOwnView(SoraDCurrentTopPanelFromManager())
	self.itemBox:setOwnScroll(gModuleMgr.sharedMgr("mailMgr"):getScrollParent())
	self.itemBox:setScale(0.8)
	self.itemWidth = 100
	self.itemHeight = 100
end
function mailRewardItem:initWithData(data)
	self.itemBox:initData(data.id, data.num or data.count)
	self.itemBox:setUpVisible(data.showUp)
	self.itemBox:setTouchEnabled(true)
	self.itemBox:setSwallowTouches(false)
end
function mailRewardItem:setGray(isGray)
	self.itemBox:setGray(isGray)
end
return mailRewardItem
