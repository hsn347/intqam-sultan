local gamemodulec = include("GameModule")
local conquestWarCtrl = class("conquestWarCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local timerList = gModuleMgr.getObject("timerList")
function conquestWarCtrl:ctor(properties)
	conquestWarCtrl.super.ctor(self, properties)
	self:resetData()
end
function conquestWarCtrl:resetData()
	self.matchKid = 0
	self.queue, _ENV, self.conquestWarState = gConquestWarState.LOCK, gConquestWarState.LOCK, gConquestWarState.LOCK
	self.matchKingdomList, _ENV, self.matchKingdomInfo, _ENV, self.persionalScore = gConquestWarState.LOCK, gConquestWarState.LOCK, gConquestWarState.LOCK, gConquestWarState.LOCK, 0
	self.matchPool = 1
	self.matchStrength = 0
	self.strength = 0
	self.totalCanInviteStrength = 0
	self.canReinforceInfo, _ENV, self.canReinforceKids, _ENV, self.mathcReinforcementsKids, _ENV, self.reinforcementsKids, _ENV, self.reinforcements, _ENV, self.maxCanInviteStrength = gConquestWarState.LOCK, gConquestWarState.LOCK, gConquestWarState.LOCK, gConquestWarState.LOCK, gConquestWarState.LOCK, gConquestWarState.LOCK, gConquestWarState.LOCK, gConquestWarState.LOCK, gConquestWarState.LOCK, gConquestWarState.LOCK, 0
	self.toBeReinforcementsNew = false
	self.toBeReinforcHost = false
	self.selfCastleInRuled = false
	self.matchCastleInRuled = false
	self.isKingdomRecovered = false
	self.kingdomRecoverScore = 0
end
function conquestWarCtrl:EnterGame()
	self:addEventListener(tostring(gConquestWarState.LOCK), handler(self, self.lockStateCallBack))
	self:addEventListener(tostring(gConquestWarState.WAITING), handler(self, self.waitingStateCallBack))
	self:addEventListener(tostring(gConquestWarState.NOT_MATCH), handler(self, self.notMatchStateCallBack))
	self:addEventListener(tostring(gConquestWarState.PREPARE), handler(self, self.prepareStateCallBack))
	self:addEventListener(tostring(gConquestWarState.OPENING), handler(self, self.openingStateCallBack))
	self:addEventListener(tostring(CONQUESTWAR_WIN_BUFF_TIMEQUEUE_KEY), handler(self, self.conquestWarWinBuffCallBack))
	self:addEventListener(tostring(CONQUESTWAR_REINFORCE_QUEUE_KEY), handler(self, self.timeEndCallBack))
	self:addEventListener(tostring(CONQUESTWAR_TO_BE_REINFORCE_QUEUE_KEY), handler(self, self.timeEndCallBack))
	msgCtrl.register(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_INFO, handler(self, self.getConquestWarInfoRsp))
	msgCtrl.register(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_RANK, handler(self, self.getConquestWarRankRsp))
	msgCtrl.register(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_BATTLE_RESULT, handler(self, self.getConquestWarBattleResultRsp))
	msgCtrl.register(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_STAGE_INFO, handler(self, self.getStageInfoRsp))
	msgCtrl.register(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_PLAYER_RANK_IN_ALLIANCE, handler(self, self.getPlayerRankInAllianceRsp))
	msgCtrl.register(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_HONOR_RANK, handler(self, self.getHonorRankRsp))
	msgCtrl.register(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_REPORT_OTHER, handler(self, self.reportOtherRsp))
	msgCtrl.register(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_SEARCH_PLAYER, handler(self, self.searchPlayerRsp))
	msgCtrl.register(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_KID_BATTLE_RESULT, handler(self, self.reqKidBattleResultRsp))
	msgCtrl.register(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_REINFORCEMENTS_INVITE, handler(self, self.reqReinforcementsInviteRsp))
	msgCtrl.register(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_REINFORCEMENTS_CANCEL, handler(self, self.reqReinforcementsCancleRsp))
	msgCtrl.register(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_GET_REINFORCEMENTS, handler(self, self.reqReinforcementsInfoRsp))
	msgCtrl.register(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_AGREED_REINFORCEMENTS, handler(self, self.reqAgreeReinforcementsInfoRsp))
	msgCtrl.register(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_REINFORCEMENTS_CHOOSE, handler(self, self.reqReinforcementsChooseRsp))
	msgCtrl.register(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_MATCH_LIST, handler(self, self.reqMatchListRsp))
	msgCtrl.register(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_BATTLE_INFO, handler(self, self.reqBattleInfoRsp))
end
function conquestWarCtrl:lockStateCallBack(event)
	print("conquestWarCtrl:lockStateCallBack")
end
function conquestWarCtrl:waitingStateCallBack(event)
	print("conquestWarCtrl:waitingStateCallBack")
end
function conquestWarCtrl:notMatchStateCallBack(event)
	print("conquestWarCtrl:notMatchStateCallBack")
end
function conquestWarCtrl:prepareStateCallBack(event)
	print("conquestWarCtrl:prepareStateCallBack")
end
function conquestWarCtrl:openingStateCallBack(event)
	print("conquestWarCtrl:openingStateCallBack")
end
function conquestWarCtrl:conquestWarWinBuffCallBack(event)
	print("conquestWarCtrl:conquestWarWinBuffCallBack")
	_ENV = nil
	;(nil).name = gEventName.event_conquestwar_win_buff_update
	self:dispatchEvent(nil)
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_CITYBUFF_DISAPPEAR"
	SoraDSendMessage(self)
end
function conquestWarCtrl:Logout()
	conquestWarCtrl.super.Logout(self)
	self:resetData()
end
function conquestWarCtrl:getConquestWarState()
	return self.conquestWarState
end
function conquestWarCtrl:getLeftTime()
	local ret = 0
	local queue = self:queryQueue(self.conquestWarState)
	if queue then
		ret = queue.timerNode.timer:getRemainTime()
	end
	return ret
end
function conquestWarCtrl:addQueue(queuetype, starttime, totaltime, lefttime, data)
	local queuetype = tostring(queuetype)
	local curqueue = self:queryQueue(queuetype)
	if curqueue then
		self:removeQueue(queuetype)
	end
	local dispatchQueueEvent = function()
		queuetype = nil
		;(nil).name = queuetype
		local (nil).data, event = data, nil
		self:dispatchEvent(event)
		self.queue[queuetype] = nil
	end
	local _ENV, queue = self, self
	queue.starttime = starttime
	queue.totaltime = totaltime
	local ok, node = timerList:createTimer(lefttime, timerHandler(dispatchQueueEvent))
	if ok then
		node.timer:resetStartTime(starttime)
		queue.timerNode = node
		self.queue[queuetype] = queue
	end
end
function conquestWarCtrl:removeQueue(queuetype)
	local queuetype = tostring(queuetype)
	local queue = self:queryQueue(queuetype)
	if queue then
		timerList:cancelTimer(queue.timerNode)
		self.queue[queuetype] = nil
	end
end
function conquestWarCtrl:queryQueue(queuetype)
	local ret = self.queue[tostring(queuetype)]
	if ret then
		return ret
	end
end
function conquestWarCtrl:isMatchKingdom(kid1, kid2)
	local ret = false
	local matchkid = self.matchKingdomList[tostring(kid1)]
	if matchkid and matchkid == kid2 then
		ret = true
	end
	return ret
end
function conquestWarCtrl:isPlayerMoveToEnemyKingdom(targetKid)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	if self:getConquestWarState() == gConquestWarState.OPENING then
		local sourceKid = lordInfoCtrl:getSourceKid()
		local matchKid = self.matchKid
		if sourceKid == 0 and matchKid == targetKid then
			return true
		end
	end
	if self:isPlayerMoveToReinforceMatchKingdom(targetKid) then
		return true
	end
	return false
end
function conquestWarCtrl:isPlayerMoveToReinforceMatchKingdom(targetKid)
	local agreeKindom, matchKid = SoraDGetCtrl("conquestWarReinforcementsCtrl"):getAgreeKindom()
	if targetKid == matchKid and self:getReinforceEndTime() <= 0 then
		return true
	end
	return false
end
function conquestWarCtrl:isPlayerMoveToReinforceKingdom(targetKid)
	local agreeKindom, matchKid = SoraDGetCtrl("conquestWarReinforcementsCtrl"):getAgreeKindom()
	if agreeKindom == targetKid and self:getReinforceEndTime() <= 0 then
		return true
	end
end
function conquestWarCtrl:isPlayerReturnSourceKingdom(targetKid)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	if self:getConquestWarState() == gConquestWarState.OPENING then
		local sourceKid = lordInfoCtrl:getSourceKid()
		if targetKid == sourceKid then
			return true
		end
	end
	return false
end
function conquestWarCtrl:isPlayerConquestWarMigration()
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local sourceKid = lordInfoCtrl:getSourceKid()
	if sourceKid and 0 < sourceKid then
		return true
	else
		return false
	end
end
function conquestWarCtrl:getMatchKingdomList()
	return self.matchKingdomList
end
function conquestWarCtrl:isConquestWarOpenning(...)
	return self.conquestWarState and gConquestWarState.OPENING == self.conquestWarState
end
function conquestWarCtrl:isConquestWarOpenningAndNotInWar()
	if self.conquestWarState and gConquestWarState.OPENING == self.conquestWarState then
		return not worldMapDefine.isInWar()
	end
	return false
end
function conquestWarCtrl:tipConquestWarVictory(mailid)
	print("conquestWarCtrl:tipConquestWarVictory mailid", mailid)
	_ENV = "conquestWarCtrl:tipConquestWarVictory mailid"
	;("conquestWarCtrl:tipConquestWarVictory mailid").msg = "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_VICTORY"
	;("conquestWarCtrl:tipConquestWarVictory mailid").mid = mailid
	SoraDSendMessage("conquestWarCtrl:tipConquestWarVictory mailid")
end
function conquestWarCtrl:isConquestWarWinBuffActive()
	if self.conquestWarState == gConquestWarState.WAITING and self.lastWin and self:queryQueue(CONQUESTWAR_WIN_BUFF_TIMEQUEUE_KEY) then
		return true
	end
	return false
end
function conquestWarCtrl:getConquestWarWinBuffLefttime()
	local ret = 0
	if self.conquestWarState == gConquestWarState.WAITING and self.lastWin then
		local queue = self:queryQueue(CONQUESTWAR_WIN_BUFF_TIMEQUEUE_KEY)
		if queue then
			ret = queue.timerNode.timer:getRemainTime()
		end
	end
	return ret
end
function conquestWarCtrl:getConquestWarWinBuffList(effectType)
	local conquestWarltCtrl = include("conquestWarltCtrl")
	_ENV = "conquestWarltCtrl"
	;("conquestWarltCtrl").bufflist, _ENV, ("conquestWarltCtrl").totalEffect = nil, nil, 0
	local ret = "conquestWarltCtrl"
	local isActive = self:isConquestWarWinBuffActive()
	local buffinfo = conquestWarltCtrl.getConquestWarWinBuffInfo(effectType)
	if isActive and buffinfo then
		ret.totalEffect = conquestWarltCtrl.getConquestWarWinBuffValue(effectType)
		local starttime = serviceFunctions.systemTime()
		local buffqueue = self:queryQueue(CONQUESTWAR_WIN_BUFF_TIMEQUEUE_KEY)
		if buffqueue then
			starttime = buffqueue.starttime
		end
		_ENV = self
		self.effect = buffinfo.effect[2] or 0
		self.effectType = buffinfo.effectType
		self.source = gBuffSource.CONQUESTWAR
		self.beginTime = starttime
		self.time = buffinfo.time
		local self.id, temp = 0, self
		table.insert(ret.bufflist, temp)
	end
	return ret
end
function conquestWarCtrl:getConquestWarInfoReq(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_INFO, nil, ...)
end
function conquestWarCtrl:getConquestWarInfoRsp(content)
	dump(content, "getConquestWarInfoRsp")
	local err = content.err
	if err == gErrDef.Err_None then
		local retdata = content.data.retdata
		self:setConquestWarData(retdata)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_REFRESH"
		SoraDSendMessage(self)
	else
		print("conquestWarCtrl:getConquestWarInfoRsp err=", err)
	end
end
function conquestWarCtrl:getConquestWarRankReq(kid)
	serverproxy = nil
	;(nil).kid = kid
	serverproxy:Request(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_RANK, nil)
end
function conquestWarCtrl:getConquestWarRankRsp(content)
	dump(content, "getConquestWarRankRsp====", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		local retdata = content.data.retdata
		_ENV = 10
		;(10).msg = "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_RANKDATA"
		;(10).data = retdata
		SoraDSendMessage(10)
	else
		print("conquestWarCtrl:getConquestWarRankRsp err=", err)
	end
end
function conquestWarCtrl:reqGetConquestWarBattleResult(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_BATTLE_RESULT, nil, ...)
end
function conquestWarCtrl:getConquestWarBattleResultRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local retdata = content.data.retdata
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_HISTORY"
		;(nil).data = retdata
		SoraDSendMessage(nil)
	end
end
function conquestWarCtrl:getHonorRankReq(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_HONOR_RANK, nil, ...)
end
function conquestWarCtrl:getHonorRankRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local retdata = content.data.retdata
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_HONOURDATA"
		;(nil).data = retdata
		SoraDSendMessage(nil)
	end
end
function conquestWarCtrl:reqReport(uid)
	print("conquestWarCtrl:reqReport", uid)
	local _ENV, data = print, print
	data.tarUid = uid
	serverproxy:Request(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_REPORT_OTHER, data)
end
function conquestWarCtrl:reqSearch(nickName, pid)
	print("conquestWarCtrl:reqSearch", nickName, pid)
	local _ENV, data = print, print
	data.nickName = nickName
	data.pid = pid
	serverproxy:Request(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_SEARCH_PLAYER, data)
end
function conquestWarCtrl:reportOtherRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		if content.data and content.data.retdata then
			self.reportData = content.data.retdata
		end
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_CONQUESTWAR_REPORTBACK"
		;(nil).data = self.reportData
		SoraDSendMessage(nil)
	else
	end
end
function conquestWarCtrl:searchPlayerRsp(content)
	local _ENV, searchResult
	local err = content.err
	if err == gErrDef.Err_None then
		if content.data and content.data.retdata then
			searchResult = content.data.retdata
		end
		table.sort(searchResult, function(s1, s2)
			if s1.diffScore < s2.diffScore then
				return true
			else
				return false
			end
		end)
		_ENV = searchResult
		searchResult.msg = "MESSAGE_WORLD_MAP_CONQUESTWAR_REPORTLIST"
		searchResult.data = searchResult
		SoraDSendMessage(searchResult)
	else
	end
end
function conquestWarCtrl:reqGetConquestWarStageInfo(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_STAGE_INFO, nil, ...)
end
function conquestWarCtrl:getStageInfoRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local retdata = content.data.retdata
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_STAGE"
		;(nil).data = retdata
		SoraDSendMessage(nil)
	end
end
function conquestWarCtrl:reqGetRankInAlliance(startIndex)
	local serverproxy, data
	data.startIndex = startIndex
	serverproxy:Request(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_PLAYER_RANK_IN_ALLIANCE, data)
end
function conquestWarCtrl:getPlayerRankInAllianceRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local retdata = content.data.retdata
		local _ENV, myInfo
		if tonumber(content.data.startIndex) == 1 then
			self.rankInAlliance, _ENV = tonumber(content.data.startIndex), tonumber(content.data.startIndex)
			myInfo = retdata.myInfo
		end
		if not self.rankInAlliance then
			self.rankInAlliance, _ENV = self.rankInAlliance, self.rankInAlliance
		end
		if type(retdata.rankData) == "table" then
			for index, value in pairs(retdata.rankData) do
				self.rankInAlliance[tonumber(value.rank)] = value
			end
		end
		local newStartIndex = retdata.newStartIndex
		local bCanContinueGet = retdata.bCanContinueGet
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_ALLIANCE_RANKDATA"
		;(nil).myInfo = myInfo
		;(nil).rankList = self.rankInAlliance
		;(nil).idx = newStartIndex
		;(nil).wget = bCanContinueGet
		SoraDSendMessage(nil)
	end
end
function conquestWarCtrl:getMatchPool()
	return self.matchPool
end
function conquestWarCtrl:reqKidBattleResult(kid)
	serverproxy = nil
	;(nil).kid = tonumber(kid)
	serverproxy:Request(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_KID_BATTLE_RESULT, nil)
end
function conquestWarCtrl:reqKidBattleResultRsp(content)
	if not content.data or not content.data.retdata then
		local _ENV, retdata = content.data.retdata, content.data.retdata
	end
	_ENV = nil
	;(nil).msg = "MESSAGE_KINGDOMBATTLE_HONOURBOARD_RESULT"
	;(nil).err = content.err
	;(nil).data = retdata
	SoraDSendMessage(nil)
end
function conquestWarCtrl:reqReinforcementsInvite(uid)
	serverproxy = nil
	;(nil).uid = tonumber(uid)
	serverproxy:Request(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_REINFORCEMENTS_INVITE, nil)
end
function conquestWarCtrl:reqReinforcementsInviteRsp(content)
	dump(content, "conquestWarCtrl:reqReinforcementsInviteRsp", 10)
	if content.err == gErrDef.Err_None then
		self.reinforcements = content.data.retdata.reinforcements
		SoraDShowMsgTip(i18n("notice_0092"))
		_ENV = i18n("notice_0092")
		i18n("notice_0092").msg = "MESSAGE_CONQUESTWAR_REINFORCEMENTS"
		i18n("notice_0092").subMsg = "reinforcementsUpdate"
		i18n("notice_0092").uid = content.data.uid
		SoraDSendMessage(i18n("notice_0092"))
	elseif content.err == gErrDef.Err_CONQUESTWAR_MAX_STRENGTH then
		SoraDShowMsgTip(i18n("conquestwar_text_41"))
	elseif content.err == gErrDef.Err_CONQUESTWAR_MAX_MATCH_USER_STRENGTH then
		SoraDShowMsgTip(i18n("conquestwar_text_40"))
	elseif content.err == gErrDef.Err_CONQUESTWAR_AGREE_NUM_LIMIT then
		_ENV = i18n("conquestwar_text_40")
		i18n("conquestwar_text_40").num = include("constantRead").getConstValue("CONQUESTWAR_REINFORCEMENT_AGREE", 10)
		SoraDShowMsgTip(i18n("conquestwar_text_38", i18n("conquestwar_text_40")))
	end
end
function conquestWarCtrl:reqReinforcementsCancle(uid)
	serverproxy = nil
	;(nil).uid = tonumber(uid)
	serverproxy:Request(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_REINFORCEMENTS_CANCEL, nil)
end
function conquestWarCtrl:reqReinforcementsCancleRsp(content)
	dump(content, "conquestWarCtrl:reqReinforcementsCancleRsp", 10)
	if content.err == gErrDef.Err_None then
		self.reinforcements = content.data.retdata.reinforcements
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_CONQUESTWAR_REINFORCEMENTS"
		gErrDef.Err_None.subMsg = "reinforcementsUpdate"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function conquestWarCtrl:reqReinforcementsInfo()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_GET_REINFORCEMENTS, nil)
end
function conquestWarCtrl:reqReinforcementsInfoRsp(content)
	dump(content, "conquestWarCtrl:reqReinforcementsInfoRsp", 10)
	if content.err == gErrDef.Err_None then
		self.matchStrength = content.data.retdata.matchStrength
		self.reinforcements = content.data.retdata.reinforcements
		self.strength = content.data.retdata.strength
		self.totalCanInviteStrength = content.data.retdata.totalCanInviteStrength
		self.maxCanInviteStrength = content.data.retdata.maxCanInviteStrength
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_CONQUESTWAR_REINFORCEMENTS"
		gErrDef.Err_None.subMsg = "reinforcementsInit"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function conquestWarCtrl:reqAgreeReinforcementsInfo()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_AGREED_REINFORCEMENTS, nil)
