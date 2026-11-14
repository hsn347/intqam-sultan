local activity_9001596_Read = include("activity_9001596_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001596_gainPanel = class("Activity_9001596_gainPanel", baseFguiPanel)
function Activity_9001596_gainPanel:ctor(...)
	Activity_9001596_gainPanel.super.ctor(self, ...)
	print("Activity_9001596_gainPanel:ctor", self.viewName)
end
function Activity_9001596_gainPanel:onInit()
	print("=======Activity_9001596_gainPanel:onInit")
	self.partList, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("starlight_btn_01"))
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
end
function Activity_9001596_gainPanel:onListRenderer(index, obj)
	obj:initData(self.partList[index + 1])
end
function Activity_9001596_gainPanel:onShow()
	print("=======Activity_9001596_gainPanel:onShow")
	self.part = self.param and self.param.part or 0
	self.controllers.c1:setSelectedIndex(self.part > 0 and 1 or 0)
	self.fields.List:setScrollEnable(self.part == 0)
	self:initData()
end
function Activity_9001596_gainPanel:initData()
	if self.part == 0 then
		_UPVALUE3_ = self.part
		self.partList, self.part[1] = self.part, activity_9001596_Read.partType.carriage
		self.partList, self.part[2] = self.part, activity_9001596_Read.partType.barrel
		self.partList, self.part[3] = self.part, activity_9001596_Read.partType.wheel
	else
		_UPVALUE1_ = self.part
		self.partList, self.part[1] = self.part, self.part
	end
	self.fields.List:setNumItems(#self.partList)
end
return Activity_9001596_gainPanel
