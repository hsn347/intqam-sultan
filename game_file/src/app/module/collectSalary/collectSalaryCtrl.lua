local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local collectSalaryCtrl = class("collectSalaryCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function collectSalaryCtrl:ctor(properties)
	collectSalaryCtrl.super.ctor(self, properties)
	self:resetData()
end
function collectSalaryCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_COLLECT_TORCH_MODULE, gCmd.REQ_COLLECT_TORCH_INIT_DATA, handler(self, self.reqGetInitDataRsp))
	msgCtrl.register(gCmd.CMD_COLLECT_TORCH_MODULE, gCmd.REQ_COLLECT_TORCH_COMPOSE, handler(self, self.reqGetComposeRsp))
	msgCtrl.register(gCmd.CMD_COLLECT_TORCH_MODULE, gCmd.REQ_COLLECT_TORCH_SEND, handler(self, self.reqGetSendRsp))
	msgCtrl.register(gCmd.CMD_COLLECT_TORCH_MODULE, gCmd.REQ_COLLECT_TORCH_RANK, handler(self, self.reqGetRankRsp))
	msgCtrl.register(gCmd.CMD_COLLECT_TORCH_MODULE, gCmd.REQ_COLLECT_TORCH_REQUEST, handler(self, self.reqGetRequestRsp))
	msgCtrl.register(gCmd.CMD_COLLECT_TORCH_MODULE, gCmd.REQ_COLLECT_TORCH_BEGIN_TREASURE_TASK, handler(self, self.reqGetBeginTaskRsp))
	msgCtrl.register(gCmd.CMD_COLLECT_TORCH_MODULE, gCmd.REQ_COLLECT_TORCH_RANK_SUMMARY, handler(self, self.reqGetMyRankRsp))
	msgCtrl.register(gCmd.CMD_COLLECT_TORCH_MODULE, gCmd.REQ_COLLECT_TORCH_SEND_CHECK, handler(self, self.reqGetSendCheckRsp))
	self:registerNotify()
	self:reqGetInitData()
end
function collectSalaryCtrl:Logout()
	collectSalaryCtrl.super.Logout(self)
	self:resetData()
end
function collectSalaryCtrl:resetData()
	self.lastRequireTimeChip, _UPVALUE0_, self.itemTaskData, _UPVALUE0_, self.myRankData, _UPVALUE0_ = nil, nil, nil, nil, nil, nil
end
function collectSalaryCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.COLLECT_TORCH, handler(self, self.notifyHandler))
end
function collectSalaryCtrl:notifyHandler(event)
	for k, v in ipairs(event.data) do
		if v.type == "refreshScore" then
			dump(v, "collectSalaryCtrl:notifyHandler", 10)
			self.curTorchScore = v.data.score
			_ENV = v
			v.msg = "MESSAGE_COLLECT_RANK_MESSAGE"
			v.subMsg = "notify"
			SoraDSendMessage(v)
		elseif v.type == "refreshInit" then
			if not v.data or not v.data.initData then
				local _ENV, initdata = v.data.initData, v.data.initData
			end
			self.curTorchScore = initdata.curTorchScore
			self.receiveNum = initdata.receiveNum
			self.lastRequireTime = initdata.lastRequireTime
			if not initdata.lastRequireTimeChip then
				_ENV = initdata.lastRequireTimeChip
			end
			self.lastRequireTimeChip = initdata.lastRequireTimeChip
			self.itemTaskData = initdata.treasureTask
			_ENV = "collectSalaryCtrl:notifyHandler"
			;("collectSalaryCtrl:notifyHandler").msg = "MESSAGE_COLLECT_RANK_MESSAGE"
			;("collectSalaryCtrl:notifyHandler").subMsg = "notify"
			SoraDSendMessage("collectSalaryCtrl:notifyHandler")
		end
	end
end
function collectSalaryCtrl:reqGetInitData(data)
	serverproxy:Request(gCmd.CMD_COLLECT_TORCH_MODULE, gCmd.REQ_COLLECT_TORCH_INIT_DATA)
end
function collectSalaryCtrl:reqGetComposeData(data)
	serverproxy:Request(gCmd.CMD_COLLECT_TORCH_MODULE, gCmd.REQ_COLLECT_TORCH_COMPOSE, data)
end
function collectSalaryCtrl:reqGetSendData(data)
	dump(data, "collectSalaryCtrl:reqGetSendData", 10)
	serverproxy:Request(gCmd.CMD_COLLECT_TORCH_MODULE, gCmd.REQ_COLLECT_TORCH_SEND, data)
