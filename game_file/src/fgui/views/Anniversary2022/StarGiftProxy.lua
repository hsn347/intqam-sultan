local baseProxy = require("fgui.base.baseProxy")
local StarGiftProxy = class("StarGiftProxy", baseProxy)
function StarGiftProxy:onRegisterEvent()
	print("=======StarGiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SATR_GIFT_REFRESH", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.initData))
end
function StarGiftProxy:refreshView(target, data)
	dump(data, "jfkdjfkdjfk")
	if self.view then
		if data.subMsg == "init" then
			self.view:initData()
		elseif data.subMsg == "buySuccess" then
			self.view:popReward(data)
			self.view:initData()
		end
	end
end
function StarGiftProxy:initData()
	if self.view then
		self.view:refreshPageInZero()
	end
end
function StarGiftProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.STARS_GIFT_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return StarGiftProxy
