local raidersLostArkSnatchView = class("raidersLostArkSnatchView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("raidersLostArkSnatchView")
	end
	return target
end)
local raidersLostArkRead = include("raidersLostArkRead")
local publicRead = include("publicRead")
local raidersLostArkCtrl = SoraDGetCtrl("raidersLostArkCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local constantRead = include("constantRead")
local shopCtrl = SoraDGetCtrl("shopCtrl")
function raidersLostArkSnatchView:ctor()
	self:initControls()
	self:fitDevice()
	self:playBgDownEffect()
	self:playBgTopEffect()
end
function raidersLostArkSnatchView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.Particle_10:setPositionY(self.Particle_10:getPositionY() + 350)
	self.Particle_10:setAutoCull(false)
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_friend")
	self.nodeTitle:setTitle(i18n("activity_name_9001270"))
	self.btn_help_tip:addTouchEventListener(handler(self, self.onClick_btn_help_tip))
	self.image_key:addTouchEventListener(handler(self, self.rewardClick))
	self.btn_add:addTouchEventListener(handler(self, self.addTimesClick))
	self.btn_refresh:addTouchEventListener(handler(self, self.refreshClick))
	self.btnHighArmy:addTouchEventListener(handler(self, self.viewArmyClick))
	self.btnNormalArmy:addTouchEventListener(handler(self, self.viewArmyClick))
	self.btnLowArmy:addTouchEventListener(handler(self, self.viewArmyClick))
	self.btnHighGo:addTouchEventListener(handler(self, self.snatchClick))
	self.btnNormalGo:addTouchEventListener(handler(self, self.snatchClick))
	self.btnLowGo:addTouchEventListener(handler(self, self.snatchClick))
	SoraDAutoSizeButtonText(self.btnHighGo, cc.size(100, 40))
	SoraDAutoSizeButtonText(self.btnNormalGo, cc.size(100, 40))
	SoraDAutoSizeButtonText(self.btnLowGo, cc.size(100, 40))
	self.txtTitle:setString(i18n("Martial_arts_text_11"))
	self.txtHigh:setString(i18n("Martial_arts_text_15"))
	self.txtNormal:setString(i18n("Martial_arts_text_16"))
	self.txtLow:setString(i18n("Martial_arts_text_17"))
	_ENV = i18n("Martial_arts_text_17")
	i18n("Martial_arts_text_17").power = ""
	self.txtHighPowerTitle:setString(i18n("Martial_arts_text_18", i18n("Martial_arts_text_17")))
	_ENV = i18n("Martial_arts_text_18", i18n("Martial_arts_text_17"))
	i18n("Martial_arts_text_18", i18n("Martial_arts_text_17")).power = ""
	self.txtNormalPowerTitle:setString(i18n("Martial_arts_text_18", i18n("Martial_arts_text_18", i18n("Martial_arts_text_17"))))
	_ENV = i18n("Martial_arts_text_18", i18n("Martial_arts_text_18", i18n("Martial_arts_text_17")))
	i18n("Martial_arts_text_18", i18n("Martial_arts_text_18", i18n("Martial_arts_text_17"))).power = ""
	self.txtLowPowerTitle:setString(i18n("Martial_arts_text_18", i18n("Martial_arts_text_18", i18n("Martial_arts_text_18", i18n("Martial_arts_text_17")))))
	self.btnHighArmy:setTag(gRaidersLostArkKeyDropProbability.HIGH)
	self.btnNormalArmy:setTag(gRaidersLostArkKeyDropProbability.NORMAL)
	self.btnLowArmy:setTag(gRaidersLostArkKeyDropProbability.LOW)
	self.btnHighGo:setTag(gRaidersLostArkKeyDropProbability.HIGH)
	self.btnNormalGo:setTag(gRaidersLostArkKeyDropProbability.NORMAL)
	self.btnLowGo:setTag(gRaidersLostArkKeyDropProbability.LOW)
	self.btn_refresh:setTitleText(i18n("common_text_911"))
	self.btnHighGo:setTitleText(i18n("Martial_arts_text_06"))
	self.btnNormalGo:setTitleText(i18n("Martial_arts_text_06"))
	self.btnLowGo:setTitleText(i18n("Martial_arts_text_06"))
	self.activityID = gActivityTimeActivityID.RAIDERS_LOST_ARK
	self.buyTimesPrice = include("constantRead").getConstValue("SNATCH_TREASURE_PRICE")
	self.buyTimesLimit = include("constantRead").getConstValue("SNATCH_TREASURE_COUNT")
end
function raidersLostArkSnatchView:fitDevice()
	if math.floor(display.height) == 960 then
		self.node_total:setScale(0.9)
	elseif math.floor(display.height) == 853 then
		self.node_total:setScale(0.8)
		self.node_total:setPositionY(self.node_total:getPositionY() + 30)
	end
end
function raidersLostArkSnatchView:playHighRefreshEffect(isPlay, parent)
	if isPlay then
		if parent.effectHigh then
			SoraDResetEffectNode(parent.effectHigh)
			parent.effectHigh.action:gotoFrameAndPlay(0, 75, false)
		else
			parent.effectHigh = SoraDCreatAnimationEx("Node_highEffect", nil, false)
			parent.effectHigh:setPosition(0, -15)
			parent.effectHigh:addTo(parent, 2)
		end
	elseif parent.effectHigh then
		parent.effectHigh:removeFromParent()
		parent.effectHigh = nil
	end
end
function raidersLostArkSnatchView:playNormalRefreshEffect(isPlay, parent)
	if isPlay then
		if parent.effectNormal then
			SoraDResetEffectNode(parent.effectNormal)
			parent.effectNormal.action:gotoFrameAndPlay(0, 75, false)
		else
			parent.effectNormal = SoraDCreatAnimationEx("Node_normalEffect", nil, false)
			parent.effectNormal:setPosition(0, -15)
			parent.effectNormal:addTo(parent, 2)
		end
	elseif parent.effectNormal then
		parent.effectNormal:removeFromParent()
		parent.effectNormal = nil
	end
end
function raidersLostArkSnatchView:playLowRefreshEffect(isPlay, parent)
	if isPlay then
		if parent.effectLow then
			SoraDResetEffectNode(parent.effectLow)
			parent.effectLow.action:gotoFrameAndPlay(0, 75, false)
		else
			parent.effectLow = SoraDCreatAnimationEx("Node_lowEffect", nil, false)
			parent.effectLow:setPosition(0, -15)
			parent.effectLow:addTo(parent, 2)
		end
	elseif parent.effectLow then
		parent.effectLow:removeFromParent()
		parent.effectLow = nil
	end
end
function raidersLostArkSnatchView:playBgDownEffect()
	self.bgDownEffect = SoraDCreatAnimation("Node_snatchBgEffectDown", nil, true)
	self.bgDownEffect:setPosition(cc.p(320, 250))
	self.bgDownEffect:addTo(self.Bottom_Node)
end
function raidersLostArkSnatchView:playBgTopEffect()
	self.bgTopEffect = SoraDCreatAnimation("Node_snatchBgEffectTop", nil, true)
	self.bgTopEffect:setPosition(cc.p(0, -3))
	self.bgTopEffect:addTo(self.node_total)
end
function raidersLostArkSnatchView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RAIDER_LOST_ARK_BUY_ROBBERY_TIMES", function(target, data)
		SoraDCloseLoading(self)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RAIDER_LOST_ARK_REFRESH_ROBBERY_TARGET", function(target, data)
		SoraDCloseLoading(self)
		self:playHighRefreshEffect(true, self.node_high)
		self:playNormalRefreshEffect(true, self.node_normal)
		self:playLowRefreshEffect(true, self.node_low)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RAIDER_LOST_ARK_BEGIN_ROBBERY", function(target, data)
		SoraDCloseLoading(self)
		local snatchPanel = SoraDCreatePanel("raidersLostArkWinOrLostView")
		snatchPanel:initData()
		snatchPanel:show()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RAIDER_LOST_ARK_ROBBERY_TIMES_NOT_ENOUGH", function(target, data)
		SoraDCloseLoading(self)
		SoraDShowMsgTip(i18n("remains_text_79"))
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RAIDER_LOST_ARK_ROBBERY_TROOPS_ERROR", function(target, data)
		SoraDCloseLoading(self)
		SoraDShowMsgTip(i18n("Martial_arts_text_26"))
	end)
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function raidersLostArkSnatchView:initData()
	if not self.keyId then
		return
	end
	local imageIcon = publicRead.getIcon(self.keyId)
	local remainTimes = raidersLostArkCtrl:getTodayRemainRobberyTimes()
	local highInfo = raidersLostArkCtrl:getTargetListInfo(gRaidersLostArkKeyDropProbability.HIGH)
	local normalInfo = raidersLostArkCtrl:getTargetListInfo(gRaidersLostArkKeyDropProbability.NORMAL)
	local lowInfo = raidersLostArkCtrl:getTargetListInfo(gRaidersLostArkKeyDropProbability.LOW)
	local remainTimes = raidersLostArkCtrl:getTodayRemainRobberyTimes()
	local ticketCount = backpackCtrl:getItemCount(833001)
	self.image_key:loadTexture(imageIcon, ccui.TextureResType.plistType)
	self.image_key:setContentSize(cc.size(132, 132))
	publicRead = cc.size(132, 132)
	cc.size(132, 132).num = remainTimes
	self.txt_ins:setString(i18n("Martial_arts_text_12", cc.size(132, 132)))
	self.txtHighPower:setString(highInfo.fightCapacity)
	self.txtNormalPower:setString(normalInfo.fightCapacity)
	self.txtLowPower:setString(lowInfo.fightCapacity)
	self.btnHighGo:setTitleColor(remainTimes <= 0 and ticketCount <= 0 and cc.c3b(255, 0, 0) or cc.c3b(255, 255, 255))
	self.btnNormalGo:setTitleColor(remainTimes <= 0 and ticketCount <= 0 and cc.c3b(255, 0, 0) or cc.c3b(255, 255, 255))
	self.btnLowGo:setTitleColor(remainTimes <= 0 and ticketCount <= 0 and cc.c3b(255, 0, 0) or cc.c3b(255, 255, 255))
	if remainTimes <= 0 then
		publicRead = 255
		;(255).num = ticketCount
		self.txt_ins:setString(i18n("Martial_arts_text_43", 255))
		self.txt_ins:setColor(ticketCount <= 0 and cc.c3b(255, 0, 0) or cc.c3b(239, 235, 209))
	end
	self.icon_ticket:setVisible(remainTimes <= 0)
	self.btn_add:setPositionX(self.txt_ins:getPositionX() - SoraDFSign(self.txt_ins:getContentSize().width / 2) - SoraDFSign(25))
	self.icon_ticket:setPositionX(self.txt_ins:getPositionX() + SoraDFSign(self.txt_ins:getContentSize().width / 2) + SoraDFSign(30))
