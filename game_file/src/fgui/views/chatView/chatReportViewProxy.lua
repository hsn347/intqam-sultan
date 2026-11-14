local baseProxy = require("fgui.base.baseProxy")
local chatReportViewProxy = class("chatReportViewProxy", baseProxy)
function chatReportViewProxy:onRegisterEvent()
	print("=======chatReportViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHAT_REPORT_SELECT", handler(self, self.reportSelect))
end
function chatReportViewProxy:reportSelect(target, data)
	self.view:reportSelect(target, data)
end
return chatReportViewProxy
