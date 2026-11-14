local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_CampManageProxy = class("RoaringFlame_CampManageProxy", baseProxy)
function RoaringFlame_CampManageProxy:onRegisterEvent()
	print("=======RoaringFlame_CampManageProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_CAMP_MANAGE_DATA", handler(self, self.onMsgUpdateCampManageData))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_TECHNOLOGY", handler(self, self.updateRed))
end
function RoaringFlame_CampManageProxy:onMsgUpdateCampManageData(...)
	self.view:onMsgUpdateCampManageData(...)
end
function RoaringFlame_CampManageProxy:updateRed(...)
	self.view:updateRed(...)
end
return RoaringFlame_CampManageProxy
