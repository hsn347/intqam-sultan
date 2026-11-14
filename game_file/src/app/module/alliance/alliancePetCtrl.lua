local GameModule = include("GameModule")
local alliancePetCtrl = class("alliancePetCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local alliancePetRead = include("alliancePetRead")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
function alliancePetCtrl:ctor(properties)
	alliancePetCtrl.super.ctor(self, properties)
end
function alliancePetCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_BEAST_INFO, handler(self, self.sendReqPetInfoRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_CALL_BEAST, handler(self, self.sendReqCallPetRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_WORSHIP_BEAST, handler(self, self.reqDonatePetRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_TRIAL_BEAST, handler(self, self.sendReqTrialRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_CLEAN_WORSHIP_CD, handler(self, self.sendReqCleanWorshipCDRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_REDUCE_BEAST_CD, handler(self, self.sendReqPetCDRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_REDUCE_BEAST_LIST, handler(self, self.sendReqPetCDListRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_WORSHIP_RANK, handler(self, self.sendReqWorshipRankRsp))
	self:resetData()
end
function alliancePetCtrl:resetData()
	self.queBeastBlessing, _UPVALUE0_, self.queBeastReturn, _UPVALUE0_, self.queBeastCallCD, _UPVALUE0_, self.alliancePetData, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
end
function alliancePetCtrl:setQueTimeCD(queue)
	if queue.queBeastCallCD then
		self.queBeastCallCD = queue.queBeastCallCD
	end
	if queue.queBeastReturn then
		self.queBeastReturn = queue.queBeastReturn
	end
	if queue.queBeastBlessing then
		self.queBeastBlessing = queue.queBeastBlessing
	end
end
function alliancePetCtrl:Logout()
	self:resetData()
	alliancePetCtrl.super.Logout(self)
end
function alliancePetCtrl:initClientData(data)
	local statusChange = false
	local lvChange = false
	local pointChange = false
	local lifeChange = false
	local status = data.status
	if status ~= self.alliancePetData.status then
		self.alliancePetData.status = status
		statusChange = true
	end
	if status == gAlliancePetState.DONATE then
		if not self.alliancePetData.worshipData then
			self.alliancePetData.worshipData, _ENV = nil, nil
		end
		self.alliancePetData.worshipData.beastType = data.beast.beastType
		local beastLv = data.beast.beastLv
		if beastLv ~= self.alliancePetData.worshipData.beastLv then
			self.alliancePetData.worshipData.beastLv = data.beast.beastLv
			lvChange = true
		end
		local point = data.beast.point
		if point ~= self.alliancePetData.worshipData.point then
			self.alliancePetData.worshipData.point = point
			pointChange = true
		end
	elseif status == gAlliancePetState.TRIAL then
		if not self.alliancePetData.trialData then
			self.alliancePetData.trialData, _ENV = data.beast.point, data.beast.point
		end
		self.alliancePetData.trialData.beastType = data.beast.beastType
		self.alliancePetData.trialData.beastLv = data.beast.beastLv
		local leftLife = data.beast.leftLife
		if leftLife ~= self.alliancePetData.trialData.leftLife then
			self.alliancePetData.trialData.leftLife = leftLife
			lifeChange = true
		end
	elseif status == gAlliancePetState.BLESS then
		if not self.alliancePetData.blessingData then
			self.alliancePetData.blessingData, _ENV = self.alliancePetData.trialData, self.alliancePetData.trialData
		end
		self.alliancePetData.blessingData.beastType = data.beast.beastType
		self.alliancePetData.blessingData.beastLv = data.beast.beastLv
	end
	if data.queue then
		self:setQueTimeCD(data.queue)
	end
	if data.reduceList then
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local aid = tostring(memberMgr:getOwnMember():getProperty("aid"))
		local _ENV, list = memberMgr:getOwnMember():getProperty("aid")
		if not data.reduceList[aid] then
			local _ENV, tmpReduceList = data.reduceList[aid], data.reduceList[aid]
		end
		for k, v in pairs(tmpReduceList) do
			if v.name then
				table.insert(list, v)
			end
		end
		self.alliancePetData.reduceList = list
		table.sort(self.alliancePetData.reduceList, function(l, r)
			local time1 = l.opTime or l.time
			local time2 = r.opTime or r.time
			return time1 < time2
		end)
		_ENV = self.alliancePetData.reduceList
		self.alliancePetData.reduceList.msg = "MESSAGE_ALLIACNE_PET_DONATE_LIST_BACK"
		self.alliancePetData.reduceList.alliancePetData = self.alliancePetData
		SoraDSendMessage(self.alliancePetData.reduceList)
	end
	_ENV = tostring(memberMgr:getOwnMember():getProperty("aid"))
	tostring(memberMgr:getOwnMember():getProperty("aid")).msg = "MESSAGE_ALLIACNE_PET_UPDATE_INFO"
	tostring(memberMgr:getOwnMember():getProperty("aid")).statusChange = statusChange
	tostring(memberMgr:getOwnMember():getProperty("aid")).lvChange = lvChange
	tostring(memberMgr:getOwnMember():getProperty("aid")).pointChange = pointChange
	tostring(memberMgr:getOwnMember():getProperty("aid")).lifeChange = lifeChange
	SoraDSendMessage((tostring(memberMgr:getOwnMember():getProperty("aid"))))
	if statusChange then
		_ENV = tostring(memberMgr:getOwnMember():getProperty("aid"))
		tostring(memberMgr:getOwnMember():getProperty("aid")).msg = "MESSAGE_ALLIACNE_PET_CALLBACK"
		SoraDSendMessage((tostring(memberMgr:getOwnMember():getProperty("aid"))))
	end
end
function alliancePetCtrl:sendReqPetInfoRsp(content)
	if gErrDef.Err_None == content.err then
		self.alliancePetData = content.data
		_ENV = content.err
		content.err.msg = "MESSAGE_ALLIACNE_PET_REQ_INFO_BACK"
		content.err.alliancePetData = self.alliancePetData
		SoraDSendMessage(content.err)
	end
end
function alliancePetCtrl:sendReqCallPetRsp(content)
	if gErrDef.Err_None == content.err then
		_ENV = content.err
		content.err.msg = "MESSAGE_ALLIACNE_PET_CALLBACK"
		SoraDSendMessage(content.err)
	end
end
function alliancePetCtrl:sendReqTrialRsp(content)
	if gErrDef.Err_None == content.err then
	end
end
function alliancePetCtrl:sendReqCleanWorshipCDRsp(content)
	if gErrDef.Err_None == content.err then
		self.alliancePetData.worshipData.lock = 0
		self.alliancePetData.worshipData.worshipCD, _ENV = content.err, content.err
		_ENV = content.err
		content.err.msg = "MESSAGE_ALLIACNE_PET_DONATE_CD_CLEAN_SUCCESS"
		SoraDSendMessage(content.err)
	end
end
function alliancePetCtrl:reqDonatePetRsp(content)
	if gErrDef.Err_None == content.err then
		self.alliancePetData.worshipData = content.data.worshipData
		_ENV = content.data.worshipData
		content.data.worshipData.msg = "MESSAGE_ALLIACNE_PET_DONATE_SUCCESS"
		SoraDSendMessage(content.data.worshipData)
		local get = content.data.get
		if get then
			local addhonor = get.honor
			local score = get.score
			local msgNotice = include("msgNotice")
			_ENV = nil
			;(nil).count1 = addhonor
			;(nil).count2 = score
			msgNotice.notice("notice_0079", nil)
		end
		local memberinfo = content.data.memberinfo
		if memberinfo and next(memberinfo) then
			local member = include("member").new()
			member:setProperty("minfo", memberinfo)
			local memberMgr = gametop.playertop_:getModule("memberMgr")
			memberMgr:addMember(member)
		end
	elseif gErrDef.Err_RESOUCH_NOT_REACH == content.err then
		SoraDShowMsgTip(i18n("hero_text_90"))
		_ENV = i18n("hero_text_90")
		i18n("hero_text_90").msg = "MESSAGE_ALLIACNE_PET_DONATE_SUCCESS"
		SoraDSendMessage(i18n("hero_text_90"))
	else
		_ENV = i18n("hero_text_90")
		i18n("hero_text_90").msg = "MESSAGE_ALLIACNE_PET_NORMAL_ERR"
		SoraDSendMessage(i18n("hero_text_90"))
	end
end
function alliancePetCtrl:sendReqPetCDRsp(content)
	if gErrDef.Err_None == content.err then
		self.alliancePetData.reduceNum = content.data.remainNum
		_ENV = content.data.remainNum
		content.data.remainNum.msg = "MESSAGE_ALLIACNE_PET_DONATE_BACK"
		content.data.remainNum.alliancePetData = self.alliancePetData
		SoraDSendMessage(content.data.remainNum)
	end
end
function alliancePetCtrl:sendReqPetCDListRsp(content)
	if gErrDef.Err_None == content.err then
		local _ENV, list = gErrDef.Err_None, gErrDef.Err_None
		for k, v in pairs(content.data) do
			if v.name then
				table.insert(list, v)
			end
		end
		self.alliancePetData.reduceList = list
		table.sort(self.alliancePetData.reduceList, function(l, r)
			local time1 = l.opTime or l.time
			local time2 = r.opTime or r.time
			return time1 < time2
		end)
		_ENV = self.alliancePetData.reduceList
		self.alliancePetData.reduceList.msg = "MESSAGE_ALLIACNE_PET_DONATE_LIST_BACK"
		self.alliancePetData.reduceList.alliancePetData = self.alliancePetData
		SoraDSendMessage(self.alliancePetData.reduceList)
	end
end
function alliancePetCtrl:sendReqWorshipRankRsp(content)
	dump(content, "alliancePetCtrl:sendReqWorshipRankRsp", 10)
	if gErrDef.Err_None == content.err then
		_ENV = content.err
		content.err.msg = "MESSAGE_COLLECT_RANK_MESSAGE"
		content.err.subMsg = "rank_AMRT"
		content.err.rankData = content.rspdata
		SoraDSendMessage(content.err)
	end
end
function alliancePetCtrl:sendReqPetInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_BEAST_INFO, data)
end
function alliancePetCtrl:sendReqCallPet(beastType, bGold)
	print("====alliancePetCtrl:sendReqCallPet====", beastType, bGold)
	_ENV = print
	print.beastType = beastType
	local print.bGold, data = bGold or false, print
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_CALL_BEAST, data)
end
function alliancePetCtrl:sendReqTrial()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_TRIAL_BEAST, data)
end
function alliancePetCtrl:sendReqCleanWorshipCD()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_CLEAN_WORSHIP_CD, data)
end
function alliancePetCtrl:sendReqReducePetCD()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_REDUCE_BEAST_CD, data)
end
function alliancePetCtrl:sendReqReducePetCDList()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_REDUCE_BEAST_LIST, data)
end
function alliancePetCtrl:reqDonatePet(worshipType)
	print("====alliancePetCtrl:reqDonatePet====", worshipType)
	_ENV = print
	local print.worshipType, data = worshipType, print
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_WORSHIP_BEAST, data)
end
function alliancePetCtrl:sendReqWorshipRank()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_WORSHIP_RANK, nil)
end
function alliancePetCtrl:checkDonateType(type)
	if gAScienceDonateType.Junior == type then
		return true
	end
	local petData = self:getAlliancePetData()
	if gAScienceDonateType.Middle == type then
		return petData.midResId and petData.midResId ~= 0
	elseif gAScienceDonateType.Senior == type then
		return petData.senResId and petData.senResId ~= 0
	end
