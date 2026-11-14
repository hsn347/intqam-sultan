local baseProxy = require("fgui.base.baseProxy")
local MythicalCreaturesViewProxy = class("MythicalCreaturesViewProxy", baseProxy)
function MythicalCreaturesViewProxy:onRegisterEvent()
	print("=======MythicalCreaturesViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_UPDATE_DIVINEBEAST", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.msgUpdateItem))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.msgUpdataFc))
	SoraDAddMessage(self, "MESSAGE_DIVINEBEAST_MARK_GUIDE", handler(self, self.onMarkGuide))
	SoraDAddMessage(self, "MESSAGE_UPDATE_DIVINEBEAST_MARK", handler(self, self.onMarkUpdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgActivityUpdata))
end
function MythicalCreaturesViewProxy:msgUpdateView(target, data)
	if data.isTreat then
		self.view:playTreatAnimation()
	end
	self.view:updateView()
end
function MythicalCreaturesViewProxy:msgUpdateItem()
	self.view:updateItem()
end
function MythicalCreaturesViewProxy:msgUpdataFc()
	self.view:updateFc()
end
function MythicalCreaturesViewProxy:onMarkGuide()
	self.view:showMarkGuideAni()
end
function MythicalCreaturesViewProxy:onMarkUpdate()
	self.view:updateMarkBtnRedDot()
end
function MythicalCreaturesViewProxy:msgActivityUpdata(target, data)
	if not data.activityID then
		local _ENV, activityID = data.activityID, data.activityID
	end
	if (type(activityID) == "number" and activityID == self.view.activityID or type(activityID) == "table" and table.indexof(activityID, self.view.activityID)) and not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view, true)
		self.view:updateView()
	end
end
return MythicalCreaturesViewProxy
