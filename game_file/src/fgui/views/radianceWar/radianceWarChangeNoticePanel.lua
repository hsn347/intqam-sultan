local baseFguiPanel = require("fgui.base.baseFguiPanel")
local radianceWarChangeNoticePanel = class("radianceWarChangeNoticePanel", baseFguiPanel)
function radianceWarChangeNoticePanel:ctor(...)
	self.isLRU = true
	radianceWarChangeNoticePanel.super.ctor(self, ...)
	print("radianceWarChangeNoticePanel:ctor", self.viewName)
end
function radianceWarChangeNoticePanel:onInit()
	print("=======radianceWarChangeNoticePanel:onInit")
	self.fields.Panel_bg:setString(i18n("brightWar_text_238"))
end
function radianceWarChangeNoticePanel:endShow()
	print("=======radianceWarChangeNoticePanel:endShow")
	self.fields.Text_msg:setString(i18n("brightWar_text_239"))
end
return radianceWarChangeNoticePanel
