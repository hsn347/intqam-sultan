local GameModule = include("GameModule")
local newActivityCtrl = class("newActivityCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local newActivityRead = include("newActivityRead")
function newActivityCtrl:ctor(properties)
	newActivityCtrl.super.ctor(self, properties)
end
function newActivityCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_NEW_ACTIVITY_INIT, handler(self, self.getInitResp))
	msgCtrl.register(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_DEVELOP_ARMAMENT_INFO, handler(self, self.getDevelopArmamentInfoResp))
	msgCtrl.register(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_DEVELOP_ARMAMENT_RANK, handler(self, self.getDevelopArmamentRankResp))
	msgCtrl.register(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_PERSON_LIMITED_INFO, handler(self, self.getPersonLimitedInfoResp))
	msgCtrl.register(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_PERSON_LIMITED_RANK, handler(self, self.getPersonLimitedRankResp))
	msgCtrl.register(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_CRAZY_SCORE_INFO, handler(self, self.getCrazyScoreInfoResp))
	msgCtrl.register(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_CRAZY_SCORE_RANK, handler(self, self.getCrazyScoreRankResp))
	msgCtrl.register(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_FLOWER_ACTIVITY_PERSONAL_INFO, handler(self, self.rspFlowerActivityInfo))
	msgCtrl.register(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_FLOWER_ACTIVITY_AWARD, handler(self, self.rspGetFlowerRankAward))
	msgCtrl.register(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_FLOWER_ACTIVITY_RANK_DATA, handler(self, self.rspFlowerRankData))
	msgCtrl.register(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_CRAZY_SCORE_RANK_NEW, handler(self, self.getCrazyScoreRankNewResp))
end
function newActivityCtrl:Logout()
	self:resetData()
	newActivityCtrl.super.Logout(self)
end
function newActivityCtrl:resetData()
	self.handle_notify = nil
	self.newActivityData = nil
	self.castleUpgradeData = nil
	self.developArmyHistoryRank = nil
	self.developArmyConfig = nil
	self.developArmyReward = nil
	self.developArmyRank = nil
	self.personlimitedTimeHistoryRank = nil
	self.personLimitedTimeArmyConfig = nil
	self.personLimitedNormalReward = nil
	self.personLimitedTimeArmyRank = nil
	self.crazyScoreConfig = nil
	self.crazyScoreStageReward = nil
	self.crazyScoreRankUidData = nil
	self.crazyScoreRankAidData = nil
	self.floweractivityRankData, _UPVALUE0_, self.crazyScoreRankKidData = nil, nil, nil
	self.floweractivityPersonalInfo = nil
end
function newActivityCtrl:initClientData(data)
	if not data then
		return
	end
	self:resetData()
	self:registerNotify()
	self:sendInit()
	self:reqFlowerActivityInfo()
end
function newActivityCtrl:getKingdomInfo(kingdomlist, kid)
	local _ENV, ret
	if type(kingdomlist) == "table" then
		for key, value in pairs(kingdomlist) do
			if value.kid == kid then
				ret.kname = value.kname
				ret.palaceModel = value.palaceModel
			end
		end
	end
	return ret
end
function newActivityCtrl:getFlowerActivityPersonalData()
	local ret = clone(self.floweractivityPersonalInfo)
	if not ret then
		ret, _ENV = self.floweractivityPersonalInfo, self.floweractivityPersonalInfo
	end
	return ret
end
function newActivityCtrl:getFlowerRankData(style)
	local ret = clone(self.floweractivityRankData[style])
	if not ret then
		ret, _ENV = self.floweractivityRankData[style], self.floweractivityRankData[style]
	end
	return ret
end
function newActivityCtrl:getFlowerActivityAward(style)
	return newActivityRead.getFlowerActivityAward(style)
end
function newActivityCtrl:getFlowerActivityRankAward(style)
	return newActivityRead.getFlowerActivityRankAward(style)
