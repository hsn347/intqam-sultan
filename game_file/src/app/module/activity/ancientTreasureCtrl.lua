local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local ancientTreasureCtrl = class("ancientTreasureCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function ancientTreasureCtrl:ctor(properties)
	ancientTreasureCtrl.super.ctor(self, properties)
end
function ancientTreasureCtrl:Logout()
	ancientTreasureCtrl.super.Logout(self)
	self:resetData()
end
function ancientTreasureCtrl:resetData()
	self.receivedReward, _UPVALUE0_, self.complete, _UPVALUE0_, self.stageDatas, _UPVALUE0_ = nil, nil, nil, nil, nil, nil
	self.wishCount = 0
	self.alliaTreasureOpenCount = 0
	self.defeatMonsterCount = 0
	self.speedUpDecrTime = 0
	self.reward, _UPVALUE0_, self.allicreward, _UPVALUE0_, self.allicbuilds, _UPVALUE0_, self.building, _UPVALUE0_, self.completeCount = nil, nil, nil, nil, nil, nil, nil, nil, 0
end
function ancientTreasureCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ANCIENT_TREASURE_MODULE, gCmd.REQ_ANCIENT_TREASURE_INIT, handler(self, self.getInitDataRsp))
	msgCtrl.register(gCmd.CMD_ANCIENT_TREASURE_MODULE, gCmd.REQ_ANCIENT_TREASURE_GET_REWARD, handler(self, self.getRewardRsp))
	msgCtrl.register(gCmd.CMD_ANCIENT_TREASURE_MODULE, gCmd.REQ_ANCIENT_TREASURE_GET_GIFT_INFO, handler(self, self.getGiftInfoRsp))
	msgCtrl.register(gCmd.CMD_ANCIENT_TREASURE_MODULE, gCmd.REQ_ANCIENT_TREASURE_GET_GIFT_REWARD, handler(self, self.getGiftRewardRsp))
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY) then
		self:sendGetGiftInfoMsg()
	end
end
function ancientTreasureCtrl:initClientData(data)
	dump(data, "ancientTreasureCtrl:initClientData===", 10)
	if data then
		self:setData(data)
	end
	self:registerNotify()
end
function ancientTreasureCtrl:updateDataByItemLogic(data)
	if data.result then
		local result = data.result
		local playerID = gametop.playertop_:getPlayerID()
		local info = self:getBuildInfo(result.buildID)
		if info then
			info.spadeCount = result.allicSpadeCount or info.spadeCount
			info.torchCount = result.allicTorchCount or info.torchCount
			local playerInfo = info.useItemInfo[tostring(playerID)]
			if playerInfo then
				playerInfo.torchCount = result.selfTorchCount or playerInfo.torchCount
				playerInfo.spadeCount = result.selfSpadeCount or playerInfo.spadeCount
			end
		end
	end
end
function ancientTreasureCtrl:getBuildInfo(buildID)
	if self.allicbuilds.buildList then
		return self.allicbuilds.buildList[tostring(buildID)]
	end
end
function ancientTreasureCtrl:getPlayerBuildInfo(buildID)
	local playerID = gametop.playertop_:getPlayerID()
	local info = self:getBuildInfo(buildID)
	if info then
		return info.useItemInfo[tostring(playerID)]
	end
end
function ancientTreasureCtrl:setData(data)
	if not data.stageDatas then
		_ENV = data.stageDatas
	end
	for k, v in pairs(data.stageDatas) do
		self.stageDatas[k] = v
	end
	if not data.complete then
		_ENV = data.complete
	end
	self.complete = data.complete
	if not data.receivedReward then
		_ENV = data.receivedReward
	end
	self.receivedReward = data.receivedReward
	self.wishCount = data.wishCount
	self.alliaTreasureOpenCount = data.alliaTreasureOpenCount
	self.defeatMonsterCount = data.defeatMonsterCount
	self.speedUpDecrTime = data.speedUpDecrTime
	self.completeCount = data.completeCount
	if not data.building then
		_ENV = data.building
	end
	self.building = data.building
