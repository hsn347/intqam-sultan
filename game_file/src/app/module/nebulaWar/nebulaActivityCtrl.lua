local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local nebulaActivityCtrl = class("nebulaActivityCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local nebulaTowerLvDesRead = include("nebulaTowerLvDesRead")
function nebulaActivityCtrl:ctor(properties)
	nebulaActivityCtrl.super.ctor(self, properties)
	local constantRead = include("constantRead")
	gNebulaPalaceItemID = constantRead.getConstValue("NEBULA_WARS_BUILD_ITEM_CONSUME") or 311901
	self.kingdomRegionAndGropMap, nebulaActivityCtrl, self.regionData, nebulaActivityCtrl, self.activityID = gActivityTimeActivityID.NEBULA_REGION_ACTIVITY, gActivityTimeActivityID.NEBULA_REGION_ACTIVITY, gActivityTimeActivityID.NEBULA_REGION_ACTIVITY, gActivityTimeActivityID.NEBULA_REGION_ACTIVITY, gActivityTimeActivityID.NEBULA_REGION_ACTIVITY
end
function nebulaActivityCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEBULA_WAR_MGR_MODULE, gCmd.REQ_NEBULA_WAR_MGR_STATE_DATA, handler(self, self.reqStateDataRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_WAR_MGR_MODULE, gCmd.REQ_NEBULA_WAR_MGR_ENTER_BATTLEFIELD, handler(self, self.reqEnterBattlefieldRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_WAR_MGR_MODULE, gCmd.REQ_NEBULA_WAR_MGR_QUIT_BATTLEFIELD, handler(self, self.reqQuitBattlefieldRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_WAR_MGR_MODULE, gCmd.REQ_NEBULA_WAR_MGR_REGION_DATA, handler(self, self.reqRegionDataRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_WAR_MODULE, gCmd.REQ_NEBULA_WAR_DATA, handler(self, self.reqWarDataRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_WAR_MODULE, gCmd.REQ_NEBULA_WAR_PALACE_OCCUPY_LOG, handler(self, self.reqPalaceOccupyLogRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_WAR_MODULE, gCmd.REQ_NEBULA_WAR_PLAYER_RANK, handler(self, self.reqPlayerRankRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_WAR_MODULE, gCmd.REQ_NEBULA_WAR_ALL_RESULT, handler(self, self.reqAllResultRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_WAR_MODULE, gCmd.REQ_NEBULA_WAR_SINGLE_RESULT, handler(self, self.reqSingleResultRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_WAR_MODULE, gCmd.REQ_NEBULA_WAR_SCORE_REWARD, handler(self, self.reqScoreRewardRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_WAR_MODULE, gCmd.REQ_NEBULA_WAR_CAMP_SCORE, handler(self, self.reqCampScoreRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_WAR_MODULE, gCmd.REQ_NEBULA_WAR_PLAYER_HIST, handler(self, self.reqPlayerHistRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_TOWER_MODULE, gCmd.REQ_NEBULA_TOWER_MODULE_INIT, handler(self, self.reqTowerInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_TOWER_MODULE, gCmd.REQ_NEBULA_TOWER_MODULE_GROUP_DATA, handler(self, self.reqTowerGroupRsp))
	self:reqStateData()
	self:registerNotify()
	self:resetData()
end
function nebulaActivityCtrl:Logout()
	nebulaActivityCtrl.super.Logout(self)
	self:resetData()
end
function nebulaActivityCtrl:resetData()
	_ENV, self.campBuffList, _ENV, self.warData, _ENV, self.stateBeginTime, _ENV, self.stateData, _ENV, self.initData, _ENV = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	;(nil).dailyExp = 0
	;(nil).exp = 0
	;(nil).isLock = false
	self.towerBuffList, _ENV, self.towerData, (nil).level = nil, nil, nil, 0
	self.isBettleEnd = false
	local teamCtrl = SoraDGetCtrl("teamCtrl")
	self.myTeamInfo = teamCtrl:getTeamNebula()
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	cityCtrl.resCalculate:initNebulaTowerAdd()
end
function nebulaActivityCtrl:initClientData(data, player)
	_ENV = nil
	;(nil).data = data
	;(nil).player = player
	dump(nil, "nebulaActivityCtrl:initClientData", 10)
	if not data then
		return
	end
	if data.nebulaRegionData then
		self:updateNebulaRegionData(data.nebulaRegionData)
		data.nebulaRegionData = nil
	else
		self:reqRegionData()
	end
	if data.nebulaRegionStateData then
		self:updateNebulaRegionStateData(data.nebulaRegionStateData)
		data.nebulaRegionStateData = nil
	end
	self.initData = data
	if player then
		self.warData.player = player
	end
	self:sendReqInitDataMsg()
end
function nebulaActivityCtrl:isNebulaActivityOpen()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		return true
	end
	local curState = self:getActivityCurState()
	if curState ~= NEBULA_REGION_STATE.NONE and curState ~= NEBULA_REGION_STATE.FINISH then
		return true
	end
	return false
end
function nebulaActivityCtrl:isExchangeShopOpen()
	local nebulaWarRead = include("nebulaWarRead")
	return nebulaWarRead.getExchangeShopTime() > 0
end
function nebulaActivityCtrl:registerNotify()
	local notifyCtrl = SoraDGetCtrl("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEBULA_WAR, handler(self, self.notifyHandler))
	self.handle_notify2 = notifyCtrl:register(gNotifyID.NEBULA_TOWER, handler(self, self.towerNotifyHandler))
end
function nebulaActivityCtrl:notifyHandler(event)
	dump(event.data, "nebulaActivityCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		if notifyType == "refreshData" then
		elseif notifyType == "updateNebulaRegionStateData" then
			self:updateNebulaRegionStateData(notifyData)
			self:setStateBeginTime()
			if notifyData.season ~= self.initData.season or notifyData.round ~= self.initData.round then
				self.initData.season = notifyData.season
				self.initData.round = notifyData.round
			end
			_ENV = notifyData.round
			notifyData.round.msg = "MESSAGE_NEBULAWAR_REFRESH_DATA"
			SoraDSendMessage(notifyData.round)
			_ENV = notifyData.round
			notifyData.round.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			notifyData.round.activityID = self.activityID
			SoraDSendMessage(notifyData.round)
			self:updatePersonScore()
		elseif notifyType == "setCampBuffList" then
			self.campBuffList = notifyData
		elseif notifyType == "winWarWindow" then
			if worldMapDefine.isInNebula() then
				self.isBettleEnd = true
			end
			_ENV = nil
			;(nil).notifyData = notifyData
			uiManager:show("NebulaWarPlayerResult", nil)
		elseif notifyType == "setWarBuildingOwner" then
			local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
			kingdomMapCtrl:setWarBuildingOwner(worldMapDefine.currentMapKindomID, notifyData.buildId, notifyData.owner)
		elseif notifyType == "nebulaRegionData" then
			self:updateNebulaRegionData(notifyData)
		elseif notifyType == "setPlayer" then
			self.warData.player = notifyData
			_ENV = self
			self.msg = "MESSAGE_NEBULAWAR_SCORE_UPDATE"
			SoraDSendMessage(self)
			if self:getScoreStatusAndNum() then
				_ENV = self
				self.msg = "MESSAGE_NEBULAWAR_SCORE_REWARD_UPDATE"
				SoraDSendMessage(self)
			end
		end
	end
end
function nebulaActivityCtrl:towerNotifyHandler(event)
	dump(event.data, "nebulaActivityCtrl:towerNotifyHandler", 10)
	for _, content in ipairs(event.data) do
		self.towerData = content
		if self.towerData.isLock then
			_ENV = self.towerData.isLock
			if self.towerData.isLock then
				goto lbl_22
			end
		end
		::lbl_22::
		self.towerBuffList = nebulaTowerLvDesRead.queryBuffData(self.towerData.level)
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		cityCtrl.resCalculate:initNebulaTowerAdd()
		_ENV = cityCtrl.resCalculate
		cityCtrl.resCalculate.msg = "MESSAGE_NEBULA_GET_TOWER_DATA"
		cityCtrl.resCalculate.rspdata = content
		SoraDSendMessage(cityCtrl.resCalculate)
	end
end
function nebulaActivityCtrl:setStateBeginTime(...)
	self.stateBeginTime, _ENV = nil, nil
	local timeConfig = self.stateData.timeConfig
	if not timeConfig then
		return
	end
	self.stateBeginTime[NEBULA_REGION_STATE.SCREEN_SEED_KINGDOM] = self.stateData.activeTime
	self.stateBeginTime[NEBULA_REGION_STATE.SCREEN_OTHER_KINGDOM] = timeConfig.screenOtherKingdomTime
	self.stateBeginTime[NEBULA_REGION_STATE.REGION_SHOW] = timeConfig.regionShowTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND1MATCH] = timeConfig.round1MatchTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND1TEAM] = timeConfig.round1TeamTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND1FOMATION] = timeConfig.round1FomationTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND1ROOM] = timeConfig.round1RoomTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND1BATTLE] = timeConfig.round1BattleTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND1END] = timeConfig.round1EndTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND2MATCH] = timeConfig.round2MatchTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND2TEAM] = timeConfig.round2TeamTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND2FOMATION] = timeConfig.round2FomationTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND2ROOM] = timeConfig.round2RoomTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND2BATTLE] = timeConfig.round2BattleTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND2END] = timeConfig.round2EndTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND3MATCH] = timeConfig.round3MatchTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND3TEAM] = timeConfig.round3TeamTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND3FOMATION] = timeConfig.round3FomationTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND3ROOM] = timeConfig.round3RoomTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND3BATTLE] = timeConfig.round3BattleTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND3END] = timeConfig.round3EndTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND4MATCH] = timeConfig.round4MatchTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND4TEAM] = timeConfig.round4TeamTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND4ROOM] = timeConfig.round4RoomTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND4BATTLE] = timeConfig.round4BattleTime
	self.stateBeginTime[NEBULA_REGION_STATE.ROUND4END] = timeConfig.round4EndTime
	self.stateBeginTime[NEBULA_REGION_STATE.SETTLE] = timeConfig.settleTime
	self.stateBeginTime[NEBULA_REGION_STATE.FINISH] = timeConfig.finishTime
