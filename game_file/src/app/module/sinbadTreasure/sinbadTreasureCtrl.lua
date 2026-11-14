local gametop = gModuleMgr.getObject("gametop")
local GameModule = include("GameModule")
local sinbadTreasureCtrl = class("sinbadTreasureCtrl", GameModule)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function sinbadTreasureCtrl:ctor(properties)
	sinbadTreasureCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.SINBAD_TREASURE
end
function sinbadTreasureCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SINBAD_HOARD_DATA, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SINBAD_HOARD_KINGDOM_BLESSING_RANK, handler(self, self.reqKingdomRankRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SINBAD_HOARD_GLOBAL_BLESSING_RANK, handler(self, self.reqGlobalRankRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SINBAD_HOARD_KINGDOM_DECORATE_LV_REWARD, handler(self, self.reqStageOneRewardRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SINBAD_HOARD_BLESSING, handler(self, self.reqStageTwoRewardRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SINBAD_HOARD_BLESSING_EXT_REWARD, handler(self, self.reqStageTwoExtraRewardRsp))
	self:resetData()
	self:registerNotify()
end
function sinbadTreasureCtrl:notifyPop(data)
	if data[tostring(self.activityID)] then
		self.activityData.kingdomDecoratePoint = data[tostring(self.activityID)].kingdomDecoratePoint
	end
	if data[tostring(self.activityID)] then
		self.activityData.notifiedKingdomDecorateLv = data[tostring(self.activityID)].notifiedKingdomDecorateLv
	end
end
function sinbadTreasureCtrl:initClientData(data)
	if not data then
		return
	end
	self:notifyPop(data)
end
function sinbadTreasureCtrl:resetData()
	_UPVALUE0_, self.kingdomRankData, _UPVALUE0_, self.globalRankData, _UPVALUE0_ = nil, nil, nil, nil, nil
	;(nil).selfDecoratePoint = 0
	;(nil).gotKingdomDecorateLvReward, _UPVALUE0_, (nil).notifiedKingdomDecorateLv = nil, nil, 0
	;(nil).selfBlessingNum = 0
	;(nil).lastGotExtRewardBlessingNum = 0
	;(nil).kingdomDecoratePoint = 0
	self.activityData, (nil).activityStage = nil, 0
end
function sinbadTreasureCtrl:Logout()
	self:resetData()
	sinbadTreasureCtrl.super.Logout(self)
end
function sinbadTreasureCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
end
function sinbadTreasureCtrl:notifyHandler(event)
	dump(event.data, "sinbadTreasureCtrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
		if content.activityID == self.activityID then
			if content.notifyType == "sinbadHoardUpgrade" then
				self.activityData.notifiedKingdomDecorateLv = content.notifyData.lv
				self.activityData.kingdomDecoratePoint = content.notifyData.point
				_ENV = nil
				;(nil).byUID = true
				SoraDConfigSet("Game:sinbadTreasurePopVew:first~bool", true, nil)
				_ENV = "Game:sinbadTreasurePopVew:first~bool"
				;("Game:sinbadTreasurePopVew:first~bool").msg = "MESSAGE_SINBAD_TREASURE_UPDATE_LV_POP_WINDOW"
				SoraDSendMessage("Game:sinbadTreasurePopVew:first~bool")
			elseif content.notifyType == "progressUpdate" then
				_ENV = "Game:sinbadTreasurePopVew:first~bool"
				;("Game:sinbadTreasurePopVew:first~bool").msg = "MESSAGE_SINBAD_TREASURE_PREPARE_FINISH"
				SoraDSendMessage("Game:sinbadTreasurePopVew:first~bool")
			elseif content.notifyType == "updateData" then
				self.activityData.kingdomDecoratePoint = content.notifyData.kingdomDecoratePoint
				self.activityData.selfDecoratePoint = content.notifyData.selfDecoratePoint
				_ENV = content.notifyData.selfDecoratePoint
				content.notifyData.selfDecoratePoint.msg = "MESSAGE_SINBAD_TREASURE_SCORE_UPDATE"
				SoraDSendMessage(content.notifyData.selfDecoratePoint)
			end
		end
	end
end
function sinbadTreasureCtrl:reqInitInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SINBAD_HOARD_DATA, data)
end
function sinbadTreasureCtrl:reqKingdomRank()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SINBAD_HOARD_KINGDOM_BLESSING_RANK, data)
end
function sinbadTreasureCtrl:reqGlobalRank()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SINBAD_HOARD_GLOBAL_BLESSING_RANK, data)
end
function sinbadTreasureCtrl:reqStageOneReward(lv)
	serverproxy = nil
	local (nil).lv, data = lv, nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SINBAD_HOARD_KINGDOM_DECORATE_LV_REWARD, data)
