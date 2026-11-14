local baseProxy = require("fgui.base.baseProxy")
local HappyEggViewProxy = class("HappyEggViewProxy", baseProxy)
function HappyEggViewProxy:onRegisterEvent()
	print("=======HappyEggViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001544_UPDATE", handler(self, self.onMsgCallBack))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onMsgUpdateItem))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function HappyEggViewProxy:onMsgCallBack(target, data)
	SoraDCloseLoading(self.view)
	if data.subMsg == "init" then
		self.view:initEgg()
	elseif data.subMsg == "select" then
		self.view:initEgg()
	elseif data.subMsg == "lottery" then
		self.view:runAction(data.position, data.reward)
		self.view:updateItemNum()
	end
	self.view:updateButton()
	self.view:updatePoint()
	self.view:updateView()
end
function HappyEggViewProxy:onMsgUpdateItem()
	self.view:updateButton()
	self.view:updateItemNum()
end
function HappyEggViewProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return HappyEggViewProxy