end
function nebulaActivityCtrl:getStateBeginTime(state)
	return self.stateBeginTime[state] or 0
end
function nebulaActivityCtrl:sendReqInitDataMsg()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local state = activityShowCtrl:getStateByID(self.activityID)
	if clientEventMgr.judgeIsOnShow(state) then
		self.myTeamInfo:reqTeamInitData()
		self:reqStateData()
		self:reqTowerInit()
	end
	local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
	nebulaMileStoneCtrl:sendDataMsg()
end
function nebulaActivityCtrl:reqStateData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEBULA_WAR_MGR_MODULE, gCmd.REQ_NEBULA_WAR_MGR_STATE_DATA, nil)
end
function nebulaActivityCtrl:reqEnterBattlefield()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEBULA_WAR_MGR_MODULE, gCmd.REQ_NEBULA_WAR_MGR_ENTER_BATTLEFIELD, nil)
end
function nebulaActivityCtrl:reqQuitBattlefield()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEBULA_WAR_MGR_MODULE, gCmd.REQ_NEBULA_WAR_MGR_QUIT_BATTLEFIELD, nil)
end
function nebulaActivityCtrl:reqRegionData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEBULA_WAR_MGR_MODULE, gCmd.REQ_NEBULA_WAR_MGR_REGION_DATA, nil)
end
function nebulaActivityCtrl:reqRegionDataRsp(content)
	dump(content, "nebulaActivityCtrl:reqRegionDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:updateNebulaRegionData(content.rspdata)
	end
end
function nebulaActivityCtrl:updateNebulaRegionData(regionData)
