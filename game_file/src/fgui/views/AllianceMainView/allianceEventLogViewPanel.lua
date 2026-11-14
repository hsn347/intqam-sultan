local allianceLog = SoraDGetCtrl("allianceLog")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceEventLogViewPanel = class("allianceEventLogViewPanel", baseFguiPanel)
function allianceEventLogViewPanel:ctor(...)
	allianceEventLogViewPanel.super.ctor(self, ...)
	print("allianceEventLogViewPanel:ctor", self.viewName)
end
function allianceEventLogViewPanel:onInit()
	print("=======allianceEventLogViewPanel:onInit")
	self.logListData, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("common_text_4792"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onLogRenderer))
end
function allianceEventLogViewPanel:onShow()
	print("=======allianceEventLogViewPanel:onShow")
	allianceLog:reqAllianceLogData()
	SoraDShowLoading(self)
end
function allianceEventLogViewPanel:onLogRenderer(index, obj)
	obj:initData(self.logListData[index + 1])
end
function allianceEventLogViewPanel:updateLogData(target, data)
	SoraDCloseLoading(self)
	self.logListData = allianceLog:getLogList()
	self.fields.List:setNumItems(#self.logListData)
end
return allianceEventLogViewPanel