end
function alliancePetCtrl:checkDonateLock(...)
	local data = self:getAlliancePetData()
	if data.lock and data.lock ~= 0 and 0 >= self:getDonateTimeCD() then
		data.lock = 0
	end
	return data.lock and data.lock ~= 0
end
function alliancePetCtrl:getAlliancePetState(...)
	return self.alliancePetData.status or gAlliancePetState.CALL
end
function alliancePetCtrl:getMapAltarId(...)
	return self.alliancePetData.mapAltarId
end
function alliancePetCtrl:getAlliancePetType(...)
	return self:getAlliancePetData().beastType or 1
end
function alliancePetCtrl:getAlliancePetCallTimeCD(...)
	if self.queBeastCallCD and next(self.queBeastCallCD) then
		return self.queBeastCallCD.startTime + self.queBeastCallCD.totalTime - serviceFunctions.systemTime()
	end
	return 0
end
function alliancePetCtrl:getAlliancePetTotalTime(...)
	if self.queBeastCallCD and next(self.queBeastCallCD) then
		return self.queBeastCallCD.totalTime
	end
	return 0
end
function alliancePetCtrl:getAlliancePetReturnTimeCD(...)
	if self.queBeastReturn and next(self.queBeastReturn) then
		return self.queBeastReturn.startTime + self.queBeastReturn.totalTime - serviceFunctions.systemTime()
	end
	return 0
