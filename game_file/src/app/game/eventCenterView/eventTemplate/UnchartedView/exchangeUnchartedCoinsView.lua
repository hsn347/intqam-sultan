local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local pyramidCtrl = gametop.playertop_:getModule("pyramidCtrl")
local unchartedCtrl = gametop.playertop_:getModule("unchartedCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local unchartedAdventureRead = include("unchartedAdventureRead")
local exchangeUnchartedCoinsView = class("exchangeUnchartedCoinsView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("exchangeUnchartedCoinsView")
	end
	return target
end)
function exchangeUnchartedCoinsView:ctor()
	self:initControls()
	self:initData()
end
function exchangeUnchartedCoinsView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_UNCHARTED_HELP_BUY_BACK", function(target, data)
		self:getCoinsOrCountsAnimation(200)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_UNCHARTED_SHOP_BUY_BACK", handler(self, self.initData))
end
function exchangeUnchartedCoinsView:initControls()
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_gold")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_eventCenter")
	self.btnQuest = SoraDGetChildByName(self, "btn_quest")
	self.btnStore = SoraDGetChildByName(self, "btn_store")
	SoraDAutoSizeButtonText(self.btnStore, cc.size(160, 60))
	self.btnGold = SoraDGetChildByName(self, "btn_goldBuy")
	self.btnCopper = SoraDGetChildByName(self, "btn_copperBuy")
	self.panelDown = SoraDGetChildByName(self, "panel_down")
	self.txtIng = SoraDGetChildByName(self, "text_ing")
	self.txtClear = SoraDGetChildByName(self, "text_clear")
	SoraDSetTextWidthHeight(self.txtClear, cc.size(400, 60))
	self.txtDes = SoraDGetChildByName(self, "text_des")
	self.txtCoinRemain = SoraDGetChildByName(self, "text_unchartedCoinRemain")
	self.txtGoldRemainTimes = SoraDGetChildByName(self, "text_goldRemainTimes")
	self.txtCopperRemainTimes = SoraDGetChildByName(self, "text_copperRemainTimes")
	self.txtGoldExchangeNum = SoraDGetChildByName(self, "text_buyCost")
	self.txtcopperExchangeNum = SoraDGetChildByName(self, "text_copperCost")
	self.txtGoldUnchartedNum = SoraDGetChildByName(self, "text_goldUncharted")
	self.txtCopperUnchartedNum = SoraDGetChildByName(self, "text_copperUncharted")
	self.scroll = SoraDGetChildByName(self, "ScrollView_3")
	if display.height > 960 then
		self.scroll:setPositionY(self.scroll:getPositionY() + 100)
	end
	self.txtTime = SoraDGetChildByName(self, "text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.imageIconBg = SoraDGetChildByName(self, "Image_4")
	self.bg = SoraDGetChildByName(self, "Image_bg")
	self.btnQuest:addTouchEventListener(handler(self, self.questClickCallBack))
	self.btnStore:addTouchEventListener(handler(self, self.storeClickCallBack))
	self.btnGold:addTouchEventListener(handler(self, self.goldClickCallBack))
	self.btnCopper:addTouchEventListener(handler(self, self.goldClickCallBack))
	self.nodeTitle:setTitle(i18n("secret_explore_assistance_text_01"))
	self.btnStore:setTitleText(i18n("secret_explore_assistance_text_05"))
	self.txtIng:setString(i18n("secret_explore_assistance_text_03"))
	self.txtClear:setString(i18n("secret_explore_assistance_text_02"))
	self.txtDes:setString(i18n("secret_explore_assistance_text_04"))
	self.btnGold:setTag(gItemType.GOLD)
	self.btnCopper:setTag(gItemType.COPPER)
	self.bg:setFillType(1)
	local helpTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.UNCHARTED_HELP)
	if helpTime then
		self.txtTime:setTimeLast(function(str)
			_ENV = nil
			;(nil).time = str
			return i18n("common_text_607", nil)
		end)
		self.txtTime:beginTime(helpTime.timerNode.timer:getRemainTime())
		self.txtTime:setTimeEndListener(function(...)
			self:removeFromParent()
		end)
	end
	self.resImgArray, _ENV = self.txtTime.setTimeEndListener, self.txtTime.setTimeEndListener
	self.allItemList = require("app." .. LocalTblPath .. ".config_server.secret_explore_shop")
