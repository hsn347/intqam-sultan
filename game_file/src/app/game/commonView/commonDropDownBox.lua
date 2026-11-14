local commonDropDownBox = class("commonDropDownBox", function(target)
	if "userdata" == type(target) then
		return target
	else
		return SoraDCreateBasePanel("commonDropDownBox")
	end
end)
function commonDropDownBox:ctor()
	self.dir = 1
	self.isCustom = false
	self.switcher = false
	self.maxHeight = 200
	self.childSize = cc.size(212, 40)
	self.offset = cc.p(-32, -5)
	self.childData, _ENV, self.size = cc.size(0, 0), cc.size(0, 0), cc.size(0, 0)
	self.chooseTag = 1
	self.childArray, _ENV, self.chooseIndex = cc.size(0, 0), cc.size(0, 0), 1
	self.handle = nil
	self.targetName = nil
	self.Image_border_base = SoraDGetChildByName(self, "Image_border_base")
	self.baseSize = self.Image_border_base:getContentSize()
	self.Image_border = SoraDGetChildByName(self, "Image_border")
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	self.Node_single:setVisible(false)
	self.frame_arrow = SoraDGetChildByName(self, "frame_arrow")
	self.Text_choose = SoraDGetChildByName(self, "Text_choose")
	self.Button_choose = SoraDGetChildByName(self, "Button_choose")
	self.Button_choose:addTouchEventListener(handler(self, self.btnChooseClick))
	self.customParam = nil
end
function commonDropDownBox:setSize(size)
	self.size = size
end
function commonDropDownBox:setSelectSingleTarget(targetName)
	self.targetName = targetName
end
function commonDropDownBox:setCustomColor(customColor)
	self.customColor = customColor
end
function commonDropDownBox:setIsCustom(ret)
	self.isCustom = ret
end
function commonDropDownBox:setCustomParam(customParam)
	self.customParam = customParam
end
function commonDropDownBox:setDir(dir)
	self.dir = dir
	self.frame_arrow:setFlippedY(self.dir ~= 1)
end
function commonDropDownBox:setOffset(offset)
	self.offset = offset
end
function commonDropDownBox:setChooseTag(tag)
	self.chooseTag = tag
end
function commonDropDownBox:setBaseBorderInfo(info)
	self.Image_border_base:setAnchorPoint(info.anchorPoint or cc.p(0.5, 1))
	self.Image_border_base:setPosition(info.point or cc.p(0, 0))
	self.Image_border_base:setContentSize(info.size or cc.size(250, 60))
end
function commonDropDownBox:setBtnChooseInfo(info)
	self.Button_choose:setAnchorPoint(info.anchorPoint or cc.p(0.5, 0.5))
	self.Button_choose:setPosition(info.point or cc.p(0, -self.baseSize.height / 2))
	self.Button_choose:setContentSize(info.size or self.baseSize)
end
function commonDropDownBox:setArrowInfo(info)
	self.frame_arrow:setAnchorPoint(info.anchorPoint or cc.p(0.5, 0.5))
	self.frame_arrow:setPosition(info.point or cc.p(self.baseSize.width / 2 - 45, -self.baseSize.height / 2))
	self.frame_arrow:setFlippedY(info.isfy or false)
end
function commonDropDownBox:setTextChooseInfo(info)
	self.Text_choose:setAnchorPoint(info.anchorPoint or cc.p(0.5, 0.5))
	self.Text_choose:setPosition(info.point or cc.p(-20, -self.baseSize.height / 2))
	self.Text_choose:setContentSize(info.size or cc.size(self.baseSize.width - 80, self.baseSize.height - 20))
	self.Text_choose:setColor(info.color or cc.c3b(255, 255, 255))
end
function commonDropDownBox:setBorderInfo(info)
	self.Image_border:setAnchorPoint(info.anchorPoint or cc.p(0.5, 1))
	self.Image_border:setPosition(info.point or cc.p(0, 0))
	self.Image_border:setContentSize(info.size or cc.size(250, 200))
end
function commonDropDownBox:setScrollInfo(info)
	self.scroll:setAnchorPoint(info.anchorPoint or cc.p(0.5, 1))
	self.scroll:setPosition(info.point or cc.p(0, -self.baseSize.height))
	self.scroll:setContentSize(info.size or cc.size(212, 120))
end
function commonDropDownBox:setTouchClose()
	if not self.touchPanel then
		self.touchPanel = ccui.Layout:create()
		self.touchPanel:setAnchorPoint(cc.p(0.5, 0.5))
		self.touchPanel:setContentSize(cc.size(display.width, display.height))
		local worldPos = self:convertToWorldSpace(cc.p(0, 0))
		local nodePos = self:convertToNodeSpace(worldPos)
		self.touchPanel:setPosition(nodePos.x, nodePos.y + display.cy - self:getPositionY() - 40)
		self.touchPanel:addTo(self, -1)
		self.touchPanel:setTouchEnabled(true)
		self.touchPanel:setSwallowTouches(true)
		self.touchPanel:addTouchEventListener(function(target, event)
			if event == ccui.TouchEventType.ended and self.switcher then
				self:closeBox()
				self.switcher = not self.switcher
			end
		end)
	end