end
function alliancePetCtrl:getAlliancePetBlessingTimeCD(...)
	if self.queBeastBlessing and next(self.queBeastBlessing) then
		return self.queBeastBlessing.startTime + self.queBeastBlessing.totalTime - serviceFunctions.systemTime()
	end
	return 0
end
function alliancePetCtrl:getDonateTimeCD(...)
	local data = self:getAlliancePetData()
	local worshipCD = data.worshipCD
	if worshipCD and next(worshipCD) then
		return worshipCD.startTime + worshipCD.totalTime - serviceFunctions.systemTime()
	end
	return 0
end
function alliancePetCtrl:getAlliancePetLv()
	return self:getAlliancePetData().beastLv or 1
end
function alliancePetCtrl:getAlliancePetLeftLife()
	return self:getAlliancePetData().leftLife or 0
end
function alliancePetCtrl:getAlliancePetData()
	local status = self:getAlliancePetState()
	if status == gAlliancePetState.DONATE then
		return self.alliancePetData.worshipData
	elseif status == gAlliancePetState.TRIAL then
		return self.alliancePetData.trialData
	elseif status == gAlliancePetState.BLESS then
		return self.alliancePetData.blessingData
	end
	_ENV = self.alliancePetData.blessingData
	return self.alliancePetData.blessingData
