local activity_9001719_Read = include("activity_9001719_Read")
local activity_9001719_Ctrl = SoraDGetCtrl("activity_9001719_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001719_TaskPanel = class("Activity_9001719_TaskPanel", baseFguiPanel)
function Activity_9001719_TaskPanel:ctor(...)
	self.isLRU = true
	Activity_9001719_TaskPanel.super.ctor(self, ...)
	print("Activity_9001719_TaskPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.MAGIC_CARPET
end
function Activity_9001719_TaskPanel:onInit()
	print("=======Activity_9001719_TaskPanel:onInit")
	self.fields.Com_title:initData(i18n("balloon_hunter_003"), handler(self, self.onClickClose))
	self.fields.List_task:setVirtual()
	self.fields.List_task:setItemRenderer(handler(self, self.onTaskRenderer))
end
function Activity_9001719_TaskPanel:onTaskRenderer(index, obj)
	obj:initData(self.taskData[index + 1])
end
function Activity_9001719_TaskPanel:endShow()
	print("=======Activity_9001719_TaskPanel:endShow")
	self.taskCfg = activity_9001719_Read.getTaskCfg(activity_9001719_Ctrl:getClassType())
	local _ENV, stageData = activity_9001719_Read.getTaskCfg(activity_9001719_Ctrl:getClassType()), activity_9001719_Read.getTaskCfg(activity_9001719_Ctrl:getClassType())
	local stageCfg = activity_9001719_Read.getStageCfg()
	for __, cfg in ipairs(stageCfg) do
		_ENV = activity_9001719_Ctrl:getClassType()
		activity_9001719_Ctrl:getClassType().stage = cfg.stageId
		activity_9001719_Ctrl:getClassType().point = cfg.stage
		activity_9001719_Ctrl:getClassType().rewards = cfg.stageReward
		table.insert(stageData, activity_9001719_Ctrl:getClassType())
	end
	self.stageData = stageData
	self.fields.Com_boxList:setBarColor(3)
	_ENV = 3
	;(3).activityID = self.activityID
	;(3).stageMax = #self.stageData
	self.fields.Com_boxList:initData(3)
	self:initView()
	self.fields.List_task:jumpToTop()
end
function Activity_9001719_TaskPanel:initView()
	local score = activity_9001719_Ctrl:getScore()
	activity_9001719_Ctrl = nil
	;(nil).score = fguiHelper.getColorString("#FFD43E", score)
	self.fields.Text_tip:setString(i18n("magic_carpet_04", nil))
	for __, data in ipairs(self.stageData) do
		data.state = activity_9001719_Ctrl:getStageBoxStatues(data.stage, data.point)
	end
	activity_9001719_Ctrl = ipairs(self.stageData)
	ipairs(self.stageData).score = score
	ipairs(self.stageData).stageData = self.stageData
	self.fields.Com_boxList:updateData(ipairs(self.stageData))
	self.taskData, activity_9001719_Ctrl = self.fields.Com_boxList.updateData, self.fields.Com_boxList.updateData
	for k, v in ipairs(self.taskCfg) do
		activity_9001719_Ctrl = data.stage
		data.stage.taskId = v.taskId
		data.stage.taskType = v.taskType
		data.stage.parameter = v.parameter
		data.stage.taskReward = v.taskReward
		data.stage.status = activity_9001719_Ctrl:getTaskStatus(v.taskId, v.taskType, v.parameter)
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
return Activity_9001719_TaskPanel
