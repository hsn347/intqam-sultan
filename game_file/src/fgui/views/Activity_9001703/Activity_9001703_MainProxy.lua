local baseProxy = require("fgui.base.baseProxy")
local Activity_9001703_MainProxy = class("Activity_9001703_MainProxy", baseProxy)
function Activity_9001703_MainProxy:onRegisterEvent()
	print("=======Activity_9001703_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001703_UPDATE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.itemChange))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001703_NEWGAME", handler(self, self.newGame))
end
function Activity_9001703_MainProxy:initView(target, data)
	self.view:initView(target, data)
end
function Activity_9001703_MainProxy:itemChange(target, data)
	if not data.itemMap then
		local _UPVALUE0_, itemMap = data.itemMap, data.itemMap
	end
	if itemMap[self.view.huntCost] then
		self.view:initView(target, data)
	end
end
function Activity_9001703_MainProxy:newGame(target, data)
	self.view:newGame(target, data)
end
return Activity_9001703_MainProxy