end
function conquestWarCtrl:reqAgreeReinforcementsInfoRsp(content)
	dump(content, "conquestWarCtrl:reqAgreeReinforcementsInfoRsp", 10)
	if content.err == gErrDef.Err_None then
		self.matchStrength = content.data.retdata.matchStrength
		self.strength = content.data.retdata.strength
		self.totalCanInviteStrength = content.data.retdata.totalCanInviteStrength
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_CONQUESTWAR_REINFORCEMENTS"
		gErrDef.Err_None.subMsg = "reinforcementsList"
		gErrDef.Err_None.rspdata = content.data.retdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function conquestWarCtrl:reqReinforcementsChoose(data)
	serverproxy:Request(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_REINFORCEMENTS_CHOOSE, data)
end
function conquestWarCtrl:reqReinforcementsChooseRsp(content)
	dump(content, "conquestWarCtrl:reqReinforcementsChooseRsp", 10)
	if content.err == gErrDef.Err_None then
		local retdata = content.data.retdata
		self:setConquestWarData(retdata)
		if content.data.isOpen then
			SoraDShowMsgTip(i18n("atlantiswar_text_0423"))
		else
			SoraDShowMsgTip(i18n("atlantiswar_text_0424"))
		end
	else
		_ENV = SoraDShowMsgTip
		SoraDShowMsgTip.msg = "MESSAGE_CONQUESTWAR_REINFORCEMENTS"
		SoraDShowMsgTip.subMsg = "ReinforcementsChoose"
		SoraDShowMsgTip.isSuccess = false
		SoraDSendMessage(SoraDShowMsgTip)
	end