end
function ancientTreasureCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.ANCIENT_TREASURE_ACTIVITY, handler(self, self.notifyHandler))
	notifyCtrl:register(gNotifyID.ALLIANCE_MEMBERS_GIFTS, handler(self, self.notifyGifts))
end
function ancientTreasureCtrl:notifyGifts(event)
	dump(event, "notifyGifts", 5)
	for _, data in ipairs(event.data) do
		if data.activityID == gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY then
			self.reward = data.rewards
			_ENV = gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY
			gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY.eventID = gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY
			SoraDSendMessage(gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY)
		end
	end
end
function ancientTreasureCtrl:notifyHandler(event)
	dump(event.data, "ancientTreasureCtrl:notifyHandler", 10)
	local msgType, removeID
	for _, content in ipairs(event.data) do
		msgType = content.type
		if content.type == "stageChang" then
			local stageType = content.data.stageType
			if self.stageDatas[tostring(stageType)] then
				self.stageDatas[tostring(stageType)].stageStatus = content.data.stageStatus
			end
		elseif content.type == "taskCompete" then
			for k, v in pairs(content.data) do
				self.complete[tostring(v)] = true
			end
		elseif content.type == "alliaMiningNum" then
			self.allicreward.miningNums = content.data.alliaMiningNum
		elseif content.type == "buildChange" then
			local result = content.data.buildChange
			for k, v in pairs(result) do
				local info = self:getBuildInfo(k)
				if info then
					info.spadeCount = v.spadeCount or info.spadeCount
					info.torchCount = v.torchCount or info.torchCount
					local playerID = gametop.playertop_:getPlayerID()
					local playerInfo = info.useItemInfo[tostring(playerID)]
					local resultInfo = v.useItemInfo[tostring(playerID)]
					if playerInfo and resultInfo then
						playerInfo.torchCount = resultInfo.torchCount or playerInfo.torchCount
						playerInfo.spadeCount = resultInfo.spadeCount or playerInfo.spadeCount
					elseif not playerInfo and resultInfo then
						info.useItemInfo[tostring(playerID)] = resultInfo
					end
				end
			end
		elseif content.type == "newBuild" then
			local result = content.data.newBuild
			if not self.allicbuilds.buildList then
				self.allicbuilds.buildList, _ENV = pairs(result)
			end
			for k, v in pairs(result) do
				self.allicbuilds.buildList[k] = v
			end
		elseif content.type == "removeBuild" then
			local buildID = content.data.buildID
			if self.allicbuilds.buildList and self.allicbuilds.buildList[tostring(buildID)] then
				self.allicbuilds.buildList[tostring(buildID)] = nil
			end
			removeID = buildID
		elseif content.type == "onExploreFinished" then
			SoraDShowMsgTip(i18n("AncienTreasure_text_78"))
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	ipairs(event.data).msgType = msgType
	ipairs(event.data).removeID = removeID
	SoraDSendMessage(ipairs(event.data))
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	ipairs(event.data).eventID = gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY
	SoraDSendMessage(ipairs(event.data))
end
function ancientTreasureCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ANCIENT_TREASURE_MODULE, gCmd.REQ_ANCIENT_TREASURE_INIT, nil)
end
function ancientTreasureCtrl:sendGetRewardMsg(questID)
	serverproxy = nil
	;(nil).index = questID
	serverproxy:Request(gCmd.CMD_ANCIENT_TREASURE_MODULE, gCmd.REQ_ANCIENT_TREASURE_GET_REWARD, nil)
