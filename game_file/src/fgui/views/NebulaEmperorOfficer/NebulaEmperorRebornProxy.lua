local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorRebornProxy = class("NebulaEmperorRebornProxy", baseProxy)
function NebulaEmperorRebornProxy:onRegisterEvent()
	print("=======NebulaEmperorRebornProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_SUMMON_ARMY", handler(self, self.onMsgHeroicLandRefresh))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_SUMMON_ITEM", handler(self, self.onMsgUpdateItemCount))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function NebulaEmperorRebornProxy:onMsgHeroicLandRefresh(...)
	self.view:onMsgHeroicLandRefresh(...)
end
function NebulaEmperorRebornProxy:judgeClose(...)
	self.view:judgeClose()
end
function NebulaEmperorRebornProxy:onMsgUpdateItemCount(...)
	self.view:onMsgUpdateItemCount(...)
end
return NebulaEmperorRebornProxy
