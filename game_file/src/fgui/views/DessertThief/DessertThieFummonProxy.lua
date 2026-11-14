local baseProxy = require("fgui.base.baseProxy")
local DessertThieFummonProxy = class("DessertThieFummonProxy", baseProxy)
function DessertThieFummonProxy:onRegisterEvent()
	print("=======DessertThieFummonProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_DESSERT_THIEF_UPDATE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function DessertThieFummonProxy:onUpdateView()
	self.view:updateView()
end
function DessertThieFummonProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SWEET_MEAT_ROBBER_ACTIVITY) then
		self.view:close()
	end
end
return DessertThieFummonProxy
