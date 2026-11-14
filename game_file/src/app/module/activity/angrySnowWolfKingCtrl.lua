local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local angrySnowWolfKingCtrl = class("angrySnowWolfKingCtrl", gamemodulec)
local monsterpalaceltCtrl = gModuleMgr.sharedMgr("monsterpalaceltCtrl")
local timerList = gModuleMgr.getObject("timerList")
local MAX_RECORD_NUM = 100
function angrySnowWolfKingCtrl:ctor(properties)
	angrySnowWolfKingCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.ANGRY_SNOW_WOLF_KING_ACTIVITY
	self.feathershopdata = monsterpalaceltCtrl:get_feahtershop()
	self:resetData()
	self.personalNormalCount = 0
	self.personalEliteCount = 0
	self.systemNormalCount = 0
	self.systemEliteCount = 0
end
function angrySnowWolfKingCtrl:modifyPersonalRecordNum(battletype, addnum)
	addnum = addnum or 0
	if battletype == gAngrySnowWolfKingBattletype.NORMAL_BATTLE then
		self.personalNormalCount = self.personalNormalCount + addnum
		return self.personalNormalCount
	elseif battletype == gAngrySnowWolfKingBattletype.ELITE_BATTLE then
		self.personalEliteCount = self.personalEliteCount + addnum
		return self.personalEliteCount
	end
end
function angrySnowWolfKingCtrl:modifySystemRecordNum(battletype, addnum)
	addnum = addnum or 0
	if battletype == gAngrySnowWolfKingBattletype.NORMAL_BATTLE then
		self.systemNormalCount = self.systemNormalCount + addnum
		return self.systemNormalCount
	elseif battletype == gAngrySnowWolfKingBattletype.ELITE_BATTLE then
		self.systemEliteCount = self.systemEliteCount + addnum
		return self.systemEliteCount
	end
end
function angrySnowWolfKingCtrl:getActivityStatus()
	if self.initdata then
		return self.initdata.activitystatus
	else
		return 0
	end
end
function angrySnowWolfKingCtrl:Logout()
	angrySnowWolfKingCtrl.super.Logout(self)
	self:resetData()
end
function angrySnowWolfKingCtrl:resetData()
	self.personalawardinfo, _UPVALUE0_, self.serverawardinfo, _UPVALUE0_, self.curbattleaward, _UPVALUE0_, self.awardlist, _UPVALUE0_, self.battleinfo, _UPVALUE0_, self.initdata, _UPVALUE0_, self.queue, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.firstQueryFlag = true
end
function angrySnowWolfKingCtrl:getEliteChallengeStatus()
	if self.initdata then
		return self.initdata.elitestatus, self.initdata.elitetime
	else
		return MONSTERPALACE_ELITE_STATUS_CLOSE, 86400
	end
end
function angrySnowWolfKingCtrl:splitPersonalAward(battleType)
	local _ENV, reTbl
	for _, v in ipairs(self.personalawardinfo) do
		if v.battletype and v.battletype == battleType then
			table.insert(reTbl, v)
		end
	end
	return reTbl
end
function angrySnowWolfKingCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SNOW_WOLF_KING_MODULE, gCmd.REQ_SNOW_WOLF_KING_ENTRANCE, handler(self, self.entranceinfoRsp))
	msgCtrl.register(gCmd.CMD_SNOW_WOLF_KING_MODULE, gCmd.REQ_SNOW_WOLF_KING_ENTERBATTLE, handler(self, self.enterpalacebattleRsp))
	msgCtrl.register(gCmd.CMD_SNOW_WOLF_KING_MODULE, gCmd.REQ_SNOW_WOLF_KING_ATTACK, handler(self, self.palaceattackRsp))
	msgCtrl.register(gCmd.CMD_SNOW_WOLF_KING_MODULE, gCmd.REQ_SNOW_WOLF_KING_FEATHER_SHOP, handler(self, self.feathershopRsp))
	msgCtrl.register(gCmd.CMD_SNOW_WOLF_KING_MODULE, gCmd.REQ_SNOW_WOLF_KING_FEATHER_SHOP_BUY, handler(self, self.feathershopbuyRsp))
	msgCtrl.register(gCmd.CMD_SNOW_WOLF_KING_MODULE, gCmd.REQ_SNOW_WOLF_KING_QUERY_AWARDLOG, handler(self, self.queryAwardLogRsp))
	msgCtrl.register(gCmd.CMD_SNOW_WOLF_KING_MODULE, gCmd.REQ_SNOW_WOLF_KING_SYSTEM_LOG, handler(self, self.querySystemLogRsp))
	msgCtrl.register(gCmd.CMD_SNOW_WOLF_KING_MODULE, gCmd.REQ_SNOW_WOLF_KING_PERSONAL_LOG, handler(self, self.queryPersonalLogRsp))
	msgCtrl.register(gCmd.CMD_SNOW_WOLF_KING_MODULE, gCmd.REQ_SNOW_WOLF_KING_DECREE_REWARD, handler(self, self.decreeRewardRsp))
