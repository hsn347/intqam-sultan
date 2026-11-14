local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local newExchangeMallRead = include("newExchangeMallRead")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local dailyRemindManager = include("dailyRemindManager")
local snowmanCelebrationltCtrl = include("snowmanCelebrationltCtrl")
local snowmanCelebrationCtrl = SoraDGetCtrl("snowmanCelebrationCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RamadanStarLightsMainPanel = class("RamadanStarLightsMainPanel", baseFguiPanel)
function RamadanStarLightsMainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("RamadanStarLightsMainPanel:ctor", self.viewName)
end
function RamadanStarLightsMainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "Ramadanstarlights"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "HarvestSeason"
		self._packageList, self._packageList[5] = self._packageList, "CommonBoxSingle"
		self._packageList, self._packageList[6] = self._packageList, "fonts"
	end
	return self._packageList
end
function RamadanStarLightsMainPanel:onInit()
	self.fields.Button_rank:fixPos()
	self.fields.Button_exchangeShop:fixPos()
	self.fields.Button_donate:fixPos()
	self.fields.Button_buy:fixPos()
	self.fields.Com_bar:fixPos()
	self.fields.Text_rewardTimes:fixPos()
	self.fields.n63:fixPos()
	self.fields.Text_itemGet:fixPos()
	self.fields.Text_itemGetTime:fixPos()
	self.fields.Com_iceCount:fixPos()
	self.fields.Ani_redLine:fixPos()
	self.fields.Ani_blueLine:fixPos()
	local lang = SoraDGetDefaultLanguage()
	if lang ~= "ar" then
		self.fields.Ani_redLine:setScaleX(-1)
		self.fields.Ani_blueLine:setScaleX(-1)
	end
	print("=======RamadanStarLightsMainPanel:onInit")
	self.functionCol = self:initFunc()
	snowmanCelebrationCtrl:sendInitMsg()
	self.itemData, _ENV = snowmanCelebrationCtrl.sendInitMsg, snowmanCelebrationCtrl.sendInitMsg
	self.fields.Com_title:initData(i18n("activity_name_9001419"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self:initJumpButton()
	self:initProgressBar()
	self:setTime()
	self:setGetItemTime()
	self.fields.Button_donate:addClickListener(handler(self, self.onClickDonate))
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBuy))
	self.fields.Button_buy:setTitleText(i18n("common_text_282"))
	self.fields.Button_donate:setTitleText(i18n("Snowman_Activity_03"))
	self.fields.Button_donate:setCostIcon(publicRead.getIcon(snowmanCelebrationltCtrl.getNeedIDByIndex(1)))
	self.on = false
	self:setAnimationConfig()
	self.activityID = gActivityTimeActivityID.SNOWMAN_CELEBRATION_ACTIVITY
	self:initData()
	self:setPointAndTimes()
end
function RamadanStarLightsMainPanel:setAnimationConfig()
	self.fields.Ani_redGem:setAllFrameName("dh_ghgd_bs_%.2d.png", 1)
	self.fields.Ani_blueGem:setAllFrameName("dh_ghgd_bs_%.2d.png", 1)
	self.fields.Ani_redLine:setAllFrameName("dh_ghgd_td_%.2d.png", 1)
	self.fields.Ani_blueLine:setAllFrameName("dh_ghgd_td_%.2d.png", 1)
	self.transitions.redGem:setHook("showEnd", function()
		self:updateExchangeButton()
	end)
	self.transitions.blueGem:setHook("showEnd", function()
		self:updateExchangeButton()
	end)
end
function RamadanStarLightsMainPanel:clickEffect()
	local timeCall = function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SNOWMAN_CELEBRATION_WATER_DELAY"
		SoraDSendMessage(nil)
	end
	SoraDCreateDelayTimer(self, timeCall, 0.7)
end
function RamadanStarLightsMainPanel:waterEffectOn()
	self.on = true
end
function RamadanStarLightsMainPanel:animationShow()
	if not self.exchangeActOn then
		return
	end
	if self.rewardId == self.itemSnowID then
		self.transitions.redGem:play(1, 1.2)
	else
		self.transitions.blueGem:play(1, 1.2)
	end
end
function RamadanStarLightsMainPanel:initFunc()
	snowmanCelebrationCtrl = nil
	;(nil).init = function()
		self:initData()
		snowmanCelebrationCtrl:sendAllianceRankMsg()
		self.fields.Com_bar:setProcessBar2Width(1 - snowmanCelebrationCtrl:getCurScore() / snowmanCelebrationltCtrl.getNeedIntegral(), 20)
		self.fields.Com_bar:updateHeadPointPos()
		self:setPointAndTimes()
	end
	;(nil).donate = function()
		snowmanCelebrationCtrl:sendAllianceRankMsg()
		self:initData()
		if snowmanCelebrationCtrl:getReceiveNum() ~= snowmanCelebrationltCtrl.getBoxRewardMaxTimes() then
			self.fields.Com_bar:setProcessBar2Width(1 - snowmanCelebrationCtrl:getCurScore() / snowmanCelebrationltCtrl.getNeedIntegral(), 20)
			self.fields.Com_bar:updateHeadPointPos()
			self:setPointAndTimes()
		else
			self:setPointAndTimes()
		end
		self:showRewards()
		self.rewardId = self.rewards[1] and self.rewards[1].id or nil
		if 1 < snowmanCelebrationCtrl:getIncScore() then
			self = 20
			;(20)[1] = "X" .. tostring(snowmanCelebrationCtrl:getIncScore())
			self.transitions.scoreSlide:setValue("text", 20)
			self.transitions.scoreSlide:play()
		end
		local str = self:getCritStr()
		if str ~= "" then
			SoraDShowMsgTip(str)
		end
	end
	;(nil).reward = function()
		self.fields.Text_rewardTimes:setString(snowmanCelebrationCtrl:getReceiveNum() .. "/" .. snowmanCelebrationltCtrl.getBoxRewardMaxTimes())
		self.fields.Com_bar:updateBox()
	end
	;(nil).notEnoughMoney = function()
		SoraDShowMsgTip(i18n("alliance_landSet_006"))
	end
	;(nil).notOpen = function()
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
	local (nil).notInAlliance, functionCol = function()
		SoraDShowMsgTip(i18n("common_text_826"))
	end, nil
	return functionCol
end
function RamadanStarLightsMainPanel:initData()
	self:setCostItemData()
end
function RamadanStarLightsMainPanel:initProgressBar()
	local iconPng = publicRead.getIcon(1647)
	self.fields.Com_bar:setIcon(iconPng)
	self.fields.Com_bar:setHandle(function()
		SoraDPlaySound()
		_ENV = SoraDPlaySound
		SoraDPlaySound.title = i18n("Snowman_Activity_07")
		SoraDPlaySound.btnText = i18n("common_text_1146")
		SoraDPlaySound.hadReward = snowmanCelebrationCtrl:isHaveBoxReward()
		_ENV = nil
		;(nil).num = snowmanCelebrationltCtrl.getNeedIntegral()
		SoraDPlaySound.tip = i18n("Snowman_Activity_08", nil)
		SoraDPlaySound.times = snowmanCelebrationCtrl:getReceiveNum() .. "/" .. snowmanCelebrationltCtrl.getBoxRewardMaxTimes()
		snowmanCelebrationltCtrl = snowmanCelebrationltCtrl.getBoxRewardMaxTimes()
		snowmanCelebrationltCtrl.getBoxRewardMaxTimes()[1] = "id"
		snowmanCelebrationltCtrl.getBoxRewardMaxTimes()[2] = "count"
		SoraDPlaySound.data = serviceFunctions.tableFormat(snowmanCelebrationltCtrl.getBoxRewardItem(), (snowmanCelebrationltCtrl.getBoxRewardMaxTimes()))
		local SoraDPlaySound.handle, param = function()
			if not snowmanCelebrationCtrl:isHaveBoxReward() then
				if snowmanCelebrationCtrl:haveGetBoxRewardChance() then
					SoraDShowMsgTip(i18n("Snowman_Activity_10"))
				else
					SoraDShowMsgTip(i18n("Snowman_Activity_09"))
				end
			else
				snowmanCelebrationCtrl:sendBoxRewardMsg()
			end
		end, SoraDPlaySound
		uiManager:show("SnowmanPointReward", param):setOwnerKey(self)
	end)
end
function RamadanStarLightsMainPanel:setPointAndTimes()
	self.fields.Text_rewardTimes:setString(snowmanCelebrationCtrl:getReceiveNum() .. "/" .. snowmanCelebrationltCtrl.getBoxRewardMaxTimes())
	print("11111111============")
	if snowmanCelebrationCtrl:getReceiveNum() == snowmanCelebrationltCtrl.getBoxRewardMaxTimes() then
		self.fields.Com_bar:setZeroState()
		return
	end
	print("22222222============")
	self.fields.Com_bar:setNum(snowmanCelebrationCtrl:getCurScore(), snowmanCelebrationltCtrl.getNeedIntegral())
	self.fields.Com_bar:setProcessBarWidth(1 - snowmanCelebrationCtrl:getCurScore() / snowmanCelebrationltCtrl.getNeedIntegral(), 20)
end
function RamadanStarLightsMainPanel:setTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.SNOWMAN_CELEBRATION_ACTIVITY)
	if eventTime then
		self.fields.Com_time:initData(eventTime.timerNode.timer:getRemainTime())
	end
