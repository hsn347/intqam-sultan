local commonPromptBoxNew = class("commonPromptBoxNew", function()
	return SoraDCreateTouchPanel("commonPromptBoxNew")
end)
function commonPromptBoxNew:ctor()
	self:openMsgBoxMode()
	self.tableBoxData, _UPVALUE0_ = self.openMsgBoxMode, self.openMsgBoxMode
	self:initWidget()
end
function commonPromptBoxNew:initWidget(...)
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_1")
	self.ccs_bg:hideTitle()
	self.panel_bg = SoraDGetChildByName(self, "Size_Panel_1")
	if self.panel_bg then
		self.panel_bg:setVisible(false)
	end
	self.labelMsg = SoraDGetChildByName(self, "Text_msg")
	self.btnYes = SoraDGetChildByName(self, "Button_yes")
	self.btnYes:addTouchEventListener(handler(self, self.btnClickCallBack))
	SoraDAutoSizeButtonTextByContent(self.btnYes)
	self.btnNo = SoraDGetChildByName(self, "Button_no")
	self.btnNo:addTouchEventListener(handler(self, self.btnClickCallBack))
	SoraDAutoSizeButtonTextByContent(self.btnNo)
	self:setCloseCallBack(handler(self, self.exitView))
end
function commonPromptBoxNew:initData(boxData)
	self.tableBoxData = boxData
	if not boxData.otherData then
		local _ENV, otherData = boxData.otherData, boxData.otherData
	end
	self.btnYes:setTitleText(boxData.yes)
	if boxData.no then
		self.btnNo:setTitleText(boxData.no)
		self.btnNo:setVisible(true)
		self.btnYes:setPositionX(122)
		self.btnNo:setPositionX(-122)
	else
		self.btnNo:setVisible(false)
		self.btnYes:setPositionX(0)
	end
	if boxData.handle then
		self.callBackHandle = boxData.handle
	end
	if otherData.align then
		self.labelMsg:setTextHorizontalAlignment(otherData.align)
	end
	if otherData.valign then
		self.labelMsg:setTextVerticalAlignment(otherData.valign)
	end
	if otherData.title then
		self.ccs_bg:showTitle(otherData.title)
		self.labelMsg:setPositionY(self.labelMsg:getPositionY() - 20)
	end
	if otherData.useHtml then
		self.labelMsg:setColor(display.COLOR_WHITE)
		SoraDChangeTextToHtml(self.labelMsg)
	end
	if otherData.canNotClose then
		self.enableTouchCloseSelf = otherData.canNotClose
	end
	self.labelMsg:setString(boxData.msg)
end
function commonPromptBoxNew:setHandle(handle)
	self.callBackHandle = handle
end
function commonPromptBoxNew:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button == self.btnYes then
			self:exitView(MSGBOX_CALLBACK_YES)
		elseif button == self.btnNo then
			self:exitView(MSGBOX_CALLBACK_NO)
		end
		self:close(button, type)
	end
end
function commonPromptBoxNew:onExitPanel()
	if not self.isExitViewCall then
		self:exitView(nil)
	end
end
function commonPromptBoxNew:exitView(exitType)
	self.isExitViewCall = true
	if self.callBackHandle then
		self.callBackHandle(exitType, self)
	end
end
return commonPromptBoxNew
