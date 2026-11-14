local baseProxy = require("fgui.base.baseProxy")
local ArenaRecordViewProxy = class("ArenaRecordViewProxy", baseProxy)
function ArenaRecordViewProxy:onRegisterEvent()
	print("=======ArenaRecordViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_RECORDLIST", handler(self.view, self.view.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_DETAILREPORT", handler(self.view, self.view.detailBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_CLOSELOADING", function(args)
		SoraDCloseLoading(self.view:displayObject())
	end)
end
return ArenaRecordViewProxy
