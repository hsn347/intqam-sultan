local lightGuardianMainView = class("lightGuardianMainView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("lightGuardianMainView")
end)
function lightGuardianMainView:ctor(properties)
	self.activityID = gActivityTimeActivityID.RADIANCE_GUARDIAN_ACTIVITY
	self.nodeLightGuardianMainNode = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_lightGuardianMainNode")
	self.nodeLightGuardianRankNode = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_lightGuardianRankNode")
	self.nodeTimer = SoraDGetChildByName(self, "Node_Timer")
	self.textActivityTime = SoraDGetChildByName(self.nodeTimer, "Text_ActivityTime")
	self.textActivityTime = SoraDCreateTimerLabel(self, self.textActivityTime)
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeCommonFramTitle:setTitle(i18n("activity_name_9001262"))
	_ENV, self.nodeCommonTabBtn = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn"), SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").tabNum = 2
	_ENV, _ENV, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").defaultClick = "Top_CCS_commonTabBtn", self, 1
	;("Top_CCS_commonTabBtn").title = i18n("guardLight_text_01")
	;("Top_CCS_commonTabBtn").handle = handler(self, self.btnTabClick)
	;("Top_CCS_commonTabBtn").tag = 1
	_ENV, self[1], ("Top_CCS_commonTabBtn").fontSize = "Top_CCS_commonTabBtn", "Top_CCS_commonTabBtn", 22
	;("Top_CCS_commonTabBtn").title = i18n("common_text_851")
	;("Top_CCS_commonTabBtn").handle = handler(self, self.btnTabClick)
	;("Top_CCS_commonTabBtn").tag = 2
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").tabsetArray, self[2], ("Top_CCS_commonTabBtn").fontSize = self, "Top_CCS_commonTabBtn", 22
	local param = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	self.nodeCommonTabBtn:initView(param)
	self:initActivityTime()
end
function lightGuardianMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
end
function lightGuardianMainView:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.textActivityTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	if self.eventTime then
		self.textActivityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	SoraDToCenter(self.nodeTimer, 10, not SoraDFIsRA())
end
function lightGuardianMainView:btnTabClick(tag, name)
	self.nodeLightGuardianMainNode:setVisible(tag == 1)
	self.nodeLightGuardianRankNode:setVisible(tag == 2)
end
function lightGuardianMainView:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return lightGuardianMainView
