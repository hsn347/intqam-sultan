local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local warTreasureCtrl = class("warTreasureCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function warTreasureCtrl:ctor(properties)
	warTreasureCtrl.super.ctor(self, properties)
	self:resetData()
end
function warTreasureCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_WAR_TREASURE_MODULE, gCmd.REQ_WAR_TREASURE_DATA, handler(self, self.reqWarTreasureDataRsp))
	msgCtrl.register(gCmd.CMD_WAR_TREASURE_MODULE, gCmd.REQ_WAR_TREASURE_ALLIANCE_RANK, handler(self, self.reqWarTreasureAllianceRankRsp))
	msgCtrl.register(gCmd.CMD_WAR_TREASURE_MODULE, gCmd.REQ_WAR_TREASURE_DONATE, handler(self, self.reqWarTreasureDonateRsp))
	msgCtrl.register(gCmd.CMD_WAR_TREASURE_MODULE, gCmd.REQ_WAR_TREASURE_DONATE_RANK, handler(self, self.reqWarTreasureDonateRankRsp))
	msgCtrl.register(gCmd.CMD_WAR_TREASURE_MODULE, gCmd.REQ_WAR_TREASURE_DONATE_LOG, handler(self, self.reqWarTreasureDonateLogRsp))
	self:registerNotify()
end
function warTreasureCtrl:Logout()
	warTreasureCtrl.super.Logout(self)
	self:resetData()
end
function warTreasureCtrl:resetData()
	self.userWarTreasureData, _UPVALUE0_, self.rankList, _UPVALUE0_, self.allianceWarTreasureData, _UPVALUE0_ = nil, nil, nil, nil, nil, nil