end
function RamadanStarLightsMainPanel:setGetItemTime()
	self.fields.Text_itemGet:setString(i18n("Snowman_Activity_01"))
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.SURPRISED_DROP_ACTIVITY_1)
	if eventTime then
		self.fields.Text_itemGet:setVisible(true)
		self.fields.Text_itemGetTime:setVisible(true)
		self.fields.Text_itemGetTime:initData(eventTime.timerNode.timer:getRemainTime())
	end
end
function RamadanStarLightsMainPanel:initJumpButton()
	_ENV = nil
	;(nil).title = i18n("common_text_851")
	;(nil).data = snowmanCelebrationltCtrl.getRewardFront2ByIndex(snowmanCelebrationCtrl:getPlayerRank())
	local (nil).handle, data = function(...)
		SoraDPlaySound()
		uiManager:show("SnowmanAllianceRank"):setOwnerKey(self)
	end, nil
	self.fields.Button_rank:initData(data)
	self.itemIceID = snowmanCelebrationltCtrl.getGetItemIDByIndex(2)
	if self.itemIceID then
		self.fields.Com_iceCount:setIcon(publicRead.getIcon(self.itemIceID))
		self.fields.Com_iceCount:setText(i18n("common_text_4458"))
	end
end
function RamadanStarLightsMainPanel:hideItemTime()
	self.fields.Text_itemGet:setVisible(false)
	self.fields.Text_itemGetTime:setVisible(false)
