local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorGloryRankProxy = class("NebulaEmperorGloryRankProxy", baseProxy)
function NebulaEmperorGloryRankProxy:onRegisterEvent()
	print("=======NebulaEmperorGloryRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_GET_RANK", handler(self, self.onMsgGetPlayerRank))
end
function NebulaEmperorGloryRankProxy:onMsgGetPlayerRank(target, event)
	SoraDCloseLoading(self.view:displayObject())
	self.view:refreshRankData(event.rspdata)
end
return NebulaEmperorGloryRankProxy
