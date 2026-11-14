local baseProxy = require("fgui.base.baseProxy")
local jerseyScoreProxy = class("jerseyScoreProxy", baseProxy)
function jerseyScoreProxy:onRegisterEvent()
	print("=======jerseyScoreProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_FOOTBALL_CLOTHES_REFRESH", handler(self, self.msgUpdateView))
end
function jerseyScoreProxy:msgUpdateView(target, data)
	if data.subMsg == "detail" then
		self.view:updateView()
	end
end
return jerseyScoreProxy