end
function newActivityCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEW_ACTIVITY, handler(self, self.notifyFun))
end
function newActivityCtrl:notifyFun(event)
	local content = event.data[1]
	if content and content.activityID then
		local activityID = tonumber(content.activityID)
		if not self.newActivityData then
			_ENV = self.newActivityData
		end
		self.newActivityData = self.newActivityData
		if not self.newActivityData[tostring(activityID)] then
			_ENV = self.newActivityData[tostring(activityID)]
		end
		self.newActivityData[tostring(activityID)] = self.newActivityData[tostring(activityID)]
		if activityID == gActivityTimeActivityID.CASTLE_UPGRADE_ACTIVITY and content.level then
			if not self.castleUpgradeData then
				local a = self:getCastleUpgradeData()
			end
			for key, value in pairs(self.castleUpgradeData) do
				if tonumber(content.level) == 0 then
					value.receive = false
					self.castleUpgradeData[key] = value
				end
				if tonumber(content.level) == tonumber(value.castleLv) then
					value.receive = true
					self.castleUpgradeData[key] = value
					break
				end
			end
		end
		if activityID == gActivityTimeActivityID.DEVELOP_ARMAMENT_ACTIVITY or activityID == gActivityTimeActivityID.CRAZY_GET_POINT_ACTIVITY then
			if content.rank then
				self.newActivityData[tostring(activityID)].rank = content.rank
			end
			if content.score then
				self.newActivityData[tostring(activityID)].score = content.score
			end
			if content.stage then
				self.newActivityData[tostring(activityID)].stage = content.stage
			end
		end
		if activityID == gActivityTimeActivityID.DEVELOP_ARMAMENT_ACTIVITY and content.opencount then
			if self.newActivityData[tostring(activityID)].opencount and content.opencount > self.newActivityData[tostring(activityID)].opencount then
				self.developArmyHistoryRank = nil
			end
			self.newActivityData[tostring(activityID)].opencount = content.opencount
		end
		if activityID == gActivityTimeActivityID.CRAZY_GET_POINT_ACTIVITY then
			if content.kidRank then
				self.newActivityData[tostring(activityID)].kidRank = content.kidRank
			end
			if content.aidRank then
				self.newActivityData[tostring(activityID)].aidRank = content.aidRank
			end
			if content.aidScore then
				self.newActivityData[tostring(activityID)].aidScore = content.aidScore
			end
			if content.kidScore then
				self.newActivityData[tostring(activityID)].kidScore = content.kidScore
			end
			if content.stage then
				self.newActivityData[tostring(activityID)].stage = content.stage
				if 0 < content.stage then
					_ENV = activityID
					activityID.num = content.stage
					SoraDShowMsgTip(i18n("common_text_3116", activityID))
				end
			end
		end
		if activityID == gActivityTimeActivityID.FLOWER_ACTIVITY_RANK then
			if not self.floweractivityPersonalInfo then
				self.floweractivityPersonalInfo, _ENV = self.floweractivityPersonalInfo, self.floweractivityPersonalInfo
			end
			if content.activityID then
				self.newActivityData[tostring(activityID)].activityID = content.activityID
				self.floweractivityPersonalInfo.activityID = content.activityID
			end
			if content.opencount then
				self.newActivityData[tostring(activityID)].opencount = content.opencount
				self.floweractivityPersonalInfo.opencount = content.opencount
			end
			if content.sendNum then
				self.newActivityData[tostring(activityID)].sendNum = content.sendNum
				self.floweractivityPersonalInfo.sendNum = content.sendNum
			end
			if content.receiveNum then
				self.newActivityData[tostring(activityID)].receiveNum = content.receiveNum
				self.floweractivityPersonalInfo.receiveNum = content.receiveNum
			end
			if content.awardFlag then
				self.newActivityData[tostring(activityID)].awardFlag = content.awardFlag
				self.floweractivityPersonalInfo.awardFlag = content.awardFlag
			end
			if content.curSendRank then
				self.newActivityData[tostring(activityID)].curSendRank = content.curSendRank
				self.floweractivityPersonalInfo.curSendRank = content.curSendRank
			end
			if content.curReceiveRank then
				self.newActivityData[tostring(activityID)].curReceiveRank = content.curReceiveRank
				self.floweractivityPersonalInfo.curReceiveRank = content.curReceiveRank
			end
			_ENV = content.curReceiveRank
			content.curReceiveRank.msg = "MESSAGE_SERVER_EVENTCENTER_FLOWER_REFRESH"
			SoraDSendMessage(content.curReceiveRank)
			_ENV = content.curReceiveRank
			content.curReceiveRank.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			content.curReceiveRank.eventID = gActivityTimeActivityID.FLOWER_ACTIVITY_RANK
			SoraDSendMessage(content.curReceiveRank)
		end
	end