end
function alliancePetCtrl:getAlliancePetTimeCD()
	local status = self:getAlliancePetState()
	if status == gAlliancePetState.CALL then
		return self:getAlliancePetCallTimeCD()
	elseif status == gAlliancePetState.DONATE then
		return self:getAlliancePetReturnTimeCD()
	elseif status == gAlliancePetState.TRIAL then
		return self:getAlliancePetReturnTimeCD()
	elseif status == gAlliancePetState.BLESS then
		return self:getAlliancePetBlessingTimeCD()
	end
	return 0
end
function alliancePetCtrl:getDonateResID(petType, key)
	if "Use1" == key then
		local data = alliancePetRead.getDonateDataByKey(petType, key)
		if "table" == type(data) then
			return data[1]
		end
	end
	local petData = self:getAlliancePetData()
	if "Use2" == key then
		return petData.midResId
	elseif "Use3" == key then
		return petData.senResId
	end
end
function alliancePetCtrl:getBuffEffect(effectType)
	local status = self:getAlliancePetState()
	if status ~= gAlliancePetState.BLESS then
		return
	end
	local value = 0
	local petType = self:getAlliancePetType()
	local lv = self:getAlliancePetLv()
	local _effectType, _value = alliancePetRead.getWishEffectAndVale(petType, lv)
	if _effectType and _value and _effectType == effectType then
		value = _value
	end
	local hasAltar = allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.ALTAR)
	if hasAltar then
		return value
	end
	local allianceDesRead = include("allianceDesRead")
	if (allianceDesRead.getPlayerConquestWarMigration(false) or allianceDesRead.getPlayerBattleGroundMigration(false)) and self.queBeastBlessing and next(self.queBeastBlessing) and not self.queBeastBlessing.disable then
		return value
	end
end
return alliancePetCtrl
