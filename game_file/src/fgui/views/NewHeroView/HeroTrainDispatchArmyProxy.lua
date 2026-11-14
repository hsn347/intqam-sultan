local baseProxy = require("fgui.base.baseProxy")
local HeroTrainDispatchArmyProxy = class("HeroTrainDispatchArmyProxy", baseProxy)
function HeroTrainDispatchArmyProxy:onRegisterEvent()
	print("=======HeroTrainDispatchArmyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRAIN_TRAINSUCCESS", function(...)
		self.view:removeFromParent()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRAIN_TRAINFAIL", function(...)
		SoraDCloseLoading(self.view)
	end)
end
return HeroTrainDispatchArmyProxy
