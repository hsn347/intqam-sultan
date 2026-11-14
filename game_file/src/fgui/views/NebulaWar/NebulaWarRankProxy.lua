local baseProxy = require("fgui.base.baseProxy")
local NebulaWarRankProxy = class("NebulaWarRankProxy", baseProxy)
function NebulaWarRankProxy:onRegisterEvent()
	print("=======NebulaWarRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_GET_PLAYER_RANK", handler(self, self.onMsgGetPlayerRank))
end
function NebulaWarRankProxy:onMsgGetPlayerRank(target, event)
	SoraDCloseLoading(self.view:displayObject())
	self.view:refreshRankData(event.rspdata)
end
return NebulaWarRankProxy
