local baseProxy = require("fgui.base.baseProxy")
local NebulaOfflcerProxy = class("NebulaOfflcerProxy", baseProxy)
function NebulaOfflcerProxy:onRegisterEvent()
	print("=======NebulaOfflcerProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_PRIVILEGE_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function NebulaOfflcerProxy:updateView()
	local nebulaPrivilegeCtrl = SoraDGetCtrl("nebulaPrivilegeCtrl")
	local nebulaWarUtil = include("nebulaWarUtil")
	local round = nebulaPrivilegeCtrl:getRound()
	if 4 <= round and nebulaWarUtil.checkSelfCampType1() then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	else
		self.view:updateView()
	end
end
function NebulaOfflcerProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_PRIVILEGE) and self.view then
		self.view:close()
	end
end
return NebulaOfflcerProxy
