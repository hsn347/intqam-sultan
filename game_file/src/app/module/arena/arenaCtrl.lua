local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local timerList = gModuleMgr.getObject("timerList")
local arenaCtrl = class("arenaCtrl", gamemodulec)
function arenaCtrl:req4battleInfo(battleType)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ARENA_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_ARENA_GROUND_STATE, gCmd.REQ_ARENA_GROUND_STATE
	;(nil).data, gCmd.REQ_ARENA_GROUND_STATE.arenaType = gCmd.REQ_ARENA_GROUND_STATE, battleType
	local msg
	serverproxy:SendMsg(msg)
end
function arenaCtrl:req4battleGrounds(battleType)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ARENA_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_ARENA_ENTER_ROOM, gCmd.REQ_ARENA_ENTER_ROOM
	;(nil).data, gCmd.REQ_ARENA_ENTER_ROOM.arenaType = gCmd.REQ_ARENA_ENTER_ROOM, battleType
	local msg
	serverproxy:SendMsg(msg)
end
function arenaCtrl:req4battleRanks(battleType, group)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ARENA_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_ARENA_RANKING_QUERY, gCmd.REQ_ARENA_RANKING_QUERY
	gCmd.REQ_ARENA_RANKING_QUERY.arenaGroup = group
	;(nil).data, gCmd.REQ_ARENA_RANKING_QUERY.arenaType = gCmd.REQ_ARENA_RANKING_QUERY, battleType
	local msg
	serverproxy:SendMsg(msg)
end
function arenaCtrl:req2setMyArmy(battleType, armyList, heroInfo, armsInfo, divineBeastInfo, detail_c, bufflist_c)
	if type(detail_c) == "table" then
		detail_c.total_add = (detail_c.total_add or 0) + (detail_c.heroAddNum or 0) + (detail_c.godarmsadd or 0)
		detail_c.total = (detail_c.base or 0) + detail_c.total_add
	end
	_ENV = (detail_c.base or 0) + detail_c.total_add
	;(detail_c.base or 0) + detail_c.total_add.cmd = gCmd.CMD_ARENA_MODULE
	_ENV, (detail_c.base or 0) + detail_c.total_add.subcmd = gCmd.REQ_ARENA_SET_DEFEND, gCmd.REQ_ARENA_SET_DEFEND
	gCmd.REQ_ARENA_SET_DEFEND.armyInfo = armyList
	gCmd.REQ_ARENA_SET_DEFEND.arenaType = battleType
	gCmd.REQ_ARENA_SET_DEFEND.heroInfo = heroInfo
	gCmd.REQ_ARENA_SET_DEFEND.armsInfo = armsInfo
	gCmd.REQ_ARENA_SET_DEFEND.divineBeastInfo = divineBeastInfo
	gCmd.REQ_ARENA_SET_DEFEND.detail_c = detail_c
	;(detail_c.base or 0) + detail_c.total_add.data, gCmd.REQ_ARENA_SET_DEFEND.bufflist_c = gCmd.REQ_ARENA_SET_DEFEND, bufflist_c
	local msg = (detail_c.base or 0) + detail_c.total_add
	dump(msg, "req2setMyArmy======", 10)
	serverproxy:SendMsg(msg)
end
function arenaCtrl:req2gainReward(battleType)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ARENA_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_ARENA_GET_REWARD, gCmd.REQ_ARENA_GET_REWARD
	;(nil).data, gCmd.REQ_ARENA_GET_REWARD.arenaType = gCmd.REQ_ARENA_GET_REWARD, battleType
	local msg
	serverproxy:SendMsg(msg)
end
function arenaCtrl:req4battleReport(battleType)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ARENA_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_ARENA_BATTLE_REPORT, gCmd.REQ_ARENA_BATTLE_REPORT
	;(nil).data, gCmd.REQ_ARENA_BATTLE_REPORT.arenaType = gCmd.REQ_ARENA_BATTLE_REPORT, battleType
	local msg
	serverproxy:SendMsg(msg)
