local desertTreasureltCtrl = include("desertTreasureltCtrl")
local gametop = gModuleMgr.getObject("gametop")
local desertTreasureCtrl = gametop.playertop_:getModule("desertTreasureCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local dailyRemindManager = include("dailyRemindManager")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DesertSecretTreasurePanel = class("DesertSecretTreasurePanel", baseFguiPanel)
function DesertSecretTreasurePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("DesertSecretTreasurePanel:ctor", self.viewName)
end
_UPVALUE3_, DesertSecretTreasurePanel.getPackageList = function(self)
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "DesertSecretTreasure"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[5] = self._packageList, "CommonBoxSingle"
		self._packageList, self._packageList[6] = self._packageList, "HarvestSeason"
	end
	return self._packageList
end, function(self)
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "DesertSecretTreasure"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[5] = self._packageList, "CommonBoxSingle"
		self._packageList, self._packageList[6] = self._packageList, "HarvestSeason"
	end
	return self._packageList
end
;(function(self)
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "DesertSecretTreasure"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[5] = self._packageList, "CommonBoxSingle"
		self._packageList, self._packageList[6] = self._packageList, "HarvestSeason"
	end
	return self._packageList
end)[1] = 14568
;(function(self)
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "DesertSecretTreasure"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[5] = self._packageList, "CommonBoxSingle"
		self._packageList, self._packageList[6] = self._packageList, "HarvestSeason"
	end
	return self._packageList
end)[2] = 14569
local (function(self)
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "DesertSecretTreasure"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[5] = self._packageList, "CommonBoxSingle"
		self._packageList, self._packageList[6] = self._packageList, "HarvestSeason"
	end
	return self._packageList
end)[3], giftID = 14570, function(self)
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "DesertSecretTreasure"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[5] = self._packageList, "CommonBoxSingle"
		self._packageList, self._packageList[6] = self._packageList, "HarvestSeason"
	end
	return self._packageList
end
function DesertSecretTreasurePanel:onInit()
	print("=======DesertSecretTreasurePanel:onInit")
	self:fixNodePos()
	self.enter = true
	self:resizeForRoom(self.stageRewardFlag)
	self:setAniFrameConfig()
	self.itemID = 844001
	self.activityID = gActivityTimeActivityID.DESERT_TREASURE_ACTIVITY
	self.stageData = desertTreasureltCtrl.getExtraConfig()
	self.fields.Com_title:initData(i18n("activity_name_9001376"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_getAll:setString(i18n("universe_text_04"))
	self.fields.Com_time:setTitle(i18n("common_text_1663"))
	self.fields.Com_time:setState(1)
	if SoraDGetDefaultLanguage() ~= "ar" then
		self.fields.Com_time:setToCenter()
	end
	self:setTime()
	self.fields.Button_reward:addClickListener(handler(self, self.onClickReward))
	self.fields.Button_cost:setTitle(i18n("common_text_246"))
	self.fields.Button_cost:setCostIcon("8440.png")
	self.fields.Button_cost:addClickListener(handler(self, self.onClickRun))
	self.fields.List_cumuReward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_luck:addClickListener(handler(self, self.onClickLuckDetail))
	self.fields.Button_luck:initData(i18n("herovault_text_08"), 1)
	_ENV = self.fields.Button_luck.initData
	self.fields.Button_luck.initData.itemid = self.itemID
	local self.fields.Button_luck.initData.handle, data = function()
		SoraDPlaySound()
		self:jumpToGift(MSGBOX_CALLBACK_YES)
	end, self.fields.Button_luck.initData
	self.fields.Com_ownNum:initData(data)
	self.stageRewardFlag = desertTreasureltCtrl.hadStageReward()
	self.hadLuckRewardFlag = desertTreasureltCtrl.hadLuckReward()
	if not self.stageRewardFlag then
		self:resizeNoStageReward()
	end
	self.fields.List_cumuReward:setVisible(self.stageRewardFlag)
	self.fields.Node_processBar:setVisible(self.stageRewardFlag)
	self.fields.Node_luck:setVisible(self.hadLuckRewardFlag)
	self.fields.Button_luck:setVisible(self.hadLuckRewardFlag)
	self.fields.List_cumuReward:setItemRenderer(handler(self, self.onItemRendererStage))
	self.transitions.right:setHook("boom", function()
		self = nil
		;(nil).var = desertTreasureCtrl:getLuckyPoint()
		self.fields.Button_luck:setTitle(i18n("herovault_text_08", nil))
		self:updateLuckFill()
	end)
	self.transitions.left:setHook("boom", function()
		self = nil
		;(nil).var = desertTreasureCtrl:getLuckyPoint()
		self.fields.Button_luck:setTitle(i18n("herovault_text_08", nil))
		self:updateLuckFill()
	end)
	self.enterUsmComplete = false
	self.tryEffectComplete = true
	local key = dailyRemindManager.REMIND_TYPE.desertTreasureEnterAni
	if dailyRemindManager.checkNeedRemind(key) then
		dailyRemindManager.addRemindToManager(key)
		self.fields.bg_enter:setVisible(false)
		self.fields.Com_usm:initData(true)
		self:playEnterAction()
	else
		self.fields.Com_usm:initData(false)
		self.enterUsmComplete = true
	end
	self:initData()
end
function DesertSecretTreasurePanel:fixNodePos()
	self.fields.Node_processBar:fixPos()
	self.fields.process_bg:fix(false)
	self.fields.process_highLight:fix(false)
	self.fields.List_cumuReward:fixPos()
	self.fields.icon_luck:fix(false)
	self.fields.icon_luck_highLight:fix(false)
	self.fields.Ani_fill:fix(false)
end
function DesertSecretTreasurePanel:enterUsmReady()
	self.transitions.itemScale:play()
end
function DesertSecretTreasurePanel:playEnterAction()
	local origX = self.fields.Com_rewardCol:getPositionX()
	local origY = self.fields.Com_rewardCol:getPositionY()
	_UPVALUE2_ = nil
	;(nil)[1] = origX
	;(nil)[2] = origY + 193
	self.transitions.itemScale:setValue("point1", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = origX
	;(nil)[2] = origY + 193
	self.transitions.itemScale:setValue("point2", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = origX - 2
	;(nil)[2] = origY
	self.transitions.itemScale:setValue("point3", nil)
	self.transitions.itemScale:setHook("actionEnd", function()
		self.enterUsmComplete = true
	end)
	self.transitions.itemScale:play()
end
function DesertSecretTreasurePanel:initData(data)
	if data and data.subMsg == "extract" and data.reward then
		self:tryOnceSuccess(data.reward, data.subMsg)
	end
	if data and data.subMsg == "stageReward" and data.reward then
		desertTreasureCtrl = data.reward
		data.reward.rewards = data.reward
		self:getReward(data.reward)
	end
	if self.enter then
		self.fields.compass:setRotation(0)
		self.fields.Com_rewardCol:initData()
	end
	self.fields.Com_ownNum:refreshCount()
	self.getAllFlag = desertTreasureCtrl:getTreasureNum() >= desertTreasureltCtrl.getConfigNum(desertTreasureCtrl:getGroup())
	if self.getAllFlag then
		self.fields.Text_getAll:setVisible(true)
		self.fields.Button_cost:setVisible(false)
	else
		local nth = desertTreasureCtrl:getTreasureNum() + 1
		self.fields.Button_cost:setCostNum(desertTreasureltCtrl.getCost(nth), backpackCtrl:getItemCount(self.itemID))
	end
	if self.hadLuckRewardFlag and self.enter then
		desertTreasureCtrl = backpackCtrl:getItemCount(self.itemID)
		backpackCtrl:getItemCount(self.itemID).var = desertTreasureCtrl:getLuckyPoint()
		self.fields.Button_luck:setTitle(i18n("herovault_text_08", backpackCtrl:getItemCount(self.itemID)))
		self:updateLuckFill()
	end
	if self.stageRewardFlag then
		self.fields.List_cumuReward:setNumItems(table.nums(self.stageData))
		local per = desertTreasureltCtrl:getStagePercent(desertTreasureCtrl:getTreasureNum())
		self.fields.process_highLight:setFillAmount(per)
	end
	self.enter = false
end
function DesertSecretTreasurePanel:updateLuckFill()
	local luckPercent = desertTreasureltCtrl:getLuckyPercent(desertTreasureCtrl:getLuckyPoint())
	dump(percent, "Fjdksfjkdfjkd")
	self.fields.icon_luck_highLight:setFillAmount(luckPercent)
end
function DesertSecretTreasurePanel:setAniFrameConfig()
	self.fields.Ani_fly:setAllFrameName("YXMZ_DD_%.2d.png", 1)
	self.fields.Ani_boom:setAllFrameName("YXMZ_glow_%.2d.png", 1)
	self.fields.Ani_fill:setAllFrameName("YXMZ_baoshi_%.2d.png", 1)
end
function DesertSecretTreasurePanel:setToLocal()
	desertTreasureCtrl:sendInitMsg()
end
function DesertSecretTreasurePanel:requestInitData()
	desertTreasureCtrl:sendInitMsg()
end
function DesertSecretTreasurePanel:onItemRendererStage(index, object)
	object:initData(index + 1, self.stageData[index + 1])
end
function DesertSecretTreasurePanel:showUsm()
	self.fields.Com_usm:showUsm(3)
	local pos = desertTreasureCtrl:getPointTo()
	_UPVALUE1_ = nil
	;(nil)[1] = 1440 + (pos - 1) * 30
	self.transitions.anchorRotate:setValue("angle", nil)
	_UPVALUE1_ = nil
	;(nil)[1] = 1440 + (pos - 1) * 30
	self.transitions.anchorRotate:setValue("angle1", nil)
	self.transitions.anchorRotate:setHook("angle", function()
		self.fields.Com_rewardCol:showUsm(pos)
	end)
	self.transitions.anchorRotate:play()
end
function DesertSecretTreasurePanel:getReward(data)
	local rewards = data.rewards or self.rewards
	local _ENV, t
	for i, v in pairs(rewards) do
		if v.id then
			table.insert(t, v)
		end
	end
	SoraDMailGainItems(t, true)
	self.tryEffectComplete = true
end
function DesertSecretTreasurePanel:tryOnceSuccess(rewards, msg)
	self:showUsm()
	self.rewards = rewards
	if msg == "extract" and self.hadLuckRewardFlag then
		local lang = SoraDGetDefaultLanguage()
		self.transitions.right:play()
	end
end
function DesertSecretTreasurePanel:onItemRenderer(index, object)
	object:initData(index + 1, desertTreasureltCtrl.getStageRewardByIndex(index + 1))
end
function DesertSecretTreasurePanel:setTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		self.fields.Com_time:initData(eventTime.timerNode.timer:getRemainTime())
	end
end
function DesertSecretTreasurePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("desert_treasure_text_01")
	;(nil).contentColor = cc.c3b(255, 235, 185)
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function DesertSecretTreasurePanel:onClickLuckDetail()
	SoraDPlaySound()
	if desertTreasureltCtrl.hadLuckGearReward() then
		uiManager:show("DesertTreasureLuck"):setOwnerKey(self)
	else
		_ENV = nil
		;(nil).title = i18n("Mermaid_title_06")
		;(nil).content = i18n("desert_treasure_text_03")
		;(nil).contentColor = cc.c3b(255, 235, 185)
		uiManager:show("RuleView", nil):setOwnerKey(self)
	end
end
function DesertSecretTreasurePanel:onClickRun()
	if not self.enterUsmComplete or not self.tryEffectComplete then
		return
	end
	SoraDPlaySound()
	local nth = desertTreasureCtrl:getTreasureNum() + 1
	if backpackCtrl:getItemCount(self.itemID) >= desertTreasureltCtrl.getCost(nth) then
		self.tryEffectComplete = false
		self:requestTryOnce()
	else
		_ENV = nil
		;(nil).content = i18n("desert_treasure_text_02")
		;(nil).confirmFunc = function()
			self:jumpToGift(MSGBOX_CALLBACK_YES)
		end
		;(nil).cancelFunc = function()
		end
		uiManager:show("MessageBox", nil):setOwnerKey(self)
	end
end
function DesertSecretTreasurePanel:jumpToGift(type)
	if type == MSGBOX_CALLBACK_YES then
		local giftData = self:getGiftInfo()
		if giftData then
			if GLOBAL_GAME_RECHARGE_MODE then
				_ENV = nil
				;(nil).rechargeID = tonumber(giftData.ID)
				uiManager:show("rechargeView", nil)
			else
				local panel = SoraDCreatePanel("rechargeView")
				panel:jumpToLimitNode(giftData.category, tonumber(giftData.ID))
				panel:show()
			end
		else
			SoraDShowMsgTip(i18n("HeroVault_text_03"))
		end
	end
end
function DesertSecretTreasurePanel:getGiftInfo()
	local giftInfo = rechargeActivityCtrl:getHotActivityList()
	for i = 3, 1, -1 do
		local item = giftInfo[tostring(giftID[i])]
		if item and 1 <= tonumber(item.extraData) then
			return item
		end
	end
	return nil
end
function DesertSecretTreasurePanel:requestTryOnce()
	desertTreasureCtrl:sendExtractMsg()
end
function DesertSecretTreasurePanel:onClickReward()
	SoraDPlaySound()
	local group = desertTreasureCtrl:getGroup()
	local rewards = desertTreasureCtrl:setRewardGetFlag(desertTreasureltCtrl.getAward(group))
	_ENV = desertTreasureCtrl
	desertTreasureCtrl.title = i18n("hero_title_02")
	local desertTreasureCtrl.data, param = rewards, desertTreasureCtrl
	uiManager:show("CommonPopBox", param):setOwnerKey(self)
end
function DesertSecretTreasurePanel:resizeNoStageReward()
	local offset = self.fields.Button_cost:getPositionY() - (display.height - self.fields.Button_cost:getHeight())
	if -20 < offset then
		self.fields.Com_ownNum:setPositionY(self.fields.Com_ownNum:getPositionY() - 15)
	end
end
function DesertSecretTreasurePanel:resizeForRoom(stageRewardFlag)
	self.fields.bg_enter:setPositionY(self.fields.bg_enter:getPositionY() - 2)
	if display.width / display.height < 0.57 then
		return
	end
	if display.width / display.height < 0.601 and display.width / display.height > 0.599 then
		self.fields.bg_enter:setPositionY(self.fields.bg_enter:getPositionY() - 1)
	end
	if display.width / display.height < 0.6251 and display.width / display.height > 0.6249 then
		self.fields.bg_enter:setPositionX(self.fields.bg_enter:getPositionX() + 1)
	end
	if display.width / display.height > 0.7 then
		local scale = 0.9
		self.fields.Com_time:setScale(scale)
		self.fields.List_cumuReward:setScale(scale)
		self.fields.process_bg:setScale(scale)
		self.fields.process_highLight:setScale(scale)
		self.fields.Com_ownNum:setScale(scale)
		self.fields.Button_cost:setScale(scale)
		self.fields.Button_luck:setScale(scale)
		self.fields.Button_reward:setScale(scale)
		self.fields.bg:setPositionY(self.fields.bg:getPositionY() + 35)
		self.fields.bg_enter:setPositionY(self.fields.bg_enter:getPositionY() - 1)
		self.fields.List_cumuReward:setPositionY(display.height - 250)
		self.fields.Com_ownNum:setPositionY(display.height - 130)
		self.fields.Button_cost:setPositionY(display.height - 80)
		return
	end
	local pos1 = self.fields.compass:getPositionY()
	local pos2 = self.fields.List_cumuReward:getPositionY()
	if pos2 - pos1 < 400 then
		local offset = display.height - self.fields.Button_cost:getPositionY()
		self.fields.List_cumuReward:setPositionY(pos1 + 400)
	end
	local offset = self.fields.Button_cost:getPositionY() - (display.height - self.fields.Button_cost:getHeight())
	if -10 < offset then
		self.fields.List_cumuReward:setPositionY(display.height - 280)
		self.fields.Com_ownNum:setPositionY(self.fields.Com_ownNum:getPositionY() - 15)
		self.fields.Button_cost:setPositionY(self.fields.Button_cost:getPositionY() - 15)
	end
	offset = self.fields.Button_cost:getPositionY() - (display.height - self.fields.Button_cost:getHeight())
	if -10 < offset then
		self.fields.Button_cost:setPositionY(self.fields.Button_cost:getPositionY() - 10)
	end
end
function DesertSecretTreasurePanel:onShow()
	print("=======DesertSecretTreasurePanel:onShow")
end
function DesertSecretTreasurePanel:onHide()
	print("=======DesertSecretTreasurePanel:onHide")
end
function DesertSecretTreasurePanel:onDispose()
	print("=======DesertSecretTreasurePanel:onDispose")
end
return DesertSecretTreasurePanel
