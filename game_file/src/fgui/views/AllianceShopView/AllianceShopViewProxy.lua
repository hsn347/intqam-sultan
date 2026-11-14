local baseProxy = require("fgui.base.baseProxy")
local AllianceShopViewProxy = class("AllianceShopViewProxy", baseProxy)
function AllianceShopViewProxy:onRegisterEvent()
	print("=======AllianceShopViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_STORE_LIST_SUCCESS", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SCIENCE_POINT_UPDATE", handler(self, self.msgCallBack))
end
function AllianceShopViewProxy:msgCallBack(target, data)
	self.view:updateScrollWithData()
end
return AllianceShopViewProxy
