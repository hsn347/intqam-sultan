local backToTopCtrl = SoraDGetCtrl("backToTopCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local backToTopTaskViewPanel = class("backToTopTaskViewPanel", baseFguiPanel)
function backToTopTaskViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("backToTopTaskViewPanel:ctor", self.viewName)
end
function backToTopTaskViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function backToTopTaskViewPanel:onInit()
	print("=======backToTopTaskViewPanel:onInit")
	self.fields.Com_title:initData(i18n("return_peak_02"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.itemRender))
end
function backToTopTaskViewPanel:itemRender(index, obj)
	obj:initData(self.taskList[index + 1])
end
function backToTopTaskViewPanel:onShow()
	print("=======backToTopTaskViewPanel:onShow")
	self:initData()
end
function backToTopTaskViewPanel:initData()
	self.taskList = backToTopCtrl:getTaskList()
	self.fields.List:setNumItems(#self.taskList)
end
return backToTopTaskViewPanel