end
function angrySnowWolfKingCtrl:entranceinfoRsp(content)
	dump(content, "angrySnowWolfKingCtrl:entranceinfoRsp", 10)
	local data = content.rspdata
	local err = content.err
	if err == gErrDef.Err_None then
		self.initdata = data
		_ENV = 10
		;(10).msg = "MESSAGE_SERVER_SNOW_WOLF_KING_ENTRANCE"
		SoraDSendMessage(10)
	end
end
function angrySnowWolfKingCtrl:enterpalacebattleRsp(content)
	local data = content.rspdata
	local err = content.err
	if err == gErrDef.Err_None then
		local battletype = tonumber(data.battletype)
		if not self.battleinfo[battletype] then
			self.battleinfo[battletype], _ENV = nil, nil
			self.battleinfo[battletype].dechp = data.dechp
			self.battleinfo[battletype].remainkilltimes = data.remainkilltimes
			self.battleinfo[battletype].Allanhbless = data.Allanhbless
		else
			self.battleinfo[battletype].dechp = data.dechp
			self.battleinfo[battletype].remainkilltimes = data.remainkilltimes
			self.battleinfo[battletype].Allanhbless = data.Allanhbless
		end
		if battletype == gAngrySnowWolfKingBattletype.NORMAL_BATTLE then
			self.battleinfo[battletype].maxhp = self.initdata.normalmaxhp
		elseif battletype == gAngrySnowWolfKingBattletype.ELITE_BATTLE then
			self.battleinfo[battletype].maxhp = self.initdata.elitemaxhp
		end
	end
	_ENV = self.battleinfo[battletype]
	self.battleinfo[battletype].msg = "MESSAGE_SERVER_SNOW_WOLF_KING_ENTERBATTLE"
	SoraDSendMessage(self.battleinfo[battletype])
end
function angrySnowWolfKingCtrl:palaceattackRsp(content)
	dump(content, "angrySnowWolfKingCtrl:palaceattackRsp", 10)
	local data = content.rspdata
	local err = content.err
	if err == gErrDef.Err_None then
		local battletype = tonumber(data.battletype)
		local bDie = data.dieflag
		if content.data.attacktype == gAngrySnowWolfKingAtkType.ATKTYPE_CRITICAL then
			bDie = true
		end
		local bfinished = data.bfinished
		if not self.battleinfo[battletype] then
			self.battleinfo[battletype], _ENV = nil, nil
			self.battleinfo[battletype].dechp = data.dechp
			self.battleinfo[battletype].remainkilltimes = data.remainkilltimes
			self.battleinfo[battletype].Allanhbless = data.Allanhbless
		else
			self.battleinfo[battletype].dechp = data.dechp
			self.battleinfo[battletype].remainkilltimes = data.remainkilltimes
			self.battleinfo[battletype].Allanhbless = data.Allanhbless
		end
		self.curbattleaward = data.awardlist
		if battletype == gAngrySnowWolfKingBattletype.NORMAL_BATTLE then
			self.initdata.normaldechp = data.dechp
			self.initdata.normalkilltimes = data.remainkilltimes
		elseif battletype == gAngrySnowWolfKingBattletype.ELITE_BATTLE then
			self.initdata.elitedechp = data.dechp
			self.initdata.elitekilltimes = data.remainkilltimes
		end
		_ENV = data.remainkilltimes
		data.remainkilltimes.msg = "MESSAGE_SERVER_SNOW_WOLF_KING_ATTACK"
		data.remainkilltimes.awardlist = data.awardlist
		data.remainkilltimes.monsterDie = bDie
		data.remainkilltimes.noMonster = bfinished
		SoraDSendMessage(data.remainkilltimes)
		_ENV = data.remainkilltimes
		data.remainkilltimes.msg = "MESSAGE_SERVER_SNOW_WOLF_KING_REFRESHINFO"
		SoraDSendMessage(data.remainkilltimes)
		_ENV = data.remainkilltimes
		data.remainkilltimes.msg = "MESSAGE_ACTIVITY_MODULE_UPDATE_VIEW"
		data.remainkilltimes.activityID = gActivityTimeActivityID.ANGRY_SNOW_WOLF_KING_ACTIVITY
		SoraDSendMessage(data.remainkilltimes)
	else
		_ENV = true
		;(true).msg = "MESSAGE_SERVER_SNOW_WOLF_KING_ERRCALLBACK"
		;(true).errType = err
		SoraDSendMessage(true)
	end
