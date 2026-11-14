local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local nebulaAllStarCtrl = class("nebulaAllStarCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local nebulaAllStarRead = include("nebulaAllStarRead")
local NEBULA_ALL_STAR_STATE = nebulaAllStarRead.NEBULA_ALL_STAR_STATE
local RANK_TYPE = nebulaAllStarRead.NEBULA_ALLSTAR_WAR_PLAYER_RANK_TYPE
function nebulaAllStarCtrl:ctor(properties)
	nebulaAllStarCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY
end
local _CMD_BASE = gCmd.CMD_NEBULA_ALL_STAR_MGR_MODULE
local _CMD_WAR = gCmd.CMD_NEBULA_ALLSTAR_WAR_MODULE
function nebulaAllStarCtrl:EnterGame()
	local cmd = _CMD_BASE
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALL_STAR_MGR_INIT_DATA, handler(self, self.reqInitDataRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALL_STAR_SIGN_UP_BACKUP, handler(self, self.reqSignUpBackupRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALL_STAR_CANCEL_BACKUP, handler(self, self.reqCancelBackupRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALL_STAR_MGR_ENTER_ROOM, handler(self, self.reqEnterRoomRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALL_STAR_MGR_QUIT_ROOM, handler(self, self.reqQuitRoomRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALL_STAR_DONATE_GOLD, handler(self, self.reqDonateGoldRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALL_STAR_DONATE_REWARD, handler(self, self.reqDonateRewardRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALL_STAR_CURE_ARMY, handler(self, self.reqCureArmyRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALL_STAR_BUY_GIFT, handler(self, self.reqBuyGiftRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALL_STAR_BACKUP_RANK, handler(self, self.reqBackupRankRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALL_STAR_DONATE_DATA, handler(self, self.reqDonateDataRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALL_SET_DEFEND_ARMY, handler(self, self.reqSetDefendArmyRsp))
	local cmd = _CMD_WAR
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALLSTAR_WAR_DATA, handler(self, self.reqWarDataRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALLSTAR_WAR_PLAYER_DATA, handler(self, self.reqPlayerDataRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALLSTAR_WAR_ENERGY_EXCHANGE_BUFF, handler(self, self.reqExchangeBuffRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALLSTAR_WAR_ENERGY_DATA, handler(self, self.reqEnergyDataRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALLSTAR_WAR_PLAYER_RECV_GIFT_RECORD, handler(self, self.reqRecvGiftRecordRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALLSTAR_WAR_PLAYER_RECV_GIFT_RANK, handler(self, self.reqRecvGiftRankRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALLSTAR_WAR_PLAYER_ROB_TASK_REWARD, handler(self, self.reqRobTaskRewardRsp))
	msgCtrl.register(cmd, gCmd.REQ_NEBULA_ALLSTAR_WAR_CAMP_BUILDING_COUNT, handler(self, self.reqCampBuildingCountRsp))
	_UPVALUE4_ = msgCtrl.register
	self.rankCmdList, msgCtrl.register[1] = msgCtrl.register, gCmd.REQ_NEBULA_ALLSTAR_WAR_CAMP_OCCUPY_RANK
	self.rankCmdList, msgCtrl.register[2] = msgCtrl.register, gCmd.REQ_NEBULA_ALLSTAR_WAR_PLAYER_RANK
	self.rankCmdList, msgCtrl.register[3] = msgCtrl.register, gCmd.REQ_NEBULA_ALLSTAR_WAR_VIEWER_COLLECT_SPOIL_RANK
	self.rankCmdList, msgCtrl.register[4] = msgCtrl.register, gCmd.REQ_NEBULA_ALLSTAR_WAR_CAMP_COLLECT_SPOIL_RANK
	for __, subcmd in ipairs(self.rankCmdList) do
		msgCtrl.register(cmd, subcmd, handler(self, self.reqRankDataRsp))
	end
	msgCtrl.register(_CMD_BASE, gCmd.REQ_NEBULA_ALL_STAR_RECIVE_GIFT, handler(self, self.reqViewerReciveGiftRsp))
	msgCtrl.register(_CMD_BASE, gCmd.REQ_NEBULA_ALL_STAR_GET_GIFT_INFO, handler(self, self.reqViewerGiftInfoRsp))
	msgCtrl.register(_CMD_WAR, gCmd.REQ_NEBULA_ALLSTAR_WAR_VIEWER_SYNC, handler(self, self.reqViewerSyncRsp))
	msgCtrl.register(_CMD_WAR, gCmd.REQ_NEBULA_ALLSTAR_WAR_VIEWER_STOP_SYNC, handler(self, self.reqViewerStopSyncRsp))
	msgCtrl.register(_CMD_WAR, gCmd.REQ_NEBULA_ALLSTAR_WAR_VIEWER_COLLECT_SPOIL, handler(self, self.reqViewerCollectSpoilRsp))
	msgCtrl.register(_CMD_WAR, gCmd.REQ_NEBULA_ALLSTAR_WAR_VIEWER_GIVE_GIFT, handler(self, self.reqViewerGiveGiftRsp))
	msgCtrl.register(_CMD_WAR, gCmd.REQ_NEBULA_ALLSTAR_WAR_VIEWER_QUIZ_BET, handler(self, self.reqViewerQuizRsp))
	msgCtrl.register(_CMD_WAR, gCmd.REQ_NEBULA_ALLSTAR_WAR_VIEWER_QUIZ_BET_RECORD, handler(self, self.reqViewerQuizRecordRsp))
	msgCtrl.register(_CMD_WAR, gCmd.REQ_NEBULA_ALLSTAR_WAR_VIEWER_EXCHANGE, handler(self, self.reqViewerExchangeRsp))
	msgCtrl.register(_CMD_WAR, gCmd.REQ_NEBULA_ALLSTAR_WAR_VIEWER_EXCHANGE_RECORD, handler(self, self.reqViewerExchangeRecordRsp))
	msgCtrl.register(_CMD_WAR, gCmd.REQ_NEBULA_ALLSTAR_WAR_VIEWER_EXCHANGE_REMIND, handler(self, self.reqViewerExchangeRemindRsp))
	self:resetData()
	self:registerNotify()
end
function nebulaAllStarCtrl:Logout()
	nebulaAllStarCtrl.super.Logout(self)
	self:resetData()
end
function nebulaAllStarCtrl:resetData()
	_ENV = nil
	;(nil).isSingUpBackupGroup = false
	;(nil).season = 0
	;(nil).totalArmy = 0
	;(nil).woundedArmy = 0
	_ENV, (nil).lastSignUpTime = nil, 0
	;(nil).donateGold = 0
	;(nil).rewardInfo, _ENV, (nil).resetTime = nil, nil, 0
	;(nil).todayGold = 0
	;(nil).giftRecord, _ENV, (nil).donateInfo, (nil).totalGold = nil, nil, nil, 0
	_ENV, self.initData, (nil).armyid = nil, nil, 0
	;(nil).season = 1
	;(nil).curState = 1
	self.player, _ENV, self.campBuffMap, _ENV, self.campData, _ENV, self.energyData, _ENV, self.warData, _ENV, self.stateData, (nil).allStarTeamInfo, _ENV, (nil).timeConfig, _ENV, (nil).kingdoms, _ENV, (nil).regionIds, _ENV, (nil).activeTime = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0
	self.initEnergyData, _ENV, self.isBettleEnd = nil, nil, false
	;(nil).collector, _ENV, (nil).campData, _ENV, _ENV, self.isViewer = nil, nil, nil, nil, nil, false
	self.viewerData, (nil).quizBet, _ENV, (nil).warData, _ENV, (nil).warBuildingOwnerMap, _ENV, (nil).spoilMap, _ENV, (nil).quizExchange, _ENV, (nil).quizCoin = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0
	local teamCtrl = SoraDGetCtrl("teamCtrl")
	local teamDef = include("teamDef")
	local teamAreaEnum = teamDef.teamAreaEnum
	self.myTeamInfo = teamCtrl:getTeamData(teamAreaEnum.NEBULA_ALL_STAR)
	self:updateSpoilQueueData()
end
function nebulaAllStarCtrl:initClientData(data1, data2)
	_ENV = nil
	;(nil).data1 = data1
	;(nil).data2 = data2
	dump(nil, "==nebulaAllStarCtrl:initClientData==", 10)
	if data1 and data1.teamId then
		_ENV = "==nebulaAllStarCtrl:initClientData=="
		_ENV, ("==nebulaAllStarCtrl:initClientData==").tid = data1.teamId, data1.teamId
		;("==nebulaAllStarCtrl:initClientData==").setting, data1.teamId.isSuperTeam = data1.teamId, data1.isSuperTeam
		self.myTeamInfo:setMyTeamInfo("==nebulaAllStarCtrl:initClientData==")
	end
	if data2 then
		self.initEnergyData = data2
		if data2.viewerSync then
			self.isViewer = true
			nebulaAllStarCtrl:reqViewerSync(true)
		end
	end
	self:sendReqInitDataMsg()
end
function nebulaAllStarCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.NEBULA_ALL_STAR, handler(self, self.notifyHandler))
	notifyCtrl:register(gNotifyID.NEBULA_ALLSTAR_WAR, handler(self, self.notifyHandlerWar))
end
function nebulaAllStarCtrl:notifyHandler(event)
	dump(event.data, "==nebulaAllStarCtrl:notifyHandler==", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		if notifyType == "refreshData" then
			local totalArmy = self:getTotalArmy()
			local woundedArmy = self:getWoundedArmy()
			self.initData = notifyData
			if totalArmy ~= notifyData.totalArmy then
				_ENV = nil
				;(nil).msg = "MESSAGE_NEBULA_ALLSTAR_TOTAL_ARMY"
				SoraDSendMessage(nil)
			end
			if woundedArmy ~= notifyData.woundedArmy then
				_ENV = nil
				;(nil).msg = "MESSAGE_NEBULA_ALLSTAR_WOUNDED_ARMY"
				SoraDSendMessage(nil)
			end
		elseif notifyType == "updateNebulaAllStarStateData" then
			self.stateData = notifyData
			_ENV = self:getWoundedArmy()
			self:getWoundedArmy().msg = "MESSAGE_NEBULA_ALLSTAR_REFRESH_DATA"
			SoraDSendMessage((self:getWoundedArmy()))
		elseif notifyType == "buyGift" and notifyData.success then
			paymentManager.loopForFinishTransaction()
			local reward = notifyData.reward
			local rid = notifyData.rid
			local record = self:getGiftCount(rid)
			self.initData.giftRecord[tostring(rid)] = record + 1
			_ENV = tostring(rid)
			_ENV, tostring(rid).msg = record + 1, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
			;(record + 1).result = true
			;(record + 1).rid = rid
			tostring(rid).data, (record + 1).itemList = record + 1, reward
			SoraDSendMessage((tostring(rid)))
		end
	end
end
function nebulaAllStarCtrl:notifyHandlerWar(event)
