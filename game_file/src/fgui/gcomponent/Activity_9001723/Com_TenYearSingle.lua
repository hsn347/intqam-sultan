local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_TenYearSingle = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001723/Com_TenYearSingle", Com_TenYearSingle)
function Com_TenYearSingle:onInit()
	self:addClickListener(handler(self, self.onClickSelf))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.update))
end
function Com_TenYearSingle:onShow()
end
function Com_TenYearSingle:initData(data)
	local activityData = clientEventMgr.nowEventStateList[data.activityId]
	self.data = data
	local name = i18n(data.activityName)
	if activityData then
		name = activityData.eventName
	end
	self.fields.title:setString(name)
	local timeLeft = activityShowCtrl:getTimeInfoByID(data.activityId)
	local startTime, endTime = data.default_startTime, data.default_endTime
	if timeLeft then
		startTime = timeLeft.starttime
		endTime = timeLeft.totaltime + startTime
	end
	local timeStr = string.format("%s-%s", os.date("!%m.%d", startTime), os.date("!%m.%d", endTime))
	self.fields.Text_time:setString(timeStr)
	local serverTime = serviceFunctions.systemTime()
	if startTime > serverTime then
		self.controllers.ctrlStatus:setSelectedIndex(0)
	elseif endTime <= serverTime then
		self.controllers.ctrlStatus:setSelectedIndex(2)
	else
		self.controllers.ctrlStatus:setSelectedIndex(1)
		if clientEventMgr.judgeIsOpen(data.activityId, false) then
			local timeStr = SoraDConvertSecondToString(endTime - serverTime)
			self.fields.Text_time:setString(timeStr)
		else
			self.controllers.ctrlStatus:setSelectedIndex(0)
		end
	end
end
function Com_TenYearSingle:onClickSelf(...)
	SoraDPlaySound()
	local pID = self.data.activityId
	if clientEventMgr.judgeIsOpen(self.data.activityId, false) then
		local trigger = clientEventMgr.singleClickEvent(pID, 1)
		if not trigger then
			SoraDShowMsgTip(i18n("common_text_699"))
		end
	elseif self.controllers.ctrlStatus:getSelectedIndex() == 0 then
		SoraDShowMsgTip(i18n("anniversary_2025_02"))
	elseif self.controllers.ctrlStatus:getSelectedIndex() == 2 then
		SoraDShowMsgTip(i18n("anniversary_2025_03"))
	end
end
function Com_TenYearSingle:update()
end
return Com_TenYearSingle
