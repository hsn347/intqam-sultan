local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RamadanWorldExplorerTaskPanel = class("RamadanWorldExplorerTaskPanel", baseFguiPanel)
function RamadanWorldExplorerTaskPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("RamadanWorldExplorerTaskPanel:ctor", self.viewName)
end
function RamadanWorldExplorerTaskPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RamadanWorldExplorerTaskPanel:onInit()
	print("=======RamadanWorldExplorerTaskPanel:onInit")
	self:updateView(self.proxy.param)
	self:fitHieghtView()
end
function RamadanWorldExplorerTaskPanel:updateView(param)
	self.taskId = SoraDGetCtrl("ramadanWorldExplorerCtrl"):getTaskIDByIndex(param.taskIdx)
	self.controllers.c1:setSelectedIndex(self.taskId == 5 and 1 or 0)
	self.fields.task_Bg:initData(param)
end
function RamadanWorldExplorerTaskPanel:onShow()
	print("=======RamadanWorldExplorerTaskPanel:onShow")
end
function RamadanWorldExplorerTaskPanel:fitHieghtView()
	if display.width / display.height <= 0.5633802816901409 then
		return
	end
	local height = self.view:getHeight() * 0.1
	self.view:setScale(0.9, 0.9)
	self.view:setPositionY(self.view:getPositionY() + height / 2 + 2)
end
function RamadanWorldExplorerTaskPanel:onHide()
	print("=======RamadanWorldExplorerTaskPanel:onHide")
end
function RamadanWorldExplorerTaskPanel:onDispose()
	print("=======RamadanWorldExplorerTaskPanel:onDispose")
end
return RamadanWorldExplorerTaskPanel
