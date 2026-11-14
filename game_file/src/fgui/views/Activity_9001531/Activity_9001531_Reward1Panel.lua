local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001531_Reward1Panel = class("Activity_9001531_Reward1Panel", baseFguiPanel)
function Activity_9001531_Reward1Panel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001531_Reward1Panel:ctor", self.viewName)
end
function Activity_9001531_Reward1Panel:onInit()
	print("=======Activity_9001531_Reward1Panel:onInit")
	self.controllers.c_lan:setSelectedIndex(SoraDFIsRA() and 0 or 1)
	local itemID = self.proxy.param and self.proxy.param.itemID
	local iconPng = publicRead.getIcon(itemID)
	self.fields.icon:setURL(iconPng)
	local iconName = publicRead.getName(itemID)
	self.fields.title:setString(iconName)
	self.fields.Text_close:setString(i18n("Bright_fireworks_05"))
end
function Activity_9001531_Reward1Panel:onShow()
	print("=======Activity_9001531_Reward1Panel:onShow")
end
return Activity_9001531_Reward1Panel
