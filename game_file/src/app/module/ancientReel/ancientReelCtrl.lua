local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local ancientReelCtrl = class("ancientReelCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local ancientReelDef = include("ancientReelDef")
local ancientReelRead = include("ancientReelRead")
local LV_VALUE = ancientReelDef.LV_VALUE
local ANCIENT_REEL_MAX_LEVEL = ancientReelDef.ANCIENT_REEL_MAX_LEVEL
local ANCIENT_REEL_LEVEL = ancientReelDef.ANCIENT_REEL_LEVEL
local ANCIENT_REEL_AWARD_TYPE = ancientReelDef.ANCIENT_REEL_AWARD_TYPE
local ANCIENT_REEL_ITEM_TYPE = ancientReelDef.ANCIENT_REEL_ITEM_TYPE
function ancientReelCtrl:getClassType()
	local param = _G.SoraDGetCtrl("activityShowCtrl"):getParamByID(self.activityID)
	return param.classtype or 1
end
function ancientReelCtrl:getActivitySeasonRound()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local round = activityShowCtrl:getOpenCount(self.activityID)
	return round
end
function ancientReelCtrl:getActivitySeasonTitle()
	local round = self:getActivitySeasonRound()
	_ENV = nil
	;(nil).num = round
	return i18n("remains_text_02", nil)
end
function ancientReelCtrl:getActivitySeasonEndTime()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local endTime = activityShowCtrl:getEndTimeSecond(self.activityID)
	return endTime
end
function ancientReelCtrl:getActivityStatusTime()
	local endTime = self:getActivitySeasonEndTime()
	local sysTime = serviceFunctions.systemTime()
	if endTime > sysTime then
		return endTime - sysTime
	end
	return 0
end
function ancientReelCtrl:getActivitySeasonEndTitle()
	local time = self:getActivitySeasonEndTime()
	local strTime = os.date("!%Y/%m/%d", time)
	_ENV = nil
	;(nil).time = strTime
	return i18n("summoned_text_09", nil)
end
function ancientReelCtrl:getActivityDay()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local beginTime = activityShowCtrl:getBeginTimeSecond(self.activityID)
	local day1 = serviceFunctions.getUtcDayIndex(beginTime)
	local day2 = serviceFunctions.getUtcDayIndex(serviceFunctions.systemTime())
	if day1 <= day2 then
		return day2 - day1 + 1
	end
	return 0
end
function ancientReelCtrl:isActiveGold()
	return self.ancientReelLock > 0
end
function ancientReelCtrl:getKingTokenNum()
	return self.ancientReelExchange or 0
end
function ancientReelCtrl:getExchangeNotifyNum()
	local activityExchangeMallCtrl = _G.SoraDGetCtrl("activityExchangeMallCtrl")
	local _, num = activityExchangeMallCtrl:getReceiveStatusAndNum(self.activityID)
	return num
end
function ancientReelCtrl:getCurLevel()
	return math.floor(self.ancientReelExp / LV_VALUE)
end
function ancientReelCtrl:getLevelAddExp(exp)
	return math.floor((self.ancientReelExp + exp) / LV_VALUE)
end
function ancientReelCtrl:getCurLevelExp()
	local min = self.ancientReelExp % LV_VALUE
	return min, LV_VALUE
end
function ancientReelCtrl:isMaxLevel()
	local level = self:getCurLevel()
	return level > ANCIENT_REEL_MAX_LEVEL
end
function ancientReelCtrl:getCurGoldLevel()
	local level = self:getCurLevel()
	return math.min(level, ANCIENT_REEL_MAX_LEVEL)
end
function ancientReelCtrl:getAwardNum(isGold, level)
	local getAwardNum_awardNum = function(awardType, levelBegin, levelNum)
		local num = 0
		if awardType == ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_NORMAL then
			for i = levelBegin + 1, levelBegin + levelNum do
				local awardData = ancientReelRead:getLevelList(i, self:getClassType())
				if awardData and awardData.bronzeAward then
					num = num + #awardData.bronzeAward
				end
			end
		elseif awardType == ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_GOLD then
			for i = levelBegin + 1, levelBegin + levelNum do
				local awardData = ancientReelRead:getLevelList(i, self:getClassType())
				if awardData and awardData.goldAward then
					num = num + #awardData.goldAward
				end
			end
		elseif awardType == ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_SUPER then
			local awardData = ancientReelRead:getLevelMaxList(self:getClassType())
			if awardData and awardData.award and 0 < #awardData.award then
				local awardNum = #awardData.award
				for _ = levelBegin + 1, levelBegin + levelNum do
					num = num + awardNum
				end
			end
		end
		return num
	end
	isGold = isGold or self.ancientReelLock > 0
	level = level or self:getCurLevel()
	local num = 0
	do
		local lvnum = math.max(0, math.min(level, ANCIENT_REEL_MAX_LEVEL) - self.bronzeAwardLv)
		if 0 < lvnum then
			num = num + getAwardNum_awardNum(ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_NORMAL, self.bronzeAwardLv, lvnum)
		end
	end
	if isGold and self.goldAwardLv < ANCIENT_REEL_MAX_LEVEL then
		local lvnum = math.max(0, math.min(level, ANCIENT_REEL_MAX_LEVEL) - self.goldAwardLv)
		if 0 < lvnum then
			num = num + getAwardNum_awardNum(ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_GOLD, self.goldAwardLv, lvnum)
		end
	end
	do
		local lvSuperLv = math.max(self.bronzeAwardLv, ANCIENT_REEL_MAX_LEVEL)
		if level >= lvSuperLv then
			local lvnum = math.max(0, math.floor(level - lvSuperLv) / ANCIENT_REEL_LEVEL)
			if 0 < lvnum then
				num = num + getAwardNum_awardNum(ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_SUPER, lvSuperLv, lvnum)
			end
		end
	end
	return num
end
function ancientReelCtrl:getAwardItemNum(minLv, maxLv)
	local awardItemNum_imp = function(lv)
		local curlv = math.max(lv, ANCIENT_REEL_MAX_LEVEL)
		return math.max(0, math.floor((curlv - ANCIENT_REEL_MAX_LEVEL) / ANCIENT_REEL_LEVEL))
	end
	local num = awardItemNum_imp(maxLv) - awardItemNum_imp(minLv - 1)
	return math.max(0, num)
end
function ancientReelCtrl:getAwardItemStatus(awardType, lv)
	local curLevel = self:getCurLevel()
	lv = lv or curLevel
	if awardType == ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_NORMAL then
		if lv <= self.bronzeAwardLv then
			return ANCIENT_REEL_ITEM_TYPE.ANCIENT_REEL_ITEM_TYPE_GET
		elseif curLevel >= lv then
			return ANCIENT_REEL_ITEM_TYPE.ANCIENT_REEL_ITEM_TYPE_AWARD
		end
	elseif awardType == ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_GOLD then
		if lv <= self.goldAwardLv then
			return ANCIENT_REEL_ITEM_TYPE.ANCIENT_REEL_ITEM_TYPE_GET
		elseif curLevel >= lv then
			if self.ancientReelLock > 0 then
				return ANCIENT_REEL_ITEM_TYPE.ANCIENT_REEL_ITEM_TYPE_AWARD
			else
				return ANCIENT_REEL_ITEM_TYPE.ANCIENT_REEL_ITEM_TYPE_ACTIVITY
			end
		elseif self.ancientReelLock <= 0 then
			return ANCIENT_REEL_ITEM_TYPE.ANCIENT_REEL_ITEM_TYPE_LOCK
		end
	elseif awardType == ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_SUPER and lv > ANCIENT_REEL_MAX_LEVEL then
		if lv <= self.bronzeAwardLv then
			return ANCIENT_REEL_ITEM_TYPE.ANCIENT_REEL_ITEM_TYPE_GET
		elseif curLevel >= lv and (lv - self.bronzeAwardLv) / ANCIENT_REEL_LEVEL >= 1 then
			return ANCIENT_REEL_ITEM_TYPE.ANCIENT_REEL_ITEM_TYPE_AWARD
		end
	end
	return ANCIENT_REEL_ITEM_TYPE.ANCIENT_REEL_ITEM_TYPE_NORMAL
end
function ancientReelCtrl:getTaskNum()
	local activityTaskComponentCtrl = gametop.playertop_:getModule("activityTaskComponentCtrl")
	local _, num = activityTaskComponentCtrl:getReceiveStatusAndNum(self.activityID)
	return num or 0
end
function ancientReelCtrl:getReceiveStatusAndNum()
	local num = 0
	if _G.clientEventMgr.judgeIsOpen(self.activityID) then
		num = self:getAwardNum() + self:getTaskNum() + self:getExchangeNotifyNum()
	end
	return 0 < num, num
end
function ancientReelCtrl:reqActivityGetAllLevelReward()
	print("ancientReelCtrl:reqActivityGetAllLevelReward")
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANCIENT_REEL_RECEIVE_LV_REWARD)
end
function ancientReelCtrl:reqActivityBuyExp(eid, count)
	print("ancientReelCtrl:reqActivityBuyExp", eid)
	_ENV = nil
	;(nil).shopID = eid
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANCIENT_REEL_BUY, nil)
end
function ancientReelCtrl:ctor(properties)
	ancientReelCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.ANCIENT_REEL_ACTIVITY