end
function arenaCtrl:reqChallengePlayer(targetUid, targetRank, targetNickname, arenaType, group, armyInfo, heroInfo, armsInfo, divineBeastInfo)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ARENA_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_ARENA_ARENA_CHALLENGE, gCmd.REQ_ARENA_ARENA_CHALLENGE
	gCmd.REQ_ARENA_ARENA_CHALLENGE.targetUid = targetUid
	gCmd.REQ_ARENA_ARENA_CHALLENGE.arenaType = arenaType
	gCmd.REQ_ARENA_ARENA_CHALLENGE.targetRank = targetRank
	gCmd.REQ_ARENA_ARENA_CHALLENGE.nickName = targetNickname
	gCmd.REQ_ARENA_ARENA_CHALLENGE.arenaGroup = group
	gCmd.REQ_ARENA_ARENA_CHALLENGE.armyInfo = armyInfo
	gCmd.REQ_ARENA_ARENA_CHALLENGE.heroInfo = heroInfo
	gCmd.REQ_ARENA_ARENA_CHALLENGE.armsInfo = armsInfo
	;(nil).data, gCmd.REQ_ARENA_ARENA_CHALLENGE.divineBeastInfo = gCmd.REQ_ARENA_ARENA_CHALLENGE, divineBeastInfo
	local msg
	serverproxy:SendMsg(msg)
end
function arenaCtrl:req4detailReport(battleType, index)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ARENA_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_ARENA_BATTLE_REPORT_DETAIL, gCmd.REQ_ARENA_BATTLE_REPORT_DETAIL
	gCmd.REQ_ARENA_BATTLE_REPORT_DETAIL.index = index
	;(nil).data, gCmd.REQ_ARENA_BATTLE_REPORT_DETAIL.arenaType = gCmd.REQ_ARENA_BATTLE_REPORT_DETAIL, battleType
	local msg
	serverproxy:SendMsg(msg)
end
function arenaCtrl:req2refreshEnemy(battleType)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ARENA_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_ARENA_REFRESH_RIVAL, gCmd.REQ_ARENA_REFRESH_RIVAL
	;(nil).data, gCmd.REQ_ARENA_REFRESH_RIVAL.arenaType = gCmd.REQ_ARENA_REFRESH_RIVAL, battleType
	local msg
	serverproxy:SendMsg(msg)
end
function arenaCtrl:req2buyCounts(battleType)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ARENA_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_ARENA_BUY_CHALLENGE_TIMES, gCmd.REQ_ARENA_BUY_CHALLENGE_TIMES
	;(nil).data, gCmd.REQ_ARENA_BUY_CHALLENGE_TIMES.arenaType = gCmd.REQ_ARENA_BUY_CHALLENGE_TIMES, battleType
	local msg
	serverproxy:SendMsg(msg)
end
function arenaCtrl:req4rankArmyInfo(battleType, arenaGroup, rank, lordInfo, fromPanel)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ARENA_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_ARENA_QUERY_RANK_ARMYINFO, gCmd.REQ_ARENA_QUERY_RANK_ARMYINFO
	gCmd.REQ_ARENA_QUERY_RANK_ARMYINFO.arenaType = battleType
	gCmd.REQ_ARENA_QUERY_RANK_ARMYINFO.arenaGroup = arenaGroup
	gCmd.REQ_ARENA_QUERY_RANK_ARMYINFO.rank = rank
	gCmd.REQ_ARENA_QUERY_RANK_ARMYINFO.lordInfo = lordInfo
	;(nil).data, gCmd.REQ_ARENA_QUERY_RANK_ARMYINFO.fromPanel = gCmd.REQ_ARENA_QUERY_RANK_ARMYINFO, fromPanel
	local msg
	serverproxy:SendMsg(msg)
end
function arenaCtrl:req4BattleInfo(battleType)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ARENA_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_ARENA_QUERY_BATTLE_INFO, gCmd.REQ_ARENA_QUERY_BATTLE_INFO
	;(nil).data, gCmd.REQ_ARENA_QUERY_BATTLE_INFO.arenaType = gCmd.REQ_ARENA_QUERY_BATTLE_INFO, battleType
	local msg
	serverproxy:SendMsg(msg)
end
function arenaCtrl:reqRefreshBuff(arenaType)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ARENA_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_ARENA_REFRESH_BUFF, gCmd.REQ_ARENA_REFRESH_BUFF
	;(nil).data, gCmd.REQ_ARENA_REFRESH_BUFF.arenaType = gCmd.REQ_ARENA_REFRESH_BUFF, arenaType
	local msg
	serverproxy:SendMsg(msg)