end
function sinbadTreasureCtrl:reqStageTwoReward(num)
	serverproxy = nil
	local (nil).num, data = num, nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SINBAD_HOARD_BLESSING, data)
end
function sinbadTreasureCtrl:reqStageTwoExtraReward(num)
	serverproxy = nil
	local (nil).num, data = num, nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SINBAD_HOARD_BLESSING_EXT_REWARD, data)
end
function sinbadTreasureCtrl:reqInitRsp(content)
	dump(content, "sinbadTreasureCtrl:reqInitRsp===", 10)
	if content.err == gErrDef.Err_None then
		for k, v in pairs(content.rspdata) do
			self.activityData[k] = v
		end
		_ENV = pairs(content.rspdata)
		pairs(content.rspdata).msg = "MESSAGE_SINBAD_TREASURE_INIT"
		SoraDSendMessage(pairs(content.rspdata))
	end
end
function sinbadTreasureCtrl:getSelfPlayerInfo()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	gametop = gametop.playertop_
	gametop.playertop_.uid = gametop.playertop_:getPlayerID()
	gametop.playertop_.score = self.activityData.selfBlessingNum
	gametop.playertop_.kid = lordInfoCtrl:getSourceKid()
	gametop.playertop_.headid = lordInfoCtrl:getLordInfo().base.imageId
	gametop.playertop_.avatar = lordInfoCtrl:getAvatar()
	gametop.playertop_.allianceAbb = allianceMgr:getAllianceProperty("abbr")
	gametop.playertop_.allianceName = allianceMgr:getAllianceProperty("name")
	gametop.playertop_.name = lordInfoCtrl:getLordInfo().base.nickName
	local gametop.playertop_.rank, selfInfo = 0, gametop.playertop_
	return selfInfo
