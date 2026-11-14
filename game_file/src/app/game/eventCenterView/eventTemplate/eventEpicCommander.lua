local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local eventEpicCommander = class("eventEpicCommander", function(target)
	if target then
		return target
	end
	return SoraDCreateTouchPanel("eventEpicCommander")
end)
function eventEpicCommander:ctor()
	SoraDGetChildByName(self, "Text_name"):setString(i18n("activity_name_22"))
	self.Button_Look = SoraDGetChildByName(self, "Button_Look")
	self.Button_Look:setTitleText(i18n("common_text_477"))
	self.Button_Look:addTouchEventListener(handler(self, self.btnClickLook))
	self.textTime = SoraDGetChildByName(self, "Text_Time")
	self.textTime = SoraDCreateTimerLabel(self, self.textTime)
	self.textTime:setTimeEndListener(function()
		self:removeFromParent()
	end)
	self.Text_Info = SoraDGetChildByName(self, "Text_Info")
	_ENV = handler(self, self.btnClickLook)
	handler(self, self.btnClickLook).multiple = activityShowCtrl:getEpicCommandMultiple()
	self.Text_Info:setString(i18n("herotrain_text_28", handler(self, self.btnClickLook)))
	self:setTime()
end
function eventEpicCommander:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function eventEpicCommander:setTime()
	self.textTime:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("common_text_766", nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.EPIC_WAR_EXP_MULTIPLE)
	if timer then
		self.leftTime = timer.timerNode.timer:getRemainTime()
		_ENV = nil
		;(nil).time = self.leftTime
		self.textTime:setString(i18n("common_text_766", nil))
		self.textTime:beginTime(self.leftTime)
	end
end
function eventEpicCommander:btnClickLook(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.EPIC_WAR, nil)
		SoraDRemoveAllPanelFromManager()
	end
end
function eventEpicCommander:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EPIC_WAR_EXP_MULTIPLE) then
		self:removeFromParent()
	end
end
return eventEpicCommander
