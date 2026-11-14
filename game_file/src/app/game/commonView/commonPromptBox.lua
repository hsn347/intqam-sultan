local CommonPromptBox = class("commonPromptBox", function()
	return SoraDCreateTouchPanel("commonPromptBox")
end)
function CommonPromptBox:ctor()
	self:openMsgBoxMode()
	self.btnYes = SoraDGetChildByName(self, "Button_yes")
	self.btnNo = SoraDGetChildByName(self, "Button_no")
	self.btnOther = SoraDGetChildByName(self, "Button_other")
	self.labelMsg = SoraDGetChildByName(self, "Text_msg")
	SoraDChangeTextToHtmlFgui(self.labelMsg)
	self.scrollMsg = SoraDGetChildByName(self, "ScrollView_msg")
	self.touchPanel = SoraDGetChildByName(self, "Panel_touch")
	self.img_bg = SoraDGetChildByName(self, "Image_6")
	self.nodeCommon = SoraDGetChildByName(self, "node_common")
	self.txtGold = SoraDGetChildByName(self, "text_gold")
	self.txtRefresh = SoraDGetChildByName(self, "text_refresh")
	self.btnNo:setVisible(false)
	self.nodeCommon:setVisible(false)
	self.btnOther:setVisible(false)
	self.callBackHandle = nil
	self.fromTarget = nil
	self.btnNo:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnYes:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnOther:addTouchEventListener(handler(self, self.btnClickCallBack))
	self:setCloseCallBack(handler(self, self.exitView))
	SoraDAutoSizeButtonTextByContent(self.btnNo)
	SoraDAutoSizeButtonTextByContent(self.btnYes)
	self.tableBoxData, _ENV, self.btnTouchNotClose = SoraDAutoSizeButtonTextByContent, SoraDAutoSizeButtonTextByContent, false
	SoraDAddMessage(self, "MESSAGE_UI_COMMON_MSGBOX", handler(self, self.closeSelf))
end
function CommonPromptBox:updateScroll()
	local labelH = SoraDGetAutoHeightLabel(self.labelMsg)
	local frameH = labelH + 180
	local maxH = 370
	local minH = 190
	if labelH > minH then
		self.scrollMsg:setInnerContainerSize(cc.size(380, labelH))
		self.scrollMsg:setBounceEnabled(true)
		self.scrollMsg:jumpToTop()
	else
		self.labelMsg:setPositionY(minH / 2 - labelH / 2)
		self.scrollMsg:setBounceEnabled(false)
	end
end
function CommonPromptBox:closeSelf(target, data)
	if self.fromTarget and self.fromTarget == data.fromTarget then
		if self.goldTimer then
			SoraDManagerRemoveTimer(self, self.goldTimer)
			self.goldTimer = nil
		end
		if self:getParent() and self:getParent():isRunning() then
			self:removeFromParent()
		end
	end
end
function CommonPromptBox:setTimerText(lang, timeData)
	if not self.goldTimer then
		local gold = timeData.gold
		local curTime = timeData.curTime
		local totalTime = timeData.totalTime
		self.goldTimer = SoradCreateTimer(self, function(dt)
			if curTime <= 0 then
				SoraDManagerRemoveTimer(self, self.goldTimer)
				self.goldTimer = nil
				self:removeFromParent()
			else
				local realGold = math.floor(gold * curTime / totalTime)
				if realGold <= 0 then
					realGold = 1
				end
				lang.num = string.formatnumberthousands(math.floor(realGold))
				self.labelMsg:setString(i18n(lang))
			end
		end)
	end
end
function CommonPromptBox:setTextAndGoldOnYesBtn(goldNum, displayText, checkGold)
	self.nodeCommon:setVisible(true)
	self.txtGold:setString(goldNum)
	self.txtRefresh:setString(displayText)
	self.btnYes:setTitleText("")
	if checkGold then
		self.txtGold:setColor(SoraDEnoughGold(goldNum, true) and display.COLOR_WHITE or display.COLOR_RED)
	end
