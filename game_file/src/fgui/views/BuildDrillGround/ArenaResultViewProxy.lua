local baseProxy = require("fgui.base.baseProxy")
local ArenaResultViewProxy = class("ArenaResultViewProxy", baseProxy)
function ArenaResultViewProxy:onRegisterEvent()
	print("=======ArenaResultViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_RESULTBACK", handler(self.view, self.view.resultBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_FIGHTERR", handler(self.view, self.view.fightErr))
end
return ArenaResultViewProxy
