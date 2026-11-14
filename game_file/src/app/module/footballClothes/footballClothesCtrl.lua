local jerseyRead = include("jerseyRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local footballClothesCtrl = class("footballClothesCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function footballClothesCtrl:ctor(properties)
	footballClothesCtrl.super.ctor(self, properties)
	self:resetData()
end
function footballClothesCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FOOTBALL_CLOTHES_MODULE, gCmd.REQ_FOOTBALL_CLOTHES_INIT, handler(self, self.reqFootballClothesInitRsp))
	msgCtrl.register(gCmd.CMD_FOOTBALL_CLOTHES_MODULE, gCmd.REQ_FOOTBALL_CLOTHES_DONATE, handler(self, self.reqFootballClothesDonateRsp))
	msgCtrl.register(gCmd.CMD_FOOTBALL_CLOTHES_MODULE, gCmd.REQ_FOOTBALL_CLOTHES_SCORE_DETAIL, handler(self, self.reqFootballClothesScoreDetailRsp))
	msgCtrl.register(gCmd.CMD_FOOTBALL_CLOTHES_MODULE, gCmd.REQ_FOOTBALL_CLOTHES_RECEIVE_REWARD, handler(self, self.reqFootballClothesReceiveRewardRsp))
	self:registerNotify()
end
function footballClothesCtrl:Logout()
	footballClothesCtrl.super.Logout(self)
	self:resetData()
end
function footballClothesCtrl:resetData()
	self.detail, _UPVALUE0_, self.initData, _UPVALUE0_ = nil, nil, nil, nil
end
function footballClothesCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.FOOTBALL_CLOTHES, handler(self, self.notifyHandler))
end
function footballClothesCtrl:notifyHandler(event)
	dump(event.data, "footballClothesCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.initData = v.initData
		_ENV = nil
		;(nil).msg = "MESSAGE_FOOTBALL_CLOTHES_REFRESH"
		;(nil).subMsg = "init"
		SoraDSendMessage(nil)
	end
end
function footballClothesCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FOOTBALL_CLOTHES_MODULE, gCmd.REQ_FOOTBALL_CLOTHES_INIT, nil)
end
function footballClothesCtrl:reqFootballClothesDonate(count)
	serverproxy = nil
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_FOOTBALL_CLOTHES_MODULE, gCmd.REQ_FOOTBALL_CLOTHES_DONATE, nil)
end
function footballClothesCtrl:reqFootballClothesScoreDetail()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FOOTBALL_CLOTHES_MODULE, gCmd.REQ_FOOTBALL_CLOTHES_SCORE_DETAIL, nil)
end
function footballClothesCtrl:reqFootballClothesReceiveReward(nType, number)
	serverproxy = nil
	;(nil).nType = nType
	;(nil).number = number
	serverproxy:Request(gCmd.CMD_FOOTBALL_CLOTHES_MODULE, gCmd.REQ_FOOTBALL_CLOTHES_RECEIVE_REWARD, nil)