end
function CommonPromptBox:initData(boxData)
	self.tableBoxData = boxData
	self.labelMsg:setString(self.tableBoxData.msg)
	self.btnYes:setTitleText(self.tableBoxData.yes)
	if self.tableBoxData.no then
		self.btnNo:setTitleText(self.tableBoxData.no)
		self.btnNo:setVisible(true)
		self.btnYes:setPositionX(SoraDFPosX(140, 0))
		self.btnNo:setPositionX(SoraDFPosX(-140, 0))
	end
	if self.tableBoxData.data and self.tableBoxData.data.isHtml then
		SoraDChangeTextToHtml(self.labelMsg)
	end
	self:updateScroll()
	if self.tableBoxData.handle then
		self.callBackHandle = self.tableBoxData.handle
	end
	if self.tableBoxData.align then
		self.labelMsg:setTextHorizontalAlignment(self.tableBoxData.align)
	end
	if self.tableBoxData.data then
		if self.tableBoxData.data.basePanelPowerValue ~= nil then
			self.showPanelPowerValue = self.tableBoxData.data.basePanelPowerValue
		end
		if self.tableBoxData.data.fromTarget ~= nil then
			self.fromTarget = self.tableBoxData.data.fromTarget
		end
		if self.tableBoxData.data.canNotClose ~= nil then
			self.enableTouchCloseSelf = self.tableBoxData.data.canNotClose
		end
		if self.tableBoxData.data.canNotBtnClose ~= nil then
			self.btnTouchNotClose = self.tableBoxData.data.canNotBtnClose
		end
		if self.tableBoxData.data.noStyle then
			local noStyle = self.tableBoxData.data.noStyle
			self.btnNo:loadTextures(noStyle.normal or "btn_red_normal_01.png", noStyle.pressed or "", noStyle.cancel or "", ccui.TextureResType.plistType)
		end
		if self.tableBoxData.data.yesStyle then
			local yesStyle = self.tableBoxData.data.yesStyle
			self.btnNo:loadTextures(yesStyle.normal or "btn_green_normal_01.png", yesStyle.pressed or "", yesStyle.cancel or "", ccui.TextureResType.plistType)
		end
		if self.tableBoxData.data.otherBtn then
			local otherStyle = self.tableBoxData.data.otherBtn
			self.btnOther:setScale9Enabled(false)
			self.btnOther:loadTextures(otherStyle.normal or "icon_contact_service.png", otherStyle.pressed or "icon_contact_service.png", otherStyle.cancel or "icon_contact_service.png", ccui.TextureResType.plistType)
			self.btnOther:setVisible(true)
			if otherStyle.pos then
				self.btnOther:setPosition(otherStyle.pos)
			end
		end
		if self.tableBoxData.data.isCantCloseByReturn then
			self.isCantCloseByReturn = self.tableBoxData.data.isCantCloseByReturn
		end
		if self.tableBoxData.data.hideBtn then
			self:hideYesBtn()
		end
		if self.tableBoxData.data.layout then
			self.btnYes:setPositionX(SoraDFPosX(140, 0))
			self.btnNo:setPositionX(SoraDFPosX(-140, 0))
		end
		if self.tableBoxData.data.closeCancel then
			self.closeCancel = true
		end
	end
end
function CommonPromptBox:setHandle(handle)
	self.callBackHandle = handle
end
function CommonPromptBox:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		self:retain()
		if not self.tableBoxData.noSound then
			SoraDPlaySound()
		end
		if button == self.btnYes then
			self:exitView(MSGBOX_CALLBACK_YES)
		elseif button == self.btnNo then
			self:exitView(MSGBOX_CALLBACK_NO)
		elseif button == self.btnOther then
			self:exitView(MSGBOX_CALLBACK_OTHER)
		end
		if self.btnTouchNotClose then
			if self:getReferenceCount() >= 1 then
				if G_IS_UNITY and tolua.isnull(self) then
					return
				end
				self:release()
			end
			return
		end
		self:close(button, type)
		if G_IS_UNITY and tolua.isnull(self) then
			return
		end
		self:release()
	end
end
function CommonPromptBox:exitView(exitType)
	if self.goldTimer then
		SoraDManagerRemoveTimer(self, self.goldTimer)
		self.goldTimer = nil
	end
	if self.callBackHandle then
		self.callBackHandle(exitType, self)
	end
end
function CommonPromptBox:onExitPanel()
	if self.closeCancel then
		self:exitView(MSGBOX_CALLBACK_NO)
	end
end
function CommonPromptBox:initAwardData(data)
end
function CommonPromptBox:hideYesBtn(...)
	self.btnYes:setVisible(false)
	self.scrollMsg:setPositionY(-90)
end
return CommonPromptBox
