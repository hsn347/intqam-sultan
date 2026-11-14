local commonDropBox = class("commonDropBox", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonDropBox")
	end
	return target
end)
local ON_PERCENTAGE_CHANGED = 0
function commonDropBox:ctor()
	self.width = 400
	self.singleWidth = 350
	self.singleHeight = 50
	self.sliderWidth = 50
	self.sliderHeight = 300
	self.dataArray, _ENV, self.showPanelHeight = nil, nil, 400
	self.selectedIndex = 1
	self.dir = 0
	self.curPercent = 0
	self.panel_bg = SoraDGetChildByName(self, "Panel_bg")
	self.btn_choose = SoraDGetChildByName(self, "Button_choose")
	self.btn_choose:addTouchEventListener(handler(self, self.btnChooseClickCallBack))
	self.listBtnSize = self.btn_choose:getContentSize()
	self.btn_dir = SoraDGetChildByName(self, "Button_dir")
	self.btn_dir:addTouchEventListener(handler(self, self.btnDirClickCallBack))
	self.panel_list = SoraDGetChildByName(self, "Panel_list")
	self.panel_list:setScaleY(0)
	self.node_slider = SoraDGetChildByName(self, "Node_slider")
	self.panel_sliderBg = SoraDGetChildByName(self, "Panel_sliderBg")
	self.slider = SoraDGetChildByName(self, "Panel_slider")
	self.slider:setTouchEnabled(true)
	self.slider:addTouchEventListener(handler(self, self.OnSliderBtnClick))
	self.btn_up = SoraDGetChildByName(self, "Button_up")
	self.btn_up:addTouchEventListener(handler(self, self.btnUpClickCallBack))
	self.btn_down = SoraDGetChildByName(self, "Button_down")
	self.btn_down:addTouchEventListener(handler(self, self.btnDownClickCallBack))
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.inner = self.scroll:getInnerContainer()
end
function commonDropBox:initConfig(param)
	self.width = param.width or 400
	self.singleWidth = param.singleWidth or 350
	self.singleHeight = param.singleHeight or 50
	self.sliderWidth = param.sliderWidth or 50
	self.sliderHeight = param.sliderHeight or 300
	self.showPanelHeight = param.showPanelHeight or 400
	self.panel_bg:setContentSize(cc.size(self.width, self.singleHeight))
	self.panel_list:setContentSize(cc.size(self.width, self.showPanelHeight))
	self.panel_list:setPosition(cc.p(self.width / 2, -self.singleHeight))
	self.btn_choose:setContentSize(cc.size(self.singleWidth, self.singleHeight))
	self.btn_choose:setPosition(cc.p(self.singleWidth / 2, self.singleHeight / 2))
	self.btn_dir:setContentSize(cc.size(self.singleHeight, self.singleHeight))
	self.btn_dir:setPosition(cc.p(self.width - self.singleHeight / 2, self.singleHeight / 2))
	local triangle_dir = cc.DrawNode:create()
	triangle_dir:drawTriangle(cc.p(0, 0), cc.p(self.singleHeight, 0), cc.p(self.singleHeight / 2, self.singleHeight), cc.c4f(0, 0, 0, 1))
	triangle_dir:addTo(self.btn_dir, 2)
	self.btn_up:setContentSize(cc.size(self.sliderWidth, self.sliderWidth))
	self.btn_up:setPosition(cc.p(0, self.sliderHeight / 2 + self.sliderWidth / 2))
	local triangle_up = cc.DrawNode:create()
	triangle_up:drawTriangle(cc.p(0, 0), cc.p(self.sliderWidth, 0), cc.p(self.sliderWidth / 2, self.sliderWidth), cc.c4f(0, 0, 0, 1))
	triangle_up:addTo(self.btn_up, 2)
	self.btn_down:setContentSize(cc.size(self.sliderWidth, self.sliderWidth))
	self.btn_down:setPosition(cc.p(0, -self.sliderHeight / 2 - self.sliderWidth / 2))
	local triangle_down = cc.DrawNode:create()
	triangle_down:drawTriangle(cc.p(0, 0), cc.p(self.sliderWidth, 0), cc.p(self.sliderWidth / 2, self.sliderWidth), cc.c4f(0, 0, 0, 1))
	triangle_down:addTo(self.btn_down, 2)
	self.frame_line = cc.DrawNode:create()
	self.frame_line:setPosition(0, self.showPanelHeight)
	self.frame_line:addTo(self.panel_list, 2)
	self.frame_line:drawSegment(cc.p(0, 0), cc.p(self.width, 0), 0.5, cc.c4f(0, 0, 0, 1))
	self.scroll:setContentSize(cc.size(self.singleWidth, self.showPanelHeight))
	self.scroll:setPosition(cc.p(0, self.showPanelHeight))
	self.node_slider:setPosition(cc.p(self.width - self.singleHeight / 2, self.showPanelHeight / 2))
	self.panel_sliderBg:setContentSize(cc.size(self.sliderWidth, self.sliderHeight))
	self.slider:setContentSize(cc.size(self.sliderWidth, math.max(100, self.sliderHeight - 200)))
