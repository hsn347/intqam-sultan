local activity_9001717_Read = include("activity_9001717_Read")
local activity_9001717_Ctrl = SoraDGetCtrl("activity_9001717_Ctrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001717_TaskPanel = class("Activity_9001717_TaskPanel", baseFguiPanel)
function Activity_9001717_TaskPanel:ctor(...)
	self.isLRU = true
	Activity_9001717_TaskPanel.super.ctor(self, ...)
	print("Activity_9001717_TaskPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.FANTASY_LAND
end
function Activity_9001717_TaskPanel:onInit()
	print("=======Activity_9001717_TaskPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_4498"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_tip:setString(i18n("Bubble_island_rebuild_text_17"))
end
function Activity_9001717_TaskPanel:endShow()
	print("=======Activity_9001717_TaskPanel:endShow")
	self.doStage = activity_9001717_Ctrl:getDoStage()
	self:updateTaskList()
	self.fields.List:jumpToTop()
end
function Activity_9001717_TaskPanel:updateTaskList(...)
	self.taskList = activity_9001717_Ctrl:getTaskList()
	self.fields.List:setNumItems(#self.taskList)
end
function Activity_9001717_TaskPanel:onItemRenderer(index, obj)
	obj:initData(self.activityID, self.taskList[index + 1])
	obj:setHandler(handler(self, self.onGetReward))
end
function Activity_9001717_TaskPanel:onGetReward(taskID)
	SoraDPlaySound()
	local taskComponent = activityTaskComponentCtrl:getQuestComponent(self.activityID)
	local taskStatus = taskComponent:getTaskState(taskID)
	if taskStatus == gBtnTargetStatusDef.GOT and not activity_9001717_Ctrl:getIsAdvanceRewardUnlock() then
		self:openBuyGiftView()
		return
	end
	activity_9001717_Ctrl:reqQuestReward(taskID)
end
function Activity_9001717_TaskPanel:openBuyGiftView(...)
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).rewardType = 2
	uiManager:show("Activity_9001637_BuyGift", nil)
end
function Activity_9001717_TaskPanel:onMsgUpdateData(target, event)
	local subMsg = event.subMsg
	if subMsg == "questReward" then
		self:updateTaskList()
	elseif subMsg == "buyGift" then
		self:updateTaskList()
	end
end
function Activity_9001717_TaskPanel:onMsgCheckStage(target, data)
	if data and data.activityID and SoraDisInList(self.activityID, data.activityID) and self.doStage ~= activity_9001717_Ctrl:getDoStage() then
		self:close()
	end
end
return Activity_9001717_TaskPanel
