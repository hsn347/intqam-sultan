local activity_9001734_Read = include("activity_9001734_Read")
local activity_9001734_Ctrl = SoraDGetCtrl("activity_9001734_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001734_RecordPanel = class("Activity_9001734_RecordPanel", baseFguiPanel)
function Activity_9001734_RecordPanel:ctor(...)
	self.isLRU = true
	Activity_9001734_RecordPanel.super.ctor(self, ...)
	print("Activity_9001734_RecordPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001734
end
function Activity_9001734_RecordPanel:onInit()
	print("=======Activity_9001734_RecordPanel:onInit")
	self.fields.list_Record:setItemRenderer(handler(self, self.itemRenderer_list_Record))
	self.fields.Panel_bg:setString(i18n("football_betting_text_15"))
	self.fields.Text_noData:setString(i18n("common_text_1464"))
end
function Activity_9001734_RecordPanel:onExit()
	activity_9001734_Ctrl:cleanReadRecordNum()
	activity_9001734_Ctrl = activity_9001734_Ctrl
	activity_9001734_Ctrl.msg = "MESSAGE_ACTIVITY_9001734_RECORD"
	SoraDSendMessage(activity_9001734_Ctrl)
end
function Activity_9001734_RecordPanel:endShow()
	print("=======Activity_9001734_RecordPanel:endShow")
	self:updateData()
end
function Activity_9001734_RecordPanel:updateData()
	self.resultList = activity_9001734_Ctrl:getPredictResultList()
	self.fields.list_Record:setNumItems(#self.resultList)
	self.fields.Text_noData:setVisible(#self.resultList == 0)
end
function Activity_9001734_RecordPanel:itemRenderer_list_Record(index, obj)
	local data = self.resultList[index + 1]
	obj:initData(data)
end
return Activity_9001734_RecordPanel