end
function commonDropDownBox:initData(param)
	self.maxHeight = param.maxHeight or 200
	self.childSize = param.childSize or cc.size(212, 40)
	if not param.childData then
		_ENV = param.childData
	end
	self.childData = param.childData
	self:refreshData(self.childData)
	self:closeBox()
end
function commonDropDownBox:refreshData(data)
	self.childData = data
	local innerHeight = self.scroll:getContentSize().height
	if self.isCustom then
		if not self.customParam then
			innerHeight = math.max(#self.childData * self.childSize.height, self.scroll:getContentSize().height)
			self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, innerHeight))
		else
			local childSizeH = #self.childData * self.childSize.height
			innerHeight = childSizeH
			local maxScrollH = self.maxHeight - self.baseSize.height + self.offset.y - 10
			local scrollH = math.min(innerHeight, maxScrollH)
			print("commonDropDownBox:refreshData ----------self.customParam", self.customParam, innerHeight, maxScrollH, scrollH)
			self.scroll:setContentSize(cc.size(self.baseSize.width + self.offset.x, scrollH))
			self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, innerHeight))
		end
	else
		self.scroll:setContentSize(cc.size(self.baseSize.width + self.offset.x, self.maxHeight - self.baseSize.height + self.offset.y - 10))
		innerHeight = math.max(#self.childData * self.childSize.height, self.maxHeight - self.baseSize.height + self.offset.y)
		self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, innerHeight))
	end
	self.scroll:setBounceEnabled(innerHeight >= self.scroll:getContentSize().height)
	self:removeAllChildren()
	for k, v in ipairs(self.childData) do
		if k == 1 then
			self.Node_single:setVisible(true)
			self.childArray[k] = self.Node_single
		else
			self.childArray[k] = self.Node_single:clone()
			self.childArray[k]:setVisible(true)
			self.childArray[k]:addTo(self.scroll)
		end
		self.childArray[k]:setPosition(self.scroll:getContentSize().width / 2, innerHeight - self.childSize.height * k)
		self:setSingleInfo(self.childArray[k], k, v)
	end
	self:updateChooseIndex()
	self.Text_choose:setString(self.childData[self.chooseIndex].title)
end
function commonDropDownBox:setDefaultIndex(index)
	self.chooseIndex = index
	self.Text_choose:setString(self.childData[self.chooseIndex].title)
end
function commonDropDownBox:updateChooseIndex()
	for i, v in ipairs(self.childData) do
		if v.tag == self.chooseTag then
			self.chooseIndex = i
			break
		end
	end
end
function commonDropDownBox:removeAllChildren()
	for k, v in ipairs(self.childArray) do
		if k ~= 1 then
			self.childArray[k]:removeFromParent()
			self.childArray[k] = nil
		else
			self.childArray[k]:setVisible(false)
		end
	end
end
function commonDropDownBox:setSingleInfo(single, index, data)
	local Button_select = SoraDGetChildByName(single, "Button_select")
	Button_select = include("commonBtnInstance").new(Button_select)
	Button_select:setSwallowTouches(false)
	Button_select:setTitleText(data.title)
	SoraDAutoSizeButtonText(Button_select)
	Button_select:setScroll(self.scroll)
	Button_select:setTag(data.tag or index)
	Button_select:setHandle(handler(self, self.btnSelectClick))
	single.tag = Button_select:getTag()
	if self.targetName then
		SoraDGetChildByName(single, self.targetName):setVisible(single.tag == self.chooseTag)
	end
	if self.customColor then
		Button_select:setTitleColor(single.tag == self.chooseTag and cc.c3b(255, 235, 14) or cc.c3b(116, 52, 17))
	end
	local redIcon = SoraDGetChildByName(single, "img_number")
	if redIcon then
		local newNum = data.newNum or 0
		redIcon:setVisible(0 < newNum)
		local label_number = redIcon:getChildByName("label_number")
		if 99 < newNum then
			label_number:setString("99+")
		else
			label_number:setString(tostring(newNum))
		end
	end
