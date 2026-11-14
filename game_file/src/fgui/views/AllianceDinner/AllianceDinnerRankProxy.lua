local baseProxy = require("fgui.base.baseProxy")
local AllianceDinnerRankProxy = class("AllianceDinnerRankProxy", baseProxy)
function AllianceDinnerRankProxy:onRegisterEvent()
	print("=======AllianceDinnerRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_DINNER_RANK", handler(self, self.onMsgUpdateRank))
end
function AllianceDinnerRankProxy:onMsgUpdateRank(target, event)
	self.view:onMsgUpdateRank(target, event)
end
return AllianceDinnerRankProxy
