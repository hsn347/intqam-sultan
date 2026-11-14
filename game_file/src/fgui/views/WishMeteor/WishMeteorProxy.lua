local baseProxy = require("fgui.base.baseProxy")
local WishMeteorProxy = class("WishMeteorProxy", baseProxy)
function WishMeteorProxy:onRegisterEvent()
	print("=======WishMeteorProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_WISHING_METEOR_BACK", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function WishMeteorProxy:refreshView(target, data)
	if data.subMsg == "initBack" then
		self.view:updateAwardNodes()
	elseif data.subMsg == "wishBack" then
		self.view:updateAwardNodes(true)
	elseif data.subMsg == "lotteryBack" then
		self.view:playAnimation(data.lv, data.idx, data.reward)
		self.view:updateItem()
	end
end
function WishMeteorProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.WISHING_METEOR) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return WishMeteorProxy