end
function exchangeUnchartedCoinsView:initData()
	local MissRightTable = self:chooseThreeItems()
	local helpData = unchartedCtrl:getUnchartedHelpInfo()
	local unchartedInfo = unchartedCtrl:getUnchartedInfo()
	local exchangeList = unchartedAdventureRead.getExchangeCoinList()
	self.scroll:removeAllChildren()
	local scrollH = math.max(#helpData * 150 + 50, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(scrollH, self.scroll:getContentSize().height))
	self.scroll:setBounceEnabled(4 < #helpData)
	self.txtGoldUnchartedNum:setString(exchangeList[1].num1)
	self.txtGoldExchangeNum:setString(exchangeList[1].num2)
	self.txtCopperUnchartedNum:setString(exchangeList[2].num1)
	self.txtcopperExchangeNum:setString(exchangeList[2].num2)
	self.txtCoinRemain:setString(unchartedInfo.coin)
	for i = 1, #helpData do
		local singleItem = include("itemSingleView").new()
		singleItem:setItemDelegate(handler(self, self.singleItemClick))
		singleItem:setRechargeUse(true)
		singleItem:setButtonTag(MissRightTable[i].Item[1])
		singleItem:sendParentToButton(self)
		singleItem:setScale(0.6)
		singleItem:addTo(self.scroll)
		singleItem:setPosition(cc.p(50 + (i - 1) * 150, 120))
		singleItem:initRechargeForRewardData(MissRightTable[i].Item[1], MissRightTable[i].Item[2])
		unchartedCtrl = singleItem
		singleItem.text = string.format("%d%%", helpData[i].rate / 10)
		singleItem.size = 22
		singleItem.align = cc.ui.TEXT_ALIGN_CENTER
		singleItem.color = cc.c3b(255, 204, 0)
		local labelDisCount = cc.ui.UILabel.new(singleItem)
		labelDisCount:addTo(self.scroll)
		labelDisCount:setPosition(cc.p(70 + (i - 1) * 150, 135))
		unchartedCtrl = labelDisCount
		labelDisCount.text = string.format("%d", MissRightTable[i].NeedPoint)
		labelDisCount.size = 20
		labelDisCount.align = cc.ui.TEXT_ALIGN_CENTER
		labelDisCount.color = cc.c3b(255, 255, 255)
		local labelOriPrice = cc.ui.UILabel.new(labelDisCount)
		labelOriPrice:addTo(self.scroll)
		labelOriPrice:setPosition(cc.p(50 + (i - 1) * 150, 10))
		if helpData[i].price == "" then
			helpData[i].price = MissRightTable[i].NeedPoint
		end
		if MissRightTable[i].NeedPoint ~= helpData[i].price then
			local spriteLine = display.newSprite("#frame_merchant_08.png")
			spriteLine:addTo(self.scroll)
			spriteLine:setPosition(cc.p(70 + (i - 1) * 150, 10))
			unchartedCtrl = spriteLine
			spriteLine.text = string.format("%d", helpData[i].price)
			spriteLine.size = 20
			spriteLine.align = cc.ui.TEXT_ALIGN_CENTER
			spriteLine.color = cc.c3b(0, 190, 30)
			local labelNowPrice = cc.ui.UILabel.new(spriteLine)
			labelNowPrice:addTo(self.scroll)
			labelNowPrice:setPosition(cc.p(110 + (i - 1) * 150, 10))
		else
			labelOriPrice:setPosition(cc.p(70 + (i - 1) * 150, 10))
		end
	end
	unchartedCtrl = include("itemSingleView").new()
	include("itemSingleView").new().count = exchangeList[1].time - unchartedInfo.exchangeNum[1]
	self.txtGoldRemainTimes:setString(i18n("common_text_1673", (include("itemSingleView").new())))
	unchartedCtrl = i18n("common_text_1673", (include("itemSingleView").new()))
	i18n("common_text_1673", (include("itemSingleView").new())).count = exchangeList[2].time - unchartedInfo.exchangeNum[2]
	self.txtCopperRemainTimes:setString(i18n("common_text_1673", i18n("common_text_1673", (include("itemSingleView").new()))))
end
function exchangeUnchartedCoinsView:chooseThreeItems()
	local unchartedCtrl, ret
	local helpData = unchartedCtrl:getUnchartedHelpInfo()
	for i, v in ipairs(helpData) do
		for j, m in ipairs(self.allItemList) do
			if tonumber(v.id) == m.Index then
				table.insert(ret, m)
			end
		end
	end
	return ret
end
function exchangeUnchartedCoinsView:questClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.UNCHARTED_HELP)
	end
end
function exchangeUnchartedCoinsView:storeClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local timeCtrl = gametop.playertop_:getModule("timeCtrl")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.UNCHARTED_ADVENTURE)
		local serverTime = timeCtrl:getServerTime()
		local lastDays = (param[1] - serverTime) / 86400
		if 0 < lastDays then
			SoraDCreatePanel("unchartedView"):show()
		end
		SoraDCreatePanel("unchartedStoreView"):show()
	end
