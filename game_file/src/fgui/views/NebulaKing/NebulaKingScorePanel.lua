local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaKingScorePanel = class("NebulaKingScorePanel", baseFguiPanel)
function NebulaKingScorePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaKingScorePanel:ctor", self.viewName)
end
function NebulaKingScorePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaKingScorePanel:onInit()
	print("=======NebulaKingScorePanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_623"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function NebulaKingScorePanel:onItemRenderer(index, obj)
	local data = self.taskList[index + 1]
	obj:initData(index, data)
end
function NebulaKingScorePanel:onShow()
	print("=======NebulaKingScorePanel:onShow")
	self.taskList = SoraDGetCtrl("nebulaKingCtrl"):getStageTaskList()
	self.fields.List:setNumItems(#self.taskList)
end
return NebulaKingScorePanel
