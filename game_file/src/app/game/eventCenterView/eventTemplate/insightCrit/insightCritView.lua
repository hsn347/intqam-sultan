local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local insightCritView = class("insightCritView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("insightCritView")
	end
	return target
end)
function insightCritView:ctor()
	self:initControls()
	self:initData()
end
function insightCritView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.Button_go:setTitleText(i18n("common_text_477"))
	self.Button_go:addTouchEventListener(handler(self, self.buttonGoCallBack))
	self.Text_ins:setString(i18n("addition_text_02"))
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.HERO_AWAKE_CRIT_ACTIVTY)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.Text_time:setString(SoraDConvertSecondToString(leftTime))
		self.Text_time:beginTime(leftTime)
	end
end
function insightCritView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function insightCritView:initData()
end
function insightCritView:buttonGoCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllPanelFromManager()
		uiManager:show("newHeroListView")
	end
end
function insightCritView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.HERO_AWAKE_CRIT_ACTIVTY) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return insightCritView
