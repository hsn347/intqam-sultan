local baseProxy = require("fgui.base.baseProxy")
local AllianceScienceProxy = class("AllianceScienceProxy", baseProxy)
function AllianceScienceProxy:onRegisterEvent()
	print("=======AllianceScienceProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE_BYTYPE", handler(self, self.greenPointUpdateByType))
end
function AllianceScienceProxy:greenPointUpdateByType(target, data)
	if ALLIANCE_MAIN_MENU_TYPE.SCIENCE == data.type then
		self.view:greenPointUpdate()
	end
end
return AllianceScienceProxy
