local AutoFightMapView = class("autoFightMapView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("autoFightMapView")
	end
	return target
end)
function AutoFightMapView:ctor()
	self.firstMapViewCell = include("autoBaseMap").new()
	local mapViewSize = self.firstMapViewCell:getContentSize()
	local containerViewSize = cc.size(960.0, 1440.0)
	self.firstMapViewCell:ignoreAnchorPointForPosition(false)
	self.firstMapViewCell:setAnchorPoint(cc.p(0.5, 0.5))
	self.firstMapViewCell:setPosition(cc.p(0.5 * containerViewSize.width, 0.5 * containerViewSize.height))
	self.containerView = ccui.Layout:create()
	self.containerView:setTouchEnabled(true)
	self.containerView:setSwallowTouches(false)
	self.containerView:setContentSize(containerViewSize)
	self.firstMapViewCell:addTo(self.containerView, 0)
	self.viewScrollView = cc.ScrollView:create(self:getContentSize())
	self.viewScrollView:setContainer(self.containerView)
	self.viewScrollView:setMinScale(0.75)
	self.viewScrollView:setMaxScale(1.35)
	self.viewScrollView:setZoomScale(1)
	self.viewScrollView:setBounceable(false)
	self.viewScrollView:setInertiaValue(0.35)
	self.viewScrollView:setPosition(cc.p(0, 0))
	self:addChild(self.viewScrollView, 0)
	self.btnStar = SoraDGetChildByName(self, "Button_star")
	self.btnStar:addTouchEventListener(handler(self, self.btnClickCallBack))
end
function AutoFightMapView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		self.firstMapViewCell:starWar()
	end
end
return AutoFightMapView
