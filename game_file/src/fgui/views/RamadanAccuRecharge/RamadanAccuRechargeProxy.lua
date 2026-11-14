local baseProxy = require("fgui.base.baseProxy")
local RamadanAccuRechargeProxy = class("RamadanAccuRechargeProxy", baseProxy)
function RamadanAccuRechargeProxy:onRegisterEvent()
	print("=======RamadanAccuRechargeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RAMADAN_ACCU_RECHARGE", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function RamadanAccuRechargeProxy:refreshView(target, data)
	if self.view then
		dump(data, "RamadanAccuRechargeProxy:refreshV")
		self.view:refreshView(data)
	end
end
function RamadanAccuRechargeProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RAMADAN_ACCUMULATE_RECHARGE) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return RamadanAccuRechargeProxy
