local baseProxy = require("fgui.base.baseProxy")
local lordInfoViewProxy = class("lordInfoViewProxy", baseProxy)
function lordInfoViewProxy:onRegisterEvent()
	print("=======lordInfoViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.updateLordInfo))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_FCINFO", handler(self, self.updateLordInfo))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_HONOUR_ACHIEVEMENT", handler(self, self.updateLordInfo))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_TITLE_SHOW", handler(self, self.updateLordInfo))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_DISMISS_TITLE_BACK", handler(self, self.sMsgDismissTitleBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_LORD_NOTIFY_CL_LT", handler(self, self.updateLordInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEGEMON_LORD_NOTIFY_CL_LT", handler(self, self.updateLordInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEGEMON_LORD_NOTIFY_AP_LT", handler(self, self.updateLordInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_LORD_NOTIFY_AP_LT", handler(self, self.updateLordInfo))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_PRIVILEGE_REFRESH_TITLE", handler(self, self.updateLordInfo))
	SoraDAddMessage(self, "MESSAGE_NEBULA_PRIVILEGE_REFRESH_TITLE", handler(self, self.updateLordInfo))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_HONOUR_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function lordInfoViewProxy:updateLordInfo(target, data)
	self.view:updateLordInfo(target, data)
end
function lordInfoViewProxy:sMsgDismissTitleBack(target, data)
	self.view:sMsgDismissTitleBack(target, data)
end
function lordInfoViewProxy:serverMessageGetLordInfo(target, data)
	self.view:serverMessageGetLordInfo(target, data)
end
return lordInfoViewProxy
