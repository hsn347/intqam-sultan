local baseProxy = require("fgui.base.baseProxy")
local StarryNightCarnivalProxy = class("StarryNightCarnivalProxy", baseProxy)
function StarryNightCarnivalProxy:onRegisterEvent()
	print("=======StarryNightCarnivalProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_STARRY_NIGHT_CARNIVAL_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshItem))
end
function StarryNightCarnivalProxy:initData(target, data)
	if self.view then
		self.view:refreshView(data)
	end
end
function StarryNightCarnivalProxy:refreshItem()
	if self.view then
		self.view:refreshItem(data)
	end
end
function StarryNightCarnivalProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.STARRY_NIGHT_CARNIVAL) then
		self.view:close()
	end
end
return StarryNightCarnivalProxy
