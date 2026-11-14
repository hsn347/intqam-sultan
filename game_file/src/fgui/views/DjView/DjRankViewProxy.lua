local baseProxy = require("fgui.base.baseProxy")
local DjRankViewProxy = class("DjRankViewProxy", baseProxy)
function DjRankViewProxy:onRegisterEvent()
	print("=======DjRankViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_RANK_UPDATE", handler(self, self.updateView))
end
function DjRankViewProxy:updateView(target, data)
	self.view:updateView(data)
end
return DjRankViewProxy
