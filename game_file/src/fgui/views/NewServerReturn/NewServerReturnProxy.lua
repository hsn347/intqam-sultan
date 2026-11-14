local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseProxy = require("fgui.base.baseProxy")
local NewServerReturnProxy = class("NewServerReturnProxy", baseProxy)
function NewServerReturnProxy:ctor(...)
	self.super.ctor(self, ...)
	self.activityIDList = activityShowCtrl:getActivityGroup(gActivityCenterUIEnum.NEWSERVERBACK_ACTIVITY)
end
function NewServerReturnProxy:onRegisterEvent()
	print("=======NewServerReturnProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updateRedPoint))
end
function NewServerReturnProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
		return
	end
	local _ENV, ret = SoraDRemoveAllAfterPanelFromManager, SoraDRemoveAllAfterPanelFromManager
	for i, v in ipairs(self.view.eventData) do
		if not clientEventMgr.judgeIsOpen(v.activityID) then
			table.insert(ret, v.activityID)
		end
	end
	if next(ret) then
		self.view:removeActivityList(ret)
	end
end
function NewServerReturnProxy:updateRedPoint(target, data)
	self.view:updateRedPoint(target, data)
end
function NewServerReturnProxy:getActivityOrder(activityID)
	if not self.orderMap then
		self.orderMap, _ENV = self.orderMap, self.orderMap
		local newstart = require_data("newstart", true).data
		for k, v in pairs(newstart) do
			self.orderMap[v.activityId] = v.activityOrder
		end
	end
	return self.orderMap[activityID] or activityID
end
function NewServerReturnProxy:getActivityShowList(...)
	_ENV = nil
	_ENV = nil
	;(nil).title = i18n("activity_name_9001405")
	;(nil).iconURL = "icon_newstarteffect.png"
	;(nil)[gActivityTimeActivityID.NEW_START_EFFECT_ACTIVITY], (nil).comName = nil, "Com_newServerGain"
	_ENV = nil
	;(nil).title = i18n("activity_name_9001406")
	;(nil).iconURL = "icon_newstartreward.png"
	;(nil)[gActivityTimeActivityID.NEW_START_REWARD_ACTIVITY], (nil).comName = nil, "Com_newServerReward"
	_ENV = nil
	;(nil).title = i18n("activity_name_9001407")
	;(nil).iconURL = "icon_newstartInherit.png"
	;(nil)[gActivityTimeActivityID.WEALTH_ACTIVITY], (nil).comName = nil, "Com_inheritance"
	_ENV = nil
	;(nil).title = i18n("activity_name_9001408")
	;(nil).iconURL = "icon_roadtoreviva.png"
	;(nil)[gActivityTimeActivityID.ROAD_TO_REVIVE_ACTIVITY], (nil).comName = nil, "Com_revivalRoad"
	_ENV = nil
	;(nil).title = i18n("activity_name_9001409")
	;(nil).iconURL = "icon_viciouscat.png"
	;(nil)[gActivityTimeActivityID.VICIOUS_PET_ACTIVITY], (nil).comName = nil, "caracalmian"
	_ENV = nil
	;(nil).title = i18n("activity_name_9001410")
	;(nil).iconURL = "icon_riseofsudan.png"
	;(nil)[gActivityTimeActivityID.SUDAN_RISING_ACTIVITY], (nil).comName = nil, "Com_riseOfSultan"
	_ENV = nil
	;(nil).title = i18n("activity_name_9001449")
	;(nil).iconURL = "icon_backtotop.png"
	;(nil)[gActivityTimeActivityID.BACK_TO_TOP_ACTIVITY], (nil).comName = nil, "backToTopView"
	local eventConfig
	local _ENV, ret = gActivityTimeActivityID.BACK_TO_TOP_ACTIVITY, gActivityTimeActivityID.BACK_TO_TOP_ACTIVITY
	for activityID, v in pairs(self.activityIDList) do
		if clientEventMgr.judgeIsOpen(activityID) then
			local data = eventConfig[activityID]
			data.activityID = activityID
			data.order = self:getActivityOrder(activityID)
			table.insert(ret, data)
		end
	end
	table.sort(ret, function(a, b)
		if a.order ~= b.order then
			return a.order < b.order
		end
		return a.activityID > b.activityID
	end)
	return ret
end
function NewServerReturnProxy:initActivityTime(Label_timer, activityID)
	Label_timer:setTimeLast(function(strTime)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, strTime
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html("common_text_4415", nil, nil)
	end)
	Label_timer:initActivityTime(activityID)
end
function NewServerReturnProxy:jumpToActivity(activityID)
	self.view:jumpToActivity(activityID)
end
return NewServerReturnProxy
