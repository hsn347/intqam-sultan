local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local heroJailCtrl = class("heroJailCtrl", gamemodulec)
function heroJailCtrl:reqInitdata(...)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_PRISON_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_HERO_PRISON_INITDATA, gCmd.REQ_HERO_PRISON_INITDATA, gCmd.REQ_HERO_PRISON_INITDATA
	local msg
	serverproxy:SendMsg(msg)
end
function heroJailCtrl:reqOfferReward(heroID, targetUid, resList)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_PRISON_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_PRISON_OFFER_REWARD, gCmd.REQ_HERO_PRISON_OFFER_REWARD
	gCmd.REQ_HERO_PRISON_OFFER_REWARD.heroID = heroID
	gCmd.REQ_HERO_PRISON_OFFER_REWARD.targetUid = targetUid
	;(nil).data, gCmd.REQ_HERO_PRISON_OFFER_REWARD.resList = gCmd.REQ_HERO_PRISON_OFFER_REWARD, resList
	local msg
	serverproxy:SendMsg(msg)
end
function heroJailCtrl:reqSetRansom(heroID, ownerUid, resList)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_PRISON_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_PRISON_SET_RANSOM, gCmd.REQ_HERO_PRISON_SET_RANSOM
	gCmd.REQ_HERO_PRISON_SET_RANSOM.heroID = heroID
	gCmd.REQ_HERO_PRISON_SET_RANSOM.ownerUid = ownerUid
	;(nil).data, gCmd.REQ_HERO_PRISON_SET_RANSOM.resList = gCmd.REQ_HERO_PRISON_SET_RANSOM, resList
	local msg
	serverproxy:SendMsg(msg)
end
function heroJailCtrl:reqBreaker(heroID)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_PRISON_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_PRISON_BREAKER, gCmd.REQ_HERO_PRISON_BREAKER
	;(nil).data, gCmd.REQ_HERO_PRISON_BREAKER.heroID = gCmd.REQ_HERO_PRISON_BREAKER, heroID
	local msg
	serverproxy:SendMsg(msg)
end
function heroJailCtrl:reqExecute(heroID, ownerUid, shareFlag)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_PRISON_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_PRISON_EXECUTE, gCmd.REQ_HERO_PRISON_EXECUTE
	gCmd.REQ_HERO_PRISON_EXECUTE.heroID = heroID
	gCmd.REQ_HERO_PRISON_EXECUTE.ownerUid = ownerUid
	;(nil).data, gCmd.REQ_HERO_PRISON_EXECUTE.shareFlag = gCmd.REQ_HERO_PRISON_EXECUTE, shareFlag
	local msg
	serverproxy:SendMsg(msg)
end
function heroJailCtrl:reqReleaseHero(heroID, ownerUid)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_PRISON_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_PRISON_RELEASE_HERO, gCmd.REQ_HERO_PRISON_RELEASE_HERO
	gCmd.REQ_HERO_PRISON_RELEASE_HERO.heroID = heroID
	;(nil).data, gCmd.REQ_HERO_PRISON_RELEASE_HERO.ownerUid = gCmd.REQ_HERO_PRISON_RELEASE_HERO, ownerUid
	local msg
	serverproxy:SendMsg(msg)
end
function heroJailCtrl:reqPayRansom(heroID)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_PRISON_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_PRISON_PAY_RANSOM, gCmd.REQ_HERO_PRISON_PAY_RANSOM
	;(nil).data, gCmd.REQ_HERO_PRISON_PAY_RANSOM.heroID = gCmd.REQ_HERO_PRISON_PAY_RANSOM, heroID
	local msg
	serverproxy:SendMsg(msg)
end
function heroJailCtrl:reqGetReward(uid)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_PRISON_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_PRISON_GET_TOTAL_REWARD, gCmd.REQ_HERO_PRISON_GET_TOTAL_REWARD
	;(nil).data, gCmd.REQ_HERO_PRISON_GET_TOTAL_REWARD.uid = gCmd.REQ_HERO_PRISON_GET_TOTAL_REWARD, uid
	local msg
	serverproxy:SendMsg(msg)
end
function heroJailCtrl:reqPrisionShareHero(shareData)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_PRISON_MODULE
	;(nil).subcmd = gCmd.REQ_HERO_PRISON_SHARE_HERO
	local (nil).data, msg = shareData, nil
	serverproxy:SendMsg(msg)