end
function angrySnowWolfKingCtrl:feathershopRsp(content)
	local data = content.rspdata
	local err = content.err
	if err == gErrDef.Err_None then
		self.feathershopdata = data
	else
	end
end
function angrySnowWolfKingCtrl:feathershopbuyRsp(content)
	dump(content, "angrySnowWolfKingCtrl:feathershopbuyRsp", 10)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		local snowWolfltCtrl = gModuleMgr.sharedMgr("snowWolfltCtrl")
		local priceConfig = clone(snowWolfltCtrl:get_feahtershop(self:getZeroLv()))
		_UPVALUE2_ = snowWolfltCtrl:get_feahtershop(self:getZeroLv())
		snowWolfltCtrl:get_feahtershop(self:getZeroLv())[1] = "id"
		snowWolfltCtrl:get_feahtershop(self:getZeroLv())[2] = "count"
		local gainList = serviceFunctions.tableFormat(priceConfig[data.index].rewards, snowWolfltCtrl:get_feahtershop(self:getZeroLv()))
		SoraDMailGainItems(gainList, true)
		_ENV = gainList
		gainList.msg = "MESSAGE_SERVER_SNOW_WOLF_KING_FEATHERSHOPBUY"
		gainList.idx = data.index
		SoraDSendMessage(gainList)
	else
	end
end
function angrySnowWolfKingCtrl:entranceinfoReq(isForce)
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_SNOW_WOLF_KING_MODULE, gCmd.REQ_SNOW_WOLF_KING_ENTRANCE, data)
	if isForce or self.firstQueryFlag then
		local serverproxy, dataaward = self.firstQueryFlag, self.firstQueryFlag
		serverproxy:Request(gCmd.CMD_SNOW_WOLF_KING_MODULE, gCmd.REQ_SNOW_WOLF_KING_SYSTEM_LOG, dataaward)
		serverproxy:Request(gCmd.CMD_SNOW_WOLF_KING_MODULE, gCmd.REQ_SNOW_WOLF_KING_PERSONAL_LOG, dataaward)
		self.firstQueryFlag = false
	end
end
function angrySnowWolfKingCtrl:enterpalacebattleReq(type)
	local serverproxy, data
	data.battletype = type
	serverproxy:Request(gCmd.CMD_SNOW_WOLF_KING_MODULE, gCmd.REQ_SNOW_WOLF_KING_ENTERBATTLE, data)
end
function angrySnowWolfKingCtrl:palaceattackReq(type)
	local serverproxy, data
	data.attacktype = type
	serverproxy:Request(gCmd.CMD_SNOW_WOLF_KING_MODULE, gCmd.REQ_SNOW_WOLF_KING_ATTACK, data)
