local gamemodulec = include("GameModule")
local intetiorCtrl = class("intetiorCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local intetiorRead = include("intetiorRead")
local serverproxy = gModuleMgr.getObject("serverproxy")
local intetiorDef = include("intetiorDef")
local ID_GOLDBAR = tostring(gIDDef.GOLDBAR)
local MSG_TYPE = intetiorDef.gParliamentMsgType
local gParliamentTrick = intetiorDef.gParliamentTrick
function intetiorCtrl:getKingdomGold()
	return self.res and self.res[ID_GOLDBAR] or 0
end
function intetiorCtrl:getMyGold()
	return self.goldBarNum or 0
end
function intetiorCtrl:isCanStealGold()
	if self.dayStealCount then
		return self.dayStealCount and self.dayStealCount < intetiorDef.MAX_STEAL_COUNT
	end
	return false
end
function intetiorCtrl:getKingdomResource()
	if not self.res then
		_UPVALUE0_ = self.res
	end
	return self.res
end
function intetiorCtrl:getKingdomResourceAllocation()
	if not self.awardRes then
		_UPVALUE0_ = self.awardRes
	end
	return self.awardRes
end
function intetiorCtrl:getIntetiorEdict()
	return self.edict
end
function intetiorCtrl:isCanEdict()
	if SoraDIsSelfKing() and self.modifyEdictCount then
		return self.modifyEdictCount and self.modifyEdictCount < 1
	end
	return false
end
function intetiorCtrl:getAllocationLeftCDTime()
	local ret = 0
	local time = self.lastAwardTime or 0
	if time and 0 < time then
		local sysTime = serviceFunctions.systemTime()
		local endTime = time + intetiorDef.ALLOCATION_CD
		if sysTime < endTime then
			return endTime - sysTime
		end
	end
	return ret
end
function intetiorCtrl:getPolicyPormiseID()
	if self.policyData then
		for i, v in pairs(self.policyData) do
			if v.res and next(v.res) then
				return tonumber(i)
			end
		end
	end
end
function intetiorCtrl:isHasPolicyPormise()
	local id = self:getPolicyPormiseID()
	return id and 0 < id
end
function intetiorCtrl:getPolicyPolicyID()
	if self.policyData then
		for i, v in pairs(self.policyData) do
			if v.t then
				local id = tonumber(i)
				local policyCfg = intetiorRead:getPolicyBaseConfig(id)
				if policyCfg then
					local buffTime = policyCfg.buffTime or 0
					if serviceFunctions.systemTime() < v.t + buffTime then
						return id
					end
				end
			end
		end
	end
end
function intetiorCtrl:isHasPolicyPolicy()
	local id = self:getPolicyPolicyID()
	return id and 0 < id
end
function intetiorCtrl:getPolicyData()
	if not self.policyData then
		_UPVALUE0_ = self.policyData
	end
	return self.policyData
end
function intetiorCtrl:getDecreeData()
	if not self.decreeData then
		_UPVALUE0_ = self.decreeData
	end
	return self.decreeData
end
function intetiorCtrl:getTrickData()
	if not self.trickData then
		_UPVALUE0_ = self.trickData
	end
	return self.trickData
end
function intetiorCtrl:isSelfInTrick_recallOfficial()
	return self:isSelfInTrick(gParliamentTrick.RECALL_OFFICIAL)
end
function intetiorCtrl:isSelfInTrick_monitorEmbezzle()
	return self:isSelfInTrick(gParliamentTrick.MONITOR_EMBEZZLE)
end
function intetiorCtrl:isSelfInTrick(trickId)
	if self.trickData and trickId then
		local data = self.trickData[tostring(trickId)]
		if data then
			local buffTime = intetiorRead:getTrickBuffTime(trickId)
			if data.t and serviceFunctions.systemTime() < data.t + buffTime then
				if gParliamentTrick.RECALL_OFFICIAL == trickId then
					local gametop = gModuleMgr.getObject("gametop")
					local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
					local official = lordInfoCtrl:getSelfOfficial()
					if official then
						local officialInfoRead = include("officialInfoRead")
						local isGood = officialInfoRead.judgeGoodOrBad(official)
						if isGood then
							return true
						end
					end
				else
					local position = intetiorRead:getTrickPosition(trickId)
					local intetiorUtil = include("intetiorUtil")
					return intetiorUtil:isCanOpPromise_official(position)
				end
			end
		end
	end
	return false
end
function intetiorCtrl:getPolicyBuffPlus(buffType)
	local plus = 0
	if self.policyData and next(self.policyData) then
		for policyId, policy in pairs(self.policyData) do
			local policyCfg = intetiorRead:getPolicyBaseConfig(tonumber(policyId))
			if policyCfg.attribute[1] == buffType and policy.t and serviceFunctions.systemTime() < policy.t + policyCfg.buffTime then
				plus = plus + (policyCfg.attribute[2] or 0)
			end
		end
	end
	return plus
end
function intetiorCtrl:getDecreeBuffPlus(buffType)
	local plus = 0
	if self.decreeData and next(self.decreeData) then
		for decreeId, decree in pairs(self.decreeData) do
			local policyCfg = intetiorRead:getPolicyOrderConfig(tonumber(decreeId))
			if policyCfg.attribute[1] == buffType and decree.t and serviceFunctions.systemTime() < decree.t + policyCfg.buffTime then
				local gametop = gModuleMgr.getObject("gametop")
				local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
				if lordInfoCtrl:getSourceKid() == 0 and policyCfg.countryType == 1 or 0 < lordInfoCtrl:getSourceKid() and policyCfg.countryType == 2 then
					plus = plus + (policyCfg.attribute[2] or 0)
				end
			end
		end
	end
	return plus
end
function intetiorCtrl:getBuffPlus(buffType)
	local plus = 0
	if not worldMapDefine.isInWar() then
		plus = plus + self:getPolicyBuffPlus(buffType)
		plus = plus + self:getDecreeBuffPlus(buffType)
	end
	return plus
end
function intetiorCtrl:resetLoginDays()
	self.dayStealCount = 0
end
function intetiorCtrl:reqParliamentTreasuryData()
	print("intetiorCtrl:reqParliamentTreasuryData")
	if not self.refreshRes then
		self.refreshRes = true
		serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_DATA)
	end