end
function newActivityCtrl:handleInfoData(ret)
	if type(ret) == "table" and type(ret.data) == "table" and ret.err == gErrDef.Err_None then
		local activityID = tonumber(ret.data.activityID)
		if not self.newActivityData then
			_ENV = self.newActivityData
		end
		self.newActivityData = self.newActivityData
		if not self.newActivityData[tostring(activityID)] then
			_ENV = self.newActivityData[tostring(activityID)]
		end
		self.newActivityData[tostring(activityID)] = self.newActivityData[tostring(activityID)]
		self.newActivityData[tostring(activityID)].rank = ret.data.rank
		self.newActivityData[tostring(activityID)].score = ret.data.score
		if activityID == gActivityTimeActivityID.DEVELOP_ARMAMENT_ACTIVITY then
			self.newActivityData[tostring(activityID)].opencount = ret.data.opencount
		end
		if activityID == gActivityTimeActivityID.CRAZY_GET_POINT_ACTIVITY then
			if ret.data.kidRank then
				self.newActivityData[tostring(activityID)].kidRank = ret.data.kidRank
			end
			if ret.data.aidRank then
				self.newActivityData[tostring(activityID)].aidRank = ret.data.aidRank
			end
			if ret.data.aidScore then
				self.newActivityData[tostring(activityID)].aidScore = ret.data.aidScore
			end
			if ret.data.kidScore then
				self.newActivityData[tostring(activityID)].kidScore = ret.data.kidScore
			end
		end
	end
end
function newActivityCtrl:dump()
end
function newActivityCtrl:sendInit()
	serverproxy:Request(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_NEW_ACTIVITY_INIT)
end
function newActivityCtrl:sendGetDevelopArmamentInfo()
	serverproxy:Request(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_DEVELOP_ARMAMENT_INFO)
end
function newActivityCtrl:sendGetDevelopArmamentRank(opencountArray)
	if type(opencountArray) == "table" and table.nums(opencountArray) > 0 then
		local _ENV, data = table.nums(opencountArray), table.nums(opencountArray)
		data.opencountArray = opencountArray
		serverproxy:Request(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_DEVELOP_ARMAMENT_RANK, data)
	end
end
function newActivityCtrl:sendGetPersonLimitedInfo()
	serverproxy:Request(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_PERSON_LIMITED_INFO)
end
function newActivityCtrl:sendGetPersonLimitedRank(smallRoundArray)
	if type(smallRoundArray) == "table" and table.nums(smallRoundArray) > 0 then
		local _ENV, data = table.nums(smallRoundArray), table.nums(smallRoundArray)
		data.smallRoundArray = smallRoundArray
		serverproxy:Request(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_PERSON_LIMITED_RANK, data)
	end
end
function newActivityCtrl:sendCrazyScoreInfo()
	serverproxy:Request(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_CRAZY_SCORE_INFO)
end
function newActivityCtrl:sendCrazyScoreRank(startIndex, rankType)
	local serverproxy, data
	data.startIndex = startIndex
	data.rankType = rankType
	serverproxy:Request(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_CRAZY_SCORE_RANK, data)
end
function newActivityCtrl:sendNewCrazyScoreRank(startIndex, endIndex, rankType)
	local serverproxy, data
	data.startIndex = startIndex
	data.endIndex = endIndex
	data.rankType = rankType
	serverproxy:Request(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_CRAZY_SCORE_RANK_NEW, data)
end
function newActivityCtrl:getInitResp(ret)
	if ret and ret.data and gErrDef.Err_None == ret.err then
		self.newActivityData = ret.data
		if self.newActivityData[tostring(gActivityTimeActivityID.CASTLE_UPGRADE_ACTIVITY)] then
			clientEventMgr.getEventStateInfo(gActivityTimeActivityID.CASTLE_UPGRADE_ACTIVITY)
		end
	end