end
function sinbadTreasureCtrl:reqKingdomRankRsp(content)
	dump(content, "sinbadTreasureCtrl:reqKingdomRankRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.kingdomRankData.rankInfo = content.data.rspdata
		self.kingdomRankData.selfInfo = self:getSelfPlayerInfo()
		local isFound = false
		for i, v in ipairs(self.kingdomRankData.rankInfo) do
			v.rank = i
			v.rankType = 2
		end
		if content.data.selfRank and content.data.selfRank > 0 and content.data.selfRank < 1000 then
			self.kingdomRankData.selfInfo.rank = content.data.selfRank
		end
		_ENV = content.data.selfRank
		content.data.selfRank.msg = "MESSAGE_SINBAD_TREASURE_KINGDOM_RANK_REFRESH"
		SoraDSendMessage(content.data.selfRank)
	end
end
function sinbadTreasureCtrl:reqGlobalRankRsp(content)
	dump(content, "sinbadTreasureCtrl:reqGlobalRankRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.globalRankData.rankInfo = content.data.rspdata
		self.globalRankData.selfInfo = self:getSelfPlayerInfo()
		local isFound = false
		for i, v in ipairs(self.globalRankData.rankInfo) do
			v.rank = i
			v.rankType = 3
		end
		if content.data.selfRank and content.data.selfRank > 0 and content.data.selfRank <= 2000 then
			self.globalRankData.selfInfo.rank = content.data.selfRank
		end
		_ENV = content.data.selfRank
		content.data.selfRank.msg = "MESSAGE_SINBAD_TREASURE_GLOBAL_RANK_REFRESH"
		SoraDSendMessage(content.data.selfRank)
	end
end
function sinbadTreasureCtrl:reqStageOneRewardRsp(content)
	dump(content, "sinbadTreasureCtrl:reqStageOneRewardRsp===", 10)
	if content.err == gErrDef.Err_None then
		local reward = content.rspdata.reward
		if reward then
			SoraDMailGainItems(reward, true)
		end
		local lv = content.data.lv
		self.activityData.gotKingdomDecorateLvReward[tostring(lv)] = true
		if content.rspdata.updateData then
			for k, v in pairs(content.rspdata.updateData) do
				self.activityData[k] = v
			end
		end
		_ENV = pairs(content.rspdata.updateData)
		pairs(content.rspdata.updateData).msg = "MESSAGE_SINBAD_TREASURE_STAGE_REWARD_REFRESH"
		SoraDSendMessage(pairs(content.rspdata.updateData))
		_ENV = pairs(content.rspdata.updateData)
		pairs(content.rspdata.updateData).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		pairs(content.rspdata.updateData).eventID = self.activityID
		SoraDSendMessage(pairs(content.rspdata.updateData))
	end
end
function sinbadTreasureCtrl:reqStageTwoRewardRsp(content)
	dump(content, "sinbadTreasureCtrl:reqStageTwoRewardRsp===", 10)
	if content.err == gErrDef.Err_None then
		if content.rspdata.updateData then
			for k, v in pairs(content.rspdata.updateData) do
				self.activityData[k] = v
			end
		end
	elseif content.err == gErrDef.Err_ITEM_IS_NOT_ENOUGH then
	end
	_ENV = gErrDef.Err_ITEM_IS_NOT_ENOUGH
	gErrDef.Err_ITEM_IS_NOT_ENOUGH.msg = "MESSAGE_SINBAD_TREASURE_KEY_ROTTERY_REWARD_REFRESH"
	if not content.rspdata or not content.rspdata.reward then
		_ENV = content.rspdata.reward
	end
	gErrDef.Err_ITEM_IS_NOT_ENOUGH.rewardList = content.rspdata.reward
	gErrDef.Err_ITEM_IS_NOT_ENOUGH.num = content.data.num
	SoraDSendMessage(gErrDef.Err_ITEM_IS_NOT_ENOUGH)
end
function sinbadTreasureCtrl:reqStageTwoExtraRewardRsp(content)
	dump(content, "sinbadTreasureCtrl:reqStageTwoExtraRewardRsp===", 10)
	if content.err == gErrDef.Err_None then
		local reward = content.rspdata.reward
		if reward then
			_ENV = 10
			;(10).isArray = true
			SoraDOpenGiftView(reward, 10)
		end
		if content.rspdata.updateData then
			for k, v in pairs(content.rspdata.updateData) do
				self.activityData[k] = v
			end
		end
		_ENV = pairs(content.rspdata.updateData)
		pairs(content.rspdata.updateData).msg = "MESSAGE_SINBAD_TREASURE_EXTRA_REWARD_REFRESH"
		SoraDSendMessage(pairs(content.rspdata.updateData))
	end
end
function sinbadTreasureCtrl:getReceiveStatusAndNum()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local activityData = activityShowCtrl:getActivityData(gActivityTimeActivityID.SINBAD_TREASURE)
	if activityData.doStage and activityData.doStage ~= 0 then
		return false
	end
	local activityTaskComponentCtrl = gametop.playertop_:getModule("activityTaskComponentCtrl")
	return activityTaskComponentCtrl:getReceiveStatusAndNum(self.activityID)
end
function sinbadTreasureCtrl:getIsPopSinbadTreasureView()
	dump(self.activityData, "getIsPopSinbadTreasureView activityData", 10)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		return false
	end
	if worldMapDefine.inInCrossWar() then
		return false
	end
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local activityData = activityShowCtrl:getActivityData(gActivityTimeActivityID.SINBAD_TREASURE)
	print("sinbadTreasureCtrl:getIsPopSinbadTreasureView(), doStage = ", activityData.doStage)
	if activityData.doStage and activityData.doStage ~= 0 then
		return false
	end
	if self.activityData and next(self.activityData) ~= nil and self.activityData.kingdomDecoratePoint then
		local sinbadTreasureRead = include("sinbadTreasureRead")
		local curLv = sinbadTreasureRead.getDecorateLv(self.activityData.kingdomDecoratePoint, sinbadTreasureCtrl:getClassType())
		print("self.activityData.notifiedKingdomDecorateLv = ", self.activityData.notifiedKingdomDecorateLv, ", curLv = ", curLv)
		if not self.activityData.notifiedKingdomDecorateLv or curLv >= self.activityData.notifiedKingdomDecorateLv then
			print("self.activityData.kingdomDecoratePoint = ", self.activityData.kingdomDecoratePoint, ",sinbadTreasureCtrl:getIsPopSinbadTreasureView: curLv = ", curLv, ", notifiedKingdomDecorateLv = ", self.activityData.notifiedKingdomDecorateLv)
			if 2 <= curLv then
				print("返回true-------")
				return true
			end
		end
	end
	print("返回false-----")
	return false
end
function sinbadTreasureCtrl:getActivityData()
	return self.activityData
end
function sinbadTreasureCtrl:getRankData(rankType)
	if rankType == 1 then
		return self.globalRankData
	elseif rankType == 2 then
		return self.kingdomRankData
	end
end
function sinbadTreasureCtrl:isClaimedReward(lv)
	if self.activityData.gotKingdomDecorateLvReward[tostring(lv)] then
		return true
	end
	return false
end
function sinbadTreasureCtrl:getNextBlessRewardNum()
	if not self.activityData or not self.activityData.selfBlessingNum then
		return 0, gMaxBlessingRewardNum
	end
	print("selfBlessingNum = ", self.activityData.selfBlessingNum, ", self.activityData.lastGotExtRewardBlessingNum = ", self.activityData.lastGotExtRewardBlessingNum)
	local num = math.floor((self.activityData.selfBlessingNum or 0) / gMaxBlessingRewardNum) - math.floor((self.activityData.lastGotExtRewardBlessingNum or 0) / gMaxBlessingRewardNum)
	local nextNum = gMaxBlessingRewardNum - math.fmod(self.activityData.selfBlessingNum, gMaxBlessingRewardNum)
	if 0 < num then
		return num, nextNum
	else
		return num, nextNum
	end
end
function sinbadTreasureCtrl:getPersonalRankInfo()
	local _ENV, topRank
	local _ENV, remainRank
	if next(self.kingdomRankData.rankInfo) then
		for i, v in ipairs(self.kingdomRankData.rankInfo) do
			if i <= 3 then
				table.insert(topRank, v)
			else
				table.insert(remainRank, v)
			end
		end
	end
	return topRank, remainRank
end
function sinbadTreasureCtrl:getAllianceRankInfo()
	local _ENV, topRank
	local _ENV, remainRank
	if next(self.globalRankData.rankInfo) then
		for i, v in ipairs(self.globalRankData.rankInfo) do
			if i <= 3 then
				table.insert(topRank, v)
			else
				table.insert(remainRank, v)
			end
		end
	end
	return topRank, remainRank
end
function sinbadTreasureCtrl:getMyPersonalRankInfo()
	return self.kingdomRankData.selfInfo
end
function sinbadTreasureCtrl:getMyAllianceRankInfo()
	return self.globalRankData.selfInfo
end
function sinbadTreasureCtrl:getClassType()
	return SoraDGetCtrl("activityShowCtrl"):getParamClassType(gActivityTimeActivityID.SINBAD_TREASURE)
end
return sinbadTreasureCtrl