end
function intetiorCtrl:reqParliamentTreasuryDonate(num)
	print("intetiorCtrl:reqParliamentTreasuryDonate", num)
	_ENV = nil
	;(nil).num = num
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_DONATE, nil)
end
function intetiorCtrl:reqParliamentTreasuryDonateRank(iBegin, nCount)
	print("intetiorCtrl:reqParliamentTreasuryDonateRank", iBegin, nCount)
	_ENV = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_DONATE_RANK, nil)
end
function intetiorCtrl:reqParliamentTreasuryDonateRecord(iBegin, nCount)
	print("intetiorCtrl:reqParliamentTreasuryDonateRecord", iBegin, nCount)
	_ENV = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_DONATE_RECORD, nil)
end
function intetiorCtrl:reqParliamentTreasuryAward(uid, resMap)
	print("intetiorCtrl:reqParliamentTreasuryAward", uid, resMap)
	_ENV = nil
	;(nil).uid = uid
	;(nil).resMap = resMap
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_AWARD, nil)
end
function intetiorCtrl:reqParliamentTreasuryAwardEx(awardMap)
	print("gCmd.REQ_PARLIAMENT_TREASURY_AWARD_EX", gCmd.REQ_PARLIAMENT_TREASURY_AWARD_EX)
	dump("awardMap", awardMap)
	_ENV = nil
	;(nil).awardMap = awardMap
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_AWARD_EX, nil)
end
function intetiorCtrl:reqParliamentTreasuryAwardRecord(iBegin, nCount)
	print("intetiorCtrl:reqParliamentTreasuryAwardRecord", iBegin, nCount)
	_ENV = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_AWARD_RECORD, nil)