end
function newActivityCtrl:getDevelopArmamentInfoResp(ret)
	self:handleInfoData(ret)
	_ENV = self
	self.msg = "MESSAGE_SERVER_EVENTCENTER_DEVELOP_ARMY_REFRESH"
	SoraDSendMessage(self)
end
function newActivityCtrl:getDevelopArmamentRankResp(ret)
	local failCount = 0
	if type(ret) == "table" and type(ret.data) == "table" then
		local activityID = ret.data.activityID
		local opencountArray = ret.data.opencountArray
		if not ret.data.topTenInfoArray then
			local _ENV, topTenInfoArray = ret.data.topTenInfoArray, ret.data.topTenInfoArray
		end
		if not self.developArmyHistoryRank then
			_ENV = self.developArmyHistoryRank
		end
		self.developArmyHistoryRank = self.developArmyHistoryRank
		for opencount, topTenInfo in pairs(topTenInfoArray) do
			self.developArmyHistoryRank[tostring(opencount)] = topTenInfo
			if not topTenInfo.beginTime or not topTenInfo.endTime then
				failCount = failCount + 1
			end
		end
	end
	_ENV = ret.data.opencountArray
	ret.data.opencountArray.msg = "MESSAGE_SERVER_EVENTCENTER_DEVELOP_ARMY_RANK_BACK"
	SoraDSendMessage(ret.data.opencountArray)
end
function newActivityCtrl:getCrazyScoreInfoResp(ret)
	self:handleInfoData(ret)
	_ENV = self
	self.msg = "MESSAGE_SERVER_EVENTCENTER_CRAZYINTEGRAL_REQDATA"
	SoraDSendMessage(self)
end
function newActivityCtrl:getCrazyScoreRankResp(ret)
	if ret.err == gErrDef.Err_None then
		if not ret.data then
			_ENV = ret.data
		end
		ret.data = ret.data
		local rankType = ret.data.rankType
		if type(ret.data.rankData) == "table" then
			local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
			local kingdomlist = kingdomCtrl:getKingdomList()
			for i, value in pairs(ret.data.rankData) do
				if rankType == gCrazyScoreRankType.UID_RANK_TYPE then
					if not self.crazyScoreRankUidData then
						_ENV = self.crazyScoreRankUidData
					end
					self.crazyScoreRankUidData = self.crazyScoreRankUidData
					self.crazyScoreRankUidData[tonumber(value.rank)] = value
				elseif rankType == gCrazyScoreRankType.AID_RANK_TYPE then
					if not self.crazyScoreRankAidData then
						_ENV = self.crazyScoreRankAidData
					end
					self.crazyScoreRankAidData = self.crazyScoreRankAidData
					self.crazyScoreRankAidData[tonumber(value.rank)] = value
				elseif rankType == gCrazyScoreRankType.KID_RANK_TYPE then
					if not self.crazyScoreRankKidData then
						_ENV = self.crazyScoreRankKidData
					end
					self.crazyScoreRankKidData = self.crazyScoreRankKidData
					self.crazyScoreRankKidData[tonumber(value.rank)] = value
					local kid = value.kid
					local tmp = self:getKingdomInfo(kingdomlist, kid)
					for tmpKey, info in pairs(tmp) do
						self.crazyScoreRankKidData[tonumber(value.rank)][tmpKey] = info
					end
				end
			end
		end
		local newStartIndex = ret.data.newStartIndex
		local bCanContinueGet = ret.data.bCanContinueGet
		local _ENV, curTypeTbl = pairs(ret.data.rankData)
		if rankType == gCrazyScoreRankType.UID_RANK_TYPE then
			curTypeTbl = self.crazyScoreRankUidData
		elseif rankType == gCrazyScoreRankType.AID_RANK_TYPE then
			curTypeTbl = self.crazyScoreRankAidData
		elseif rankType == gCrazyScoreRankType.KID_RANK_TYPE then
			curTypeTbl = self.crazyScoreRankKidData
		end
		_ENV = pairs(ret.data.rankData)
		pairs(ret.data.rankData).msg = "MESSAGE_SERVER_EVENTCENTER_CRAZYINTEGRAL_RANKDATA"
		pairs(ret.data.rankData).rankList = curTypeTbl
		pairs(ret.data.rankData).idx = newStartIndex
		pairs(ret.data.rankData).wget = bCanContinueGet
		pairs(ret.data.rankData).dataType = rankType
		SoraDSendMessage(pairs(ret.data.rankData))
	end