end
function ancientTreasureCtrl:sendGetGiftInfoMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ANCIENT_TREASURE_MODULE, gCmd.REQ_ANCIENT_TREASURE_GET_GIFT_INFO, nil)
end
function ancientTreasureCtrl:sendGetGiftRewardMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ANCIENT_TREASURE_MODULE, gCmd.REQ_ANCIENT_TREASURE_GET_GIFT_REWARD, nil)
end
function ancientTreasureCtrl:getInitDataRsp(content)
	dump(content, "ancientTreasureCtrl:getInitDataRsp", 5)
	local initData = content.rspdata
	if gErrDef.Err_None == content.err then
		self:setData(initData)
		if not content.allicbuilds then
			_ENV = content.allicbuilds
		end
		self.allicbuilds = content.allicbuilds
		if not content.allicreward then
			_ENV = content.allicreward
		end
		self.allicreward = content.allicreward
	end
	_ENV = self
	self.msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(self)
end
function ancientTreasureCtrl:getRewardRsp(content)
	dump(content, "ancientTreasureCtrl:getRewardRsp", 5)
	local data = content.rspdata
	if gErrDef.Err_None == content.err then
		self:setData(data)
		SoraDMailGainItems(content.rspreward, true)
		_ENV = content.rspreward
		content.rspreward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspreward.eventID = gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY
		SoraDSendMessage(content.rspreward)
	end
	_ENV = content.rspreward
	content.rspreward.msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	content.rspreward.isTask = true
	SoraDSendMessage(content.rspreward)
end
function ancientTreasureCtrl:getGiftInfoRsp(content)
	dump(content, "ancientTreasureCtrl:getGiftInfoRsp", 5)
	local data = content.rspdata
	if gErrDef.Err_None == content.err then
		self.reward = data.reward
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(content.err)
end
function ancientTreasureCtrl:getGiftRewardRsp(content)
	dump(content, "ancientTreasureCtrl:getGiftRewardRsp", 5)
	local data = content.rspdata
	if gErrDef.Err_None == content.err then
		self.reward, _ENV = gErrDef.Err_None, gErrDef.Err_None
		SoraDMailGainItems(data.reward, true)
	end
	_ENV = data.reward
	data.reward.msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(data.reward)
end
function ancientTreasureCtrl:getReceiveStatusAndNum()
	local num = self:getFinishTaskNum()
	local alliNum = self:getRewardCount()
	num = num + alliNum
	return 0 < num, num
end
function ancientTreasureCtrl:getFinishTaskNum()
	local n = 0
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY) and self:isTreasureStageOpen() then
		if not self.complete then
			_ENV = self.complete
		end
		for k, v in pairs(self.complete) do
			if not self.receivedReward[k] then
				n = n + 1
			end
		end
	end
	return n
end
function ancientTreasureCtrl:getRewardCount()
	local count = 0
	for k, v in ipairs(self.reward) do
		count = count + v.count
	end
	return count
end
function ancientTreasureCtrl:getTreasureOpenCount()
	return self.allicreward.miningNums
end
function ancientTreasureCtrl:getTreasureStageData(stage)
	if not self.stageDatas[tostring(stage)] then
		return 0
	end
	return self.stageDatas[tostring(stage)].stageStatus or 0
end
function ancientTreasureCtrl:isTreasureStageOpen()
	local isOpen1 = self:getTreasureStageData(gATStageType.AT_SHOW) == gATStageStatus.AT_BEGIN
	local isOpen2 = self:getTreasureStageData(gATStageType.AT_OPEN) == gATStageStatus.AT_BEGIN
	local isOpen3 = self:getTreasureStageData(gATStageType.AT_SPAWN) == gATStageStatus.AT_BEGIN
	return not isOpen1 and (isOpen2 or isOpen3)
end
function ancientTreasureCtrl:getTreasureOpenStage()
	local stage = gATStageType.AT_SHOW
	if not self.stageDatas then
		_ENV = self.stageDatas
	end
	for k, v in pairs(self.stageDatas) do
		if v.stageStatus == gATStageStatus.AT_BEGIN then
			stage = k
			break
		end
	end
	return tonumber(stage)
end
function ancientTreasureCtrl:isTaskComplete(id)
	return self.complete[tostring(id)] or false
end
function ancientTreasureCtrl:isTaskReceived(id)
	return self.receivedReward[tostring(id)] or false
