local baseProxy = require("fgui.base.baseProxy")
local HeroTrainListProxy = class("HeroTrainListProxy", baseProxy)
function HeroTrainListProxy:onRegisterEvent()
	print("=======HeroTrainListProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRAIN_INIT", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRAIN_TRAINSUCCESS", handler(self, self.updatePosition))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRAIN_GAINSUCCESS", handler(self, self.updatePosition))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRAIN_STOPSUCCESS", handler(self, self.updatePosition))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRAIN_SPEEDSUCCESS", handler(self, self.updatePosition))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRAIN_NOTIFY", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRAIN_COMMONFAIL", function(target, redata)
		SoraDCloseLoading()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_FEEDHEROSUCCESS", handler(self, self.updatePosition))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_NOTICEHERO", handler(self, self.updatePosition))
end
function HeroTrainListProxy:initData()
	self.view:initData()
end
function HeroTrainListProxy:updatePosition(target, redata)
	self.view:initData(redata)
end
return HeroTrainListProxy