end
function commonDropBox:initData(data)
	self.dataArray = data
end
function commonDropBox:initDefaultIndex(index)
	self.selectedIndex = index
	self:setDefaultItem()
end
function commonDropBox:initView()
	local scrollH = math.max(self.scroll:getContentSize().height, self.singleHeight * table.nums(self.dataArray))
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	for k, v in ipairs(self.dataArray) do
		local btn = self.btn_choose:clone()
		btn:setContentSize(self.listBtnSize)
		btn:setTitleText(v.name)
		btn:setTag(k)
		btn:addTouchEventListener(handler(self, self.btnClickCallBack))
		btn:setPosition(cc.p(self.scroll:getContentSize().width / 2, scrollH - k * self.singleHeight + self.singleHeight / 2))
		btn:addTo(self.scroll)
	end
	self:setDefaultItem()
	self.scroll:jumpToTop()
end
function commonDropBox:hideSlider()
	self.node_slider:setVisible(false)
	self.scroll:setContentSize(cc.size(self.width, self.showPanelHeight))
	self.listBtnSize = cc.size(self.width, self.singleHeight)
end
function commonDropBox:setDefaultItem()
	if self.dataArray[self.selectedIndex] then
		self.btn_choose:setTitleText(self.dataArray[self.selectedIndex].name)
		self.btn_choose:setTag(self.selectedIndex)
		if self.handler_choose then
			self.handler_choose(self, self.selectedIndex, self.dataArray[self.selectedIndex])
		end
	end
end
function commonDropBox:setHandleChoose(handler)
	self.handler_choose = handler
end
function commonDropBox:getSelectedItem()
	return self.dataArray[self.selectedIndex]
end
function commonDropBox:setPercent(percent)
	self.slider:setPositionY(self.sliderHeight / 2 - self.slider:getContentSize().height / 2 + percent * (self.slider:getContentSize().height - self.sliderHeight) / 100)
end
function commonDropBox:btnUpClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.curPercent = math.min(100, self.curPercent + math.abs(self.singleHeight * 100 / (self.showPanelHeight - self.inner:getContentSize().height)))
		self:setPercent(self.curPercent)
		self:updateSlider()
	end
end
function commonDropBox:btnDownClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.curPercent = math.max(0, self.curPercent - math.abs(self.singleHeight * 100 / (self.showPanelHeight - self.inner:getContentSize().height)))
		self:setPercent(self.curPercent)
		self:updateSlider()
	end
end
function commonDropBox:OnSliderBtnClick(target, event)
	if event == ccui.TouchEventType.ended then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.began then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = touchBeganPoint.y - touchmovePoint.y
		if math.abs(tonumber(distance)) > 0 then
			self.singleIsMoved = true
		end
		if self.singleIsMoved then
			local pos = self:convertToNodeSpace(cc.p(touchmovePoint.x, touchmovePoint.y))
			local posY = pos.y + 280
			posY = math.min(posY, 100)
			posY = math.max(posY, -100)
			target:setPositionY(posY)
			self.curPercent = (1 - (100 + posY) / 200) * 100
			self:updateSlider()
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function commonDropBox:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		local posY = self.inner:getPositionY()
		local percent = (1 - math.abs(posY / (self.scroll:getInnerContainerSize().height - self.showPanelHeight))) * 100
		if percent < 0 then
			percent = 0
		end
		if 100 < percent then
			percent = 100
		end
		self.curPercent = percent
		self:setPercent(self.curPercent)
	elseif event == ccui.ScrollviewEventType.scrollToTop then
		self.curPercent = 0
		self:setPercent(self.curPercent)
	end
end
function commonDropBox:updateSlider()
	local perY = (self.showPanelHeight - self.inner:getContentSize().height) / 100
	local curPosY = self.showPanelHeight - self.inner:getContentSize().height - perY * self.curPercent
	self.inner:setPositionY(curPosY)
end
function commonDropBox:btnClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:runActionUp()
		self.selectedIndex = button:getTag()
		self:setDefaultItem()
		self.dir = 0
		self.btn_dir:setFlippedY(false)
	end
end
function commonDropBox:btnDirClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.dir == 0 then
			self:runActionDown()
			self.dir = 1
			button:setFlippedY(true)
		else
			self:runActionUp()
			self.dir = 0
			button:setFlippedY(false)
		end
	end
end
function commonDropBox:btnChooseClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:runActionUp()
		self.selectedIndex = button:getTag()
		self.dir = 0
		self.btn_dir:setFlippedY(false)
	end
end
function commonDropBox:runActionDown()
	self.panel_list:runAction(cc.EaseExponentialOut:create(cca.scaleTo(0.2, 1, 1)))
end
function commonDropBox:runActionUp()
	self.panel_list:runAction(cc.EaseExponentialOut:create(cca.scaleTo(0.2, 1, 0)))
end
return commonDropBox
