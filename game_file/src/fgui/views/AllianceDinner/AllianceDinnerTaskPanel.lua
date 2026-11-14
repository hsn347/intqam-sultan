local baseFguiPanel = require("fgui.base.baseFguiPanel")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local AllianceDinnerTaskPanel = class("AllianceDinnerTaskPanel", baseFguiPanel)
function AllianceDinnerTaskPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("AllianceDinnerTaskPanel:ctor", self.viewName)
end
function AllianceDinnerTaskPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceDinnerTaskPanel:onInit()
	print("=======AllianceDinnerTaskPanel:onInit")
	self.activityID = gActivityTimeActivityID.ALLIANCE_DINNER_ACTIVITY
	self.fields.Com_title:initData(i18n("Alliance_dinner_02"), handler(self, self.onClickClose))
	self.fields.List_task:setVirtual()
	self.fields.List_task:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData()
end
function AllianceDinnerTaskPanel:onShow()
	print("=======AllianceDinnerTaskPanel:onShow")
end
function AllianceDinnerTaskPanel:initData()
	local questData = activityTaskComponentCtrl:getQuestData(self.activityID)
	self.taskList = eventQuestRead.getSortList(self.activityID, questData)
	dump(self.taskList, "AllianceDinnerTaskPanel:initData")
	self.fields.List_task:setNumItems(table.nums(self.taskList))
end
function AllianceDinnerTaskPanel:onItemRenderer(index, object)
	object:initData(self.taskList[index + 1])
end
return AllianceDinnerTaskPanel
