local activity_9001729_Read = include("activity_9001729_Read")
local activity_9001729_Ctrl = SoraDGetCtrl("activity_9001729_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001729_ViewPanel = class("Activity_9001729_ViewPanel", baseFguiPanel)
function Activity_9001729_ViewPanel:ctor(...)
	self.isLRU = true
	Activity_9001729_ViewPanel.super.ctor(self, ...)
	print("Activity_9001729_ViewPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CRESCENT_TREASURE_ACTIVITY
end
function Activity_9001729_ViewPanel:onInit()
	print("=======Activity_9001729_ViewPanel:onInit")
	self.fields.btn_gift:setTitle(i18n("kindofwar_btn_01"))
	self.fields.btn_gift:addClickListener(handler(self, self.onClick_btn_gift))
	self.fields.comTitle:initData(i18n("activity_name_9001729"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.comTitle:initCommonActivityTime(self.activityID)
	self.stageData = activity_9001729_Ctrl:getStageData()
	_ENV = self.activityID
	self.activityID.activityID = self.activityID
	self.activityID.stageMax = #self.stageData
	self.fields.Com_boxList2:initData(self.activityID)
	self.tag = 2
	_ENV = self.activityID
	_ENV, _ENV, self.activityID.defaultClick = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).title = i18n("Ramadan_treasure_hunt_text_01")
	_ENV, self.tag[1], handler(self, self.onClickHelp).tag = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).title = i18n("activity_name_9001729")
	self.activityID.tabsetArray, self.tag[2], handler(self, self.onClickHelp).tag = self.tag, handler(self, self.onClickHelp)
	self.activityID.callback = handler(self, self.onTabClick)
	self.fields.comTitle:initTab(self.activityID)
	self.fields.stopAuto:addClickListener(handler(self, self.onClickStopAuto))
	self.fields.comSkip:fixChildrenPos()
end
function Activity_9001729_ViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Ramadan_treasure_hunt_text_14")
	uiManager:show("RuleView", nil)
end
function Activity_9001729_ViewPanel:endShow()
	print("=======Activity_9001729_ViewPanel:endShow")
	self.stageData = activity_9001729_Ctrl:getStageData()
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).stageMax = #self.stageData
	self.fields.Com_boxList2:initData(nil)
	self:enableDices(true)
	self.fields.comTitle:setTabIndex(2, true)
	self.fields.stopAuto:setVisible(false)
end
function Activity_9001729_ViewPanel:onClick_btn_gift(context)
	SoraDPlaySound()
	if activity_9001729_Ctrl:packageSoldOut() then
		SoraDShowMsgTip(i18n("snow_competition_text_02"))
		return
	end
	uiManager:show("Activity_9001729_Package")
end
function Activity_9001729_ViewPanel:onClickStopAuto(context)
	SoraDPlaySound()
	local comSkip = self.fields.comSkip
	comSkip:closeAuto()
end
function Activity_9001729_ViewPanel:onTabClick(tag)
	self.controllers.ctrlBattlePass:setSelectedIndex(tag - 1)
	if tag == 1 then
		self.fields.battlePass:initData(self.activityID)
	else
		self:initGame()
	end
end
function Activity_9001729_ViewPanel:initGame()
	self:updateDice()
	_ENV = nil
	;(nil).num = activity_9001729_Ctrl:getScore()
	self.fields.txtDes:setString(i18n("Ramadan_treasure_hunt_text_10", nil))
	self.stageData = activity_9001729_Ctrl:getStageData()
	_ENV = i18n("Ramadan_treasure_hunt_text_10", nil)
	i18n("Ramadan_treasure_hunt_text_10", nil).stageData = self.stageData
	i18n("Ramadan_treasure_hunt_text_10", nil).score = activity_9001729_Ctrl:getScore()
	self.fields.Com_boxList2:updateData(i18n("Ramadan_treasure_hunt_text_10", nil))
	self.fields.container:initData(self.activityID)
	self:updateReddot()
end
function Activity_9001729_ViewPanel:updateDice(data)
	if not data then
		if activity_9001729_Ctrl:getGoldDiceNum() > 0 then
			self.fields.dice2x:initDice(true, data)
			self.controllers.ctrlHasGold:setSelectedIndex(1)
		else
			self.controllers.ctrlHasGold:setSelectedIndex(0)
		end
	elseif data.isGold and 1 < data.oldData.goldDiceNum then
		self.fields.dice2x:initDice(true, data)
		self.controllers.ctrlHasGold:setSelectedIndex(1)
	elseif not data.isGold and 0 < data.oldData.goldDiceNum then
		self.fields.dice2x:initDice(true, data)
		self.controllers.ctrlHasGold:setSelectedIndex(1)
	else
		self.controllers.ctrlHasGold:setSelectedIndex(0)
	end
	self.fields.dice1x:initDice(nil, data)
end
function Activity_9001729_ViewPanel:onThrowDice(data)
	local comSkip = self.fields.comSkip
	if comSkip and comSkip:getIsAuto() then
		self.fields.stopAuto:setVisible(true)
	else
		self.fields.stopAuto:setVisible(false)
	end
	self:enableDices(false)
	self.fields.container:onThrowDice(data)
	_ENV = nil
	;(nil).num = activity_9001729_Ctrl:getScore()
	self.fields.txtDes:setString(i18n("Ramadan_treasure_hunt_text_10", nil))
	self:updateDice(data)
	self.stageData = activity_9001729_Ctrl:getStageData()
	_ENV = data
	data.stageData = self.stageData
	data.score = activity_9001729_Ctrl:getScore()
	self.fields.Com_boxList2:updateData(data)
end
function Activity_9001729_ViewPanel:onStageReward(...)
	self.stageData = activity_9001729_Ctrl:getStageData()
	activity_9001729_Ctrl = nil
	;(nil).stageData = self.stageData
	;(nil).score = activity_9001729_Ctrl:getScore()
	self.fields.Com_boxList2:updateData(nil)
	self:updateDice()
end
function Activity_9001729_ViewPanel:enableDices(enabled)
	self.fields.dice1x:setTouchable(enabled)
	self.fields.dice2x:setTouchable(enabled)
end
function Activity_9001729_ViewPanel:tryAutoThrow()
	local comSkip = self.fields.comSkip
	if comSkip and comSkip:getIsAuto() then
		local normalDiceNum = activity_9001729_Ctrl:getNormalDiceNum()
		if 0 < normalDiceNum then
			activity_9001729_Ctrl:reqThrowDiceMsg()
		else
			self.fields.comSkip:closeAuto()
		end
	else
		self.fields.comSkip:closeAuto()
	end
end
function Activity_9001729_ViewPanel:updateReddot()
	self.fields.btn_gift:setReddot(activity_9001729_Ctrl:getDailyRewardReceived() == false)
	local diceNum = activity_9001729_Ctrl:getNormalDiceNum() + activity_9001729_Ctrl:getGoldDiceNum()
	local stageRewardNum = activity_9001729_Ctrl:getStageRewardCanReceiveNum()
	local dailyGiftNum = activity_9001729_Ctrl:getDailyRewardReceived() == false and 1 or 0
	self.fields.comTitle:setBtnRedDot(2, 0 < diceNum + stageRewardNum + dailyGiftNum)
	local battlePassNum = activity_9001729_Ctrl:getBattlePassCanReceiveNum()
	self.fields.comTitle:setBtnRedDot(1, 0 < battlePassNum)
end
return Activity_9001729_ViewPanel
