local gametop = gModuleMgr.getObject("gametop")
local petraRareTreasureCtrl = gametop.playertop_:getModule("petraRareTreasureCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local petraRareTreasureDef = include("petraRareTreasureDef")
local petraRareTreasureUtil = include("petraRareTreasureUtil")
local petraRareTreasureMainView = class("petraRareTreasureMainView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
local BEST_TREASURE = petraRareTreasureDef.BEST_TREASURE
function petraRareTreasureMainView:ctor()
	self.txtRemain = SoraDGetChildByName(self, "Text_remain")
	self.txtRemainTime = SoraDGetChildByName(self, "Text_remainTime")
	self.imgHourglass = SoraDGetChildByName(self, "Image_hourglass")
	self.btnChange = SoraDGetChildByName(self, "Button_change")
	self.txtTockenNum = SoraDGetChildByName(self, "Text_tocken_num")
	self.txtBuyNum = SoraDGetChildByName(self, "Text_buy_num")
	self.btnBuy = SoraDGetChildByName(self, "Button_buy")
	self.btnLottery = SoraDGetChildByName(self, "Button_lottery")
	self.btnLotteryTen = SoraDGetChildByName(self, "Button_lottery_ten")
	self.btnSelect = SoraDGetChildByName(self, "Button_select")
	self.btnBag = SoraDGetChildByName(self, "Button_bag")
	self.iconBag = SoraDGetChildByName(self, "icon_bag")
	self.txtLotteryTitle = SoraDGetChildByName(self, "Text_title_lottery")
	self.txtLotteryNum = SoraDGetChildByName(self, "Text_num_lottery")
	self.imgLottery = SoraDGetChildByName(self.btnLottery, "Sprite_1038")
	self.txtLotteryTenTitle = SoraDGetChildByName(self, "Text_title_lotteryten")
	self.txtLotteryTenNum = SoraDGetChildByName(self, "Text_num_lotteryten")
	self.imgLotteryTen = SoraDGetChildByName(self.btnLotteryTen, "Sprite_1038")
	self.nodeActivity = SoraDGetChildByName(self, "Node_activity")
	self.nodeSelect = SoraDGetChildByName(self, "Node_select")
	self.nodeBag = SoraDGetChildByName(self, "Node_bag")
	self.nodeEffectPartent = SoraDGetChildByName(self, "Node_effect")
	self.nodeItem = SoraDGetChildByName(self, "Node_item")
	self.btnBuy:addTouchEventListener(handler(self, self.onClickBuy))
	self.btnLottery:addTouchEventListener(handler(self, self.onClickLottery))
	self.btnLotteryTen:addTouchEventListener(handler(self, self.onClickLotteryTen))
	self.btnSelect:addTouchEventListener(handler(self, self.onClickSelect))
	self.btnChange:addTouchEventListener(handler(self, self.onClickSelect))
	self.btnBag:addTouchEventListener(handler(self, self.onClickBag))
	if self:getPanelOffsetHeight() > 960 then
		local nodeBottom = SoraDGetChildByName(self, "Bottom_Node_team")
		nodeBottom:setPositionY(-self:getPanelOffsetHeight() + 180)
		local nodeBottomBg = SoraDGetChildByName(self, "Bottom_Image_bg")
		nodeBottomBg:setPositionY(-self:getPanelOffsetHeight() + 150)
		local nodeContent = SoraDGetChildByName(self, "Node_content")
		nodeContent:setPositionY(nodeContent:getPositionY() - (self:getPanelOffsetHeight() - 960) * 0.5)
	elseif self:getPanelOffsetHeight() < 900 then
		local nodeBottom = SoraDGetChildByName(self, "Bottom_Node_team")
		nodeBottom:setPositionY(-self:getPanelOffsetHeight() + 110)
		local nodeBottomBg = SoraDGetChildByName(self, "Bottom_Image_bg")
		nodeBottomBg:setPositionY(-self:getPanelOffsetHeight() + 800)
		local nodeContent = SoraDGetChildByName(self, "Node_content")
		nodeContent:setPosition(nodeContent:getPositionX() + 32, nodeContent:getPositionY() - 5)
		nodeContent:setScale(0.9)
		self.nodeActivity:setPositionY(self.nodeActivity:getPositionY() + 30)
		self.nodeSelect:setPositionY(self.nodeSelect:getPositionY() + 30)
	end
	self.txtRemain:setString(i18n("rides_text_09"))
	self.txtRemainTime = SoraDCreateTimerLabel(self, self.txtRemainTime)
	self.txtLotteryTitle:setString(i18n("petra_btn_03"))
	self.txtLotteryTenTitle:setString(i18n("petra_btn_04"))
	self.btnSelect:setTitleText(i18n("petra_title_03"))
	self.nodeLuckKey = SoraDGetExtendChildFromCCSByName(self, "CCS_petraRareTreasureMainSingle_luackkey")
	self.tableItem = SoraDGetChildsArrayByName(self, "CCS_petraRareTreasureMainSingle_", 12, 1, true, true)
	self.nodeBest = self.tableItem[BEST_TREASURE]
	self:initEffect()
	self.btn_Log = SoraDGetChildByName(self, "Button_Log")
	self.btn_Log:setTouchEnabled(true)
	self.btn_Log:addTouchEventListener(handler(self, self.onClickOpenLog))
	local textLog = SoraDGetChildByName(self.btn_Log, "Text_Log")
	textLog:setString(i18n("petra_title_05"))
	textLog:setFontSize(16)
	self.btn_Log:setPositionX(self.btn_Log:getPositionX() - (SoraDFIsRA() and -1 or 1) * (textLog:getContentSize().width / 2 - 50))
end
function petraRareTreasureMainView:initEffect()
	local node_content = SoraDGetChildByName(self, "Node_bg")
	if node_content then
		do
			local array = SoraDGetChildsArrayByName(node_content, "Sprite_sp_", 4, 1)
			_G.SoraDSetNodeArrayAdditive(array)
		end
		local array = SoraDGetChildsArrayByName(node_content, "Particle_", 6, 1)
		_G.SoraDSetParticleAutoCull(array)
	end
	local ret = _G.SoraDIsFileExistByKey("petraRareTreasure")
	if ret then
		display.addSpriteFrames("Common/petraRareTreasure.plist", getImageFileNameByPlatform("Common/petraRareTreasure"))
	end
	local loop = true
	local cssFileName = "petraRareTreasureMainView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, true)
	self:runAction(action)
end
function petraRareTreasureMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_PETRA_RARE_TREASURE_REFRESH", handler(self, self.updateInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_PETRA_RARE_TREASURE_EFFECT", handler(self, self.playAwardItem_Key))
	SoraDAddMessage(self, "MESSAGE_SERVER_PETRA_RARE_TREASURE_EFFECT_ITEM", handler(self, self.playAwardItem))
end
function petraRareTreasureMainView:init()
	self:setItemInfo()
	self:setTime()
	self:updateInfo()
end
function petraRareTreasureMainView:updateInfo()
	SoraDCloseLoading(self)
	self:setBestItemInfo()
	self:setBag()
	self:setLotternTimes()
	self:setBtnStatus()
end
function petraRareTreasureMainView:setTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.PETRA_RARE_TREASURE)
	if eventTime then
		self.txtRemainTime:beginTime(eventTime.timerNode.timer:getRemainTime())
		if SoraDFIsRA() then
			self.imgHourglass:setPositionX(self.txtRemainTime:getPositionX() + (self.txtRemainTime:getContentSize().width + 20))
		else
			self.imgHourglass:setPositionX(self.txtRemainTime:getPositionX() - (self.txtRemainTime:getContentSize().width + 20))
		end
	end
