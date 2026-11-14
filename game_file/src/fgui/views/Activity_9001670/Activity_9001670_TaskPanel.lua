local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local activity_9001670_Ctrl = SoraDGetCtrl("activity_9001670_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001670_TaskPanel = class("Activity_9001670_TaskPanel", baseFguiPanel)
function Activity_9001670_TaskPanel:ctor(...)
	Activity_9001670_TaskPanel.super.ctor(self, ...)
	print("Activity_9001670_TaskPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.REBUILD_BUBBLE_LAND
end
function Activity_9001670_TaskPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity_9001624"
	end
	return self._packageList
end
function Activity_9001670_TaskPanel:onInit()
	print("=======Activity_9001670_TaskPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_4498"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
end
function Activity_9001670_TaskPanel:onShow()
	print("=======Activity_9001670_TaskPanel:onShow")
	self:updateTaskList()
end
function Activity_9001670_TaskPanel:updateTaskList(...)
	self.taskList = activity_9001670_Ctrl:getTaskList()
	self.fields.List:setNumItems(#self.taskList)
end
function Activity_9001670_TaskPanel:onItemRenderer(index, obj)
	obj:initData(self.activityID, self.taskList[index + 1])
	obj:setHandler(handler(self, self.onGetReward))
end
function Activity_9001670_TaskPanel:onGetReward(taskID)
	SoraDPlaySound()
	local taskComponent = activityTaskComponentCtrl:getQuestComponent(self.activityID)
	local taskStatus = taskComponent:getTaskState(taskID)
	if taskStatus == gBtnTargetStatusDef.GOT and not activity_9001670_Ctrl:getIsAdvanceRewardUnlock() then
		self:openBuyGiftView()
		return
	end
	activity_9001670_Ctrl:reqQuestReward(taskID)
end
function Activity_9001670_TaskPanel:openBuyGiftView(...)
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).rewardType = 2
	uiManager:show("Activity_9001637_BuyGift", nil)
end
function Activity_9001670_TaskPanel:onMsgUpdateData(target, event)
	SoraDCloseLoading()
	local subMsg = event.subMsg
	if subMsg == "questReward" then
		self:updateTaskList()
	elseif subMsg == "buyGift" then
		self:updateTaskList()
	end
end
return Activity_9001670_TaskPanel
