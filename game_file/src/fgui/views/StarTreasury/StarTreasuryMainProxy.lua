local baseProxy = require("fgui.base.baseProxy")
local StarTreasuryMainProxy = class("StarTreasuryMainProxy", baseProxy)
function StarTreasuryMainProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_UPDATE_STAR_TREASURY", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function StarTreasuryMainProxy:onUpdateView(target, data)
	self.view:updateView()
	if data.subMsg == "reward" and data.reward ~= nil and next(data.reward) then
		_ENV = nil
		;(nil).reward = data.reward
		;(nil).rid = data.rid
		uiManager:show("StarTreasuryAward", nil):setOwnerKey(self.view)
	end
end
function StarTreasuryMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.STAR_TREASURY_ACTIVITY) then
		self.view:close()
	end
end
return StarTreasuryMainProxy