end
function petraRareTreasureMainView:setBag()
	local num = petraRareTreasureCtrl:getLockLuckyCoin()
	petraRareTreasureCtrl = nil
	;(nil).num = string.formatnumberthousands(num)
	self.txtTockenNum:setString(i18n("petra_text_03", nil))
end
function petraRareTreasureMainView:setLotternTimes()
	local times = petraRareTreasureCtrl:getLotternTimes()
	local strTimes = string.formatnumberthousands(times)
	petraRareTreasureCtrl = nil
	;(nil).num = strTimes
	self.txtBuyNum:setString(i18n("petra_text_05", nil))
	if SoraDFIsRA() then
		self.btnBuy:setPositionX(self.txtBuyNum:getPositionX() - (self.txtBuyNum:getContentSize().width * 0.5 + 20))
	else
		self.btnBuy:setPositionX(self.txtBuyNum:getPositionX() + (self.txtBuyNum:getContentSize().width * 0.5 + 20))
	end
	do
		local enableLottern = 0 < times
		petraRareTreasureCtrl = i18n("petra_text_05", nil)
		i18n("petra_text_05", nil).member = times
		i18n("petra_text_05", nil).total = 1
		self.txtLotteryNum:setString(i18n("common_text_155", i18n("petra_text_05", nil)))
		_UPVALUE2_ = self.btnLottery
		self.btnLottery[1] = self.imgLottery
		self.btnLottery[2] = self.txtLotteryNum
		SoraDAlignNodeArrayOnCenterX(self.btnLottery:getContentSize().width / 2, self.btnLottery, SoraDFIsRA())
		if enableLottern then
			self.txtLotteryNum:setColor(display.COLOR_WHITE)
		else
			self.txtLotteryNum:setColor(display.COLOR_RED)
		end
	end
	do
		local enableLottern = 10 <= times
		petraRareTreasureCtrl = SoraDFIsRA()
		SoraDFIsRA().member = times
		SoraDFIsRA().total = 10
		self.txtLotteryTenNum:setString(i18n("common_text_155", SoraDFIsRA()))
		_UPVALUE2_ = self.btnLotteryTen
		self.btnLotteryTen[1] = self.imgLotteryTen
		self.btnLotteryTen[2] = self.txtLotteryTenNum
		SoraDAlignNodeArrayOnCenterX(self.btnLotteryTen:getContentSize().width / 2, self.btnLotteryTen, SoraDFIsRA())
		if enableLottern then
			self.txtLotteryTenNum:setColor(display.COLOR_WHITE)
		else
			self.txtLotteryTenNum:setColor(display.COLOR_RED)
		end
	end