end
function arenaCtrl:noitfyDataRsp(content)
	dump(content, "noitfyDataRsp@@@@", 10)
	local loopData = content.data
	for i, notifyMsg in ipairs(loopData) do
		local revcDataType = notifyMsg.type
		local revcData = notifyMsg.data
		if revcData and next(revcData) then
			if "refreshData" == revcDataType then
				self.battleData = revcData
				self:refreshGloalTime()
				_ENV = self
				self.msg = "MESSAGE_SERVER_ARENA_MYINFOCHANGE"
				SoraDSendMessage(self)
				_ENV = self
				self.msg = "MESSAGE_UI_PANDECT_ARENA"
				self.bid = BUILDID.DRILL_GROUDS
				SoraDSendMessage(self)
			elseif "arenaRankChange" == revcDataType then
				print("arenaRankChange rank=", revcData.rank)
				local bType = revcData.arenaType
				self.battleData[gArenaBattleStrType[bType]].myRank = revcData.rank
				self.isUnderAttack[gArenaBattleStrType[bType]] = true
				_ENV = gArenaBattleStrType[bType]
				gArenaBattleStrType[bType].msg = "MESSAGE_SERVER_ARENA_MYINFOCHANGE"
				SoraDSendMessage(gArenaBattleStrType[bType])
				_ENV = gArenaBattleStrType[bType]
				gArenaBattleStrType[bType].msg = "MESSAGE_SERVER_ARENA_TIPCHANGE"
				SoraDSendMessage(gArenaBattleStrType[bType])
			elseif "groupChange" == revcDataType then
				self.battleData = revcData
				self.recordInfo = clone(self.battleData)
				_ENV = self.battleData
				self.battleData.msg = "MESSAGE_SERVER_ARENA_TIPCHANGE"
				SoraDSendMessage(self.battleData)
				_ENV = self.battleData
				self.battleData.msg = "MESSAGE_SERVER_ARENA_GROUPCHANGE"
				SoraDSendMessage(self.battleData)
			elseif "globalState" == revcDataType then
				if revcData.changeTime then
					self.battleData.globalArena.arenaChangeTime = revcData.changeTime
				else
				end
				self.battleData.globalArena.arenaStatus = revcData.status
				if revcData.buff then
					self.battleData.globalArena.arenaBuff = revcData.buff
				end
				self:refreshGloalTime()
				_ENV = self
				self.msg = "MESSAGE_SERVER_ARENA_GLOBALCHANGE"
				SoraDSendMessage(self)
			elseif "rewardTime" == revcDataType then
				local bType = revcData.arenaType
				self.battleData[gArenaBattleStrType[bType]].nextRewardTime = revcData.nextRewardTime
				_ENV = revcData.nextRewardTime
				revcData.nextRewardTime.msg = "MESSAGE_SERVER_ARENA_REWARDTIME"
				SoraDSendMessage(revcData.nextRewardTime)
				_ENV = revcData.nextRewardTime
				revcData.nextRewardTime.msg = "MESSAGE_SERVER_ARENA_TIPCHANGE"
				SoraDSendMessage(revcData.nextRewardTime)
			elseif "rewardChange" == revcDataType then
				local bType = revcData.arenaType
				if revcData.rewards then
					self.battleData[gArenaBattleStrType[bType]].rewards = revcData.rewards
				end
				_ENV = revcData.rewards
				revcData.rewards.msg = "MESSAGE_SERVER_ARENA_GAINREWARD"
				SoraDSendMessage(revcData.rewards)
				_ENV = revcData.rewards
				revcData.rewards.msg = "MESSAGE_SERVER_ARENA_TIPCHANGE"
				SoraDSendMessage(revcData.rewards)
			elseif "refreshHonor" == revcDataType then
				if revcData.arenaHonor then
					self.battleData.arenaHonor = revcData.arenaHonor
				end
				_ENV = revcData.arenaHonor
				revcData.arenaHonor.msg = "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH"
				SoraDSendMessage(revcData.arenaHonor)
			end
		end
	end
end
function arenaCtrl:battleInfoRsp(content)
	if content.err == gErrDef.Err_None then
		local enemyInfo = content.rspdata.enemyInfo
		local topInfo = content.rspdata.rankinfo
		local bType = content.data.arenaType
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_ARENA_BATTLEINFO"
		;(nil).enemyInfo = enemyInfo
		;(nil).battleType = bType
		;(nil).topInfo = topInfo
		SoraDSendMessage(nil)
	else
		_ENV = content.rspdata.rankinfo
		content.rspdata.rankinfo.msg = "MESSAGE_SERVER_ARENA_CLOSELOADING"
		SoraDSendMessage(content.rspdata.rankinfo)
	end
