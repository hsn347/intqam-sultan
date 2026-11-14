local baseProxy = require("fgui.base.baseProxy")
local allianceMemberBattlePointViewProxy = class("allianceMemberBattlePointViewProxy", baseProxy)
function allianceMemberBattlePointViewProxy:onRegisterEvent()
	print("=======allianceMemberBattlePointViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_MEMBER_LIST_SUCCESS", handler(self, self.initData))
end
function allianceMemberBattlePointViewProxy:initData()
	self.view:initData()
end
return allianceMemberBattlePointViewProxy
