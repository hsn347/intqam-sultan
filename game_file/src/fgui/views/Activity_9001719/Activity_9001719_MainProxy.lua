local baseProxy = require("fgui.base.baseProxy")
local Activity_9001719_MainProxy = class("Activity_9001719_MainProxy", baseProxy)
function Activity_9001719_MainProxy:onRegisterEvent()
	print("=======Activity_9001719_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001719_UPDATE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.itemChange))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001719_NEWGAME", handler(self, self.newGame))
end
function Activity_9001719_MainProxy:initView(target, data)
	self.view:initView(target, data)
end
function Activity_9001719_MainProxy:itemChange(target, data)
	if not data.itemMap then
		local _UPVALUE0_, itemMap = data.itemMap, data.itemMap
	end
	if itemMap[self.view.costID] then
		self.view:initView(target, data)
	end
end
function Activity_9001719_MainProxy:newGame(target, data)
	self.view:newGame(target, data)
end
return Activity_9001719_MainProxy