end
function petraRareTreasureMainView:setBtnStatus()
	local hasBestTreasureID = petraRareTreasureCtrl:hasBestTreasureID()
	self.nodeSelect:setVisible(not hasBestTreasureID)
	self.nodeActivity:setVisible(hasBestTreasureID)
end
function petraRareTreasureMainView:setItemInfo()
	local view = self:getParent():getParent()
	for i, v in ipairs(self.tableItem) do
		if i ~= BEST_TREASURE then
			local config = petraRareTreasureUtil:getAwardByIndex(i)
			if config then
				v:initItemData(i, config, view)
			end
		end
	end
end
function petraRareTreasureMainView:setBestItemInfo()
	local view = self:getParent():getParent()
	local config = petraRareTreasureUtil:getAwardByIndex(BEST_TREASURE)
	self.nodeBest:initItemData(BEST_TREASURE, config, view)
end
function petraRareTreasureMainView:onClickLottery(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local times = petraRareTreasureCtrl:getLotternTimes()
		local enableLottern = 0 < times
		if not enableLottern then
			SoraDShowMsgTip(i18n("common_text_4443"))
		else
			petraRareTreasureCtrl:reqTreasureLottory()
			self:showClose()
		end
	end
end
function petraRareTreasureMainView:showClose()
	local panel = SoraDShowLoading(self, nil, nil, false, 10)
	panel:setPositionY(-panel:getPositionY())
end
function petraRareTreasureMainView:onClickLotteryTen(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local times = petraRareTreasureCtrl:getLotternTimes()
		local enableLottern = 10 <= times
		if not enableLottern then
			SoraDShowMsgTip(i18n("common_text_4443"))
		else
			petraRareTreasureCtrl:reqTreasureLottoryTen()
			self:showClose()
		end
	end
end
function petraRareTreasureMainView:onClickSelect(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("petraRareTreasureSetView"):show()
	end
end
function petraRareTreasureMainView:onClickBuy(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).menuEnum = 12
			uiManager:show("rechargeView", nil)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNodeByType(12, gRechargeActiveModelType.PETRA_GIFT)
			panel:show()
		end
	end
end
function petraRareTreasureMainView:onClickBag(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("petra_text_02"))
	end
end
function petraRareTreasureMainView:onClickOpenLog(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("petraRareTreasureLog")
		panel:show()
	end
end
function petraRareTreasureMainView:playAwardItem(target, data)
	local index = data.index or 1
	local targetPos = cc.p(0, -1000)
	self:playAwardItem_imp(index, targetPos)
end
function petraRareTreasureMainView:showWaggleEffect()
	self.iconBag:stopAllActions()
	_UPVALUE6_ = self.iconBag
	self.iconBag[1] = cca.delay(2.8333333333333335)
	self.iconBag[2] = cca.rotateTo(0.25, 10)
	self.iconBag[3] = cca.rotateTo(0.21666666666666667, -10)
	self.iconBag[4] = cca.rotateTo(0.2, 8)
	self.iconBag[5] = cca.rotateTo(0.16666666666666666, -5)
	self.iconBag[6] = cca.rotateTo(0.15, 2)
	self.iconBag[7] = cca.rotateTo(0.15, 0)
	self.iconBag[8] = cca.rotateTo(0.15, 0)
	self.iconBag[9] = cca.rotateTo(0.15, 0)
	local seq = cca.seq(self.iconBag)
	self.iconBag:runAction(seq)
end
function petraRareTreasureMainView:playAwardItem_Key(target, data)
	local unlockedLuckyCoin = data.unlockedLuckyCoin or 0
	local targetPos = cc.p(self.nodeBag:getPosition())
	self:playAwardItem_imp(petraRareTreasureDef.LUCKY_KEY, targetPos, unlockedLuckyCoin)
	self:showWaggleEffect()
end
function petraRareTreasureMainView:playAwardItem_imp(index, targetPos, unlockedLuckyCoin)
	local targetItem = self.tableItem[index]
	local reward = petraRareTreasureUtil:getAwardByIndex(index)
	if targetItem and reward then
		local showItem
		local isLuck = petraRareTreasureDef.LUCKY_KEY == index
		if isLuck then
			local single = SoraDGetChildByName(targetItem, "Image_icon")
			showItem = single:clone()
		else
			showItem = include("commonItemAward").new()
			showItem:initData(reward.id, reward.count)
			showItem:setScale(0.9)
			showItem:setTouchEnabled(false)
		end
		local pos = SoraDCoverToPoint(self.nodeItem, cc.p(targetItem:getPositionX(), targetItem:getPositionY() - 10), self.nodeEffectPartent)
		showItem:setPosition(pos)
		showItem:addTo(self.nodeEffectPartent, 2)
		_UPVALUE7_ = showItem.addTo
		showItem.addTo[1] = cca.delay(0.2)
		showItem.addTo[2] = cca.callFunc(function()
			if showItem.showEffect then
				showItem:showEffect()
			end
		end)
		showItem.addTo[3] = cc.EaseExponentialOut:create(cca.moveTo(0.5, 0, 0))
		showItem.addTo[4] = cca.delay(1.2)
		showItem.addTo[5] = cc.EaseExponentialIn:create(cca.moveTo(0.5, targetPos.x, targetPos.y + 0))
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
				SoraDShowMsgTip(i18n("petra_text_09", nil))
				_ENV = i18n("petra_text_09", nil)
				i18n("petra_text_09", nil).msg = "MESSAGE_SERVER_PETRA_RARE_TREASURE_SHOP_GUIDE"
				SoraDSendMessage(i18n("petra_text_09", nil))
			end)
		end
		local seq = cca.seq(action)
		showItem:runAction(seq)
		self:playAwardEffect()
	end
end
function petraRareTreasureMainView:playAwardEffect()
	if not self.nodeEffect then
		local node = _G.SoraDCreatAnimationEx("petraRareTreasureEffect", nil, false)
		if node then
			local childs = node:getChildren()
			_G.SoraDSetNodeArrayAdditive(childs)
			self.nodeEffectPartent:addChild(node, 1)
		end
		self.nodeEffect = node
	end
	if self.nodeEffect and self.nodeEffect.action then
		self.nodeEffect.action:gotoFrameAndPlay(0, false)
	end
end
return petraRareTreasureMainView
