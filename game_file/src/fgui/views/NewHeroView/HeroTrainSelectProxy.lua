local baseProxy = require("fgui.base.baseProxy")
local HeroTrainSelectProxy = class("HeroTrainSelectProxy", baseProxy)
function HeroTrainSelectProxy:onRegisterEvent()
	print("=======HeroTrainSelectProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRAIN_TRAINSUCCESS", function(...)
		self.view:removeFromParent()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRAIN_TRAINFAIL", function(...)
		SoraDCloseLoading()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STARTUPGRADE", handler(self, self.heroStateChange))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_FEEDHEROSUCCESS", handler(self, self.heroStateChange))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_NOTICEHERO", handler(self, self.heroStateChange))
end
function HeroTrainSelectProxy:heroStateChange()
	self.view:heroStateChange()
end
return HeroTrainSelectProxy
