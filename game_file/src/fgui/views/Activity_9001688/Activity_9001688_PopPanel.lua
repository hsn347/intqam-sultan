local constantRead = include("constantRead")
local activity_9001688_Read = include("activity_9001688_Read")
local activity_9001688_Ctrl = SoraDGetCtrl("activity_9001688_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001688_PopPanel = class("Activity_9001688_PopPanel", baseFguiPanel)
function Activity_9001688_PopPanel:ctor(...)
	self.isLRU = true
	Activity_9001688_PopPanel.super.ctor(self, ...)
	print("Activity_9001688_PopPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.DAILY_SALUTE
end
function Activity_9001688_PopPanel:onInit()
	print("=======Activity_9001688_PopPanel:onInit")
	self.fields.Panel_bg:setString(i18n("decrypt_text_03"))
	self.fields.Label_title:setString(i18n("daily_salute_text08"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_time:setTimeLast(function(time, timeNum)
		if timeNum < 1 then
			return i18n("daily_salute_text28")
		else
			_ENV = nil
			;(nil).time = time
			return i18n("daily_salute_text27", nil)
		end
	end)
	self.fields.Com_boxList:setBarColor(3)
end
function Activity_9001688_PopPanel:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Activity_9001688_PopPanel:endShow()
	print("=======Activity_9001688_PopPanel:endShow")
	local _ENV, stageData = print, print
	local stageConfig = activity_9001688_Read.getStageCfg()
	for index, cfg in ipairs(stageConfig) do
		_ENV = nil
		;(nil).stage = index
		;(nil).point = cfg.score
		;(nil).rewards = cfg.reward
		table.insert(stageData, nil)
	end
	self.stageData = stageData
	_ENV = ipairs(stageConfig)
	ipairs(stageConfig).activityID = self.activityID
	ipairs(stageConfig).stageMax = #self.stageData
	self.fields.Com_boxList:initData(ipairs(stageConfig))
	SoraDShowLoading(self)
	activity_9001688_Ctrl:sendReqInitDataMsg()
end
function Activity_9001688_PopPanel:initView()
	SoraDCloseLoading(self)
	local value = activity_9001688_Ctrl:getGlobalScore()
	_ENV = nil
	;(nil).num = fguiHelper.getColorString("#FFDF2D", value)
	self.fields.Text_value:setString(i18n("daily_salute_text06", nil))
	for __, data in ipairs(self.stageData) do
		data.state = value >= data.point and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	end
	_ENV = ipairs(self.stageData)
	ipairs(self.stageData).score = value
	ipairs(self.stageData).stageData = self.stageData
	self.fields.Com_boxList:updateData(ipairs(self.stageData))
	local baseReward = constantRead.getConstValueArray("DAILY_SALUTE_BASE_REWARD")
	local stageReward = activity_9001688_Read.getStageReward(value)
	local _ENV, rewardMap = value, value
	for i = 1, #baseReward - 1, 2 do
		rewardMap[baseReward[i]] = baseReward[i + 1]
	end
	for k, v in ipairs(stageReward) do
		rewardMap[v.id] = v.count + (rewardMap[v.id] or 0)
	end
	self.reward, _ENV = ipairs(stageReward)
	for id, count in pairs(rewardMap) do
		_ENV = rewardMap[v.id] or 0
		;(rewardMap[v.id] or 0).id = id
		;(rewardMap[v.id] or 0).count = count
		table.insert(self.reward, rewardMap[v.id] or 0)
	end
	table.sort(self.reward, function(a, b)
		return a.id < b.id
	end)
	self.fields.List:setNumItems(#self.reward)
	local status, leftTime = activity_9001688_Ctrl:getCycleState()
	if status == 0 then
		self.fields.Text_time:beginTime(leftTime)
	else
		self.fields.Text_time:endTime()
		self.fields.Text_time:setString(i18n("daily_salute_text28"))
	end
end
return Activity_9001688_PopPanel
