local baseProxy = require("fgui.base.baseProxy")
local Activity_9001061_RankProxy = class("Activity_9001061_RankProxy", baseProxy)
function Activity_9001061_RankProxy:onRegisterEvent()
	print("=======Activity_9001061_RankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGSORDER_SECTIONRANK", handler(self, self.setStageData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGSORDER_TOTALRANK", handler(self, self.setTotalData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGSORDER_STAGERANK", handler(self, self.setCurStageData))
end
function Activity_9001061_RankProxy:setStageData(target, data)
	SoraDCloseLoading(self.view)
	self.view:onStageView()
end
function Activity_9001061_RankProxy:setTotalData(target, data)
	SoraDCloseLoading(self.view)
	self.view:onHistoryView()
end
function Activity_9001061_RankProxy:setCurStageData(target, data)
	SoraDCloseLoading(self.view)
	self.view:onCurStageView()
end
return Activity_9001061_RankProxy