end
function conquestWarCtrl:reqMatchList()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_MATCH_LIST, nil)
end
function conquestWarCtrl:reqMatchListRsp(content)
	dump(content, "conquestWarCtrl:reqMatchListRsp", 10)
	if content.err == gErrDef.Err_None then
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_CONQUESTWAR_MATCHLIST"
	if not content.data.retdata then
		_ENV = content.data.retdata
	end
	gErrDef.Err_None.list = content.data.retdata
	SoraDSendMessage(gErrDef.Err_None)
end
function conquestWarCtrl:reqBattleInfo(kid)
	serverproxy = nil
	;(nil).kid = kid
	serverproxy:Request(gCmd.CMD_CONQUESTWAR, gCmd.REQ_GET_CONQUESTWAR_BATTLE_INFO, nil)
end
function conquestWarCtrl:reqBattleInfoRsp(content)
	dump(content, "conquestWarCtrl:reqBattleInfoRsp", 10)
	if content.err == gErrDef.Err_None then
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_CONQUESTWAR_BATTLEINFO"
	if not content.data.retdata then
		_ENV = content.data.retdata
	end
	gErrDef.Err_None.data = content.data.retdata
	SoraDSendMessage(gErrDef.Err_None)
end
function conquestWarCtrl:initClientData(data)
	self:setConquestWarData(data)
	self:registerNotify()
