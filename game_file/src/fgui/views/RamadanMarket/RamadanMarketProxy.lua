local baseProxy = require("fgui.base.baseProxy")
local RamadanMarketProxy = class("RamadanMarketProxy", baseProxy)
function RamadanMarketProxy:onRegisterEvent()
	print("=======RamadanMarketProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_RAMADAN_MARKET", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.updateData))
end
function RamadanMarketProxy:refreshView(target, data)
	if self.view then
		dump(data, "RamadanMarketProxy:refreshV")
		self.view:refreshView(data)
	end
end
function RamadanMarketProxy:updateData(target, data)
	if self.view then
		dump(data, "RamadanMarketProxy:updateData")
		self.view:initData()
	end
end
function RamadanMarketProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RAMADAN_MARKET_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return RamadanMarketProxy
