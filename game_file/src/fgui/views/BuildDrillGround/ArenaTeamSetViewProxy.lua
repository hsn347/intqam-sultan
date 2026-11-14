local baseProxy = require("fgui.base.baseProxy")
local ArenaTeamSetViewProxy = class("ArenaTeamSetViewProxy", baseProxy)
function ArenaTeamSetViewProxy:onRegisterEvent()
	print("=======ArenaTeamSetViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_SETARMYLIST", handler(self.view, self.view.setSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_CLOSELOADING", function(args)
		SoraDCloseLoading(self.view:displayObject())
	end)
	SoraDAddMessage(self, "MESSAGE_ARMY_TEAMORGANIZE_BACKDATA", handler(self.view, self.view.adaptTeam))
	SoraDAddMessage(self, "MESSAGE_ARMY_SELECT_TYPE", handler(self.view, self.view.selectArmyType))
end
return ArenaTeamSetViewProxy
