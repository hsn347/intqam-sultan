local gametop = gModuleMgr.getObject("gametop")
local activity_9001615_Ctrl = SoraDGetCtrl("activity_9001615_Ctrl")
local eventQuestRead = include("eventQuestRead")
local questDesRead = include("questDesRead")
_ENV = "questDesRead"
;("questDesRead").FINISH = 1
;("questDesRead").UNCOMPLETE = 2
local ("questDesRead").RECEIVE, TaskStatus = 3, "questDesRead"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001615_TaskPopViewPanel = class("Activity_9001615_TaskPopViewPanel", baseFguiPanel)
function Activity_9001615_TaskPopViewPanel:ctor(...)
	Activity_9001615_TaskPopViewPanel.super.ctor(self, ...)
	print("Activity_9001615_TaskPopViewPanel:ctor", self.viewName)
end
function Activity_9001615_TaskPopViewPanel:onInit()
	print("=======Activity_9001615_TaskPopViewPanel:onInit")
	self.ccs_bg = SoraDGetChildByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitle(i18n("Smelt_text_43"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	self.scroll:setVirtual()
	self.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.textTip = SoraDGetChildByName(self, "Text_task_tip")
	self.textTip:setString(i18n("task_text_02"))
end
function Activity_9001615_TaskPopViewPanel:onShow()
	print("=======Activity_9001615_TaskPopViewPanel:onShow")
	self:initData()
end
function Activity_9001615_TaskPopViewPanel:initData()
	self.taskList = activity_9001615_Ctrl:getTasks()
	dump(self.taskList, "self.taskList")
	local task = self.taskList[1]
	self.textTip:setVisible(false)
	if task then
		local taskCfg = eventQuestRead.getTaskConfig(task.taskID)
		if taskCfg and taskCfg.type == 1 then
			self.textTip:setVisible(true)
		end
	end
	self.scroll:setNumItems(#self.taskList)
end
function Activity_9001615_TaskPopViewPanel:onItemRenderer(index, obj)
	obj:fixChildrenPos()
	local single = fguiHelper.get_fields(obj)
	single.Button_go:setTitle(i18n("alliance_btn_02"))
	if not single.Button_go.addClick then
		single.Button_go.addClick = true
		single.Button_go:addTouchEventListener(handler(self, self.btnGoClick))
	end
	single.Node_got = SoraDGetChildByName(obj, "Node_got")
	single.Text_got = SoraDGetChildByName(obj, "Text_got")
	single.Text_got:setString(i18n("common_text_1892"))
	single.Text_schedule = SoraDGetChildByName(obj, "Text_player")
	self:refreshSingle(single, self.taskList[index + 1])
end
function Activity_9001615_TaskPopViewPanel:refreshSingle(single, data, otherData)
	local taskID = data.taskID
	local status = data.status
	local progress = data.progress
	eventQuestRead, eventQuestRead, single.Button_go.data = nil, single.Button_go, data
	;(nil).color = "#ffff00"
	eventQuestRead, single.Button_go.num, (nil).i = nil, nil, "true"
	single.Button_go.__default, (nil).color = nil, "#d7c39b"
	local styles = single.Button_go
	single.Text_des:setString(eventQuestRead.getDesEx(taskID, styles))
	local targetStr = eventQuestRead.getAim(taskID)
	if type(targetStr) == "number" then
		if progress > targetStr then
			progress = targetStr
		end
		targetStr = string.formatnumberthousands(targetStr)
	end
	eventQuestRead = eventQuestRead.getDesEx(taskID, styles)
	eventQuestRead.getDesEx(taskID, styles).count = string.formatnumberthousands(progress)
	eventQuestRead, eventQuestRead.getDesEx(taskID, styles).total = string.formatnumberthousands(progress), targetStr
	if status == TaskStatus.FINISH then
		eventQuestRead = TaskStatus.FINISH
		TaskStatus.FINISH.color = "#d7c39b"
		if TaskStatus.FINISH then
			goto lbl_58
		end
	end
	eventQuestRead = TaskStatus.FINISH
	eventQuestRead, string.formatnumberthousands(progress).count, TaskStatus.FINISH.color = TaskStatus.FINISH, TaskStatus.FINISH, "#be2828"
	::lbl_58::
	eventQuestRead, string.formatnumberthousands(progress).total, TaskStatus.FINISH.color = TaskStatus.FINISH, TaskStatus.FINISH, "#d7c39b"
	string.formatnumberthousands(progress).__default, TaskStatus.FINISH.color = TaskStatus.FINISH, "#d7c39b"
	single.Text_schedule:setString(i18n_html("common_text_3683", eventQuestRead.getDesEx(taskID, styles)))
	local guideId = eventQuestRead.getGuideId(data.taskID)
	single.Node_got:setVisible(status == TaskStatus.RECEIVE)
	single.Button_go:setVisible(status ~= TaskStatus.RECEIVE and guideId ~= nil)
	local btnTitle = status == TaskStatus.UNCOMPLETE and i18n("common_text_477") or status == TaskStatus.FINISH and i18n("common_text_1146") or i18n("common_text_1892")
	single.Button_go:setTitle(btnTitle)
	if status == TaskStatus.RECEIVE then
		single.Button_go:setBright(false)
		single.Button_go:setBtnColorIndex(0)
	elseif status == TaskStatus.UNCOMPLETE then
		single.Button_go:setBright(true)
		single.Button_go:setBtnColorIndex(0)
	else
		single.Button_go:setBright(true)
		single.Button_go:setBtnColorIndex(2)
	end
	local rewards = eventQuestRead.getReward(taskID)
	single.rewards:setItemRenderer(function(index2, obj2)
		local award = rewards[index2 + 1]
		obj2:initData(award.id, award.count)
	end)
	single.rewards:setNumItems(#rewards)
end
function Activity_9001615_TaskPopViewPanel:btnGoClick(button, type)
	SoraDPlaySound()
	if button.data.status == TaskStatus.FINISH then
		local activity_9001615_Ctrl = SoraDGetCtrl("activity_9001615_Ctrl")
		activity_9001615_Ctrl:reqClaim(button.data.taskID)
	else
		local guideId = eventQuestRead.getGuideId(button.data.taskID)
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		local tbParam = mildGuideManager:splitGuideParam(guideId)
		if tbParam.id == gNewPLayerTaskType.POP_TIP then
			SoraDShowMsgTip(i18n(taskDes))
		end
		if guideId then
			SoraDRemoveAllPanelFromManager()
			mildGuideManager:starMildByNewPlayerStringParam(guideId)
		end
	end
end
return Activity_9001615_TaskPopViewPanel
