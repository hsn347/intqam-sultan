local nebulaExplorationRead = include("nebulaExplorationRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local nebulaExplorationCtrl = class("nebulaExplorationCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function nebulaExplorationCtrl:ctor(properties)
	nebulaExplorationCtrl.super.ctor(self, properties)
	self:resetData()
end
function nebulaExplorationCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEBULE_EXPLORATION_MODULE, gCmd.REQ_NEBULE_EXPLORATION_INIT, handler(self, self.reqNebuleExplorationInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULE_EXPLORATION_MODULE, gCmd.REQ_NEBULE_EXPLORATION_EXPLORE, handler(self, self.reqNebuleExplorationExploreRsp))
	msgCtrl.register(gCmd.CMD_NEBULE_EXPLORATION_MODULE, gCmd.REQ_NEBULE_EXPLORATION_CLAIM, handler(self, self.reqNebuleExplorationClaimRsp))
end
function nebulaExplorationCtrl:Logout()
	nebulaExplorationCtrl.super.Logout(self)
	self:resetData()
end
function nebulaExplorationCtrl:resetData()
	self.gotGift, _UPVALUE0_ = nil, nil
	self.processData, _UPVALUE0_, self.curLevel = nil, nil, 1
end
function nebulaExplorationCtrl:sendReqInitDataMsg()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_EXPLORATION_ACTIVITY) then
		_ENV = nil
		serverproxy:Request(gCmd.CMD_NEBULE_EXPLORATION_MODULE, gCmd.REQ_NEBULE_EXPLORATION_INIT, nil)
	end
end
function nebulaExplorationCtrl:reqNebuleExplorationExplore(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_NEBULE_EXPLORATION_MODULE, gCmd.REQ_NEBULE_EXPLORATION_EXPLORE, nil)
end
function nebulaExplorationCtrl:reqNebuleExplorationClaim(level, index)
	serverproxy = nil
	;(nil).level = level
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_NEBULE_EXPLORATION_MODULE, gCmd.REQ_NEBULE_EXPLORATION_CLAIM, nil)
end
function nebulaExplorationCtrl:reqNebuleExplorationInitRsp(content)
	dump(content, "nebulaExplorationCtrl:reqNebuleExplorationInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.gotGift = content.rspdata.gotGift
		self.curLevel = content.rspdata.curLevel
		for i, v in pairs(content.rspdata.progress) do
			self.processData[v] = i
		end
		_ENV = pairs(content.rspdata.progress)
		pairs(content.rspdata.progress).msg = "MESSAGE_NEBULA_EXPLORATION_ACTIVITY"
		pairs(content.rspdata.progress).subMsg = "Init"
		SoraDSendMessage(pairs(content.rspdata.progress))
	end
end
function nebulaExplorationCtrl:reqNebuleExplorationExploreRsp(content)
	dump(content, "nebulaExplorationCtrl:reqNebuleExplorationExploreRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if content.rspdata.curLevel and self.curLevel ~= content.rspdata.curLevel then
			self.processData, _ENV, self.curLevel = content.rspdata.curLevel, content.rspdata.curLevel, content.rspdata.curLevel
			_ENV = content.rspdata.curLevel
			content.rspdata.curLevel.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			SoraDSendMessage(content.rspdata.curLevel)
		else
			for i, v in pairs(content.rspdata.newProgress) do
				self.processData[v] = i
			end
		end
		_ENV = pairs(content.rspdata.newProgress)
		pairs(content.rspdata.newProgress).msg = "MESSAGE_NEBULA_EXPLORATION_ACTIVITY"
		pairs(content.rspdata.newProgress).subMsg = "Explore"
		pairs(content.rspdata.newProgress).rspdata = content.rspdata
		SoraDSendMessage(pairs(content.rspdata.newProgress))
	end
end
function nebulaExplorationCtrl:reqNebuleExplorationClaimRsp(content)
	dump(content, "nebulaExplorationCtrl:reqNebuleExplorationClaimRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		for i, v in pairs(content.rspdata.gotGift) do
			self.gotGift[i] = v
		end
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_NEBULA_EXPLORATION_ACTIVITY"
		content.rspdata.reward.subMsg = "Claim"
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage(content.rspdata.reward)
	end
end
function nebulaExplorationCtrl:checkIsGotGift(index)
	if self.gotGift[tostring(index)] then
		return self.gotGift[tostring(index)]
	end
end
function nebulaExplorationCtrl:doorIndex2RewardIndex(index)
	if self.processData[index] then
		return self.processData[index]
	end
end
function nebulaExplorationCtrl:getCurLevel()
	return self.curLevel
end
function nebulaExplorationCtrl:getReceiveStatusAndNum(activityID)
	if activityID == gActivityTimeActivityID.NEBULA_EXPLORATION_ACTIVITY then
		local itemID = include("constantRead").getConstValue("NEBULA_TREASURE_CONSUME_ITEM", 864801)
		local countItem = SoraDGetCtrl("backpackCtrl"):getItemCount(itemID)
		local config = nebulaExplorationRead:getProgressCfg()
		local num = 0
		local isMaxLv = true
		for _, v in pairs(config) do
			if self.curLevel >= v.level and not self:checkIsGotGift(v.level) then
				num = num + 1
			end
			if self.curLevel < v.level then
				isMaxLv = false
			end
		end
		if isMaxLv and table.nums(self.processData) == 10 then
			countItem = 0
		end
		return 0 < num or 0 < countItem, 0 < num and num or -1
	end
end
return nebulaExplorationCtrl
