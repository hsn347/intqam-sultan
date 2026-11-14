local lordOfDessertRead = include("lordOfDessertRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local lordOfDessertCtrl = class("lordOfDessertCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function lordOfDessertCtrl:ctor(properties)
	lordOfDessertCtrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.LORD_OF_DESSERT_ACTIVITY
end
function lordOfDessertCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_LORD_OF_DESSERT_MODULE, gCmd.REQ_LORD_OF_DESSERT_INIT, handler(self, self.reqLordOfDessertInitRsp))
	msgCtrl.register(gCmd.CMD_LORD_OF_DESSERT_MODULE, gCmd.REQ_LORD_OF_DESSERT_DONATE, handler(self, self.reqLordOfDessertDonateRsp))
	msgCtrl.register(gCmd.CMD_LORD_OF_DESSERT_MODULE, gCmd.REQ_LORD_OF_DESSERT_RANK, handler(self, self.reqLordOfDessertRankRsp))
	msgCtrl.register(gCmd.CMD_LORD_OF_DESSERT_MODULE, gCmd.REQ_LORD_OF_DESSERT_REWARD, handler(self, self.reqLordOfDessertRewardRsp))
end
function lordOfDessertCtrl:Logout()
	lordOfDessertCtrl.super.Logout(self)
	self:resetData()
end
function lordOfDessertCtrl:resetData()
	self.score = 0
	self.gotRewardCount = 0
	self.myRank = -1
end
function lordOfDessertCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LORD_OF_DESSERT_MODULE, gCmd.REQ_LORD_OF_DESSERT_INIT, nil)
end
function lordOfDessertCtrl:reqLordOfDessertInitRsp(content)
	dump(content, "lordOfDessertCtrl:reqLordOfDessertInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.score = content.rspdata.score
		self.gotRewardCount = content.rspdata.gotRewardCount
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001538_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.Err_None.eventID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function lordOfDessertCtrl:reqLordOfDessertDonate(donateType, count)
	serverproxy = nil
	;(nil).donateType = donateType
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_LORD_OF_DESSERT_MODULE, gCmd.REQ_LORD_OF_DESSERT_DONATE, nil)
end
function lordOfDessertCtrl:reqLordOfDessertDonateRsp(content)
	dump(content, "lordOfDessertCtrl:reqLordOfDessertDonateRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.score = content.rspdata.score
		local mulTable = content.rspdata.mulTable
		_ENV = "lordOfDessertCtrl:reqLordOfDessertDonateRsp(content)"
		;("lordOfDessertCtrl:reqLordOfDessertDonateRsp(content)").msg = "MESSAGE_ACTIVITY_9001538_UPDATE"
		;("lordOfDessertCtrl:reqLordOfDessertDonateRsp(content)").mulTable = mulTable
		;("lordOfDessertCtrl:reqLordOfDessertDonateRsp(content)").reward = content.rspdata.reward
		SoraDSendMessage("lordOfDessertCtrl:reqLordOfDessertDonateRsp(content)")
		_ENV = "lordOfDessertCtrl:reqLordOfDessertDonateRsp(content)"
		;("lordOfDessertCtrl:reqLordOfDessertDonateRsp(content)").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;("lordOfDessertCtrl:reqLordOfDessertDonateRsp(content)").eventID = self.activityID
		SoraDSendMessage("lordOfDessertCtrl:reqLordOfDessertDonateRsp(content)")
	end
end
function lordOfDessertCtrl:reqLordOfDessertRank(iBegin, nCount)
	serverproxy = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_LORD_OF_DESSERT_MODULE, gCmd.REQ_LORD_OF_DESSERT_RANK, nil)
end
function lordOfDessertCtrl:reqLordOfDessertRankRsp(content)
	dump(content, "lordOfDessertCtrl:reqLordOfDessertRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local selfRank = content.rspdata.selfRank
		self.myRank = selfRank and selfRank.rank or -1
		_ENV = "lordOfDessertCtrl:reqLordOfDessertRankRsp(content)"
		;("lordOfDessertCtrl:reqLordOfDessertRankRsp(content)").msg = "MESSAGE_ACTIVITY_9001538_UPDATE"
		;("lordOfDessertCtrl:reqLordOfDessertRankRsp(content)").subMsg = "rank"
		;("lordOfDessertCtrl:reqLordOfDessertRankRsp(content)").selfRank = selfRank
		;("lordOfDessertCtrl:reqLordOfDessertRankRsp(content)").rankList = content.rspdata.rankList
		SoraDSendMessage("lordOfDessertCtrl:reqLordOfDessertRankRsp(content)")
		_ENV = "lordOfDessertCtrl:reqLordOfDessertRankRsp(content)"
		;("lordOfDessertCtrl:reqLordOfDessertRankRsp(content)").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;("lordOfDessertCtrl:reqLordOfDessertRankRsp(content)").eventID = self.activityID
		SoraDSendMessage("lordOfDessertCtrl:reqLordOfDessertRankRsp(content)")
	end
end
function lordOfDessertCtrl:reqLordOfDessertReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LORD_OF_DESSERT_MODULE, gCmd.REQ_LORD_OF_DESSERT_REWARD, nil)
end
function lordOfDessertCtrl:reqLordOfDessertRewardRsp(content)
	dump(content, "lordOfDessertCtrl:reqLordOfDessertRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.reward, true)
		self.gotRewardCount = content.rspdata.gotRewardCount
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ACTIVITY_9001538_UPDATE"
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.reward.eventID = self.activityID
		SoraDSendMessage(content.rspdata.reward)
	end
end
function lordOfDessertCtrl:getReceiveStatusAndNum()
	local maxPoint = lordOfDessertRead.getNeedIntegral(self:getActivityGroup())
	local maxBoxNum = lordOfDessertRead.getBoxMax(self:getActivityGroup())
	local canGetNum = math.min(math.floor(self.score / maxPoint), maxBoxNum)
	if canGetNum - self.gotRewardCount > 0 then
		return true, canGetNum - self.gotRewardCount
	end
	local gametop = gModuleMgr.getObject("gametop")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	_UPVALUE2_ = 1
	;(1)[1] = "id"
	;(1)[2] = "count"
	local count = backpackCtrl:getItemCount(lordOfDessertRead.getNeedItemByIndex(1)[1], 1)
	if maxBoxNum > self.gotRewardCount and 0 < count then
		return true, -1
	end
	return false, 0
end
function lordOfDessertCtrl:getScore()
	return self.score or 0
end
function lordOfDessertCtrl:getRewardCount()
	return self.gotRewardCount or 0
end
function lordOfDessertCtrl:getPlayerRank()
	return self.myRank or -1
end
function lordOfDessertCtrl:getActivityGroup()
	return SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)
end
return lordOfDessertCtrl
