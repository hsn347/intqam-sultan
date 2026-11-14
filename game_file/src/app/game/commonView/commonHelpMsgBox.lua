local CommonHelpMsgBox = class("commonHelpMsgBox", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("commonHelpMsgBox")
	end
	return target
end)
function CommonHelpMsgBox:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:hideTitle()
	self.scroll = SoraDGetChildByName(self, "ScrollView_msg")
	self.labelMsg = SoraDGetChildByName(self, "Text_msg")
	self.labelMsg:setColor(cc.c3b(215, 195, 155))
	SoraDChangeTextToHtml(self.labelMsg)
end
function CommonHelpMsgBox:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function CommonHelpMsgBox:judgeClose()
	if self.activityID and not clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
function CommonHelpMsgBox:setMsg(msg, other)
	local labelDesH = 0
	self.labelMsg:setString(msg)
	labelDesH = SoraDGetAutoHeightLabel(self.labelMsg)
	labelDesH = labelDesH < 103 and 103 or labelDesH
	self.scroll:setInnerContainerSize(cc.size(520, labelDesH))
	self.scroll:setBounceEnabled(labelDesH > display.height * 0.5 - 40)
	self.labelMsg:setPositionY(0.5 * labelDesH)
	labelDesH = math.min(labelDesH, display.height * 0.5 - 40)
	self.scroll:setContentSize(cc.size(520, labelDesH))
	self.ccs_bg:setSize(cc.size(542, labelDesH + 45))
	self.ccs_bg:setPositionY(-(labelDesH + 45) / 2)
	if other then
		if other.float then
			self:setFloat(other.float)
		end
		if other.align then
			self.labelMsg:setTextHorizontalAlignment(other.align)
		end
		if other.addLine then
			self:addLineImage()
		end
		if other.closeBtn then
			self:addCloseBtn()
			labelDesH = labelDesH + 100
			self.ccs_bg:setSize(cc.size(542, labelDesH))
		end
		if other.title then
			self.ccs_bg:showTitle(other.title)
			self.ccs_bg:setSize(cc.size(542, labelDesH + 90))
		end
		if other.activityID then
			self.activityID = other.activityID
		end
	end
	self.scroll:setPositionY(labelDesH + 25)
end
function CommonHelpMsgBox:initData(listText, listNum, colorNum)
	local _ENV, tblTextNum
	local _UPVALUE1_, _ENV, tblText
	local (nil)[1], tblY = 0, nil
	local textHeight = 0
	for i, v in ipairs(listText) do
		local text = ccui.Text:create(v, "", 20)
		local textNum
		if listNum then
			textNum = ccui.Text:create(listNum[i], "", 20)
			textNum:setAnchorPoint(0, 1)
			textNum:setTextHorizontalAlignment(SoraDFLabelL())
			textNum:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
			textNum:setTextAreaSize(cc.size(200, 0))
			if colorNum then
				textNum:setColor(colorNum)
			end
			textNum:addTo(self.scroll)
		end
		text:setAnchorPoint(1, 1)
		text:setTextHorizontalAlignment(SoraDFLabelR())
		text:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		text:setTextAreaSize(cc.size(320, 0))
		text:addTo(self.scroll)
		textHeight = textHeight + text:getVirtualRendererSize().height + 20
		table.insert(tblY, textHeight)
		table.insert(tblText, text)
		if textNum then
			table.insert(tblTextNum, textNum)
		end
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, textHeight)
	self.ccs_bg:setSize(cc.size(self.ccs_bg:getContentSize().width, sH + 45))
	self.ccs_bg:setPositionY(-(sH + 45) / 2)
	self.scroll:setContentSize(cc.size(sSize.width, sH))
	self.scroll:setPositionY(sH + 25)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	if SoraDFIsRA() then
		for i, v in ipairs(tblText) do
			if tblTextNum[i] then
				tblTextNum[i]:setPosition(5, sH - tblY[i])
			end
			v:setPosition(sSize.width - 5, sH - tblY[i])
		end
	else
		for i, v in ipairs(tblText) do
			if tblTextNum[i] then
				tblTextNum[i]:setPosition(sSize.width - 205, sH - tblY[i])
			end
			v:setPosition(325, sH - tblY[i])
		end
	end
end
function CommonHelpMsgBox:setFloat(key)
	self.labelMsg:setTextHorizontalAlignment(key)
end
function CommonHelpMsgBox:addLineImage()
end
function CommonHelpMsgBox:addCloseBtn()
	local closeBtn = ccui.Button:create()
	closeBtn:loadTextures("btn_green_small_01.png", "", "", ccui.TextureResType.plistType)
	closeBtn:setPosition(271, 50)
	closeBtn:addTo(self.ccs_bg)
	closeBtn:setTitleText(i18n("common_text_204"))
	closeBtn:setTitleFontSize(20)
	closeBtn:addTouchEventListener(handler(self, self.close))
end
return CommonHelpMsgBox
