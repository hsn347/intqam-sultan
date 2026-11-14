local baseProxy = require("fgui.base.baseProxy")
local StarLampCeremonyRankProxy = class("StarLampCeremonyRankProxy", baseProxy)
function StarLampCeremonyRankProxy:onRegisterEvent()
	print("=======StarLampCeremonyRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_STAR_LAMP_CEREMONY_RANK", handler(self, self.onMsgUpdateRank))
end
function StarLampCeremonyRankProxy:onMsgUpdateRank(target, event)
	self.view:onMsgUpdateRank(target, event)
end
return StarLampCeremonyRankProxy