end
function angrySnowWolfKingCtrl:feathershopReq()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_SNOW_WOLF_KING_MODULE, gCmd.REQ_SNOW_WOLF_KING_FEATHER_SHOP, data)
end
function angrySnowWolfKingCtrl:feathershopbuyReq(idindex)
	local serverproxy, data
	data.index = idindex
	serverproxy:Request(gCmd.CMD_SNOW_WOLF_KING_MODULE, gCmd.REQ_SNOW_WOLF_KING_FEATHER_SHOP_BUY, data)
end
function angrySnowWolfKingCtrl:reqDecreeReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SNOW_WOLF_KING_MODULE, gCmd.REQ_SNOW_WOLF_KING_DECREE_REWARD, nil)
end
function angrySnowWolfKingCtrl:decreeRewardRsp(content)
	dump(content, "angrySnowWolfKingCtrl:decreeRewardRsp", 10)
	if content.err == gErrDef.Err_None then
		self.initdata = content.rspdata.initData
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_SERVER_SNOW_WOLF_KING_DECREE"
	SoraDSendMessage(SoraDMailGainItems)
end
function angrySnowWolfKingCtrl:queryAwardLogReq()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_SNOW_WOLF_KING_QUERYSYSLOG"
	SoraDSendMessage(nil)
end
function angrySnowWolfKingCtrl:getServerAwardInfo()
	local ret = clone(self.serverawardinfo)
	return ret
end
function angrySnowWolfKingCtrl:getPersonalAwardInfo()
	local ret = clone(self.personalawardinfo)
	return ret
end
function angrySnowWolfKingCtrl:queryPersonalLogRsp(content)
	local data = content.rspdata
	local err = content.err
	self.personalawardinfo = data.personalaward
	for k, v in pairs(self.personalawardinfo) do
		if v.battletype == gAngrySnowWolfKingBattletype.NORMAL_BATTLE then
			self.personalNormalCount = self.personalNormalCount + 1
		elseif v.battletype == gAngrySnowWolfKingBattletype.ELITE_BATTLE then
			self.personalEliteCount = self.personalEliteCount + 1
		end
	end
end
function angrySnowWolfKingCtrl:querySystemLogRsp(content)
	local data = content.rspdata
	local err = content.err
	self.serverawardinfo = data.systemawardlog
	for k, v in pairs(self.serverawardinfo) do
		if v.battletype == gAngrySnowWolfKingBattletype.NORMAL_BATTLE then
			self.systemNormalCount = self.systemNormalCount + 1
		elseif v.battletype == gAngrySnowWolfKingBattletype.ELITE_BATTLE then
			self.systemEliteCount = self.systemEliteCount + 1
		end
	end
end
function angrySnowWolfKingCtrl:queryAwardLogRsp(content)
	local data = content.rspdata
	local err = content.err
	self.serverawardinfo = data.systemawardlog
	for k, v in pairs(self.serverawardinfo) do
		if v.battletype == gAngrySnowWolfKingBattletype.NORMAL_BATTLE then
			self.systemNormalCount = self.systemNormalCount + 1
		elseif v.battletype == gAngrySnowWolfKingBattletype.ELITE_BATTLE then
			self.systemEliteCount = self.systemEliteCount + 1
		end
	end
	self.personalawardinfo = data.personalaward
	for k, v in pairs(self.personalawardinfo) do
		if v.battletype == gAngrySnowWolfKingBattletype.NORMAL_BATTLE then
			self.personalNormalCount = self.personalNormalCount + 1
		elseif v.battletype == gAngrySnowWolfKingBattletype.ELITE_BATTLE then
			self.personalEliteCount = self.personalEliteCount + 1
		end
	end
end
function angrySnowWolfKingCtrl:initClientData(data)
	dump(data, "angrySnowWolfKingCtrl:initClient data", 10)
	self.initdata = data
	self:registerNotify()
