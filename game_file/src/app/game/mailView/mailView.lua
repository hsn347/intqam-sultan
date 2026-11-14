local mailCtrl = SoraDGetCtrl("mailCtrl")
local mailMgr = gModuleMgr.sharedMgr("mailMgr")
local mailFunctions = include("mailFunctions")
local mailDesRead = include("mailDesRead")
local mailView = class("mailView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("mailView")
	end
	return target
end)
function mailView:ctor()
	self.nodeTabs, _ENV = nil, nil
	self.judgeHMove = 3 * TOUCH_MOVED_ERROR_VALUE
	self.judgeVMove = 3 * TOUCH_MOVED_ERROR_VALUE
	self.tabIndex = 0
	self.mailSetKey = "key"
	self.mailSetType = gMailSetType.INFO_MAIL
	self.isHideCurrentSceneView = true
	self.title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_mail")
	self.title:setTitle(i18n("mail_text_25"))
	self.scrollView = SoraDGetExtendChildFromCCSByName(self, "CCS_mailScrollView_node", true)
	self.touchPanel = SoraDGetChildByName(self, "Size_TouchPanel")
	self.touchPanel:setSwallowTouches(false)
	self.touchPanel:addTouchEventListener(handler(self, self.onTouchPanel))
	self.emptyTipNode = SoraDGetChildByName(self, "Center_EmptyTip")
	self.text_empty_tip = SoraDGetChildByName(self.emptyTipNode, "Center_text_empty_tip")
	self.text_empty_tip:setString(i18n("common_text_1800"))
	self.scrollTab = SoraDGetChildByName(self, "Top_ScrollView_Tab")
	self.nodeTabs[1] = SoraDGetChildByName(self.scrollTab, "Node_TabSingle")
	self.scrollTab:setLocalZOrder(1)
	self.title:setLocalZOrder(2)
	self.battleMailType = 0
	self.dropDownBox = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonDropDownBox", true)
	self.dropDownBox:setCustomColor(true)
	self.dropDownBox:setIsCustom(true)
	self.dropDownBox:setSelectSingleTarget("Image_select")
	self.dropDownBox:setTouchClose()
	self.dropDownBox:setFlipArrow(0)
	self.dropDownBox:setChooseTag(self.battleMailType + 1)
	self.dropDownBox:setTouchClose()
	_ENV = self.battleMailType + 1
	;(self.battleMailType + 1).maxHeight = 300
	_ENV, _UPVALUE8_, (self.battleMailType + 1).childSize = 360, cc.size(360, 47), cc.size(360, 47)
	;(360).title = "mail_2_text_4"
	_ENV, (360).tag = 47, 1
	;(47).title = "mail_2_text_5"
	_ENV, (47).tag = 1 + gBattleMailType.NORMAL, 1 + gBattleMailType.NORMAL
	;(1 + gBattleMailType.NORMAL).title = "mail_2_text_6"
	_ENV, (1 + gBattleMailType.NORMAL).tag = 1 + gBattleMailType.ALLIANCE, 1 + gBattleMailType.ALLIANCE
	;(1 + gBattleMailType.ALLIANCE).title = "mail_2_text_7"
	_ENV, (1 + gBattleMailType.ALLIANCE).tag = 1 + gBattleMailType.PALACE, 1 + gBattleMailType.PALACE
	;(1 + gBattleMailType.PALACE).title = "mail_2_text_8"
	_ENV, (1 + gBattleMailType.PALACE).tag = 1 + gBattleMailType.ESCORT, 1 + gBattleMailType.ESCORT
	;(1 + gBattleMailType.ESCORT).title = "mail_2_text_9"
	_ENV, (1 + gBattleMailType.ESCORT).tag = 1 + gBattleMailType.PLAYING, 1 + gBattleMailType.PLAYING
	;(1 + gBattleMailType.PLAYING).title = "mail_2_text_10"
	_ENV, (1 + gBattleMailType.PLAYING).tag = 1 + gBattleMailType.EXPLORE, 1 + gBattleMailType.EXPLORE
	;(1 + gBattleMailType.EXPLORE).title = "mail_2_text_11"
	;(1 + gBattleMailType.EXPLORE).tag = 1 + gBattleMailType.OTHER
	;(self.battleMailType + 1).childData, cc.size(360, 47)[1] = cc.size(360, 47), 360
	;(self.battleMailType + 1).childData, cc.size(360, 47)[2] = cc.size(360, 47), 47
	;(self.battleMailType + 1).childData, cc.size(360, 47)[3] = cc.size(360, 47), 1 + gBattleMailType.NORMAL
	;(self.battleMailType + 1).childData, cc.size(360, 47)[4] = cc.size(360, 47), 1 + gBattleMailType.ALLIANCE
	;(self.battleMailType + 1).childData, cc.size(360, 47)[5] = cc.size(360, 47), 1 + gBattleMailType.PALACE
	;(self.battleMailType + 1).childData, cc.size(360, 47)[6] = cc.size(360, 47), 1 + gBattleMailType.ESCORT
	;(self.battleMailType + 1).childData, cc.size(360, 47)[7] = cc.size(360, 47), 1 + gBattleMailType.PLAYING
	;(self.battleMailType + 1).childData, cc.size(360, 47)[8] = cc.size(360, 47), 1 + gBattleMailType.EXPLORE
	self.dropDownBox:initData(self.battleMailType + 1)
	self.dropDownBox:setDefaultIndex(self.battleMailType + 1)
	self.dropDownBox:addEventListener(handler(self, self.onSelDropDownBox))
	self.btnDelet = SoraDGetChildByName(self, "btn_del")
	self.btnDelet:setTitleText(i18n("mail_2_text_2"))
	SoraDAutoSizeButtonText(self.btnDelet, cc.size(210, 70))
	self.btnReadAndReceive = SoraDGetChildByName(self, "btn_onekey")
	self.btnReadAndReceive:setTitleText(i18n("mail_2_text_3"))
	SoraDAutoSizeButtonText(self.btnReadAndReceive, cc.size(210, 70))
	self.btnDelet:addTouchEventListener(handler(self, self.onBottomMenuEvent))
	self.btnReadAndReceive:addTouchEventListener(handler(self, self.onBottomMenuEvent))
	self:createRedPointLayer()
