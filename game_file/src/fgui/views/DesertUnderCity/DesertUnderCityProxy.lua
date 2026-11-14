local baseProxy = require("fgui.base.baseProxy")
local DesertUnderCityProxy = class("DesertUnderCityProxy", baseProxy)
function DesertUnderCityProxy:onRegisterEvent()
	print("=======DesertUnderCityProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_DESERT_UNDER_CITY_BACK", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateItem))
end
function DesertUnderCityProxy:judgeClose(target, redata)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function DesertUnderCityProxy:refreshView(target, data)
	SoraDCloseLoading()
	if data.subMsg == "next" then
		self.view:showNextEffect()
	elseif data.isBigPrize then
		_ENV = nil
		;(nil).id = data.reward.id
		uiManager:show("DesertUnderCityPop", nil)
	end
	self.view:updateFloor()
	self.view:updateStatus()
	if data.index then
		self.view:showOpenEffect(data.index)
	else
		self.view:updateAwardNode()
	end
end
function DesertUnderCityProxy:updateItem()
	self.view:updateItemNum()
end
return DesertUnderCityProxy
