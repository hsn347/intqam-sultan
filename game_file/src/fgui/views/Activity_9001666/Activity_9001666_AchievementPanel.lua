local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001666_AchievementPanel = class("Activity_9001666_AchievementPanel", baseFguiPanel)
local activity_9001666_Read = include("activity_9001666_Read")
local activity_9001666_Ctrl = SoraDGetCtrl("activity_9001666_Ctrl")
function Activity_9001666_AchievementPanel:ctor(...)
	Activity_9001666_AchievementPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001666_AchievementPanel:ctor", self.viewName)
end
function Activity_9001666_AchievementPanel:onInit()
	print("=======Activity_9001666_AchievementPanel:onInit")
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001666
	self.fields.Panel_bg:setTitle(i18n("common_text_1752"))
	local _ENV, stageData = self.fields.Panel_bg.setTitle, self.fields.Panel_bg.setTitle
	local stageConfig = activity_9001666_Read.getBoxCfgs()
	for i, cfg in ipairs(stageConfig) do
		_ENV = i18n("common_text_1752")
		i18n("common_text_1752").stage = i
		i18n("common_text_1752").point = cfg.point
		i18n("common_text_1752").rewards = cfg.reward
		table.insert(stageData, i18n("common_text_1752"))
	end
	self.stageData = stageData
	_ENV = ipairs(stageConfig)
	ipairs(stageConfig).activityID = self.activityID
	ipairs(stageConfig).stageMax = #self.stageData
	self.fields.Com_boxList:initData(ipairs(stageConfig))
	self.fields.list_task:setVirtual()
	self.fields.list_task:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.icon:fixPos()
	self.fields.text_value:fixPos()
end
function Activity_9001666_AchievementPanel:onShow()
	print("=======Activity_9001666_AchievementPanel:onShow")
	self:updateView()
end
function Activity_9001666_AchievementPanel:updateView()
	SoraDCloseLoading(self)
	for __, data in ipairs(self.stageData) do
		data.state = activity_9001666_Ctrl:getBoxRewardDataStatus(data.stage, data.point)
	end
	local maxScore = activity_9001666_Ctrl:getMaxScore()
	_ENV = nil
	;(nil).score = maxScore
	;(nil).stageData = self.stageData
	self.fields.Com_boxList:updateData(nil)
	self.fields.text_value:setString(maxScore)
	self.taskList, _ENV = self.fields.text_value.setString, self.fields.text_value.setString
	for i, v in ipairs(activity_9001666_Read.getAchievementCfgs()) do
		local state = activity_9001666_Ctrl:getAchieveStatus(v.index)
		_ENV = activity_9001666_Read.getAchievementCfgs()
		activity_9001666_Read.getAchievementCfgs().id = v.index
		activity_9001666_Read.getAchievementCfgs().cfg = v
		activity_9001666_Read.getAchievementCfgs().taskStatus = state
		activity_9001666_Read.getAchievementCfgs().order = state == gBtnTargetStatusDef.GET and 2 or state == gBtnTargetStatusDef.GO and 1 or 0
		table.insert(self.taskList, activity_9001666_Read.getAchievementCfgs())
		table.sort(self.taskList, function(a, b)
			if a.order == b.order then
				return a.id < b.id
			end
			return a.order > b.order
		end)
	end
	self.fields.list_task:setNumItems(#self.taskList)
end
function Activity_9001666_AchievementPanel:onItemRenderer(index, obj)
	local task = self.taskList[index + 1]
	obj:initData(task, self)
end
return Activity_9001666_AchievementPanel
