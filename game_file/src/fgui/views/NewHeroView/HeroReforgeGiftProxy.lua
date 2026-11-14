local baseProxy = require("fgui.base.baseProxy")
local HeroReforgeGiftProxy = class("HeroReforgeGiftProxy", baseProxy)
function HeroReforgeGiftProxy:onRegisterEvent()
	print("=======HeroReforgeGiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.initView))
end
function HeroReforgeGiftProxy:initView(target, data)
	dump(data, "HeroReforgeGiftProxy:initView======", 10)
	if data and data.data and data.data.rid and data.data.rid == self.view.rid then
		self.view:initView()
	end
end
return HeroReforgeGiftProxy
