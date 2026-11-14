local ScrollSliderFlat = class("scrollSliderFlat", function(target)
	return target
end)
function ScrollSliderFlat:ctor()
	self.sliderStyle = 1
	self.initInfo, _ENV, self.imgFlat = nil, nil, "progressbar_cumu_recharge_glow.png"
	self:addEventListener(handler(self, self.scrollEventCallBack))
	function self.addEventListener(target, cb)
		target.scrollEventCb = cb
	end
end
function ScrollSliderFlat:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		local scrollInner = self:getInnerContainer()
		local offset = self.sliderStyle == 1 and scrollInner:getPositionY() or scrollInner:getPositionX()
		self:setFlatPos(offset)
	end
	if self.scrollEventCb then
		self.scrollEventCb(target, event)
	end
end
function ScrollSliderFlat:setFlatPos(offset)
	if self.ocxFlat then
		local p = self:getParent()
		if 1 == self.sliderStyle then
			local bili = offset / self.initInfo.containerDis
			local _pos, _size = self:calcuForRealPos(self.initInfo.flatBottom + self.initInfo.flatDis * bili)
			self.ocxFlat:setPositionY(_pos)
		elseif 2 == self.sliderStyle then
		end
	end
end
function ScrollSliderFlat:calcuForRealPos(pos)
	local _size
	if 1 == self.sliderStyle then
		pos = math.max(math.min(pos, self.initInfo.flatTop), self.initInfo.flatBottom)
	elseif 2 == self.sliderStyle then
	end
	return pos, _size
end
function ScrollSliderFlat:initStyle(isHorizontal, flagImage)
	if isHorizontal then
		self.sliderStyle = 1
	else
		self.sliderStyle = 2
	end
	self.imgFlat = flagImage or "progressbar_login_lightspot.png"
	print("self.sliderStyle", self.sliderStyle)
	print("self.imgFlat", self.imgFlat)
	self:initFlat()
end
function ScrollSliderFlat:initFlat(...)
	local p = self:getParent()
	local virFlat = self:getChildByName("scroll_slider_flat")
	if virFlat then
		self.ocxFlat = virFlat
	else
		self.ocxFlat = ccui.ImageView:create(self.imgFlat, ccui.TextureResType.plistType)
		self.ocxFlat:ignoreContentAdaptWithSize(false)
		self.ocxFlat:setAnchorPoint(cc.p(0.5, 0.5))
		self.ocxFlat:setName("scroll_slider_flat")
		self.ocxFlat:addTo(p)
	end
	if 1 == self.sliderStyle then
		local deta = self:getContentSize().height / self:getInnerContainer():getContentSize().height * self:getContentSize().height
		_ENV = self:getContentSize().height
		self:getContentSize().height.posX = self:getPositionX() + self:getContentSize().width / 2
		self:getContentSize().height.flatTop = self:getPositionY() + self:getContentSize().height / 2 - deta / 2
		self:getContentSize().height.flatBottom = self:getPositionY() - self:getContentSize().height / 2 + deta / 2
		self:getContentSize().height.flatDis = self:getContentSize().height - self.ocxFlat:getContentSize().height
		self.initInfo, self:getContentSize().height.containerDis = self:getContentSize().height, self:getContentSize().height - self:getInnerContainer():getContentSize().height
		self.ocxFlat:setContentSize(cc.size(20, deta))
		self.ocxFlat:setAnchorPoint(cc.p(1, 0.5))
		self.ocxFlat:setPosition(self.initInfo.posX, self.initInfo.flatTop)
	elseif 2 == self.sliderStyle then
	end
end
return ScrollSliderFlat