end
function exchangeUnchartedCoinsView:goldClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local unchartedInfo = unchartedCtrl:getUnchartedInfo()
		local exchangeList = unchartedAdventureRead.getExchangeCoinList()
		if button:getTag() == gItemType.GOLD then
			_ENV = nil
			;(nil).Gold = exchangeList[1].num1
			;(nil).Num = exchangeList[1].num2
			SoraDShowMsgBox(i18n("secret_explore_assistance_notice_01", nil), i18n("common_text_054"), nil, function(msgType)
				if msgType == MSGBOX_CALLBACK_YES then
					if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.UNCHARTED_HELP, true) then
						local goldExchangeNum = exchangeList[1].time - unchartedInfo.exchangeNum[1]
						local goldNum = lordInfoCtrl:getBaseInfo().gold
						if 0 < goldExchangeNum then
							if goldNum > exchangeList[1].num1 then
								unchartedCtrl:sendExchangeCoinsMsg(1, exchangeList[1].num1)
							else
								SoraDShowMsgBox(i18n("common_text_423"), i18n("common_text_477"), nil, function(msgType)
									if MSGBOX_CALLBACK_YES == msgType then
										if GLOBAL_GAME_RECHARGE_MODE then
											uiManager:show("rechargeView")
										else
											SoraDCreatePanel("rechargeView"):show()
										end
									end
								end)
							end
						else
							SoraDShowMsgTip(i18n("Secret_explore_notice_13"))
						end
					else
						SoraDShowMsgTip(i18n("common_text_1859"))
						self:removeFromParent()
					end
				end
			end)
		elseif button:getTag() == gItemType.COPPER then
			_ENV = nil
			;(nil).Coin = exchangeList[2].num1
			;(nil).Num = exchangeList[2].num2
			SoraDShowMsgBox(i18n("secret_explore_assistance_notice_02", nil), i18n("common_text_054"), nil, function(msgType)
				if msgType == MSGBOX_CALLBACK_YES then
					if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.UNCHARTED_HELP, true) then
						local copperExchangeNum = exchangeList[2].time - unchartedInfo.exchangeNum[2]
						local copperNum = pyramidCtrl:getCopperNum()
						if 0 < copperExchangeNum then
							if copperNum > exchangeList[2].num1 then
								unchartedCtrl:sendExchangeCoinsMsg(2, exchangeList[2].num1)
							else
								SoraDShowMsgBox(i18n("common_text_1162"), i18n("common_text_477"), nil, function(msgType)
									if msgType == MSGBOX_CALLBACK_YES then
										uiManager:show("copperBuyView")
									end
								end)
							end
						else
							SoraDShowMsgTip(i18n("Secret_explore_notice_13"))
						end
					else
						SoraDShowMsgTip(i18n("common_text_1859"))
						self:removeFromParent()
					end
				end
			end)
		end
	end