end
function raidersLostArkSnatchView:setKeyId(keyId)
	self.keyId = keyId
	self:playHighRefreshEffect(true, self.node_high)
	self:playNormalRefreshEffect(true, self.node_normal)
	self:playLowRefreshEffect(true, self.node_low)
	self:initData()
end
function raidersLostArkSnatchView:onClick_btn_help_tip(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "Martial_arts_text_01"
		;("Martial_arts_text_01").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("Martial_arts_text_01"), "Martial_arts_text_01")
	end
end
function raidersLostArkSnatchView:rewardClick(target, event)
	if event == ccui.TouchEventType.ended or event == ccui.TouchEventType.canceled then
		SoraDCloseCommonTips()
	elseif event == ccui.TouchEventType.began then
		SoraDPlaySound()
		SoraDShowCommonTips(target, self.keyId)
	end
end
function raidersLostArkSnatchView:addTimesClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local ownGold = lordInfoCtrl:getBaseInfo().gold
		local countLimit = math.min(10, math.max(1, math.floor(ownGold / self.buyTimesPrice)))
		self:quickBuy(countLimit)
	end
end
function raidersLostArkSnatchView:quickBuy(num)
	_ENV, _ENV = nil, nil
	;(nil).id = 833001
	;(nil).price = self.buyTimesPrice
	;(nil).max = num
	;(nil).cur = num
	_ENV, (nil).itemData, (nil).shopItemID = nil, nil, 1000243
	;(nil).otherData, (nil).curValue = nil, 1
	uiManager:show("newShopSingleBuy", nil)
