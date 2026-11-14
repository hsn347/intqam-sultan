local baseProxy = require("fgui.base.baseProxy")
local AllianceWarViewProxy = class("AllianceWarViewProxy", baseProxy)
function AllianceWarViewProxy:onRegisterEvent()
end
function AllianceWarViewProxy:myRegistEvent()
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", function(...)
		self.view:close()
	end)
end
return AllianceWarViewProxy
