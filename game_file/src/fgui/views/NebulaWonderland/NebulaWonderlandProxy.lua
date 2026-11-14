local baseProxy = require("fgui.base.baseProxy")
local NebulaWonderlandProxy = class("NebulaWonderlandProxy", baseProxy)
function NebulaWonderlandProxy:onRegisterEvent()
	print("=======NebulaWonderlandProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_NEBULA_WONDERLAND_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_NEBULA_WONDERLAND_PAGE", handler(self, self.setPageChange))
	SoraDAddMessage(self, "MESSAGE_NEBULA_WONDERLAND_INCSCORE", handler(self, self.popIncScore))
	SoraDAddMessage(self, "MESSAGE_NEBULA_WONDERLAND_REWARD", handler(self, self.setGiftState))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function NebulaWonderlandProxy:initData()
	if self.view then
		self.view:initData()
	end
end
function NebulaWonderlandProxy:popIncScore(target, data)
	if self.view then
		self.view:popIncScore(data)
	end
end
function NebulaWonderlandProxy:setGiftState(target, data)
	if self.view then
		self.view:setGiftState(data)
	end
end
function NebulaWonderlandProxy:setPageChange(target, data)
	if self.view then
		self.view:setPageChange(data)
	end
end
function NebulaWonderlandProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_WONDERLAND_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return NebulaWonderlandProxy
