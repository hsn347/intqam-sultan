local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local allianceHuntCtrl = class("allianceHuntCtrl", gamemodulec)
function allianceHuntCtrl:reqChallenge(uid, heroid, multipleTimes)
	print("uid, heroid, multipleTimes====", uid, heroid, multipleTimes)
	_ENV = print
	print.target = uid
	print.heroID = heroid
	local print.multipleTimes, data = multipleTimes or 1, print
	serverproxy:Request(gCmd.CMD_ALLIANCE_HUNTING_MODULE, gCmd.REQ_ALLIANCE_HUNTING_CHALLEGE, data)
end
function allianceHuntCtrl:getCheckSum(hitInfo)
	local strHit = json.encode(hitInfo)
	if type(strHit) ~= "string" then
		return 0
	end
	local sum = 0
	for i = 1, string.len(strHit) do
		local num = string.byte(strHit, i)
		sum = sum + num
	end
	return sum
end
function allianceHuntCtrl:reqHit(hitInfo)
	print("allianceHuntCtrl:reqHit(hitInfo)")
	dump(hitInfo, "hitInfo")
	local data = hitInfo
	serverproxy:Request(gCmd.CMD_ALLIANCE_HUNTING_MODULE, gCmd.REQ_ALLIANCE_HUNTING_HIT, data, self:getCheckSum(data))
end
function allianceHuntCtrl:reqBuy(shopIndex, exchangeNum)
	_ENV = nil
	;(nil).shopIndex = shopIndex
	local (nil).exchangeNum, data = exchangeNum, nil
	dump(data, "allianceHuntCtrl:reqBuy(shopIndex, exchangeNum)")
	serverproxy:Request(gCmd.CMD_ALLIANCE_HUNTING_MODULE, gCmd.REQ_ALLIANCE_HUNTING_BUY, data)
end
function allianceHuntCtrl:reqQueryRank()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_ALLIANCE_HUNTING_MODULE, gCmd.REQ_ALLIANCE_HUNTING_QUERY_RANK, data)
end
function allianceHuntCtrl:reqExit()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_ALLIANCE_HUNTING_MODULE, gCmd.REQ_ALLIANCE_HUNTING_EXIT, data)
end
function allianceHuntCtrl:getHuntData()
	return self.huntData
end
function allianceHuntCtrl:getRankData()
	return self.rankData
end
function allianceHuntCtrl:getHuntingPoint()
	return self.huntData.huntingPoint or 0
end
function allianceHuntCtrl:getHuntingPointItemID()
	return gIDDef.ALLIANCE_HUNTING_POINT
end
function allianceHuntCtrl:getTodayHuntingPoint()
	return self.huntData.todayHuntingPoint
end
function allianceHuntCtrl:getShopData()
	return self.huntData.shopData
end
function allianceHuntCtrl:hasAnyExchange()
	local allianceHuntDesRead = include("allianceHuntDesRead")
	local exchangeList = allianceHuntDesRead.getExchangeList()
	local huntingPoint = self:getHuntingPoint()
	if huntingPoint <= 0 then
		return false
	end
	local shopData = self:getShopData()
	for i, v in ipairs(exchangeList) do
		local needNum = v.changeID[2]
		local cur = shopData[tostring(v.shopIndex)] or 0
		local total = v.limitNum
		if cur < total and huntingPoint >= needNum then
			return true
		end
	end
	return false
end
function allianceHuntCtrl:getGuideHistory()
	return self.huntData.guideHistory
end
function allianceHuntCtrl:getChanllengeTimes()
	if not self.huntData then
		return 0
	end
	return HUNTING_MAX_TIMES - self.huntData.challengeTimes
end
function allianceHuntCtrl:getCheckChanllengeTimes()
	if SoraDGetCastleLv() < ALLIANCE_HUNT_CASTLE_LV_MIN then
		return 0
	end
	if worldMapDefine.inInCrossWar() then
		return 0
	end
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local myalliance = allianceMgr:getAlliance()
	if not myalliance then
		return 0
	end
	return self:getChanllengeTimes()
end
function allianceHuntCtrl:ctor(properties)
	allianceHuntCtrl.super.ctor(self, properties)
	self:init()
end
function allianceHuntCtrl:Logout()
	allianceHuntCtrl.super.Logout(self)
	self:resetData()
end
function allianceHuntCtrl:resetData()
end
function allianceHuntCtrl:init()
	self:resetData()
