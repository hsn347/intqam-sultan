local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local mailGivePersentHelpPanel = class("mailGivePersentHelpPanel", baseFguiPanel)
function mailGivePersentHelpPanel:ctor(...)
	mailGivePersentHelpPanel.super.ctor(self, ...)
	print("mailGivePersentHelpPanel:ctor", self.viewName)
end
function mailGivePersentHelpPanel:onInit()
	print("=======mailGivePersentHelpPanel:onInit")
	self.itemList, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("common_text_4834"))
	self.fields.Text_tip:setString(i18n("common_text_1462"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function mailGivePersentHelpPanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1])
end
function mailGivePersentHelpPanel:onShow()
	print("=======mailGivePersentHelpPanel:onShow")
	self.itemList = backpackltCtrl:getCannotShowList()
	self.fields.List:setNumItems(#self.itemList)
end
return mailGivePersentHelpPanel
