local baseProxy = require("fgui.base.baseProxy")
local ArenaSelectViewProxy = class("ArenaSelectViewProxy", baseProxy)
function ArenaSelectViewProxy:onRegisterEvent()
	print("=======ArenaSelectViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_BATTLEGROUNDS", handler(self.view, self.view.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_GROUPCHANGE", handler(self.view, self.view.reReq4Info))
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_GLOBALCHANGE", handler(self.view, self.view.judgeGlobalChange))
end
return ArenaSelectViewProxy