end
function arenaCtrl:battleGroundsRsp(content)
	if content.err == gErrDef.Err_None then
		local rankList = content.rspdata.topRankData
		local bType = content.data.arenaType
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_ARENA_BATTLEGROUNDS"
		;(nil).rankList = rankList
		;(nil).battleType = bType
		SoraDSendMessage(nil)
	else
		_ENV = content.data.arenaType
		content.data.arenaType.msg = "MESSAGE_SERVER_ARENA_CLOSELOADING"
		SoraDSendMessage(content.data.arenaType)
	end
end
function arenaCtrl:battleRanksRsp(content)
	if content.err == gErrDef.Err_None then
		local bType = content.data.arenaType
		local groupID = content.data.arenaGroup
		local backInfo = content.rspdata.rankData
		local rankTop = content.rspdata.rank1
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_ARENA_GROUPRANK"
		;(nil).groupID = groupID
		;(nil).battleType = bType
		;(nil).rankList = backInfo
		;(nil).rankTop = rankTop
		SoraDSendMessage(nil)
	else
		_ENV = content.data.arenaGroup
		content.data.arenaGroup.msg = "MESSAGE_SERVER_ARENA_CLOSELOADING"
		SoraDSendMessage(content.data.arenaGroup)
	end
end
function arenaCtrl:setMyArmyRsp(content)
	dump(content, "setMyArmyRsp==========", 10)
	if content.err == gErrDef.Err_None then
		local bType = content.data.arenaType
		local heroInfo = content.rspdata.heroInfo
		local armsInfo = content.rspdata.armsInfo
		local armyInfo = content.rspdata.armyInfo
		local divineBeastInfo = content.rspdata.divineBeastInfo
		local newForce = content.rspdata.fightCapacity
		self.battleData[gArenaBattleStrType[bType]].heroInfo = heroInfo
		self.battleData[gArenaBattleStrType[bType]].armyInfo = armyInfo
		self.battleData[gArenaBattleStrType[bType]].armsInfo = armsInfo
		self.battleData[gArenaBattleStrType[bType]].divineBeastInfo = divineBeastInfo
		self.battleData[gArenaBattleStrType[bType]].fightCapacity = newForce
		_ENV = gArenaBattleStrType[bType]
		gArenaBattleStrType[bType].msg = "MESSAGE_SERVER_ARENA_SETARMYLIST"
		SoraDSendMessage(gArenaBattleStrType[bType])
	else
		_ENV = content.rspdata.heroInfo
		content.rspdata.heroInfo.msg = "MESSAGE_SERVER_ARENA_CLOSELOADING"
		SoraDSendMessage(content.rspdata.heroInfo)
	end
