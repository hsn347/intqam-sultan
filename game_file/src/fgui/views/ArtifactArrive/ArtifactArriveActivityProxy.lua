local baseProxy = require("fgui.base.baseProxy")
local ArtifactArriveActivityProxy = class("artifactArriveActivityProxy", baseProxy)
function ArtifactArriveActivityProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onItemCountChange))
	SoraDAddMessage(self, "MESSAGE_ARTIFACT_ARRIVE_REFRESH", handler(self, self.onReqInitBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function ArtifactArriveActivityProxy:onItemCountChange()
	self.view:updateNumNode()
end
function ArtifactArriveActivityProxy:onReqInitBack()
	SoraDCloseLoading()
	self.view:updateBtnStatus()
end
function ArtifactArriveActivityProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ARTIFACT_ARRIVE_ACTIVITY) then
		self.view:close()
	end
end
return ArtifactArriveActivityProxy
