local baseProxy = require("fgui.base.baseProxy")
local intetiorTrickProxy = class("intetiorTrickProxy", baseProxy)
function intetiorTrickProxy:onRegisterEvent()
	print("=======intetiorTrickProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_STEAL_RSP", handler(self, self.rspStealOP))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_CHARGE_RSP", handler(self, self.rspChargeOP))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_TRICK_DATA_RSP", handler(self, self.rspTrickData))
end
function intetiorTrickProxy:rspTrickData(target, data)
end
function intetiorTrickProxy:rspStealOP(target, data)
	SoraDCloseLoading(self.view)
	if data.err == gErrDef.Err_None then
		local info = data.info
		local result = info.result
		if result == 1 or result == 2 then
			_ENV = nil
			;(nil).num = info.stealNum
			SoraDShowMsgTip(i18n("parliament_text_29", nil))
		elseif result == 3 then
			SoraDShowMsgTip(i18n("parliament_text_30"))
		elseif result == 4 then
			SoraDShowMsgTip(i18n("parliament_text_31"))
		end
	elseif data.err == gErrDef.Err_PARLIAMENT_TREASURY_RESOURCE_NOT_REACH then
		SoraDShowMsgTip(i18n("parliament_text_28"))
	end
end
function intetiorTrickProxy:rspChargeOP(target, data)
	SoraDCloseLoading(self.view)
	if data.err == gErrDef.Err_None and data.info then
		local info = data.info
		if info.isEffect then
			local trickId = info.trickId
			if trickId == include("intetiorDef").gParliamentTrick.RECALL_OFFICIAL then
				SoraDShowMsgTip(i18n("parliament_text_33"))
			elseif trickId == include("intetiorDef").gParliamentTrick.MONITOR_EMBEZZLE then
				SoraDShowMsgTip(i18n("parliament_text_34"))
			end
		end
	end
end
return intetiorTrickProxy
