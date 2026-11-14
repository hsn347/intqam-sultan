local baseProxy = require("fgui.base.baseProxy")
local jerseyActivityProxy = class("jerseyActivityProxy", baseProxy)
function jerseyActivityProxy:onRegisterEvent()
	print("=======jerseyActivityProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_FOOTBALL_CLOTHES_REFRESH", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.msgUpdateButton))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.msgUpdateItemCount))
end
function jerseyActivityProxy:msgUpdateView(target, data)
	SoraDCloseLoading(self.view:displayObject())
	if data.subMsg == "init" then
		self.view:updateScore()
		self.view:updateButton()
	end
end
function jerseyActivityProxy:msgUpdateButton()
	self.view:updateButton()
end
function jerseyActivityProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.FOOTBALL_CLOTHES_ACTIVITY) and self.view then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function jerseyActivityProxy:msgUpdateItemCount()
	self.view:updateItem()
end
return jerseyActivityProxy
