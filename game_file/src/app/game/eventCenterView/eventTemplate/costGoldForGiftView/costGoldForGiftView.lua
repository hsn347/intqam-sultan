local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local costGoldForGiftCtrl = gametop.playertop_:getModule("costGoldForGiftCtrl")
local costGoldForGiftView = class("costGoldForGiftView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("costGoldForGiftView")
	end
	return target
end)
function costGoldForGiftView:ctor()
	self:initControls()
	self:initScroll()
end
function costGoldForGiftView:initControls()
	self.txtTime = SoraDGetChildByName(self, "Text_title")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.panelSingle = SoraDGetChildByName(self, "panel_single")
	self.panelBox = SoraDGetChildByName(self, "panel_graduation")
	self.btnQuest = SoraDGetChildByName(self, "btn_quest")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_eventCenter")
	self.costPointer = SoraDGetChildByName(self, "frame_totalCost")
	self.smallPointer = SoraDGetChildByName(self, "frame_main_integration_arrow_39")
	self.progressBar = SoraDGetChildByName(self, "LoadingBar_10")
	self.scroll = SoraDGetChildByName(self, "Top_Size_scrollView_content")
	self.cellScroll = SoraDGetChildByName(self, "ScrollView_5")
	self.imageProgress = SoraDGetChildByName(self, "image_progressBg")
	self.txtCostGold = SoraDGetChildByName(self, "text_totalCost")
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	local costGoldTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.COST_GOLD_FOR_GIFT)
	if costGoldTime then
		self.txtTime:beginTime(costGoldTime.timerNode.timer:getRemainTime())
		self.txtTime:setTimeEndListener(function(...)
			self:removeFromParent()
		end)
	end
	self.nodeTitle:setTitle(i18n("consume_gold_text_01"))
	self.btnQuest:addTouchEventListener(handler(self, self.questClickCallBack))
	self.buyGrade = 1