end
function allianceHuntCtrl:EnterGame()
	allianceHuntCtrl.super.EnterGame(self)
	self:resetData()
	msgCtrl.register(gCmd.CMD_ALLIANCE_HUNTING_MODULE, gCmd.REQ_ALLIANCE_HUNTING_CHALLEGE, handler(self, self.reqChallengeRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_HUNTING_MODULE, gCmd.REQ_ALLIANCE_HUNTING_HIT, handler(self, self.reqHitRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_HUNTING_MODULE, gCmd.REQ_ALLIANCE_HUNTING_BUY, handler(self, self.reqBuyRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_HUNTING_MODULE, gCmd.REQ_ALLIANCE_HUNTING_QUERY_RANK, handler(self, self.reqQueryRankRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_HUNTING_MODULE, gCmd.REQ_ALLIANCE_HUNTING_EXIT, handler(self, self.reqExitRsp))
	self:registerNotify()
end
function allianceHuntCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ALLIANCE_HUNTING, handler(self, self.noitfyDataRsp))
end
function allianceHuntCtrl:initClientData(retdata)
	self.huntData = retdata
	if self.huntData and self.huntData.maxHuntingTimes then
		HUNTING_MAX_TIMES = self.huntData.maxHuntingTimes
	end
end
function allianceHuntCtrl:noitfyDataRsp(content)
	local notifydata = content.data
	dump(notifydata, "allianceHuntCtrl.noitfyDataRsp(content)@@@", 10)
	for i, notifyMsg in ipairs(notifydata) do
		local notifyType = notifyMsg.type
		local notifyData = notifyMsg.data
		local notifyFunc = "onNotify_" .. notifyType
		if not allianceHuntCtrl[notifyFunc] then
			print("allianceHuntCtrl:" .. notifyFunc .. " not implemented!")
		else
			allianceHuntCtrl[notifyFunc](self, notifyData)
		end
	end
end
function allianceHuntCtrl:onNotify_initData(notifyData)
	dump(notifyData, "onNotify_initData(notifyData)")
end
function allianceHuntCtrl:onNotify_huntingEnd(notifyData)
	dump(notifyData, "onNotify_huntingEnd(notifyData)")
	self.huntData.curRoundData = notifyData.newRoundData
	self.huntData.todayHuntingPoint = notifyData.todayHuntingPoint
	self.huntData.guideHistory = notifyData.guideHistory
	self.huntData.challengeTimes = notifyData.challengeTimes
	if notifyData.huntingPoint then
		self.huntData.huntingPoint = notifyData.huntingPoint
	end
	local bWin = notifyData.win
	local winPoint = notifyData.winPoint
	_ENV = nil
	;(nil).msg = "MESSAGE_ALLIANCE_HUNT_BATTLE_END"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_GREEN_POINT_UPDATE"
	;(nil).type = GREEN_POINT_NOTICE_TYPE.HUNT
	SoraDSendMessage(nil)
end
function allianceHuntCtrl:onNotify_refreshShop(notifyData)
	dump(notifyData, "onNotify_refreshShop(notifyData)")
	self.huntData.shopData = notifyData.shopData
	_ENV = notifyData.shopData
	notifyData.shopData.msg = "MESSAGE_ALLIANCE_HUNT_BUY_SUCCESS"
	SoraDSendMessage(notifyData.shopData)
end
function allianceHuntCtrl:onNotify_dailyRefresh(notifyData)
	dump(notifyData, "onNotify_dailyRefresh(notifyData)")
	if notifyData.challengeTimes then
		self.huntData.challengeTimes = notifyData.challengeTimes
	end
	if notifyData.guideHistory then
		self.huntData.guideHistory = notifyData.guideHistory
	end
	if notifyData.todayHuntingPoint then
		self.huntData.todayHuntingPoint = notifyData.todayHuntingPoint
	end
	_ENV = notifyData.todayHuntingPoint
	notifyData.todayHuntingPoint.msg = "MESSAGE_ALLIANCE_HUNT_DAILY_REFRESH"
	SoraDSendMessage(notifyData.todayHuntingPoint)
	_ENV = notifyData.todayHuntingPoint
	notifyData.todayHuntingPoint.msg = "MESSAGE_ALLIANCE_HUNT_BUY_SUCCESS"
	SoraDSendMessage(notifyData.todayHuntingPoint)
	_ENV = notifyData.todayHuntingPoint
	notifyData.todayHuntingPoint.msg = "MESSAGE_GREEN_POINT_UPDATE"
	notifyData.todayHuntingPoint.type = GREEN_POINT_NOTICE_TYPE.HUNT
	SoraDSendMessage(notifyData.todayHuntingPoint)
end
function allianceHuntCtrl:onNotify_huntingPoint(notifyData)
	if notifyData.huntingPoint then
		self.huntData.huntingPoint = notifyData.huntingPoint
		_ENV = notifyData.huntingPoint
		notifyData.huntingPoint.msg = "MESSAGE_ALLIANCE_HUNT_DAILY_REFRESH"
		SoraDSendMessage(notifyData.huntingPoint)
		_ENV = notifyData.huntingPoint
		notifyData.huntingPoint.msg = "MESSAGE_ALLIANCE_HUNT_BUY_SUCCESS"
		SoraDSendMessage(notifyData.huntingPoint)
		_ENV = notifyData.huntingPoint
		notifyData.huntingPoint.msg = "MESSAGE_GREEN_POINT_UPDATE"
		notifyData.huntingPoint.type = GREEN_POINT_NOTICE_TYPE.HUNT
		SoraDSendMessage(notifyData.huntingPoint)
	end
end
function allianceHuntCtrl:reqChallengeRsp(content)
	dump(content, "allianceHuntCtrl:reqChallengeRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.huntData.curRoundData = content.rspdata.roundData
		self.huntData.generateSet = content.rspdata.generateSet
		_ENV = content.rspdata.generateSet
		content.rspdata.generateSet.msg = "MESSAGE_ALLIANCE_HUNT_CHALLENGE_SUCCESS"
		content.rspdata.generateSet.multipleTimes = content.data.multipleTimes
		SoraDSendMessage(content.rspdata.generateSet)
	else
		_ENV = content.rspdata.generateSet
		content.rspdata.generateSet.msg = "MESSAGE_ALLIANCE_HUNT_CHALLENGE_FAILED"
		SoraDSendMessage(content.rspdata.generateSet)
	end
end
function allianceHuntCtrl:getAwardPoint()
	if self.huntData.curRoundData and self.huntData.curRoundData.targetInfo then
		return self.huntData.curRoundData.targetInfo.awardPoint or 0
	end
	return 0
end
function allianceHuntCtrl:reqHitRsp(content)
	dump(content, "allianceHuntCtrl:reqHitRsp(content)")
end
function allianceHuntCtrl:reqBuyRsp(content)
	dump(content, "allianceHuntCtrl:reqBuyRsp(content) ", 10)
	if content.err == gErrDef.Err_None then
		self.huntData.shopData = content.rspdata.shopData
		if content.rspdata.huntingPoint then
			self.huntingPoint = content.rspdata.huntingPoint
		end
		_ENV = content.rspdata.shopData
		content.rspdata.shopData.msg = "MESSAGE_ALLIANCE_HUNT_BUY_SUCCESS"
		SoraDSendMessage(content.rspdata.shopData)
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ALLIANCE_HUNT_UPDATE_EXCHANGE_POINT"
		SoraDSendMessage(content.rspdata.reward)
	else
		self.rankData, _ENV = SoraDSendMessage, SoraDSendMessage
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ALLIANCE_HUNT_BUY_FAILED"
		SoraDSendMessage(content.rspdata.reward)
	end
end
function allianceHuntCtrl:reqQueryRankRsp(content)
	dump(content, "allianceHuntCtrl:reqQueryRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.rankData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ALLIANCE_HUNT_RANK_DATA_SUCCESS"
		gErrDef.Err_None.data = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	else
		self.rankData, _ENV = SoraDSendMessage, SoraDSendMessage
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ALLIANCE_HUNT_RANK_DATA_FAILED"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function allianceHuntCtrl:reqExitRsp(content)
	dump(content, "allianceHuntCtrl:reqExitRsp(content)", 10)
	self.huntData.guideHistory = content.rspdata.guideHistory
	self.huntData.todayHuntingPoint = content.rspdata.todayHuntingPoint
	if content.rspdata.challengeTimes then
		self.huntData.challengeTimes = content.rspdata.challengeTimes
	end
	if content.rspdata.huntingPoint then
		self.huntData.huntingPoint = content.rspdata.huntingPoint
	end
	_ENV = content.rspdata.huntingPoint
	content.rspdata.huntingPoint.msg = "MESSAGE_ALLIANCE_HUNT_BATTLE_END"
	content.rspdata.huntingPoint.data = content.rspdata
	content.rspdata.huntingPoint.retData = content.retData
	SoraDSendMessage(content.rspdata.huntingPoint)
	_ENV = content.rspdata.huntingPoint
	content.rspdata.huntingPoint.msg = "MESSAGE_GREEN_POINT_UPDATE"
	content.rspdata.huntingPoint.type = GREEN_POINT_NOTICE_TYPE.HUNT
	SoraDSendMessage(content.rspdata.huntingPoint)
end
return allianceHuntCtrl
