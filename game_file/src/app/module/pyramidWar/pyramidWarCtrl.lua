local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local timerList = gModuleMgr.getObject("timerList")
local msgCtrl = include("msgCtrl")
local gamemodulec = include("GameModule")
local pyramidWarCtrl = class("pyramidWarCtrl", gamemodulec)
function pyramidWarCtrl:ctor(properties)
	pyramidWarCtrl.super.ctor(self, properties)
	self:resetData()
end
function pyramidWarCtrl:resetData()
	self.queue, _ENV = nil, nil
	self.openKidNum = 0
	self.pyramidWarOpenState = gPyramidWarOpenState.NOT_OPEN
	self.curSeasonNo = 0
	self.curSeasonType = gSeasonType.NONE
	self.memberState = gMemberState.NO_APPOINT
	self.regularSeasonState = gRegularSeasonState.NOT_OPEN
	self.regularCurRound = 0
	self.regularTotalRound = 0
	self.aidPool, _ENV, self.regularEndTime = gRegularSeasonState.NOT_OPEN, gRegularSeasonState.NOT_OPEN, 0
	self.regularSeasonAllianceState = gRegularSeasonAllianceState.NOT_APPLY
	self.applyRegularSeasonCount = 0
	self.pinnacleSeasonState = gPinnacleSeasonState.NOT_OPEN
	self.pinnacleRound = 0
	self.peakSeasonNo = 0
	self.top4Alliance, _ENV, self.top16GroupInfo, _ENV, self.top16Group, _ENV, self.battleResult, _ENV, self.curMatchType = gPinnacleMatchType.NONE, gPinnacleMatchType.NONE, gPinnacleMatchType.NONE, gPinnacleMatchType.NONE, gPinnacleMatchType.NONE, gPinnacleMatchType.NONE, gPinnacleMatchType.NONE, gPinnacleMatchType.NONE, gPinnacleMatchType.NONE
	self.postSeasonGiftSendRecord, _ENV, self.postSeasonGiftSendCount = gPinnacleMatchType.NONE, gPinnacleMatchType.NONE, 0
	_ENV, self.historyPBLTop16Group, _ENV, self.postSeasonBattleTime, _ENV, self.postSeasonBattleFinishTime = gPinnacleMatchType.NONE, gPinnacleMatchType.NONE, gPinnacleMatchType.NONE, gPinnacleMatchType.NONE, gPinnacleMatchType.NONE, 0
	gPinnacleMatchType.NONE[gGloryRankTypeDef.DARK_HORSE_RANK], _ENV = nil, nil
	gPinnacleMatchType.NONE[gGloryRankTypeDef.NEWBIE_LEGION], _ENV = nil, nil
	gPinnacleMatchType.NONE[gGloryRankTypeDef.POWER_TOP_4_LEGION], _ENV = nil, nil
	self.praiseData, _ENV, self.historyPBLGroupContent, _ENV, self.historyPBLGroupMemberSum, _ENV, self.historyPBLRank, gPinnacleMatchType.NONE[gGloryRankTypeDef.ALSTAR_PLAYER], _ENV = gPinnacleMatchType.NONE, gPinnacleMatchType.NONE, gPinnacleMatchType.NONE, gPinnacleMatchType.NONE, gPinnacleMatchType.NONE, gPinnacleMatchType.NONE, gPinnacleMatchType.NONE
	self.seasonStartTime = 0
	self.applyLegionNum = 512
	self.postSeasonAllianceInfoCache, _ENV, self.postSeasonAllianceState = gPinnacleSeasonState.NOT_APPLY, gPinnacleSeasonState.NOT_APPLY, gPinnacleSeasonState.NOT_APPLY
	self.showResult = false
	self.pblPoint = 0
	self.groupId = 1
	self.xxsStatus = 0
	self.legionInfoList, _ENV, self.groupid = gPinnacleSeasonState.NOT_APPLY, gPinnacleSeasonState.NOT_APPLY, 0