end
function intetiorCtrl:reqParliamentTreasuryTaxRecord(iBegin, nCount)
	print("intetiorCtrl:reqParliamentTreasuryTaxRecord", iBegin, nCount)
	_ENV = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_TAX_RECORD, nil)
end
function intetiorCtrl:reqParliamentPolicyData()
	print("intetiorCtrl:reqParliamentPolicyData")
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_POLICY_DATA)
end
function intetiorCtrl:reqParliamentPolicyExecute(policyId)
	print("intetiorCtrl:reqParliamentPolicyExecute", policyId)
	_ENV = nil
	;(nil).policyId = policyId
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_POLICY_EXECUTE, nil)
end
function intetiorCtrl:reqParliamentPolicyPromise(policyId)
	print("intetiorCtrl:reqParliamentPolicyPromise", policyId)
	_ENV = nil
	;(nil).policyId = policyId
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_POLICY_PROMISE, nil)
end
function intetiorCtrl:reqParliamentPolicyDonate(policyId, num)
	print("intetiorCtrl:reqParliamentPolicyDonate", policyId, num)
	_ENV = nil
	;(nil).policyId = policyId
	;(nil).num = num
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_POLICY_DONATE, nil)
end
function intetiorCtrl:reqParliamentPolicyRecord(iBegin, nCount)
	print("intetiorCtrl:reqParliamentPolicyRecord", iBegin, nCount)
	_ENV = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_POLICY_RECORD, nil)
end
function intetiorCtrl:reqParliamentDecreeData()
	print("intetiorCtrl:reqParliamentDecreeData")
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_DECREE_DATA)
end
function intetiorCtrl:reqParliamentDecreeExecute(decreeId, targetUid)
	print("intetiorCtrl:reqParliamentDecreeExecute", decreeId, targetUid)
	_ENV = nil
	;(nil).decreeId = decreeId
	;(nil).targetUid = targetUid
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_DECREE_EXECUTE, nil)
end
function intetiorCtrl:reqParliamentDecreeRecord(iBegin, nCount)
	print("intetiorCtrl:reqParliamentDecreeRecord", iBegin, nCount)
	_ENV = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_DECREE_RECORD, nil)
end
function intetiorCtrl:reqParliamentTrickData()
	print("intetiorCtrl:reqParliamentTrickData")
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TRICK_DATA)
end
function intetiorCtrl:reqParliamentTrickSteal()
	print("intetiorCtrl:reqParliamentTrickSteal")
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TRICK_STEAL)
end
function intetiorCtrl:reqParliamentTrickStealRecord(iBegin, nCount)
	print("intetiorCtrl:reqParliamentTrickStealRecord", iBegin, nCount)
	_ENV = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TRICK_STEAL_RECORD, nil)
end
function intetiorCtrl:reqParliamentTrickCharge(trickId, num)
	print("intetiorCtrl:reqParliamentTrickCharge", trickId, num)
	_ENV = nil
	;(nil).trickId = trickId
	;(nil).num = num
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TRICK_CHARGE, nil)
end
function intetiorCtrl:reqParliamentTreasuryModifyEdict(edict)
	print("intetiorCtrl:reqParliamentTreasuryModifyEdict", edict)
	_ENV = nil
	;(nil).edict = edict
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_MODIFY_EDICT, nil)
end
function intetiorCtrl:reqParliamentTreasuryPlayerDayAward(uid)
	print("intetiorCtrl:reqParliamentTreasuryPlayerDayAward", uid)
	_ENV = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_PLAYER_DAY_AWARD, nil)
end
function intetiorCtrl:ctor(properties)
	intetiorCtrl.super.ctor(self, properties)