end
function conquestWarCtrl:setConquestWarData(data)
	dump(data, "conquestWarCtrl:setConquestWarData", 10)
	if self.conquestWarState == gConquestWarState.OPENING and data.conquestWarState == gConquestWarState.WAITING then
		local resurrectionCtrl = gametop.playertop_:getModule("resurrectionCtrl")
		resurrectionCtrl:getResurrectionData()
	end
	if not data.matchKingdomList then
		_ENV = data.matchKingdomList
	end
	self.matchKingdomList = data.matchKingdomList
	self.matchKid = data.matchKid
	self.conquestWarState = data.conquestWarState
	self.matchPool = data.matchPool or 1
	self.matchKingdomInfo = data.matchKingdomInfo
	self.persionalScore = data.persionalScore
	self.lastWin = data.lastWin or false
	self.reinforcementsKids = data.reinforcementsKids
	self.mathcReinforcementsKids = data.mathcReinforcementsKids
	if not data.canReinforceKids then
		_ENV = data.canReinforceKids
	end
	self.canReinforceKids = data.canReinforceKids
	self.canReinforceInfo = data.canReinforceInfo
	self.strength = data.strength
	self.matchStrength = data.matchStrength
	self.toBeReinforcementsNew = data.toBeReinforcementsNew or false
	self.toBeReinforcHost = data.toBeReinforcHost or false
	self.selfCastleInRuled = data.selfCastleInRuled or false
	self.matchCastleInRuled = data.matchCastleInRuled or false
	self.isKingdomRecovered = data.isKingdomRecovered or false
	self.kingdomRecoverScore = data.kingdomRecoverScore or 0
	if data.reportData then
		self.reportData = data.reportData
	end
	local queue = data.queue
	for k, v in pairs(queue) do
		local queuetype = tostring(k)
		local starttime = v.starttime
		local totaltime = v.totaltime
		self:addQueue(queuetype, starttime, totaltime, totaltime)
	end
