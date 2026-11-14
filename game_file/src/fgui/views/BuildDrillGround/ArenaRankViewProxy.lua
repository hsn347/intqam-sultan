local baseProxy = require("fgui.base.baseProxy")
local ArenaRankViewProxy = class("ArenaRankViewProxy", baseProxy)
function ArenaRankViewProxy:onRegisterEvent()
	print("=======ArenaRankViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_GROUPRANK", handler(self.view, self.view.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_SEEARMYINFO", handler(self.view, self.view.reqBackInfo))
end
return ArenaRankViewProxy
