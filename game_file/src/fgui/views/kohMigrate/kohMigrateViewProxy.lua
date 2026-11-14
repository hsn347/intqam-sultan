local baseProxy = require("fgui.base.baseProxy")
local kohMigrateViewProxy = class("kohMigrateViewProxy", baseProxy)
function kohMigrateViewProxy:onRegisterEvent()
	print("=======kohMigrateViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function()
		if not clientEventMgr.judgeIsOpen(self.view.activityID) then
			SoraDRemoveAllAfterPanelFromManager(self.view)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_KINGDOMLIST", handler(self, self.refreshKingdomList))
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_PLAYER_APPLYLIST", handler(self, self.refreshApplyList))
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_REDPOINT", handler(self, self.refreshRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED", function()
		self.view:refreshPrivilegeBtn()
	end)
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_ENTER_CHATROOM", handler(self, self.onMsgEnterChatRoom))
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_KINGDOMDATA", handler(self, self.onMsgUpdateKingdomData))
end
function kohMigrateViewProxy:refreshKingdomList(...)
	self.view:refreshKingdomList(...)
end
function kohMigrateViewProxy:refreshApplyList(...)
	self.view:refreshApplyList(...)
end
function kohMigrateViewProxy:refreshRedPoint(...)
	self.view:refreshRedPoint(...)
end
function kohMigrateViewProxy:refreshPrivilegeBtn(...)
	self.view:refreshPrivilegeBtn(...)
end
function kohMigrateViewProxy:onMsgEnterChatRoom(...)
	self.view:onMsgEnterChatRoom(...)
end
function kohMigrateViewProxy:onMsgUpdateKingdomData(...)
	self.view:onMsgUpdateKingdomData(...)
end
return kohMigrateViewProxy
