local baseProxy = require("fgui.base.baseProxy")
local WarGemQuickSetProxy = class("WarGemQuickSetProxy", baseProxy)
function WarGemQuickSetProxy:onRegisterEvent()
	print("=======WarGemQuickSetProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_DATA", handler(self, self.onGemData))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_RESET", handler(self, self.onGemData))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_COPY", handler(self, self.onGemData))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_RESET_FAIL", handler(self, self.onResetFail))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_COPY_FAIL", handler(self, self.onCopyFail))
end
function WarGemQuickSetProxy:onGemData()
	SoraDCloseLoading(self.view:displayObject())
	self:removeView(self.view)
end
function WarGemQuickSetProxy:onResetFail()
	SoraDCloseLoading(self.view:displayObject())
end
function WarGemQuickSetProxy:onCopyFail()
	SoraDShowMsgTip(i18n("privilege_text_85"))
	SoraDCloseLoading(self.view:displayObject())
	self:removeView(self.view)
end
return WarGemQuickSetProxy
