local anniversaryRead = include("anniversaryRead")
local activityTimeRead = include("activityTimeRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_mode = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001690/Com_mode", Com_mode)
function Com_mode:onInit()
	self._activityID = gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Text_finish:setString(i18n("devilvalley_text_08"))
	self.fields.Text_finish:setVisible(false)
	self.fields.Btn_icon:addClickListener(handler(self, self.btnClick))
end
function Com_mode:onShow()
end
function Com_mode:initWeek(week, cfg, rType)
	self.week = week
	local param = activityShowCtrl:getParamByID(self._activityID)
	activityShowCtrl = nil
	;(nil).num = self.week
	self.fields.Text_name:setString(i18n("ruise_rabia_06", nil))
	self.fields.Text_name:setPositionY(156)
	local placeIcon = anniversaryRead.getPlaceIcon(rType, 3 + self.week, self._activityID)
	self.fields.Btn_icon:setIcon(placeIcon)
	local sysTime = serviceFunctions.systemTime()
	local beginTime, endTime = self:getActivityTimeCfg()
	if beginTime == 0 and endTime == 0 then
		self.fields.Text_time:setVisible(false)
		self.fields.Text_finish:setVisible(false)
		self.fields.Text_name:setPositionY(170)
	elseif sysTime >= endTime then
		self.fields.Text_time:setVisible(false)
		self.fields.Text_finish:setVisible(true)
		self.fields.Text_finish:setString(i18n("Anchor_text_21"))
	elseif sysTime >= beginTime and sysTime < endTime then
		self.fields.Text_time:setVisible(false)
		self.fields.Text_finish:setVisible(false)
		self.fields.Text_name:setPositionY(170)
	else
		self.fields.Text_finish:setVisible(false)
		self.fields.Text_time:setVisible(true)
		self.Text_time:setTimeLast(function(strTime)
			_ENV = nil
			;(nil).time = fguiHelper.getColorString("#FFFFFF", strTime)
			return i18n("common_text_606", nil)
		end)
		self.fields.Text_time:beginTime(beginTime - sysTime)
	end
end
function Com_mode:getActivityTimeCfg()
	local param = activityShowCtrl:getParamByID(self._activityID)
	if not param.showConfig then
		local activityShowCtrl, showConfig = param.showConfig, param.showConfig
	end
	local activityShowCtrl, ret = self._activityID, self._activityID
	for i, v in ipairs(showConfig) do
		if self:isNeedShow(v.weeks, self.week, v.activityID) then
			table.insert(ret, v)
		end
	end
	if 0 < #ret then
		table.sort(ret, function(a, b)
			return a.beginTime < b.beginTime
		end)
		local beginTime = ret[1].beginTime
		table.sort(ret, function(a, b)
			return a.endTime > b.endTime
		end)
		local endTime = ret[1].endTime
		return beginTime, endTime
	else
		return 0, 0
	end
end
function Com_mode:isNeedShow(weeks, week, activityID)
	for i, v in ipairs(weeks) do
		if v == week then
			return true
		end
	end
	return false
end
function Com_mode:isActivityPassed(activityID, showConfig)
	local ret = false
	for k, v in ipairs(showConfig) do
		if v.activityID == activityID and v.endTime < serviceFunctions.systemTime() then
			ret = true
			break
		end
	end
	return ret
end
function Com_mode:initActivity(showplace, rType)
	local param = activityShowCtrl:getParamByID(self._activityID)
	local cfg = anniversaryRead.getActCfgEX(showplace, param.classtype or 1, rType, self._activityID)
	self.activityID = cfg.activityID
	local _param = activityShowCtrl:getParamByID(self.activityID)
	local _classtype = _param.classtype or 1
	self.fields.Text_name:setString(i18n(activityTimeRead.getActivityNameByID(self.activityID, _classtype)))
	self.fields.Btn_icon:setIcon(anniversaryRead.getPlaceIcon(rType, showplace, self._activityID))
	local status = activityShowCtrl:getStateByID(self.activityID)
	local param = activityShowCtrl:getParamByID(self.activityID)
	if not param.showConfig then
		local activityShowCtrl, showConfig = param.showConfig, param.showConfig
	end
	if status == gActivityState.OPEN then
		self.fields.Text_finish:setVisible(false)
		self.fields.Text_time:setVisible(true)
		self.Text_time:setTimeLast(function(strTime)
			return fguiHelper.getColorString("#FFC864", i18n("common_text_2669")) .. fguiHelper.getColorString("#FFFFFF", strTime)
		end)
		local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
		if eventTime then
			self.fields.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
		end
	elseif status == gActivityState.CLOSE then
		self.fields.Text_time:setVisible(false)
		self.fields.Text_finish:setVisible(true)
		self.fields.Text_finish:setString(self:isActivityPassed(self.activityID, showConfig) and i18n("common_text_1859") or i18n("devilvalley_text_08"))
	elseif status == gActivityState.PREPARE then
		self.fields.Text_finish:setVisible(false)
		self.fields.Text_time:setVisible(true)
		self.Text_time:setTimeLast(function(strTime)
			_ENV = nil
			;(nil).time = fguiHelper.getColorString("#FFFFFF", strTime)
			return i18n("common_text_606", nil)
		end)
		local activityData = activityShowCtrl:getActivityData(self.activityID)
		self.fields.Text_time:beginTime(activityData.begintime - serviceFunctions.systemTime())
	end
end
function Com_mode:btnClick()
	SoraDPlaySound()
	if self.week then
		_ENV = nil
		;(nil).week = self.week
		uiManager:show("Activity_9001690_List", nil)
	elseif clientEventMgr.getEventInfoByeid(self.activityID) then
		clientEventMgr.singleClickEvent(self.activityID)
	else
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
end
return Com_mode