end
function collectSalaryCtrl:reqGetRankData(data)
	serverproxy:Request(gCmd.CMD_COLLECT_TORCH_MODULE, gCmd.REQ_COLLECT_TORCH_RANK, data)
end
function collectSalaryCtrl:reqGetRequestData(data)
	serverproxy:Request(gCmd.CMD_COLLECT_TORCH_MODULE, gCmd.REQ_COLLECT_TORCH_REQUEST, data)
end
function collectSalaryCtrl:reqGetBeginTaskData(data)
	serverproxy:Request(gCmd.CMD_COLLECT_TORCH_MODULE, gCmd.REQ_COLLECT_TORCH_BEGIN_TREASURE_TASK, data)
end
function collectSalaryCtrl:reqGetMyRankData(data)
	serverproxy:Request(gCmd.CMD_COLLECT_TORCH_MODULE, gCmd.REQ_COLLECT_TORCH_RANK_SUMMARY)
end
function collectSalaryCtrl:reqGetSendCheckData(data)
	serverproxy:Request(gCmd.CMD_COLLECT_TORCH_MODULE, gCmd.REQ_COLLECT_TORCH_SEND_CHECK, data)
end
function collectSalaryCtrl:reqGetInitDataRsp(content)
	dump(content, "collectSalaryCtrl:reqGetInitDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata or not content.rspdata.initdata then
			local _ENV, initdata = content.rspdata.initdata, content.rspdata.initdata
		end
		self.curTorchScore = initdata.curTorchScore
		self.receiveNum = initdata.receiveNum
		self.lastRequireTime = initdata.lastRequireTime
		if not initdata.lastRequireTimeChip then
			_ENV = initdata.lastRequireTimeChip
		end
		self.lastRequireTimeChip = initdata.lastRequireTimeChip
		self.itemTaskData = initdata.treasureTask
		_ENV = "collectSalaryCtrl:reqGetInitDataRsp(content)"
		;("collectSalaryCtrl:reqGetInitDataRsp(content)").msg = "MESSAGE_COLLECT_RANK_MESSAGE"
		;("collectSalaryCtrl:reqGetInitDataRsp(content)").subMsg = "init"
		SoraDSendMessage("collectSalaryCtrl:reqGetInitDataRsp(content)")
	end
end
function collectSalaryCtrl:reqGetComposeRsp(content)
	dump(content, "collectSalaryCtrl:reqGetComposeRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_COLLECT_RANK_MESSAGE"
		gErrDef.Err_None.subMsg = "showSuccess"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function collectSalaryCtrl:reqGetSendRsp(content)
	dump(content, "collectSalaryCtrl:reqGetSendRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local itemDesRead = include("itemDesRead")
		_ENV = nil
		;(nil).itemname = itemDesRead.getName(content.data.fragmentID)
		SoraDShowMsgTip(i18n("treasuremap_text_45", nil))
	end
end
function collectSalaryCtrl:reqGetSendCheckRsp(content)
	dump(content, "collectSalaryCtrl:reqGetSendCheckRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local panel = SoraDCreatePanel("treasureMapPreView")
		_ENV = nil
		;(nil).nickName = content.rspdata.nickName
		;(nil).uid = content.rspdata.recUid
		;(nil).indexID = content.data.indexID
		panel:initData(1, content.data.fragmentID, nil)
		panel:show()
	elseif content.err == gErrDef.Err_COLLECT_TORCH_MAX_RECEIVE then
		SoraDShowMsgTip(i18n("treasuremap_text_02"))
	elseif content.err == gErrDef.Err_COLLECT_TORCH_NOT_SELFKINGDOM then
		SoraDShowMsgTip(i18n("common_text_3302"))
	elseif content.err == gErrDef.Err_COLLECT_TORCH_INVALID_REQUEST then
		SoraDShowMsgTip(i18n("treasuremap_text_46"))
	end
end
function collectSalaryCtrl:reqGetRankRsp(content)
	dump(content, "collectSalaryCtrl:reqGetRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if content.data.rankType == gCollectSalaryRankType.ALLIANCE_MEMBER_RANK_TYPE then
			self.myRankData.allianceUserRank = content.rspdata.curRank
			_ENV = content.rspdata.curRank
			content.rspdata.curRank.msg = "MESSAGE_COLLECT_RANK_MESSAGE"
			content.rspdata.curRank.subMsg = "rank_AMRT"
			content.rspdata.curRank.rankData = content.rspdata
			SoraDSendMessage(content.rspdata.curRank)
		elseif content.data.rankType == gCollectSalaryRankType.ALLIANCE_RANK_TYPE then
			_ENV = gCollectSalaryRankType.ALLIANCE_RANK_TYPE
			gCollectSalaryRankType.ALLIANCE_RANK_TYPE.msg = "MESSAGE_COLLECT_RANK_MESSAGE"
			gCollectSalaryRankType.ALLIANCE_RANK_TYPE.subMsg = "rank"
			gCollectSalaryRankType.ALLIANCE_RANK_TYPE.rankData = content.rspdata
			gCollectSalaryRankType.ALLIANCE_RANK_TYPE.rankType = gCollectSalaryRankType.ALLIANCE_RANK_TYPE
			SoraDSendMessage(gCollectSalaryRankType.ALLIANCE_RANK_TYPE)
			self.myRankData.kingdomAliRank = content.rspdata.curRank
		else
			_ENV = content.rspdata.curRank
			content.rspdata.curRank.msg = "MESSAGE_COLLECT_RANK_MESSAGE"
			content.rspdata.curRank.subMsg = "rank"
			content.rspdata.curRank.rankData = content.rspdata
			content.rspdata.curRank.rankType = gCollectSalaryRankType.PERSONAL_RANK_TYPE
			SoraDSendMessage(content.rspdata.curRank)
			self.myRankData.personalRank = content.rspdata.curRank
		end
	end
end
function collectSalaryCtrl:reqGetRequestRsp(content)
	dump(content, "collectSalaryCtrl:reqGetRequestRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata.lastRequireTimeChip then
			_ENV = content.rspdata.lastRequireTimeChip
		end
		self.lastRequireTimeChip = content.rspdata.lastRequireTimeChip
		self.lastRequireTime = content.rspdata.lastRequireTime
		local itemDesRead = include("itemDesRead")
		_ENV = nil
		;(nil).itemname = itemDesRead.getName(content.data.fragmentID)
		SoraDShowMsgTip(i18n("treasuremap_text_44", nil))
		_ENV = i18n("treasuremap_text_44", nil)
		i18n("treasuremap_text_44", nil).msg = "MESSAGE_COLLECT_RANK_MESSAGE"
		i18n("treasuremap_text_44", nil).subMsg = "requestHelp"
		i18n("treasuremap_text_44", nil).fragmentID = content.data.fragmentID
		SoraDSendMessage(i18n("treasuremap_text_44", nil))
	elseif content.err == gErrDef.Err_COLLECT_TORCH_NOT_JOIN_ALLIANCE then
		SoraDShowMsgTip(i18n("common_text_583"))
	else
		SoraDShowMsgTip(i18n("common_text_508"))
	end
end
function collectSalaryCtrl:reqGetBeginTaskRsp(content)
	dump(content, "collectSalaryCtrl:reqGetBeginTaskRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.itemTaskData = content.rspdata.initData.treasureTask
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_COLLECT_RANK_MESSAGE"
		gErrDef.Err_None.subMsg = "showOpenSuccess"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function collectSalaryCtrl:reqGetMyRankRsp(content)
	dump(content, "collectSalaryCtrl:reqGetMyRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.myRankData = content.rspdata.rankData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_COLLECT_RANK_MESSAGE"
		gErrDef.Err_None.subMsg = "myRank"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function collectSalaryCtrl:getPointHave()
	return self.curTorchScore or 0
end
function collectSalaryCtrl:getMyRank(rankType)
	local rank
	if rankType == gCollectSalaryRankType.ALLIANCE_MEMBER_RANK_TYPE then
		rank = self.myRankData.allianceUserRank
	elseif rankType == gCollectSalaryRankType.ALLIANCE_RANK_TYPE then
		rank = self.myRankData.kingdomAliRank
	else
		rank = self.myRankData.personalRank
	end
	return rank or 0
end
function collectSalaryCtrl:getAlreadyRequestNums()
	return self.receiveNum or 0
end
function collectSalaryCtrl:getLastRequireTime(itemID)
	return self.lastRequireTimeChip[tostring(itemID)] or 0
end
function collectSalaryCtrl:getTaskInfo(itemID, taskEndTime)
	if self.itemTaskData and self.itemTaskData[tostring(itemID)] then
		for i, v in pairs(self.itemTaskData[tostring(itemID)]) do
			if taskEndTime == v.taskEndTime then
				return v
			end
		end
	end
	_ENV = (for generator)
	return pairs(self.itemTaskData[tostring(itemID)])
end
return collectSalaryCtrl
