local gamemodulec = include("GameModule")
local remainsTeamCtrl = class("remainsTeamCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local RUINS_WAR_STATE = _G.RUINS_WAR_STATE
function remainsTeamCtrl:checkActivityMatchTime()
	if self:isActiveOpen() and self:isHasTeam() and self:isTeamCanOperator() then
		local _UPVALUE3_, RUINS_WAR_STATE, timeArray = self, self:isTeamCanOperator(), self:isTeamCanOperator()
		self[1] = RUINS_WAR_STATE.MATCH1
		self[2] = RUINS_WAR_STATE.MATCH2
		local self[3], timeStatus = RUINS_WAR_STATE.MATCH3, self
		for _, state in ipairs(timeStatus) do
			local time = self:getWarStatusTime_imp(state)
			local remainTime = 300
			if time >= remainTime then
				timeArray[state] = time - remainTime
			end
		end
		return timeArray
	end
end
function remainsTeamCtrl:getWarStatusTime_imp(curState)
	if not self.ruinsWarStateInfo.timeConfig then
		local RUINS_WAR_STATE, timeConfig = self.ruinsWarStateInfo.timeConfig, self.ruinsWarStateInfo.timeConfig
	end
	local endTime
	if curState == RUINS_WAR_STATE.PREPARE then
		endTime = timeConfig.beginTime
	elseif curState == RUINS_WAR_STATE.MATCH1 then
		endTime = timeConfig.match1Time
	elseif curState == RUINS_WAR_STATE.MATCH2 then
		endTime = timeConfig.match2Time
	elseif curState == RUINS_WAR_STATE.MATCH3 then
		endTime = timeConfig.match3Time
	elseif curState == RUINS_WAR_STATE.BATTLE then
		endTime = timeConfig.endTime
	end
	local sysTime = serviceFunctions.systemTime()
	if endTime and endTime > sysTime then
		return endTime - sysTime
	end
	return 0
end
function remainsTeamCtrl:getWarStatusTime()
	local curState = self.ruinsWarStateInfo.cruState
	return self:getWarStatusTime_imp(curState)
end
function remainsTeamCtrl:isWarBattle()
	local curState = self.ruinsWarStateInfo.cruState
	return curState == RUINS_WAR_STATE.BATTLE
end
function remainsTeamCtrl:isWarPrepare()
	local curState = self.ruinsWarStateInfo.cruState
	return curState == RUINS_WAR_STATE.PREPARE
end
function remainsTeamCtrl:isWarMatchBegin()
	local curState = self.ruinsWarStateInfo.cruState
	if curState == RUINS_WAR_STATE.MATCH1 or curState == RUINS_WAR_STATE.MATCH2 or curState == RUINS_WAR_STATE.MATCH3 then
		return true
	end
	return false
end
function remainsTeamCtrl:getWarMatchNum()
	local curState = self.ruinsWarStateInfo.cruState
	if curState == RUINS_WAR_STATE.MATCH1 then
		return 1
	elseif curState == RUINS_WAR_STATE.MATCH2 then
		return 2
	elseif curState == RUINS_WAR_STATE.MATCH3 then
		return 3
	end
	return 0
end
function remainsTeamCtrl:getWarMatchTotalTime()
	local curState = self.ruinsWarStateInfo.cruState
	if not self.ruinsWarStateInfo.timeConfig then
		local RUINS_WAR_STATE, timeConfig = self.ruinsWarStateInfo.timeConfig, self.ruinsWarStateInfo.timeConfig
	end
	local beginTime, endTime
	if curState == RUINS_WAR_STATE.MATCH1 then
		beginTime = timeConfig.beginTime
		endTime = timeConfig.match1Time
	elseif curState == RUINS_WAR_STATE.MATCH2 then
		beginTime = timeConfig.match1Time
		endTime = timeConfig.match2Time
	elseif curState == RUINS_WAR_STATE.MATCH3 then
		beginTime = timeConfig.match2Time
		endTime = timeConfig.match3Time
	end
	if beginTime and endTime and beginTime < endTime then
		return endTime - beginTime
	end
	return 1
end
function remainsTeamCtrl:isActiveOpen()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.RUINS_WAR)
	local remainsWarStatus = param.curState
	if remainsWarStatus == _G.ACTIVITY_STATE.ACTIVE or remainsWarStatus == _G.ACTIVITY_STATE.SETTLE then
		return true
	end
	return false