end
function conquestWarCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.CONQUESTWAR, handler(self, self.updateData))
end
function conquestWarCtrl:updateData(event)
	local data = event.data
	for k, v in pairs(data) do
		local clientdata = v.clientdata
		if clientdata then
			self:setConquestWarData(clientdata)
		end
		local battleresult = v.battleresult
		if battleresult then
			local result = battleresult.result
			local mid = battleresult.mid
			if result == gConquestWarResult.WIN then
				self:tipConquestWarVictory(mid)
			end
		end
	end
	_ENV = pairs(data)
	pairs(data).msg = "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_REFRESH"
	SoraDSendMessage(pairs(data))
	_ENV = pairs(data)
	pairs(data).msg = "MESSAGE_WORLD_MAP_CONQUESTWAR_FRESH"
	SoraDSendMessage(pairs(data))
	_ENV = pairs(data)
	pairs(data).name = gEventName.event_conquestwar_win_buff_update
	self:dispatchEvent(pairs(data))
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_CITYBUFF_ADD"
	SoraDSendMessage(self)
end
function conquestWarCtrl:getPersionalScore(...)
	return self.persionalScore
end
function conquestWarCtrl:getKingdomScore(...)
	local sKid = tostring(SoraDGetCtrl("lordInfoCtrl"):getMapSourceKid())
	return self.matchKingdomInfo[sKid] and self.matchKingdomInfo[sKid].kingdomScore or 0
