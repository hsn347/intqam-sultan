local baseProxy = require("fgui.base.baseProxy")
local gameOptionsProxy = class("gameOptionsProxy", baseProxy)
function gameOptionsProxy:onRegisterEvent()
	print("=======gameOptionsProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_GAMEOPTION_LBS_REMOVELOCATION", handler(self, self.removeLbsBack))
end
function gameOptionsProxy:removeLbsBack(target, redata)
	SoraDCloseLoading(self.view)
	if redata.isSuccess then
		SoraDShowMsgTip(i18n("lbs_text_08"))
	end
end
return gameOptionsProxy