end
function newActivityCtrl:getCrazyScoreRankNewResp(ret)
	if not ret.data then
		_UPVALUE0_ = ret.data
	end
	ret.data = ret.data
	local rankType = ret.data.rankType
	if not ret.data.rankData then
		local _UPVALUE0_, rankData = ret.data.rankData, ret.data.rankData
	end
end
function newActivityCtrl:getPersonLimitedInfoResp(ret)
	self:handleInfoData(ret)
	_ENV = self
	self.msg = "MESSAGE_SERVER_EVENTCENTER_PERSON_LIMIT_REFRESH"
	SoraDSendMessage(self)
end
function newActivityCtrl:getPersonLimitedRankResp(ret)
	if type(ret) == "table" and type(ret.data) == "table" and ret.err == gErrDef.Err_None then
		local activityID = ret.data.activityID
		if not ret.data.topTenInfoArray then
			local _ENV, topTenInfoArray = ret.data.topTenInfoArray, ret.data.topTenInfoArray
		end
		if not self.personlimitedTimeHistoryRank then
			_ENV = self.personlimitedTimeHistoryRank
		end
		self.personlimitedTimeHistoryRank = self.personlimitedTimeHistoryRank
		for smallRound, topTenInfo in pairs(topTenInfoArray) do
			self.personlimitedTimeHistoryRank[tostring(smallRound)] = topTenInfo
		end
	end
	_ENV = ret.data.topTenInfoArray
	ret.data.topTenInfoArray.msg = "MESSAGE_SERVER_EVENTCENTER_PERSON_LIMIT_RANK_BACK"
	SoraDSendMessage(ret.data.topTenInfoArray)
end
function newActivityCtrl:getCastleUpgradeData()
	local activityID = gActivityTimeActivityID.CASTLE_UPGRADE_ACTIVITY
	if not self.castleUpgradeData or next(self.castleUpgradeData) == nil then
		self.castleUpgradeData, _ENV = next(self.castleUpgradeData), next(self.castleUpgradeData)
		if type(self.newActivityData) == "table" then
			local tmp = self.newActivityData[tostring(activityID)]
			if type(tmp) == "table" then
				for key, value in pairs(tmp) do
					_UPVALUE2_ = nil
					;(nil)[1] = "id"
					;(nil)[2] = "count"
					value.reward = serviceFunctions.tableFormat(value.reward, nil)
				end
				self.castleUpgradeData = tmp
			end
		end
	end
	return self.castleUpgradeData
end
function newActivityCtrl:getDevelopArmyConfig()
	local activityID = gActivityTimeActivityID.DEVELOP_ARMAMENT_ACTIVITY
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local group = activityShowCtrl:getParamByID(activityID).classtype or 1
	if not self.developArmyConfig then
		self.developArmyConfig, _ENV = self.developArmyConfig, self.developArmyConfig
		local tmp = newActivityRead.getDevelopArmyInfo()
		for key, value in pairs(tmp) do
			if value.group == group then
				local _ENV, data = value.group, value.group
				data.eventType = value.eventType
				data.condition = value.condition[1]
				data.point = value.rewardPoint
				if value.taskDes and next(value.taskDes) then
					data.taskDes = i18n(value.taskDes)
				end
				table.insert(self.developArmyConfig, data)
			end
		end
		table.sort(self.developArmyConfig, function(a, b)
			if a.eventType == b.eventType then
				return a.condition < b.condition
			else
				return a.eventType < b.eventType
			end
		end)
	end
	return self.developArmyConfig
end
function newActivityCtrl:getDevelopArmamentInfo()
	local activityID = gActivityTimeActivityID.DEVELOP_ARMAMENT_ACTIVITY
	if not self.newActivityData then
		_ENV = self.newActivityData
	end
	self.newActivityData = self.newActivityData
	if not self.newActivityData[tostring(activityID)] then
		_ENV = self.newActivityData[tostring(activityID)]
	end
	self.newActivityData[tostring(activityID)] = self.newActivityData[tostring(activityID)]
	local _ENV, ret = self.newActivityData, self.newActivityData
	ret.score = self.newActivityData[tostring(activityID)].score or 0
	ret.rank = self.newActivityData[tostring(activityID)].rank or 0
	ret.opencount = self.newActivityData[tostring(activityID)].opencount or 0
	return ret