end
function costGoldForGiftView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_COST_GOLD_REFRESH_BACK", handler(self, self.refreshData))
end
function costGoldForGiftView:initScroll()
	local playerCostGoldNum = costGoldForGiftCtrl:getPlayerSpendGoldNum()
	local costGoldInfo = costGoldForGiftCtrl:getCostGoldInfo()
	local pbSize = self.progressBar:getContentSize()
	local index = 0
	costGoldForGiftCtrl = nil
	;(nil).num = string.formatnumberthousands(playerCostGoldNum)
	self.txtCostGold:setString(i18n("alliance_mobilize_des_18", nil))
	if SoraDGetDefaultLanguage() == "ru" then
		self.txtCostGold:setFontSize(14)
	end
	self.scroll:removeAllChildren()
	local scrollH = math.max(self.scroll:getContentSize().height, 220 * #costGoldInfo)
	self.scroll:setInnerContainerSize(cc.size(display.width, scrollH))
	for i = 1, #costGoldInfo do
		local cell = self.panelSingle:clone()
		cell:addTo(self.scroll, #costGoldInfo - i)
		cell:setPosition(cc.p(display.width / 2, scrollH - 220 * (i - 1)))
		local cellScroll = SoraDGetChildByName(cell, "ScrollView_5")
		local celltxtTitle = SoraDGetChildByName(cell, "text_grade")
		local cellGold = SoraDGetChildByName(cell, "icon_recharge_gold_01_157")
		local cellBg = SoraDGetChildByName(cell, "Image_smallBg")
		cellBg:setFillType(1)
		local strTitle = string.format("%s%d", i18n("consume_gold_text_02"), costGoldInfo[i].needgold)
		celltxtTitle:setString(strTitle)
		SoraDSetGray(cellGold, playerCostGoldNum >= costGoldInfo[i].needgold)
		celltxtTitle:setColor(playerCostGoldNum >= costGoldInfo[i].needgold and cc.c3b(120, 120, 120) or cc.c3b(255, 200, 100))
		local box = self.panelBox:clone()
		local line = SoraDGetChildByName(box, "frame_graduation")
		local iconBox = SoraDGetChildByName(box, "icon_graduation")
		if playerCostGoldNum >= costGoldInfo[i].needgold then
			iconBox:setSpriteFrame("icon_king_road_box_03.png")
			index = index + 1
			self.buyGrade = self.buyGrade + 1
		end
		if i == #costGoldInfo then
			line:setVisible(false)
		end
		box:addTo(self.imageProgress)
		box:setPosition(cc.p(math.floor(pbSize.width / #costGoldInfo) * i, -80))
		local txtBox = SoraDGetChildByName(box, "text_task")
		local strBox = string.format("%d th", i)
		if i == 1 then
			strBox = string.format("%d st", i)
		elseif i == 2 then
			strBox = string.format("%d nd", i)
		elseif i == 3 then
			strBox = string.format("%d rd", i)
		end
		txtBox:setString(strBox)
		local isPass = false
		isPass = playerCostGoldNum >= costGoldInfo[i].needgold
		self:initCellScroll(cellScroll, costGoldInfo[i].rewardItems, isPass)
	end
	local pastPercent = index / #costGoldInfo
	local notPastPercent = 0
	if index >= #costGoldInfo then
		self.progressBar:setPercent((pastPercent + notPastPercent) * 100)
	elseif index == 0 then
		notPastPercent = playerCostGoldNum / costGoldInfo[1].needgold / #costGoldInfo
		self.progressBar:setPercent((pastPercent + notPastPercent) * 100)
	else
		notPastPercent = (playerCostGoldNum - costGoldInfo[index].needgold) / (costGoldInfo[index + 1].needgold - costGoldInfo[index].needgold) / #costGoldInfo
		self.progressBar:setPercent((pastPercent + notPastPercent) * 100)
	end
	self.costPointer:setPositionX(pbSize.width * self.progressBar:getPercent() / 100 + 5)
	self.smallPointer:setPositionX(pbSize.width * self.progressBar:getPercent() / 100 + 5)
	if self.progressBar:getPercent() < 10 then
		self.costPointer:setPositionX(54)
	elseif self.progressBar:getPercent() > 90 then
		self.costPointer:setPositionX(499)
	end
	self:ScrollViewJumpToRightPos(#costGoldInfo)
end
function costGoldForGiftView:initCellScroll(myDarling, smallData, isPass)
	myDarling:removeAllChildren()
	local scrollW = math.max(myDarling:getContentSize().width, 120 * #smallData)
	myDarling:setInnerContainerSize(cc.size(scrollW, myDarling:getContentSize().height))
	myDarling:setBounceEnabled(5 < #smallData)
	for i = 1, #smallData do
		local cellSingle = SoraDCreatePanel("eventGeocentricCell")
		cellSingle:initData(smallData[i].id, smallData[i].count)
		cellSingle:setClickDelegate(handler(self, self.singleCellClick))
		cellSingle:sendParentToButton(self)
		cellSingle:setPosition(cc.p(120 * (i - 1) + 2, myDarling:getContentSize().height - 4))
		cellSingle:addTo(myDarling)
		cellSingle.nodeItem:setColor(isPass and cc.c3b(120, 120, 120) or cc.c3b(255, 255, 255))
		local iconPass = display.newSprite("#icon_czhl_g.png")
		iconPass:addTo(cellSingle, 10)
		iconPass:setPosition(cc.p(80, -80))
		iconPass:setScale(0.5)
		iconPass:setVisible(isPass)
	end
end
function costGoldForGiftView:singleCellClick(pItem)
end
function costGoldForGiftView:ScrollViewJumpToRightPos(tabNum)
	local scrollInner = self.scroll:getInnerContainer()
	local scrollInnerNewH = math.max(220 * tabNum, self.scroll:getContentSize().height)
	self.rightPosY = scrollInnerNewH - 220 * self.buyGrade
	if self.rightPosY > 0 and self.buyGrade > 1 then
		local scrollPercent = 100 * (1 - self.rightPosY / scrollInner:getContentSize().height)
		scrollPercent = math.min(100, math.max(0, scrollPercent))
		self.scroll:scrollToPercentVertical(scrollPercent, 0.2, true)
	end
	if self.buyGrade >= 5 then
		self.scroll:jumpToBottom()
	end
end
function costGoldForGiftView:questClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("consume_gold_text_03"))
	end
end
function costGoldForGiftView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.COST_GOLD_FOR_GIFT) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function costGoldForGiftView:refreshData(target, data)
	self:initScroll()
end
return costGoldForGiftView
