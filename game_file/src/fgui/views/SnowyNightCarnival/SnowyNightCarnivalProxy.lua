local baseProxy = require("fgui.base.baseProxy")
local SnowyNightCarnivalProxy = class("SnowyNightCarnivalProxy", baseProxy)
function SnowyNightCarnivalProxy:onRegisterEvent()
	print("=======SnowyNightCarnivalProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SNOW_NIGHT_CARNIVAL_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.updateFurtherBtn))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshItem))
end
function SnowyNightCarnivalProxy:initData(target, data)
	if self.view then
		self.view:refreshView(data)
	end
end
function SnowyNightCarnivalProxy:updateFurtherBtn()
	if self.view then
		self.view:updateFurtherBtn()
	end
end
function SnowyNightCarnivalProxy:refreshItem()
	if self.view then
		self.view:refreshItem(data)
	end
end
function SnowyNightCarnivalProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SNOWY_NIGHT_CARNIVAL_ACTIVITY) then
		self.view:close()
	else
		self:initData()
	end
end
return SnowyNightCarnivalProxy
