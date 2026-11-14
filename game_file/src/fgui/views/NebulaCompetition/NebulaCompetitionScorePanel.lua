local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaCompetitionScorePanel = class("NebulaCompetitionScorePanel", baseFguiPanel)
function NebulaCompetitionScorePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaCompetitionScorePanel:ctor", self.viewName)
end
function NebulaCompetitionScorePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaCompetitionScorePanel:onInit()
	print("=======NebulaCompetitionScorePanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_623"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function NebulaCompetitionScorePanel:onItemRenderer(index, obj)
	local data = self.taskList[index + 1]
	obj:initData(index, data)
end
function NebulaCompetitionScorePanel:onShow()
	print("=======NebulaCompetitionScorePanel:onShow")
	self.taskList = SoraDGetCtrl("nebulaCompetitionCtrl"):getStageTaskList()
	self.fields.List:setNumItems(#self.taskList)
end
return NebulaCompetitionScorePanel