end
function raidersLostArkSnatchView:refreshClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		raidersLostArkCtrl:reqRobberyRefresh()
		SoraDShowLoading(self)
	end
end
function raidersLostArkSnatchView:viewArmyClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local armyInfo = raidersLostArkCtrl:getTargetListInfo(button:getTag())
		local panel = SoraDCreatePanel("raidersLostArkArmyPopView")
		panel:initData(button:getTag(), armyInfo)
		panel:show()
	end
end
function raidersLostArkSnatchView:snatchClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local remainTimes = raidersLostArkCtrl:getTodayRemainRobberyTimes()
		local ticketCount = backpackCtrl:getItemCount(833001)
		if 0 < remainTimes or 0 < ticketCount then
			local dispatchPanel = uiManager:show("WorldDispatchArmyView")
			_ENV = nil
			;(nil).isRaiderLostArk = true
			;(nil).targetID = button:getTag()
			;(nil).itemID = self.keyId
			dispatchPanel:initData(nil)
		else
			SoraDShowBuyBox(i18n("Martial_arts_text_44"), self.buyTimesPrice, i18n("common_text_4523"), function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					if lordInfoCtrl:getBaseInfo().gold >= self.buyTimesPrice then
						shopCtrl:reqBuyInItemShop(1000243, 1)
						local dispatchPanel = uiManager:show("WorldDispatchArmyView")
						_ENV = 1
						;(1).isRaiderLostArk = true
						;(1).targetID = button:getTag()
						;(1).itemID = self.keyId
						dispatchPanel:initData(1)
					else
						SoraDShowMsgBox(i18n("common_text_430"), i18n("common_text_204"), nil, handler(self, self.gotoStore))
					end
				end
			end)
		end
	end
end
function raidersLostArkSnatchView:makeSure(type)
	if type == MSGBOX_CALLBACK_YES then
		if lordInfoCtrl:getBaseInfo().gold >= self.buyTimesPrice then
			raidersLostArkCtrl:reqRobberyTimes()
			SoraDShowLoading(self)
		else
			SoraDShowMsgBox(i18n("common_text_430"), i18n("common_text_204"), nil, handler(self, self.gotoStore))
		end
	end
end
function raidersLostArkSnatchView:gotoStore(type)
	if type == MSGBOX_CALLBACK_YES then
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
end
function raidersLostArkSnatchView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return raidersLostArkSnatchView