end
function newActivityCtrl:getDevelopArmamentStage()
	local activityID = gActivityTimeActivityID.DEVELOP_ARMAMENT_ACTIVITY
	if not self.newActivityData then
		_ENV = self.newActivityData
	end
	self.newActivityData = self.newActivityData
	if not self.newActivityData[tostring(activityID)] then
		_ENV = self.newActivityData[tostring(activityID)]
	end
	self.newActivityData[tostring(activityID)] = self.newActivityData[tostring(activityID)]
	return self.newActivityData[tostring(activityID)].stage or 0
end
function newActivityCtrl:getDevelopArmyReward()
	local activityID = gActivityTimeActivityID.DEVELOP_ARMAMENT_ACTIVITY
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local group = activityShowCtrl:getParamByID(activityID).classtype or 1
	if not self.developArmyReward then
		self.developArmyReward, _ENV = self.developArmyReward, self.developArmyReward
		local tmp = newActivityRead.getDevelopArmyStage()
		for key, value in pairs(tmp) do
			if value.group == group then
				local _ENV, data = value.group, value.group
				data.needscore = value.needscore
				data.stage = value.stage
				_UPVALUE2_ = nil
				;(nil)[1] = "id"
				;(nil)[2] = "count"
				data.reward = serviceFunctions.tableFormat(value.reward, nil)
				table.insert(self.developArmyReward, data)
			end
		end
	end
	return self.developArmyReward
end
function newActivityCtrl:getDevelopArmyRankReward()
	local activityID = gActivityTimeActivityID.DEVELOP_ARMAMENT_ACTIVITY
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local group = activityShowCtrl:getParamByID(activityID).classtype or 1
	if not self.developArmyRank then
		self.developArmyRank, _ENV = self.developArmyRank, self.developArmyRank
		local tmp = newActivityRead.getDevelopArmyRankData()
		for _, value in ipairs(tmp) do
			if value.group == group then
				local _ENV, data = value.group, value.group
				data.rank = value.rank
				_UPVALUE2_ = nil
				;(nil)[1] = "id"
				;(nil)[2] = "count"
				data.reward = serviceFunctions.tableFormat(value.reward, nil)
				table.insert(self.developArmyRank, data)
			end
		end
	end
	return self.developArmyRank
end
function newActivityCtrl:getDevelopArmyHistoryRank()
	local _ENV, ret
	if type(self.developArmyHistoryRank) == "table" then
		for _, value in pairs(self.developArmyHistoryRank) do
			if value.beginTime and value.endTime then
				table.insert(ret, value)
			end
		end
		table.sort(ret, function(a, b)
			return a.endTime > b.endTime
		end)
	end
	return ret
end
function newActivityCtrl:getDevelopArmyAllHistoryRank()
	if not self.developArmyHistoryRank then
		_UPVALUE0_ = self.developArmyHistoryRank
	end
	return self.developArmyHistoryRank
end
function newActivityCtrl:clearDevelopData()
	self.developArmyConfig = nil
	self.developArmyReward = nil
	self.developArmyRank = nil
end
function newActivityCtrl:getPersonLimitedTimeArmyConfig()
	_UPVALUE0_ = nil
	return nil
end
function newActivityCtrl:getPersonLimitedTimeInfo()
	_UPVALUE0_ = nil
	return nil
end
function newActivityCtrl:getPersonLimitedTimeStage()
	return 0
end
function newActivityCtrl:getPersonLimitedTimeReward()
	_UPVALUE0_ = nil
	return nil
end
function newActivityCtrl:getPersonLimitedTimeRankReward()
	_UPVALUE0_ = nil
	return nil
end
function newActivityCtrl:getPersonLimitedTimeHistoryRank()
	local _ENV, ret
	if type(self.personlimitedTimeHistoryRank) == "table" then
		for _, value in pairs(self.personlimitedTimeHistoryRank) do
			if value.beginTime and value.endTime then
				table.insert(ret, value)
			end
		end
		table.sort(ret, function(a, b)
			return a.endTime > b.endTime
		end)
	end
	return ret