end
function commonDropDownBox:openBox()
	if self.touchPanel then
		self.touchPanel:setVisible(true)
	end
	self.Image_border:setVisible(true)
	if self.needFlipArrow and self.needFlipArrow == 1 then
		self.frame_arrow:setFlippedY(true)
	else
		self.frame_arrow:setFlippedY(false)
	end
	if self.dir == 1 then
		if self.isCustom then
			if not self.customParam then
			else
				print("--------------------11111")
				self.Image_border:setAnchorPoint(cc.p(0.5, 1))
				self.Image_border:setPositionY(0 + self.customParam.borderOffsetY)
				local scrollSize = self.scroll:getContentSize()
				local bp = self.customParam.borderPadding
				local borderSize = cc.size(scrollSize.width + bp[1] + bp[3], scrollSize.height + bp[2] + bp[4])
				self.Image_border:setContentSize(borderSize)
				self.scroll:setAnchorPoint(cc.p(0.5, 1))
				local scrollOffsetY = self.customParam.scrollOffsetY
				self.scroll:setPositionY(-self.baseSize.height + (scrollOffsetY or 0))
			end
		else
			self.Image_border:setAnchorPoint(cc.p(0.5, 1))
			self.Image_border:setPositionY(0)
			self.Image_border:setContentSize(cc.size(self.baseSize.width, self.maxHeight))
			self.scroll:setAnchorPoint(cc.p(0.5, 1))
			self.scroll:setPositionY(-self.baseSize.height)
		end
	elseif self.isCustom then
		if not self.customParam then
		else
			print("--------------------112221")
			self.Image_border:setAnchorPoint(cc.p(0.5, 0))
			self.Image_border:setPositionY(-self.baseSize.height + self.customParam.borderOffsetY)
			self.scroll:setAnchorPoint(cc.p(0.5, 0))
			local scrollOffsetY = self.customParam.scrollOffsetY
			self.scroll:setPositionY(scrollOffsetY or 0)
			local scrollSize = self.scroll:getContentSize()
			local bp = self.customParam.borderPadding
			local borderSize = cc.size(scrollSize.width + bp[1] + bp[3], scrollSize.height + bp[2] + bp[4])
			self.Image_border:setContentSize(borderSize)
		end
	else
		self.Image_border:setAnchorPoint(cc.p(0.5, 0))
		self.Image_border:setPositionY(-self.baseSize.height)
		self.Image_border:setContentSize(cc.size(self.baseSize.width, self.maxHeight))
		self.scroll:setAnchorPoint(cc.p(0.5, 0))
		self.scroll:setPositionY(0)
	end
	if self.isCustom then
		if not self.customParam then
		else
		end
	else
		self.scroll:setContentSize(cc.size(self.baseSize.width + self.offset.x, self.maxHeight - self.baseSize.height + self.offset.y - 10))
	end
	self.scroll:setVisible(true)
	self:jumpIndexToCenter(self.chooseIndex)
	if self.targetName then
		for k, v in ipairs(self.childArray) do
			SoraDGetChildByName(v, self.targetName):setVisible(v.tag == self.chooseTag)
		end
	end
	if self.customColor then
		for k, v in ipairs(self.childArray) do
			SoraDGetChildByName(v, "Button_select"):setTitleColor(v.tag == self.chooseTag and cc.c3b(255, 235, 14) or cc.c3b(116, 52, 17))
		end
	end
end
function commonDropDownBox:closeBox()
	if self.touchPanel then
		self.touchPanel:setVisible(false)
	end
	self.Image_border:setVisible(false)
	self.scroll:setVisible(false)
	if self.needFlipArrow and self.needFlipArrow == 1 then
		self.frame_arrow:setFlippedY(false)
	else
		self.frame_arrow:setFlippedY(true)
	end
end
function commonDropDownBox:getSelectTag()
	return self.chooseTag
end
function commonDropDownBox:getSelectSingle()
	return self.childArray[self.chooseIndex]
end
function commonDropDownBox:getSize()
	return self.size
end
function commonDropDownBox:addEventListener(handle)
	self.handle = handle
end
function commonDropDownBox:btnSelectClick(button, event)
	self.Text_choose:setString(button:getTitleText())
	self:closeBox()
	self.switcher = false
	self.chooseTag = button:getTag()
	self:updateChooseIndex()
	if self.handle then
		self.handle(self.chooseTag)
	end
end
function commonDropDownBox:btnChooseClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.switcher then
			self:closeBox()
		else
			self:openBox()
		end
		self.switcher = not self.switcher
	end
end
function commonDropDownBox:setFlipArrow(dir)
	self.needFlipArrow = dir
end
function commonDropDownBox:jumpIndexToCenter(index)
	print("jumpIndexToCenter", index)
	local inner = self.scroll:getInnerContainer()
	local innerH = inner:getContentSize().height
	local scrollH = self.scroll:getContentSize().height
	local index = index or 1
	local posY = scrollH / 2 - innerH + self.childSize.height * (index - 0.5)
	inner:setPositionY(math.max(scrollH - innerH, (math.min(0, posY))))
end
function commonDropDownBox:getTextChoose(...)
	return self.Text_choose
end
return commonDropDownBox