end
function remainsTeamCtrl:getActivityStatusTime()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.RUINS_WAR)
	local endTime
	local remainsWarStatus = param.curState
	if not param.timeConfig then
		local gametop, timeConfig = param.timeConfig, param.timeConfig
	end
	if remainsWarStatus == _G.ACTIVITY_STATE.PREPARE then
		endTime = timeConfig.prepareTime
	elseif remainsWarStatus == _G.ACTIVITY_STATE.ACTIVE then
		endTime = timeConfig.finishTime
	elseif remainsWarStatus == _G.ACTIVITY_STATE.SETTLE then
		endTime = timeConfig.finishTime
	elseif remainsWarStatus == _G.ACTIVITY_STATE.FINISH then
		endTime = timeConfig.finishTime
	end
	local sysTime = serviceFunctions.systemTime()
	if endTime and endTime > sysTime then
		return endTime - sysTime
	end
	return 0
end
function remainsTeamCtrl:getActivitySeasonRound()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.RUINS_WAR)
	local round = param and param.round or 0
	return round
end
function remainsTeamCtrl:getActivitySeasonTitle()
	if include("remainsWarUtil").checkIsInRemainsXianXia() then
		return i18n("remains_text_202")
	else
		local round = self:getActivitySeasonRound()
		_ENV = nil
		;(nil).num = round
		return i18n("remains_text_02", nil)
	end
end
function remainsTeamCtrl:getActivitySeasonTime()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.RUINS_WAR)
	local beginTime = 0
	local endTime = 0
	if param and param.timeConfig then
		beginTime = param.timeConfig.activeTime
		endTime = param.timeConfig.finishTime
	end
	local beginTimeStr = os.date("!%Y.%m.%d", beginTime)
	local endTimeStr = os.date("!%Y.%m.%d", endTime)
	return beginTimeStr .. " - " .. endTimeStr
end
function remainsTeamCtrl:getRankScoreList(idx, count, ...)
	serverproxy = nil
	;(nil).idx = idx
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_GET_SCORE_RANKING, nil, ...)
end
function remainsTeamCtrl:getRankHistoryList()
	serverproxy:Request(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_GET_HISTORY_RECORD)
end
function remainsTeamCtrl:reqCreateTeam(armyList)
	_UPVALUE0_ = nil
	local (nil).army, areaData = armyList, nil
	self.myTeamInfo:reqTeamCreate(areaData)
end
function remainsTeamCtrl:reqCheckName(name)
	local remainsWarUtil = include("remainsWarUtil")
	local err = remainsWarUtil.checkTeamName(name, true)
	if err == gErrDef.Err_None then
		_ENV = nil
		;(nil).name = name
		serverproxy:Request(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_CHECK_NAME, nil)
	end
	return err
end
function remainsTeamCtrl:reqGetTeamList(kid, aid, name)
	self.myTeamInfo:reqTeamSearch(kid, aid, name)
end
function remainsTeamCtrl:reqGetUserList(kid, name)
	self.myTeamInfo:reqTeamSearchUser(kid, name)
end
function remainsTeamCtrl:reqGetAllianceList(isFilter)
	self.myTeamInfo:reqTeamSearchAlliance(isFilter)
end
function remainsTeamCtrl:reqGetFriendList(isFilter)
	self.myTeamInfo:reqTeamSearchFriend(isFilter)
end
function remainsTeamCtrl:reqApplyJoin(teamId, armyList)
	_UPVALUE0_ = nil
	local (nil).army, areaData = armyList, nil
	self.myTeamInfo:reqTeamApplyJoin(teamId, areaData)
end
function remainsTeamCtrl:reqAgreeApplyJoin(uid)
	self.myTeamInfo:reqTeamAgreeApply(uid)
end
function remainsTeamCtrl:reqDismissTeam()
	self.myTeamInfo:reqTeamDismiss()
end
function remainsTeamCtrl:reqExpelMember(uid)
	self.myTeamInfo:reqTeamKick(uid)
end
function remainsTeamCtrl:reqQuitTeam()
	self.myTeamInfo:reqTeamQuit()
end
function remainsTeamCtrl:reqDemiseTeam(uid)
	self.myTeamInfo:reqTeamTransferLeader(uid)
end
function remainsTeamCtrl:reqSendAllianceInvite(shareWorld, shareAlliance)
	local isShareWorld = shareWorld or false
	local isShareAlliance = shareAlliance or false
	self.myTeamInfo:reqTeamSendInvitation(isShareWorld, isShareAlliance)
	self:setSendShare()