end
function conquestWarCtrl:isInMatchKingdom(kid)
	return self.matchKingdomInfo[tostring(kid)] and true or false
end
function conquestWarCtrl:getMatchKid(...)
	return self.matchKid
end
function conquestWarCtrl:getReportLeftTimes(...)
	return self.reportData and self.reportData.leftTimes or 0
end
function conquestWarCtrl:isTriggerReinforcements()
	if self.reinforcementsKids and next(self.reinforcementsKids) then
		return true
	end
	return false
end
function conquestWarCtrl:isMatchTriggerReinforcements()
	if self.mathcReinforcementsKids and next(self.mathcReinforcementsKids) then
		return true
	end
	return false
end
function conquestWarCtrl:isDoubleReward()
	if SoraDGetCtrl("lordInfoCtrl"):getSourceKid() > 0 then
		local agreeKindom, matchKid = SoraDGetCtrl("conquestWarReinforcementsCtrl"):getAgreeKindom()
		if agreeKindom then
			return false
		end
		return self:isTriggerReinforcements()
	else
		return self:isMatchTriggerReinforcements()
	end
end
function conquestWarCtrl:isCanReinforce()
	if self.canReinforceKids and next(self.canReinforceKids) then
		return true
	end
	return false
end
function conquestWarCtrl:getMatchStrength()
	return self.matchStrength
