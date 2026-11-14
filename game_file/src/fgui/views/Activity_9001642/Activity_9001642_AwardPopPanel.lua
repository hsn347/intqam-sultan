local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001642_AwardPopPanel = class("Activity_9001642_AwardPopPanel", baseFguiPanel)
function Activity_9001642_AwardPopPanel:ctor(...)
	Activity_9001642_AwardPopPanel.super.ctor(self, ...)
	print("Activity_9001642_AwardPopPanel:ctor", self.viewName)
end
function Activity_9001642_AwardPopPanel:onInit()
	print("=======Activity_9001642_AwardPopPanel:onInit")
	self.fields.Panel_bg:setString(i18n("king_tri_text_18"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001642_AwardPopPanel:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1], index + 1)
end
function Activity_9001642_AwardPopPanel:onShow()
	print("=======Activity_9001642_AwardPopPanel:onShow")
	self.reward = self.param.reward
	self.fields.List:setNumItems(#self.reward)
end
return Activity_9001642_AwardPopPanel