end
function arenaCtrl:gainRewardRsp(content)
	dump(content, "content@@@@", 10)
	if content.err == gErrDef.Err_None then
		local bType = content.data.arenaType
		local newRewards = content.rspdata.rewards
		local gainItems = content.rspdata.rewardinfo
		self.battleData[gArenaBattleStrType[bType]].rewards = newRewards
		_ENV = gArenaBattleStrType[bType]
		gArenaBattleStrType[bType].msg = "MESSAGE_SERVER_ARENA_TIPCHANGE"
		SoraDSendMessage(gArenaBattleStrType[bType])
		_ENV = gArenaBattleStrType[bType]
		gArenaBattleStrType[bType].msg = "MESSAGE_SERVER_ARENA_GAINREWARD"
		gArenaBattleStrType[bType].gainItems = gainItems
		SoraDSendMessage(gArenaBattleStrType[bType])
	else
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_SERVER_ARENA_CLOSELOADING"
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function arenaCtrl:fightRsp(content)
	dump(content, "fightRsp-content@@@@", 10)
	if content.err == gErrDef.Err_None then
		local enemyInfo = content.rspdata.enemyInfo
		if enemyInfo then
			_ENV = "fightRsp-content@@@@"
			;("fightRsp-content@@@@").msg = "MESSAGE_SERVER_ARENA_REFRESHENEMY"
			;("fightRsp-content@@@@").enemyInfo = enemyInfo
			SoraDSendMessage("fightRsp-content@@@@")
		end
		local rankinfo = content.rspdata.rankinfo
		if rankinfo then
			_ENV = 10
			;(10).msg = "MESSAGE_SERVER_ARENA_REFRESHTOPRANK"
			;(10).rankinfo = rankinfo
			SoraDSendMessage(10)
		end
		local bWin = content.rspdata.bWin
		local rank = content.rspdata.rank
		local report = content.rspdata.report
		local remainTimes = content.rspdata.remainTimes
		local bType = content.data.arenaType
		local myRank = content.rspdata.rank
		local randFlipAward = content.rspdata.randFlipAward
		self.battleData[gArenaBattleStrType[bType]].remainTimes = remainTimes
		local isRankUp = false
		local oldRank = self.battleData[gArenaBattleStrType[bType]].myRank
		if oldRank and (oldRank == 0 and 0 < myRank or myRank < oldRank) then
			isRankUp = true
		end
		self.battleData[gArenaBattleStrType[bType]].myRank = myRank
		self.recordInfo = clone(self.battleData)
		_ENV = self.battleData
		self.battleData.msg = "MESSAGE_SERVER_ARENA_MYINFOCHANGE"
		SoraDSendMessage(self.battleData)
		_ENV = self.battleData
		self.battleData.msg = "MESSAGE_SERVER_ARENA_TIPCHANGE"
		SoraDSendMessage(self.battleData)
		_ENV = self.battleData
		self.battleData.msg = "MESSAGE_SERVER_ARENA_RESULTBACK"
		self.battleData.bWin = bWin
		self.battleData.rank = rank
		self.battleData.report = report
		self.battleData.randFlipAward = randFlipAward
		self.battleData.isRankUp = isRankUp
		SoraDSendMessage(self.battleData)
		_ENV = self.battleData
		self.battleData.msg = "MESSAGE_SERVER_ARENA_CHOOSECARD"
		self.battleData.randFlipAward = randFlipAward
		SoraDSendMessage(self.battleData)
	else
		if content.rspdata then
			local enemyInfo = content.rspdata.enemyInfo
			if enemyInfo then
				_ENV = content.rspdata.bWin
				content.rspdata.bWin.msg = "MESSAGE_SERVER_ARENA_REFRESHENEMY"
				content.rspdata.bWin.enemyInfo = enemyInfo
				SoraDSendMessage(content.rspdata.bWin)
			end
			local rankinfo = content.rspdata.rankinfo
			if rankinfo then
				_ENV = content.rspdata.rank
				content.rspdata.rank.msg = "MESSAGE_SERVER_ARENA_REFRESHTOPRANK"
				content.rspdata.rank.rankinfo = rankinfo
				SoraDSendMessage(content.rspdata.rank)
			end
		end
		_ENV = content.rspdata.rankinfo
		content.rspdata.rankinfo.msg = "MESSAGE_SERVER_ARENA_FIGHTERR"
		content.rspdata.rankinfo.err = content.err
		SoraDSendMessage(content.rspdata.rankinfo)
		_ENV = content.rspdata.rankinfo
		content.rspdata.rankinfo.msg = "MESSAGE_SERVER_ARENA_CLOSELOADING"
		SoraDSendMessage(content.rspdata.rankinfo)
	end
end
function arenaCtrl:battleReportRsp(content)
	if content.err == gErrDef.Err_None then
		local recordList = content.rspdata.report
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_ARENA_RECORDLIST"
		;(nil).recordList = recordList
		SoraDSendMessage(nil)
	else
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_SERVER_ARENA_CLOSELOADING"
		SoraDSendMessage(SoraDSendMessage)
	end
end
function arenaCtrl:detailReportRsp(content)
	if content.err == gErrDef.Err_None then
		local detailReport = content.rspdata.detail
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_ARENA_DETAILREPORT"
		;(nil).detailReport = detailReport
		SoraDSendMessage(nil)
	else
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_SERVER_ARENA_CLOSELOADING"
		SoraDSendMessage(SoraDSendMessage)
	end
end
function arenaCtrl:refreshEnemyRsp(content)
	if content.err == gErrDef.Err_None then
		local enemyInfo = content.rspdata.enemyInfo
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_ARENA_REFRESHENEMY"
		;(nil).enemyInfo = enemyInfo
		SoraDSendMessage(nil)
	else
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_SERVER_ARENA_CLOSELOADING"
		SoraDSendMessage(SoraDSendMessage)
	end
