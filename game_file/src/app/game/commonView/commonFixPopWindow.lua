local CommonFixPopWindow = class("commonFixPopWindow", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("commonFixPopWindow")
	end
	return target
end)
function CommonFixPopWindow:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.btnOk = SoraDGetChildByName(self, "Button_ok")
	self.scroll = SoraDGetChildByName(self, "ScrollView_listText")
	self.nodeArrow = SoraDGetChildByName(self, "Node_arrow")
	self.nodeArrow:setVisible(false)
	self.spUpArrow = SoraDGetChildByName(self, "Sprite_upArrow")
	self.spDownArrow = SoraDGetChildByName(self, "Sprite_downArrow")
	self.btnOk:setTitleText(i18n("common_text_204"))
	self.btnOk:addTouchEventListener(handler(self, self.btnOkClick))
end
function CommonFixPopWindow:initData(title, listText, color, other)
	self.ccs_bg:setTitleName(title)
	local _UPVALUE1_, _ENV, tblText = self.ccs_bg, self.ccs_bg.setTitleName, self.ccs_bg.setTitleName
	local self.ccs_bg[1], tblY = 0, self.ccs_bg
	local textHeight = 0
	local isHtml = other and other.isHtml or false
	local emptyH = 24
	if other and other.noEmpty then
		emptyH = 0
	end
	for _, v in ipairs(listText) do
		local text = ccui.Text:create(v, "", 20)
		text:setAnchorPoint(1, 1)
		text:setTextHorizontalAlignment(SoraDFLabelR())
		text:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		if color then
			text:setColor(color)
		end
		if isHtml then
			text:setIsHtml(true)
		end
		text:addTo(self.scroll)
		textHeight = textHeight + SoraDGetAutoHeightLabel(text, self.scroll:getContentSize().width) + emptyH
		table.insert(tblY, textHeight)
		table.insert(tblText, text)
	end
	if other then
		if other.hideBtn then
			self.btnOk:setVisible(false)
		end
		local offsetY = 0
		if other.showArrow then
			self.nodeArrow:setVisible(true)
			offsetY = -30
			self.nodeArrow:setPositionY(offsetY)
			self.scroll:addEventListener(function(target, event)
				if event == ccui.ScrollviewEventType.scrollingEnd then
					self:checkToBottom()
				end
			end)
			self.scroll:setBounceEnabled(true)
		end
		if other.autoHeight then
			other.height = textHeight + 70
		end
		if other.height then
			local sSize = self.scroll:getContentSize()
			sSize.height = other.height - 50 - 20
			self.scroll:setContentSize(sSize)
			self.scroll:setPositionY(other.height * 0.5 - 50 + offsetY)
			self.ccs_bg:setSize(cc.size(542, other.height))
			self.ccs_bg:setPositionY(-other.height * 0.5)
		else
			self.scroll:setPositionY(self.scroll:getPositionY() + offsetY)
		end
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, textHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, textHeight))
	for i, v in ipairs(tblText) do
		v:setPosition(sSize.width, sH - tblY[i])
	end
	self:checkToBottom()
end
function CommonFixPopWindow:btnOkClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.btnHandle then
			self.btnHandle(button, type)
		else
			self:close(button, type)
		end
	end
end
function CommonFixPopWindow:setBtnInfo(handle, title)
	self.btnHandle = handle
	if title then
		self.btnOk:setTitleText(title)
	end
end
function CommonFixPopWindow:checkToBottom()
	local isToBottom = false
	local isToTop
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	print(offsetY, "offsetY")
	isToBottom = -10 < offsetY
	isToTop = offsetY < -scrollInner:getContentSize().height + self.scroll:getContentSize().height + 10
	self.spDownArrow:setVisible(not isToBottom)
	self.spUpArrow:setVisible(not isToTop)
end
return CommonFixPopWindow
