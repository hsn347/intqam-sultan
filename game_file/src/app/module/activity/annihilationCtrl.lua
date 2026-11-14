local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local annihilationCtrl = class("annihilationCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function annihilationCtrl:ctor(properties)
	annihilationCtrl.super.ctor(self, properties)
end
function annihilationCtrl:Logout()
	annihilationCtrl.super.Logout(self)
	self:resetData()
end
function annihilationCtrl:resetData()
	self.rewardFlag, _UPVALUE0_ = nil, nil
	self.score = 0
	self.opencount = 0
	self.rankData, _UPVALUE0_, self.myRank, _UPVALUE0_, self.updateTime = nil, nil, nil, nil, 0
end
function annihilationCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ANNIHILATION_MODULE, gCmd.REQ_ANNIHILATION_GET_REWARD, handler(self, self.getRewardRsp))
	msgCtrl.register(gCmd.CMD_ANNIHILATION_MODULE, gCmd.REQ_ANNIHILATION_RANK_INFO, handler(self, self.getRankInfoRsp))
end
function annihilationCtrl:initClientData(data)
	dump(data, "annihilationCtrl:initClientData===", 10)
	if data then
		self.rewardFlag = data.rewardFlag
		self.score = data.score
		self.opencount = data.opencount
		self.updateTime = data.updateTime
	end
	self:registerNotify()
end
function annihilationCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ANNIHILATION, handler(self, self.notifyHandler))
end
function annihilationCtrl:notifyHandler(event)
	dump(event, "annihilationCtrl:notifyHandler", 5)
	for _, content in ipairs(event.data) do
		local svrData = content.data
		self.opencount = svrData.opencount
		self.rewardFlag = svrData.rewardFlag
		self.score = svrData.score
		self.updateTime = svrData.updateTime
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_SERVER_ANNIHILATION_UPDATE"
	SoraDSendMessage(ipairs(event.data))
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	ipairs(event.data).eventID = gActivityTimeActivityID.ANNIHILATION
	SoraDSendMessage(ipairs(event.data))
end
function annihilationCtrl:sendReqClaimGiftMsg(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_ANNIHILATION_MODULE, gCmd.REQ_ANNIHILATION_GET_REWARD, nil)
end
function annihilationCtrl:sendReqRankDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ANNIHILATION_MODULE, gCmd.REQ_ANNIHILATION_RANK_INFO, nil)
end
function annihilationCtrl:getScore()
	return self.score
end
function annihilationCtrl:getUpdateTime()
	return self.updateTime
end
function annihilationCtrl:getMyRankData()
	return self.myRank
end
function annihilationCtrl:getRankData()
	return self.rankData
end
function annihilationCtrl:isCanClaimBox()
	local ret = false
	local num = 0
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANNIHILATION, false) and self.score and self.rewardFlag then
		local annihilationRead = include("annihilationRead")
		local config = annihilationRead.getRewardBoxInfo()
		for k, v in ipairs(config) do
			if self.score >= v.num and not self.rewardFlag[tostring(k)] then
				ret = true
				num = num + 1
			end
		end
	end
	return ret, num
end
function annihilationCtrl:getBoxStatus(index)
	local status = gBtnTargetStatusDef.GO
	local annihilationRead = include("annihilationRead")
	local boxData = annihilationRead.getRewardBoxInfo(index)
	if self.score >= boxData.num then
		status = self.rewardFlag[tostring(index)] and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GET
	end
	return status
end
function annihilationCtrl:getReceiveStatusAndNum()
	return self:isCanClaimBox()
end
function annihilationCtrl:getRewardRsp(content)
	dump(content, "annihilationCtrl:getRewardRsp", 5)
	if gErrDef.Err_None == content.err then
		self.rewardFlag = content.rspdata.rewardFlag
		SoraDMailGainItems(content.rspdata.rewardInfo, true)
		_ENV = content.rspdata.rewardInfo
		content.rspdata.rewardInfo.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.rewardInfo.eventID = gActivityTimeActivityID.ANNIHILATION
		SoraDSendMessage(content.rspdata.rewardInfo)
	end
	_ENV = content.rspdata.rewardInfo
	content.rspdata.rewardInfo.msg = "MESSAGE_SERVER_ANNIHILATION_UPDATE"
	SoraDSendMessage(content.rspdata.rewardInfo)
end
function annihilationCtrl:getRankInfoRsp(content)
	dump(content, "annihilationCtrl:getRankInfoRsp", 5)
	if gErrDef.Err_None == content.err then
		self.myRank = content.rspdata.myRank
		self.rankData = content.rspdata.rankData
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_ANNIHILATION_UPDATE"
	SoraDSendMessage(content.err)
end
return annihilationCtrl