end
function exchangeUnchartedCoinsView:getCoinsOrCountsAnimation(multiple)
	local multiple = multiple / 2
	if 50 <= multiple then
		multiple = 25
	end
	local frmx, frmy = display.cx, display.cy
	local tablePosX = SoraDGetRandNum(multiple, 100, 550)
	local tablePosY = SoraDGetRandNum(multiple, frmy + 100, frmy + 180)
	self:clearAnimationCache(multiple)
	for i = 1, multiple do
		self.resImgArray[i] = nil
		self.resImgArray[i] = cc.Sprite:createWithSpriteFrameName("icon_mjtx_tanxianbi.png")
		self.resImgArray[i]:setPosition(cc.p(frmx, frmy + 50))
		self.resImgArray[i]:addTo(self.panelDown)
		local callFunc = cca.callFunc(function()
			self.resImgArray[i]:removeFromParent()
			self.resImgArray[i] = nil
		end)
		local actionTo0 = cca.jumpTo(0.5, tablePosX[i], tablePosY[i], 50, 2)
		local actionTo1 = cca.delay(0.5)
		local failAction = cca.moveTo(0.5, self.panelDown:convertToNodeSpace(self.imageIconBg:convertToWorldSpace(cc.p(self.txtCoinRemain:getPositionX(), self.txtCoinRemain:getPositionY()))))
		local actionTo2 = cc.EaseExponentialOut:create(failAction)
		_UPVALUE4_ = self.panelDown:convertToNodeSpace(self.imageIconBg:convertToWorldSpace(cc.p(self.txtCoinRemain:getPositionX(), self.txtCoinRemain:getPositionY())))
		self.panelDown:convertToNodeSpace(self.imageIconBg:convertToWorldSpace(cc.p(self.txtCoinRemain:getPositionX(), self.txtCoinRemain:getPositionY())))[1] = actionTo0
		self.panelDown:convertToNodeSpace(self.imageIconBg:convertToWorldSpace(cc.p(self.txtCoinRemain:getPositionX(), self.txtCoinRemain:getPositionY())))[2] = actionTo1
		self.panelDown:convertToNodeSpace(self.imageIconBg:convertToWorldSpace(cc.p(self.txtCoinRemain:getPositionX(), self.txtCoinRemain:getPositionY())))[3] = actionTo2
		self.panelDown:convertToNodeSpace(self.imageIconBg:convertToWorldSpace(cc.p(self.txtCoinRemain:getPositionX(), self.txtCoinRemain:getPositionY())))[4] = callFunc
		self.resImgArray[i]:runAction(cca.seq(self.panelDown:convertToNodeSpace(self.imageIconBg:convertToWorldSpace(cc.p(self.txtCoinRemain:getPositionX(), self.txtCoinRemain:getPositionY())))))
		self.resImgArray[i]:setGlobalZOrder(1000)
	end
end
function exchangeUnchartedCoinsView:clearAnimationCache(multiple)
	for i = 1, multiple do
		if self.resImgArray[i] then
			transition.stopTarget(self.resImgArray[i])
			self.panelDown:removeChild(self.resImgArray[i], true)
		end
	end
end
function exchangeUnchartedCoinsView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.UNCHARTED_HELP) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return exchangeUnchartedCoinsView
