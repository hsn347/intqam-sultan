local baseProxy = require("fgui.base.baseProxy")
local CoffeeCraftsmanSpoonProxy = class("CoffeeCraftsmanSpoonProxy", baseProxy)
function CoffeeCraftsmanSpoonProxy:onRegisterEvent()
	print("=======CoffeeCraftsmanSpoonProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWREFRESH", handler(self, self.initData))
end
function CoffeeCraftsmanSpoonProxy:initData()
	if self.view then
		self.view:updateView()
	end
end
function CoffeeCraftsmanSpoonProxy:onRemoveView()
	print("=======CoffeeCraftsmanSpoonProxy:onRemoveView")
end
return CoffeeCraftsmanSpoonProxy
