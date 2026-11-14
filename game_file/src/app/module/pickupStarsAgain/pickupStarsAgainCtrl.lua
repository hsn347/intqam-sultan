local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local pickupStarsAgainCtrl = class("pickupStarsAgainCtrl", gamemodulec)
local pickupStarsAgainRead = include("pickupStarsAgainRead")
local constantRead = include("constantRead")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
_ENV = "msgCtrl"
;("msgCtrl").PERSON = 1
local ("msgCtrl").GLOBAL, REWARDTYPE = 2, "msgCtrl"
local DESERT_METEORITE_UNLOCK_LV = 6
local ACTIVITY_ID = gActivityTimeActivityID.PICKUP_STARS_AGAIN_ACTIVITY
function pickupStarsAgainCtrl:ctor(properties)
	pickupStarsAgainCtrl.super.ctor(self, properties)
	self.itemID = constantRead.getConstValue("PICKUP_STARS_ITEM")
	self:resetData()
end
function pickupStarsAgainCtrl:EnterGame()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.activityInitRsp))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PICKUP_STARS_AGAIN_BUILD, handler(self, self.reqAnnivColossusBuildRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PICKUP_STARS_AGAIN_TAKE_REWARD, handler(self, self.reqAnnivColossusTakeRewardRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PICKUP_STARS_AGAIN_TOTAL_SCORE, handler(self, self.reqAnnivColossusTotalScoreRsp))
	self:registerNotify()
	self:reqInit()
end
function pickupStarsAgainCtrl:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(ACTIVITY_ID) then
		self:resetData()
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = ACTIVITY_ID
		SoraDSendMessage(self)
	end
end
function pickupStarsAgainCtrl:onActivityClose()
end
function pickupStarsAgainCtrl:onActivityOpen()
	self:reqInit()
end
function pickupStarsAgainCtrl:canBuid()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemNum = backpackCtrl:getItemCount(self.itemID)
	if 0 < itemNum then
		return true
	end
end
function pickupStarsAgainCtrl:hasReward()
	local myRewardCfgs = pickupStarsAgainRead:getRewards(REWARDTYPE.PERSON)
	local myScore = self:getMyScore()
	for i, v in ipairs(myRewardCfgs) do
		local isGot = self:isRewardGot(REWARDTYPE.PERSON, v.Rank)
		if myScore >= v.NeedNum and not isGot then
			return true
		end
	end
end
function pickupStarsAgainCtrl:stageOneReddot()
	if not self:isStageOne() then
		return false
	end
	return self:canBuid() or self:hasReward()
end
function pickupStarsAgainCtrl:canExploreDesertMeteorite()
	if self:getExploreLeftTime() >= 0 and not SoraDGetCtrl("kingdomMapCtrl"):hasDesertMeteoriteQueue() and self:getExploreLeftTime() > 0 then
		return true
	end
end
function pickupStarsAgainCtrl:stageTwoReddot()
	if self:isDesertMeteoriteUnlock() then
		return self:canExploreDesertMeteorite()
	end
	return false
end
function pickupStarsAgainCtrl:isActivityOpen(showTip)
	if SoraDGetCastleLv() < DESERT_METEORITE_UNLOCK_LV then
		if showTip then
			DESERT_METEORITE_UNLOCK_LV = nil
			;(nil)[1] = DESERT_METEORITE_UNLOCK_LV
			SoraDShowMsgTip(i18n("common_text_1795", nil))
		end
		return false
	end
	if not SoraDGetCtrl("activityShowCtrl"):isActivityOpen(ACTIVITY_ID) then
		if showTip then
			SoraDShowMsgTip(i18n("common_text_2486"))
		end
		return false
	end
	return true
end
function pickupStarsAgainCtrl:getReceiveStatusAndNum()
	if self:isActivityOpen() and (self:stageOneReddot() or self:stageTwoReddot()) then
		return true, -1
	end
	return false, -1
end
function pickupStarsAgainCtrl:initClientData(data)
	print(debug.traceback())
	dump(data, "==pickupStarsAgainCtrl:initClientData==", 10)
	if not data then
		return
	end
	self.myData = data.data
	self.globalData = data.globalData
end
function pickupStarsAgainCtrl:Logout()
	pickupStarsAgainCtrl.super.Logout(self)
	self:resetData()
end
function pickupStarsAgainCtrl:resetData()
	self.myData = nil
	self.globalData = nil
end
function pickupStarsAgainCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.PICKUP_STARS_AGAIN_ACTIVITY, handler(self, self.notifyHandler))
end
function pickupStarsAgainCtrl:notifyHandler(event)
	dump(event.data, "pickupStarsAgainCtrl:notifyHandler", 10)
	for _, content in pairs(event.data) do
		self.globalData = content.globalInfo
	end
	_ENV = pairs(event.data)
	pairs(event.data).msg = "MESSAGE_PICKUP_STARS_AGAIN_REFRESH"
	SoraDSendMessage(pairs(event.data))
end
function pickupStarsAgainCtrl:activityInitRsp(target, data)
	if data.activityID == ACTIVITY_ID then
		self:initClientData(data.initData)
		ACTIVITY_ID = self
		self.msg = "MESSAGE_PICKUP_STARS_AGAIN_REFRESH"
		SoraDSendMessage(self)
	end
