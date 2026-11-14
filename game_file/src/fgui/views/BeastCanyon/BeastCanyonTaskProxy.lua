local baseProxy = require("fgui.base.baseProxy")
local BeastCanyonTaskProxy = class("BeastCanyonTaskProxy", baseProxy)
function BeastCanyonTaskProxy:onRegisterEvent()
	print("=======BeastCanyonTaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001547_UPDATE", handler(self, self.msgCallBack))
end
function BeastCanyonTaskProxy:msgCallBack(target, data)
	if data.subMsg == "reward" or data.subMsg == "challenge" or data.subMsg == "sweep" then
		self.view:updatTaskScroll()
	elseif data.subMsg == "taskClose" then
		self.view:close()
	end
end
return BeastCanyonTaskProxy
