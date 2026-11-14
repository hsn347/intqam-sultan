local baseProxy = require("fgui.base.baseProxy")
local DessertThiefMainProxy = class("DessertThiefMainProxy", baseProxy)
function DessertThiefMainProxy:onRegisterEvent()
	print("=======DessertThiefMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_DESSERT_THIEF_UPDATE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_SETTING", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function DessertThiefMainProxy:onUpdateView()
	self.view:updateView()
end
function DessertThiefMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SWEET_MEAT_ROBBER_ACTIVITY) then
		self.view:close()
	end
end
return DessertThiefMainProxy