end
function RamadanStarLightsMainPanel:setButtonRewardShow()
	local rank = snowmanCelebrationCtrl:getPlayerRank()
	local data
	if 0 < rank and rank <= 100 then
		data = snowmanCelebrationltCtrl.getRewardFront2ByIndex(rank)
	end
	self.fields.Button_rank:setRewardShow(data)
end
function RamadanStarLightsMainPanel:GetItemNum(itemID)
	local num = backpackCtrl:getItemCount(itemID)
	if 999 < num then
		return SoraDConvertNumberWithUnit(num)
	end
	return num or 0
end
function RamadanStarLightsMainPanel:setCostItemData()
	self.itemID = snowmanCelebrationltCtrl.getNeedIDByIndex(1)
	self.needNum = snowmanCelebrationltCtrl.getNeedCountByIndex(1)
	self:updateDonateBtn()
	self.costID = snowmanCelebrationltCtrl.getNeedIDByIndex(2)
	self.costNum = snowmanCelebrationltCtrl.getNeedCountByIndex(2)
	_UPVALUE2_ = 2
	;(2)[1] = self.itemID
	;(2)[2] = self.cosetID
	dump(2, "self.itemID,self.cosetID")
	self:updateBuyBtn()
end
function RamadanStarLightsMainPanel:updateExchangeButton()
	_UPVALUE0_, _UPVALUE2_ = nil, nil
	;(nil).id = self.itemSnowID
	_UPVALUE0_, (nil).count = self:GetItemNum(self.itemSnowID), self:GetItemNum(self.itemSnowID)
	self:GetItemNum(self.itemSnowID).id = self.itemIceID
	self:GetItemNum(self.itemSnowID).count = self:GetItemNum(self.itemIceID)
	;(nil)[1] = nil
	local (nil)[2], otherData = self:GetItemNum(self.itemSnowID), nil
	self.fields.Button_exchangeShop:refreshCount(otherData)
