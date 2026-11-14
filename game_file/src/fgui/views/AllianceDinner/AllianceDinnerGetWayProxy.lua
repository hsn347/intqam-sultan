local baseProxy = require("fgui.base.baseProxy")
local AllianceDinnerGetWayProxy = class("AllianceDinnerGetWayProxy", baseProxy)
function AllianceDinnerGetWayProxy:onRegisterEvent()
	print("=======AllianceDinnerGetWayProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.onItemChange))
end
function AllianceDinnerGetWayProxy:onItemChange()
	self.view:updateItemNum()
end
return AllianceDinnerGetWayProxy
