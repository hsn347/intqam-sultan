local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local superCommanderView = class("superCommanderView", function(target)
	if target then
		return target
	end
	return SoraDCreateTouchPanel("superCommanderView")
end)
function superCommanderView:ctor()
	SoraDGetChildByName(self, "Text_name"):setString(i18n("activity_name_19"))
	self.btnLook = SoraDGetChildByName(self, "Button_Look")
	self.btnLook:addTouchEventListener(handler(self, self.btnClickLook))
	self.btnLook:setTitleText(i18n("common_text_477"))
	self.textTime = SoraDGetChildByName(self, "Text_Time")
	self.textTime = SoraDCreateTimerLabel(self, self.textTime)
	self.textTime:setTimeEndListener(function()
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	self.textTime:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("common_text_766", nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.SUPER_COMMANDER)
	if timer then
		self.leftTime = timer.timerNode.timer:getRemainTime()
		_ENV = i18n("common_text_477")
		i18n("common_text_477").time = self.leftTime
		self.textTime:setString(i18n("common_text_766", i18n("common_text_477")))
		self.textTime:beginTime(self.leftTime)
	end
	self.textInfo = SoraDGetChildByName(self, "Text_Info")
	_ENV = i18n("common_text_766", i18n("common_text_477"))
	i18n("common_text_766", i18n("common_text_477")).multiple = activityShowCtrl:getClassType(gActivityTimeActivityID.SUPER_COMMANDER) / 1000
	self.textInfo:setString(i18n("hero_text_105", i18n("common_text_766", i18n("common_text_477"))))
	SoraDGetAutoHeightLabel(self.textInfo, 480)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function superCommanderView:btnClickLook(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if heroCtrl:getMaxBattleHeroNum() <= 0 then
			_ENV = nil
			;(nil).lv = CASTLE_LV7_LIMITED
			SoraDShowMsgTip(i18n("common_text_3868", nil))
		else
			uiManager:show("newHeroListView")
		end
	end
end
function superCommanderView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SUPER_COMMANDER) then
		self:layerClickCallBack(self, ccui.TouchEventType.ended)
	end
end
return superCommanderView
