local baseProxy = require("fgui.base.baseProxy")
local HeroStoryProxy = class("HeroStoryProxy", baseProxy)
function HeroStoryProxy:onRegisterEvent()
	print("=======HeroStoryProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STORYTASK_UPDATE", handler(self, self.msgCallBack))
end
function HeroStoryProxy:msgCallBack(target, data)
	if data.subMsg == "turnNextPage" then
		self.view:turnNext()
	elseif data.subMsg == "turnPrevPage" then
		self.view:turnPre()
	end
end
return HeroStoryProxy
