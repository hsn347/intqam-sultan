local gamemodulec = include("GameModule")
local activity_9001737_Ctrl = class("activity_9001737_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001737_Read = include("activity_9001737_Read")
function activity_9001737_Ctrl:ctor(properties)
	activity_9001737_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY
	self:resetData()
end
function activity_9001737_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_FOOTBALL_MONSTER_ASSIGN_INIT, handler(self, self.reqAssignInitRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_FOOTBALL_MONSTER_ASSIGN_CAMP, handler(self, self.reqAssignCampRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_FOOTBALL_MONSTER_MEMBER_RANKLIST, handler(self, self.reqMemberRanklistRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_FOOTBALL_MONSTER_CLAIM_REWARD, handler(self, self.reqClaimRewardRsp))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.activityInitRsp))
end
function activity_9001737_Ctrl:Logout()
	activity_9001737_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001737_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).campId = 0
	self.msgData, (nil).campRank, _UPVALUE0_, (nil).pointReward, _UPVALUE0_, (nil).point = nil, nil, nil, nil, nil, 0
end
function activity_9001737_Ctrl:initClientData(userActivityModule)
end
function activity_9001737_Ctrl:activityInitRsp(target, event)
	if event.activityID == self.activityID then
		dump(event, "==activity_9001737_Ctrl:activityInitRsp==", 10)
		for k, v in pairs(event.initData) do
			self.msgData[k] = v
		end
		_ENV = pairs(event.initData)
		pairs(event.initData).msg = "MESSAGE_ACTIVITY_9001737_UPDATE"
		SoraDSendMessage(pairs(event.initData))
		_ENV = pairs(event.initData)
		pairs(event.initData).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		pairs(event.initData).eventID = self.activityID
		SoraDSendMessage(pairs(event.initData))
	end
