local baseProxy = require("fgui.base.baseProxy")
local IceDragonCaveProxy = class("IceDragonCaveProxy", baseProxy)
function IceDragonCaveProxy:onRegisterEvent()
	print("=======IceDragonCaveProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_ICE_DRAGON_UPDATE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function IceDragonCaveProxy:onUpdateView(target, data)
	self.view:updateView()
	if data.reward then
		self.view:showReward(data.reward)
	end
end
function IceDragonCaveProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ICE_DRAGON_CAVE_ACTIVITY) then
		self.view:close()
	end
end
return IceDragonCaveProxy
