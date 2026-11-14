local baseComponent = require("fgui.base.baseComponent")
local Com_reportSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://chatView/Com_reportSingle", Com_reportSingle)
function Com_reportSingle:onInit()
	self:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Com_reportSingle:onShow()
end
function Com_reportSingle:initData(data, index, curReportType)
	self.data = data
	self.fields.nbg:setVisible(index % 2 == 1)
	self.fields.title:setString(i18n(self.data.key))
	if curReportType and curReportType == self.data.reportType then
		self.fields.Check_tick:setSelected(true)
	else
		self.fields.Check_tick:setSelected(false)
	end
end
function Com_reportSingle:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REPORT_SELECT"
	;(nil).reportType = self.data.reportType
	SoraDSendMessage(nil)
end
return Com_reportSingle
