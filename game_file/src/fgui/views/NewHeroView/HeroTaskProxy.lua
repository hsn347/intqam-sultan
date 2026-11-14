local baseProxy = require("fgui.base.baseProxy")
local HeroTaskProxy = class("HeroTaskProxy", baseProxy)
function HeroTaskProxy:onRegisterEvent()
	print("=======HeroTaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STORYTASK_UPDATE", handler(self, self.msgCallBack))
end
function HeroTaskProxy:msgCallBack(target, data)
	if data.subMsg == "getReward" then
		self.view:updateList()
	end
end
return HeroTaskProxy
