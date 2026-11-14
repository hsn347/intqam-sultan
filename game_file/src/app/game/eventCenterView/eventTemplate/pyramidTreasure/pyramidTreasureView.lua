local pyramidRareTreasureCtrl = SoraDGetCtrl("pyramidRareTreasureCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local pyramidTreasureRead = include("pyramidTreasureRead")
local pyramidTreasureView = class("pyramidTreasureView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidTreasureView")
	end
	return target
end)
function pyramidTreasureView:ctor()
	self.tableItem, _ENV, self.activityID = gActivityTimeActivityID.PYRAMID_TREASURE_ACTIVITY, gActivityTimeActivityID.PYRAMID_TREASURE_ACTIVITY, gActivityTimeActivityID.PYRAMID_TREASURE_ACTIVITY
	self.isEnoughOne = false
	self.isEnoughTen = false
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_event")
	self.ccs_title:setTitle(i18n("activity_name_9001314"))
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.Text_left = SoraDGetChildByName(self, "Text_left")
	self.Text_left:setString(i18n("rides_text_09"))
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.icon_hourglass = SoraDGetChildByName(self, "icon_hourglass")
	self.Button_record = SoraDGetChildByName(self, "Button_record")
	self.Button_record:addTouchEventListener(handler(self, self.btnRecordClick))
	self.Button_shop = SoraDGetChildByName(self, "Button_shop")
	self.Button_shop:addTouchEventListener(handler(self, self.btnShopClick))
	self.Button_coin = SoraDGetChildByName(self, "Button_coin")
	self.Button_coin:addTouchEventListener(handler(self, self.btnCoinClick))
	self.Text_coin = SoraDGetChildByName(self, "Text_coin")
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.Text_times = SoraDGetChildByName(self, "Text_times")
	self.Button_addTimes = SoraDGetChildByName(self, "Button_addTimes")
	self.Button_addTimes:addTouchEventListener(handler(self, self.onAddTimesClick))
	self.Button_select = SoraDGetChildByName(self, "Button_select")
	self.Button_select:setTitleText(i18n("Pyramid_treasure_text_14"))
	self.Button_select:addTouchEventListener(handler(self, self.btnAddClick))
	self.ccs_btnDraw = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_draw")
	self.ccs_btnDraw:addTouchEventListener(handler(self, self.btnDrawClick))
	self.ccs_btnDrawTen = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_drawTen")
	self.ccs_btnDrawTen:addTouchEventListener(handler(self, self.btnDrawTenClick))
	self.Node_other = SoraDGetChildByName(self, "Node_other")
	self.Node_coin = SoraDGetChildByName(self, "Node_coin")
	self.Node_jp = SoraDGetChildByName(self, "Node_jp")
	self.Node_add = SoraDGetChildByName(self.Node_jp, "Node_add")
	self.Button_add = SoraDGetChildByName(self.Node_add, "Button_add")
	self.Button_add:addTouchEventListener(handler(self, self.btnAddClick))
	self.Top_Node_item = SoraDGetChildByName(self, "Top_Node_item")
	self.Node_change = SoraDGetChildByName(self.Node_jp, "Node_change")
	self.Button_change = SoraDGetChildByName(self.Node_jp, "Button_change")
	self.Button_change:addTouchEventListener(handler(self, self.btnAddClick))
	self.ccs_jp = SoraDGetExtendChildFromCCSByName(self.Node_jp, "CCS_commonItemAward_jp")
	self.tableItem[1] = self.ccs_jp
	self.ccs_jz = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward_jz")
	self.tableItem[2] = self.ccs_jz
	self.Node_bgEffect = SoraDGetChildByName(self, "Node_bgEffect")
	SoraDCreatAnimation("animationJZTBZBG"):addTo(self.Node_bgEffect)
	self.Node_etJZD = SoraDGetChildByName(self, "Node_etJZD")
	SoraDCreatAnimation("animationJZTBZJZD"):addTo(self.Node_etJZD)
	self.Node_etJZ = SoraDGetChildByName(self, "Node_etJZ")
	SoraDCreatAnimation("animationJZTBZJZ"):addTo(self.Node_etJZ)
	self.Node_etJP = SoraDGetChildByName(self, "Node_etJP")
	SoraDCreatAnimation("animationJZTXZD"):addTo(self.Node_etJP)
	self.Node_etAdd = SoraDGetChildByName(self, "Node_etAdd")
	SoraDCreatAnimation("animationJZTBZADD"):addTo(self.Node_etAdd)
	self.Node_etAdd:setVisible(false)
	self:suitView()
	self:setTime()
	self:initData()
	self:setNormalItem()
