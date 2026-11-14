local baseProxy = require("fgui.base.baseProxy")
local kohMigrateRankProxy = class("kohMigrateRankProxy", baseProxy)
function kohMigrateRankProxy:onRegisterEvent()
	print("=======kohMigrateRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_PLAYER_RANK", handler(self, self.onMsgUpdatePlayerRank))
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_GROUPLIST", handler(self, self.onMsgUpdateGroupList))
end
function kohMigrateRankProxy:onMsgUpdatePlayerRank(...)
	self.view:onMsgUpdatePlayerRank(...)
end
function kohMigrateRankProxy:onMsgUpdateGroupList(...)
	self.view:onMsgUpdateGroupList(...)
end
return kohMigrateRankProxy
