local baseProxy = require("fgui.base.baseProxy")
local MagicLampActivityProxy = class("MagicLampActivityProxy", baseProxy)
function MagicLampActivityProxy:onRegisterEvent()
	print("=======MagicLampActivityProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001498_UPDATE", handler(self, self.msgRefreshView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.msgRefreshItemNum))
end
function MagicLampActivityProxy:msgRefreshView(target, data)
	SoraDCloseLoading(self.view)
	if data.subMsg == "init" then
		self.view:updateView()
	elseif data.subMsg == "one" then
		self.view:updateStageButton()
		self.view:updateButton()
		self.view:playFlipAnimation(data.reward)
	elseif data.subMsg == "ten" then
		self.view:updateView()
	else
		self.view:updateStageButton()
	end
end
function MagicLampActivityProxy:msgRefreshItemNum(target, data)
	self.view:updateButton()
end
function MagicLampActivityProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return MagicLampActivityProxy