end
function pyramidTreasureView:suitView()
	self.Node_other:setPositionY(-display.height + 370)
	if display.height > 1136 then
		self.Node_other:setPositionY(math.max(-display.height + 370, -750))
	end
	if display.height < 960 then
		self.Node_other:setScale(0.8)
		self.Node_other:setPositionY(-display.height + 325)
	end
end
function pyramidTreasureView:setTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
	self.icon_hourglass:setPositionX(self.Text_time:getPositionX() + self.Text_time:getContentSize().width + 20)
	if SoraDFIsRA() then
		self.icon_hourglass:setPositionX(self.Text_time:getPositionX() - self.Text_time:getContentSize().width - 20)
	end
end
function pyramidTreasureView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMID_TREASURE_BESTTREASURE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMID_TREASURE_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMID_TREASURE_EFFECT_ITEM", handler(self, self.playAwardItem))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMID_TREASURE_EFFECT", handler(self, self.playAwardItem_Key))
end
function pyramidTreasureView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
function pyramidTreasureView:initData()
	self:setAmazyTreasure()
	local times = pyramidRareTreasureCtrl:getLotternTimes()
	pyramidRareTreasureCtrl = nil
	;(nil).count = string.formatnumberthousands(times)
	self.Text_times:setString(i18n("common_text_1673", nil))
	self.Button_addTimes:setPositionX(SoraDFPosX(-self.Text_times:getContentSize().width / 2 - 30, 0))
	self.isEnoughOne = 1 <= times
	self.isEnoughTen = 10 <= times
	pyramidRareTreasureCtrl = SoraDFPosX(-self.Text_times:getContentSize().width / 2 - 30, 0)
	pyramidRareTreasureCtrl = SoraDFPosX(-self.Text_times:getContentSize().width / 2 - 30, 0)
	SoraDFPosX(-self.Text_times:getContentSize().width / 2 - 30, 0).num = 1
	SoraDFPosX(-self.Text_times:getContentSize().width / 2 - 30, 0).title = i18n("Pyramid_treasure_btn_01", SoraDFPosX(-self.Text_times:getContentSize().width / 2 - 30, 0))
	SoraDFPosX(-self.Text_times:getContentSize().width / 2 - 30, 0).icon = "1616.png"
	self.ccs_btnDraw:initData(SoraDFPosX(-self.Text_times:getContentSize().width / 2 - 30, 0))
	self.ccs_btnDraw:setGoldText(string.format("%s/%d", string.formatnumberthousands(times), 1))
	self.ccs_btnDraw:setTextGoldColor(self.isEnoughOne and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
	pyramidRareTreasureCtrl = self.isEnoughOne and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40)
	pyramidRareTreasureCtrl = 40
	;(40).num = 10
	;(self.isEnoughOne and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40)).title = i18n("Pyramid_treasure_btn_01", 40)
	;(self.isEnoughOne and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40)).icon = "1616.png"
	self.ccs_btnDrawTen:initData(self.isEnoughOne and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40), 1)
	self.ccs_btnDrawTen:setGoldText(string.format("%s/%d", string.formatnumberthousands(times), 10))
	self.ccs_btnDrawTen:setTextGoldColor(self.isEnoughTen and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
	local lockCoin = pyramidRareTreasureCtrl:getLockLuckyCoin()
	pyramidRareTreasureCtrl = 40
	;(40).num = lockCoin
	self.Text_coin:setString(i18n("Pyramid_treasure_text_08", 40))
end
function pyramidTreasureView:playAwardItem_Key(target, data)
	local unlockedLuckyCoin = data.unlockedLuckyCoin or 0
	local targetPos = SoraDCoverToPoint(self.Top_Node, cc.p(self.Node_coin:getPositionX(), self.Node_coin:getPositionY()), self.Node_other)
	self:playAwardItem_imp(2, targetPos, unlockedLuckyCoin)
	self:showWaggleEffect()
end
function pyramidTreasureView:showWaggleEffect()
	self.Node_coin:stopAllActions()
	_UPVALUE6_ = self.Node_coin
	self.Node_coin[1] = cca.delay(2.8333333333333335)
	self.Node_coin[2] = cca.rotateTo(0.25, 10)
	self.Node_coin[3] = cca.rotateTo(0.21666666666666667, -10)
	self.Node_coin[4] = cca.rotateTo(0.2, 8)
	self.Node_coin[5] = cca.rotateTo(0.16666666666666666, -5)
	self.Node_coin[6] = cca.rotateTo(0.15, 2)
	self.Node_coin[7] = cca.rotateTo(0.15, 0)
	self.Node_coin[8] = cca.rotateTo(0.15, 0)
	self.Node_coin[9] = cca.rotateTo(0.15, 0)
	local seq = cca.seq(self.Node_coin)
	self.Node_coin:runAction(seq)
end
function pyramidTreasureView:playAwardItem(target, data)
	local index = data.index or 1
	local targetPos = cc.p(0, -1000)
	self:playAwardItem_imp(index, targetPos)
end
function pyramidTreasureView:playAwardItem_imp(index, targetPos, unlockedLuckyCoin)
	local targetItem = self.tableItem[index]
	local id, count = targetItem:getData()
	if targetItem and id then
		local showItem
		local isLuck = pyramidTreasureRead.isJZIndex(index)
		if isLuck then
			local single = SoraDGetChildByName(targetItem, "Image_icon")
			showItem = single:clone()
		else
			showItem = include("commonItemAward").new()
			showItem:initData(id, count)
			showItem:setScale(0.9)
			showItem:setTouchEnabled(false)
		end
		local pos = SoraDCoverToPoint(self.Node_other, cc.p(targetItem:getPositionX(), targetItem:getPositionY()), self.Node_other)
		if index == 1 then
			pos = SoraDCoverToPoint(self.Top_Node_item, cc.p(self.Node_jp:getPositionX(), self.Node_jp:getPositionY()), self.Node_other)
		end
		showItem:setPosition(pos.x, pos.y)
		showItem:addTo(self.Node_other, 2)
		_UPVALUE7_ = showItem.addTo
		showItem.addTo[1] = cca.delay(0.2)
		showItem.addTo[2] = cca.callFunc(function()
			if showItem.showEffect then
				showItem:showEffect()
			end
		end)
		showItem.addTo[3] = cc.EaseExponentialOut:create(cca.moveTo(0.5, 0, math.max(160, (display.height - 640) / 2)))
		showItem.addTo[4] = cca.delay(1.2)
		showItem.addTo[5] = cc.EaseExponentialIn:create(cca.moveTo(0.5, targetPos.x, targetPos.y))
		showItem.addTo[6] = cc.EaseExponentialIn:create(cca.scaleTo(0.5, 0.25))
		showItem.addTo[7] = cca.delay(0.25)
		showItem.addTo[8] = cca.callFunc(function()
			showItem:removeFromParent()
		end)
		showItem.addTo[9] = cca.callFunc(function()
			showItem:removeFromParent()
		end)
		local showItem.addTo[10], action = cca.callFunc(function()
			showItem:removeFromParent()
		end)
		if isLuck and unlockedLuckyCoin and 0 < unlockedLuckyCoin then
			action[#action + 1] = cca.callFunc(function()
				_ENV = nil
				;(nil).num = unlockedLuckyCoin
				SoraDShowMsgTip(i18n("Pyramid_treasure_text_12", nil))
			end)
		end
		local seq = cca.seq(action)
		showItem:runAction(seq)
	end
end
function pyramidTreasureView:setAmazyTreasure()
	local hasBest = pyramidRareTreasureCtrl:hasBestTreasureID()
	self.Node_add:setVisible(not hasBest)
	self.Node_etAdd:setVisible(not hasBest)
	self.Node_change:setVisible(hasBest)
	self.ccs_jp:setVisible(hasBest)
	self.Button_select:setVisible(not hasBest)
	self.ccs_btnDraw:setVisible(hasBest)
	self.ccs_btnDrawTen:setVisible(hasBest)
	if hasBest then
		local bestIndex = pyramidRareTreasureCtrl:getBestTreasureID()
		local id, count = pyramidTreasureRead.getBestCfg(bestIndex)
		self.ccs_jp:setOwnView(self)
		self.ccs_jp:initData(id, count)
	end
end
function pyramidTreasureView:setNormalItem()
	local id, count = pyramidTreasureRead.getBDYConfig()
	self.ccs_jz:setOwnView(self)
	self.ccs_jz:initData(id, count)
	local config = pyramidTreasureRead.getNormalConfig()
	for k, v in ipairs(config) do
		local item = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward_" .. k)
		if item then
			item:setOwnView(self)
			item:initData(v.id, v.count)
			item:setSpecialQualityBg()
		end
		table.insert(self.tableItem, item)
	end
end
function pyramidTreasureView:btnAddClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("pyramidTreasureChooseView"):show()
	end
end
function pyramidTreasureView:btnDrawClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isEnoughOne then
			pyramidRareTreasureCtrl:reqTreasureLottory()
		else
			SoraDShowMsgTip(i18n("common_text_4443"))
		end
	end
end
function pyramidTreasureView:btnDrawTenClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isEnoughTen then
			pyramidRareTreasureCtrl:reqTreasureLottoryTen()
		else
			SoraDShowMsgTip(i18n("common_text_4443"))
		end
	end
end
function pyramidTreasureView:btnRecordClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("pyramidTreasureRecordView"):show()
	end
end
function pyramidTreasureView:btnShopClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("pyramidTreasureShopView"):show()
	end
end
function pyramidTreasureView:btnCoinClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "Pyramid_treasure_text_09"
		;("Pyramid_treasure_text_09").align = SoraDFIsRA() and 2 or 0
		;("Pyramid_treasure_text_09").activityID = self.activityID
		SoraDShowHelpMsgTip(i18n("Pyramid_treasure_text_09"), "Pyramid_treasure_text_09")
	end
end
function pyramidTreasureView:btnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "Pyramid_treasure_text_01"
		;("Pyramid_treasure_text_01").align = SoraDFIsRA() and 2 or 0
		;("Pyramid_treasure_text_01").activityID = self.activityID
		SoraDShowHelpMsgTip(i18n("Pyramid_treasure_text_01"), "Pyramid_treasure_text_01")
	end
end
function pyramidTreasureView:onAddTimesClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_UPVALUE3_ = SoraDPlaySound
		SoraDPlaySound[1] = 14147
		SoraDPlaySound[2] = 14148
		local SoraDPlaySound[3], giftArray = 14149, SoraDPlaySound
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).rechargeIDList = giftArray
			uiManager:show("rechargeView", nil)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNodeByList(12, giftArray)
			panel:show()
		end
	end
end
return pyramidTreasureView