end
function RamadanStarLightsMainPanel:updateDonateBtn()
	local total = backpackCtrl:getItemCount(self.itemID)
	local needNum = self.needNum
	self:setItemInfo(self.itemID, needNum, total)
	self.fields.Button_donate:setCost(self.itemID, needNum)
	self.itemEnough = total >= needNum and true or false
	self.fields.Button_donate:setNumTotal(needNum, total, total >= needNum and "#FFFFFF" or "#F02828")
end
function RamadanStarLightsMainPanel:updateBuyBtn()
	local total = lordInfoCtrl:getBaseInfo().gold
	local needNum = self.costNum
	self:setItemInfo(self.costID, needNum, total)
	self.fields.Button_buy:setCost(self.costID, needNum)
	self.costEngough = total >= needNum and true or false
	self.fields.Button_buy:setNumTotal(needNum, total, total >= needNum and "#FFFFFF" or "#F02828")
end
function RamadanStarLightsMainPanel:setItemInfo(itemID, needNum, total)
	if self.itemData[itemID] then
		self.itemData[itemID].needNum = needNum
		self.itemData[itemID].total = total
		return
	end
	_UPVALUE0_ = self.itemData[itemID]
	self.itemData[itemID].needNum = needNum
	local self.itemData[itemID].total, tmp = total, self.itemData[itemID]
	self.itemData[itemID] = tmp
end
function RamadanStarLightsMainPanel:refreshView(data)
	if not data then
		return
	end
	dump(data, "RamadanStarLightsMainPanel:refreshView")
	self.rewards = data.rewards
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end
function RamadanStarLightsMainPanel:getCritStr()
	local str = ""
	local critsData = snowmanCelebrationCtrl:getCritsData()
	dump(critsData, "RamadanStarLightsMainPanel:getCritStr", 10)
	local num = 0
	for i, v in pairs(critsData) do
		if i ~= 1 and v ~= 0 then
			num = num + 1
			if 2 <= num then
				str = str .. ", "
			end
			snowmanCelebrationCtrl = nil
			;(nil).num = i
			;(nil).times = v
			str = str .. i18n("Snowman_Activity_13", nil)
		end
	end
	return str
end
function RamadanStarLightsMainPanel:showRewards()
	if not self.rewards then
		return
	end
	local _ENV, t = self.rewards, self.rewards
	for i, v in pairs(self.rewards) do
		if v.id then
			table.insert(t, v)
		end
	end
	SoraDMailGainItems(t, true)
end
function RamadanStarLightsMainPanel:onClickDonate()
	SoraDPlaySound()
	if not self:IsInAlliance() then
		return
	end
	if self.itemData[self.itemID].needNum > self.itemData[self.itemID].total then
		_ENV = nil
		;(nil).item = i18n("item_name_845301")
		SoraDShowMsgTip(i18n("Glory_text_19", nil))
		return
	end
	local handle = function(multiple)
		snowmanCelebrationCtrl:sendDonateMsg(self.itemID, snowmanCelebrationltCtrl.getNeedCountByIndex(1) * multiple)
	end
	local maxValue = self:retrunMaxCost(self.itemID, 1)
	_ENV = i18n("Glory_text_19", nil)
	i18n("Glory_text_19", nil).index = 1
	i18n("Glory_text_19", nil).handle = handle
	i18n("Glory_text_19", nil).maxValue = maxValue
	uiManager:show("SnowmanCelebrationShop", i18n("Glory_text_19", nil)):setOwnerKey(self)
