local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001629_TaskPanel = class("Activity_9001629_TaskPanel", baseFguiPanel)
local activity_9001629_Ctrl = SoraDGetCtrl("activity_9001629_Ctrl")
local activity_9001629_Read = include("activity_9001629_Read")
function Activity_9001629_TaskPanel:ctor(...)
	Activity_9001629_TaskPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001629_TaskPanel:ctor", self.viewName)
end
function Activity_9001629_TaskPanel:onInit()
	print("=======Activity_9001629_TaskPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("nebula_stars_wishing_text2"))
	self.fields.List_task:setVirtual()
	self.fields.List_task:setItemRenderer(handler(self, self.onItemRenderer))
	activity_9001629_Ctrl:reqTask()
end
function Activity_9001629_TaskPanel:onShow()
	print("=======Activity_9001629_TaskPanel:onShow")
	self:updateView()
end
function Activity_9001629_TaskPanel:updateView()
	self.globalCount = activity_9001629_Ctrl:getGlobalCount()
	activity_9001629_Ctrl = nil
	;(nil).num = self.globalCount
	self.fields.Text_task_tip:setString(i18n("nebula_stars_wishing_text30", nil))
	local taskCfgs = activity_9001629_Read.getTaskList()
	self.taskList, activity_9001629_Ctrl = self.fields.Text_task_tip, self.fields.Text_task_tip
	for i, v in ipairs(taskCfgs) do
		local status = gBtnTargetStatusDef.GO
		local order = 1
		if self.globalCount >= v.number then
			if activity_9001629_Ctrl:isTaskClaimed(v.index) then
				status = gBtnTargetStatusDef.GOT
				order = 0
			else
				status = gBtnTargetStatusDef.GET
				order = 2
			end
		end
		activity_9001629_Ctrl = gBtnTargetStatusDef
		gBtnTargetStatusDef.taskID = v.index
		gBtnTargetStatusDef.progress = self.globalCount
		activity_9001629_Ctrl, gBtnTargetStatusDef.taskStatus = self.globalCount, status
		activity_9001629_Ctrl = i18n("nebula_stars_wishing_text30", nil)
		i18n("nebula_stars_wishing_text30", nil).times = v.number
		gBtnTargetStatusDef.taskDes, self.globalCount[1] = self.globalCount, i18n("nebula_stars_wishing_text29", i18n("nebula_stars_wishing_text30", nil))
		gBtnTargetStatusDef.taskDes, self.globalCount[2] = self.globalCount, i18n("nebula_stars_wishing_text29", i18n("nebula_stars_wishing_text30", nil))
		gBtnTargetStatusDef.taskDes, self.globalCount[3] = self.globalCount, i18n("nebula_stars_wishing_text29", i18n("nebula_stars_wishing_text30", nil))
		gBtnTargetStatusDef.taskDes, self.globalCount[4] = self.globalCount, i18n("nebula_stars_wishing_text29", i18n("nebula_stars_wishing_text30", nil))
		gBtnTargetStatusDef.award = v.Rewards
		gBtnTargetStatusDef.aim = v.number
		gBtnTargetStatusDef.isAct = 0
		local gBtnTargetStatusDef.order, taskData = order, gBtnTargetStatusDef
		table.insert(self.taskList, taskData)
	end
	table.sort(self.taskList, function(a, b)
		if a.order == b.order then
			return a.taskID < b.taskID
		else
			return a.order > b.order
		end
	end)
	self.fields.List_task:setNumItems(table.nums(self.taskList))
end
function Activity_9001629_TaskPanel:getTaskStatus()
end
function Activity_9001629_TaskPanel:onItemRenderer(index, object)
	object:initData(self.taskList[index + 1])
	object:setHandler(handler(self, self.onGetReward))
end
function Activity_9001629_TaskPanel:onGetReward(taskID)
	SoraDPlaySound()
	if not activity_9001629_Ctrl:getIsHaveWish() then
		SoraDShowMsgTip(i18n("nebula_stars_wishing_text34"))
		return
	end
	activity_9001629_Ctrl:reqTaskReward(taskID)
end
return Activity_9001629_TaskPanel