end
function pyramidWarCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_REGULAR_SEASON_APPLY, handler(self, self.regularSeasonApplyRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_APPOINT, handler(self, self.pyramidwarAppointRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_CANCEL_APPOINT, handler(self, self.pyramidwarCancelAppointRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_ENTER, handler(self, self.pyramidwarEnterRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_REGULAR_SEASON_GET_APPLYINFO, handler(self, self.regularSeasonGetApplyInfoRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_GET_ALLIANCE_APPOINTINFO, handler(self, self.pyramidwarGetAppointInfoRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_REGULAR_SEASON_GET_BATTLE_RECORD, handler(self, self.regularSeasonGetBattleRecordRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_REGULAR_SEASON_GET_RANK, handler(self, self.regularSeasonGetRankRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_REGULAR_SEASON_GET_MATCH_ALLIANCE_INFO, handler(self, self.regularSeasonGetMatchAllianceInfoRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_REGULAR_SEASON_GET_MATCH_TOTAL_INFO, handler(self, self.regularSeasonGetMatchTotalInfoRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_POST_SEASON_APPLY, handler(self, self.postSeasonApplyRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_SEND_POST_SEASON_GIFT, handler(self, self.sendPostSeasonGiftRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_GET_POST_SEASON_TOP_ALLIANCE, handler(self, self.getPostSeasonTopAllianceRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_GET_POST_SEASON_TOP_GIFT_SEND_RECORD, handler(self, self.getPostSeasonTopGiftSendRecordRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_GET_WATCH_LIST_INFO, handler(self, self.getWatchListRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_GET_POST_SEASON_CHAMPION_LIST, handler(self, self.getHonourHistoryListRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_INITDATA, handler(self, self.getPwInitDataRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_XIAN_XIA_SAI_PLAYER_STATUS, handler(self, self.sendPwXianXiaSaiPlayerStatusRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_XIAN_XIA_SAI_ENTER, handler(self, self.sendPwXianXiaSaiEnterRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_XIAN_XIA_SAI_EXIT, handler(self, self.sendPwXianXiaSaiExitRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_NEW_SET_LEGION_CAPTAIN, handler(self, self.newSetLegionCaptainRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_NEW_CANCLE_LEGION_CAPTAIN, handler(self, self.newCancleLegionCaptainRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_NEW_REGULAR_SEASON_APPLY, handler(self, self.newRegularSeasonApplyRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_NEW_APPOINT, handler(self, self.newAppointRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_NEW_CANCEL_APPOINT, handler(self, self.newCancelAppointRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_NEW_SET_LEGION_NAME, handler(self, self.newSetLegionNameRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_NEW_GET_LEGION_DATA, handler(self, self.newGetLegionDataRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_NEW_QUERY_LEGION_TOTAL_RANK, handler(self, self.newQueryLegionTotalRankRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_NEW_QUERY_LEGIONLIST_RANK_DATA, handler(self, self.newQueryLegionlistRankDataRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_NEW_APPLY_PINNACLE_SEASON, handler(self, self.newApplyPinnacleSeasonRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_NEW_DRAW_GROUP_PINNACLE, handler(self, self.newDrawGroupPinnacleRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_NEW_DRAW_FINALLISTS_COMPETITION, handler(self, self.newDrawFinallistsCompetitionRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_NEW_GLORY_RANK, handler(self, self.newGloryRankRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_NEW_AREA_GROUP_DATA, handler(self, self.newAreaGroupDataRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_SET_LEGION_CONTENT, handler(self, self.setLegionContentRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_SET_PLAYER_CONTENT, handler(self, self.setPlayerContentRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_QUERY_GRLORY_LEGION_MEMBER_SUM, handler(self, self.queryGrloryLegionMemberSumRsp))
	msgCtrl.register(gCmd.CMD_PINNACLE_PRAISE_MODULE, gCmd.REQ_PINNACLE_PRAISE_INIT, handler(self, self.pinnaclePraiseInitRsp))
	msgCtrl.register(gCmd.CMD_PINNACLE_PRAISE_MODULE, gCmd.REQ_PINNACLE_PRAISE_PRAISED, handler(self, self.pinnaclePraisePraisedRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_MODULE, gCmd.REQ_PW_GET_IMPRINT, handler(self, self.setImprint))
	if IsArClient then
		self:sendPwXianXiaSaiPlayerStatusReq()
	end
end
function pyramidWarCtrl:Logout()
	pyramidWarCtrl.super.Logout(self)
	self:resetData()
end
function pyramidWarCtrl:addQueue(queuetype, starttime, totaltime, lefttime, data)
