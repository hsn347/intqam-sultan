local eventQuestRead = include("eventQuestRead")
local activity_9001602_Ctrl = SoraDGetCtrl("activity_9001602_Ctrl")
local activity_9001696_Ctrl = SoraDGetCtrl("activity_9001696_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001602_RecordPanel = class("Activity_9001602_RecordPanel", baseFguiPanel)
_ENV = "Activity_9001602_RecordPanel"
;("Activity_9001602_RecordPanel")[gActivityTimeActivityID.NORMAL_ACTIVITY_9001602] = activity_9001602_Ctrl
local ("Activity_9001602_RecordPanel")[gActivityTimeActivityID.NORMAL_ACTIVITY_9001696], activityCtrl = activity_9001696_Ctrl, "Activity_9001602_RecordPanel"
function Activity_9001602_RecordPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001602_RecordPanel:ctor", self.viewName)
	self.debug = true
end
function Activity_9001602_RecordPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001602_RecordPanel:onInit()
	print("=======Activity_9001602_RecordPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("lost_ruins_text_23"))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001602_RecordPanel:onShow()
	self.activityID = self.param.activityID
	print("=======Activity_9001602_RecordPanel:onShow")
	activityCtrl[self.activityID]:reqLegendOfPegasusClearNewNum()
	self.records = activityCtrl[self.activityID]:getRecordList()
	self.fields.scroll:setNumItems(#self.records)
	self.fields.txt_nodesc:setVisible(#self.records == 0)
	self.fields.txt_nodesc:setString(i18n("firedragon_of_anger_text15"))
end
function Activity_9001602_RecordPanel:onHide()
	print("=======Activity_9001602_RecordPanel:onHide")
end
function Activity_9001602_RecordPanel:onDispose()
	print("=======Activity_9001602_RecordPanel:onDispose")
end
function Activity_9001602_RecordPanel:onItemRenderer(index, obj)
	local record = self.records[index + 1]
	obj:initData(record, self.activityID)
end
return Activity_9001602_RecordPanel