end
function arenaCtrl:buyCountsRsp(content)
	if content.err == gErrDef.Err_None then
		local bType = content.data.arenaType
		local remainTimes = content.rspdata.remainTimes
		if content.rspdata.buyTimes then
			self.battleData[gArenaBattleStrType[bType]].buyTimes = content.rspdata.buyTimes
		end
		self.battleData[gArenaBattleStrType[bType]].remainTimes = remainTimes
		_ENV = gArenaBattleStrType[bType]
		gArenaBattleStrType[bType].msg = "MESSAGE_SERVER_ARENA_TIPCHANGE"
		SoraDSendMessage(gArenaBattleStrType[bType])
		_ENV = gArenaBattleStrType[bType]
		gArenaBattleStrType[bType].msg = "MESSAGE_SERVER_ARENA_MYINFOCHANGE"
		SoraDSendMessage(gArenaBattleStrType[bType])
		_ENV = gArenaBattleStrType[bType]
		gArenaBattleStrType[bType].msg = "MESSAGE_SERVER_ARENA_BUYSUCCESS"
		SoraDSendMessage(gArenaBattleStrType[bType])
	else
		_ENV = content.rspdata.remainTimes
		content.rspdata.remainTimes.msg = "MESSAGE_SERVER_ARENA_CLOSELOADING"
		SoraDSendMessage(content.rspdata.remainTimes)
	end
end
function arenaCtrl:rankArmyInfoRsp(content)
	if content.err == gErrDef.Err_None then
		local heroInfo = content.rspdata.heroInfo
		local armsInfo = content.rspdata.armsInfo
		local armyInfo = content.rspdata.armyInfo
		local divineBeastInfo = content.rspdata.divineBeastInfo
		local lordInfo = content.data.lordInfo
		lordInfo.heroInfo = heroInfo
		lordInfo.armsInfo = armsInfo
		local fromPanel = content.data.fromPanel
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_ARENA_SEEARMYINFO"
		;(nil).armyInfo = armyInfo
		;(nil).divineBeastInfo = divineBeastInfo
		;(nil).lordInfo = lordInfo
		;(nil).fromPanel = fromPanel
		SoraDSendMessage(nil)
	else
		_ENV = content.rspdata.armsInfo
		content.rspdata.armsInfo.msg = "MESSAGE_SERVER_ARENA_CLOSELOADING"
		SoraDSendMessage(content.rspdata.armsInfo)
	end
end
function arenaCtrl:queryBattleInfoRsp(content)
	if content.err == gErrDef.Err_None then
		local battleInfo = content.rspdata.battleInfo
		local akPlus = battleInfo.akPlus
		local dfPlus = battleInfo.dfPlus
		local hpPlus = battleInfo.hpPlus
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_ARENA_ATTRIBUTE"
		;(nil).akPlus = akPlus
		;(nil).dfPlus = dfPlus
		;(nil).hpPlus = hpPlus
		SoraDSendMessage(nil)
	end
end
function arenaCtrl:refreshBuffRsp(content)
	dump(content, "refreshBuffRsp", 10)
	if content.err == gErrDef.Err_None then
		local bType = content.data.arenaType
		local refreshBuffTimes = content.rspdata.refreshBuffTimes
		local personalBuff = content.rspdata.personalBuff
		self.battleData[gArenaBattleStrType[bType]].personalBuff, _ENV = gArenaBattleStrType[bType], gArenaBattleStrType[bType]
		self.battleData[gArenaBattleStrType[bType]].refreshBuffTimes = refreshBuffTimes
		self.battleData[gArenaBattleStrType[bType]].personalBuff = personalBuff
		_ENV = gArenaBattleStrType[bType]
		gArenaBattleStrType[bType].msg = "MESSAGE_SERVER_ARENA_REFRESH_BUFF"
		SoraDSendMessage(gArenaBattleStrType[bType])
	end
end
function arenaCtrl:getArenaTicketNums()
	local ticketNums = 0
	if self.battleData and self.battleData.arenaHonor then
		ticketNums = self.battleData.arenaHonor
	end
	return ticketNums
end
function arenaCtrl:getBattleInfo(battleType)
	if gArenaBattleType.ARENA_LOCAL == battleType then
		return self.battleData.localArena
	elseif gArenaBattleType.AREAN_GLOBAL == battleType then
		return self.battleData.globalArena
	else
		return self.battleData
	end