end
function remainsTeamCtrl:reqInviteJoinTeam(uid, kid)
	self.myTeamInfo:reqTeamInviteJoin(uid, kid)
end
function remainsTeamCtrl:reqAgreeInviteJoin(teamId, armyList)
	_UPVALUE0_ = nil
	local (nil).army, areaData = armyList, nil
	self.myTeamInfo:reqTeamAgreeInvite(teamId, areaData)
end
function remainsTeamCtrl:reqRejectInviteJoin(teamId)
	self.myTeamInfo:reqTeamRejectInvite(teamId)
end
function remainsTeamCtrl:reqGetTeamInfo(teamId)
	self.myTeamInfo:reqTeamGetTeamInfo(teamId)
end
function remainsTeamCtrl:reqGetMemberInfo()
	self.myTeamInfo:reqTeamGetTeamMemberInfo()
end
function remainsTeamCtrl:reqGetApplyList()
	self.myTeamInfo:reqTeamGetTeamApplyInfo()
end
function remainsTeamCtrl:reqChangeArmy(armyList)
	_UPVALUE0_ = nil
	local (nil).army, areaData = armyList, nil
	self.myTeamInfo:reqTeamChangeTroop(areaData)
end
function remainsTeamCtrl:reqMatch(isRandomTeam)
	self.myTeamInfo:reqTeamMatch(isRandomTeam)
	_ENV = self.myTeamInfo
	self.myTeamInfo.msg = "MESSAGE_SERVER_REMAINS_TEAM_MATCH_REQ"
	SoraDSendMessage(self.myTeamInfo)
end
function remainsTeamCtrl:reqCancelMatch()
	self.myTeamInfo:reqTeamCancelMatch()
end
function remainsTeamCtrl:reqEnterBattlefield()
	serverproxy:Request(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_ENTER_BATTLEFIELD)
end
function remainsTeamCtrl:reqQuitBattlefield()
	serverproxy:Request(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_QUIT_BATTLEFIELD)
end
function remainsTeamCtrl:reqCanJoinTeam(teamId, extraData)
	serverproxy = nil
	;(nil).teamId = teamId
	;(nil).extraData = extraData
	serverproxy:Request(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_CAN_JOIN_TEAM, nil)
end
function remainsTeamCtrl:reqGetMatchInfo()
	serverproxy:Request(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_GET_MATCH_INFO)
end
function remainsTeamCtrl:reqGetHistoryGrade()
	serverproxy:Request(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_GET_HISTORY_GRADE)
end
function remainsTeamCtrl:reqShareSettleInfo(shareWorld, shareAlliance)
	local isShareWorld = shareWorld or false
	local isShareAlliance = shareAlliance or false
	serverproxy = nil
	;(nil).isShareWorld = isShareWorld
	;(nil).isShareAlliance = isShareAlliance
	serverproxy:Request(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_SHARE_SETTLE_INFO, nil)
end
function remainsTeamCtrl:reqShareSeasonInfo(seasonID, shareWorld, shareAlliance)
	serverproxy = nil
	;(nil).season = seasonID
	;(nil).isShareWorld = shareWorld or false
	local (nil).isShareAlliance, data = shareAlliance or false, nil
	serverproxy:Request(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_SHARE_SEASON_INFO, data)
end
function remainsTeamCtrl:reqGetPlayerBuyList()
	serverproxy:Request(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_GET_SHOP_ITEM_BUY_NUM)
end
function remainsTeamCtrl:reqBuyItem(itemID, count, ...)
	local serverproxy, data
	data.shopItemID = itemID
	data.count = count
	serverproxy:Request(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_SHOP_ITEM_BUY, data, ...)
end
function remainsTeamCtrl:isHasTeam(hasData)
	if hasData then
		return self.myTeamInfo:isHasTeam()
	end
	return not self.myTeamInfo:isHasTeam() and self.matchTeamInfo and next(self.matchTeamInfo)
end
function remainsTeamCtrl:isRemainsWarEnd()
	return self.isBettleEnd
end
function remainsTeamCtrl:resetRemainsWarEnd()
	self.isBettleEnd = false
end
function remainsTeamCtrl:isRemainsWarShared()
	return self.isBattleShared