end
function heroJailCtrl:rspInitdata(content)
	dump(content, "heroJailCtrl:rspInitdata", 10)
	if content.err == gErrDef.Err_None then
	else
	end
end
function heroJailCtrl:rspOfferReward(content)
	dump(content, "heroJailCtrl:rspOfferReward", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_HEROJAIN_REWARDSUCCESS"
		SoraDSendMessage(gErrDef.Err_None)
	else
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_HEROJAIN_SERVERNORMALFAIL"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function heroJailCtrl:rspSetRansom(content)
	dump(content, "heroJailCtrl:rspSetRansom", 10)
	if content.err == gErrDef.Err_None then
		local hid = content.data.heroID
		local uid = content.data.ownerUid
		local flagID = heroJailCtrl.combineUidAndHeroID(hid, uid)
		local prisonData = content.rspdata.prisonHeroInfo
		self.heroPrisonList[flagID] = prisonData
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_HEROJAIN_SETRANSOMSUCCESS"
		;(nil).flagID = flagID
		SoraDSendMessage(nil)
	else
	end
end
function heroJailCtrl:getPrisonBuff(buffEffect)
	local prisonBuffEffect = gBuffEffect.TROOP_ATTACK_BOOST
	if not buffEffect then
		return 0
	end
	if buffEffect ~= prisonBuffEffect then
		return 0
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local prisonLev = cityCtrl:getBuildMaxLv(BUILDID.HERO_PRISON)
	local buildLogic = include("buildLogic")
	local heronum = buildLogic.getHeroJailAddAttack()
	if heronum < 1 then
		return 0
	end
	local _ENV, heroLevList = 0, 0
	if self.heroPrisonList then
		if self.heroPrisonList and type(self.heroPrisonList) == "table" then
			for k, v in pairs(self.heroPrisonList) do
				local level = v.level
				table.insert(heroLevList, level)
			end
		end
		if next(heroLevList) then
			table.sort(heroLevList, function(a, b)
				if b < a then
					return true
				else
					return false
				end
			end)
		end
	end
	local value = 0
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	if 0 < #heroLevList then
		for index, lev in ipairs(heroLevList) do
			if heronum >= index then
				value = value + heroltCtrl.getJailAttackBuffByLevel(lev)
			end
		end
	end
	print("getPrisonBuff(buffEffect)", buffEffect, value)
	return value
end
function heroJailCtrl:rspBreaker(content)
	dump(content, "heroJailCtrl:rspBreaker", 10)
	if content.err == gErrDef.Err_None then
		local heroID = content.data.heroID
		_ENV = "heroJailCtrl:rspBreaker"
		;("heroJailCtrl:rspBreaker").msg = "MESSAGE_SERVER_HEROJAIN_BREAKSUCCESS"
		;("heroJailCtrl:rspBreaker").heroID = heroID
		SoraDSendMessage("heroJailCtrl:rspBreaker")
	else
	end
end
function heroJailCtrl:rspExecute(content)
	dump(content, "heroJailCtrl:rspExecute", 10)
	if content.err == gErrDef.Err_None then
		local hid = content.data.heroID
		local uid = content.data.ownerUid
		local flagID = heroJailCtrl.combineUidAndHeroID(hid, uid)
		self.heroPrisonList[flagID] = nil
		_ENV = uid
		uid.msg = "MESSAGE_SERVER_HEROJAIN_EXECUTESUCCESS"
		uid.flagID = flagID
		SoraDSendMessage(uid)
	else
	end
end
function heroJailCtrl:rspReleaseHero(content)
	dump(content, "heroJailCtrl:rspReleaseHero", 10)
	if content.err == gErrDef.Err_None then
		local hid = content.data.heroID
		local uid = content.data.ownerUid
		local flagID = heroJailCtrl.combineUidAndHeroID(hid, uid)
		self.heroPrisonList[flagID] = nil
		_ENV = uid
		uid.msg = "MESSAGE_SERVER_HEROJAIN_RELEASESUCCESS"
		uid.flagID = flagID
		SoraDSendMessage(uid)
	else
	end
end
function heroJailCtrl:rspPayRansom(content)
	dump(content, "heroJailCtrl:rspPayRansom", 10)
	if content.err == gErrDef.Err_None then
		local heroID = content.data.heroID
		_ENV = "heroJailCtrl:rspPayRansom"
		;("heroJailCtrl:rspPayRansom").msg = "MESSAGE_SERVER_HEROJAIN_PAYSUCCESS"
		;("heroJailCtrl:rspPayRansom").heroID = heroID
		SoraDSendMessage("heroJailCtrl:rspPayRansom")
	else
		if gErrDef.Err_HERO_PRISON_NOT_ENOUGH_NORMAL_RES == content.err then
			SoraDShowMsgTip("hero_text_90")
		end
		_ENV = "hero_text_90"
		;("hero_text_90").msg = "MESSAGE_SERVER_HEROJAIN_SERVERNORMALFAIL"
		SoraDSendMessage("hero_text_90")
	end
end
function heroJailCtrl:rspGetReward(content)
	dump(content, "heroJailCtrl:rspGetReward", 10)
	if content.err == gErrDef.Err_None then
		local mainData = content.rspdata.prisonData
		_ENV = "heroJailCtrl:rspGetReward"
		;("heroJailCtrl:rspGetReward").msg = "MESSAGE_SERVER_HEROJAIN_LORDREWARDINFO"
		;("heroJailCtrl:rspGetReward").detail = mainData.prisonHeroList
		;("heroJailCtrl:rspGetReward").total = mainData.totalResList
		SoraDSendMessage("heroJailCtrl:rspGetReward")
	else
	end
end
function heroJailCtrl:rspPrisionShareHero(content)
	dump(content, "heroJailCtrl:rspPrisionShareHero", 10)
	if content.err == nil or content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("notice_0103"))
	end