end
function RamadanStarLightsMainPanel:onClickBuy(context)
	SoraDPlaySound()
	if not self:IsInAlliance() then
		return
	end
	if SoraDEnoughGold(self.itemData[self.costID].needNum) then
		local key = dailyRemindManager.REMIND_TYPE.snowmanMaxBoxContinue
		if snowmanCelebrationCtrl:getReceiveNum() == snowmanCelebrationltCtrl.getBoxRewardMaxTimes() and dailyRemindManager.checkNeedRemindOnce(key, self.activityID) then
			_ENV = nil
			;(nil).content = i18n("ramadan_starlight_08")
			;(nil).confirmFunc = function()
				self:addRemind(key)
				self:shopItem()
			end
			;(nil).cancelFunc = function()
			end
			uiManager:show("MessageBox", nil):setOwnerKey(self)
		else
			self:shopItem()
		end
	end
end
function RamadanStarLightsMainPanel:shopItem()
	local handle = function(multiple)
		local skin = snowmanCelebrationCtrl:getSkin()
		local tipStr = skin == 1 and "Snowman_Activity_17" or "ramadan_starlight_07"
		local key = dailyRemindManager.REMIND_TYPE.snowmanDonateOrBuyPrompt
		if dailyRemindManager.checkNeedRemind(key) then
			snowmanCelebrationCtrl = nil
			snowmanCelebrationCtrl = nil
			;(nil).item = i18n("common_text_020")
			;(nil).content = i18n(tipStr, nil)
			;(nil).confirmFunc = function()
				dailyRemindManager.addRemindToManager(key)
				snowmanCelebrationCtrl:sendDonateMsg(self.costID, snowmanCelebrationltCtrl.getNeedCountByIndex(2) * multiple)
			end
			;(nil).cancelFunc = function()
			end
			uiManager:show("MessageBox", nil):setOwnerKey(self)
		else
			snowmanCelebrationCtrl:sendDonateMsg(self.costID, snowmanCelebrationltCtrl.getNeedCountByIndex(2) * multiple)
		end
	end
	local maxValue = self:retrunMaxCost(self.costID, 2)
	snowmanCelebrationCtrl = nil
	;(nil).index = 2
	;(nil).handle = handle
	;(nil).maxValue = maxValue
	uiManager:show("SnowmanCelebrationShop", nil):setOwnerKey(self)
end
function RamadanStarLightsMainPanel:addRemind(key)
	local openCount = activityShowCtrl:getOpenCount(self.activityID)
	dailyRemindManager.addRemindToManager(key, openCount)
end
function RamadanStarLightsMainPanel:IsInAlliance()
	if not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("Snowman_Activity_02"))
		return false
	end
	return true
end
function RamadanStarLightsMainPanel:retrunMaxCost(itemID, index)
	local maxValue = math.floor(self.itemData[itemID].total / self.itemData[itemID].needNum)
	local singleLimit = snowmanCelebrationltCtrl.getMaxGetTimesByIndex(index)
	return maxValue <= singleLimit and maxValue or singleLimit
end
function RamadanStarLightsMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("ramadan_starlight_01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function RamadanStarLightsMainPanel:onShow()
	print("=======RamadanStarLightsMainPanel:onShow")
end
function RamadanStarLightsMainPanel:onHide()
	print("=======RamadanStarLightsMainPanel:onHide")
end
function RamadanStarLightsMainPanel:onDispose()
	print("=======RamadanStarLightsMainPanel:onDispose")
end
return RamadanStarLightsMainPanel