end
function conquestWarCtrl:getMyStrength()
	return self.strength
end
function conquestWarCtrl:getMaxStrength()
	return self.maxCanInviteStrength
end
function conquestWarCtrl:getStrengthDiff()
	return self.totalCanInviteStrength
end
function conquestWarCtrl:getReinforcements()
	local _ENV, ret
	if not self.reinforcements then
		_ENV = self.reinforcements
	end
	for i, v in pairs(self.reinforcements) do
		if v.state ~= gConquestWarReinforcementsState.CANCEL then
			table.insert(ret, v)
		end
	end
	table.sort(ret, function(l, r)
		if l.state ~= r.state then
			return l.state < r.state
		elseif l.strength ~= r.strength then
			return l.strength > r.strength
		elseif l.lastInvitetime ~= r.lastInvitetime then
			return l.lastInvitetime > r.lastInvitetime
		else
			return l.uid < r.uid
		end
	end)
	return ret
end
function conquestWarCtrl:getAgreePowerAndNum()
	local power, num = 0, 0
	if not self.reinforcements then
		_ENV = self.reinforcements
	end
	for i, v in pairs(self.reinforcements) do
		if v.state == gConquestWarReinforcementsState.AGREE then
			power = power + v.strength
			num = num + 1
		end
	end
	return power, num
end
function conquestWarCtrl:getReinforceByUid(uid)
	if self.reinforcements[tostring(uid)] then
		return self.reinforcements[tostring(uid)]
	end
	return nil
end
function conquestWarCtrl:getNumString(num)
	if num / 10000000000000 >= 1 then
		return SoraDConvertNumberWithUnit(num, true, 0)
	end
	return string.formatnumberthousands(num)