end
function activity_9001737_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_FOOTBALL_MONSTER_ASSIGN_INIT, nil)
end
function activity_9001737_Ctrl:reqAssignInitRsp(content)
	dump(content, "activity_9001737_Ctrl:reqAssignInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.msgData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001737_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001737_Ctrl:reqAssignCamp()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_FOOTBALL_MONSTER_ASSIGN_CAMP, nil)
end
function activity_9001737_Ctrl:reqAssignCampRsp(content)
	dump(content, "activity_9001737_Ctrl:reqAssignCampRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.msgData = content.rspdata
		local campCfg = activity_9001737_Read.getCampCfgByCampType(self:getMyCamp())
		_ENV = self:getMyCamp()
		self:getMyCamp().name = i18n(campCfg.campName)
		SoraDShowMsgTip(i18n("troublemaker_text_04", self:getMyCamp()))
		_ENV = i18n("troublemaker_text_04", self:getMyCamp())
		i18n("troublemaker_text_04", self:getMyCamp()).msg = "MESSAGE_ACTIVITY_9001737_ASSIGN"
		SoraDSendMessage(i18n("troublemaker_text_04", self:getMyCamp()))
	end
end
function activity_9001737_Ctrl:reqMemberRanklist(campId)
	local campId = campId or self:getMyCamp()
	serverproxy = nil
	;(nil).campId = campId
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_FOOTBALL_MONSTER_MEMBER_RANKLIST, nil)
end
function activity_9001737_Ctrl:reqMemberRanklistRsp(content)
	dump(content, "activity_9001737_Ctrl:reqMemberRanklistRsp(content)", 10)
	if content.err == gErrDef.Err_None or content.err == nil then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001737_RANK"
		gErrDef.Err_None.myInfo = content.rspdata.myInfo
		gErrDef.Err_None.rankList = content.rspdata.rankList
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001737_Ctrl:reqClaimReward(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_FOOTBALL_MONSTER_CLAIM_REWARD, nil)
end
function activity_9001737_Ctrl:reqClaimRewardRsp(content)
	dump(content, "activity_9001737_Ctrl:reqClaimRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if content.rspdata then
			self.msgData = content.rspdata.initData
			local reward = content.rspdata.reward
			if reward and next(reward) then
				SoraDMailGainItems(reward, true)
			end
		end
		_ENV = SoraDMailGainItems
		SoraDMailGainItems.msg = "MESSAGE_ACTIVITY_9001737_UPDATE"
		SoraDSendMessage(SoraDMailGainItems)
	end
end
function activity_9001737_Ctrl:getReceiveStatusAndNum()
	local num = self:getStageRewardNum()
	return 0 < num, num
end
function activity_9001737_Ctrl:getStageRewardNum()
	local activity_9001737_Read = include("activity_9001737_Read")
	local stageCfg = activity_9001737_Read.getStageRewardCfg()
	local num = 0
	for k, v in ipairs(stageCfg) do
		if self:getStageBoxStatues(v.stage, v.point) == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	return num
end
function activity_9001737_Ctrl:getMyCamp()
	return self.msgData.campId or 0
end
function activity_9001737_Ctrl:getEnemyCamp()
	local campCfg = activity_9001737_Read.getCampCfgByCampType(self:getMyCamp())
	return campCfg.hostileCamp
end
function activity_9001737_Ctrl:getPoint()
	return self.msgData.point or 0
end
function activity_9001737_Ctrl:getStageBoxStatues(stage, point)
	local state = self.msgData.pointReward[tostring(stage)] and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	if state ~= gBtnTargetStatusDef.GOT and point <= self:getPoint() then
		state = gBtnTargetStatusDef.GET
	end
	return state
end
function activity_9001737_Ctrl:getCampRank()
	if not self.msgData.campRank then
		_UPVALUE0_ = self.msgData.campRank
	end
	return self.msgData.campRank
end
function activity_9001737_Ctrl:getCampRankInfoByCamp(campId)
	local _ENV, rankInfo
	local rank
	local campId = campId or self:getMyCamp()
	for k, v in ipairs(self.msgData.campRank) do
		if v.campId == campId then
			rank = k
			rankInfo.rank = k
			rankInfo.point = v.point
			break
		end
	end
	return rank, rankInfo
end
function activity_9001737_Ctrl:getCampRankInfo(rank)
	if not self.msgData.campRank[rank] then
		_UPVALUE0_ = self.msgData.campRank[rank]
	end
	return self.msgData.campRank[rank]
end
function activity_9001737_Ctrl:getPointDiff()
	local rank, myInfo = self:getCampRankInfoByCamp(self:getMyCamp())
	if rank == 1 then
		local myPoint = self:getCampRankInfo(1).point or 0
		local secondPoint = self:getCampRankInfo(2).point or 0
		local diffPoint = myPoint - secondPoint
		return true, diffPoint
	else
		local firstPoint = self:getCampRankInfo(1).point or 0
		local myPoint = self:getCampRankInfo(rank).point or 0
		local diffPoint = firstPoint - myPoint
		return false, diffPoint
	end
end
function activity_9001737_Ctrl:getCampRankList(isEx)
	local activity_9001737_Read, campList
	local cfgList = activity_9001737_Read.getCampCfgList()
	local exRank = #self.msgData.campRank
	for k, v in ipairs(cfgList) do
		if isEx and v.campType ~= self:getMyCamp() or not isEx then
			local rank, rankInfo = self:getCampRankInfoByCamp(v.campType)
			if not rank then
				rankInfo, activity_9001737_Read = v.campType, v.campType
				rankInfo.rank = exRank + 1
				rankInfo.point = 0
				exRank = exRank + 1
			end
			activity_9001737_Read = nil
			;(nil).campType = v.campType
			;(nil).campIcon = v.campIcon
			;(nil).campName = v.campName
			;(nil).rankInfo = rankInfo
			table.insert(campList, nil)
		end
	end
	return campList
end
return activity_9001737_Ctrl
