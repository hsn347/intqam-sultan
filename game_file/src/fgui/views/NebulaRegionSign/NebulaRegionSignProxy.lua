local baseProxy = require("fgui.base.baseProxy")
local NebulaRegionSignProxy = class("NebulaRegionSignProxy", baseProxy)
function NebulaRegionSignProxy:onRegisterEvent()
	print("=======NebulaRegionSignProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_SIGN_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function NebulaRegionSignProxy:initData(target, data)
	if self.view then
		self.view:initData()
	end
end
function NebulaRegionSignProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_REGION_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return NebulaRegionSignProxy