end
function newActivityCtrl:getCrazyScoreConfig()
	if not self.crazyScoreConfig then
		self.crazyScoreConfig, newActivityRead = self.crazyScoreConfig, self.crazyScoreConfig
		local tmp = newActivityRead.getCrazyScorePoint()
		for key, value in pairs(tmp) do
			local newActivityRead, data
			data.eventType = value.eventID
			data.condition = value.condition[1]
			data.point = 0
			if value.rewardPoint[1] and value.rewardPoint[2] and value.rewardPoint[2] ~= 0 then
				data.point = value.rewardPoint[1] / value.rewardPoint[2]
			end
			table.insert(self.crazyScoreConfig, data)
		end
		table.sort(self.crazyScoreConfig, function(a, b)
			if a.eventType == b.eventType then
				return a.condition < b.condition
			else
				return a.eventType < b.eventType
			end
		end)
	end
	return self.crazyScoreConfig
end
function newActivityCtrl:getCrazyScoreStageReward()
	if not self.crazyScoreStageReward then
		self.crazyScoreStageReward, newActivityRead = self.crazyScoreStageReward, self.crazyScoreStageReward
		local tmp = newActivityRead.getCrazyScoreStageReward()
		for key, value in ipairs(tmp) do
			local newActivityRead, data
			data.needscore = value.needscore
			data.stage = value.stage
			data.reward = value.reward
			data.price = value.price
			table.insert(self.crazyScoreStageReward, data)
		end
	end
	return self.crazyScoreStageReward
end
function newActivityCtrl:getCrazyScoreRankReward(rankType)
	if not self.crazyScoreRankReward then
		newActivityRead = self.crazyScoreRankReward
	end
	self.crazyScoreRankReward = self.crazyScoreRankReward
	if not self.crazyScoreRankReward[rankType] then
		self.crazyScoreRankReward[rankType], newActivityRead = nil, nil
		local tmp = newActivityRead.getCrazyScoreRankReward()
		for _, value in ipairs(tmp) do
			local newActivityRead, data
			data.rank = value.rank
			data.reward = value.reward
			data.specialGiftType = value.specialGiftType
			if rankType == tostring(value.type) then
				table.insert(self.crazyScoreRankReward[rankType], data)
			end
		end
	end
	return self.crazyScoreRankReward[rankType]
end
function newActivityCtrl:getCrazyScoreStage()
	local activityID = gActivityTimeActivityID.CRAZY_GET_POINT_ACTIVITY
	if not self.newActivityData then
		_ENV = self.newActivityData
	end
	self.newActivityData = self.newActivityData
	if not self.newActivityData[tostring(activityID)] then
		_ENV = self.newActivityData[tostring(activityID)]
	end
	self.newActivityData[tostring(activityID)] = self.newActivityData[tostring(activityID)]
	return self.newActivityData[tostring(activityID)].stage or 0
end
function newActivityCtrl:getCrazyScoreInfo()
	local activityID = gActivityTimeActivityID.CRAZY_GET_POINT_ACTIVITY
	if not self.newActivityData then
		_ENV = self.newActivityData
	end
	self.newActivityData = self.newActivityData
	if not self.newActivityData[tostring(activityID)] then
		_ENV = self.newActivityData[tostring(activityID)]
	end
	self.newActivityData[tostring(activityID)] = self.newActivityData[tostring(activityID)]
	local _ENV, ret = self.newActivityData, self.newActivityData
	ret.score = self.newActivityData[tostring(activityID)].score or 0
	ret.rank = self.newActivityData[tostring(activityID)].rank or 0
	ret.opencount = self.newActivityData[tostring(activityID)].opencount or 0
	ret.kidRank = self.newActivityData[tostring(activityID)].kidRank or 0
	ret.aidRank = self.newActivityData[tostring(activityID)].aidRank or 0
	ret.aidScore = self.newActivityData[tostring(activityID)].aidScore or 0
	ret.kidScore = self.newActivityData[tostring(activityID)].kidScore or 0
	return ret
