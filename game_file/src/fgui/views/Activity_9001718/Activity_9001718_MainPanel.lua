local activityCommonDrawRead = include("activityCommonDrawRead")
local activityCommonDrawCtrl = SoraDGetCtrl("activityCommonDrawCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001718_MainPanel = class("Activity_9001718_MainPanel", baseFguiPanel)
function Activity_9001718_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001718_MainPanel.super.ctor(self, ...)
	print("Activity_9001718_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.LAMP_WISH_ACTIVITY
	self.costID = activityCommonDrawCtrl:getItemID(self.activityID)
	self.costNum = activityCommonDrawCtrl:getItemCost(self.activityID)
end
function Activity_9001718_MainPanel:onInit()
	print("=======Activity_9001718_MainPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_reward:setString(i18n("soldier_rush_text_11"))
	self.fields.Button_reward:addClickListener(handler(self, self.btnRewardClick))
	self.fields.Button_one:setString(i18n("prayer_lamp_002"))
	self.fields.Button_one:addClickListener(handler(self, self.btnOneClick))
	self.fields.Button_ten:setString(i18n("prayer_lamp_003"))
	self.fields.Button_ten:addClickListener(handler(self, self.btnTenClick))
	self.fields.Com_boxList:setBarColor(3)
	self.fields.Button_one:fixPos()
	self.fields.Button_ten:fixPos()
end
function Activity_9001718_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("prayer_lamp_001")
	uiManager:show("RuleView", nil)
end
function Activity_9001718_MainPanel:initPre()
	local rewards = activityCommonDrawRead.activity_9001718_getMayReward()
	for i = 1, 5 do
		local target = self.fields.Com_pre:getChild("n" .. i)
		if rewards[i] then
			target:getChild("Com_item"):initData(rewards[i].id)
			local isSuper = activityCommonDrawRead.isSuperReward(rewards[i].id, rewards[i].count)
			target:getController("c1"):setSelectedIndex(1)
			target:setVisible(true)
		else
			target:setVisible(false)
		end
	end
end
function Activity_9001718_MainPanel:endShow()
	print("=======Activity_9001718_MainPanel:endShow")
	self:initPre()
	local _ENV, stageData = self.initPre, self.initPre
	local stageCfg = activityCommonDrawRead.activity_9001718_getStageCfg()
	for __, cfg in ipairs(stageCfg) do
		_ENV = nil
		;(nil).stage = cfg.stageIndex
		;(nil).point = cfg.accumulate
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		;(nil).rewards = serviceFunctions.tableFormat(cfg.accumulateReward, nil)
		table.insert(stageData, nil)
	end
	self.stageData = stageData
	_ENV = ipairs(stageCfg)
	ipairs(stageCfg).activityID = self.activityID
	ipairs(stageCfg).stageMax = #self.stageData
	self.fields.Com_boxList:initData(ipairs(stageCfg))
	self:initView()
end
function Activity_9001718_MainPanel:updateItem(target, data)
	self.fields.Com_have:initData(self.costID)
	self.itemCount = backpackCtrl:getItemCount(self.costID)
	self.fields.Button_one:setCost(self.costID, self.costNum)
	self.fields.Button_one:setIsEnough(self.itemCount >= self.costNum)
	self.fields.Button_ten:setCost(self.costID, self.costNum * 10)
	self.fields.Button_ten:setIsEnough(self.itemCount >= self.costNum * 10)
end
function Activity_9001718_MainPanel:initView(target, data)
	SoraDCloseLoading(self)
	if data and data.rewards then
		_ENV = nil
		;(nil).rewards = data.rewards
		uiManager:show("CommonCongratulations", nil)
	end
	self.data = activityCommonDrawCtrl:getActivityData(self.activityID)
	for __, data in ipairs(self.stageData) do
		data.state = self:getStageBoxStatues(data.stage, data.point)
	end
	_ENV = ipairs(self.stageData)
	ipairs(self.stageData).score = self.data.totalTimes
	ipairs(self.stageData).stageData = self.stageData
	self.fields.Com_boxList:updateData(ipairs(self.stageData))
	self:updateItem()
	_ENV = data.rewards
	data.rewards.num = fguiHelper.getColorString("#FFD43E", self.data.totalTimes)
	self.fields.Text_times:setString(i18n("prayer_lamp_008", data.rewards))
end
function Activity_9001718_MainPanel:getStageBoxStatues(stage, point)
	local stageData = self.data.stageReward[tostring(stage)]
	local state = stageData and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	if state ~= gBtnTargetStatusDef.GOT and point <= self.data.totalTimes then
		state = gBtnTargetStatusDef.GET
	end
	return state
end
function Activity_9001718_MainPanel:btnRewardClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("hero_title_02")
	;(nil).rewardData = activityCommonDrawRead.activity_9001718_getMayReward()
	uiManager:show("Common_RewardPre", nil)
end
function Activity_9001718_MainPanel:btnOneClick()
	SoraDPlaySound()
	if self.itemCount < self.costNum then
		SoraDShowMsgTip(i18n("Smelt_text_35"))
		_ENV = i18n("Smelt_text_35")
		i18n("Smelt_text_35").itemID = self.costID
		uiManager:show("CommonSourceGuide", i18n("Smelt_text_35"))
		return
	end
	activityCommonDrawCtrl:reqDrawOne(self.activityID, self.costNum)
	SoraDShowLoading(self)
end
function Activity_9001718_MainPanel:btnTenClick()
	SoraDPlaySound()
	if self.itemCount < self.costNum * 10 then
		SoraDShowMsgTip(i18n("Smelt_text_35"))
		_ENV = i18n("Smelt_text_35")
		i18n("Smelt_text_35").itemID = self.costID
		uiManager:show("CommonSourceGuide", i18n("Smelt_text_35"))
		return
	end
	activityCommonDrawCtrl:reqDrawOne(self.activityID, self.costNum * 10)
	SoraDShowLoading(self)
end
return Activity_9001718_MainPanel
