local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local annivColossusCtrl = class("annivColossusCtrl", gamemodulec)
local annivColossusRead = include("annivColossusRead")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
_ENV = "msgCtrl"
;("msgCtrl").PERSON = 1
local ("msgCtrl").GLOBAL, REWARDTYPE = 2, "msgCtrl"
function annivColossusCtrl:ctor(properties)
	annivColossusCtrl.super.ctor(self, properties)
	self.itemID = 841801
	self:resetData()
end
function annivColossusCtrl:EnterGame()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.activityInitRsp))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANNIV_COLOSSUS_BUILD, handler(self, self.reqAnnivColossusBuildRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANNIV_COLOSSUS_TAKE_REWARD, handler(self, self.reqAnnivColossusTakeRewardRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANNIV_COLOSSUS_TOTAL_SCORE, handler(self, self.reqAnnivColossusTotalScoreRsp))
	self:registerNotify()
end
function annivColossusCtrl:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANNIV_COLOSSUS_ACTIVITY) then
		self:resetData()
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = gActivityTimeActivityID.ANNIV_COLOSSUS_ACTIVITY
		SoraDSendMessage(self)
	end
end
function annivColossusCtrl:getReceiveStatusAndNum()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemNum = backpackCtrl:getItemCount(self.itemID)
	if 0 < itemNum then
		return true, -1
	end
	local myRewardCfgs = annivColossusRead:getRewards(REWARDTYPE.PERSON)
	local myScore = self:getMyScore()
	for i, v in ipairs(myRewardCfgs) do
		local isGot = self:isRewardGot(REWARDTYPE.PERSON, v.Rank)
		if myScore >= v.NeedNum and not isGot then
			return true, -1
		end
	end
	return false, -1
end
function annivColossusCtrl:initClientData(data)
	dump(data, "==annivColossusCtrl:initClientData==", 10)
	if not data then
		return
	end
	self.myData = data.data
	self.globalData = data.globalData
end
function annivColossusCtrl:Logout()
	annivColossusCtrl.super.Logout(self)
	self:resetData()
end
function annivColossusCtrl:resetData()
	self.myData = nil
	self.globalData = nil
end
function annivColossusCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ANNIV_COLOSSUS_ACTIVITY, handler(self, self.notifyHandler))
end
function annivColossusCtrl:notifyHandler(event)
	dump(event.data, "annivColossusCtrl:notifyHandler", 10)
	for _, content in pairs(event.data) do
		self.globalData = content.globalInfo
	end
	_ENV = pairs(event.data)
	pairs(event.data).msg = "MESSAGE_ANNIV_COLOSSUS_REFRESH"
	SoraDSendMessage(pairs(event.data))
end
function annivColossusCtrl:activityInitRsp(target, data)
	if data.activityID == gActivityTimeActivityID.ANNIV_COLOSSUS_ACTIVITY then
		self:initClientData(data.initData)
		_ENV = self
		self.msg = "MESSAGE_ANNIV_COLOSSUS_REFRESH"
		SoraDSendMessage(self)
	end
end
function annivColossusCtrl:reqInit(...)
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	activityTaskComponentCtrl:sendReqInit()
end
function annivColossusCtrl:reqAnnivColossusBuild()
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANNIV_COLOSSUS_BUILD)
end
function annivColossusCtrl:reqAnnivColossusTakeReward(rank)
	serverproxy = nil
	;(nil).rank = rank
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANNIV_COLOSSUS_TAKE_REWARD, nil)
end
function annivColossusCtrl:reqAnnivColossusTotalScore()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANNIV_COLOSSUS_TOTAL_SCORE, nil)
end
function annivColossusCtrl:reqAnnivColossusBuildRsp(content)
	dump(content, "annivColossusCtrl:reqAnnivColossusBuild(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_ANNIV_COLOSSUS_BUILD"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = gActivityTimeActivityID.ANNIV_COLOSSUS_ACTIVITY
		SoraDSendMessage(self)
	end
end
function annivColossusCtrl:reqAnnivColossusTakeRewardRsp(content)
	dump(content, "annivColossusCtrl:reqAnnivColossusTakeRewardRsp(content)", 10)
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
		SoraDMailGainItems.msg = "MESSAGE_ANNIV_COLOSSUS_GET_REWARD"
		SoraDSendMessage(SoraDMailGainItems)
		_ENV = SoraDMailGainItems
		SoraDMailGainItems.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDMailGainItems.eventID = gActivityTimeActivityID.ANNIV_COLOSSUS_ACTIVITY
		SoraDSendMessage(SoraDMailGainItems)
	end
end
function annivColossusCtrl:reqAnnivColossusTotalScoreRsp(content)
	dump(content, "annivColossusCtrl:reqAnnivColossusTotalScoreRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
end
function annivColossusCtrl:getMyData()
	return self.myData
end
function annivColossusCtrl:getGlobalData()
	return self.globalData
end
function annivColossusCtrl:getMyScore()
	return self.myData and self.myData.score or 0
end
function annivColossusCtrl:getGlobalScore()
	return self.globalData and self.globalData.score or 0
end
function annivColossusCtrl:isRewardGot(rType, rank)
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
return annivColossusCtrl