end
function heroJailCtrl:getHerosInMyPrison(...)
	return table.keys(self.heroPrisonList)
end
function heroJailCtrl:getHerosInMyPrisonByID(id)
	return self.heroPrisonList[id]
end
function heroJailCtrl:isCanExecutePrisonInMyJail(...)
	local ret = false
	for _, v in pairs(self.heroPrisonList) do
		local state = self.getJailStateWithTime(v)
		if state == gHeroJailState.execute then
			ret = true
			break
		end
	end
	return ret
end
function heroJailCtrl:getHerosInOtherPrison(...)
	return table.keys(self.inIronsHeroList)
end
function heroJailCtrl:getHerosInOtherPrisonByID(id)
	dump(self.inIronsHeroList, "self.inIronsHeroList")
	return self.inIronsHeroList[tostring(id)]
end
function heroJailCtrl:isAnyoneInMyJail(...)
	return table.nums(self.heroPrisonList) > 0
end
function heroJailCtrl:isAnyCanExecute(...)
	if table.nums(self.heroPrisonList) > 0 then
		local minExecuteTime
		for _, jailData in pairs(self.heroPrisonList) do
			local state, leftTime = self.getJailStateWithTime(jailData)
			if gHeroJailState.waiting == state then
				if minExecuteTime then
					minExecuteTime = math.min(minExecuteTime, leftTime)
				else
					minExecuteTime = leftTime
				end
			end
		end
		return minExecuteTime
	end
end
function heroJailCtrl.getJailStateWithTime(jailData)
	local approachZero = function(value)
		return math.max(0, value)
	end
	if jailData and jailData.extraData then
		local nowTime = serviceFunctions.systemTime()
		local combine = jailData.extraData
		if combine.executeTime <= 0 then
			return gHeroJailState.escape, approachZero(combine.captureTime + combine.killTime - nowTime), combine.killTime
		elseif 0 < combine.captureTime + combine.killTime - nowTime then
			return gHeroJailState.waiting, approachZero(combine.captureTime + combine.killTime - nowTime), combine.killTime
		else
			return gHeroJailState.execute, approachZero(combine.captureTime + combine.killTime + combine.executeTime - nowTime), combine.executeTime
		end
	end
end
function heroJailCtrl.combineUidAndHeroID(hid, uid)
	return string.format("%s_%s", tostring(uid), tostring(hid))
end
function heroJailCtrl:ctor(properties)
	heroJailCtrl.super.ctor(self, properties)
	self:resetData()