end
function ancientTreasureCtrl:getCountByEvent(eventType)
	local count = 0
	if eventType == gATEventTypeDef.WISH then
		count = self.wishCount
	elseif eventType == gATEventTypeDef.ALLIANCE_TREASURE_OPEN then
		count = self.alliaTreasureOpenCount
	elseif eventType == gATEventTypeDef.DEFEAT_MONSTER then
		count = self.defeatMonsterCount
	elseif eventType == gATEventTypeDef.SPEEDUP_EFFECT_TIME then
		count = self.speedUpDecrTime
	elseif eventType == gATEventTypeDef.TASK_COMPLETE then
		count = self.completeCount
	end
	return count
end
function ancientTreasureCtrl:getTaskStatus(id, count, amount)
	local status = gBtnTargetStatusDef.GO
	count = count or 0
	if amount > count then
		status = gBtnTargetStatusDef.GO
	elseif self:isTaskReceived(id) then
		status = gBtnTargetStatusDef.GOT
	else
		status = gBtnTargetStatusDef.GET
	end
	return status
end
function ancientTreasureCtrl:getTorchCount(buildID)
	local info = self:getPlayerBuildInfo(buildID)
	return info and info.torchCount or 0
end
function ancientTreasureCtrl:getSpadeCount(buildID)
	local info = self:getPlayerBuildInfo(buildID)
	return info and info.spadeCount or 0
end
function ancientTreasureCtrl:getAllianceTorchCount(buildID)
	local info = self:getBuildInfo(buildID)
	return info and info.torchCount or 0
end
function ancientTreasureCtrl:getAllianceSpadeCount(buildID)
	local info = self:getBuildInfo(buildID)
	return info and info.spadeCount or 0
end
function ancientTreasureCtrl:getBuildType(buildID)
	local info = self:getBuildInfo(buildID)
	return info and info.buildType or 0
end
function ancientTreasureCtrl:getMiningValue(buildID)
	local info = self:getBuildInfo(buildID)
	return info and info.miningValue or 0
end
function ancientTreasureCtrl:getATUnExploreList()
	local gametop, tb
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if not self.allicbuilds.buildList then
		gametop = self.allicbuilds.buildList
	end
	for k, v in pairs(self.allicbuilds.buildList) do
		if v.buildStatus == gATBuildingStatus.AT_EXPLORE then
			v.distance = math.ceil(cc.pGetDistance(cc.p(v.buildX, v.buildY), cityCtrl:getCurCityPos()))
			v.buildID = k
			table.insert(tb, v)
		end
	end
	table.sort(tb, function(a, b)
		return a.distance < b.distance
	end)
	return tb
end
function ancientTreasureCtrl:getATExploredList()
	local gametop, tb
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if not self.allicbuilds.buildList then
		gametop = self.allicbuilds.buildList
	end
	for k, v in pairs(self.allicbuilds.buildList) do
		if v.buildStatus == gATBuildingStatus.AT_MINNING then
			v.distance = math.ceil(cc.pGetDistance(cc.p(v.buildX, v.buildY), cityCtrl:getCurCityPos()))
			v.buildID = k
			table.insert(tb, v)
		end
	end
	table.sort(tb, function(a, b)
		return a.distance < b.distance
	end)
	return tb
end
function ancientTreasureCtrl:getBuildInfoInAlliance(buildID)
	return self.allicbuilds.buildList and self.allicbuilds.buildList[tostring(buildID)] or nil
end
function ancientTreasureCtrl:isSelfJoinTreasure(buildID)
	local ret = false
	local buildInfo = self:getBuildInfoInAlliance(buildID)
	if buildInfo then
		local selfPlayerID = gametop.playertop_:getPlayerID()
		if not buildInfo.useItemInfo then
			gametop = buildInfo.useItemInfo
		end
		for k, v in pairs(buildInfo.useItemInfo) do
			if tonumber(k) == selfPlayerID then
				ret = true
				break
			end
		end
	end
	return ret
end
function ancientTreasureCtrl:getArmySpeed(armyList)