end
function arenaCtrl:getRewardTime(battleType)
	local nowtime = serviceFunctions.systemTime()
	local endtime = self.battleData[gArenaBattleStrType[battleType]].nextRewardTime or 0
	return endtime - nowtime
end
function arenaCtrl:getTipState(battleType)
	if gArenaBattleType.AREAN_GLOBAL == battleType then
		if next(self.battleData[gArenaBattleStrType[battleType]].rewards) then
			return gArenaTipEnum.haveReward, "icon_recruitsupplies_box_01.png"
		end
		if self.battleData.globalArena.arenaStatus == gActivityState.CLOSE then
			return nil
		end
	end
	if next(self.battleData[gArenaBattleStrType[battleType]].rewards) then
		return gArenaTipEnum.haveReward, "icon_recruitsupplies_box_01.png"
	elseif self.battleData[gArenaBattleStrType[battleType]].myRank > self.recordInfo[gArenaBattleStrType[battleType]].myRank then
		return gArenaTipEnum.rankFall, "icon_equip_arrow_01.png"
	elseif self.isUnderAttack[gArenaBattleStrType[battleType]] and self.battleData[gArenaBattleStrType[battleType]].myRank <= self.recordInfo[gArenaBattleStrType[battleType]].myRank then
		return gArenaTipEnum.underAttackAndWin, "icon_saleRoom_symbol.png"
	elseif self.battleData[gArenaBattleStrType[battleType]].remainTimes > 0 then
		return gArenaTipEnum.haveAttackChange, "icon_saleRoom_symbol.png"
	else
		return nil
	end
end
function arenaCtrl:getAllTipState(checkType, battleType)
	if gArenaTipEnum.haveReward == checkType then
		return not not next(self.battleData[gArenaBattleStrType[battleType]].rewards)
	elseif gArenaTipEnum.rankFall == checkType then
		return self.battleData[gArenaBattleStrType[battleType]].myRank > self.recordInfo[gArenaBattleStrType[battleType]].myRank
	elseif gArenaTipEnum.underAttackAndWin == checkType then
		return self.isUnderAttack[gArenaBattleStrType[battleType]] and self.battleData[gArenaBattleStrType[battleType]].myRank <= self.recordInfo[gArenaBattleStrType[battleType]].myRank
	elseif gArenaTipEnum.haveAttackChange == checkType then
		return self.battleData[gArenaBattleStrType[battleType]].remainTimes > 0
	end
end
function arenaCtrl:clickTip(battleType)
	self.recordInfo[gArenaBattleStrType[battleType]].remainTimes = self.battleData[gArenaBattleStrType[battleType]].remainTimes
	_ENV = self.battleData[gArenaBattleStrType[battleType]].remainTimes
	self.battleData[gArenaBattleStrType[battleType]].remainTimes.msg = "MESSAGE_SERVER_ARENA_TIPCHANGE"
	SoraDSendMessage(self.battleData[gArenaBattleStrType[battleType]].remainTimes)
end
function arenaCtrl:clickRecordTip(battleType)
	self.recordInfo[gArenaBattleStrType[battleType]].myRank = self.battleData[gArenaBattleStrType[battleType]].myRank
	self.isUnderAttack[gArenaBattleStrType[battleType]] = false
	_ENV = gArenaBattleStrType[battleType]
	gArenaBattleStrType[battleType].msg = "MESSAGE_SERVER_ARENA_TIPCHANGE"
	SoraDSendMessage(gArenaBattleStrType[battleType])
end
function arenaCtrl:clickRewardTip(battleType)
	self.recordInfo[gArenaBattleStrType[battleType]].rewards = self.battleData[gArenaBattleStrType[battleType]].rewards
	_ENV = self.battleData[gArenaBattleStrType[battleType]].rewards
	self.battleData[gArenaBattleStrType[battleType]].rewards.msg = "MESSAGE_SERVER_ARENA_TIPCHANGE"
	SoraDSendMessage(self.battleData[gArenaBattleStrType[battleType]].rewards)
end
function arenaCtrl:ctor(properties)
	arenaCtrl.super.ctor(self, properties)
	self:resetData()
end
function arenaCtrl:resetData()
	self.isUnderAttack, _UPVALUE0_, self.recordInfo, _UPVALUE0_, self.battleData, _UPVALUE0_, self.queue, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
