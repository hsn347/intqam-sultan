local baseProxy = require("fgui.base.baseProxy")
local ArenaPriceViewProxy = class("ArenaPriceViewProxy", baseProxy)
function ArenaPriceViewProxy:onRegisterEvent()
	print("=======ArenaPriceViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_REWARDTIME", handler(self.view, self.view.refreshTime))
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_GAINREWARD", handler(self.view, self.view.gainCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_CLOSELOADING", function(args)
		SoraDCloseLoading(self.view:displayObject())
	end)
end
return ArenaPriceViewProxy