end
function remainsTeamCtrl:isTeamLeader()
	return self.myTeamInfo:isTeamLeader()
end
function remainsTeamCtrl:getTeamRemainNum()
	local num = self:getTeamMemberNum()
	return math.max(0, _G.TEAM_MEMBER_MAX - num)
end
function remainsTeamCtrl:getTeamMemberNum()
	return self.myTeamInfo:getTeamMemberNum()
end
function remainsTeamCtrl:getMyTeamInfo()
	return self.myTeamInfo
end
function remainsTeamCtrl:getWarMapId()
	if self.matchTeamInfo and self.matchTeamInfo.mapId then
		return self.matchTeamInfo.mapId
	end
	return 0
end
function remainsTeamCtrl:getTeamStatus()
	local status = _G.RUINS_WAR_TEAM_STATE.NONE
	if self:getWarMapId() > 0 then
		status = _G.RUINS_WAR_TEAM_STATE.BATTLE
	elseif self.myTeamInfo:isHasTeam() and self.myTeamInfo:isMaching() then
		status = _G.RUINS_WAR_TEAM_STATE.MATCHING
	end
	return status
end
function remainsTeamCtrl:isTeamCanInWar()
	local status = self:getTeamStatus()
	return status == _G.RUINS_WAR_TEAM_STATE.BATTLE
end
function remainsTeamCtrl:isTeamCanOperator()
	local status = self:getTeamStatus()
	return status == _G.RUINS_WAR_TEAM_STATE.NONE
end
function remainsTeamCtrl:isTeamHasApproval()
	return self.myTeamInfo and self.myTeamInfo:isTeamHasApproval()
end
function remainsTeamCtrl:isGetMatchInfo()
	if self.myTeamInfo and self.myTeamInfo:isHasTeam() then
		local tid = self.myTeamInfo:getTeamID()
		return self.matchInfo[tid] or false
	end
	return false
end
function remainsTeamCtrl:setGetMatchInfo()
	if self.myTeamInfo and self.myTeamInfo:isHasTeam() then
		local tid = self.myTeamInfo:getTeamID()
		self.matchInfo[tid] = true
	end
end
function remainsTeamCtrl:isCanSendShare()
	if self.myTeamInfo and self.myTeamInfo:isHasTeam() then
		local tid = self.myTeamInfo:getTeamID()
		local time = self.shareInfo[tid]
		if time and 0 < time then
			local curTime = serviceFunctions.systemTime()
			if time < curTime then
				return 60 <= curTime - time
			end
		end
	end
	return true
end
function remainsTeamCtrl:setSendShare()
	if self.myTeamInfo and self.myTeamInfo:isHasTeam() then
		local tid = self.myTeamInfo:getTeamID()
		local curTime = serviceFunctions.systemTime()
		self.shareInfo[tid] = curTime
	end
end
function remainsTeamCtrl:getPlayerRankScore()
	return self.playerInfo and self.playerInfo.rankScore or 0
end
function remainsTeamCtrl:isPlayerApplayTeam()
	local teamId = self.playerInfo and self.playerInfo.curApplyTeamId or 1
	return teamId ~= 0
end
function remainsTeamCtrl:isPlayerApplayThisTeam(teamId)
	local applyTeamId = self.playerInfo and self.playerInfo.curApplyTeamId or 0
	return teamId == applyTeamId
end
function remainsTeamCtrl:isPlayerHasBattleTimes()
	local battleTimes = self.playerInfo and self.playerInfo.battleTimes or 0
	return battleTimes == 0
end
function remainsTeamCtrl:getPlayerSegment()
	return self.playerInfo and self.playerInfo.segment or 1
end
function remainsTeamCtrl:getSegmentRealIndex(segment)
	_UPVALUE8_ = nil
	;(nil)[1] = 1
	;(nil)[2] = 2
	;(nil)[3] = 3
	;(nil)[4] = 4
	;(nil)[5] = 5
	;(nil)[6] = 6
	;(nil)[7] = 8
	local (nil)[8], sgList = 7, nil
	return sgList[segment]
end
function remainsTeamCtrl:getPlayerStar()
	return self.playerInfo and self.playerInfo.star or 0
end
function remainsTeamCtrl:getPlayerShopScore()
	return self.playerInfo and self.playerInfo.ruinsWarShopScore or 0
