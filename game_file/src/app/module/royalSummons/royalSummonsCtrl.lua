local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = class("royalSummonsCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local activityID = gActivityTimeActivityID.ROYAL_SUMMONS
local LV_VALUE = 100
local ROYAL_SUMMONS_MAX_LEVEL = 50
local ROYAL_SUMMONS_LEVEL = 3
function royalSummonsCtrl:getClassType()
	local param = SoraDGetCtrl("activityShowCtrl"):getParamByID(activityID)
	print("···royalSummonsCtrl-paramlth", param.classtype)
	return param.classtype or 1
end
function royalSummonsCtrl:getActivitySeasonRound()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local round = activityShowCtrl:getOpenCount(activityID)
	return round
end
function royalSummonsCtrl:getActivitySeasonTitle()
	local round = self:getActivitySeasonRound()
	_ENV = nil
	;(nil).num = round
	return i18n("remains_text_02", nil)
end
function royalSummonsCtrl:getActivitySeasonEndTime()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local endTime = activityShowCtrl:getEndTimeSecond(activityID)
	return endTime
end
function royalSummonsCtrl:getActivityStatusTime()
	local endTime = self:getActivitySeasonEndTime()
	local sysTime = serviceFunctions.systemTime()
	if endTime > sysTime then
		return endTime - sysTime
	end
	return 0
end
function royalSummonsCtrl:getActivitySeasonEndTitle()
	local time = self:getActivitySeasonEndTime()
	local strTime = os.date("!%Y/%m/%d", time)
	_ENV = nil
	;(nil).time = strTime
	return i18n("summoned_text_09", nil)
end
function royalSummonsCtrl:getActivityDay()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local beginTime = activityShowCtrl:getBeginTimeSecond(activityID)
	local day1 = serviceFunctions.getUtcDayIndex(beginTime)
	local day2 = serviceFunctions.getUtcDayIndex(serviceFunctions.systemTime())
	if day1 <= day2 then
		return day2 - day1 + 1
	end
	return 0
end
function royalSummonsCtrl:isActiveGold()
	return self.isGoldClass
end
function royalSummonsCtrl:getKingTokenNum()
	return self.exchangeCoin or 0
end
function royalSummonsCtrl:getExchangeNum(itemId)
	local exchangeInfo = self.exchangeMap[tostring(itemId)]
	if exchangeInfo and exchangeInfo.count then
		return exchangeInfo.count
	end
	return 0
end
function royalSummonsCtrl:lazeyInitExchangeNotity()
