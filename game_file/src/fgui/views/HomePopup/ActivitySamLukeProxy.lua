local baseProxy = require("fgui.base.baseProxy")
local ActivitySamLukeProxy = class("ActivitySamLukeProxy", baseProxy)
function ActivitySamLukeProxy:onRegisterEvent()
	print("=======ActivitySamLukeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_SEMLUK_BALL_REFRESH", function(target, redata)
		SoraDCloseLoading()
		self.view:initData()
	end)
end
function ActivitySamLukeProxy:judgeClose(target, redata)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SEMLUK_EXPERIENCE_BALL) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function ActivitySamLukeProxy:getRefreshRemainTime()
	if not IsArClient then
		return self:getROSRefreshRemainTime()
	end
	local serverTime = serviceFunctions.systemTime()
	local hour = tonumber(os.date("!%H", serverTime))
	local targetHour = 15
	if 15 <= hour and hour < 18 then
		targetHour = 18
	elseif 18 <= hour and hour < 21 then
		targetHour = 21
	elseif 21 <= hour and hour < 23 then
		targetHour = 23
	end
	local targetTime = serviceFunctions.getTodayZeroHourUTC() + targetHour * 3600
	local remainTime = targetTime - serverTime
	return remainTime
end
function ActivitySamLukeProxy:getROSRefreshRemainTime()
	local serverTime = serviceFunctions.systemTime()
	local hour = tonumber(os.date("!%H", serverTime))
	local targetHour = 0
	if 0 <= hour and hour < 4 then
		targetHour = 4
	elseif 4 <= hour and hour < 8 then
		targetHour = 8
	elseif 8 <= hour and hour < 12 then
		targetHour = 12
	elseif 12 <= hour and hour < 16 then
		targetHour = 16
	elseif 16 <= hour and hour < 20 then
		targetHour = 20
	end
	local targetTime = serviceFunctions.getTodayZeroHourUTC() + targetHour * 3600
	local remainTime = targetTime - serverTime
	if 20 <= hour then
		remainTime = serviceFunctions.getTodayRemainTime() + targetHour * 3600
		print("slkdjfskldjf", remainTime, serviceFunctions.getTodayRemainTime(), targetHour)
	end
	return remainTime
end
return ActivitySamLukeProxy
