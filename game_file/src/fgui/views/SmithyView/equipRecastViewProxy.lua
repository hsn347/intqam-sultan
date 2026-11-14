local baseProxy = require("fgui.base.baseProxy")
local equipRecastViewProxy = class("equipRecastViewProxy", baseProxy)
function equipRecastViewProxy:onRegisterEvent()
	print("=======equipRecastViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MALL_BUY_SUCCESS", handler(self, self.setItemCount))
end
function equipRecastViewProxy:setItemCount()
	self.view:setItemCount()
end
return equipRecastViewProxy
