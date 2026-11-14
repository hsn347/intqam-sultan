local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorRankProxy = class("NebulaEmperorRankProxy", baseProxy)
function NebulaEmperorRankProxy:onRegisterEvent()
	print("=======NebulaEmperorRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_GET_RANK", handler(self, self.onMsgGetPlayerRank))
end
function NebulaEmperorRankProxy:onMsgGetPlayerRank(target, event)
	if event.rankType ~= self.view.rankType then
		return
	end
	SoraDCloseLoading(self.view:displayObject())
	self.view:refreshRankData(event.rspdata)
end
return NebulaEmperorRankProxy