end
function remainsTeamCtrl:getHistoryShareLeftCDTime()
	local ret = 0
	local time = self.playerInfo and self.playerInfo.lastShareTime or 0
	if time and 0 < time then
		local sysTime = serviceFunctions.systemTime()
		local endTime = time + _G.REMAIS_WAR_HISTORY_SHARE_CDTIME
		if sysTime < endTime then
			return endTime - sysTime
		end
	end
	return ret
end
function remainsTeamCtrl:getTeamShareLeftCDTime()
	local ret = 0
	if self.myTeamInfo and self.myTeamInfo:isHasTeam() then
		local tid = self.myTeamInfo:getTeamID()
		local time = self.shareInfo[tid]
		if time and 0 < time then
			local sysTime = serviceFunctions.systemTime()
			local endTime = time + _G.REMAIS_WAR_TEAM_SHARE_CDTIME
			if sysTime < endTime then
				ret = endTime - sysTime
			end
		end
	end
	return ret
end
function remainsTeamCtrl:ctor(properties)
	remainsTeamCtrl.super.ctor(self, properties)
end
function remainsTeamCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_ENTER_BATTLEFIELD, handler(self, self.enterBattlefieldRSP))
	msgCtrl.register(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_QUIT_BATTLEFIELD, handler(self, self.quitBattlefieldRSP))
	msgCtrl.register(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_GET_SCORE_RANKING, handler(self, self.reqRankScoreListRSP))
	msgCtrl.register(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_GET_HISTORY_RECORD, handler(self, self.reqRankHistoryListRSP))
	msgCtrl.register(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_CAN_JOIN_TEAM, handler(self, self.canJoinTeamRSP))
	msgCtrl.register(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_GET_MATCH_INFO, handler(self, self.getMatchInfoRSP))
	msgCtrl.register(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_GET_SHOP_ITEM_BUY_NUM, handler(self, self.reqGetPlayerBuyListRSP))
	msgCtrl.register(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_SHOP_ITEM_BUY, handler(self, self.reqBuyItemRSP))
	msgCtrl.register(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_GET_HISTORY_GRADE, handler(self, self.reqGetHistoryGradeRSP))
	msgCtrl.register(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_SHARE_SETTLE_INFO, handler(self, self.reqShareSettleInfoRSP))
	msgCtrl.register(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_SHARE_SEASON_INFO, handler(self, self.reqShareSeasonInfoRSP))
	msgCtrl.register(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_HISTORY_RECORD_INFO, handler(self, self.reqHistoryRecordInfoRSP))
	msgCtrl.register(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_SHARE_HISTORY_RECORD, handler(self, self.reqShareHistoryRecordRSP))
	msgCtrl.register(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_GET_TITLE_RANKING, handler(self, self.reqTitleRankRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.RUINS_WAR_STATE_INFO, handler(self, self.onMsg))
	self:resetData()
end
function remainsTeamCtrl:resetData()
	self.matchInfo, _ENV, self.playerInfo, _ENV, self.ruinsWarStateInfo, _ENV, self.invitedInfo, _ENV = nil, nil, nil, nil, nil, nil, nil, nil
	self.shareInfo, _ENV, self.matchTeamInfo = nil, nil, nil
	self.ruinsWarStateInfo.cruState = _G.RUINS_WAR_STATE.NONE
	self.isBettleEnd = false
	self.isBattleShared = false
	self:initMyTeam()
end
function remainsTeamCtrl:Logout()
	remainsTeamCtrl.super.Logout(self)
	self:resetData()
end
function remainsTeamCtrl:setMatchInfo(data)
	self.matchTeamInfo = data
end
function remainsTeamCtrl:getInvitedInfo()
	return self.myTeamInfo:getInvitedInfo()
end
function remainsTeamCtrl:isHasInvitedInfo()
	return self.myTeamInfo:isHasInvitedInfo()
end
function remainsTeamCtrl:setMyTeamInfo(data)
	self.myTeamInfo = data
end
function remainsTeamCtrl:isHasNewTeamMsg(new)
	return self.myTeamInfo:isHasNewTeamMsg()
end
function remainsTeamCtrl:cleanHasNewTeamMsg()
	self.myTeamInfo:cleanHasNewTeamMsg()
end
function remainsTeamCtrl:onMsg(event)
	local data = event.data
	if data then
		for _, msg in pairs(data) do
			if msg.notifyType == "updateRuinsWarStateInfo" then
				self:setRemiansWarStatus_Info(msg.notifyData)
			elseif msg.notifyType == "updateRuinsWarTeamInfo" then
			elseif msg.notifyType == "inviteJoin" then
			elseif msg.notifyType == "matchSucess" then
				_ENV = self
				self.msg = "MESSAGE_SERVER_REMAINS_TEAM_MATCH_SUC_BEFFER"
				self.matchInfo = msg.notifyData
				SoraDSendMessage(self)
				_ENV = self
				self.msg = "MESSAGE_SERVER_REMAINS_TEAM_MATCH_SUC"
				self.matchInfo = msg.notifyData
				SoraDSendMessage(self)
				self:setMatchInfo(msg.notifyData)
				self.myTeamInfo:resetData()
				_ENV = self.myTeamInfo
				self.myTeamInfo.msg = "MESSAGE_UI_TEAM_MY_INFO"
				SoraDSendMessage(self.myTeamInfo)
			elseif msg.notifyType == "clearMatchInfo" then
				self:setMatchInfo(nil)
				self.myTeamInfo:resetData()
				_ENV = self.myTeamInfo
				self.myTeamInfo.msg = "MESSAGE_UI_TEAM_MY_INFO"
				SoraDSendMessage(self.myTeamInfo)
			elseif msg.notifyType == "ruinsWarSettle" or msg.notifyType == "notifyRankScore" then
				self:updateSegmentByBattleEnd(msg.notifyData)
				local resultInfo = msg.notifyData
				if resultInfo then
					if not resultInfo.ruinsWarSettleData then
						local panel = SoraDCreatePanel("remainsWarScoreView")
						panel:show()
						panel:initData(resultInfo)
					else
						local panel = SoraDCreatePanel("remainsWarResultView")
						panel:show()
						_ENV = resultInfo
						resultInfo.resultInfo = resultInfo
						panel:initData(resultInfo)
					end
				end
				if worldMapDefine.isInRemains() then
					self.isBettleEnd = true
				end
			elseif msg.notifyType == "anchorRuinsWarSettle" then
				self:updateSegmentByBattleEnd(msg.notifyData)
				_ENV = self
				self.msg = "MESSAGE_SERVER_REMAINS_WAR_BATTLE_END"
				self.resultInfo = msg.notifyData
				SoraDSendMessage(self)
			elseif msg.notifyType == "updateRuinsWarShopScore" then
				self.playerInfo.ruinsWarShopScore = msg.notifyData.ruinsWarShopScore
				_ENV = msg.notifyData.ruinsWarShopScore
				msg.notifyData.ruinsWarShopScore.msg = "MESSAGE_SERVER_REMAINS_BUY_SUCCESS"
				msg.notifyData.ruinsWarShopScore.score = msg.notifyData.ruinsWarShopScore
				msg.notifyData.ruinsWarShopScore.buyList = self.buyList
				SoraDSendMessage(msg.notifyData.ruinsWarShopScore)
			elseif msg.notifyType == "updateCurApplyTeamId" then
				self.playerInfo.curApplyTeamId = msg.notifyData.teamId
				_ENV = msg.notifyData.teamId
				msg.notifyData.teamId.msg = "MESSAGE_SERVER_REMAINS_TEAM_APPLY_TEAM"
				SoraDSendMessage(msg.notifyData.teamId)
			elseif msg.notifyType == "updateCurRoundBattleTimes" then
				self.playerInfo.battleTimes = msg.notifyData.battleTimes
			elseif msg.notifyType == "updateSegment" then
				if msg.notifyData.segment then
					self.playerInfo.segment = msg.notifyData.segment
					_ENV = msg.notifyData.segment
					msg.notifyData.segment.msg = "MESSAGE_SERVER_REMAINS_WAR_SCORE_STATUS"
					SoraDSendMessage(msg.notifyData.segment)
				end
			elseif msg.notifyType == "dismissTeam" then
				SoraDShowMsgBox(i18n("remains_text_112"), i18n("common_text_054"), nil, nil)
			elseif msg.notifyType == "expeledTeam" then
				SoraDShowMsgBox(i18n("remains_text_109"), i18n("common_text_054"), nil, nil)
			elseif msg.notifyType == "matchFaild" then
				SoraDShowMsgBox(i18n("remains_text_174"), i18n("common_text_054"), nil, nil)
			elseif msg.notifyType == "reported" then
				self.playerInfo.reported = msg.notifyData
			end
		end
	end
end
function remainsTeamCtrl:initClientData(data)