end
function angrySnowWolfKingCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ANGRY_SNOW_WOLF_KING, handler(self, self.notifyUpdate))
end
function angrySnowWolfKingCtrl:notifyUpdate(event)
	local notifydata = event.data
	dump(event, "angrySnowWolfKingCtrl:notifyUpdate==========", 20)
	for k, data in pairs(notifydata) do
		if data.type == "activestatus" then
			self.initdata = data.data
			if self.battleinfo then
				if self.battleinfo[gAngrySnowWolfKingBattletype.NORMAL_BATTLE] and self.initdata then
					self.battleinfo[gAngrySnowWolfKingBattletype.NORMAL_BATTLE].dechp = self.initdata.normaldechp
					self.battleinfo[gAngrySnowWolfKingBattletype.NORMAL_BATTLE].remainkilltimes = self.initdata.normalkilltimes
				end
				if self.battleinfo[gAngrySnowWolfKingBattletype.ELITE_BATTLE] and self.initdata then
					self.battleinfo[gAngrySnowWolfKingBattletype.ELITE_BATTLE].dechp = self.initdata.elitedechp
					self.battleinfo[gAngrySnowWolfKingBattletype.ELITE_BATTLE].remainkilltimes = self.initdata.elitekilltimes
				end
			end
			_ENV = self.initdata.elitekilltimes
			self.initdata.elitekilltimes.msg = "MESSAGE_SERVER_SNOW_WOLF_KING_UPDATEACTIVESTATUS"
			SoraDSendMessage(self.initdata.elitekilltimes)
		elseif data.type == "personalaward" then
			if next(data.data) then
				local battletype = data.data[1].battletype
				for k, v in pairs(data.data) do
					local curCount = self:modifyPersonalRecordNum(battletype)
					if curCount >= MAX_RECORD_NUM then
						for k1, v1 in ipairs(self.personalawardinfo) do
							if v1.battletype == battletype then
								table.remove(self.personalawardinfo, k1)
								curCount = self:modifyPersonalRecordNum(battletype, -1)
								break
							end
						end
						table.insert(self.personalawardinfo, v)
						curCount = self:modifyPersonalRecordNum(battletype, 1)
					else
						table.insert(self.personalawardinfo, v)
						curCount = self:modifyPersonalRecordNum(battletype, 1)
					end
				end
			end
			local reward = self.personalawardinfo[#self.personalawardinfo]
			_ENV = pairs(data.data)
			pairs(data.data).msg = "MESSAGE_SERVER_SNOW_WOLF_KING_UPDATE_PERSONALAWARD"
			pairs(data.data).reward = reward
			SoraDSendMessage(pairs(data.data))
		elseif data.type == "systemaward" then
			if next(data.data) then
				local battletype = data.data[1].battletype
				for k, v in pairs(data.data) do
					local curCount = self:modifySystemRecordNum(battletype)
					if curCount >= MAX_RECORD_NUM then
						for k1, v1 in ipairs(self.serverawardinfo) do
							if v1.battletype == battletype then
								table.remove(self.serverawardinfo, k1)
								curCount = self:modifySystemRecordNum(battletype, -1)
								break
							end
						end
						table.insert(self.serverawardinfo, v)
						curCount = self:modifySystemRecordNum(battletype, 1)
					else
						table.insert(self.serverawardinfo, v)
						curCount = self:modifySystemRecordNum(battletype, 1)
					end
				end
			end
			local reward = self.serverawardinfo[#self.serverawardinfo]
			_ENV = pairs(data.data)
			pairs(data.data).msg = "MESSAGE_SERVER_SNOW_WOLF_KING_UPDATE_SYSTEMAWARD"
			pairs(data.data).reward = reward
			SoraDSendMessage(pairs(data.data))
		elseif data.type == "buyGift" and data.data.success then
			self.initdata = data.data.initData
			_ENV = SoraDSendMessage
			SoraDSendMessage.msg = "MESSAGE_SERVER_SNOW_WOLF_KING_DECREE"
			SoraDSendMessage(SoraDSendMessage)
		end
	end
end
function angrySnowWolfKingCtrl:getZeroLv()
	if next(self.initdata) ~= nil then
		return self.initdata.serverLevel or 1
	end
	return 1
end
function angrySnowWolfKingCtrl:getInitInfo()
	return self.initdata
end
function angrySnowWolfKingCtrl:getBattleInfo(battleType)
	return self.battleinfo[battleType]
end
function angrySnowWolfKingCtrl:judgeTimesOut(battleType)
	local isOut = false
	if gAngrySnowWolfKingBattletype.NORMAL_BATTLE == battleType then
		isOut = self.initdata.normalkilltimes == nil or self.initdata.normalkilltimes <= 0
	elseif gAngrySnowWolfKingBattletype.ELITE_BATTLE == battleType then
		isOut = self.initdata.elitekilltimes == nil or 0 >= self.initdata.elitekilltimes
	end
	return isOut
end
function angrySnowWolfKingCtrl:judgeIsEnough()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local snowWolfltCtrl = gModuleMgr.sharedMgr("snowWolfltCtrl")
	local priceConfig = clone(snowWolfltCtrl:get_feahtershop(self:getZeroLv()))
	local ret = false
	for _, v in pairs(priceConfig) do
		local itemList = SoraDIntArr2FormatTable(v.needItem)
		local isEnough = true
		for _, val in pairs(itemList) do
			if backpackCtrl:getItemCount(val.id) < val.num then
				isEnough = false
			end
		end
		if isEnough then
			ret = true
			break
		end
	end
	return ret
end
function angrySnowWolfKingCtrl:getItemCount()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	return backpackCtrl:getItemCount(self:getItemID())
end
function angrySnowWolfKingCtrl:getItemID()
	return include("constantRead").getConstValue("CHALLENGE_SNOWWOLF_ITEM")
end
function angrySnowWolfKingCtrl:isCanChallenge()
	local ret = false
	if self:getItemCount() >= ANGRY_SNOW_WOLF_KING_ELITE_COSTHORN and 0 < (self.initdata.elitekilltimes or 0) then
		ret = true
	end
	return ret
end
function angrySnowWolfKingCtrl:hasAward()
	local curDay = self:getCurDay()
	local decree = self:getDecreeInfo()
	local rewardList = monsterpalaceltCtrl:getRewardList()
	if curDay > decree.normalRewardLv and decree.normalRewardLv < #rewardList then
		return true
	end
	if decree.isAdvanceRewardUnlock and curDay > decree.advanceRewardLv and decree.advanceRewardLv < #rewardList then
		return true
	end
end
function angrySnowWolfKingCtrl:getCurDay()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local beginTime = activityShowCtrl:getBeginTimeSecond(self.activityID)
	local zeroTime1 = serviceFunctions.getTomorrowZeroHourUTC(beginTime)
	local zeroTime2 = serviceFunctions.getTomorrowZeroHourUTC()
	local passTime = zeroTime2 - zeroTime1
	return math.floor(passTime / 86400) + 1
end
function angrySnowWolfKingCtrl:getDecreeInfo()
	if not self.initdata.decree then
		_UPVALUE0_ = self.initdata.decree
		self.initdata.decree.normalRewardLv = 0
		self.initdata.decree.isAdvanceRewardUnlock = false
		self.initdata.decree.advanceRewardLv = 0
	end
	return self.initdata.decree
end
function angrySnowWolfKingCtrl:isActiveAdvance()
	local decree = self:getDecreeInfo()
	return decree.isAdvanceRewardUnlock
end
function angrySnowWolfKingCtrl:getSignLevelStatus(level)
	local curDay = self:getCurDay()
	local decree = self:getDecreeInfo()
	local status1 = 2
	local status2 = 0
	if level <= decree.normalRewardLv then
		status1 = 3
	elseif curDay >= decree.normalRewardLv and level <= curDay then
		status1 = 1
	end
	if decree.isAdvanceRewardUnlock then
		status2 = 2
		if level <= decree.advanceRewardLv then
			status2 = 3
		elseif curDay >= decree.advanceRewardLv and level <= curDay then
			status2 = 1
		end
	end
	return status1, status2
end
function angrySnowWolfKingCtrl:getReceiveStatusAndNum()
	local num = 0
	if self:isCanChallenge() then
		num = num + 1
	end
	if self:hasAward() then
		num = num + 1
	end
	return 0 < num, -1
end
return angrySnowWolfKingCtrl