end
function conquestWarCtrl:getReinforceEndTime(offsetTimes)
	offsetTimes = offsetTimes or 0
	if self.conquestWarState == gConquestWarState.NOT_MATCH then
		local kingdomID = self.canReinforceKids[1]
		local info = self.canReinforceInfo and self.canReinforceInfo[tostring(kingdomID)]
		if info and info.queue and info.queue["4"] then
			local timeData = info.queue["4"]
			return math.max(0, timeData.starttime + timeData.totaltime - offsetTimes - serviceFunctions.systemTime())
		end
	elseif self.conquestWarState == gConquestWarState.PREPARE then
		return math.max(0, self:getLeftTime() - offsetTimes)
	end
	return 0
end
function conquestWarCtrl:getSettingReinforceLefttime()
	local ret = 0
	local queue = self:queryQueue(CONQUESTWAR_TO_BE_REINFORCE_QUEUE_KEY)
	if queue then
		ret = queue.timerNode.timer:getRemainTime()
	end
	return ret
end
function conquestWarCtrl:getReinforceShowLefttime()
	local ret = 0
	local queue = self:queryQueue(CONQUESTWAR_REINFORCE_QUEUE_KEY)
	if queue then
		ret = queue.timerNode.timer:getRemainTime()
	end
	return ret
end
function conquestWarCtrl:getSettingWaitingLefttime()
	local ret = 0
	if self.conquestWarState == gConquestWarState.WAITING then
		ret = math.max(0, self:getLeftTime() - CONQUESTWAR_REINFORCE_WAITING_SETTING_TIME)
	end
	return ret
end
function conquestWarCtrl:isHelperInReinforceKingdom()
	local agreeKindom, matchKid = SoraDGetCtrl("conquestWarReinforcementsCtrl"):getAgreeKindom()
	if agreeKindom == gametop.playertop_:getKingdomID() then
		return true
	end
	return false
end
function conquestWarCtrl:isHelperInReinforceMatchKingdom()
	local agreeKindom, matchKid = SoraDGetCtrl("conquestWarReinforcementsCtrl"):getAgreeKindom()
	if matchKid == gametop.playertop_:getKingdomID() then
		return true
	end
	return false
end
function conquestWarCtrl:isHelper()
	return self:isHelperInReinforceKingdom() or self:isHelperInReinforceMatchKingdom()
end
function conquestWarCtrl:isFromReinforceKingdom(kid)
	local info = self.reinforcementsKids
	if SoraDGetCtrl("lordInfoCtrl"):getSourceKid() > 0 then
		info = self.mathcReinforcementsKids
	end
	for i, v in ipairs(info) do
		if v == kid then
			return true
		end
	end
	return false
end
function conquestWarCtrl:getCanReinforceKidsStr()
	local str = ""
	for i, v in ipairs(self.reinforcementsKids) do
		if i == 1 then
			str = v
		else
			str = string.format("%s,%d", str, v)
		end
	end
	return str
end
function conquestWarCtrl:getReceiveStatusAndNum()
	local _, num = SoraDGetCtrl("conquestWarReinforcementsCtrl"):getReceiveStatusAndNum()
	local num = num + self:getReinforceSettingRedNum()
	return 0 < num, num
end
function conquestWarCtrl:getReinforceSettingRedNum()
	local num = 0
	local startTime = self:getQueueStartTime(CONQUESTWAR_TO_BE_REINFORCE_QUEUE_KEY)
	if 0 < self:getSettingReinforceLefttime() and SoraDIsSelfKing() then
		_ENV = nil
		;(nil).byUID = true
		local lastStartTime = SoraDConfigGet("Game:kingdomBattle:prepareStatTime~string", nil)
		if lastStartTime ~= tostring(startTime) then
			num = num + 1
		end
	end
	return num
end
function conquestWarCtrl:getQueueStartTime(queueType)
	local ret = 0
	local queue = self:queryQueue(queueType)
	if queue then
		ret = queue.starttime
	end
	return ret
end
function conquestWarCtrl:getToBeReinforcements()
	return self.toBeReinforcementsNew
end
function conquestWarCtrl:gettoBeReinforcHost()
	return self.toBeReinforcHost
end
function conquestWarCtrl:isRecovering()
	return self.selfCastleInRuled and not self.matchCastleInRuled
end
function conquestWarCtrl:isRecoverd()
	return self.isKingdomRecovered or false
end
function conquestWarCtrl:getRecoverScore()
	return math.floor(self.kingdomRecoverScore or 0)
end
function conquestWarCtrl:timeEndCallBack()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_REFRESH"
	SoraDSendMessage(nil)
end
return conquestWarCtrl