end
function footballClothesCtrl:reqFootballClothesInitRsp(content)
	dump(content, "footballClothesCtrl:reqFootballClothesInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata.initData then
			_ENV = content.rspdata.initData
		end
		self.initData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_FOOTBALL_CLOTHES_REFRESH"
		gErrDef.Err_None.subMsg = "init"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.Err_None.eventID = gActivityTimeActivityID.FOOTBALL_CLOTHES_ACTIVITY
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function footballClothesCtrl:reqFootballClothesDonateRsp(content)
	dump(content, "footballClothesCtrl:reqFootballClothesDonateRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata.initData then
			_ENV = content.rspdata.initData
		end
		self.initData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_FOOTBALL_CLOTHES_REFRESH"
		gErrDef.Err_None.subMsg = "init"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.Err_None.eventID = gActivityTimeActivityID.FOOTBALL_CLOTHES_ACTIVITY
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function footballClothesCtrl:reqFootballClothesScoreDetailRsp(content)
	dump(content, "footballClothesCtrl:reqFootballClothesScoreDetailRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata.detail then
			_ENV = content.rspdata.detail
		end
		self.detail = content.rspdata.detail
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_FOOTBALL_CLOTHES_REFRESH"
		gErrDef.Err_None.subMsg = "detail"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function footballClothesCtrl:reqFootballClothesReceiveRewardRsp(content)
	dump(content, "footballClothesCtrl:reqFootballClothesReceiveRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata.initData then
			_ENV = content.rspdata.initData
		end
		self.initData = content.rspdata.initData
		local reward = content.rspdata.reward
		SoraDMailGainItems(reward, true)
		_ENV = reward
		reward.msg = "MESSAGE_FOOTBALL_CLOTHES_REFRESH"
		reward.subMsg = "init"
		SoraDSendMessage(reward)
		_ENV = reward
		reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		reward.eventID = gActivityTimeActivityID.FOOTBALL_CLOTHES_ACTIVITY
		SoraDSendMessage(reward)
	end
end
function footballClothesCtrl:getPersonScore()
	return self.initData.personScore or 0
end
function footballClothesCtrl:getAllianceScore()
	return self.initData.allianceScore or 0
end
function footballClothesCtrl:getScoreByType(type)
	if type == 1 then
		return self:getPersonScore(num)
	else
		return self:getAllianceScore(num)
	end
end
function footballClothesCtrl:getJoinAllianceTime()
	return self.initData.joinAllianceTime or 0
end
function footballClothesCtrl:getPersonRecord()
	if not self.initData.personRecord then
		_UPVALUE0_ = self.initData.personRecord
	end
	return self.initData.personRecord
end
function footballClothesCtrl:getAllianceRecord()
	if not self.initData.allianceRecord then
		_UPVALUE0_ = self.initData.allianceRecord
	end
	return self.initData.allianceRecord
end
function footballClothesCtrl:getReceiveStatusAndNum()
	local num = include("publicUtil").getCount(858901) > 0 and 1 or 0
	local group = SoraDGetCtrl("activityShowCtrl"):getParamClassType(gActivityTimeActivityID.FOOTBALL_CLOTHES_ACTIVITY)
	local score = self:getPersonScore()
	for _, v in ipairs(jerseyRead.getAwardList(group, 1)) do
		if score >= v.num and self:getStatusByTypeNum(1, v.num) == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	if not self:isNewJoinAlliance() then
		score = self:getAllianceScore()
		for _, v in ipairs(jerseyRead.getAwardList(group, 2)) do
			if score >= v.num and self:getStatusByTypeNum(2, v.num) == gBtnTargetStatusDef.GET then
				num = num + 1
			end
		end
	end
	return 0 < num, num
end
function footballClothesCtrl:getPersonStatusByNum(num)
	local nowScore = self:getPersonScore()
	print("getPersonStatusByNum", num, nowScore)
	if num > nowScore then
		return gBtnTargetStatusDef.GO
	elseif self.initData.personRecord and self.initData.personRecord[tostring(num)] then
		return gBtnTargetStatusDef.GOT
	else
		return gBtnTargetStatusDef.GET
	end
end
function footballClothesCtrl:getAllianceStatusByNum(num)
	local nowScore = self:getAllianceScore()
	if num > nowScore then
		return gBtnTargetStatusDef.GO
	elseif self.initData.allianceRecord and self.initData.allianceRecord[tostring(num)] then
		return gBtnTargetStatusDef.GOT
	else
		return gBtnTargetStatusDef.GET
	end
end
function footballClothesCtrl:getStatusByTypeNum(type, num)
	if type == 1 then
		return self:getPersonStatusByNum(num)
	else
		return self:getAllianceStatusByNum(num)
	end
end
function footballClothesCtrl:getAllianceDetailScore()
	if not self.detail then
		_UPVALUE0_ = self.detail
	end
	return self.detail
end
function footballClothesCtrl:isNewJoinAlliance()
	local jointime = self:getJoinAllianceTime()
	local beginTime = SoraDGetCtrl("activityShowCtrl"):getBeginTimeSecond(gActivityTimeActivityID.FOOTBALL_CLOTHES_ACTIVITY)
	return jointime > beginTime
end
function footballClothesCtrl:getFinishRewardNum(type)
	local num = 0
	local group = SoraDGetCtrl("activityShowCtrl"):getParamClassType(gActivityTimeActivityID.FOOTBALL_CLOTHES_ACTIVITY)
	for _, v in ipairs(jerseyRead.getAwardList(group, type)) do
		if self:getStatusByTypeNum(type, v.num) == gBtnTargetStatusDef.GOT then
			num = num + 1
		end
	end
	return num
end
return footballClothesCtrl