end
function mailView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAIL_UI_RED_POINT_EVENT", handler(self, self.msgRedPointEvent))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.msgUpdateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_ONKEY_VIEW_MAILS_SUCCESS", handler(self, self.msgOnkeyViewMailsSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_GET_EXTRA_SUCCESS", handler(self, self.msgGetExtraSuccess))
	SoraDAddMessage(self, "MESSAGE_MAIL_UI_UPDATE_EMPTY_TIP", handler(self, self.msgUpdateMailEmptyTip))
end
function mailView:createRedPointLayer()
	self.redPointLayer = include("commonRedPointLayer").new()
	self:addChild(self.redPointLayer, 10)
	self.redPointLayer:setPosition(cc.p(0, 0))
end
function mailView:initMailTabs()
	local singleWidth = 148
	local staticTabList = mailFunctions:getStaticTabList()
	local maxWidth = math.max(640, #staticTabList * singleWidth)
	self.scrollTab:setInnerContainerSize(cc.size(maxWidth, 67))
	for index, mailSetType in ipairs(staticTabList) do
		local single = self.nodeTabs[1]
		if index ~= 1 then
			single = self.nodeTabs[1]:clone()
			self.nodeTabs[index] = single
			single:addTo(self.scrollTab)
		end
		single.mailSetType = mailSetType
		single:setPosition(SoraDFPosX(maxWidth - (index - 1) * singleWidth, maxWidth), -2)
		self:initTabSingle(single, index)
		self:setItemSel(single, false)
	end
	local tabIndex = mailCtrl:getDefaultMailTabIndex()
	self:btnChooseClick(SoraDGetChildByName(self.nodeTabs[tabIndex], "Button_Choose"), ccui.TouchEventType.ended)
end
function mailView:setItemSel(nodeItem, isSel)
	SoraDGetChildByName(nodeItem, "Icon_Choose"):setVisible(isSel)
	SoraDGetChildByName(nodeItem, "Button_Choose"):setBright(not isSel)
	if isSel then
		nodeItem:setLocalZOrder(99)
		SoraDGetChildByName(nodeItem, "label_title"):setColor(cc.c3b(255, 245, 175))
		SoraDGetChildByName(nodeItem, "label_titleNum"):setColor(cc.c3b(255, 245, 175))
	else
		nodeItem:setLocalZOrder(1)
		SoraDGetChildByName(nodeItem, "label_title"):setColor(cc.c3b(144, 132, 97))
		SoraDGetChildByName(nodeItem, "label_titleNum"):setColor(cc.c3b(144, 132, 97))
	end
end
function mailView:initTabSingle(parent, index)
	local btnChoose = SoraDGetChildByName(parent, "Button_Choose")
	btnChoose:setTag(index)
	btnChoose:setSwallowTouches(false)
	btnChoose:addTouchEventListener(handler(self, self.btnChooseClick))
	local textName = SoraDGetChildByName(parent, "label_title")
	local mailSetType = parent.mailSetType
	local mailTitle = mailDesRead.getMailSetTitle(mailSetType)
	textName:setString(i18n(mailTitle))
	local btnNumberBg = SoraDGetChildByName(parent, "btnNumberBg")
	btnNumberBg:addTouchEventListener(handler(self, self.onBtnNumberBg))
	btnNumberBg:setSwallowTouches(true)
	btnNumberBg:setVisible(false)
	self:nodeTabSingleRefresh(parent, index)
end
function mailView:nodeTabSingleRefresh(parent, index)
	local textNumber = SoraDGetChildByName(parent, "label_titleNum")
	local mailSetType = parent.mailSetType
	local cur, total = mailCtrl:getMailCountPer(mailSetType)
	_ENV = nil
	;(nil).member = cur
	;(nil).total = total
	textNumber:setString("(" .. i18n("common_text_155", nil) .. ")")
	self:updateMailNumber(parent)
end
function mailView:updateMailNumber(parent)
	local imgNumberBg = SoraDGetChildByName(parent, "img_number")
	local label_number = SoraDGetChildByName(parent, "label_number")
	local btnNumberBg = SoraDGetChildByName(parent, "btnNumberBg")
	local numberOfUnRead = mailCtrl:getNewNumOfSet(parent.mailSetType)
	if 0 < numberOfUnRead then
		if 99 < numberOfUnRead then
			label_number:setString("99+")
		else
			label_number:setString(tostring(numberOfUnRead))
		end
		imgNumberBg:setVisible(true)
	else
		imgNumberBg:setVisible(false)
		btnNumberBg:setVisible(false)
	end
end
function mailView:initWithData()
	self:initMailTabs()
end
function mailView:updateScroll()
	self.emptyTipNode:setVisible(false)
	self.dropDownBox:setVisible(self.mailSetType == gMailSetType.NEW_BATTLE)
	self.scrollView:setMailSetType(self.mailSetType)
	self.scrollView:setMailSetKey(self.mailSetKey)
	self.scrollView:cleanAll(self.mailSetType == gMailSetType.NEW_BATTLE)
	mailCtrl:getMailList(nil, 20, self.mailSetType, self.mailSetKey)
end
function mailView:onBottomMenuEvent(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if target == self.btnDelet then
			local totalNum, _ = mailMgr:getMailSetNumInfo(self.mailSetType)
			if totalNum <= 0 then
				SoraDShowMsgTip(i18n("notice_0098"))
				return
			else
				SoraDShowMsgBox(i18n("mail_2_text_31"), i18n("common_text_054"), nil, handler(self, self.confirmDel))
			end
		elseif target == self.btnReadAndReceive then
			print("onBottomMenuEvent", self.mailSetType, self.mailSetKey)
			mailCtrl:viewMailSet(self.mailSetType, self.mailSetKey)
		end
	end
end
function mailView:confirmDel(type)
	if type == MSGBOX_CALLBACK_YES then
		mailCtrl:removeMailList(self.mailSetType, self.mailSetKey)
	end
end
function mailView:btnChooseClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		self.redPointLayer:hideRedPoint()
		self.redTouch = false
		local index = target:getTag()
		if self.tabIndex == index then
			return
		end
		SoraDShowLoading()
		if self.tabIndex > 0 and self.tabIndex <= #mailFunctions:getStaticTabList() then
			self:setItemSel(self.nodeTabs[self.tabIndex], false)
		end
		self.tabIndex = index
		if self.tabIndex ~= 4 then
			local percent = self.tabIndex > 4 and 100 or 0
			self.scrollTab:scrollToPercentHorizontal(SoraDFPosX(100 - percent, 100), 0, false)
		end
		self.mailSetType = self.nodeTabs[self.tabIndex].mailSetType
		if self.mailSetType ~= gMailSetType.NEW_BATTLE then
			self.mailSetKey = "key"
		else
			if 0 < self.battleMailType then
				self.mailSetKey = "battle" .. self.battleMailType
			else
				self.mailSetKey = "key"
			end
			self:refreshDropBox()
			self:refreshBattleRedIcon()
		end
		if tolua.type(self.mailSetType) ~= "table" then
			self:showMailFullTip(self.mailSetType)
		end
		self:setItemSel(self.nodeTabs[self.tabIndex], true)
		self:updateScroll()
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
function mailView:onTouchPanel(target, event)
	if event == ccui.TouchEventType.ended then
		if self.newIndex ~= self.tabIndex and not self.redTouch then
			self:btnChooseClick(SoraDGetChildByName(self.nodeTabs[self.newIndex], "Button_Choose"), ccui.TouchEventType.ended)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local touchDeltaX = touchmovePoint.x - touchBeganPoint.x
		local touchDeltaY = touchmovePoint.y - touchBeganPoint.y
		if self.isMoveH == false and self.isMoveV == false then
			if math.abs(touchDeltaX) >= self.judgeHMove and self.isMoveV == false and math.abs(touchDeltaY) < self.judgeVMove then
				self.isMoveH = true
				if SoraDFIsRA() then
					if 0 < touchDeltaX then
						self.newIndex = math.min(7, self.newIndex + 1)
					else
						self.newIndex = math.max(1, self.newIndex - 1)
					end
				elseif 0 < touchDeltaX then
					self.newIndex = math.max(1, self.newIndex - 1)
				else
					self.newIndex = math.min(7, self.newIndex + 1)
				end
			end
			if math.abs(touchDeltaX) < self.judgeHMove and math.abs(touchDeltaY) >= self.judgeVMove and self.isMoveH == false then
				self.isMoveV = true
			end
		end
	elseif event == ccui.TouchEventType.began then
		self.isMoveV = false
		self.isMoveH = false
		self.newIndex = self.tabIndex
	end
end
function mailView:refreshDropBox()
	mailCtrl, _UPVALUE8_ = nil, nil
	;(nil).newNum = mailCtrl:getNewNumOfSet(self.mailSetType)
	mailCtrl = self.mailSetType
	self.mailSetType.abbr = mailMgr:getMailSetNumInfo(self.mailSetType, "key")
	self.mailSetType.name = i18n("mail_2_text_4")
	;(nil).title = i18n("common_text_186", self.mailSetType)
	mailCtrl, (nil).tag = i18n("common_text_186", self.mailSetType), 1
	i18n("common_text_186", self.mailSetType).newNum = mailCtrl:getNewNumOfSet(self.mailSetType, "battle1")
	mailCtrl = self.mailSetType
	self.mailSetType.abbr = mailMgr:getMailSetNumInfo(self.mailSetType, "battle1")
	self.mailSetType.name = i18n("mail_2_text_5")
	i18n("common_text_186", self.mailSetType).title = i18n("common_text_186", self.mailSetType)
	mailCtrl, i18n("common_text_186", self.mailSetType).tag = 1 + gBattleMailType.NORMAL, 1 + gBattleMailType.NORMAL
	;(1 + gBattleMailType.NORMAL).newNum = mailCtrl:getNewNumOfSet(self.mailSetType, "battle2")
	mailCtrl = self.mailSetType
	self.mailSetType.abbr = mailMgr:getMailSetNumInfo(self.mailSetType, "battle2")
	self.mailSetType.name = i18n("mail_2_text_6")
	;(1 + gBattleMailType.NORMAL).title = i18n("common_text_186", self.mailSetType)
	mailCtrl, (1 + gBattleMailType.NORMAL).tag = 1 + gBattleMailType.ALLIANCE, 1 + gBattleMailType.ALLIANCE
	;(1 + gBattleMailType.ALLIANCE).newNum = mailCtrl:getNewNumOfSet(self.mailSetType, "battle3")
	mailCtrl = self.mailSetType
	self.mailSetType.abbr = mailMgr:getMailSetNumInfo(self.mailSetType, "battle3")
	self.mailSetType.name = i18n("mail_2_text_7")
	;(1 + gBattleMailType.ALLIANCE).title = i18n("common_text_186", self.mailSetType)
	mailCtrl, (1 + gBattleMailType.ALLIANCE).tag = 1 + gBattleMailType.PALACE, 1 + gBattleMailType.PALACE
	;(1 + gBattleMailType.PALACE).newNum = mailCtrl:getNewNumOfSet(self.mailSetType, "battle4")
	mailCtrl = self.mailSetType
	self.mailSetType.abbr = mailMgr:getMailSetNumInfo(self.mailSetType, "battle4")
	self.mailSetType.name = i18n("mail_2_text_8")
	;(1 + gBattleMailType.PALACE).title = i18n("common_text_186", self.mailSetType)
	mailCtrl, (1 + gBattleMailType.PALACE).tag = 1 + gBattleMailType.ESCORT, 1 + gBattleMailType.ESCORT
	;(1 + gBattleMailType.ESCORT).newNum = mailCtrl:getNewNumOfSet(self.mailSetType, "battle5")
	mailCtrl = self.mailSetType
	self.mailSetType.abbr = mailMgr:getMailSetNumInfo(self.mailSetType, "battle5")
	self.mailSetType.name = i18n("mail_2_text_9")
	;(1 + gBattleMailType.ESCORT).title = i18n("common_text_186", self.mailSetType)
	mailCtrl, (1 + gBattleMailType.ESCORT).tag = 1 + gBattleMailType.PLAYING, 1 + gBattleMailType.PLAYING
	;(1 + gBattleMailType.PLAYING).newNum = mailCtrl:getNewNumOfSet(self.mailSetType, "battle6")
	mailCtrl = self.mailSetType
	self.mailSetType.abbr = mailMgr:getMailSetNumInfo(self.mailSetType, "battle6")
	self.mailSetType.name = i18n("mail_2_text_10")
	;(1 + gBattleMailType.PLAYING).title = i18n("common_text_186", self.mailSetType)
	mailCtrl, (1 + gBattleMailType.PLAYING).tag = 1 + gBattleMailType.EXPLORE, 1 + gBattleMailType.EXPLORE
	;(1 + gBattleMailType.EXPLORE).newNum = mailCtrl:getNewNumOfSet(self.mailSetType, "battle7")
	mailCtrl = self.mailSetType
	self.mailSetType.abbr = mailMgr:getMailSetNumInfo(self.mailSetType, "battle7")
	self.mailSetType.name = i18n("mail_2_text_11")
	;(1 + gBattleMailType.EXPLORE).title = i18n("common_text_186", self.mailSetType)
	;(1 + gBattleMailType.EXPLORE).tag = 1 + gBattleMailType.OTHER
	;(nil)[1] = nil
	;(nil)[2] = i18n("common_text_186", self.mailSetType)
	;(nil)[3] = 1 + gBattleMailType.NORMAL
	;(nil)[4] = 1 + gBattleMailType.ALLIANCE
	;(nil)[5] = 1 + gBattleMailType.PALACE
	;(nil)[6] = 1 + gBattleMailType.ESCORT
	;(nil)[7] = 1 + gBattleMailType.PLAYING
	;(nil)[8] = 1 + gBattleMailType.EXPLORE
	self.dropDownBox:refreshData(nil)
end
function mailView:onSelDropDownBox(tag)
	print("选择了---------", tag)
	self.battleMailType = tag - 1
	if self.battleMailType > 0 then
		self.mailSetKey = "battle" .. self.battleMailType
	else
		self.mailSetKey = "key"
	end
	self:refreshBattleRedIcon()
	self:updateScroll()
end
function mailView:refreshBattleRedIcon()
	local redIcon = self.dropDownBox:getChildByName("img_number")
	local newNum = mailCtrl:getNewNumOfSet(self.mailSetType, self.mailSetKey)
	redIcon:setVisible(0 < newNum)
	local label_number = redIcon:getChildByName("label_number")
	if 99 < newNum then
		label_number:setString("99+")
	else
		label_number:setString(tostring(newNum))
	end
end
function mailView:onBtnNumberBg(sender, event)
end
function mailView:showMailFullTip(mailSetType)
	local needPopUp = mailCtrl:isWillFull(mailSetType)
	if needPopUp then
		SoraDShowMsgBox(i18n("common_text_791"), i18n("common_text_204"))
	end
end
function mailView:msgOnkeyViewMailsSuccess(target, data)
	local extras = data.extras
	if extras ~= nil and next(extras) ~= nil then
		SoraDMailGainItems(extras, true)
	end
end
function mailView:msgGetExtraSuccess(target, data)
	local mail = mailMgr:queryMail(data.mid)
	if mail == nil then
		return
	end
	local equipDesRead = include("equipDesRead")
	local extra = mail:getProperty("extra")
	for i, v in ipairs(extra) do
		if tonumber(v.id) >= 40000091 and tonumber(v.id) <= 40003102 then
			v.equipQuality = equipDesRead.getEquipQuality(tonumber(v.id))
			v.id = equipDesRead.getEquipQualityCfgID(tonumber(v.id))
		end
	end
	SoraDMailGainItems(extra, true)
end
function mailView:msgShowLoading(target, data)
	SoraDShowLoading(self)
end
function mailView:msgCloseLoading(target, data)
	SoraDCloseLoading(self)
end
function mailView:msgUpdateRedPoint(target, data)
	if data.type == GREEN_POINT_NOTICE_TYPE.MAIL then
		for index, target in ipairs(self.nodeTabs) do
			self:nodeTabSingleRefresh(target, index)
		end
		self:refreshDropBox()
		self:refreshBattleRedIcon()
	end
end
function mailView:msgUpdateMailEmptyTip(target, data)
	local isShow = data.isShow
	if isShow == true then
		self.emptyTipNode:setVisible(true)
	else
		self.emptyTipNode:setVisible(false)
	end
end
function mailView:msgRedPointEvent(target, data)
	dump(data, "mailView:msgRedPointEvent", 10)
	local event = data.event
	local _ENV, touchInfo = data, data
	touchInfo.sender = data.sender
	touchInfo.event = event
	if event == ccui.TouchEventType.began then
		touchInfo.number = data.number
		touchInfo.centerPos = self.redPointLayer:convertToNodeSpace(data.sourcePoint)
		touchInfo.mailItem = data.mailItem
		touchInfo.otherData = data.otherData
		touchInfo.callBack = handler(self, self.redPointCallBack)
		self.redPointLayer:initWithData(touchInfo)
		self.redTouch = true
	elseif event == ccui.TouchEventType.canceled or event == ccui.TouchEventType.ended then
		self.redTouch = false
	end
	self.redPointLayer:touchCallBack(touchInfo)
end
function mailView:redPointCallBack(event)
	local eventType = event.eventType
	local mail = event.otherData
	dump(mail, "mail")
	local mailSetType = mail:getProperty("mailSetType")
	if eventType == REDPOINT_VANISH then
		if gMailSetTypeFunc.isReportSetBySetType(mailSetType) then
			mailCtrl = nil
			;(nil)[1] = mailSetType
			mailCtrl:viewMailSet(nil)
		else
			mailCtrl:viewMail(mail:getProperty("mid"))
		end
	end
	self.redTouch = false
end
function mailView:msgCloseView(target, data)
end
function mailView:onExitPanel()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:mailView:saveMailSetType~integer", self.tabIndex, nil)
end
return mailView