end
function pickupStarsAgainCtrl:reqInit(...)
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	activityTaskComponentCtrl:sendReqInit()
end
function pickupStarsAgainCtrl:reqAnnivColossusBuild()
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PICKUP_STARS_AGAIN_BUILD)
end
function pickupStarsAgainCtrl:reqAnnivColossusTakeReward(rank)
	serverproxy = nil
	;(nil).rank = rank
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PICKUP_STARS_AGAIN_TAKE_REWARD, nil)
end
function pickupStarsAgainCtrl:reqAnnivColossusTotalScore()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PICKUP_STARS_AGAIN_TOTAL_SCORE, nil)
end
function pickupStarsAgainCtrl:reqAnnivColossusBuildRsp(content)
	dump(content, "pickupStarsAgainCtrl:reqAnnivColossusBuild(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_PICKUP_STARS_AGAIN_BUILD"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = ACTIVITY_ID
		SoraDSendMessage(self)
	end
end
function pickupStarsAgainCtrl:reqAnnivColossusTakeRewardRsp(content)
	dump(content, "pickupStarsAgainCtrl:reqAnnivColossusTakeRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		if content.rspdata.reward then
			local _ENV, listItem = content.rspdata.reward, content.rspdata.reward
			for i, v in ipairs(content.rspdata.reward) do
				listItem[v.id] = v.count
			end
			SoraDMailGainItems(listItem, false)
		end
		_ENV = SoraDMailGainItems
		SoraDMailGainItems.msg = "MESSAGE_PICKUP_STARS_AGAIN_GET_REWARD"
		SoraDSendMessage(SoraDMailGainItems)
		_ENV = SoraDMailGainItems
		SoraDMailGainItems.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDMailGainItems.eventID = ACTIVITY_ID
		SoraDSendMessage(SoraDMailGainItems)
	end
end
function pickupStarsAgainCtrl:reqAnnivColossusTotalScoreRsp(content)
	dump(content, "pickupStarsAgainCtrl:reqAnnivColossusTotalScoreRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
end
function pickupStarsAgainCtrl:getMyData()
	return self.myData
end
function pickupStarsAgainCtrl:getGlobalData()
	return self.globalData
end
function pickupStarsAgainCtrl:getMyScore()
	return self.myData and self.myData.score or 0
end
function pickupStarsAgainCtrl:getGlobalScore()
	return self.globalData and self.globalData.score or 0
end
function pickupStarsAgainCtrl:isRewardGot(rType, rank)
	if rType == REWARDTYPE.PERSON then
		if self.myData and self.myData.gotGift and self.myData.gotGift[tostring(rank)] then
			return true
		end
		return false
	end
	if rType == REWARDTYPE.GLOBAL then
		if self.globalData and self.globalData.distributed and self.globalData.distributed[rank] then
			return true
		end
		return false
	end
end
function pickupStarsAgainCtrl:isStageOne()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityData = activityShowCtrl:getActivityData(ACTIVITY_ID)
	return activityData.doStage and activityData.doStage == 0
end
function pickupStarsAgainCtrl:isDesertMeteoriteUnlock()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityData = activityShowCtrl:getActivityData(ACTIVITY_ID)
	if serviceFunctions.systemTime() > activityData.endtime then
		return false
	end
	return activityData.doStage and activityData.doStage > 0
end
function pickupStarsAgainCtrl:getStageOneLeftTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityData = activityShowCtrl:getActivityData(ACTIVITY_ID)
	local sysTime = serviceFunctions.systemTime()
	local endtime = activityData and activityData.stagetimes and activityData.stagetimes[1] or 0
	return endtime - sysTime
end
function pickupStarsAgainCtrl:getActivityLeftTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityData = activityShowCtrl:getActivityData(ACTIVITY_ID)
	local sysTime = serviceFunctions.systemTime()
	return activityData and activityData.endtime and activityData.endtime - sysTime or 0
end
function pickupStarsAgainCtrl:getExploreLeftTime()
	local count = self:getDayExploreCount()
	local totalNum = constantRead.getConstValue("DESERT_METEORITES_NUM")
	local perTime = constantRead.getConstValue("DESERT_METEORITES_TIME")
	return (totalNum - count) * perTime
end
function pickupStarsAgainCtrl:getDayExploreCount()
	if self.myData then
		if not serviceFunctions.isSameDay(self.myData.dayExploreEventLastTime or 0) then
			return 0
		end
		return self.myData.dayExploreEventCount or 0
	end
	return 0
end
function pickupStarsAgainCtrl:checkDesertMeteoriteOpen(showTip)
	if not self:isActivityOpen(showTip) then
		return false
	end
	if not self:isDesertMeteoriteUnlock() then
		if showTip then
			SoraDShowMsgTip(i18n("common_text_2486"))
		end
		return false
	end
	return true
end
function pickupStarsAgainCtrl:setLastStage(stage)
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:pickupStarsAgainCtrl:lastStage~integer", stage, nil)
end
function pickupStarsAgainCtrl:getLastStage()
	_ENV = nil
	;(nil).byUID = true
	return SoraDConfigGet("Game:pickupStarsAgainCtrl:lastStage~integer", nil) or 1
end
return pickupStarsAgainCtrl
