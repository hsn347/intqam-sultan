local baseProxy = require("fgui.base.baseProxy")
local intetiorDonateGoldProxy = class("intetiorDonateGoldProxy", baseProxy)
function intetiorDonateGoldProxy:onRegisterEvent()
	print("=======intetiorDonateGoldProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_DOATE_RSP", handler(self, self.rspDoate))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_POLICY_DONATE_RSP", handler(self, self.rspPolicyDoate))
end
function intetiorDonateGoldProxy:rspDoate(target, data)
	SoraDCloseLoading(self.view)
	if data.err ~= gErrDef.Err_None then
		self:errHandle(data.err)
	else
		SoraDShowMsgTip(i18n("donate_text_14"))
	end
end
function intetiorDonateGoldProxy:rspPolicyDoate(target, data)
	SoraDCloseLoading(self.view)
	if data.err ~= gErrDef.Err_None then
		self:errHandle(data.err)
	else
		SoraDShowMsgTip(i18n("donate_text_14"))
		self.view.fields.Label_KingGold:updateSkillInfo()
	end
end
function intetiorDonateGoldProxy:errHandle(err)
	if err == gErrDef.Err_None then
		return
	end
end
return intetiorDonateGoldProxy