end
function heroJailCtrl:EnterGame()
	heroJailCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_HERO_PRISON_MODULE, gCmd.REQ_HERO_PRISON_INITDATA, handler(self, self.rspInitdata))
	msgCtrl.register(gCmd.CMD_HERO_PRISON_MODULE, gCmd.REQ_HERO_PRISON_OFFER_REWARD, handler(self, self.rspOfferReward))
	msgCtrl.register(gCmd.CMD_HERO_PRISON_MODULE, gCmd.REQ_HERO_PRISON_SET_RANSOM, handler(self, self.rspSetRansom))
	msgCtrl.register(gCmd.CMD_HERO_PRISON_MODULE, gCmd.REQ_HERO_PRISON_BREAKER, handler(self, self.rspBreaker))
	msgCtrl.register(gCmd.CMD_HERO_PRISON_MODULE, gCmd.REQ_HERO_PRISON_EXECUTE, handler(self, self.rspExecute))
	msgCtrl.register(gCmd.CMD_HERO_PRISON_MODULE, gCmd.REQ_HERO_PRISON_RELEASE_HERO, handler(self, self.rspReleaseHero))
	msgCtrl.register(gCmd.CMD_HERO_PRISON_MODULE, gCmd.REQ_HERO_PRISON_PAY_RANSOM, handler(self, self.rspPayRansom))
	msgCtrl.register(gCmd.CMD_HERO_PRISON_MODULE, gCmd.REQ_HERO_PRISON_GET_TOTAL_REWARD, handler(self, self.rspGetReward))
	msgCtrl.register(gCmd.CMD_HERO_PRISON_MODULE, gCmd.REQ_HERO_PRISON_SHARE_HERO, handler(self, self.rspPrisionShareHero))
end
function heroJailCtrl:registerNotify(...)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HERO_PRISON, handler(self, self.noitfyDataRsp))
end
function heroJailCtrl:noitfyDataRsp(content)
	dump(content, "heroJailCtrl:noitfyDataRsp@@@@", 6)
	local loopData = content.data
	for i, notifyMsg in ipairs(loopData) do
		local recevData = notifyMsg.data
		if recevData.inIronHeroInfo then
			local info = recevData.inIronHeroInfo
			self.inIronsHeroList[tostring(info.heroID)] = info
			_ENV = tostring(info.heroID)
			tostring(info.heroID).msg = "MESSAGE_SERVER_HEROJAIN_NOTICEMYHERO"
			tostring(info.heroID).heroID = info.heroID
			SoraDSendMessage((tostring(info.heroID)))
		end
		if recevData.delInIronHeroInfo then
			local info = recevData.delInIronHeroInfo
			self.inIronsHeroList[tostring(info.heroID)] = nil
			_ENV = tostring(info.heroID)
			tostring(info.heroID).msg = "MESSAGE_SERVER_HEROJAIN_NOTICEMYHERO"
			tostring(info.heroID).heroID = info.heroID
			SoraDSendMessage((tostring(info.heroID)))
		end
		if recevData.prisonHeroInfo then
			local info = recevData.prisonHeroInfo
			local flagID = heroJailCtrl.combineUidAndHeroID(info.heroID, info.ownerUid)
			self.heroPrisonList[flagID] = info
			_ENV = info.ownerUid
			info.ownerUid.msg = "MESSAGE_SERVER_HEROJAIN_NOTICEOTHERHERO"
			info.ownerUid.flagID = flagID
			SoraDSendMessage(info.ownerUid)
		end
		if recevData.delPrisonHeroInfo then
			local info = recevData.delPrisonHeroInfo
			local flagID = heroJailCtrl.combineUidAndHeroID(info.heroID, info.ownerUid)
			self.heroPrisonList[flagID] = nil
			_ENV = info.ownerUid
			info.ownerUid.msg = "MESSAGE_SERVER_HEROJAIN_NOTICEOTHERHERO"
			info.ownerUid.flagID = flagID
			SoraDSendMessage(info.ownerUid)
		end
	end
end
function heroJailCtrl:resetData()
	self.inIronsHeroList, _UPVALUE0_, self.heroPrisonList, _UPVALUE0_ = nil, nil, nil, nil
end
function heroJailCtrl:Logout()
	heroJailCtrl.super.Logout(self)
	self:resetData()
end
function heroJailCtrl:initClientData(data)
	if nil == data then
		return
	end
	dump(data, "heroJailCtrl:initClientData", 10)
	if not data.heroPrisonList then
		_ENV = data.heroPrisonList
	end
	self.heroPrisonList = data.heroPrisonList
	if not data.inIronsHeroList then
		_ENV = data.inIronsHeroList
	end
	self.inIronsHeroList = data.inIronsHeroList
	self:registerNotify()
end
return heroJailCtrl