end
function newActivityCtrl:clearCrazyRankData()
	self.crazyScoreRankKidData, _UPVALUE0_, self.crazyScoreRankAidData, _UPVALUE0_, self.crazyScoreRankUidData, _UPVALUE0_ = nil, nil, nil, nil, nil, nil
end
function newActivityCtrl:reqFlowerActivityInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_FLOWER_ACTIVITY_PERSONAL_INFO, data)
end
function newActivityCtrl:reqFlowerRankData(rankType)
	serverproxy = nil
	local (nil).rankType, data = rankType, nil
	serverproxy:Request(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_FLOWER_ACTIVITY_RANK_DATA, data)
end
function newActivityCtrl:reqGetFlowerRankAward(rankType, gears)
	serverproxy = nil
	;(nil).rankType = rankType
	local (nil).gears, data = gears, nil
	serverproxy:Request(gCmd.CMD_NEW_ACTIVITY_MODULE, gCmd.REQ_GET_FLOWER_ACTIVITY_AWARD, data)
end
function newActivityCtrl:rspFlowerActivityInfo(content)
	dump(content, "rspFlowerActivityInfo", 10)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		self.floweractivityPersonalInfo = data
	end
	_ENV = 10
	;(10).msg = "MESSAGE_SERVER_EVENTCENTER_FLOWER_REFRESH"
	SoraDSendMessage(10)
	_ENV = 10
	;(10).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	;(10).eventID = gActivityTimeActivityID.FLOWER_ACTIVITY_RANK
	SoraDSendMessage(10)
end
function newActivityCtrl:rspFlowerRankData(content)
	local err = content.err
	if err ~= gErrDef.Err_None then
		return
	end
	if content.data then
		self.floweractivityRankData[tonumber(content.data.rankType)] = content.rankdata
		if content.data.curSendRank then
			self.floweractivityPersonalInfo.curSendRank = content.data.curSendRank
		end
		if content.data.curReceiveRank then
			self.floweractivityPersonalInfo.curReceiveRank = content.data.curReceiveRank
		end
	end
	_ENV = content.data.curReceiveRank
	content.data.curReceiveRank.msg = "MESSAGE_SERVER_EVENTCENTER_FLOWER_REFRESH"
	content.data.curReceiveRank.isRank = true
	SoraDSendMessage(content.data.curReceiveRank)
end
function newActivityCtrl:rspGetFlowerRankAward(content)
	local data = content.data
	local err = content.err
	if err ~= gErrDef.Err_None then
		return
	end
	if self.floweractivityPersonalInfo then
		self.floweractivityPersonalInfo.awardFlag = data.awardFlag
	end
	_ENV = data.awardFlag
	data.awardFlag.msg = "MESSAGE_SERVER_EVENTCENTER_FLOWER_REFRESH"
	data.awardFlag.index = data.index
	data.awardFlag.style = data.rankType
	SoraDSendMessage(data.awardFlag)
	_ENV = data.awardFlag
	data.awardFlag.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	data.awardFlag.eventID = gActivityTimeActivityID.FLOWER_ACTIVITY_RANK
	SoraDSendMessage(data.awardFlag)
end
function newActivityCtrl:getReceiveStatusAndNum()
	if self.floweractivityPersonalInfo then
		local awardtab = newActivityRead.getFlowerActivityAllAwardData()
		local canaward = false
		local retNum = 0
		for k, v in pairs(awardtab) do
			local index = v.index
			local content = v.content
			local gears = v.gears
			if not self.floweractivityPersonalInfo.awardFlag[index] or self.floweractivityPersonalInfo.awardFlag[index] == gFlowerActivityAwardStatus.NOT_AWARDED then
				if content == gFlowerActivityRankType.SEND_FLOWER_RANK then
					if gears <= self.floweractivityPersonalInfo.sendNum then
						canaward = true
						retNum = retNum + 1
					end
				elseif content == gFlowerActivityRankType.RECEIVE_FLOWER_RANK and gears <= self.floweractivityPersonalInfo.receiveNum then
					canaward = true
					retNum = retNum + 1
				end
			end
		end
		return canaward, retNum
	else
		return false, 0
	end
end
return newActivityCtrl