end
function warTreasureCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
end
function warTreasureCtrl:notifyHandler(event)
	dump(event.data, "warTreasureCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
	end
end
function warTreasureCtrl:reqWarTreasureData()
	serverproxy:Request(gCmd.CMD_WAR_TREASURE_MODULE, gCmd.REQ_WAR_TREASURE_DATA)
end
function warTreasureCtrl:reqWarTreasureAllianceRank()
	serverproxy:Request(gCmd.CMD_WAR_TREASURE_MODULE, gCmd.REQ_WAR_TREASURE_ALLIANCE_RANK)
end
function warTreasureCtrl:reqWarTreasureDonate(data)
	serverproxy:Request(gCmd.CMD_WAR_TREASURE_MODULE, gCmd.REQ_WAR_TREASURE_DONATE, data)
end
function warTreasureCtrl:reqWarTreasureDonateRank(data)
	serverproxy:Request(gCmd.CMD_WAR_TREASURE_MODULE, gCmd.REQ_WAR_TREASURE_DONATE_RANK, data)
end
function warTreasureCtrl:reqWarTreasureDonateLog(data)
	serverproxy:Request(gCmd.CMD_WAR_TREASURE_MODULE, gCmd.REQ_WAR_TREASURE_DONATE_LOG, data)
end
function warTreasureCtrl:reqWarTreasureDataRsp(content)
	dump(content, "warTreasureCtrl:reqWarTreasureDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			local _ENV, infoData = content.rspdata, content.rspdata
		end
		self.allianceWarTreasureData = infoData.allianceWarTreasureData
		self.userWarTreasureData = infoData.userWarTreasureData
		_ENV = "warTreasureCtrl:reqWarTreasureDataRsp(content)"
		;("warTreasureCtrl:reqWarTreasureDataRsp(content)").msg = "MESSAGE_WAR_TREASURE_REFRESH"
		;("warTreasureCtrl:reqWarTreasureDataRsp(content)").subMsg = "init"
		SoraDSendMessage("warTreasureCtrl:reqWarTreasureDataRsp(content)")
	end
end
function warTreasureCtrl:reqWarTreasureAllianceRankRsp(content)
	dump(content, "warTreasureCtrl:reqWarTreasureAllianceRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			local _ENV, infoData = content.rspdata, content.rspdata
		end
		self.rankList = infoData.rankList
		_ENV = "warTreasureCtrl:reqWarTreasureAllianceRankRsp(content)"
		;("warTreasureCtrl:reqWarTreasureAllianceRankRsp(content)").msg = "MESSAGE_WAR_TREASURE_REFRESH"
		;("warTreasureCtrl:reqWarTreasureAllianceRankRsp(content)").subMsg = "rankList"
		;("warTreasureCtrl:reqWarTreasureAllianceRankRsp(content)").rankList = self.rankList
		SoraDSendMessage("warTreasureCtrl:reqWarTreasureAllianceRankRsp(content)")
	end
end
function warTreasureCtrl:reqWarTreasureDonateRsp(content)
	dump(content, "warTreasureCtrl:reqWarTreasureDonateRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("warSecrit_text_10"))
		for i, v in ipairs(self.rankList) do
			if v.aid == content.data.aid then
				if content.data.type == gWorldTypeServerDef.subMapTypeWarTreasureDrum then
					v.drumNum = content.rspdata.allianceNum
				else
					v.medicineNum = content.rspdata.allianceNum
				end
			end
		end
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local myAid = allianceMgr:getOwnAid()
		if myAid == content.data.aid then
			if content.data.type == gWorldTypeServerDef.subMapTypeWarTreasureDrum then
				self.allianceWarTreasureData.drumNum = content.rspdata.allianceNum
			else
				self.allianceWarTreasureData.medicineNum = content.rspdata.allianceNum
			end
		end
		_ENV = content.rspdata.allianceNum
		content.rspdata.allianceNum.msg = "MESSAGE_WAR_TREASURE_REFRESH"
		content.rspdata.allianceNum.subMsg = "refresh"
		SoraDSendMessage(content.rspdata.allianceNum)
	end
end
function warTreasureCtrl:reqWarTreasureDonateRankRsp(content)
	dump(content, "warTreasureCtrl:reqWarTreasureDonateRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			local _ENV, infoData = content.rspdata, content.rspdata
		end
		_ENV = "warTreasureCtrl:reqWarTreasureDonateRankRsp(content)"
		;("warTreasureCtrl:reqWarTreasureDonateRankRsp(content)").msg = "MESSAGE_WAR_TREASURE_REFRESH"
		;("warTreasureCtrl:reqWarTreasureDonateRankRsp(content)").subMsg = "rankDonateList"
		;("warTreasureCtrl:reqWarTreasureDonateRankRsp(content)").rankList = infoData
		SoraDSendMessage("warTreasureCtrl:reqWarTreasureDonateRankRsp(content)")
	end
end
function warTreasureCtrl:reqWarTreasureDonateLogRsp(content)
	dump(content, "warTreasureCtrl:reqWarTreasureDonateLogRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			local _ENV, infoData = content.rspdata, content.rspdata
		end
		_ENV = "warTreasureCtrl:reqWarTreasureDonateLogRsp(content)"
		;("warTreasureCtrl:reqWarTreasureDonateLogRsp(content)").msg = "MESSAGE_WAR_TREASURE_REFRESH"
		;("warTreasureCtrl:reqWarTreasureDonateLogRsp(content)").subMsg = "logList"
		;("warTreasureCtrl:reqWarTreasureDonateLogRsp(content)").rankList = infoData.rankList
		;("warTreasureCtrl:reqWarTreasureDonateLogRsp(content)").iBegin = content.data.iBegin
		SoraDSendMessage("warTreasureCtrl:reqWarTreasureDonateLogRsp(content)")
	end
end
function warTreasureCtrl:getScoreRewardIsGot(index)
	if not self.userWarTreasureData.scoreReward then
		local _UPVALUE0_, tmb = self.userWarTreasureData.scoreReward, self.userWarTreasureData.scoreReward
	end
	return tmb[index] or false
end
function warTreasureCtrl:getAllianceWarTreasureScore()
	return self.allianceWarTreasureData.score or 0
end
function warTreasureCtrl:getWarTreasureDrumNum()
	return self.allianceWarTreasureData.drumNum or 0
end
function warTreasureCtrl:getWarTreasureMedicineNum()
	return self.allianceWarTreasureData.medicineNum or 0
end
function warTreasureCtrl:getRankList()
	if not self.rankList then
		_UPVALUE0_ = self.rankList
	end
	return self.rankList
end
return warTreasureCtrl
