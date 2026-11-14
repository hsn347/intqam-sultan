local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local expeditionCtrl = gametop.playertop_:getModule("expeditionCtrl")
local eventExpedtionRead = include("eventExpedtionRead")
local eventExpedtionView = class("eventExpedtionView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventExpedtionView")
	end
	return target
end)
function eventExpedtionView:ctor()
	self.warConfig = eventExpedtionRead.getWarConfig()
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_target")
	self.ccs_title:setTitle(i18n("activityname_9001133"))
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.onBtnHelpClick))
	self.Image_event = SoraDGetChildByName(self, "Image_event")
	self.Image_event:loadTexture("bg_activity_9001133.png", ccui.TextureResType.plistType)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("eventExpedtionSingle")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Node_time:setVisible(false)
	self.Text_time = SoraDGetChildByName(self.Node_time, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self:setTime()
	self:initData()
end
function eventExpedtionView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EXPEDITON_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function eventExpedtionView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXPEDITON) then
		self:removeFromParent()
	end
end
function eventExpedtionView:setTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.EXPEDITON)
	if eventTime then
		self.Text_time:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_607", nil)
		end)
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
		self.Node_time:setVisible(true)
		SoraDToCenter(self.Node_time)
	end
end
function eventExpedtionView:initData(target, data)
	SoraDCloseLoading(self)
	self:sortData()
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(640, 170), self.warConfig, 1, nil)
end
function eventExpedtionView:sortData()
	table.sort(self.warConfig, function(a, b)
		local aStatus, aAmount = expeditionCtrl:getQuestStatus(a.taskID)
		local bStatus, bAmount = expeditionCtrl:getQuestStatus(b.taskID)
		if aStatus == bStatus then
			return a.taskID < b.taskID
		else
			return aStatus < bStatus
		end
	end)
end
function eventExpedtionView:onBtnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "battlefield_text_01"
		;("battlefield_text_01").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("battlefield_text_01"), "battlefield_text_01")
	end
end
return eventExpedtionView
