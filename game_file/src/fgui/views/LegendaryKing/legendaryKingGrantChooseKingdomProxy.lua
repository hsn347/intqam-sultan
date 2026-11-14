local baseProxy = require("fgui.base.baseProxy")
local legendaryKingGrantChooseKingdomProxy = class("legendaryKingGrantChooseKingdomProxy", baseProxy)
function legendaryKingGrantChooseKingdomProxy:onRegisterEvent()
	print("=======legendaryKingGrantChooseKingdomProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_KINGDOMLIST_BACK", handler(self, self.reqKingdomListBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_LORD_APPOINT_KT_BACK", handler(self, self.successBakck))
end
function legendaryKingGrantChooseKingdomProxy:reqKingdomListBack(target, data)
	SoraDCloseLoading()
	dump(data, "data")
	if data and data.list then
		self.view:initKingdomList(data.list)
	end
end
function legendaryKingGrantChooseKingdomProxy:successBakck()
	self:removeView(self.view)
end
return legendaryKingGrantChooseKingdomProxy
