local activity_9001731_Read = include("activity_9001731_Read")
local activity_9001731_Ctrl = SoraDGetCtrl("activity_9001731_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001731_TaskPanel = class("Activity_9001731_TaskPanel", baseFguiPanel)
function Activity_9001731_TaskPanel:ctor(...)
	self.isLRU = true
	Activity_9001731_TaskPanel.super.ctor(self, ...)
	print("Activity_9001731_TaskPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.FLYING_CHESS_ACTIVITY
end
function Activity_9001731_TaskPanel:onInit()
	print("=======Activity_9001731_TaskPanel:onInit")
	self.fields.Com_title:initData(i18n("balloon_hunter_003"), handler(self, self.onClickClose))
	self.fields.List_task:setVirtual()
	self.fields.List_task:setItemRenderer(handler(self, self.onTaskRenderer))
end
function Activity_9001731_TaskPanel:endShow()
	print("=======Activity_9001731_TaskPanel:endShow")
	self.taskCfg = activity_9001731_Read.getTaskCfg()
	local _ENV, stageData = activity_9001731_Read.getTaskCfg(), activity_9001731_Read.getTaskCfg()
	local stageCfg = activity_9001731_Read.getStageCfg()
	for __, cfg in ipairs(stageCfg) do
		_ENV = nil
		;(nil).stage = cfg.taskId
		;(nil).point = cfg.parameter
		;(nil).rewards = cfg.taskReward
		table.insert(stageData, nil)
	end
	self.stageData = stageData
	self.fields.Com_boxList:setBarColor(3)
	_ENV = 3
	;(3).activityID = self.activityID
	;(3).stageMax = #self.stageData
	self.fields.Com_boxList:initData(3)
	activity_9001731_Ctrl:sendReqInitDataMsg()
	SoraDShowLoading(self)
end
function Activity_9001731_TaskPanel:initView(target, data)
	SoraDCloseLoading(self)
	local times = activity_9001731_Ctrl:getGameTimes()
	_ENV = nil
	;(nil).num = times
	self.fields.Text_tip:setString(i18n("Ludo_test_027", nil))
	for __, data in ipairs(self.stageData) do
		data.state = activity_9001731_Ctrl:getStageBoxStatues(data.stage, data.point)
	end
	_ENV = ipairs(self.stageData)
	ipairs(self.stageData).score = times
	ipairs(self.stageData).stageData = self.stageData
	self.fields.Com_boxList:updateData(ipairs(self.stageData))
	self.taskData, _ENV = self.fields.Com_boxList.updateData, self.fields.Com_boxList.updateData
	for k, v in ipairs(self.taskCfg) do
		_ENV = data.stage
		data.stage.taskId = v.taskId
		data.stage.taskType = v.rewardType
		data.stage.parameter = v.parameter
		data.stage.taskReward = v.taskReward
		data.stage.status = activity_9001731_Ctrl:getTaskStatus(v.taskId, v.parameter)
		table.insert(self.taskData, data.stage)
	end
	table.sort(self.taskData, function(a, b)
		if a.status == b.status then
			return a.taskId < b.taskId
		else
			return a.status < b.status
		end
	end)
	self.fields.List_task:setNumItems(#self.taskData)
end
function Activity_9001731_TaskPanel:onTaskRenderer(index, obj)
	obj:initData(self.taskData[index + 1])
end
return Activity_9001731_TaskPanel
