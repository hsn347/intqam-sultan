local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWonderlandTaskPanel = class("NebulaWonderlandTaskPanel", baseFguiPanel)
function NebulaWonderlandTaskPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaWonderlandTaskPanel:ctor", self.viewName)
end
function NebulaWonderlandTaskPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaWonderlandTaskPanel:onInit()
	print("=======NebulaWonderlandTaskPanel:onInit")
	self.activityID = gActivityTimeActivityID.NEBULA_WONDERLAND_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001433"), handler(self, self.onClickClose))
	self.fields.List_task:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData()
end
function NebulaWonderlandTaskPanel:initData()
	local questData = activityTaskComponentCtrl:getQuestData(self.activityID)
	self.taskList = eventQuestRead.getSortList(self.activityID, questData)
	dump(self.taskList, "NebulaWonderlandTaskPanel:initData")
	self.fields.List_task:setNumItems(table.nums(self.taskList))
end
function NebulaWonderlandTaskPanel:onItemRenderer(index, object)
	object:initData(self.taskList[index + 1])
end
function NebulaWonderlandTaskPanel:onShow()
	print("=======NebulaWonderlandTaskPanel:onShow")
end
return NebulaWonderlandTaskPanel
