local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local roaringFlameWarCtrl = class("roaringFlameWarCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
function roaringFlameWarCtrl:ctor(properties)
	roaringFlameWarCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY
	self:resetData()
end
function roaringFlameWarCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_STATE_DATA, handler(self, self.reqStateDataRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_ENTER_BATTLEFIELD, handler(self, self.reqEnterBattlefieldRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_QUIT_BATTLEFIELD, handler(self, self.reqQuitBattlefieldRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_GET_MANAGER_INFO, handler(self, self.reqGetManagerInfoRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_MODIFY_MANAGER, handler(self, self.reqModifyManagerRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_ADD_LV0_USER, handler(self, self.reqAddLv0UserRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_REMOVE_LV0_USER, handler(self, self.reqRemoveLv0UserRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_GET_LV0_LIST, handler(self, self.reqGetLv0ListRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_RESEARCH_TECH, handler(self, self.reqResearchTechRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_MATCH_RESULT, handler(self, self.reqMatchResultRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_WEEKLY_REWARDS, handler(self, self.reqWeeklyRewardsRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_TECHNOLOGY_REWARD, handler(self, self.reqTechnologyRewardRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_INIT_DATA, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_RELEASE_NOTICE, handler(self, self.reqReleaseNoticeRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_QUEST_REWARD, handler(self, self.reqQuestRewardRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_TURN_STAGE, handler(self, self.reqTurnStageRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_DECREE_REWARD, handler(self, self.reqDecreeRewardRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_DECREE_GIFT, handler(self, self.reqDecreeGiftRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_MILE_STONE_REWARD, handler(self, self.reqMileStoneRewardRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_SET_KICK_FLAG, handler(self, self.reqSetKickFlagRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_SKILL_LOTTERY, handler(self, self.reqSkillLotteryRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_SKILL_REPLACE, handler(self, self.reqSkillReplaceRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_SKILL_USE, handler(self, self.reqSkillUseRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_SELECT_SKILL, handler(self, self.reqSelectSkillRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_DATA, handler(self, self.reqWarDataRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_FREE_OCCUPY, handler(self, self.reqFreeOccupyRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_COMPLETE_PHOENIX_TASK, handler(self, self.reqCompletePhoenixTaskRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_COLLECT, handler(self, self.reqCollectRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_STOP_COLLECT, handler(self, self.reqStopCollectRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_CAMP_OCCUPY_LOG, handler(self, self.reqCampOccupyLogRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_PHOENIX_LIST, handler(self, self.reqPhoenixListRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_CAMP_OCCUPY_LIST, handler(self, self.reqCampOccupyListRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_RECEIVE_FIRST_OCCUPY_BOX, handler(self, self.reqReceiveOccupyBoxRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_SEASON_RECORD, handler(self, self.reqSeasonRecordRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_RANKLIST, handler(self, self.reqRankListRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_BACK_PLAYER, handler(self, self.reqBackPlayerRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_CREATE_CAVE, handler(self, self.reqCreateCaveRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_EXPLORE_CAVE, handler(self, self.reqExploreCaveRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_RECEIVE_CAVE_TREASURE, handler(self, self.reqReceiveCaveTreasureRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_CAMP_CAVE_LIST, handler(self, self.reqCampCaveListRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_CAVE_DATA, handler(self, self.reqCaveDataRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_CAMP_MANAGE_DATA, handler(self, self.reqCampManageDataRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_SET_NEW, handler(self, self.reqSetActivityNewRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_BUILDING_OWNER_DATA, handler(self, self.reqBuildingOwnerDataRsp))
	msgCtrl.register(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_KICK_PLAYER, handler(self, self.reqKickPlayerRsp))
	self:registerNotify()
end
function roaringFlameWarCtrl:Logout()
	roaringFlameWarCtrl.super.Logout(self)
	self:resetData()
end
function roaringFlameWarCtrl:resetData()
	_ENV = nil
	;(nil).kingdoms, _ENV, (nil).curState = ROARING_FLAME_WAR_STATE.NONE, ROARING_FLAME_WAR_STATE.NONE, ROARING_FLAME_WAR_STATE.NONE
	_ENV, self.matchResult, _ENV, self.stateData, (nil).timeConfig, _ENV, (nil).matchResult, _ENV, (nil).mapId = nil, nil, nil, nil, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START
	;(nil).permission, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START.managers, _ENV, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START.lv0UserList, _ENV, _ENV, (nil).notice, _ENV, (nil).mileStoneData, _ENV, (nil).decreeGiftUserNum = GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, nil, nil, nil, nil, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, 0
	_ENV, (nil).decreeGiftUserNum = GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, 0
	;(nil).mileStone, _ENV, (nil).technologyReward, _ENV, _ENV, self.kingdomFlameWarData, (nil).technology, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START.researching, _ENV, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START.complete, _ENV, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START.point = GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, nil, nil, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, nil, nil, nil, nil, 0
	_ENV, (nil).weeklyResetTime = GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, nil
	GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START.curExp = 0
	GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START.isSeniorRewardLock = false
	GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START.normalRewardLv = 0
	GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START.seniorRewardLv = 0
	GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START.giftNormalIdx = 0
	_ENV, (nil).weeklyQuestData, _ENV, (nil).seasonQuestData, _ENV, (nil).skill, _ENV, (nil).decree, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START.giftSeniorIdx = GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, 0
	GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START.getedDay = 0
	_ENV, (nil).weeklyGift, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START.isBuy = GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, false
	;(nil).usedSkills, _ENV, (nil).candidateSkill, _ENV, (nil).skillSlot, _ENV, _ENV, self.playerFlameWarData, (nil).turntable, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START.stageRewards, _ENV, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START.times = GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, nil, nil, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, nil, nil, 0
	;(nil).isPrivilegeLock = false
	;(nil).lotteryTimes = 0
	self.skillData, (nil).floorSelectTimes = nil, 0
	self.leftReceiveCaveCount = 0
	self.warData, (nil).warData, _ENV, (nil).caveList, _ENV, (nil).resMap, _ENV, (nil).player, _ENV, (nil).campInfo, _ENV, _ENV, self.caveList = nil, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START, nil, nil
end
function roaringFlameWarCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ROARING_FLAME_WAR, handler(self, self.notifyHandler))
end
function roaringFlameWarCtrl:notifyHandler(event)
	dump(event.data, "roaringFlameWarCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		if notifyType == "updateRoaringFlameWarStateData" then
			self.stateData = notifyData
			_ENV = nil
			;(nil).msg = "MESSAGE_ROARINGFLAMEWAR_STATEDATA"
			SoraDSendMessage(nil)
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			;(nil).activityID = self.activityID
			SoraDSendMessage(nil)
		elseif notifyType == "refreshData" then
			if notifyData.kingdomFlameWarData then
				self.kingdomFlameWarData = notifyData.kingdomFlameWarData
			end
			if notifyData.playerFlameWarData then
				self.playerFlameWarData = notifyData.playerFlameWarData
				self.skillData = self.playerFlameWarData.skill
			end
			_ENV = nil
			;(nil).msg = "MESSAGE_ROARINGFLAMEWAR_REFRESHDATA"
			SoraDSendMessage(nil)
			_ENV = nil
			;(nil).msg = "MESSAGE_ROARINGFLAMEWAR_TECHNOLOGY"
			SoraDSendMessage(nil)
		elseif notifyType == "buyGift" then
			if notifyData.initData then
				self.playerFlameWarData = notifyData.initData
				self.skillData = self.playerFlameWarData.skill
			end
			_ENV = nil
			;(nil).msg = "MESSAGE_ROARINGFLAMEWAR_BUYGIFT"
			;(nil).rid = notifyData.rid
			;(nil).success = notifyData.success
			SoraDSendMessage(nil)
		elseif notifyType == "battleEndPlayerRecord" then
			_ENV = nil
			;(nil).resultData = notifyData
			uiManager:show("RoaringFlameWar_Result", nil)
		elseif notifyType == "setWarData" then
			self.warData.warData = notifyData
			_ENV = uiManager
			uiManager.msg = "MESSAGE_ROARINGFLAMEWAR_WARDATA"
			SoraDSendMessage(uiManager)
		elseif notifyType == "showSeasonRecord" then
			uiManager:show("RoaringFlameReview_1")
		elseif notifyType == "setFreeOccupyCount" then
			local campInfo = self:getCampInfoByCamp()
			campInfo.freeOccupyCount = notifyData
		elseif notifyType == "setKickPlayerCount" then
			local campInfo = self:getCampInfoByCamp()
			campInfo.kickPlayerCount = notifyData
			_ENV = "RoaringFlameReview_1"
			;("RoaringFlameReview_1").msg = "MESSAGE_ROARINGFLAMEWAR_KICKPLAYERCOUNT"
			SoraDSendMessage("RoaringFlameReview_1")
		elseif notifyType == "setResMap" then
			self.warData.resMap = notifyData
			_ENV = SoraDSendMessage
			SoraDSendMessage.msg = "MESSAGE_ROARINGFLAMEWAR_COLLECT"
			SoraDSendMessage(SoraDSendMessage)
		elseif notifyType == "setCampOccupyPalaceSecs" then
			local info = self:getCampInfoByCamp(notifyData.camp)
			info.occupyPalaceSecs = notifyData.occupyPalaceSecs
			info.occupyPalaceEndTime = notifyData.occupyPalaceEndTime
			_ENV = notifyData.camp
			notifyData.camp.msg = "MESSAGE_ROARINGFLAMEWAR_OCCUPY_NOTIFY"
			notifyData.camp.notifyType = notifyType
			notifyData.camp.subType = gWorldTypeServerDef.subTypeRoaringFlameWarPalace
			notifyData.camp.camp = notifyData.camp
			SoraDSendMessage(notifyData.camp)
		elseif notifyType == "setWarBuildingOwner" then
			local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
			kingdomMapCtrl:setWarBuildingOwner(worldMapDefine.currentMapKindomID, notifyData.buildId, notifyData.owner)
			local roaringFlameWarUtil = include("roaringFlameWarUtil")
			roaringFlameWarUtil.sendMessageUpdateLegaueManor(notifyData.buildId, notifyData.owner)
			local subType = roaringFlameWarRead.getBuildSubType(notifyData.buildId)
			_ENV = notifyData.owner
			notifyData.owner.msg = "MESSAGE_ROARINGFLAMEWAR_OCCUPY_NOTIFY"
			notifyData.owner.notifyType = notifyType
			notifyData.owner.subType = subType
			SoraDSendMessage(notifyData.owner)
		elseif notifyType == "byBackPlayerToBornArea" then
			local buildId = notifyData.buildId
			if buildId then
				local pos = roaringFlameWarRead.getBuildCoord(buildId)
				_ENV = notifyData.owner
				notifyData.owner.x = pos.x
				notifyData.owner.y = pos.y
				local posStr = i18n("common_text_2155", notifyData.owner)
				_ENV = nil
				;(nil).xy = posStr
				SoraDShowMsgBox(i18n("flames_dunes_text256", nil))
			end
			local name = notifyData.name
			if name then
				_ENV = i18n("flames_dunes_text256", nil)
				i18n("flames_dunes_text256", nil).name = name
				SoraDShowMsgBox(i18n("flames_dunes_text250", i18n("flames_dunes_text256", nil)))
			end
		elseif notifyType == "questProgressUpdate" then
			local taskType = roaringFlameWarRead.getTaskTypeByTaskID(notifyData.questID)
			local dataKey = taskType == 1 and "weeklyQuestData" or "seasonQuestData"
			if not self.playerFlameWarData[dataKey].questProgress then
				self.playerFlameWarData[dataKey].questProgress, _ENV = i18n("flames_dunes_text250", i18n("flames_dunes_text256", nil))
			end
			self.playerFlameWarData[dataKey].questProgress[tostring(notifyData.questID)] = notifyData.progress
			if notifyData.isFinish then
				if not self.playerFlameWarData[dataKey].finishedQuest then
					self.playerFlameWarData[dataKey].finishedQuest, _ENV = tostring(notifyData.questID), tostring(notifyData.questID)
				end
				self.playerFlameWarData[dataKey].finishedQuest[tostring(notifyData.questID)] = 1
			end
			_ENV = tostring(notifyData.questID)
			tostring(notifyData.questID).msg = "MESSAGE_ROARINGFLAMEWAR_QUESTREWARD"
			SoraDSendMessage((tostring(notifyData.questID)))
		elseif notifyType == "updateCave" then
			local caveList = self:getCaveList()
			for i, v in ipairs(caveList) do
				if v.caveId == notifyData.caveId then
					caveList[i] = notifyData
					break
				end
			end
			self.warData.caveList = caveList
			_ENV = ipairs(caveList)
			ipairs(caveList).msg = "MESSAGE_ROARINGFLAMEWAR_COLLECT"
			SoraDSendMessage(ipairs(caveList))
		elseif notifyType == "deleteCave" then
			local caveData
			for k, v in ipairs(self.warData.caveList) do
				if v.caveId == notifyData.caveId then
					caveData = table.remove(self.warData.caveList, k)
					break
				end
			end
			if self.caveList then
				for k, v in ipairs(self.caveList) do
					if v.caveId == notifyData.caveId then
						table.remove(self.caveList, k)
						break
					end
				end
			end
			_ENV = ipairs(self.caveList)
			ipairs(self.caveList).msg = "MESSAGE_ROARINGFLAMEWAR_COLLECT"
			SoraDSendMessage(ipairs(self.caveList))
			if caveData then
				_ENV = ipairs(self.caveList)
				ipairs(self.caveList).msg = "MESSAGE_ROARINGFLAMEWAR_COLLECT_MOVELINE"
				ipairs(self.caveList).qType = 2
				ipairs(self.caveList).data = caveData
				ipairs(self.caveList).isBack = true
				SoraDSendMessage(ipairs(self.caveList))
			end
		elseif notifyType == "setMoveCityCDEndTime" then
			self:setMoveCityCDEndTime(notifyData.moveCityCDEndTime)
		elseif notifyType == "notifyPalaceFinishOccupy" then
			_ENV = ipairs(self.caveList)
			ipairs(self.caveList).notifyData = notifyData
			uiManager:show("RoaringFlameBattlefieldPop", ipairs(self.caveList))
		elseif notifyType == "palaceUnLock" then
			_ENV = ipairs(self.caveList)
			ipairs(self.caveList).buildId = notifyData.buildId
			uiManager:show("RoaringFlameBattlefieldUnlock", ipairs(self.caveList))
		elseif notifyType == "setUseSpeedItemCount" then
			self:setUseSpeedItemCount(notifyData)
		elseif notifyType == "setWeekMonsterScore" then
			self:setWeekMonsterScore(notifyData)
		elseif notifyType == "setKickFlag" and not worldMapDefine.inInCrossWar() then
			self:checkShowKickPopup()
		end
	end
end
function roaringFlameWarCtrl:sendReqInitDataMsg(...)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local state = activityShowCtrl:getStateByID(self.activityID)
	if clientEventMgr.judgeIsOnShow(state) then
		self:reqStateData()
		self:reqInitData()
		self:reqMatchResult()
	end
end
function roaringFlameWarCtrl:reqStateData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_STATE_DATA, nil)
end
function roaringFlameWarCtrl:reqStateDataRsp(content)
	dump(content, "roaringFlameWarCtrl:reqStateDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.stateData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ROARINGFLAMEWAR_STATEDATA"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		gErrDef.Err_None.activityID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
		if self.stateData.kickFlag then
			SoraDDelayCallOnce("roaringFlameWar_checkShowKickPopup", function()
				self:checkShowKickPopup()
			end, 2)
		end
	end
end
function roaringFlameWarCtrl:reqEnterBattlefield()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_ENTER_BATTLEFIELD, nil)
end
function roaringFlameWarCtrl:reqEnterBattlefieldRsp(content)
	dump(content, "roaringFlameWarCtrl:reqEnterBattlefieldRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	else
		uiManager:close("RoaringFlame_Switcher")
		if content.err == gErrDef.Err_ROARING_FLAME_WAR_PLAYER_LIMIT then
			SoraDShowMsgTip(i18n("flames_dunes_text350"))
		end
	end
end
function roaringFlameWarCtrl:reqQuitBattlefield()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_QUIT_BATTLEFIELD, nil)
end
function roaringFlameWarCtrl:reqQuitBattlefieldRsp(content)
	dump(content, "roaringFlameWarCtrl:reqQuitBattlefieldRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	else
		uiManager:close("RoaringFlame_Switcher")
	end
end
function roaringFlameWarCtrl:reqGetManagerInfo()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_GET_MANAGER_INFO, nil)
end
function roaringFlameWarCtrl:reqGetManagerInfoRsp(content)
	dump(content, "roaringFlameWarCtrl:reqGetManagerInfoRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ROARINGFLAMEWAR_GET_MANAGER_INFO"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function roaringFlameWarCtrl:reqModifyManager(idx, uid)
	serverproxy = nil
	;(nil).idx = idx
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_MODIFY_MANAGER, nil)
end
function roaringFlameWarCtrl:reqModifyManagerRsp(content)
	dump(content, "roaringFlameWarCtrl:reqModifyManagerRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ROARINGFLAMEWAR_GET_MANAGER_INFO"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function roaringFlameWarCtrl:reqAddLv0User(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_ADD_LV0_USER, nil)
end
function roaringFlameWarCtrl:reqAddLv0UserRsp(content)
	dump(content, "roaringFlameWarCtrl:reqAddLv0UserRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.lv0Map = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ROARINGFLAMEWAR_GET_LV0_LIST"
		gErrDef.Err_None.rspdata = self.lv0Map
		SoraDSendMessage(gErrDef.Err_None)
	elseif content.err == gErrDef.Err_FLAME_WAR_PERMISSION then
		SoraDShowMsgTip(i18n("notice_0205"))
	elseif content.err == gErrDef.Err_FLAME_WAR_IS_MANAGER then
		SoraDShowMsgTip(i18n("atlantiswar_text_0352"))
	elseif content.err == gErrDef.Err_FLAME_WAR_LV0_USER_NUM_LIMIT then
		SoraDShowMsgTip(i18n("atlantiswar_text_0353"))
	end
end
function roaringFlameWarCtrl:reqRemoveLv0User(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_REMOVE_LV0_USER, nil)
end
function roaringFlameWarCtrl:reqRemoveLv0UserRsp(content)
	dump(content, "roaringFlameWarCtrl:reqRemoveLv0UserRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.lv0Map = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ROARINGFLAMEWAR_GET_LV0_LIST"
		gErrDef.Err_None.rspdata = self.lv0Map
		SoraDSendMessage(gErrDef.Err_None)
	elseif content.err == gErrDef.Err_FLAME_WAR_PERMISSION then
		SoraDShowMsgTip(i18n("notice_0205"))
	end
end
function roaringFlameWarCtrl:reqGetLv0List()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_GET_LV0_LIST, nil)
end
function roaringFlameWarCtrl:reqGetLv0ListRsp(content)
	dump(content, "roaringFlameWarCtrl:reqGetLv0ListRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.lv0Map = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ROARINGFLAMEWAR_GET_LV0_LIST"
		gErrDef.Err_None.rspdata = self.lv0Map
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function roaringFlameWarCtrl:reqResearchTech(technologyId)
	serverproxy = nil
	;(nil).technologyId = technologyId
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_RESEARCH_TECH, nil)
end
function roaringFlameWarCtrl:reqResearchTechRsp(content)
	dump(content, "roaringFlameWarCtrl:reqResearchTechRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.kingdomFlameWarData.technology.complete = content.rspdata.complete
		self.kingdomFlameWarData.technology.point = content.rspdata.point
		self.kingdomFlameWarData.technology.researching = content.rspdata.researching
		_ENV = content.rspdata.researching
		content.rspdata.researching.msg = "MESSAGE_ROARINGFLAMEWAR_TECHNOLOGY"
		SoraDSendMessage(content.rspdata.researching)
	end
end
function roaringFlameWarCtrl:reqMatchResult()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_MATCH_RESULT, nil)
end
function roaringFlameWarCtrl:reqMatchResultRsp(content)
	dump(content, "roaringFlameWarCtrl:reqMatchResultRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.matchResult = content.rspdata
	else
		self.matchResult, _ENV = content.rspdata, content.rspdata
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ROARINGFLAMEWAR_MATCHRESULT"
	gErrDef.Err_None.err = content.err
	SoraDSendMessage(gErrDef.Err_None)
end
function roaringFlameWarCtrl:reqWeeklyRewards()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_WEEKLY_REWARDS, nil)
end
function roaringFlameWarCtrl:reqWeeklyRewardsRsp(content)
	dump(content, "roaringFlameWarCtrl:reqWeeklyRewardsRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if content.rspdata.weeklyGift then
			self.playerFlameWarData.weeklyGift = content.rspdata.weeklyGift
		end
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_ROARINGFLAMEWAR_CLAIMWEEKLY"
	SoraDSendMessage(SoraDMailGainItems)
end
function roaringFlameWarCtrl:reqTechnologyReward(technologyId, lv)
	serverproxy = nil
	;(nil).technologyId = technologyId
	;(nil).lv = lv or 1
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_TECHNOLOGY_REWARD, nil)
end
function roaringFlameWarCtrl:reqTechnologyRewardRsp(content)
	dump(content, "roaringFlameWarCtrl:reqTechnologyRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.playerFlameWarData = content.rspdata.playerFlameWarData
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ROARINGFLAMEWAR_TECHNOLOGY"
		SoraDSendMessage(rewards)
	end
end
function roaringFlameWarCtrl:reqInitData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_INIT_DATA, nil)
end
function roaringFlameWarCtrl:reqInitDataRsp(content)
	dump(content, "roaringFlameWarCtrl:reqInitDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.kingdomFlameWarData = rspdata.kingdomFlameWarData
		self.playerFlameWarData = rspdata.playerFlameWarData
		self.skillData = self.playerFlameWarData.skill
		_ENV = "roaringFlameWarCtrl:reqInitDataRsp(content)"
		;("roaringFlameWarCtrl:reqInitDataRsp(content)").msg = "MESSAGE_ROARINGFLAMEWAR_INITDATA"
		SoraDSendMessage("roaringFlameWarCtrl:reqInitDataRsp(content)")
	end
end
function roaringFlameWarCtrl:reqSkillLottery(idx)
	serverproxy = nil
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_SKILL_LOTTERY, nil)
end
function roaringFlameWarCtrl:reqSkillLotteryRsp(content)
	dump(content, "roaringFlameWarCtrl:reqSkillLotteryRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.skillData.lotteryTimes = rspdata.lotteryTimes
		self.skillData.candidateSkill = rspdata.candidateSkill
		self.skillData.skillSlot = rspdata.skillSlot
		self.skillData.floorSelectTimes = rspdata.floorSelectTimes
		_ENV = rspdata.floorSelectTimes
		rspdata.floorSelectTimes.msg = "MESSAGE_ROARINGFLAMEWAR_SKILL_LOTTERY"
		rspdata.floorSelectTimes.index = rspdata.idx
		SoraDSendMessage(rspdata.floorSelectTimes)
	end
end
function roaringFlameWarCtrl:reqSkillReplace(idx)
	serverproxy = nil
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_SKILL_REPLACE, nil)
end
function roaringFlameWarCtrl:reqSkillReplaceRsp(content)
	dump(content, "roaringFlameWarCtrl:reqSkillReplaceRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.skillData.candidateSkill = rspdata.candidateSkill
		self.skillData.skillSlot = rspdata.skillSlot
		_ENV = rspdata.skillSlot
		rspdata.skillSlot.msg = "MESSAGE_ROARINGFLAMEWAR_SKILL_REPLACE"
		rspdata.skillSlot.index = rspdata.idx
		SoraDSendMessage(rspdata.skillSlot)
	end
end
function roaringFlameWarCtrl:reqSkillUse(idx)
	serverproxy = nil
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_SKILL_USE, nil)
end
function roaringFlameWarCtrl:reqSkillUseRsp(content)
	dump(content, "roaringFlameWarCtrl:reqSkillUseRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.skillData.candidateSkill = rspdata.candidateSkill
		self.skillData.skillSlot = rspdata.skillSlot
		self.skillData.usedSkills = rspdata.usedSkills
		_ENV = rspdata.usedSkills
		rspdata.usedSkills.msg = "MESSAGE_ROARINGFLAMEWAR_SKILL_USE"
		rspdata.usedSkills.index = rspdata.idx
		SoraDSendMessage(rspdata.usedSkills)
		local skillSlot = self.skillData.skillSlot[tostring(rspdata.idx)]
		local cfg = roaringFlameWarRead.getSkillDisplayConfig(skillSlot.skillId)
		_ENV = nil
		;(nil).var = i18n(cfg.name)
		local msgStr = i18n("atlantiswar_skill_text_037", nil) .. "\n" .. i18n(cfg.describe)
		local iconSprite = roaringFlameWarRead.getSkillIconSprite(cfg.img, cfg.quality)
		local sOrder_enum = include("commonPromptTip").sOrder_enum
		_ENV = nil
		;(nil).offset = cc.p(0, 2)
		;(nil).sOrder = sOrder_enum.mapBuff
		SoraDShowMsgTip(msgStr, iconSprite, nil, nil)
	else
		SoraDShowMsgTip(i18n("endless_treasures_text_13"))
	end
end
function roaringFlameWarCtrl:reqSelectSkill(idx, skillId)
	serverproxy = nil
	;(nil).idx = idx
	;(nil).skillId = skillId
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_SELECT_SKILL, nil)
end
function roaringFlameWarCtrl:reqSelectSkillRsp(content)
	dump(content, "roaringFlameWarCtrl:reqSelectSkillRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.skillData.skillSlot = rspdata.skillSlot
		self.skillData.floorSelectTimes = rspdata.floorSelectTimes
		_ENV = rspdata.floorSelectTimes
		rspdata.floorSelectTimes.msg = "MESSAGE_ROARINGFLAMEWAR_SKILL_SELECT"
		rspdata.floorSelectTimes.index = rspdata.idx
		SoraDSendMessage(rspdata.floorSelectTimes)
	end
end
function roaringFlameWarCtrl:reqReleaseNotice(content)
	serverproxy = nil
	;(nil).content = content
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_RELEASE_NOTICE, nil)
end
function roaringFlameWarCtrl:reqReleaseNoticeRsp(content)
	dump(content, "roaringFlameWarCtrl:reqReleaseNoticeRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	elseif content.err == gErrDef.Err_FLAME_WAR_RELEASE_NOTICE_CD then
		SoraDShowMsgTip(i18n("flames_dunes_text89"))
	end
end
function roaringFlameWarCtrl:reqQuestRewardNotice(questID)
	serverproxy = nil
	;(nil).questID = questID
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_QUEST_REWARD, nil)
end
function roaringFlameWarCtrl:reqQuestRewardRsp(content)
	dump(content, "roaringFlameWarCtrl:reqQuestRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local questID = content.rspdata.questID
		if self.playerFlameWarData.weeklyQuestData.finishedQuest[tostring(questID)] then
			self.playerFlameWarData.weeklyQuestData.claimedQuest[tostring(questID)] = 1
		elseif self.playerFlameWarData.seasonQuestData.finishedQuest[tostring(questID)] then
			self.playerFlameWarData.seasonQuestData.claimedQuest[tostring(questID)] = 1
		end
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ROARINGFLAMEWAR_QUESTREWARD"
		rewards.questID = questID
		SoraDSendMessage(rewards)
	end
end
function roaringFlameWarCtrl:reqDecreeReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_DECREE_REWARD, nil)
end
function roaringFlameWarCtrl:reqDecreeRewardRsp(content)
	dump(content, "roaringFlameWarCtrl:reqDecreeRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.playerFlameWarData.decree = content.rspdata.decree
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ROARINGFLAMEWAR_DECREEREWARD"
		SoraDSendMessage(rewards)
	end
end
function roaringFlameWarCtrl:reqDecreeGift()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_DECREE_GIFT, nil)
end
function roaringFlameWarCtrl:reqDecreeGiftRsp(content)
	dump(content, "roaringFlameWarCtrl:reqDecreeGiftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.playerFlameWarData.decree = content.rspdata.decree
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ROARINGFLAMEWAR_DECREEGIFT"
		SoraDSendMessage(rewards)
	end
end
function roaringFlameWarCtrl:reqMileStoneReward(taskId)
	serverproxy = nil
	;(nil).taskId = taskId
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_MILE_STONE_REWARD, nil)
end
function roaringFlameWarCtrl:reqMileStoneRewardRsp(content)
	dump(content, "roaringFlameWarCtrl:reqMileStoneRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.playerFlameWarData.mileStone = content.rspdata.mileStone
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ROARINGFLAMEWAR_MILESTONE"
		SoraDSendMessage(rewards)
	end
end
function roaringFlameWarCtrl:reqTurnStage(stage)
	serverproxy = nil
	;(nil).stage = stage
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_TURN_STAGE, nil)
end
function roaringFlameWarCtrl:reqTurnStageRsp(content)
	dump(content, "roaringFlameWarCtrl:reqTurnStageRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.playerFlameWarData.turntable = content.rspdata.turntable
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ROARINGFLAMEWAR_TURNTABLE"
		rewards.key = "stage"
		SoraDSendMessage(rewards)
	end
end
function roaringFlameWarCtrl:reqSetKickFlag()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARING_FLAME_WAR_SET_KICK_FLAG, nil)
	self.stateData.kickFlag = true
end
function roaringFlameWarCtrl:reqSetKickFlagRsp(content)
	dump(content, "roaringFlameWarCtrl:reqSetKickFlagRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
end
function roaringFlameWarCtrl:reqWarData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_DATA, nil)
end
function roaringFlameWarCtrl:reqWarDataRsp(content)
	dump(content, "roaringFlameWarCtrl:reqWarDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.warData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ROARINGFLAMEWAR_WARDATA"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function roaringFlameWarCtrl:reqFreeOccupy(buildId)
	serverproxy = nil
	;(nil).buildId = buildId
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_FREE_OCCUPY, nil)
end
function roaringFlameWarCtrl:reqFreeOccupyRsp(content)
	dump(content, "roaringFlameWarCtrl:reqFreeOccupyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local freeCount = content.rspdata.freeOccupyCount or self:getFreeOccupyCount() + 1
		local freeMax = roaringFlameWarRead.getConstValue("FLAMES_DUNES_ABANDON_CITY_NUM", 10)
		local remain = math.max(0, freeMax - freeCount)
		_ENV = nil
		;(nil).val1 = remain
		;(nil).val2 = freeMax
		SoraDShowMsgTip(i18n("flames_dunes_text215", nil))
	end
end
function roaringFlameWarCtrl:reqCompletePhoenixTask(taskId)
	serverproxy = nil
	;(nil).taskId = taskId
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_COMPLETE_PHOENIX_TASK, nil)
end
function roaringFlameWarCtrl:reqCompletePhoenixTaskRsp(content)
	dump(content, "roaringFlameWarCtrl:reqCompletePhoenixTaskRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.phoenixData = content.rspdata.phoneix
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ROARINGFLAMEWAR_PHOENIX_LIST"
		SoraDSendMessage(rewards)
	end
end
function roaringFlameWarCtrl:reqCollect(buildId)
	serverproxy = nil
	;(nil).buildId = buildId
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_COLLECT, nil)
end
function roaringFlameWarCtrl:reqCollectRsp(content)
	dump(content, "roaringFlameWarCtrl:reqCollectRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.warData.resMap = content.rspdata
		_ENV = content.rspdata
		content.rspdata.msg = "MESSAGE_ROARINGFLAMEWAR_COLLECT"
		SoraDSendMessage(content.rspdata)
		_ENV = content.rspdata
		content.rspdata.msg = "MESSAGE_ROARINGFLAMEWAR_COLLECT_MOVELINE"
		content.rspdata.qType = 1
		content.rspdata.buildId = content.data.buildId
		SoraDSendMessage(content.rspdata)
	end
end
function roaringFlameWarCtrl:reqStopCollect(buildId)
	serverproxy = nil
	;(nil).buildId = buildId
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_STOP_COLLECT, nil)
end
function roaringFlameWarCtrl:reqStopCollectRsp(content)
	dump(content, "roaringFlameWarCtrl:reqStopCollectRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.warData.resMap = content.rspdata
		_ENV = content.rspdata
		content.rspdata.msg = "MESSAGE_ROARINGFLAMEWAR_COLLECT"
		SoraDSendMessage(content.rspdata)
		_ENV = content.rspdata
		content.rspdata.msg = "MESSAGE_ROARINGFLAMEWAR_COLLECT_MOVELINE"
		content.rspdata.qType = 1
		content.rspdata.buildId = content.data.buildId
		content.rspdata.isBack = true
		SoraDSendMessage(content.rspdata)
	end
end
function roaringFlameWarCtrl:reqCampOccupyLog()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_CAMP_OCCUPY_LOG, nil)
end
function roaringFlameWarCtrl:reqCampOccupyLogRsp(content)
	dump(content, "roaringFlameWarCtrl:reqCampOccupyLogRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ROARINGFLAMEWAR_BUILD_LOG"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function roaringFlameWarCtrl:reqPhoenixList()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_PHOENIX_LIST, nil)
end
function roaringFlameWarCtrl:reqPhoenixListRsp(content)
	dump(content, "roaringFlameWarCtrl:reqPhoenixListRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.phoenixData = content.rspdata.phoenix
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ROARINGFLAMEWAR_PHOENIX_LIST"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function roaringFlameWarCtrl:reqCampOccupyList()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_CAMP_OCCUPY_LIST, nil)
end
function roaringFlameWarCtrl:reqCampOccupyListRsp(content)
	dump(content, "roaringFlameWarCtrl:reqCampOccupyListRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ROARINGFLAMEWAR_BUILD_LIST"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function roaringFlameWarCtrl:reqReceiveOccupyBox(buildId)
	serverproxy = nil
	;(nil).buildId = buildId
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_RECEIVE_FIRST_OCCUPY_BOX, nil)
end
function roaringFlameWarCtrl:reqReceiveOccupyBoxRsp(content)
	dump(content, "roaringFlameWarCtrl:reqReceiveOccupyBoxRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata, true)
	elseif content.err == gErrDef.Err_ROARING_FLAME_WAR_BOX_ALREADY_GET then
		SoraDShowMsgTip(i18n("flames_dunes_text246"))
	end
end
function roaringFlameWarCtrl:reqSeasonRecord()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_SEASON_RECORD, nil)
end
function roaringFlameWarCtrl:reqSeasonRecordRsp(content)
	dump(content, "roaringFlameWarCtrl:reqSeasonRecordRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.seasonRecordData = content.rspdata
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ROARINGFLAMEWAR_SEASONRECORD"
	SoraDSendMessage(gErrDef.Err_None)
end
function roaringFlameWarCtrl:reqRankList(rankType, week)
	serverproxy = nil
	;(nil).rankType = rankType
	;(nil).week = week
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_RANKLIST, nil)
end
function roaringFlameWarCtrl:reqRankListRsp(content)
	dump(content, "roaringFlameWarCtrl:reqRankListRsp(content)", 10)
	local _ENV, myInfo = dump, dump
	local _ENV, rankList = content, content
	if content.err == gErrDef.Err_None then
		myInfo, _ENV = content.rspdata.myInfo, content.rspdata.myInfo
		myInfo = content.rspdata.myInfo or dump
		rankList, _ENV = content.rspdata.rankList, content.rspdata.rankList
		rankList = content.rspdata.rankList or content
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ROARINGFLAMEWAR_RANKLIST"
	gErrDef.Err_None.myInfo = myInfo
	gErrDef.Err_None.rankList = rankList
	SoraDSendMessage(gErrDef.Err_None)
end
function roaringFlameWarCtrl:reqBackPlayer(toUid)
	serverproxy = nil
	;(nil).toUid = toUid
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_BACK_PLAYER, nil)
end
function roaringFlameWarCtrl:reqBackPlayerRsp(content)
	dump(content, "roaringFlameWarCtrl:reqBackPlayerRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("flames_dunes_text257"))
	elseif content.err == gErrDef.Err_ROARING_FLAME_WAR_BACK_PLAYER_CD then
		local timeCD = roaringFlameWarRead.getConstValue("FLAMES_DUNES_REPATRIATE_TIME", 120)
		local lastTime = content.rspdata.lastTime
		local time = lastTime + timeCD - serviceFunctions.systemTime()
		_ENV = i18n("flames_dunes_text257")
		i18n("flames_dunes_text257").time = time
		SoraDShowMsgTip(i18n("flames_dunes_text249", i18n("flames_dunes_text257")))
	elseif content.err == gErrDef.Err_ROARING_FLAME_WAR_BACK_PLAYER_IN_BORN then
		SoraDShowMsgTip(i18n("flames_dunes_text286"))
	end
end
function roaringFlameWarCtrl:reqCreateCave()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_CREATE_CAVE, nil)
end
function roaringFlameWarCtrl:reqCreateCaveRsp(content)
	dump(content, "roaringFlameWarCtrl:reqCreateCaveRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local point = include("mapSyncUtilClient").serverTOClientPos(cc.p(content.rspdata.x, content.rspdata.y))
		SoraDGotoWorldMapPoint(point)
		SoraDRemoveAllPanelFromManager()
	end
end
function roaringFlameWarCtrl:reqExploreCave(caveId)
	serverproxy = nil
	;(nil).caveId = caveId
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_EXPLORE_CAVE, nil)
end
function roaringFlameWarCtrl:reqExploreCaveRsp(content)
	dump(content, "roaringFlameWarCtrl:reqExploreCaveRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not self.warData.caveList then
			self.warData.caveList, _ENV = gErrDef.Err_None, gErrDef.Err_None
		end
		table.insert(self.warData.caveList, content.rspdata)
		_ENV = self.warData.caveList
		self.warData.caveList.msg = "MESSAGE_ROARINGFLAMEWAR_COLLECT"
		SoraDSendMessage(self.warData.caveList)
		_ENV = self.warData.caveList
		self.warData.caveList.msg = "MESSAGE_ROARINGFLAMEWAR_COLLECT_MOVELINE"
		self.warData.caveList.qType = 2
		self.warData.caveList.data = content.rspdata
		SoraDSendMessage(self.warData.caveList)
	elseif content.err == gErrDef.Err_ROARING_FLAME_WAR_CAVE_QUEUE_LIMIT then
		SoraDShowMsgTip("flames_dunes_text299")
	end
end
function roaringFlameWarCtrl:reqReceiveCaveTreasure(caveId)
	serverproxy = nil
	;(nil).caveId = tonumber(caveId)
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_RECEIVE_CAVE_TREASURE, nil)
end
function roaringFlameWarCtrl:reqReceiveCaveTreasureRsp(content)
	dump(content, "roaringFlameWarCtrl:reqReceiveCaveTreasureRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		local receiveCaveCount = content.rspdata.receiveCaveCount
		_ENV = true
		;(true).msg = "MESSAGE_ROARINGFLAMEWAR_CAVE"
		;(true).key = "data"
		;(true).receiveCaveCount = receiveCaveCount
		SoraDSendMessage(true)
	elseif content.err == gErrDef.Err_ROARING_FLAME_WAR_CAVE_NO_REWARD then
		SoraDShowMsgTip(i18n("flames_dunes_text144"))
	elseif content.err == gErrDef.Err_ROARING_FLAME_WAR_CAVE_RECEIVE_LIMIT then
		SoraDShowMsgTip(i18n("flames_dunes_text146"))
	else
		SoraDShowMsgTip(i18n("rides_text_02"))
	end
end
function roaringFlameWarCtrl:reqCampCaveList()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_CAMP_CAVE_LIST, nil)
end
function roaringFlameWarCtrl:reqCampCaveListRsp(content)
	dump(content, "roaringFlameWarCtrl:reqCampCaveListRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.caveList = content.rspdata
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ROARINGFLAMEWAR_CAVE"
	gErrDef.Err_None.key = "list"
	gErrDef.Err_None.caveList = content.rspdata
	SoraDSendMessage(gErrDef.Err_None)
end
function roaringFlameWarCtrl:reqCaveData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_CAVE_DATA, nil)
end
function roaringFlameWarCtrl:reqCaveDataRsp(content)
	dump(content, "roaringFlameWarCtrl:reqCaveDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local receiveCaveCount = content.rspdata.receiveCaveCount
		local caveWeekTimes = roaringFlameWarRead.getConstValue("FLAMES_DUNES_CAVE_WEEK_TIMES", 5)
		self.leftReceiveCaveCount = math.max(0, caveWeekTimes - receiveCaveCount)
		_ENV = 0
		;(0).msg = "MESSAGE_ROARINGFLAMEWAR_CAVE"
		;(0).key = "data"
		;(0).receiveCaveCount = receiveCaveCount
		SoraDSendMessage(0)
	end
end
function roaringFlameWarCtrl:reqCampManageData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_CAMP_MANAGE_DATA, nil)
end
function roaringFlameWarCtrl:reqCampManageDataRsp(content)
	dump(content, "roaringFlameWarCtrl:reqCampManageDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ROARINGFLAMEWAR_CAMP_MANAGE_DATA"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function roaringFlameWarCtrl:reqSetActivityNew(activityId)
	serverproxy = nil
	;(nil).activityId = activityId
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_SET_NEW, nil)
end
function roaringFlameWarCtrl:reqSetActivityNewRsp(content)
	dump(content, "roaringFlameWarCtrl:reqSetActivityNewRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ROARINGFLAMEWAR_ACTIVITY_NEW"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function roaringFlameWarCtrl:reqBuildingOwnerData(buildId)
	serverproxy = nil
	;(nil).buildId = buildId
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_BUILDING_OWNER_DATA, nil)
end
function roaringFlameWarCtrl:reqBuildingOwnerDataRsp(content)
	dump(content, "roaringFlameWarCtrl:reqBuildingOwnerDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local ownerMap = content.rspdata
		local buildId = content.data.buildId
		if buildId then
			local buildInfo = ownerMap[tostring(buildId)]
			_ENV = nil
			;(nil).msg = "MESSAGE_ROARINGFLAMEWAR_BUILDING_OWNER"
			;(nil).buildInfo = buildInfo
			SoraDSendMessage(nil)
		else
			_ENV = SoraDSendMessage
			SoraDSendMessage.msg = "MESSAGE_ROARINGFLAMEWAR_BUILDING_OWNER"
			SoraDSendMessage.ownerMap = ownerMap
			SoraDSendMessage(SoraDSendMessage)
		end
	end
end
function roaringFlameWarCtrl:reqKickPlayer(toUid)
	serverproxy = nil
	;(nil).toUid = toUid
	serverproxy:Request(gCmd.CMD_ROARING_FLAME_WAR_MODULE, gCmd.REQ_ROARINF_FLAME_WAR_KICK_PLAYER, nil)
end
function roaringFlameWarCtrl:reqKickPlayerRsp(content)
	dump(content, "roaringFlameWarCtrl:reqKickPlayerRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("flames_dunes_text359"))
		local toUid = content.data.toUid
		local player = self.lv0Map[tostring(toUid)]
		if player then
			player.inWarMap = false
		end
		_ENV = toUid
		toUid.msg = "MESSAGE_ROARINGFLAMEWAR_GET_LV0_LIST"
		toUid.rspdata = self.lv0Map
		SoraDSendMessage(toUid)
	else
		self:reqGetLv0List()
		if content.err == gErrDef.Err_ROARING_FLAME_WAR_KICK_PLAYER_LIMIT then
			SoraDShowMsgTip(i18n("flames_dunes_text354"))
		elseif content.err == gErrDef.Err_ROARING_FLAME_WAR_ALREADY_KICK_PLAYER then
			SoraDShowMsgTip(i18n("flames_dunes_text356"))
		elseif content.err == gErrDef.Err_FLAME_WAR_NOT_LV0_USER then
			SoraDShowMsgTip(i18n("flames_dunes_text355"))
		end
	end
end
function roaringFlameWarCtrl:getCurState(...)
	return self.stateData.curState or ROARING_FLAME_WAR_STATE.NONE
end
function roaringFlameWarCtrl:checkInState(state)
	return self:getCurState() == state
end
function roaringFlameWarCtrl:getStateBeginTime(state)
	if not self.stateData.timeConfig then
		local _ENV, timeConfig = self.stateData.timeConfig, self.stateData.timeConfig
	end
	return timeConfig[tostring(state)] or timeConfig["2"] or 0
end
function roaringFlameWarCtrl:getStateRemainTime(curState)
	curState = curState or self:getCurState()
	local endTime = self:getStateBeginTime(curState + 1)
	local remainTime = endTime - serviceFunctions.systemTime()
	return remainTime
end
function roaringFlameWarCtrl:getCampWithKid(kid)
	if not self.stateData.matchResult then
		local _ENV, matchResult = self.stateData.matchResult, self.stateData.matchResult
	end
	local camp = table.indexof(matchResult, kid)
	if camp then
		return camp
	else
		return 1
	end
end
function roaringFlameWarCtrl:getSelfCamp()
	local player = self:getPlayerData()
	if player.camp then
		return player.camp
	end
	local selfKid = gametop.playertop_:getKingdomID()
	return self:getCampWithKid(selfKid)
end
function roaringFlameWarCtrl:getSkillSlot(...)
	return self.skillData.skillSlot
end
function roaringFlameWarCtrl:getSkillSlotSkillId(index)
	local skillSlot = self:getSkillSlot()
	return skillSlot[tostring(index)].skillId
end
function roaringFlameWarCtrl:getCandidateSkill(...)
	return self.skillData.candidateSkill
end
function roaringFlameWarCtrl:checkCandidateSkill(index)
	local candidateSkill = self:getCandidateSkill()
	if candidateSkill[tostring(index)] then
		return true
	else
		return false
	end
end
function roaringFlameWarCtrl:getIsPrivilegeLock(...)
	return self.skillData.isPrivilegeLock or false
end
function roaringFlameWarCtrl:getLotteryTimes(...)
	return self.skillData.lotteryTimes or 0
end
function roaringFlameWarCtrl:getUsedSkills(...)
	if not self.skillData.usedSkills then
		_UPVALUE0_ = self.skillData.usedSkills
	end
	return self.skillData.usedSkills
end
function roaringFlameWarCtrl:getUsedSkillTimes(...)
	return self.skillData.floorSelectTimes or 0
end
function roaringFlameWarCtrl:isUsedSkillTimesEnough()
	local maxNum = roaringFlameWarRead.getConstValue("FLAMES_DUNES_SKILL_TIME", 100)
	return maxNum <= self:getUsedSkillTimes()
end
function roaringFlameWarCtrl:checkSkillSlotAndCandidateSkill(skillId)
	local skillSlot = self:getSkillSlot()
	for k, v in pairs(skillSlot) do
		if v.skillId == skillId then
			return true
		end
	end
	local candidateSkill = self:getCandidateSkill()
	for k, v in pairs(candidateSkill) do
		if v == skillId then
			return true
		end
	end
	return false
end
function roaringFlameWarCtrl:getTechnologyPoint()
	return self.kingdomFlameWarData.technology.point or 0
end
function roaringFlameWarCtrl:getTechnologyLv(tid)
	return self.kingdomFlameWarData.technology.complete[tostring(tid)] or 0
end
function roaringFlameWarCtrl:getTechnologyComplete(...)
	if not self.kingdomFlameWarData.technology.complete then
		_UPVALUE0_ = self.kingdomFlameWarData.technology.complete
	end
	return self.kingdomFlameWarData.technology.complete
end
function roaringFlameWarCtrl:isTechnologyStudying(tid)
	if next(self.kingdomFlameWarData.technology.researching) then
		if tid then
			return self.kingdomFlameWarData.technology.researching.id == tid, self.kingdomFlameWarData.technology.researching.beginTime
		else
			return true
		end
	end
	return false
end
function roaringFlameWarCtrl:isTechnologyBoxClaimed(tid, lv)
	if self.playerFlameWarData.technologyReward[tostring(tid)] and self.playerFlameWarData.technologyReward[tostring(tid)][tostring(lv)] then
		return true
	end
	return false
end
function roaringFlameWarCtrl:getTechPrefix(tid)
	local nextLv = math.min(self:getTechnologyLv(tid) + 1, roaringFlameWarRead.getTechnologyMaxLv(tid))
	local cfg = roaringFlameWarRead.getTechnologyCfg(tid, nextLv)
	local _ENV, condition = tid, tid
	if next(cfg.prefix_technology) then
		_UPVALUE2_ = roaringFlameWarRead.getTechnologyMaxLv(tid)
		roaringFlameWarRead.getTechnologyMaxLv(tid)[1] = "id"
		roaringFlameWarRead.getTechnologyMaxLv(tid)[2] = "lv"
		local preFix = serviceFunctions.tableFormat(cfg.prefix_technology, roaringFlameWarRead.getTechnologyMaxLv(tid))
		for _, v in ipairs(preFix) do
			_ENV = roaringFlameWarRead.getTechnologyMaxLv(tid)
			roaringFlameWarRead.getTechnologyMaxLv(tid).type = 1
			roaringFlameWarRead.getTechnologyMaxLv(tid).data = v
			table.insert(condition, roaringFlameWarRead.getTechnologyMaxLv(tid))
		end
	end
	if cfg.technology_resource > 0 then
		_ENV = ipairs(preFix)
		ipairs(preFix).type = 2
		ipairs(preFix).data = cfg.technology_resource
		table.insert(condition, ipairs(preFix))
	end
	if 0 < cfg.prefix_history then
		_ENV = ipairs(preFix)
		ipairs(preFix).type = 3
		ipairs(preFix).data = cfg.prefix_history
		table.insert(condition, ipairs(preFix))
	end
	return condition
end
function roaringFlameWarCtrl:checkTechPrefix(tid)
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local condition = self:getTechPrefix(tid)
	local ret = 0
	for k, v in ipairs(condition) do
		if v.type == 1 then
			local preTechLv = self:getTechnologyLv(v.data.id)
			if not preTechLv or preTechLv and preTechLv < v.data.lv then
				ret = 1
			end
		elseif v.type == 2 then
			local myCount = self:getTechnologyPoint()
			if myCount < v.data then
				ret = 2
			end
		elseif v.type == 3 then
			local status = roaringFlameWarRead.getDuneHistoryStatus(v.data)
			if status ~= 2 then
				ret = 3
			end
		end
	end
	return ret
end
function roaringFlameWarCtrl:getNoticeList()
	if not self.kingdomFlameWarData.notice.list then
		_UPVALUE0_ = self.kingdomFlameWarData.notice.list
	end
	return self.kingdomFlameWarData.notice.list
end
function roaringFlameWarCtrl:getNoticeLastTime()
	return self.kingdomFlameWarData.notice.lastTime or 0
end
function roaringFlameWarCtrl:isSeniorRewardLock()
	return self.playerFlameWarData.decree.isSeniorRewardLock or false
end
function roaringFlameWarCtrl:getDecreeLvExp()
	local exp = self.playerFlameWarData.decree.curExp or 0
	return roaringFlameWarRead.getDecreeLvEXP(exp)
end
function roaringFlameWarCtrl:getDecreeNormalLv()
	return self.playerFlameWarData.decree.normalRewardLv or 0
end
function roaringFlameWarCtrl:getDecreeAdvLv()
	return self.playerFlameWarData.decree.seniorRewardLv or 0
end
function roaringFlameWarCtrl:getGiftNormalIdx()
	return self.playerFlameWarData.decree.giftNormalIdx or 0
end
function roaringFlameWarCtrl:getGiftSeniorIdx()
	return self.playerFlameWarData.decree.giftSeniorIdx or 0
end
function roaringFlameWarCtrl:isHaveDecreeReward()
	local lv = self:getDecreeLvExp()
	local isHaveNormal = lv > self:getDecreeNormalLv()
	local isHaveSenior = self:isSeniorRewardLock() and lv > self:getDecreeAdvLv()
	return isHaveNormal or isHaveSenior
end
function roaringFlameWarCtrl:isHaveDecreeCampReward()
	local num = self:getDecreeGiftUserNum()
	local index = roaringFlameWarRead.getPassCfgByNum(num)
	local isHaveNormal = index > self:getGiftNormalIdx()
	local isHaveSenior = self:isSeniorRewardLock() and index > self:getGiftSeniorIdx()
	return isHaveNormal or isHaveSenior
end
function roaringFlameWarCtrl:isHaveDecreeTaskReward(taskType)
	local taskList = roaringFlameWarRead.getTaskList(taskType)
	local questData = taskType == 1 and self:getWeeklyQuestData() or self:getSeasonQuestData()
	local num = 0
	for k, v in ipairs(taskList) do
		local isCalimed = questData.claimedQuest and questData.claimedQuest[tostring(v)]
		if not isCalimed then
			local isDone = questData.finishedQuest and questData.finishedQuest[tostring(v)]
			if isDone then
				num = num + 1
			end
		end
	end
	return 0 < num, num
end
function roaringFlameWarCtrl:getMatchResult(campIndex)
	return self.matchResult[campIndex]
end
function roaringFlameWarCtrl:getSeasonQuestData()
	return self.playerFlameWarData.seasonQuestData
end
function roaringFlameWarCtrl:getWeeklyQuestData()
	return self.playerFlameWarData.weeklyQuestData
end
function roaringFlameWarCtrl:getDecreeGiftUserNum()
	return self.kingdomFlameWarData.decreeGiftUserNum or 0
end
function roaringFlameWarCtrl:getWeeklyGift()
	return self.playerFlameWarData.weeklyGift
end
function roaringFlameWarCtrl:isHaveWeeklyGift()
	local num = 0
	for day = 1, 7 do
		if self.playerFlameWarData.weeklyGift.isBuy and day > self.playerFlameWarData.weeklyGift.getedDay and day <= serviceFunctions.getWeekDayEx() then
			num = num + 1
		end
	end
	return 0 < num, num
end
function roaringFlameWarCtrl:getExchangeNum(shopType)
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	if not activityExchangeMallCtrl:getConfigByActivityID(gActivityTimeActivityID.ROARING_FLAME_WAR_EXCHANGE, shopType) then
		local _ENV, shopList = activityExchangeMallCtrl:getConfigByActivityID(gActivityTimeActivityID.ROARING_FLAME_WAR_EXCHANGE, shopType), activityExchangeMallCtrl:getConfigByActivityID(gActivityTimeActivityID.ROARING_FLAME_WAR_EXCHANGE, shopType)
	end
	local num = 0
	for k, v in ipairs(shopList) do
		if v.remindStatus == 1 and 0 < v.limitnum - v.curExchangeNum and backpackCtrl:getItemCount(v.exchangeitem) >= v.exchangenum then
			num = num + 1
		end
	end
	return num
end
function roaringFlameWarCtrl:getExchangeShopRedNum()
	local shopNum1 = self:getExchangeNum(1)
	local shopNum2 = self:getExchangeNum(2)
	return shopNum1 + shopNum2
end
function roaringFlameWarCtrl:getWarData()
	if not self.warData.warData then
		_UPVALUE0_ = self.warData.warData
	end
	return self.warData.warData
end
function roaringFlameWarCtrl:getWarStatus(...)
	local warData = self:getWarData()
	return warData.status or gKingdomWarStatusType.close
end
function roaringFlameWarCtrl:checkInWarStatus(...)
	local warStatus = self:getWarStatus()
	return warStatus == gKingdomWarStatusType.inWar
end
function roaringFlameWarCtrl:getPlayerData()
	if not self.warData.player then
		_UPVALUE0_ = self.warData.player
	end
	return self.warData.player
end
function roaringFlameWarCtrl:getPermission(...)
	if not self.kingdomFlameWarData.permission then
		_UPVALUE0_ = self.kingdomFlameWarData.permission
	end
	return self.kingdomFlameWarData.permission
end
function roaringFlameWarCtrl:getPlayerMemberClass(uid)
	local permission = self:getPermission()
	uid = uid or gametop.playertop_:getPlayerID()
	if uid == permission.adminId then
		return ROARING_FLAME_WAR_MEMBER_CLASS.ADMIN
	end
	if not permission.managers then
		local gametop, managers = permission.managers, permission.managers
	end
	if table.keyof(managers, uid) then
		return ROARING_FLAME_WAR_MEMBER_CLASS.MANAGER
	end
	if not permission.lv0UserList then
		local gametop, lv0UserList = permission.lv0UserList, permission.lv0UserList
	end
	if lv0UserList[tostring(uid)] then
		return ROARING_FLAME_WAR_MEMBER_CLASS.LV0_USER
	end
	return ROARING_FLAME_WAR_MEMBER_CLASS.LV1_USER
end
function roaringFlameWarCtrl:getUseSpeedItemCount(...)
	local player = self:getPlayerData()
	return player.useSpeedItemCount or 0
end
function roaringFlameWarCtrl:setUseSpeedItemCount(useSpeedItemCount)
	local player = self:getPlayerData()
	player.useSpeedItemCount = useSpeedItemCount
	self.warData.player = player
end
function roaringFlameWarCtrl:getWeekMonsterScore(...)
	local player = self:getPlayerData()
	return player.weekMonsterScore or 0
end
function roaringFlameWarCtrl:setWeekMonsterScore(weekMonsterScore)
	local player = self:getPlayerData()
	player.weekMonsterScore = weekMonsterScore
	self.warData.player = player
end
function roaringFlameWarCtrl:setMoveCityCDEndTime(moveCityCDEndTime)
	local player = self:getPlayerData()
	player.moveCityCDEndTime = moveCityCDEndTime
	self.warData.player = player
end
function roaringFlameWarCtrl:getMoveCityCDEndTime(...)
	local player = self:getPlayerData()
	local moveCityCDEndTime = player.moveCityCDEndTime or 0
	if 0 < moveCityCDEndTime then
		local remain = moveCityCDEndTime - serviceFunctions.systemTime()
		return math.max(0, remain)
	end
	return 0
end
function roaringFlameWarCtrl:isMoveCityCDEndTime()
	return self:getMoveCityCDEndTime() > 0
end
function roaringFlameWarCtrl:getUseSpeedItemRemainCount(...)
	local totalNum = roaringFlameWarRead.getConstValue("FLAMES_DUNES_MARCH_SPEED_NUM", 1000)
	local useCount = self:getUseSpeedItemCount()
	local remain = math.max(0, totalNum - useCount)
	return remain
end
function roaringFlameWarCtrl:getCampInfo()
	if not self.warData.campInfo then
		_UPVALUE0_ = self.warData.campInfo
	end
	return self.warData.campInfo
end
function roaringFlameWarCtrl:getCampInfoByCamp(camp)
	camp = camp or self:getSelfCamp()
	local campInfo = self:getCampInfo()
	if not campInfo[camp] then
		_UPVALUE0_ = campInfo[camp]
	end
	return campInfo[camp]
end
function roaringFlameWarCtrl:getFreeOccupyCount(camp)
	local campInfo = self:getCampInfoByCamp(camp)
	return campInfo.freeOccupyCount or 0
end
function roaringFlameWarCtrl:getKickPlayerCount(camp)
	local campInfo = self:getCampInfoByCamp(camp)
	return campInfo.kickPlayerCount or 0
end
function roaringFlameWarCtrl:getOccupyPalaceSecs(camp)
	local campInfo = self:getCampInfoByCamp(camp)
	return campInfo.occupyPalaceSecs or 0
end
function roaringFlameWarCtrl:getOccupyPalaceEndTime(camp)
	local campInfo = self:getCampInfoByCamp(camp)
	return campInfo.occupyPalaceEndTime or 0
end
function roaringFlameWarCtrl:getCaveList()
	if not self.warData.caveList then
		_UPVALUE0_ = self.warData.caveList
	end
	return self.warData.caveList
end
function roaringFlameWarCtrl:getCaveMapNum()
	local caveList = self:getCaveList()
	return #caveList
end
function roaringFlameWarCtrl:getCaveListNum()
	local caveList = self.caveList or self:getCaveList()
	return #caveList
end
function roaringFlameWarCtrl:getResMap()
	if not self.warData.resMap then
		_UPVALUE0_ = self.warData.resMap
	end
	return self.warData.resMap
end
function roaringFlameWarCtrl:getResMapData(buildId)
	local resMap = self:getResMap()
	return resMap[tostring(buildId)]
end
function roaringFlameWarCtrl:getCurCollNum(buildId, curSpeed)
	local res = self:getResMapData(buildId)
	if res then
		local collSpeed = curSpeed and math.max(curSpeed, res.lastCollSpeed) or res.lastCollSpeed
		local endCollTime = math.min(res.endCollTime, serviceFunctions.systemTime())
		local lastCollNum = (endCollTime - res.lastCollTime) * collSpeed
		local totalNum = lastCollNum + res.alreadyCollNum
		return totalNum, endCollTime
	end
end
function roaringFlameWarCtrl:getMileStoneProgress(index)
	if not self.kingdomFlameWarData.mileStoneData.mileStoneInfo then
		local _ENV, mileStoneInfo = self.kingdomFlameWarData.mileStoneData.mileStoneInfo, self.kingdomFlameWarData.mileStoneData.mileStoneInfo
	end
	return mileStoneInfo[tostring(index)] or 0
end
function roaringFlameWarCtrl:isMileStoneRewarded(index)
	return self.playerFlameWarData.mileStone and self.playerFlameWarData.mileStone[tostring(index)] and true or false
end
function roaringFlameWarCtrl:isHaveMileStoneReward()
	local roaringFlameWarRead = include("roaringFlameWarRead")
	local mileStoneCfg = roaringFlameWarRead.getDuneHistoryCfg()
	local num = 0
	for k, v in ipairs(mileStoneCfg) do
		local status, remainTime = roaringFlameWarRead.getDuneHistoryStatus(v.task_id)
		if 2 <= status and not self:isMileStoneRewarded(k) then
			num = num + 1
		end
	end
	return 0 < num, num
end
function roaringFlameWarCtrl:isHaveTechPointReward()
	local num = 0
	local roaringFlameWarRead = include("roaringFlameWarRead")
	local techTree = roaringFlameWarRead.getTechnologyTree()
	for i, v in ipairs(techTree) do
		if roaringFlameWarRead.isTechnologyRewardBox(v) then
			local lv = self:getTechnologyLv(v)
			if 1 <= lv and not self:isTechnologyBoxClaimed(v, 1) then
				num = num + 1
			end
		end
	end
	local techPoint = self:getTechnologyPoint()
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	local isStudying = false
	local needPoint = 0
	if roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.UPGRADE_TECHNOLOGY) then
		for i, tid in ipairs(techTree) do
			local _isStudying = self:isTechnologyStudying(tid)
			if _isStudying then
				isStudying = true
			end
			local ret = self:checkTechPrefix(tid)
			local lv = self:getTechnologyLv(tid)
			local cfg = roaringFlameWarRead.getTechnologyCfg(tid, lv)
			if ret == 0 and lv < cfg.max_level then
				local condition = self:getTechPrefix(tid)
				for k, v in ipairs(condition) do
					if v.type == 2 and techPoint >= v.data then
						if needPoint == 0 then
							needPoint = v.data
						else
							needPoint = math.min(needPoint, v.data)
						end
					end
				end
			end
		end
	end
	if not isStudying and 0 < needPoint and techPoint >= needPoint then
		num = num + 1
	end
	return 0 < num, num
end
function roaringFlameWarCtrl:setTurntableData(turntable)
	self.playerFlameWarData.turntable = turntable
end
function roaringFlameWarCtrl:getTurntableData()
	if not self.playerFlameWarData.turntable then
		_UPVALUE0_ = self.playerFlameWarData.turntable
	end
	return self.playerFlameWarData.turntable
end
function roaringFlameWarCtrl:getStageBoxStatues(stage, times)
	local turntable = self:getTurntableData()
	local state = turntable.stageRewards[tostring(stage)] and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	if state ~= gBtnTargetStatusDef.GOT and times <= turntable.times then
		state = gBtnTargetStatusDef.GET
	end
	return state
end
function roaringFlameWarCtrl:getTurntableRewardNum()
	local roaringFlameWarRead = include("roaringFlameWarRead")
	local stageConfig = roaringFlameWarRead.getTurntableStageCfg()
	local num = 0
	for k, v in ipairs(stageConfig) do
		if self:getStageBoxStatues(v.position, v.Value) == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	return num
end
function roaringFlameWarCtrl:isTurntableShowRed()
	local activityCommonDrawCtrl = SoraDGetCtrl("activityCommonDrawCtrl")
	local itemID_zp = activityCommonDrawCtrl:getItemID(self.activityID)
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemCount_zp = backpackCtrl:getItemCount(itemID_zp)
	_ENV = nil
	;(nil).byUID = true
	local isIgnore_zp = SoraDConfigGet("Game:RoaringFlame_notice:zp~bool", nil) or false
	local isShow_zp = not isIgnore_zp and 0 < itemCount_zp
	return isShow_zp, 0 < itemCount_zp
end
function roaringFlameWarCtrl:isTreasureCaveShowRed()
	local roaringFlameWarRead = include("roaringFlameWarRead")
	local itemCfg = roaringFlameWarRead.getConstValueArray("FLAMES_DUNES_CAVE_ITEM")
	local isEnoughItem = SoraDGetCtrl("backpackCtrl"):getItemCount(itemCfg[1]) >= itemCfg[2]
	local leftCount = self:getLeftCaveCount()
	_ENV = nil
	;(nil).byUID = true
	local isIgnore_cbd = SoraDConfigGet("Game:RoaringFlame_notice:cbd~bool", nil) or false
	local isShow_cbd = not isIgnore_cbd and isEnoughItem
	return isShow_cbd, isEnoughItem and 0 < leftCount
end
function roaringFlameWarCtrl:getPhoenixTaskRedNum(taskType)
	local roaringFlameWarRead = include("roaringFlameWarRead")
	local taskList = roaringFlameWarRead.getPhoenixTaskCfg(taskType)
	local num = 0
	for k, v in ipairs(taskList) do
		local status = self:getPhoenixTaskStatus(v.index, v.type)
		if status == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	return num
end
function roaringFlameWarCtrl:getPhoenixTaskStatus(taskId, taskType)
	local status = gBtnTargetStatusDef.GO
	local isCalimed = self:isPhoenixTaskReceived(taskId)
	if isCalimed then
		status = gBtnTargetStatusDef.GOT
	else
		local isDone, progress = self:isPhoenixTaskDone(taskId, taskType)
		if isDone then
			status = gBtnTargetStatusDef.GET
		end
	end
	return status
end
function roaringFlameWarCtrl:getPhoenixData()
	return self.phoenixData
end
function roaringFlameWarCtrl:isPhoenixTaskReceived(taskId)
	return self.phoenixData and self.phoenixData.task[tostring(taskId)] and true or false
end
function roaringFlameWarCtrl:isPhoenixTaskDone(taskId, taskType)
	if not self.phoenixData then
		return false, 0
	end
	local taskCfg = roaringFlameWarRead.getPhoenixTaskCfg(taskType)
	local roaringFlameWarRead, task = taskType, taskType
	for k, v in ipairs(taskCfg) do
		if v.index == taskId then
			task = v
			break
		end
	end
	if taskType == 1 then
		return (self.phoenixData.bestDamage or 0) >= task.aim, self.phoenixData.bestDamage or 0
	elseif taskType == 2 then
		return (self.phoenixData.attackCount or 0) >= task.aim, self.phoenixData.attackCount or 0
	elseif taskType == 3 then
		if not self.phoenixData.lvMap then
			local roaringFlameWarRead, lvMap = self.phoenixData.lvMap, self.phoenixData.lvMap
		end
		local maxLv = 0
		for lv, _ in pairs(lvMap) do
			maxLv = math.max(maxLv, tonumber(lv))
		end
		local isDone = lvMap[tostring(task.aim)] or maxLv >= task.aim
		if isDone then
			return true, 1
		else
			return false, 0
		end
	end
end
function roaringFlameWarCtrl:getSeaonRecordData()
	return self.seasonRecordData
end
function roaringFlameWarCtrl:getBuffEffect(effectType)
	if not worldMapDefine.isInRoaringFlame() then
		return 0
	end
	local value = 0
	local skillValue = self:getSkillBuffValue(effectType)
	value = value + skillValue
	local technologyValue = self:getTechnologyBuffValue(effectType)
	value = value + technologyValue
	return value
end
function roaringFlameWarCtrl:getSkillBuffValue(effectType)
	local usedSkills = self:getUsedSkills()
	if not next(usedSkills) then
		return 0
	end
	local list = roaringFlameWarRead.getSkillIDListByEffectType(effectType)
	if not next(list) then
		return 0
	end
	local value = 0
	for i, skillID in ipairs(list) do
		if usedSkills[tostring(skillID)] then
			local buff = roaringFlameWarRead.getSkillBuff(skillID)
			for i = 1, #buff, 2 do
				if effectType == buff[i] then
					local add = buff[i + 1] or 0
					value = value + add
				end
			end
		end
	end
	return value
end
function roaringFlameWarCtrl:getTechnologyBuffValue(effectType)
	local value = 0
	local complete = self:getTechnologyComplete()
	for k, lv in pairs(complete) do
		local tid = tonumber(k)
		local cfg = roaringFlameWarRead.getTechnologyCfg(tid, lv)
		if cfg.buff_type == effectType then
			value = value + cfg.power_num
		end
	end
	return value
end
function roaringFlameWarCtrl:getDecreeBuffValue(effectType)
	if not self:isSeniorRewardLock() then
		return 0
	end
	if effectType == gBuffEffect.MARCH_TROOP_TOTAL_BOOST then
		return roaringFlameWarRead.getConstValue("FLAMES_DUNES_BATTLE_PASS_GIFT1", 1)
	end
	if effectType == gBuffEffect.GATHER_SPEED_BOOST then
		return roaringFlameWarRead.getConstValue("FLAMES_DUNES_BATTLE_PASS_GIFT2", 100)
	end
	_UPVALUE2_ = 100
	;(100)[1] = 5
	;(100)[2] = 100
	local buffCfg = roaringFlameWarRead.getConstValueArray("FLAMES_DUNES_BATTLE_PASS_GIFT3", 100)
	if buffCfg[1] == effectType then
		return buffCfg[2] or 0
	end
	_UPVALUE2_ = 5
	;(5)[1] = 102
	;(5)[2] = 100
	local buffCfg = roaringFlameWarRead.getConstValueArray("FLAMES_DUNES_BATTLE_PASS_GIFT4", 5)
	if buffCfg[1] == effectType then
		return buffCfg[2] or 0
	end
	return 0
end
function roaringFlameWarCtrl:getLeftCaveCount()
	return self.leftReceiveCaveCount
end
function roaringFlameWarCtrl:checkShowKickPopup()
	if SoraDCurrentSceneShowView("mainCityView") then
		local priorityKey = uiDequeTypeTab.ROARING_FLAME_KICK
		SoraDAddPopupWindow(function()
			self:showKickPopup()
			SoraDDeletePopupWindow(priorityKey)
		end, priorityKey)
	else
		self:showKickPopup()
	end
end
function roaringFlameWarCtrl:showKickPopup()
	self:reqSetKickFlag()
	_ENV = nil
	;(nil).canNotClose = true
	;(nil).align = SoraDFLabelR()
	;(nil).valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP
	;(nil).title = i18n("flames_dunes_text351")
	SoraDShowMsgBoxNew(i18n("flames_dunes_text363"), i18n("common_text_204"), nil, nil, nil)
end
return roaringFlameWarCtrl
