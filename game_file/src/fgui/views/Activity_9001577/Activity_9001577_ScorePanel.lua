local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001577_ScorePanel = class("Activity_9001577_ScorePanel", baseFguiPanel)
function Activity_9001577_ScorePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001577_ScorePanel:ctor", self.viewName)
end
function Activity_9001577_ScorePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001577_ScorePanel:onInit()
	print("=======Activity_9001577_ScorePanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_623"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001577_ScorePanel:onItemRenderer(index, obj)
	local data = self.taskList[index + 1]
	obj:initData(index, data)
end
function Activity_9001577_ScorePanel:onShow()
	print("=======Activity_9001577_ScorePanel:onShow")
	self.taskList = SoraDGetCtrl("activity_9001577_Ctrl"):getStageTaskList()
	self.fields.List:setNumItems(#self.taskList)
end
return Activity_9001577_ScorePanel
