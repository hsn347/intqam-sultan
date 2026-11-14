local baseProxy = require("fgui.base.baseProxy")
local DjValueRankViewProxy = class("DjValueRankViewProxy", baseProxy)
function DjValueRankViewProxy:onRegisterEvent()
	print("=======DjValueRankViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_RANK_UPDATE", handler(self, self.initView))
end
function DjValueRankViewProxy:initView(target, data)
	self.view:initView(target, data)
end
return DjValueRankViewProxy