end
function intetiorCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_DATA, handler(self, self.parliamentTreasuryDataRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_DONATE, handler(self, self.parliamentTreasuryDonateRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_DONATE_RANK, handler(self, self.parliamentTreasuryDonateRankRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_DONATE_RECORD, handler(self, self.parliamentTreasuryDonateRecordRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_AWARD, handler(self, self.parliamentTreasuryAwardRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_AWARD_RECORD, handler(self, self.parliamentTreasuryAwardRecordRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_TAX_RECORD, handler(self, self.parliamentTreasuryTaxRecordRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_POLICY_DATA, handler(self, self.parliamentPolicyDataRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_POLICY_EXECUTE, handler(self, self.parliamentPolicyExecuteRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_POLICY_PROMISE, handler(self, self.parliamentPolicyPromiseRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_POLICY_DONATE, handler(self, self.parliamentPolicyDonateRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_POLICY_RECORD, handler(self, self.parliamentPolicyRecordRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_DECREE_DATA, handler(self, self.parliamentDecreeDataRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_DECREE_EXECUTE, handler(self, self.parliamentDecreeExecuteRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_DECREE_RECORD, handler(self, self.parliamentDecreeRecordRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TRICK_DATA, handler(self, self.parliamentTrickDataRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TRICK_STEAL, handler(self, self.parliamentTrickStealRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TRICK_STEAL_RECORD, handler(self, self.parliamentTrickStealRecordRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TRICK_CHARGE, handler(self, self.parliamentTrickChargeRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_MODIFY_EDICT, handler(self, self.parliamentTreasuryModifyEdictRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_PLAYER_DAY_AWARD, handler(self, self.parliamentTreasuryPlayerDayAwardRSP))
	msgCtrl.register(gCmd.CMD_PARLIAMENT_MODULE, gCmd.REQ_PARLIAMENT_TREASURY_AWARD_EX, handler(self, self.parliamentTreasuryAwardEXRSP))
	local gametop = gModuleMgr.getObject("gametop")
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.PARLIAMENT, handler(self, self.onMsg))
	self:resetData()
end
function intetiorCtrl:resetData()
	self.awardRes, _UPVALUE0_, self.res, _UPVALUE0_, self.refreshRes = nil, nil, nil, nil, false
	self.edict = nil
	self.modifyEdictCount = 0
	self.dayStealCount = 0
	self.lastAwardTime = 0
	self.trickData, _UPVALUE0_, self.decreeData, _UPVALUE0_, self.policyData, _UPVALUE0_, self.goldBarNum = nil, nil, nil, nil, nil, nil, 0
end
function intetiorCtrl:Logout()
	intetiorCtrl.super.Logout(self)
	self:resetData()
end
function intetiorCtrl:onMsg(event)
	local data = event.data
	dump(data, "intetiorCtrl:onMsg", 10)
	if data then
		for _, msg in pairs(data) do
			local msgType = msg.type
			if msgType == MSG_TYPE.SET_DATA then
				self:onUpdateData(msg)
			elseif msgType == MSG_TYPE.SET_POLICY_DATA then
				self:updatePolicyData(msg.data)
				_ENV = self
				self.msg = "MESSAGE_SERVER_INTETIOR_POLICY_DATA_UPDATE"
				self.info = msg.data
				SoraDSendMessage(self)
			elseif msgType == MSG_TYPE.SET_DECREE_DATA then
				self:updateDecreeData(msg.data)
				_ENV = self
				self.msg = "MESSAGE_SERVER_INTETIOR_DECREE_DATA_UPDATE"
				self.info = msg.data
				SoraDSendMessage(self)
			elseif msgType == MSG_TYPE.SET_TRICK_DATA then
				self:updateTrickData(msg.data)
				_ENV = self
				self.msg = "MESSAGE_SERVER_INTETIOR_TRICK_DATA_UPDATE"
				self.info = msg.data
				SoraDSendMessage(self)
				_ENV = self
				self.msg = "MESSAGE_MAINCITYVIEW_CITYBUFF_DISAPPEAR"
				SoraDSendMessage(self)
			end
		end
	end
end
function intetiorCtrl:onUpdateData(msg)
	local data = msg.data
	if data.goldBarNum then
		self:updateGoldBar(data.goldBarNum)
	end
end
function intetiorCtrl:initClientData(data)
	if not data then
		return
	end
	dump(data, "data", 10)
	if data.dbData then
		self.goldBarNum = data.dbData.goldBarNum or 0
		self.dayStealCount = data.dbData.dayStealCount or 0
	end
	if data.policyData then
		self.policyData = data.policyData
	end
	if data.decreeData then
		self.decreeData = data.decreeData
	end
	if data.trickData then
		self.trickData = data.trickData
	end
end
function intetiorCtrl:updateGoldBar(gold)
	self.goldBarNum = gold or 0
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_INTETIOR_GOLD_BAR_CHANGE"
	SoraDSendMessage(nil)
end
function intetiorCtrl:updateAwardRes(data)
	if data.lastAwardTime then
		self.lastAwardTime = data.lastAwardTime
	else
		self.lastAwardTime = serviceFunctions.systemTime()
	end
end
function intetiorCtrl:updatePolicyData(data)
	if data then
		self.policyData = data
	end
end
function intetiorCtrl:updateDecreeData(data)
	if data then
		self.decreeData = data
	end
end
function intetiorCtrl:updateTrickData(data)
	if data then
		self.trickData = data
	end
end
function intetiorCtrl:updatePolicyPromiseData(promiseId, data)
	if data and data.promiseResNum and promiseId then
		local key = tostring(promiseId)
		if not self.policyData[key] then
			self.policyData[key], _ENV = nil, nil
		end
		local policyData = self.policyData[key]
		if not policyData.res then
			policyData.res, _ENV = policyData.res, policyData.res
		end
		policyData.res[ID_GOLDBAR] = data.promiseResNum
		_ENV = ID_GOLDBAR
		ID_GOLDBAR.msg = "MESSAGE_SERVER_INTETIOR_POLICY_DATA_UPDATE"
		ID_GOLDBAR.info = self.policyData
		SoraDSendMessage(ID_GOLDBAR)
	end
end
function intetiorCtrl:updateTrickData_change(trickId, data)
	if self.trickData and data.trickNum and trickId then
		local key = tostring(trickId)
		if not self.trickData[key] then
			self.trickData[key], _ENV = nil, nil
		end
		local trickData = self.trickData[key]
		if not trickData.res then
			trickData.res, _ENV = trickData.res, trickData.res
		end
		trickData.res[ID_GOLDBAR] = data.trickNum
	end
end
function intetiorCtrl:updateKingdomGoldBar(data)
	if data.treasuryNum then
		if self.res then
			self.res[ID_GOLDBAR] = data.treasuryNum
		end
		ID_GOLDBAR = ID_GOLDBAR
		ID_GOLDBAR.msg = "MESSAGE_SERVER_INTETIOR_GOLD_BAR_KINGDOM_CHANGE"
		SoraDSendMessage(ID_GOLDBAR)
	end
end
function intetiorCtrl:parliamentTreasuryDataRSP(event)
	dump(event, "intetiorCtrl:parliamentTreasuryDataRSP", 10)
	self.refreshRes = false
	local err = event.err
	if err == gErrDef.Err_None then
		local rspdata = event.rspdata
		if not rspdata.res then
			_ENV = rspdata.res
		end
		self.res = rspdata.res
		self.edict = rspdata.edict
		self.modifyEdictCount = rspdata.modifyEdictCount or 0
		self.lastAwardTime = rspdata.lastAwardTime
		_ENV = 10
		;(10).msg = "MESSAGE_SERVER_INTETIOR_RESOURCE_DATA"
		SoraDSendMessage(10)
	end
end
function intetiorCtrl:parliamentTreasuryDonateRSP(event)
	dump(event, "intetiorCtrl:parliamentTreasuryDonateRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local rspdata = event.rspdata
		self:updateKingdomGoldBar(rspdata)
	end
	_ENV = self.updateKingdomGoldBar
	self.updateKingdomGoldBar.msg = "MESSAGE_SERVER_INTETIOR_DOATE_RSP"
	self.updateKingdomGoldBar.err = event.err
	SoraDSendMessage(self.updateKingdomGoldBar)
end
function intetiorCtrl:parliamentTreasuryDonateRankRSP(event)
	dump(event, "intetiorCtrl:parliamentTreasuryDonateRankRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local retdata = event.rspdata
		if not retdata.rankList then
			local _ENV, rankList = retdata.rankList, retdata.rankList
		end
		local myInfo = retdata.myInfo
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_INTETIOR_TREASURY_DONATE_RANK"
		;(nil).myInfo = myInfo
		;(nil).rankList = rankList
		SoraDSendMessage(nil)
	end
end
function intetiorCtrl:parliamentTreasuryDonateRecordRSP(event)
	dump(event, "intetiorCtrl:parliamentTreasuryDonateRecordRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local retdata = event.rspdata
		local _ENV, rankList = "intetiorCtrl:parliamentTreasuryDonateRecordRSP", retdata or "intetiorCtrl:parliamentTreasuryDonateRecordRSP"
		local iBegin = event.data.iBegin
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_INTETIOR_TREASURY_DONATE_RECORD"
		;(nil).rankList = rankList
		;(nil).iBegin = iBegin
		SoraDSendMessage(nil)
	end
end
function intetiorCtrl:parliamentTreasuryAwardRSP(event)
	dump(event, "intetiorCtrl:parliamentTreasuryAwardRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local rspdata = event.rspdata
		self:updateAwardRes(rspdata)
		self:reqParliamentTreasuryData()
	end
	_ENV = self.reqParliamentTreasuryData
	self.reqParliamentTreasuryData.msg = "MESSAGE_SERVER_INTETIOR_ALLOCATION_RSP"
	self.reqParliamentTreasuryData.err = event.err
	SoraDSendMessage(self.reqParliamentTreasuryData)
end
function intetiorCtrl:parliamentTreasuryAwardEXRSP(event)
	dump(event, "intetiorCtrl:parliamentTreasuryAwardEXRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local rspdata = event.rspdata
		self:updateAwardRes(rspdata)
		self:reqParliamentTreasuryData()
	end
	_ENV = self.reqParliamentTreasuryData
	self.reqParliamentTreasuryData.msg = "MESSAGE_SERVER_INTETIOR_ALLOCATION_RSP"
	self.reqParliamentTreasuryData.err = event.err
	SoraDSendMessage(self.reqParliamentTreasuryData)
end
function intetiorCtrl:parliamentTreasuryAwardRecordRSP(event)
	dump(event, "intetiorCtrl:parliamentTreasuryAwardRecordRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local retdata = event.rspdata
		local _ENV, rankList = "intetiorCtrl:parliamentTreasuryAwardRecordRSP", retdata or "intetiorCtrl:parliamentTreasuryAwardRecordRSP"
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_INTETIOR_TREASURY_AWARD_RECORD"
		;(nil).rankList = rankList
		SoraDSendMessage(nil)
	end
end
function intetiorCtrl:parliamentTreasuryTaxRecordRSP(event)
	dump(event, "intetiorCtrl:parliamentTreasuryTaxRecordRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local retdata = event.rspdata
		local _ENV, rankList = "intetiorCtrl:parliamentTreasuryTaxRecordRSP", retdata or "intetiorCtrl:parliamentTreasuryTaxRecordRSP"
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_INTETIOR_TREASURY_TAX_RECORD"
		;(nil).rankList = rankList
		SoraDSendMessage(nil)
	end
end
function intetiorCtrl:parliamentPolicyDataRSP(event)
	dump(event, "intetiorCtrl:parliamentPolicyDataRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local rspdata = event.rspdata
		self:updatePolicyData(rspdata)
		_ENV = self
		self.msg = "MESSAGE_SERVER_INTETIOR_POLICY_DATA_RSP"
		self.err = err
		self.info = rspdata
		SoraDSendMessage(self)
	else
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_SERVER_INTETIOR_POLICY_DATA_RSP"
		SoraDSendMessage.err = err
		SoraDSendMessage(SoraDSendMessage)
	end
end
function intetiorCtrl:parliamentPolicyExecuteRSP(event)
	dump(event, "intetiorCtrl:parliamentPolicyExecuteRSP", 10)
	local err = event.err
	_ENV = "intetiorCtrl:parliamentPolicyExecuteRSP"
	;("intetiorCtrl:parliamentPolicyExecuteRSP").msg = "MESSAGE_SERVER_INTETIOR_POLICY_EXECUTE_RSP"
	;("intetiorCtrl:parliamentPolicyExecuteRSP").err = err
	SoraDSendMessage("intetiorCtrl:parliamentPolicyExecuteRSP")
end
function intetiorCtrl:parliamentPolicyPromiseRSP(event)
	dump(event, "intetiorCtrl:parliamentPolicyPromiseRSP", 10)
	local err = event.err
	_ENV = "intetiorCtrl:parliamentPolicyPromiseRSP"
	;("intetiorCtrl:parliamentPolicyPromiseRSP").msg = "MESSAGE_SERVER_INTETIOR_POLICY_PROMISE_RSP"
	;("intetiorCtrl:parliamentPolicyPromiseRSP").err = err
	SoraDSendMessage("intetiorCtrl:parliamentPolicyPromiseRSP")
end
function intetiorCtrl:parliamentPolicyDonateRSP(event)
	dump(event, "intetiorCtrl:parliamentPolicyDonateRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local rspdata = event.rspdata
		local promiseId = event.data.policyId
		self:updatePolicyPromiseData(promiseId, rspdata)
	end
	_ENV = event.data.policyId
	event.data.policyId.msg = "MESSAGE_SERVER_INTETIOR_POLICY_DONATE_RSP"
	event.data.policyId.err = err
	SoraDSendMessage(event.data.policyId)
end
function intetiorCtrl:parliamentPolicyRecordRSP(event)
	dump(event, "intetiorCtrl:parliamentPolicyRecordRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local retdata = event.rspdata
		local _ENV, rankList = "intetiorCtrl:parliamentPolicyRecordRSP", retdata or "intetiorCtrl:parliamentPolicyRecordRSP"
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_INTETIOR_POLICY_RECORD"
		;(nil).rankList = rankList
		SoraDSendMessage(nil)
	end
end
function intetiorCtrl:parliamentDecreeDataRSP(event)
	dump(event, "intetiorCtrl:parliamentDecreeDataRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local rspdata = event.rspdata
		self:updateDecreeData(rspdata)
		_ENV = self
		self.msg = "MESSAGE_SERVER_INTETIOR_DECREE_DATA_RSP"
		self.err = err
		self.info = rspdata
		SoraDSendMessage(self)
	else
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_SERVER_INTETIOR_DECREE_DATA_RSP"
		SoraDSendMessage.err = err
		SoraDSendMessage(SoraDSendMessage)
	end
end
function intetiorCtrl:parliamentDecreeExecuteRSP(event)
	dump(event, "intetiorCtrl:parliamentDecreeExecuteRSP", 10)
	local err = event.err
	_ENV = "intetiorCtrl:parliamentDecreeExecuteRSP"
	;("intetiorCtrl:parliamentDecreeExecuteRSP").msg = "MESSAGE_SERVER_INTETIOR_DECREE_EXECUTE_RSP"
	;("intetiorCtrl:parliamentDecreeExecuteRSP").err = err
	SoraDSendMessage("intetiorCtrl:parliamentDecreeExecuteRSP")
end
function intetiorCtrl:parliamentDecreeRecordRSP(event)
	dump(event, "intetiorCtrl:parliamentDecreeRecordRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local retdata = event.rspdata
		local _ENV, rankList = "intetiorCtrl:parliamentDecreeRecordRSP", retdata or "intetiorCtrl:parliamentDecreeRecordRSP"
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_INTETIOR_DECREE_RECORD"
		;(nil).rankList = rankList
		SoraDSendMessage(nil)
	end
end
function intetiorCtrl:parliamentTrickDataRSP(event)
	dump(event, "intetiorCtrl:parliamentTrickDataRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local rspdata = event.rspdata
		_ENV = 10
		;(10).msg = "MESSAGE_SERVER_INTETIOR_TRICK_DATA_RSP"
		;(10).err = err
		;(10).info = rspdata
		SoraDSendMessage(10)
	else
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_SERVER_INTETIOR_TRICK_DATA_RSP"
		SoraDSendMessage.err = err
		SoraDSendMessage(SoraDSendMessage)
	end
end
function intetiorCtrl:parliamentTrickStealRSP(event)
	dump(event, "intetiorCtrl:parliamentTrickStealRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local rspdata = event.rspdata
		self:updateKingdomGoldBar(rspdata)
		if rspdata.dayStealCount then
			self.dayStealCount = rspdata.dayStealCount
		end
		_ENV = self
		self.msg = "MESSAGE_SERVER_INTETIOR_STEAL_RSP"
		self.err = err
		self.info = rspdata
		SoraDSendMessage(self)
	else
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_SERVER_INTETIOR_STEAL_RSP"
		SoraDSendMessage.err = err
		SoraDSendMessage(SoraDSendMessage)
	end
end
function intetiorCtrl:parliamentTrickStealRecordRSP(event)
	dump(event, "intetiorCtrl:parliamentTrickStealRecordRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local retdata = event.rspdata
		local _ENV, rankList = "intetiorCtrl:parliamentTrickStealRecordRSP", retdata or "intetiorCtrl:parliamentTrickStealRecordRSP"
		local iBegin = event.data.iBegin
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_INTETIOR_TRICK_STEAL_RECORD"
		;(nil).rankList = rankList
		;(nil).iBegin = iBegin
		SoraDSendMessage(nil)
	end
end
function intetiorCtrl:parliamentTrickChargeRSP(event)
	dump(event, "intetiorCtrl:parliamentTrickChargeRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local rspdata = event.rspdata
		local trickId = event.data.trickId
		rspdata.trickId = trickId
		self:updateTrickData_change(trickId, rspdata)
		_ENV = self
		self.msg = "MESSAGE_SERVER_INTETIOR_CHARGE_RSP"
		self.err = err
		self.info = rspdata
		SoraDSendMessage(self)
	else
		_ENV = event.data.trickId
		event.data.trickId.msg = "MESSAGE_SERVER_INTETIOR_CHARGE_RSP"
		event.data.trickId.err = err
		SoraDSendMessage(event.data.trickId)
	end
end
function intetiorCtrl:parliamentTreasuryModifyEdictRSP(event)
	dump(event, "intetiorCtrl:parliamentTreasuryModifyEdictRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		self:reqParliamentTreasuryData()
	end
end
function intetiorCtrl:parliamentTreasuryPlayerDayAwardRSP(event)
	dump(event, "intetiorCtrl:parliamentTreasuryPlayerDayAwardRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local rspdata = event.rspdata
		local uid = event.data.uid
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_INTETIOR_PLAYER_DAY_RSP"
		;(nil).err = err
		;(nil).uid = uid
		;(nil).info = rspdata
		SoraDSendMessage(nil)
	else
		_ENV = event.data.uid
		event.data.uid.msg = "MESSAGE_SERVER_INTETIOR_PLAYER_DAY_RSP"
		event.data.uid.err = err
		SoraDSendMessage(event.data.uid)
	end
end
return intetiorCtrl
