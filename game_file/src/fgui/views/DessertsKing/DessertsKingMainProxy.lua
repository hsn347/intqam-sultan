local baseProxy = require("fgui.base.baseProxy")
local DessertsKingMainProxy = class("DessertsKingMainProxy", baseProxy)
function DessertsKingMainProxy:onRegisterEvent()
	print("=======DessertsKingMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001538_UPDATE", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.msgUpdateButton))
end
function DessertsKingMainProxy:msgCallBack(target, data)
	SoraDCloseLoading(self.view)
	if data.mulTable then
		self.view:runEffect(data)
		return
	elseif data.rankList then
		self.view:updateRankAward()
	end
	self.view:updateProgressBox()
end
function DessertsKingMainProxy:msgUpdateButton()
	self.view:updateButton()
end
function DessertsKingMainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return DessertsKingMainProxy