end
function arenaCtrl:initClientData(data)
	if nil == data then
		return
	end
	dump(data, "initclient arena", 10)
	self.battleData = data
	if self.battleData then
		self:recordOldInfo()
		self:refreshGloalTime()
	end
	self:registerNotify()
end
function arenaCtrl:recordOldInfo(...)
	self.recordInfo = clone(self.battleData)
end
function arenaCtrl:refreshGloalTime(...)
	if self.battleData.globalArena.arenaStatus then
		local starttime = serviceFunctions.systemTime()
		local endtime = self.battleData.globalArena.arenaChangeTime
		local lefttime = endtime - starttime
		if lefttime <= 0 then
			lefttime = 0
		end
		self:addQueue(ARENA_GLOBAL_QUEUE_KEY, starttime, lefttime, lefttime)
	end
end
function arenaCtrl:EnterGame()
	arenaCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_ARENA_MODULE, gCmd.REQ_ARENA_GROUND_STATE, handler(self, self.battleInfoRsp))
	msgCtrl.register(gCmd.CMD_ARENA_MODULE, gCmd.REQ_ARENA_ENTER_ROOM, handler(self, self.battleGroundsRsp))
	msgCtrl.register(gCmd.CMD_ARENA_MODULE, gCmd.REQ_ARENA_RANKING_QUERY, handler(self, self.battleRanksRsp))
	msgCtrl.register(gCmd.CMD_ARENA_MODULE, gCmd.REQ_ARENA_SET_DEFEND, handler(self, self.setMyArmyRsp))
	msgCtrl.register(gCmd.CMD_ARENA_MODULE, gCmd.REQ_ARENA_GET_REWARD, handler(self, self.gainRewardRsp))
	msgCtrl.register(gCmd.CMD_ARENA_MODULE, gCmd.REQ_ARENA_ARENA_CHALLENGE, handler(self, self.fightRsp))
	msgCtrl.register(gCmd.CMD_ARENA_MODULE, gCmd.REQ_ARENA_BATTLE_REPORT, handler(self, self.battleReportRsp))
	msgCtrl.register(gCmd.CMD_ARENA_MODULE, gCmd.REQ_ARENA_BATTLE_REPORT_DETAIL, handler(self, self.detailReportRsp))
	msgCtrl.register(gCmd.CMD_ARENA_MODULE, gCmd.REQ_ARENA_REFRESH_RIVAL, handler(self, self.refreshEnemyRsp))
	msgCtrl.register(gCmd.CMD_ARENA_MODULE, gCmd.REQ_ARENA_BUY_CHALLENGE_TIMES, handler(self, self.buyCountsRsp))
	msgCtrl.register(gCmd.CMD_ARENA_MODULE, gCmd.REQ_ARENA_QUERY_RANK_ARMYINFO, handler(self, self.rankArmyInfoRsp))
	msgCtrl.register(gCmd.CMD_ARENA_MODULE, gCmd.REQ_ARENA_QUERY_BATTLE_INFO, handler(self, self.queryBattleInfoRsp))
	msgCtrl.register(gCmd.CMD_ARENA_MODULE, gCmd.REQ_ARENA_REFRESH_BUFF, handler(self, self.refreshBuffRsp))
end
function arenaCtrl:registerNotify(...)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ARENA, handler(self, self.noitfyDataRsp))
end
function arenaCtrl:Logout()
	arenaCtrl.super.Logout(self)
	self:resetData()
end
function arenaCtrl:getGlobalQueueTimer()
	return self.queue[ARENA_GLOBAL_QUEUE_KEY]
end
function arenaCtrl:addQueue(queuetype, starttime, totaltime, lefttime, data)
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
	queue.qtype = queuetype
	queue.starttime = starttime
	queue.totaltime = totaltime
	local ok, node = timerList:createTimer(lefttime, timerHandler(dispatchQueueEvent))
	if ok then
		queue.timerNode = node
		self.queue[queuetype] = queue
	end
end
function arenaCtrl:removeQueue(queuetype)
	local queuetype = tostring(queuetype)
	local queue = self:queryQueue(queuetype)
	if queue then
		timerList:cancelTimer(queue.timerNode)
		self.queue[queuetype] = nil
	end
end
function arenaCtrl:queryQueue(queuetype)
	local ret = self.queue[tostring(queuetype)]
	if ret then
		return ret
	end
end
return arenaCtrl