end
function ancientReelCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANCIENT_REEL_RECEIVE_LV_REWARD, handler(self, self.reqActivityGetAllLevelRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANCIENT_REEL_BUY, handler(self, self.reqActivityBuyExpRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end
function ancientReelCtrl:resetData()
	self.ancientReelExp = 0
	self.bronzeAwardLv = 0
	self.goldAwardLv = 0
	self.ancientReelLock = 0
	self.ancientReelExchange = 0
end
function ancientReelCtrl:Logout()
	ancientReelCtrl.super.Logout(self)
	self:resetData()
end
function ancientReelCtrl:notifyHandler(content)
	local notifydata = content.data
	for _, notifyMsg in ipairs(notifydata) do
		local activityID = notifyMsg.activityID
		if tonumber(activityID) == self.activityID then
			self:updateDataAndNotice(notifyMsg.notifyData)
		end
	end
end
function ancientReelCtrl:updateDataAndNotice(data)
	if not data then
		return
	end
	local bsend = false
	if data.ancientReelLock ~= nil and self.ancientReelLock ~= data.ancientReelLock then
		bsend = true
	end
	self:updateData(data)
	if bsend then
		_ENV = self
		self.msg = "MESSAGE_SERVER_ANCIENT_REEL_GOLD"
		SoraDSendMessage(self)
	end
	if data.ancientReelExp or data.bronzeAwardLv or data.goldAwardLv then
		_ENV = self
		self.msg = "MESSAGE_SERVER_ANCIENT_REEL_AWARD"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = self.activityID
		SoraDSendMessage(self)
	end
end
function ancientReelCtrl:updateData(data)
	dump(data, "ancientReelCtrl:updateData", 10)
	if data.ancientReelLock ~= nil then
		self.ancientReelLock = data.ancientReelLock
	end
	if data.ancientReelExp then
		self.ancientReelExp = data.ancientReelExp
	end
	if data.bronzeAwardLv then
		self.bronzeAwardLv = data.bronzeAwardLv
	end
	if data.goldAwardLv then
		self.goldAwardLv = data.goldAwardLv
	end
	if data.ancientReelExchange then
		self.ancientReelExchange = data.ancientReelExchange
	end
end
function ancientReelCtrl:initClientData(data)
