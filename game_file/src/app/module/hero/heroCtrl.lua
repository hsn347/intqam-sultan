local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local timerList = gModuleMgr.getObject("timerList")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = class("heroCtrl", gamemodulec)
function heroCtrl:initReq(...)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_INITDATA, gCmd.REQ_HERO_SYS_INITDATA, gCmd.REQ_HERO_SYS_INITDATA
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:recruitReq(heroID)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_RECRUIT, gCmd.REQ_HERO_SYS_RECRUIT
	;(nil).data, gCmd.REQ_HERO_SYS_RECRUIT.heroID = gCmd.REQ_HERO_SYS_RECRUIT, heroID
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:upgradeHeroReq(heroID, opType, heroUpType)
	local _ENV, heroUpType = nil, heroUpType or 1
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_UPGRADE_HERO, gCmd.REQ_HERO_SYS_UPGRADE_HERO
	gCmd.REQ_HERO_SYS_UPGRADE_HERO.heroID = heroID
	gCmd.REQ_HERO_SYS_UPGRADE_HERO.opType = opType
	;(nil).data, gCmd.REQ_HERO_SYS_UPGRADE_HERO.heroUpType = gCmd.REQ_HERO_SYS_UPGRADE_HERO, heroUpType
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:feedHeroReq(heroID, itemID, itemNum)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_FEED_HERO, gCmd.REQ_HERO_SYS_FEED_HERO
	gCmd.REQ_HERO_SYS_FEED_HERO.heroID = heroID
	gCmd.REQ_HERO_SYS_FEED_HERO.itemID = itemID
	gCmd.REQ_HERO_SYS_FEED_HERO.itemNum = itemNum
	;(nil).data, gCmd.REQ_HERO_SYS_FEED_HERO.opType = gCmd.REQ_HERO_SYS_FEED_HERO, gHeroUpgradeType.NORMAL
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:setDefendHeroReq(heroID, opType)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_SET_DEFEND_HERO, gCmd.REQ_HERO_SYS_SET_DEFEND_HERO
	gCmd.REQ_HERO_SYS_SET_DEFEND_HERO.heroID = heroID
	;(nil).data, gCmd.REQ_HERO_SYS_SET_DEFEND_HERO.opType = gCmd.REQ_HERO_SYS_SET_DEFEND_HERO, opType
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:resurgenceHeroReq(heroID, opType)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_RESURGENCE, gCmd.REQ_HERO_SYS_RESURGENCE
	gCmd.REQ_HERO_SYS_RESURGENCE.heroID = heroID
	;(nil).data, gCmd.REQ_HERO_SYS_RESURGENCE.opType = gCmd.REQ_HERO_SYS_RESURGENCE, opType
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:setDefendListReq(heroList)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_SET_HERO_LIST_DEFEND, gCmd.REQ_HERO_SYS_SET_HERO_LIST_DEFEND
	;(nil).data, gCmd.REQ_HERO_SYS_SET_HERO_LIST_DEFEND.heroList = gCmd.REQ_HERO_SYS_SET_HERO_LIST_DEFEND, heroList
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:queryShareInfo(heroID, channel)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_SHARE, gCmd.REQ_HERO_SYS_SHARE
	gCmd.REQ_HERO_SYS_SHARE.heroID = heroID
	;(nil).data, gCmd.REQ_HERO_SYS_SHARE.channel = gCmd.REQ_HERO_SYS_SHARE, channel
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:remakeSkillReq(heroID, skillID, itemID, times)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_REMAKE_POWER_SKILL, gCmd.REQ_HERO_SYS_REMAKE_POWER_SKILL
	gCmd.REQ_HERO_SYS_REMAKE_POWER_SKILL.heroID = heroID
	gCmd.REQ_HERO_SYS_REMAKE_POWER_SKILL.skillID = skillID
	gCmd.REQ_HERO_SYS_REMAKE_POWER_SKILL.itemID = itemID
	;(nil).data, gCmd.REQ_HERO_SYS_REMAKE_POWER_SKILL.times = gCmd.REQ_HERO_SYS_REMAKE_POWER_SKILL, times or 1
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:saveRemakeSkillReq(heroID, isAuto)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_SAVE_PWER_SKILL, gCmd.REQ_HERO_SYS_SAVE_PWER_SKILL
	gCmd.REQ_HERO_SYS_SAVE_PWER_SKILL.heroID = heroID
	;(nil).data, gCmd.REQ_HERO_SYS_SAVE_PWER_SKILL.isAuto = gCmd.REQ_HERO_SYS_SAVE_PWER_SKILL, isAuto
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:cancelRemakeSkillReq(heroID)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_CANCEL_PWER_SKILL, gCmd.REQ_HERO_SYS_CANCEL_PWER_SKILL
	;(nil).data, gCmd.REQ_HERO_SYS_CANCEL_PWER_SKILL.heroID = gCmd.REQ_HERO_SYS_CANCEL_PWER_SKILL, heroID
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:exchangeChipsReq(exchangeID, count, type)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_EXCHANGE_CHIPS, gCmd.REQ_HERO_SYS_EXCHANGE_CHIPS
	gCmd.REQ_HERO_SYS_EXCHANGE_CHIPS.exchangeID = exchangeID
	gCmd.REQ_HERO_SYS_EXCHANGE_CHIPS.count = count
	;(nil).data, gCmd.REQ_HERO_SYS_EXCHANGE_CHIPS.type = gCmd.REQ_HERO_SYS_EXCHANGE_CHIPS, type or 0
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:feedHeroMastery(heroID, itemID, num)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_FEED_HERO_MASTERY, gCmd.REQ_HERO_SYS_FEED_HERO_MASTERY
	gCmd.REQ_HERO_SYS_FEED_HERO_MASTERY.heroID = heroID
	gCmd.REQ_HERO_SYS_FEED_HERO_MASTERY.itemID = itemID
	;(nil).data, gCmd.REQ_HERO_SYS_FEED_HERO_MASTERY.num = gCmd.REQ_HERO_SYS_FEED_HERO_MASTERY, num
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:dressActive(itemID)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_DRESS_ACTIVE, gCmd.REQ_HERO_SYS_DRESS_ACTIVE
	;(nil).data, gCmd.REQ_HERO_SYS_DRESS_ACTIVE.itemID = gCmd.REQ_HERO_SYS_DRESS_ACTIVE, itemID
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:dressWear(dressID)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_DRESS_WEAR, gCmd.REQ_HERO_SYS_DRESS_WEAR
	;(nil).data, gCmd.REQ_HERO_SYS_DRESS_WEAR.dressID = gCmd.REQ_HERO_SYS_DRESS_WEAR, dressID
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:weaponWear(heroID, weaponUid)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_WEAPON_WEAR, gCmd.REQ_HERO_SYS_WEAPON_WEAR
	gCmd.REQ_HERO_SYS_WEAPON_WEAR.heroID = heroID
	;(nil).data, gCmd.REQ_HERO_SYS_WEAPON_WEAR.weaponUid = gCmd.REQ_HERO_SYS_WEAPON_WEAR, weaponUid
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:weaponTakeOff(heroID)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_WEAPON_TAKE_OFF, gCmd.REQ_HERO_SYS_WEAPON_TAKE_OFF
	;(nil).data, gCmd.REQ_HERO_SYS_WEAPON_TAKE_OFF.heroID = gCmd.REQ_HERO_SYS_WEAPON_TAKE_OFF, heroID
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:reforge(heroID, isFree)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_RESHAPE, gCmd.REQ_HERO_SYS_RESHAPE
	gCmd.REQ_HERO_SYS_RESHAPE.heroID = heroID
	;(nil).data, gCmd.REQ_HERO_SYS_RESHAPE.isFree = gCmd.REQ_HERO_SYS_RESHAPE, isFree or false
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:exchangeBatch(exchangeInfo)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_SYS_EXCHANGE_BATCH, gCmd.REQ_HERO_SYS_EXCHANGE_BATCH
	;(nil).data, gCmd.REQ_HERO_SYS_EXCHANGE_BATCH.exchangeInfo = gCmd.REQ_HERO_SYS_EXCHANGE_BATCH, exchangeInfo
	local msg
	serverproxy:SendMsg(msg)
end
function heroCtrl:initRsp(...)
	dump(content, "heroCtrl:initRsp", 10)
	if content.err == gErrDef.Err_None then
	else
	end
end
function heroCtrl:recruitRsp(content)
	dump(content, "heroCtrl:recruitRsp", 10)
	if content.err == gErrDef.Err_None then
		local heroInfo = content.rspdata.heroInfo
		local heroID = heroInfo.heroID
		self.heroListInfo[tostring(heroID)] = heroInfo
		_ENV = tostring(heroID)
		tostring(heroID).msg = "MESSAGE_SERVER_HERO_RECRUITSUCCESS"
		tostring(heroID).heroID = heroID
		SoraDSendMessage((tostring(heroID)))
		_ENV = tostring(heroID)
		tostring(heroID).msg = "MESSAGE_GREEN_POINT_UPDATE"
		tostring(heroID).type = GREEN_POINT_NOTICE_TYPE.HERO
		SoraDSendMessage((tostring(heroID)))
		_ENV = tostring(heroID)
		tostring(heroID).msg = "MESSAGE_SERVER_HERO_STORY_UPDATE"
		SoraDSendMessage((tostring(heroID)))
	else
		if SoraDGetCastleLv() < CASTLE_LV7_LIMITED then
			_ENV = tostring(heroID)
			tostring(heroID).name = i18n("common_name_01")
			tostring(heroID).lv = CASTLE_LV7_LIMITED
			SoraDShowMsgTip(i18n("common_text_2122", (tostring(heroID))))
		end
		_ENV = i18n("common_text_2122", (tostring(heroID)))
		i18n("common_text_2122", (tostring(heroID))).msg = "MESSAGE_SERVER_HERO_ERRCLOSELOADING"
		SoraDSendMessage(i18n("common_text_2122", (tostring(heroID))))
	end
end
function heroCtrl:upgradeHeroRsp(content)
	dump(content, "heroCtrl:upgradeHeroRsp", 10)
	if content.err == gErrDef.Err_None then
		local opType = content.data.opType
		local heroID = content.data.heroID
		local queueData = content.rspdata.queueData
		if queueData then
			local queueCtrl = gametop.playertop_:getModule("queueCtrl")
			queueCtrl:addQueue(gQueueTypeDef.hero_upgrade, queueData.starttime, queueData.totaltime, queueData.lefttime, queueData.data)
			_ENV = queueCtrl
			queueCtrl.msg = "MESSAGE_GREEN_POINT_UPDATE"
			queueCtrl.type = GREEN_POINT_NOTICE_TYPE.HERO
			SoraDSendMessage(queueCtrl)
		else
			local heroInfo = content.rspdata.heroInfo
			self.heroListInfo[tostring(heroID)] = heroInfo
			local qualityDes = heroltCtrl.getQuality2Des(heroInfo.quality)
			local heroName = i18n(heroltCtrl.getHeroInfo(heroInfo.heroID).herName)
			local heroUpType = content.data.heroUpType or gHeroSysUpType.UPGRADE
			if gHeroSysUpType.UPGRADE == heroUpType then
				_ENV = queueData.data
				queueData.data.hero = heroName
				queueData.data.color = qualityDes
				SoraDShowMsgTip(i18n("hero_text_73", queueData.data))
			end
		end
		_ENV = heroltCtrl.getQuality2Des(heroInfo.quality)
		heroltCtrl.getQuality2Des(heroInfo.quality).msg = "MESSAGE_SERVER_HERO_STARTUPGRADE"
		heroltCtrl.getQuality2Des(heroInfo.quality).heroID = heroID
		heroltCtrl.getQuality2Des(heroInfo.quality).opType = opType
		SoraDSendMessage((heroltCtrl.getQuality2Des(heroInfo.quality)))
	else
	end
end
function heroCtrl:feedHeroRsp(content)
	dump(content, "heroCtrl:feedHeroRsp", 10)
	if content.err == gErrDef.Err_None then
		local itemID = content.data.itemID
		local itemNum = content.data.itemNum
		local heroInfo = content.rspdata.heroInfo
		local heroID = heroInfo.heroID
		if not content.rspdata.critData then
			local _ENV, critData = content.rspdata.critData, content.rspdata.critData
		end
		local times = critData[1] and critData[1].times or 1
		self.heroListInfo[tostring(heroID)] = heroInfo
		_ENV = tostring(heroID)
		tostring(heroID).msg = "MESSAGE_SERVER_HERO_FEEDHEROSUCCESS"
		tostring(heroID).itemID = itemID
		tostring(heroID).itemNum = itemNum
		tostring(heroID).times = times
		SoraDSendMessage((tostring(heroID)))
	else
		if content.err == gErrDef.Err_HERO_SYS_CUR_LEV_MAX then
			SoraDShowMsgTip(i18n("hero_text_74"))
		elseif content.err == gErrDef.Err_HERO_SYS_CUR_UNDER_LEV_MAX then
			SoraDShowMsgTip(i18n("hero_text_102"))
		end
		_ENV = i18n("hero_text_102")
		i18n("hero_text_102").msg = "MESSAGE_SERVER_HERO_ERRCLOSELOADING"
		SoraDSendMessage(i18n("hero_text_102"))
	end
end
function heroCtrl:setDefendHeroRsp(content)
	dump(content, "heroCtrl:setDefendHeroRsp", 10)
	if content.err == gErrDef.Err_None then
		self.defendList = content.rspdata.defendList
		local heroInfo = content.rspdata.heroInfo
		local heroID = heroInfo.heroID
		self.heroListInfo[tostring(heroID)] = heroInfo
		_ENV = tostring(heroID)
		tostring(heroID).msg = "MESSAGE_SERVER_HERO_SETSINGLEDENFEND"
		tostring(heroID).heroID = heroID
		SoraDSendMessage((tostring(heroID)))
	else
	end
end
function heroCtrl:resurgenceHeroRsp(content)
	dump(content, "heroCtrl:resurgenceHeroRsp", 10)
	if content.err == gErrDef.Err_None then
		local heroInfo = content.rspdata.heroInfo
		local heroID = heroInfo.heroID
		self.heroListInfo[tostring(heroID)] = heroInfo
		_ENV = tostring(heroID)
		tostring(heroID).msg = "MESSAGE_SERVER_HERO_RESURGENCESUCCESS"
		tostring(heroID).heroID = heroID
		SoraDSendMessage((tostring(heroID)))
		_ENV = tostring(heroID)
		tostring(heroID).msg = "MESSAGE_GREEN_POINT_UPDATE"
		tostring(heroID).type = GREEN_POINT_NOTICE_TYPE.HERO
		SoraDSendMessage((tostring(heroID)))
	else
	end
end
function heroCtrl:setDefendListRsp(content)
	dump(content, "heroCtrl:setDefendListRsp", 10)
	if content.err == gErrDef.Err_None then
		local redata = content.rspdata
		for k, v in pairs(redata.updateHeroInfo) do
			local hid = v.heroID
			self.heroListInfo[tostring(hid)] = v
		end
		self.defendList = redata.defendList
		_ENV = pairs(redata.updateHeroInfo)
		pairs(redata.updateHeroInfo).msg = "MESSAGE_SERVER_HERO_SETLISTDENFEND"
		SoraDSendMessage(pairs(redata.updateHeroInfo))
	else
	end
end
function heroCtrl:queryShareRsp(content)
	dump(content, "heroCtrl:queryShareRsp", 10)
	if content.err == gErrDef.Err_None then
		local starttime = content.rspdata.starttime
		local totaltime = content.rspdata.totaltime
		_ENV = nil
		self:addHeroShareQueue(starttime, totaltime, totaltime, nil)
		SoraDShowMsgTip(i18n("notice_0103"))
	else
	end
end
function heroCtrl:remakeSkillRsp(content)
	dump(content, "heroCtrl:remakeSkillRsp", 10)
	if content.err == gErrDef.Err_None then
		local heroInfo = content.rspdata.heroInfo
		local heroID = heroInfo.heroID
		if not IsArClient then
			local preBuff = content.rspdata.heroInfo.powerSkill[tostring(content.data.skillID)].buffValue or 0
			if not content.rspdata.heroInfo.powerSkillBack then
				local _ENV, powerSkillBack = content.rspdata.heroInfo.powerSkillBack, content.rspdata.heroInfo.powerSkillBack
			end
			if not powerSkillBack[tostring(content.data.skillID)] then
				local _ENV, tmpBuff = powerSkillBack[tostring(content.data.skillID)], powerSkillBack[tostring(content.data.skillID)]
			end
			local afterBuff = tmpBuff.buffValue or 0
			local isCrit = tmpBuff.crit == 1
			local isSuccess = false
			if 0 < afterBuff - preBuff then
				isSuccess = true
			end
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_HERO_AWAKE_FOR_ROS"
			;(nil).isSuccess = isSuccess
			;(nil).data = content.data
			;(nil).preBuff = preBuff
			;(nil).afterBuff = afterBuff
			;(nil).isCrit = isCrit
			SoraDSendMessage(nil)
		end
		if heroInfo.powerSkillBack and next(heroInfo.powerSkillBack) then
			local isAllMax = true
			for k, v in pairs(heroInfo.powerSkill) do
				local psbData = heroInfo.powerSkillBack[tostring(v.skillID)]
				print("psbData.buffValue======", v.skillID, psbData.buffValue, heroltCtrl:getMaxBuffValue(v.skillID))
				if psbData and psbData.buffValue < heroltCtrl:getMaxBuffValue(v.skillID) then
					isAllMax = false
					break
				end
			end
			print("isAllMax=====", isAllMax)
			if isAllMax then
				heroInfo.powerSkill = clone(heroInfo.powerSkillBack)
			end
		end
		self.heroListInfo[tostring(heroID)] = heroInfo
	end
	if content.err == gErrDef.Err_HERO_SYS_REACH_MAX_PROPERTY_VALUE then
		print(i18n("skill_text_17"))
	end
	SoraDCloseLoading()
	_ENV = i18n("skill_text_17")
	i18n("skill_text_17").msg = "MESSAGE_SERVER_HERO_AWAKE"
	SoraDSendMessage(i18n("skill_text_17"))
end
function heroCtrl:saveSkillRsp(content)
	dump(content, "heroCtrl:saveSkillRsp", 10)
	if content.err == gErrDef.Err_None then
		local heroInfo = content.rspdata.heroInfo
		local heroID = heroInfo.heroID
		self.heroListInfo[tostring(heroID)] = heroInfo
	end
	if content.err == gErrDef.Err_HERO_SYS_NOT_POWER_SKILL_BACK then
		print("数据保存失败")
	end
	_ENV = "数据保存失败"
	;("数据保存失败").msg = "MESSAGE_SERVER_HERO_AWAKE"
	;("数据保存失败").isAuto = content.data.isAuto
	SoraDSendMessage("数据保存失败")
end
function heroCtrl:cancelSkillRsp(content)
	dump(content, "heroCtrl:cancelSkillRsp", 10)
	if content.err == gErrDef.Err_None then
		local heroInfo = content.rspdata.heroInfo
		local heroID = heroInfo.heroID
		self.heroListInfo[tostring(heroID)] = heroInfo
	end
	_ENV = heroInfo.heroID
	heroInfo.heroID.msg = "MESSAGE_SERVER_HERO_AWAKE"
	SoraDSendMessage(heroInfo.heroID)
end
function heroCtrl:chipsExchangeRsp(content)
	dump(content, "heroCtrl:chipsExchangeRsp", 10)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.itemInfo, true)
		_ENV = content.rspdata.itemInfo
		content.rspdata.itemInfo.msg = "MESSAGE_SERVER_HERO_EXCHANGE"
		SoraDSendMessage(content.rspdata.itemInfo)
	end
end
function heroCtrl:feedHeroMasteryRsp(content)
	dump(content, "heroCtrl:feedHeroMasteryRsp", 10)
	if content.err == gErrDef.Err_None then
		local heroInfo = content.rspdata.heroInfo
		local heroID = heroInfo.heroID
		self.heroListInfo[tostring(heroID)] = heroInfo
		if not content.rspdata.critInfo then
			local _ENV, critInfo = content.rspdata.critInfo, content.rspdata.critInfo
		end
		local needShowResult = false
		if not critInfo.critInfo then
			_ENV = critInfo.critInfo
		end
		for k, v in pairs(critInfo.critInfo) do
			if tonumber(k) > 1 then
				needShowResult = true
			end
		end
		if needShowResult then
			_ENV = nil
			;(nil).critInfo = content.rspdata.critInfo
			;(nil).itemID = content.data.itemID
			uiManager:show("SpecializeCritResult", nil)
		end
	end
	SoraDCloseLoading()
	_ENV = heroInfo.heroID
	heroInfo.heroID.msg = "MESSAGE_SERVER_HERO_FEED_SKILL"
	SoraDSendMessage(heroInfo.heroID)
end
function heroCtrl:dressActiveRsp(content)
	dump(content, "heroCtrl:dressActiveRsp", 10)
	if content.err == gErrDef.Err_None then
		local heroInfo = content.rspdata.heroInfo
		local heroID = heroInfo.heroID
		local dressID = content.rspdata.dressID
		if dressID then
			local isOwn = self:isOwnDressID(heroID, dressID)
			if not isOwn then
				_ENV = nil
				;(nil).heroID = heroID
				;(nil).dressID = dressID
				uiManager:show("HeroDressGain", nil)
			end
		end
		self.heroListInfo[tostring(heroID)] = heroInfo
		local publicRead = include("publicRead")
		_ENV = nil
		;(nil).itemID = i18n(publicRead.getName(content.data.itemID))
		SoraDShowMsgTip(i18n("notice_0053", nil))
	end
	_ENV = heroInfo.heroID
	heroInfo.heroID.msg = "MESSAGE_SERVER_HERO_DRESS_ACTIVE"
	SoraDSendMessage(heroInfo.heroID)
	_ENV = heroInfo.heroID
	heroInfo.heroID.msg = "MESSAGE_SERVER_HERO_STORYTASK_UPDATE"
	SoraDSendMessage(heroInfo.heroID)
	_ENV = heroInfo.heroID
	heroInfo.heroID.msg = "MESSAGE_GREEN_POINT_UPDATE"
	heroInfo.heroID.type = GREEN_POINT_NOTICE_TYPE.HERO
	SoraDSendMessage(heroInfo.heroID)
end
function heroCtrl:dressWearRsp(content)
	dump(content, "heroCtrl:dressWearRsp", 10)
	local heroID
	if content.err == gErrDef.Err_None then
		local heroInfo = content.rspdata.heroInfo
		heroID = heroInfo.heroID
		self.heroListInfo[tostring(heroID)] = heroInfo
	end
	_ENV = self.heroListInfo
	self.heroListInfo.msg = "MESSAGE_SERVER_HERO_DRESS_WEAR"
	self.heroListInfo.heroID = heroID
	SoraDSendMessage(self.heroListInfo)
end
function heroCtrl:weaponWearRsp(content)
	dump(content, "heroCtrl:weaponWearRsp", 10)
	if content.err == gErrDef.Err_None then
		local otherHeroID = content.rspdata.otherHeroID
		local heroID = content.data.heroID
		local weaponUid = content.data.weaponUid
		if otherHeroID then
			self.heroListInfo[tostring(otherHeroID)].weaponUid = nil
		end
		self.heroListInfo[tostring(heroID)].weaponUid = weaponUid
	end
	_ENV = content.data.heroID
	content.data.heroID.msg = "MESSAGE_SERVER_HERO_WEAPON_WEAR"
	SoraDSendMessage(content.data.heroID)
end
function heroCtrl:weaponTakeOffRsp(content)
	dump(content, "heroCtrl:weaponTakeOffRsp", 10)
	if content.err == gErrDef.Err_None then
		local heroID = content.data.heroID
		self.heroListInfo[tostring(heroID)].weaponUid = nil
	end
	_ENV = self.heroListInfo[tostring(heroID)]
	self.heroListInfo[tostring(heroID)].msg = "MESSAGE_SERVER_HERO_WEAPON_WEAR"
	SoraDSendMessage(self.heroListInfo[tostring(heroID)])
end
function heroCtrl:reshapeRsp(content)
	dump(content, "heroCtrl:reshapeRsp", 10)
	if content.err == gErrDef.Err_None then
		local heroInfo = content.rspdata.heroInfo
		local heroID = heroInfo.heroID
		self.heroListInfo[tostring(heroID)] = heroInfo
		if content.rspdata.lastFreeReshapeTime then
			self.lastFreeReshapeTime = content.rspdata.lastFreeReshapeTime
		end
		if content.rspdata.rewards then
			SoraDMailGainItems(content.rspdata.rewards, true)
		end
	end
	_ENV = heroInfo.heroID
	heroInfo.heroID.msg = "MESSAGE_SERVER_HERO_FEED_SKILL"
	SoraDSendMessage(heroInfo.heroID)
	_ENV = heroInfo.heroID
	heroInfo.heroID.msg = "MESSAGE_SERVER_HERO_AWAKE"
	SoraDSendMessage(heroInfo.heroID)
end
function heroCtrl:reExchangeBatchRsp(content)
	dump(content, "heroCtrl:reExchangeBatchRsp", 10)
	if content.err == gErrDef.Err_None and content.rspdata.itemInfo then
		SoraDMailGainItems(content.rspdata.itemInfo, true)
	end
	_ENV = content.rspdata.itemInfo
	content.rspdata.itemInfo.msg = "MESSAGE_SERVER_HERO_EXCHANGE"
	SoraDSendMessage(content.rspdata.itemInfo)
end
local toNumTable = function(hashtable)
	local _ENV, keys
	for k, v in pairs(hashtable) do
		keys[#keys + 1] = tonumber(k)
	end
	return keys
end
function heroCtrl:getAllHerosListByRule()
	local _ENV, temp
	for __, data in pairs(self.heroListInfo) do
		local heroID = data.heroID
		local upgrade = 0
		local maxQuality = heroltCtrl:getHeroAwakeMaxQuality(heroID)
		if maxQuality > data.quality then
			local _, _, _, canUp = heroltCtrl:judgeUpgradeItem(heroID, data.quality + 1)
			upgrade = canUp and 1 or 0
		end
		_ENV = _
		heroltCtrl:judgeUpgradeItem(heroID, data.quality + 1).upgrade = upgrade
		temp[heroID], heroltCtrl:judgeUpgradeItem(heroID, data.quality + 1).rarity = heroltCtrl:judgeUpgradeItem(heroID, data.quality + 1)
	end
	local heroIDList = heroltCtrl:getAllHeroID()
	for __, heroID in ipairs(heroIDList) do
		if not temp[heroID] then
			_ENV = temp[heroID]
			temp[heroID], temp[heroID].itemNum = temp[heroID], heroltCtrl:judgeUpgradeItem(heroID)
		end
	end
	table.sort(heroIDList, function(l, r)
		local lData = self.heroListInfo[tostring(l)]
		local rData = self.heroListInfo[tostring(r)]
		if lData and rData then
			local lUpgrade = temp[l].upgrade
			local rUpgrade = temp[r].upgrade
			local lRarity = temp[l].rarity
			local rRarity = temp[r].rarity
			if lUpgrade ~= rUpgrade then
				return lUpgrade > rUpgrade
			elseif lData.quality ~= rData.quality then
				return lData.quality > rData.quality
			elseif lRarity ~= rRarity then
				return lRarity > rRarity
			elseif lData.level ~= rData.level then
				return lData.level > rData.level
			elseif lData.level_exp ~= rData.level_exp then
				return lData.level_exp > rData.level_exp
			else
				return lData.heroID < rData.heroID
			end
		elseif not lData and not rData then
			local litemNum = temp[l].itemNum
			local ritemNum = temp[r].itemNum
			if litemNum == ritemNum then
				return l < r
			else
				return litemNum > ritemNum
			end
		else
			return lData ~= nil
		end
	end)
	return heroIDList
end
function heroCtrl:getHaveHerosList(...)
	return table.keys(self.heroListInfo)
end
function heroCtrl:getHeroList()
	return self.heroListInfo
end
function heroCtrl:getHeroSSS(isAwake, isNoWeapon)
	local _ENV, list
	local heros = self:getHaveHerosList()
	for k, v in ipairs(heros) do
		local rarity = heroltCtrl:getHeroRarity(tonumber(v))
		if rarity == gHeroRarity.ORANGE then
			if isAwake then
				local heroInfo = self:getHeroInfoByID(tonumber(v))
				if heroInfo.isAwake then
					if isNoWeapon then
						if not heroInfo.weaponUid or not (heroInfo.weaponUid > 0) then
							table.insert(list, tonumber(v))
						end
					else
						table.insert(list, tonumber(v))
					end
				end
			else
				table.insert(list, tonumber(v))
			end
		end
	end
	return list
end
function heroCtrl:isHaveHeroDress(dressID)
	local ret = false
	local heros = self:getHaveHerosList()
	for k, v in ipairs(heros) do
		local heroInfo = self:getHeroInfoByID(tonumber(v))
		if heroInfo and heroInfo.dress and heroInfo.dress.list and heroInfo.dress.list[tostring(dressID)] then
			ret = true
			break
		end
	end
	return ret
end
function heroCtrl:getHeroPowerSkillPercent(heroID)
	local percent = 0
	local heroInfo = self:getHeroInfoByID(heroID)
	if heroInfo and heroInfo.powerSkill then
		for k, v in pairs(heroInfo.powerSkill) do
			local maxValue = heroltCtrl:getSkillMaxValue(v.skillID)
			percent = percent + v.buffValue / maxValue
		end
		percent = math.floor(percent * 100 / 4)
	end
	return percent
end
function heroCtrl:getHaveHerosListByRule(sortType)
	local _ENV, temp
	for __, data in pairs(self.heroListInfo) do
		local heroID = data.heroID
		local upgrade = 0
		local maxQuality = heroltCtrl:getHeroAwakeMaxQuality(heroID)
		if maxQuality > data.quality then
			local _, _, _, canUp = heroltCtrl:judgeUpgradeItem(heroID, data.quality + 1)
			upgrade = canUp and 1 or 0
		elseif data.level >= gHeroMaxLevel and data.quality == maxQuality then
			local canAwake = heroltCtrl:judgeAwakeItem(heroID)
			upgrade = canAwake and not data.isAwake and 1 or 0
		end
		_ENV = heroID
		heroID.upgrade = upgrade
		temp[tostring(heroID)], heroID.rarity = heroID, heroltCtrl:getRarity(heroID) or 1
	end
	local ret = table.keys(self.heroListInfo)
	table.sort(ret, function(l, r)
		local lData = self.heroListInfo[l]
		local rData = self.heroListInfo[r]
		local lUpgrade = temp[l].upgrade
		local rUpgrade = temp[r].upgrade
		local lRarity = temp[l].rarity
		local rRarity = temp[r].rarity
		if lUpgrade ~= rUpgrade then
			return lUpgrade > rUpgrade
		end
		if sortType == gHeroSortType.quality then
			if lData.quality ~= rData.quality then
				return lData.quality > rData.quality
			end
		elseif sortType == gHeroSortType.level then
			if lData.level ~= rData.level then
				return lData.level > rData.level
			end
		elseif sortType == gHeroSortType.rarity and lRarity ~= rRarity then
			return lRarity > rRarity
		end
		if lData.quality ~= rData.quality then
			return lData.quality > rData.quality
		end
		if lRarity ~= rRarity then
			return lRarity > rRarity
		end
		if lData.level ~= rData.level then
			return lData.level > rData.level
		end
		if lData.level_exp ~= rData.level_exp then
			return lData.level_exp > rData.level_exp
		end
		return lData.heroID < rData.heroID
	end)
	return ret
end
function heroCtrl:filterHaveHerosList(rarity, classType, _heroID)
	local _ENV, ret
	for heroID, v in pairs(self.heroListInfo) do
		if _heroID ~= tonumber(heroID) and rarity <= heroltCtrl:getRarity(tonumber(heroID)) then
			table.insert(ret, heroID)
		end
	end
	ret = heroltCtrl.filterHeroClass(classType, ret)
	return ret
end
function heroCtrl:getHaveHerosIDNumList(...)
	return toNumTable(self.heroListInfo)
end
function heroCtrl:sortDispatchHerosID(heros, states, isCompareLie)
	local _ENV, sortTable
	for i, v in ipairs(heros) do
		local _ENV, data
		data.data = self:getHeroInfoByID(v)
		data.V = states[data.data.state] and 1 or 0
		if states[gHeroState.HERO_STATE_GARRISON] then
			local militaryFortressCtrl = SoraDGetCtrl("militaryFortressCtrl")
			if militaryFortressCtrl:isHeroInGarrison(v) then
				data.V = 0
			end
		end
		data.MarchNum = self:getHeroTotalMarchAddNum(v)
		data.Rarity = heroltCtrl:getRarity(tonumber(v))
		data.ownL = self:isOwnLieutenantByHeroID(v)
		if not isCompareLie or not commonCheck.HERO_COMBOS_SKILL then
			data.ownL = false
		end
		sortTable[v] = data
	end
	table.sort(heros, function(l, r)
		local lData = sortTable[l]
		local rData = sortTable[r]
		if lData.V ~= rData.V then
			return lData.V > rData.V
		elseif lData.ownL ~= rData.ownL then
			return lData.ownL
		elseif lData.MarchNum ~= rData.MarchNum then
			return lData.MarchNum > rData.MarchNum
		elseif lData.data.level ~= rData.data.level then
			return lData.data.level > rData.data.level
		elseif lData.Rarity ~= rData.Rarity then
			return lData.Rarity > rData.Rarity
		elseif lData.data.quality ~= rData.data.quality then
			return lData.data.quality > rData.data.quality
		else
			return lData.data.heroID < rData.data.heroID
		end
	end)
end
function heroCtrl:sortHuntHerosID(heros, states)
	local _ENV, sortTable
	for i, v in ipairs(heros) do
		local _ENV, data
		data.data = self:getHeroInfoByID(v)
		data.V = states[data.data.state] and 1 or 0
		data.huntRate = self:getHeroHuntingRate(v)
		sortTable[v] = data
	end
	table.sort(heros, function(l, r)
		local lData = sortTable[l]
		local rData = sortTable[r]
		if lData.V ~= rData.V then
			return lData.V > rData.V
		elseif lData.huntRate ~= rData.huntRate then
			return lData.huntRate > rData.huntRate
		elseif lData.data.quality ~= rData.data.quality then
			return lData.data.quality > rData.data.quality
		elseif lData.data.level ~= rData.data.level then
			return lData.data.level > rData.data.level
		elseif lData.data.level_exp ~= rData.data.level_exp then
			return lData.data.level_exp > rData.data.level_exp
		else
			return lData.data.heroID < rData.data.heroID
		end
	end)
end
function heroCtrl:sortDispatchHerosIDInTrain(heros, states)
	local lordlv = heroltCtrl.getLimitHeroLv()
	table.sort(heros, function(l, r)
		local lV, rV = 0, 0
		local lData = self:getHeroInfoByID(l)
		if lData then
			lV = states[lData.state] and lData.level < lordlv
			lV = lV and 1 or 0
		end
		local rData = self:getHeroInfoByID(r)
		if rData then
			rV = states[rData.state] and rData.level < lordlv
			rV = rV and 1 or 0
		end
		if lV ~= rV then
			return lV > rV
		elseif lData.quality ~= rData.quality then
			return lData.quality > rData.quality
		elseif lData.level ~= rData.level then
			return lData.level > rData.level
		elseif lData.level_exp ~= rData.level_exp then
			return lData.level_exp > rData.level_exp
		else
			return lData.heroID < rData.heroID
		end
	end)
end
function heroCtrl:getHeroInCastle(...)
	_ENV = nil
	;(nil)[gHeroState.HERO_STATE_NORMAL] = true
	;(nil)[gHeroState.HERO_STATE_DEAD] = false
	;(nil)[gHeroState.HERO_STATE_CAPTURED] = false
	;(nil)[gHeroState.HERO_STATE_BATTLE] = false
	;(nil)[gHeroState.HERO_STATE_DEFEND] = true
	local (nil)[gHeroState.HERO_STATE_ESCAPE], stateList = false, nil
	return self:getHeroByStates(stateList)
end
function heroCtrl:getHeroInCastleNotDefend(...)
	_ENV = nil
	;(nil)[gHeroState.HERO_STATE_NORMAL] = true
	;(nil)[gHeroState.HERO_STATE_DEAD] = false
	;(nil)[gHeroState.HERO_STATE_CAPTURED] = false
	;(nil)[gHeroState.HERO_STATE_BATTLE] = false
	;(nil)[gHeroState.HERO_STATE_DEFEND] = false
	local (nil)[gHeroState.HERO_STATE_ESCAPE], stateList = false, nil
	return self:getHeroByStates(stateList)
end
function heroCtrl:getHeroByStates(states)
	local _ENV, ret
	for _, v in pairs(self.heroListInfo) do
		if states[v.state] then
			table.insert(ret, v.heroID)
		end
	end
	return ret
end
function heroCtrl:getTheHeroByStates(heros, states)
	local _ENV, ret
	for _, v in pairs(heros) do
		local myState = self.heroListInfo[tostring(v)].state
		if states[myState] then
			table.insert(ret, v)
		end
	end
	return ret
end
function heroCtrl:judgeHeroInCastle(hid)
	_ENV = nil
	;(nil)[gHeroState.HERO_STATE_NORMAL] = true
	;(nil)[gHeroState.HERO_STATE_DEAD] = false
	;(nil)[gHeroState.HERO_STATE_CAPTURED] = false
	;(nil)[gHeroState.HERO_STATE_BATTLE] = false
	;(nil)[gHeroState.HERO_STATE_DEFEND] = true
	local (nil)[gHeroState.HERO_STATE_ESCAPE], stateList = false, nil
	return self:judgeHeroInStates(hid, stateList)
end
function heroCtrl:judgeHeroInStates(hid, states)
	local info = self.heroListInfo[tostring(hid)]
	if info then
		return states[info.state]
	end
end
function heroCtrl:judgeMyHeroInJail(hid)
	local info = self.heroListInfo[tostring(hid)]
	if info and info.state == gHeroState.HERO_STATE_CAPTURED then
		return true
	end
end
function heroCtrl:getHeroInDefend(...)
	local _ENV, ret
	local keys = table.keys(self.defendList)
	for _, v in pairs(keys) do
		table.insert(ret, tonumber(v))
	end
	table.sort(ret)
	dump(ret, "heroCtrl:getHeroInDefend")
	return ret
end
function heroCtrl:isHeroInDefend(heroID)
	for _heroID, _ in pairs(self.defendList) do
		if tonumber(heroID) == tonumber(_heroID) then
			return true
		end
	end
	return false
end
function heroCtrl:getNoHaveHerosList(...)
	local haveList = table.keys(self.heroListInfo)
	local allList = table.keys(heroltCtrl.herosInfo)
	for _, v in pairs(haveList) do
		table.removebyvalue(allList, tonumber(v))
	end
	local _ENV, noList = (for generator), pairs(haveList)
	for k, v in ipairs(allList) do
		if not SoraDisInList(v, gHeroTmpClose) and heroltCtrl:isHeroUnLock(v) then
			table.insert(noList, v)
		end
	end
	return noList
end
function heroCtrl:getNoHaveHerosListByRule()
	local ret = self:getNoHaveHerosList()
	table.sort(ret, function(l, r)
		local lNum = heroltCtrl:judgeUpgradeItem(tonumber(l))
		local rNum = heroltCtrl:judgeUpgradeItem(tonumber(r))
		local lRarity = 1
		lRarity = heroltCtrl:getRarity(tonumber(l)) or 1
		local rRarity = 1
		rRarity = heroltCtrl:getRarity(tonumber(r)) or 1
		if lNum ~= rNum then
			return lNum > rNum
		elseif lRarity ~= rRarity then
			return lRarity > rRarity
		else
			return l < r
		end
	end)
	return ret
end
function heroCtrl:getHeroInfoByID(hid)
	return self.heroListInfo[tostring(hid)]
end
function heroCtrl:isHaveActiveRed()
	local ret = false
	local num = 0
	local cfg = heroltCtrl:getDressSerCfg()
	local isHaveItem = function(items)
		local rs = false
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		for k, v in ipairs(items) do
			if backpackCtrl:getItemCount(v) > 0 then
				rs = true
				break
			end
		end
		return rs
	end
	for k, v in pairs(cfg) do
		local info = self:getHeroInfoByID(v.heroID)
		if info and next(v.activationItem) and isHaveItem(v.activationItem) and (not self:isOwnDressID(v.heroID, v.dressId) or self:isOwnDressID(v.heroID, v.dressId) and self:isLimitedDress(v.heroID, v.dressId)) then
			ret = true
			num = num + 1
		end
	end
	return ret, num
end
function heroCtrl:isHeroHaveActiveRed(hid)
	local ret = false
	local info = self:getHeroInfoByID(hid)
	if not info then
		return false
	end
	local cfg = heroltCtrl:getDressSerCfg()
	local isHaveItem = function(items)
		local rs = false
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		for k, v in ipairs(items) do
			if backpackCtrl:getItemCount(v) > 0 then
				rs = true
				break
			end
		end
		return rs
	end
	for k, v in pairs(cfg) do
		if v.heroID == hid and next(v.activationItem) and isHaveItem(v.activationItem) and (not self:isOwnDressID(v.heroID, v.dressId) or self:isOwnDressID(v.heroID, v.dressId) and self:isLimitedDress(v.heroID, v.dressId)) then
			ret = true
			break
		end
	end
	return ret
end
function heroCtrl:isHeroHaveDressActive(hid, dressID)
	local ret = false
	local cfg = heroltCtrl:getDressSerCfg()
	local isHaveItem = function(items)
		local rs = false
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		for k, v in ipairs(items) do
			if backpackCtrl:getItemCount(v) > 0 then
				rs = true
				break
			end
		end
		return rs
	end
	for k, v in pairs(cfg) do
		if v.heroID == hid and v.dressId == dressID and next(v.activationItem) and isHaveItem(v.activationItem) and (not self:isOwnDressID(v.heroID, v.dressId) or self:isOwnDressID(v.heroID, v.dressId) and self:isLimitedDress(v.heroID, v.dressId)) then
			ret = true
			break
		end
	end
	return ret
end
function heroCtrl:getHeroDressInfo(hid)
	return self.heroListInfo[tostring(hid)].dress
end
function heroCtrl:getHeroDressSeting(hid)
	return self.heroListInfo[tostring(hid)] and self.heroListInfo[tostring(hid)].dress and self.heroListInfo[tostring(hid)].dress.seting or heroltCtrl.getHeroDefaultDressID(hid)
end
function heroCtrl:isOwnDressID(hid, dressID)
	local ret = false
	if not (self.heroListInfo[tostring(hid)] and self.heroListInfo[tostring(hid)].dress) or not self.heroListInfo[tostring(hid)].dress.list then
		local _ENV, list = self.heroListInfo[tostring(hid)].dress.list, self.heroListInfo[tostring(hid)].dress.list
	end
	if list[tostring(dressID)] then
		ret = true
	end
	return ret
end
function heroCtrl:isHaveDressID(dressID)
	local _ENV, list
	for hid, v in pairs(self.heroListInfo) do
		list, _ENV = v.dress.list, v.dress.list
		list = v.dress and v.dress.list or nil
		if list[tostring(dressID)] then
			return true, tonumber(hid)
		end
	end
	return false
end
function heroCtrl:isWearDressID(hid, dressID)
	local ret = false
	if self.heroListInfo[tostring(hid)] and self.heroListInfo[tostring(hid)].dress and self.heroListInfo[tostring(hid)].dress.seting == dressID then
		ret = true
	end
	return ret
end
function heroCtrl:isLimitedDress(hid, dressID)
	local ret = false
	if not self.heroListInfo[tostring(hid)] or not self.heroListInfo[tostring(hid)].queue then
		local _ENV, queue = self.heroListInfo[tostring(hid)].queue, self.heroListInfo[tostring(hid)].queue
	end
	if queue["dress_" .. dressID] then
		ret = true
	end
	return ret, queue["dress_" .. dressID]
end
function heroCtrl:getDressLimitedTime(hid, dressID)
	local time = 0
	if not self.heroListInfo[tostring(hid)] or not self.heroListInfo[tostring(hid)].queue then
		local _ENV, queue = self.heroListInfo[tostring(hid)].queue, self.heroListInfo[tostring(hid)].queue
	end
	local queueInfo = queue["dress_" .. dressID]
	if queueInfo then
		time = queueInfo.totaltime + queueInfo.starttime - serviceFunctions.systemTime()
	end
	return time
end
function heroCtrl:getHeroActiveBuff(hid)
	local _ENV, buffList
	local heroInfo = self:getHeroInfoByID(hid)
	if heroInfo and heroInfo.dress and heroInfo.dress.list then
		for dressID, var in pairs(heroInfo.dress.list) do
			local ownBuff = heroltCtrl:getOwnBuff(tonumber(dressID))
			if next(ownBuff) then
				for ki, vi in ipairs(ownBuff) do
					if buffList[vi.id] then
						buffList[vi.id].val = buffList[vi.id].val + vi.value
						buffList[vi.id].heroID = hid
						buffList[vi.id].dressID = dressID
					else
						buffList[vi.id], _ENV = buffList[vi.id].val + vi.value, buffList[vi.id].val + vi.value
						buffList[vi.id].val = vi.value
						buffList[vi.id].heroID = hid
						buffList[vi.id].dressID = dressID
					end
				end
			end
		end
	end
	local _ENV, result = (for generator), pairs(heroInfo.dress.list)
	local index = 1
	for k, v in pairs(buffList) do
		_ENV = tonumber(dressID)
		tonumber(dressID).index = index
		tonumber(dressID).id = k
		tonumber(dressID).value = v.val
		tonumber(dressID).heroID = v.heroID
		tonumber(dressID).dressID = tonumber(v.dressID)
		table.insert(result, tonumber(dressID))
		index = index + 1
	end
	table.sort(result, function(a, b)
		return a.id < b.id
	end)
	return result
end
function heroCtrl:getHeroWearDressBuff(hid)
	local dressID = self:getHeroDressSeting(hid)
	if not heroltCtrl:getDressBuff(tonumber(dressID)) then
		local heroltCtrl, buffList = heroltCtrl:getDressBuff(tonumber(dressID)), heroltCtrl:getDressBuff(tonumber(dressID))
	end
	return buffList
end
function heroCtrl:getTheActiveBuff(buffID)
	local buffList = self:getAllActiveBuff()
	for k, v in ipairs(buffList) do
		if v.id == buffID then
			return v.value
		end
	end
	return 0
end
function heroCtrl:getDressAdd(hid)
	local add = 0
	for k, v in pairs(self.heroListInfo) do
		if v.heroID == hid and v.dress and v.dress.list and v.state ~= gHeroState.HERO_STATE_DEAD and v.state ~= gHeroState.HERO_STATE_CAPTURED then
			for dressID, var in pairs(v.dress.list) do
				local ownBuff = heroltCtrl:getOwnBuff(tonumber(dressID))
				if next(ownBuff) then
					for ki, vi in ipairs(ownBuff) do
						if gBuffEffect.MARCH_VALUE_LIMIT_BOOST == vi.id then
							add = add + vi.value
						end
					end
				end
			end
		end
	end
	return add
end
function heroCtrl:getAllActiveBuff()
	local _ENV, buffList
	for k, v in pairs(self.heroListInfo) do
		if v.dress and v.dress.list and v.state ~= gHeroState.HERO_STATE_DEAD and v.state ~= gHeroState.HERO_STATE_CAPTURED then
			for dressID, var in pairs(v.dress.list) do
				local ownBuff = heroltCtrl:getOwnBuff(tonumber(dressID))
				if next(ownBuff) then
					for ki, vi in ipairs(ownBuff) do
						if buffList[vi.id] then
							buffList[vi.id].val = buffList[vi.id].val + vi.value
							buffList[vi.id].heroID = v.heroID
							buffList[vi.id].dressID = dressID
						else
							buffList[vi.id], _ENV = v.heroID, v.heroID
							buffList[vi.id].val = vi.value
							buffList[vi.id].heroID = v.heroID
							buffList[vi.id].dressID = dressID
						end
					end
				end
			end
		end
	end
	local _ENV, result = (for generator), pairs(self.heroListInfo)
	local index = 1
	for k, v in pairs(buffList) do
		_ENV = nil
		;(nil).index = index
		;(nil).id = k
		;(nil).value = v.val
		;(nil).heroID = v.heroID
		;(nil).dressID = tonumber(v.dressID)
		table.insert(result, nil)
		index = index + 1
	end
	table.sort(result, function(a, b)
		return a.id < b.id
	end)
	return result, #result
end
function heroCtrl:getAllOwnBuff()
	local heroltCtrl, buffList
	local ownNum = 0
	local allGetBuffList = heroltCtrl:getAllGetDressBuff()
	for k, v in ipairs(allGetBuffList) do
		local hInfo = self.heroListInfo[tostring(v.heroID)]
		v.isActive = false
		if hInfo and hInfo.dress.list[tostring(v.dressID)] then
			v.isActive = true
		end
		v.index = k
		table.insert(buffList, v)
		ownNum = ownNum + 1
	end
	table.sort(buffList, function(a, b)
		if a.isActive and b.isActive then
			return a.id < b.id
		elseif a.isActive and not b.isActive then
			return true
		elseif not a.isActive and b.isActive then
			return false
		else
			return a.id < b.id
		end
	end)
	return buffList, ownNum
end
function heroCtrl:getUpgradeQueue(hid)
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local queue = queueCtrl:queryQueue(gQueueTypeDef.hero_upgrade)
	if queue then
		if not hid then
			return queue.data.heroID, queue.data.upgradeType
		elseif queue.data.heroID == hid then
			return queue
		end
	end
end
function heroCtrl:getMaxBattleHeroNum()
	local totalNum = 0
	local mainCityFunctions = include("mainCityFunctions")
	local constantRead = include("constantRead")
	for i = 1, 5 do
		local lv = constantRead.getConstValue(string.format("HIRED_HEROES_%d_LV", i), 1)
		if lv <= mainCityFunctions:getCastleLv() then
			totalNum = totalNum + 1
		end
	end
	return totalNum
end
function heroCtrl:getHeroMarchAddNum(hid)
	local _marchAdd = 0
	local hInfo = self.heroListInfo[tostring(hid)]
	if hInfo then
		_marchAdd = heroltCtrl:getHeroLevelInfo(hid, hInfo.level).march_add
	end
	return _marchAdd
end
function heroCtrl:getHeroTotalMarchAddNum(hid)
	local _marchAdd = 0
	local hInfo = self.heroListInfo[tostring(hid)]
	if hInfo then
		_marchAdd = heroltCtrl:getHeroLevelInfo(hid, hInfo.level).march_add
	end
	local _ENV, retTab = heroltCtrl:getHeroLevelInfo(hid, hInfo.level), heroltCtrl:getHeroLevelInfo(hid, hInfo.level)
	if hInfo then
		retTab = self:getBuffList(retTab, hInfo, nil, true)
	end
	if retTab[gBuffEffect.MARCH_VALUE_LIMIT_BOOST] then
		_marchAdd = _marchAdd + retTab[gBuffEffect.MARCH_VALUE_LIMIT_BOOST]
	end
	return _marchAdd
end
function heroCtrl:getSomeHeroMarchAddNum(heros)
	local ret = 0
	for _, v in pairs(heros) do
		ret = ret + self:getHeroMarchAddNum(v)
	end
	return ret
end
function heroCtrl:isDefendEmptySite()
	local defendNum = table.nums(self.defendList)
	local siteNum = self:getMaxBattleHeroNum()
	return defendNum < siteNum
end
function heroCtrl:judgeIsOverLordLevel(hid)
	local hInfo = self.heroListInfo[tostring(hid)]
	if hInfo then
		local limitLv = heroltCtrl.getLimitHeroLv(hInfo.isAwake)
		return limitLv <= hInfo.level
	end
end
function heroCtrl:judgeIsOverLordLevelWithExp(hid, exp)
	exp = exp or 0
	local hInfo = self.heroListInfo[tostring(hid)]
	if hInfo then
		local limitLv = heroltCtrl.getLimitHeroLv(hInfo.isAwake)
		if hInfo.level == limitLv - 1 then
			local judgeExp = hInfo.level_exp + exp
			local levelExp = heroltCtrl:getHeroLevelInfo(hid, hInfo.level).exp
			return judgeExp > levelExp
		end
	end
end
function heroCtrl:getShareCDTime(...)
	local ret = 0
	local queue = self:queryQueue(QUEUE_KEY_HERO_INITIATIVE_SHARE)
	if queue then
		ret = queue.timerNode.timer:getRemainTime()
	end
	return ret
end
function heroCtrl:ctor(properties)
	heroCtrl.super.ctor(self, properties)
	self:resetData()
end
function heroCtrl:EnterGame()
	heroCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_INITDATA, handler(self, self.initRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_RECRUIT, handler(self, self.recruitRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_UPGRADE_HERO, handler(self, self.upgradeHeroRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_FEED_HERO, handler(self, self.feedHeroRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_SET_DEFEND_HERO, handler(self, self.setDefendHeroRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_RESURGENCE, handler(self, self.resurgenceHeroRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_SET_HERO_LIST_DEFEND, handler(self, self.setDefendListRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_SHARE, handler(self, self.queryShareRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_REMAKE_POWER_SKILL, handler(self, self.remakeSkillRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_SAVE_PWER_SKILL, handler(self, self.saveSkillRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_CANCEL_PWER_SKILL, handler(self, self.cancelSkillRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_EXCHANGE_CHIPS, handler(self, self.chipsExchangeRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_FEED_HERO_MASTERY, handler(self, self.feedHeroMasteryRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_DRESS_ACTIVE, handler(self, self.dressActiveRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_DRESS_WEAR, handler(self, self.dressWearRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_WEAPON_WEAR, handler(self, self.weaponWearRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_WEAPON_TAKE_OFF, handler(self, self.weaponTakeOffRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_RESHAPE, handler(self, self.reshapeRsp))
	msgCtrl.register(gCmd.CMD_HERO_SYS_MODULE, gCmd.REQ_HERO_SYS_EXCHANGE_BATCH, handler(self, self.reExchangeBatchRsp))
end
function heroCtrl:registerNotify(...)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HERO_SYS, handler(self, self.noitfyDataRsp))
end
function heroCtrl:noitfyDataRsp(content)
	local loopData = content.data
	for i, notifyMsg in ipairs(loopData) do
		local revcDataType = notifyMsg.type
		local revcData = notifyMsg.data
		if revcData and next(revcData) then
			if revcData.updateHeroInfo then
				local _ENV, changeHeroIDs = revcData.updateHeroInfo, revcData.updateHeroInfo
				for i, v in ipairs(revcData.updateHeroInfo) do
					local hid = v.heroID
					self.heroListInfo[tostring(hid)] = v
					changeHeroIDs[tostring(hid)] = true
				end
				if revcDataType == "heroUpgradeSuccess" or revcDataType == "heroAwakeSuccess" then
					local heroID = revcData.updateHeroInfo[1].heroID
					local queueCtrl = gametop.playertop_:getModule("queueCtrl")
					local queueObj = self:getUpgradeQueue()
					if queueObj and queueObj == heroID then
						queueCtrl:removeQueue(gQueueTypeDef.hero_upgrade)
					end
					local quality = revcData.updateHeroInfo[1].quality
					local qualityDes = heroltCtrl.getQuality2Des(quality)
					local heroName = i18n(heroltCtrl.getHeroInfo(heroID).herName)
					if revcDataType == "heroUpgradeSuccess" then
						_ENV = nil
						;(nil).hero = heroName
						;(nil).color = qualityDes
						SoraDShowMsgTip(i18n("hero_text_73", nil))
					else
						SoraDShowMsgTip(i18n("heroskill_text_13"))
					end
				end
				_ENV = gametop.playertop_:getModule("queueCtrl")
				gametop.playertop_:getModule("queueCtrl").msg = "MESSAGE_SERVER_HERO_NOTICEHERO"
				gametop.playertop_:getModule("queueCtrl").noticeType = revcDataType
				gametop.playertop_:getModule("queueCtrl").affectHeros = changeHeroIDs
				SoraDSendMessage((gametop.playertop_:getModule("queueCtrl")))
				_ENV = gametop.playertop_:getModule("queueCtrl")
				gametop.playertop_:getModule("queueCtrl").msg = "MESSAGE_GREEN_POINT_UPDATE"
				gametop.playertop_:getModule("queueCtrl").type = GREEN_POINT_NOTICE_TYPE.HERO
				SoraDSendMessage((gametop.playertop_:getModule("queueCtrl")))
			end
			if revcData.defendList then
				self.defendList = revcData.defendList
				_ENV = SoraDSendMessage
				SoraDSendMessage.msg = "MESSAGE_SERVER_HERO_NOTICEDEFEND"
				SoraDSendMessage.noticeType = revcDataType
				SoraDSendMessage(SoraDSendMessage)
			end
		end
		if revcDataType == "Logout" then
			print("heroCtrl:noitfyDataRsp userSDKManager_sdkOpenCallBack")
			userSDKManager_sdkOpenCallBack()
		end
		if revcDataType == "heroDress" then
			for ki, vi in ipairs(revcData.updateHeroInfo) do
				self.heroListInfo[tostring(vi.heroID)] = vi
			end
			_ENV = ipairs(revcData.updateHeroInfo)
			ipairs(revcData.updateHeroInfo).msg = "MESSAGE_SERVER_HERO_DRESS_UPDATE"
			SoraDSendMessage(ipairs(revcData.updateHeroInfo))
		end
		if revcDataType == "statusChange" then
			local heroID
			for ki, vi in ipairs(revcData.updateHeroInfo) do
				self.heroListInfo[tostring(vi.heroID)] = vi
				heroID = vi.heroID
			end
			_ENV = ipairs(revcData.updateHeroInfo)
			ipairs(revcData.updateHeroInfo).msg = "MESSAGE_SERVER_HERO_STATE_UPDATE"
			ipairs(revcData.updateHeroInfo).heroID = heroID
			SoraDSendMessage(ipairs(revcData.updateHeroInfo))
		end
	end
end
function heroCtrl:resetData()
	self.queue, _UPVALUE0_, self.defendList, _UPVALUE0_, self.heroListInfo, _UPVALUE0_ = nil, nil, nil, nil, nil, nil
	self.shareCDtime = 0
	self.lastFreeReshapeTime = 0
end
function heroCtrl:Logout()
	heroCtrl.super.Logout(self)
	self:resetData()
end
function heroCtrl:initClientData(data)
	if nil == data then
		return
	end
	dump(data, "heroCtrl:initClientData", 10)
	self.heroListInfo = data.heroList
	dump(self.heroListInfo["1747"], "1747========", 10)
	for k, v in ipairs(gHeroTmpClose) do
		if self.heroListInfo[tostring(v)] then
			self.heroListInfo[tostring(v)] = nil
		end
	end
	for k, v in pairs(self.heroListInfo) do
		if self.heroListInfo[k] and not heroltCtrl:isHeroUnLock(tonumber(k)) then
			self.heroListInfo[k] = nil
		end
	end
	self.defendList = data.defendList
	for k, v in ipairs(gHeroTmpClose) do
		if self.defendList[tostring(v)] then
			self.defendList[tostring(v)] = nil
		end
	end
	for k, v in pairs(self.defendList) do
		if self.defendList[k] and not heroltCtrl:isHeroUnLock(tonumber(k)) then
			self.defendList[k] = nil
		end
	end
	self.shareCDtime = data.lastShareTime or 0
	local nowTime = serviceFunctions.systemTime()
	if nowTime < self.shareCDtime + HERO_SHARE_CD_TIME then
		local leftTime = self.shareCDtime + HERO_SHARE_CD_TIME - nowTime
		_ENV = tonumber(k)
		self:addHeroShareQueue(self.shareCDtime, HERO_SHARE_CD_TIME, leftTime, tonumber(k))
	end
	self.lastFreeReshapeTime = data.lastFreeReshapeTime or 0
	self:registerNotify()
	if self.heroListInfo and next(self.heroListInfo) then
		local guideCtrl = SoraDGetCtrl("guideCtrl")
		guideCtrl:CompleteGuideStep(nil, gGuideStep.HERO_UNLOCK_STEP_1)
	end
end
function heroCtrl:getRealMasterySKillID(heroLv, skillType)
	local level = heroLv
	local skillID = skillType * 1000 + level
	return skillID
end
function heroCtrl:getBuffValue(heroInfo, checkActiveType, buffEffect)
	local ret = 0
	if heroInfo.state ~= gHeroState.HERO_STATE_DEAD and heroInfo.state ~= gHeroState.HERO_STATE_CAPTURED then
		local skillAddition, awakeAddition, stuntAddition, masteryAddition = self:getHeroPalaceBuff(heroInfo.heroID)
		local skillList = heroInfo.skillList
		local quality = heroInfo.quality
		local getRealSkillID = function(skillType, quality)
			return skillType * 100 + quality
		end
		for _, skillInfo in pairs(skillList) do
			if skillInfo.isActive then
				local realSkillID = getRealSkillID(skillInfo.skillType, quality)
				local buffInfo = heroltCtrl:querySkillBuffInfo(realSkillID)
				if buffInfo and buffInfo.activeType == checkActiveType and buffInfo.buffType == buffEffect then
					ret = ret + buffInfo.buffValue * (1 + skillAddition / 1000)
				end
			end
		end
		if heroInfo.isAwake then
			local masterySKill = heroInfo.masterySkill
			if type(masterySKill) == "table" then
				for k, v in pairs(masterySKill) do
					local skillType = tonumber(k)
					local skillID = self:getRealMasterySKillID(heroInfo.level, skillType)
					local skillData = heroltCtrl:queryMasterySkillByID(skillID)
					if skillData then
						if not skillData.buffList then
							_ENV = skillData.buffList
						end
						for sKey, sValue in pairs(skillData.buffList) do
							if sValue.activeType == checkActiveType and tonumber(sValue.buffType) == tonumber(buffEffect) then
								local buffType = sValue.buffType
								local buffMode = sValue.buffMode
								local buffValue = buffMode == 2 and sValue.buffValue or sValue.buffValue / 10
								ret = ret + buffValue * (1 + awakeAddition / 1000)
							end
						end
					end
				end
			end
			local powerSkill = heroInfo.powerSkill
			if type(powerSkill) == "table" then
				for k, v in pairs(powerSkill) do
					local skillID = v.skillID
					local skillData = heroltCtrl:queryPowerSkillByID(skillID)
					if skillData.activeType == checkActiveType and tonumber(skillData.buffData.buffType) == tonumber(buffEffect) then
						local buffType = skillData.buffData.buffType
						local buffMode = skillData.buffData.buffMode
						local buffValue = v.buffValue
						ret = ret + buffValue * (1 + stuntAddition / 1000)
					end
				end
			end
		end
		if heroInfo.advancedSkill and next(heroInfo.advancedSkill) then
			local mskillInfo = heroltCtrl:getMasterySkillInfo(heroInfo.advancedSkill.skillID)
			if mskillInfo then
				for k, v in ipairs(mskillInfo.buffType) do
					if tonumber(v) == tonumber(buffEffect) and mskillInfo.activeType[k] == checkActiveType then
						local buffMode = mskillInfo.buffMode[k]
						local buffValue = buffMode == 2 and mskillInfo.buffValue[k] or mskillInfo.buffValue[k]
						ret = ret + buffValue * (1 + masteryAddition / 1000)
					end
				end
			end
		end
		local dressBuff = self:getHeroActiveBuff(heroInfo.heroID)
		for k, v in ipairs(dressBuff) do
			if buffEffect == v.id then
				ret = ret + v.value
			end
		end
	end
	return ret
end
function heroCtrl:getBuffList(retTab, heroInfo, checkActiveType, bAllBuff)
	local buffDesRead = include("buffDesRead")
	if not retTab then
		retTab, _ENV = "buffDesRead", "buffDesRead"
	end
	if heroInfo.state ~= gHeroState.HERO_STATE_DEAD and heroInfo.state ~= gHeroState.HERO_STATE_CAPTURED then
		local skillList = heroInfo.skillList
		local quality = heroInfo.quality
		local getRealSkillID = function(skillType, quality)
			return skillType * 100 + quality
		end
		local skillAddition, awakeAddition, stuntAddition, masteryAddition = self:getHeroPalaceBuff(heroInfo.heroID)
		for _, skillInfo in pairs(skillList) do
			if skillInfo.isActive then
				local realSkillID = getRealSkillID(skillInfo.skillType, quality)
				local buffInfo = heroltCtrl:querySkillBuffInfo(realSkillID)
				if buffInfo and (buffInfo.activeType == checkActiveType or bAllBuff) then
					if retTab[buffInfo.buffType] then
						retTab[buffInfo.buffType] = retTab[buffInfo.buffType] + buffInfo.buffValue * (1 + skillAddition / 1000)
					else
						retTab[buffInfo.buffType] = buffInfo.buffValue * (1 + skillAddition / 1000)
					end
				end
			end
		end
		if heroInfo.isAwake then
			local masterySKill = heroInfo.masterySkill
			if type(masterySKill) == "table" then
				for k, v in pairs(masterySKill) do
					local skillType = tonumber(k)
					local skillID = self:getRealMasterySKillID(heroInfo.level, skillType)
					local skillData = heroltCtrl:queryMasterySkillByID(skillID)
					if skillData then
						for sKey, sValue in pairs(skillData.buffList) do
							if sValue.activeType == checkActiveType or sValue.activeType == gSkillActiveType.PASSIVE_SKILL or bAllBuff then
								local buffType = sValue.buffType
								local buffMode = sValue.buffMode
								local buffValue = sValue.buffValue / 10
								local effectType = buffDesRead.getEffectType(buffType)
								if effectType == 5 or include("buffLogic").isNeedThousand(buffType) then
									buffValue = sValue.buffValue / 1000
								end
								if retTab[buffType] then
									retTab[buffType] = retTab[buffType] + buffValue * (1 + awakeAddition / 1000)
								else
									retTab[buffType] = buffValue * (1 + awakeAddition / 1000)
								end
								if heroInfo.heroID == 1722 and buffType == 422 then
									retTab[buffType] = nil
								end
								if heroInfo.heroID == 1723 and buffType == 481 then
									retTab[buffType] = nil
								end
							end
						end
					end
				end
			end
			local powerSkill = heroInfo.powerSkill
			if type(powerSkill) == "table" then
				for k, v in pairs(powerSkill) do
					local skillID = v.skillID
					local skillData = heroltCtrl:queryPowerSkillByID(skillID)
					if skillData.activeType == checkActiveType or bAllBuff then
						local buffType = skillData.buffData.buffType
						local buffMode = skillData.buffData.buffMode
						local buffValue = v.buffValue
						if retTab[buffType] then
							retTab[buffType] = retTab[buffType] + buffValue * (1 + stuntAddition / 1000)
						else
							retTab[buffType] = buffValue * (1 + stuntAddition / 1000)
						end
					end
				end
			end
		end
		if heroInfo.advancedSkill and next(heroInfo.advancedSkill) then
			local mskillInfo = heroltCtrl:getMasterySkillInfo(heroInfo.advancedSkill.skillID)
			if mskillInfo then
				local buffLogic = include("buffLogic")
				for k, v in ipairs(mskillInfo.buffType) do
					local buffValue = mskillInfo.buffValue[k]
					local model = mskillInfo.buffMode[k]
					buffValue = model == 2 and buffLogic.isNeedThousand(v) and buffValue / 1000 or buffValue
					if retTab[v] then
						retTab[v] = retTab[v] + buffValue * (1 + masteryAddition / 1000)
					else
						retTab[v] = buffValue * (1 + masteryAddition / 1000)
					end
				end
			end
		end
		local dressBuff = self:getHeroActiveBuff(heroInfo.heroID)
		for k, v in ipairs(dressBuff) do
			if retTab[v.id] then
				retTab[v.id] = retTab[v.id] + v.value
			else
				retTab[v.id] = v.value
			end
		end
		local wearDressBuff = self:getHeroWearDressBuff(heroInfo.heroID)
		for _, v in ipairs(wearDressBuff) do
			if retTab[v.id] then
				retTab[v.id] = retTab[v.id] + v.value
			else
				retTab[v.id] = v.value
			end
		end
	end
	return retTab
end
function heroCtrl:getLieutenantBuffList(retTab, heroInfo, checkActiveType, bAllBuff, mainHeroID)
	if not retTab then
		retTab, _ENV = nil, nil
	end
	if heroInfo.state ~= gHeroState.HERO_STATE_DEAD and heroInfo.state ~= gHeroState.HERO_STATE_CAPTURED then
		local quality = heroInfo.quality
		local level = heroInfo.level
		local inheriAttr = heroltCtrl:getInheriAttrByLevel(level)
		local rarity = mainHeroID and heroltCtrl:getHeroRarity(mainHeroID)
		local specialSuntAdd = 0
		local specialAwakeAdd = 0
		if rarity and rarity >= gHeroRarity.ORANGE then
			specialSuntAdd = inheriAttr.stuntAttrAdd
			specialAwakeAdd = inheriAttr.awakeAttrAdd
		end
		local skillAddition, awakeAddition, stuntAddition, masteryAddition = self:getHeroPalaceBuff(heroInfo.heroID)
		if heroInfo.isAwake then
			local powerSkill = heroInfo.powerSkill
			if type(powerSkill) == "table" then
				for k, v in pairs(powerSkill) do
					local skillID = v.skillID
					local skillData = heroltCtrl:queryPowerSkillByID(skillID)
					if skillData.activeType == checkActiveType or bAllBuff then
						local buffType = skillData.buffData.buffType
						local buffMode = skillData.buffData.buffMode
						local buffValue = v.buffValue
						if inheriAttr and inheriAttr.stuntAttr then
							buffValue = buffValue * ((inheriAttr.stuntAttr + specialSuntAdd) / 10000)
						end
						if retTab[buffType] then
							retTab[buffType] = retTab[buffType] + buffValue * (1 + stuntAddition / 1000)
						else
							retTab[buffType] = buffValue * (1 + stuntAddition / 1000)
						end
					end
				end
			end
		end
		if heroInfo.advancedSkill and next(heroInfo.advancedSkill) then
			local mskillInfo = heroltCtrl:getMasterySkillInfo(heroInfo.advancedSkill.skillID)
			if mskillInfo then
				for k, v in ipairs(mskillInfo.buffType) do
					local buffValue = mskillInfo.buffValue[k]
					buffValue = mskillInfo.buffMode[k] == 2 and include("buffLogic").isNeedThousand(v) and buffValue / 1000 or buffValue
					if inheriAttr and inheriAttr.awakeAttr then
						buffValue = buffValue * ((inheriAttr.awakeAttr + specialAwakeAdd) / 10000)
					end
					if mskillInfo.buffMode[k] == 2 then
						retTab[v] = (retTab[v] or 0) + math.floor(buffValue * (1 + masteryAddition / 1000))
					else
						retTab[v] = (retTab[v] or 0) + buffValue * (1 + masteryAddition / 1000)
					end
				end
			end
		end
		local dressBuff = self:getHeroActiveBuff(heroInfo.heroID)
		for k, v in ipairs(dressBuff) do
			if retTab[v.id] then
				retTab[v.id] = retTab[v.id] + v.value
			else
				retTab[v.id] = v.value
			end
		end
	end
	return retTab
end
function heroCtrl:getHeroTotalPassiveBuff(buffEffect)
	local getRealSkillID = function(skillType, quality)
		return skillType * 100 + quality
	end
	local ret = 0
	if type(self.heroListInfo) == "table" then
		for k, v in pairs(self.heroListInfo) do
			if v.state ~= gHeroState.HERO_STATE_DEAD and v.state ~= gHeroState.HERO_STATE_CAPTURED then
				if v.buffCache and v.buffCache[buffEffect] then
					ret = ret + v.buffCache[buffEffect]
				else
					local value = self:getBuffValue(v, gSkillActiveType.PASSIVE_SKILL, buffEffect) or 0
					ret = ret + value
					if not v.buffCache then
						v.buffCache, _ENV = v.buffCache, v.buffCache
					end
					v.buffCache[buffEffect] = value
				end
			end
		end
	end
	local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
	local jailBuffValue = heroJailCtrl:getPrisonBuff(buffEffect) or 0
	ret = ret + jailBuffValue
	return ret
end
function heroCtrl:getHeroPower(heroID)
	local heroInfo = self.heroListInfo[tostring(heroID)]
	if heroInfo then
		local power = 0
		local heroBasePower = heroltCtrl:getHeroPower(heroID, heroInfo.level, heroInfo.quality)
		power = power + heroBasePower
		if heroInfo.isAwake then
			local awakePower = heroltCtrl:getHeroAwakePower(heroID)
			power = power + awakePower
			power = power + self:getMasteryPower(heroInfo)
			power = power + self:getPowerSkillPower(heroInfo)
		end
		if heroInfo.weaponUid and 0 < heroInfo.weaponUid then
			local heroWeaponRead = include("heroWeaponRead")
			local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
			local weapon = heroWeaponCtrl:getWeaponByUid(heroInfo.weaponUid)
			if weapon then
				power = power + heroWeaponRead.getWeaponPower(weapon)
			end
		end
		return power
	else
		return 0
	end
end
function heroCtrl:getMasteryPower(heroInfo)
	local ret = 0
	if heroInfo.isAwake then
		for k, v in pairs(heroInfo.masterySkill) do
			local skillType = tonumber(k)
			local skillID = self:getRealMasterySKillID(heroInfo.level, skillType)
			local skillData = heroltCtrl:queryMasterySkillByID(skillID)
			local power = skillData.Power or 0
			ret = ret + power
		end
	end
	return ret
end
function heroCtrl:getPowerSkillPower(heroInfo)
	local ret = 0
	if heroInfo.isAwake then
		for k, v in pairs(heroInfo.powerSkill) do
			local skillID = v.skillID
			local curPower = heroltCtrl:getCurPower(skillID, v.buffValue) or 0
			ret = ret + curPower
		end
	end
	return ret
end
function heroCtrl:getHeroHuntingRate(heroID)
	return math.floor(math.min(1 + self:getHeroPower(heroID) / 144000 * 0.5, 1.5) * 100) / 100
end
function heroCtrl:getHeroAdvancedSkillInfo(heroID)
	local info = self:getHeroInfoByID(heroID)
	return info.advancedSkill
end
function heroCtrl:getHeroTacticsStatus(heroID)
	local heroTactics = heroltCtrl:getTacticsByHeroID(heroID)
	if #heroTactics == 0 then
		return nil
	end
	local heroltCtrl, tacticsHeroDatas
	for k, v in pairs(heroTactics) do
		local heroltCtrl, tacticHeros
		for k2, v2 in pairs(v.heroGroupID) do
			local heroltCtrl, hero
			hero.heroID = v2
			local heroInfo = self:getHeroInfoByID(v2)
			hero.isUnlock = heroInfo ~= nil
			hero.isActive = heroInfo and heroInfo.isAwake
			table.insert(tacticHeros, hero)
		end
		table.insert(tacticsHeroDatas, tacticHeros)
	end
	return tacticsHeroDatas, heroTactics
end
function heroCtrl:getHeroUpgradeTimer()
	return self.queue[HERO_UPGRADE_QUEUE]
end
function heroCtrl:addHeroShareQueue(starttime, totaltime, lefttime, data)
	self:addQueue(QUEUE_KEY_HERO_INITIATIVE_SHARE, starttime, totaltime, lefttime, data)
end
function heroCtrl:addQueue(queuetype, starttime, totaltime, lefttime, data)
	local queuetype = tostring(queuetype)
	local curqueue = self:queryQueue(queuetype)
	if curqueue then
		self:removeQueue(queuetype)
	end
	local dispatchQueueEvent = function()
		queuetype = nil
		;(nil).name = queuetype
		local (nil).data, event = data, nil
		self:dispatchEvent(event)
		self.queue[queuetype] = nil
	end
	local _ENV, queue = self, self
	queue.qtype = queuetype
	queue.starttime = starttime
	queue.totaltime = totaltime
	local ok, node = timerList:createTimer(lefttime, timerHandler(dispatchQueueEvent))
	if ok then
		queue.timerNode = node
		self.queue[queuetype] = queue
	end
end
function heroCtrl:removeQueue(queuetype)
	local queuetype = tostring(queuetype)
	local queue = self:queryQueue(queuetype)
	if queue then
		timerList:cancelTimer(queue.timerNode)
		self.queue[queuetype] = nil
	end
end
function heroCtrl:queryQueue(queuetype)
	local ret = self.queue[tostring(queuetype)]
	if ret then
		return ret
	end
end
function heroCtrl:getHeroUSkillActive()
	local _ENV, ret
	local heros = self:getHaveHerosList()
	for _, v in ipairs(heros) do
		local heroInfo = self:getHeroInfoByID(tonumber(v))
		if not heroltCtrl:getAwakeLvSkillData(tonumber(v), heroInfo.level) then
			local _ENV, skillMap = heroltCtrl:getAwakeLvSkillData(tonumber(v), heroInfo.level), heroltCtrl:getAwakeLvSkillData(tonumber(v), heroInfo.level)
		end
		if not skillMap.activeType then
			_ENV = skillMap.activeType
		end
		for k, aType in ipairs(skillMap.activeType) do
			if aType == 1 then
				local skillAddition, awakeAddition, stuntAddition, masteryAddition = self:getHeroPalaceBuff(tonumber(v))
				ret[skillMap.buffType[k]] = (ret[skillMap.buffType[k]] or 0) + skillMap.buffValue[k] * (1 + skillAddition / 1000)
			end
		end
	end
	return ret
end
function heroCtrl:getHeroUSkillDes(heroID, awakeAddition)
	local buffDesRead = include("buffDesRead")
	local heroInfo = self:getHeroInfoByID(heroID)
	local skillID = heroltCtrl:getAwakeSkill(heroID).skillID
	local skillInfo = heroltCtrl.getSkillDesInfo(skillID)
	if not clone(heroltCtrl:getAwakeLvSkillData(heroID, heroInfo.level)) then
		local _ENV, skillMap = clone(heroltCtrl:getAwakeLvSkillData(heroID, heroInfo.level)), clone(heroltCtrl:getAwakeLvSkillData(heroID, heroInfo.level))
	end
	if not next(skillMap) then
		skillMap = heroltCtrl:getAwakeLvSkillData(heroID, gHeroMaxLevel)
	end
	if awakeAddition and 0 < awakeAddition then
		skillMap.buffValOri, _ENV = heroltCtrl:getAwakeLvSkillData(heroID, gHeroMaxLevel), heroltCtrl:getAwakeLvSkillData(heroID, gHeroMaxLevel)
		for k, v in ipairs(skillMap.buffValue) do
			skillMap.buffValOri[k] = skillMap.buffValue[k]
			if not heroltCtrl:isScreenBuff(skillMap.buffType[k]) then
				skillMap.buffValue[k] = math.floor(skillMap.buffValue[k] * (1 + awakeAddition / 1000))
			end
		end
	end
	local desStr = ""
	dump(skillMap, "skillMap========" .. heroID)
	dump(skillInfo, "skillInfo========" .. heroID)
	local getShowVal = function(index, isAddP, isNum)
		local val = skillMap.buffValue[index]
		local effectType = buffDesRead.getEffectType(skillMap.buffType[index])
		if awakeAddition and 0 < awakeAddition then
			if isNum then
				local des = val
				local oriVal = skillMap.buffValOri[index]
				local oriStr = oriVal
				local palaceStr = val - oriVal
				if effectType == 5 then
					des = des / 1000
					oriStr = oriStr / 1000
					palaceStr = palaceStr / 1000
				end
				if 0 < palaceStr then
					skillMap = nil
					;(nil).des = des
					;(nil).ori = oriStr
					;(nil).add = palaceStr
					return i18n("%{des}(%{ori}+%{add})", nil)
				else
					return des
				end
			else
				local des = isAddP and SoraDPreciseDecimal(val / 100, 2) .. "%" or SoraDPreciseDecimal(val / 100, 2)
				local oriVal = skillMap.buffValOri[index]
				local oriStr = isAddP and SoraDPreciseDecimal(oriVal / 100, 2) .. "%" or SoraDPreciseDecimal(oriVal / 100, 2)
				local palaceStr = isAddP and SoraDPreciseDecimal((val - oriVal) / 100, 2) .. "%" or SoraDPreciseDecimal((val - oriVal) / 100, 2)
				skillMap = nil
				;(nil).des = des
				;(nil).ori = oriStr
				;(nil).add = palaceStr
				return i18n("%{des}(%{ori}+%{add})", nil)
			end
		elseif isNum then
			return effectType == 5 and val / 1000 or val
		else
			return isAddP and SoraDPreciseDecimal(val / 100, 4) .. "%" or SoraDPreciseDecimal(val / 100, 4)
		end
	end
	if heroID == 1716 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		_ENV = math.floor(skillMap.buffValue[k] * (1 + awakeAddition / 1000))
		math.floor(skillMap.buffValue[k] * (1 + awakeAddition / 1000)).num1 = val1
		math.floor(skillMap.buffValue[k] * (1 + awakeAddition / 1000)).num2 = val2
		desStr = i18n(skillInfo.des, (math.floor(skillMap.buffValue[k] * (1 + awakeAddition / 1000))))
	elseif heroID == 1719 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(2, true)
		local val3 = getShowVal(3, true)
		_ENV = skillMap.buffValue[k] * (1 + awakeAddition / 1000)
		;(skillMap.buffValue[k] * (1 + awakeAddition / 1000)).num1 = val3
		;(skillMap.buffValue[k] * (1 + awakeAddition / 1000)).num2 = val1
		;(skillMap.buffValue[k] * (1 + awakeAddition / 1000)).num3 = val2
		desStr = i18n(skillInfo.des, skillMap.buffValue[k] * (1 + awakeAddition / 1000))
	elseif heroID == 1722 then
		if not IsArClient then
			local val1 = getShowVal(1, true)
			_ENV = i18n(skillInfo.des, skillMap.buffValue[k] * (1 + awakeAddition / 1000))
			i18n(skillInfo.des, skillMap.buffValue[k] * (1 + awakeAddition / 1000)).num1 = val1
			desStr = i18n(skillInfo.des, (i18n(skillInfo.des, skillMap.buffValue[k] * (1 + awakeAddition / 1000))))
		else
			local val1 = getShowVal(1, true)
			local val2 = getShowVal(3, true)
			_ENV = skillInfo.des
			skillInfo.des.num1 = val1
			skillInfo.des.num2 = val2
			desStr = i18n(skillInfo.des, skillInfo.des)
		end
	elseif heroID == 1723 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		_ENV = skillInfo.des
		skillInfo.des.num1 = val1
		skillInfo.des.num2 = val2
		desStr = i18n(skillInfo.des, skillInfo.des)
	elseif heroID == 1724 then
		local val1 = getShowVal(1, false, true)
		local val2 = getShowVal(2, false, true)
		_ENV = true
		;(true).num1 = val1
		;(true).num2 = val2
		desStr = i18n(skillInfo.des, true)
	elseif heroID == 1726 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(2, true)
		_ENV = true
		;(true).num1 = val1
		;(true).num2 = val2
		desStr = i18n(skillInfo.des, true)
	elseif heroID == 1727 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		local val3 = getShowVal(3, true)
		_ENV = skillMap.buffValue[k] * (1 + awakeAddition / 1000)
		;(skillMap.buffValue[k] * (1 + awakeAddition / 1000)).num1 = val1
		;(skillMap.buffValue[k] * (1 + awakeAddition / 1000)).num2 = val2
		;(skillMap.buffValue[k] * (1 + awakeAddition / 1000)).num3 = val3
		desStr = i18n(skillInfo.des, skillMap.buffValue[k] * (1 + awakeAddition / 1000))
	elseif heroID == 1728 then
		local val1 = getShowVal(2, true)
		local val2 = skillMap.num1 .. "%"
		_ENV = skillInfo.des
		skillInfo.des.var1 = val1
		skillInfo.des.var2 = val2
		desStr = i18n(skillInfo.des, skillInfo.des)
	elseif heroID == 1729 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		local val3 = getShowVal(5, true)
		_ENV = skillMap.buffValue[k] * (1 + awakeAddition / 1000)
		;(skillMap.buffValue[k] * (1 + awakeAddition / 1000)).num1 = val1
		;(skillMap.buffValue[k] * (1 + awakeAddition / 1000)).num2 = val2
		;(skillMap.buffValue[k] * (1 + awakeAddition / 1000)).num3 = val3
		desStr = i18n(skillInfo.des, skillMap.buffValue[k] * (1 + awakeAddition / 1000))
	elseif heroID == 1730 then
		local val1 = skillMap.buffValue[1]
		local val2 = getShowVal(2, true)
		_ENV = skillInfo.des
		skillInfo.des.num1 = val1
		skillInfo.des.num2 = val2
		desStr = i18n(skillInfo.des, skillInfo.des)
	elseif heroID == 1731 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(2, true)
		local val3 = getShowVal(3, true)
		local val4 = getShowVal(4, true)
		_ENV = 1 + awakeAddition / 1000
		;(1 + awakeAddition / 1000).num1 = val1
		;(1 + awakeAddition / 1000).num2 = val2
		;(1 + awakeAddition / 1000).num3 = val3
		;(1 + awakeAddition / 1000).num4 = val4
		desStr = i18n(skillInfo.des, 1 + awakeAddition / 1000)
	elseif heroID == 1733 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(2, true)
		_ENV = i18n(skillInfo.des, 1 + awakeAddition / 1000)
		i18n(skillInfo.des, 1 + awakeAddition / 1000).num1 = val1
		i18n(skillInfo.des, 1 + awakeAddition / 1000).num2 = val2
		i18n(skillInfo.des, 1 + awakeAddition / 1000).add = skillMap.num
		desStr = i18n(skillInfo.des, (i18n(skillInfo.des, 1 + awakeAddition / 1000)))
	elseif heroID == 1734 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(2, true)
		local val3 = getShowVal(3, true)
		_ENV = skillMap.num
		skillMap.num.num1 = val1
		skillMap.num.num2 = val2
		skillMap.num.num3 = val3
		desStr = i18n(skillInfo.des, skillMap.num)
	elseif heroID == 1735 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(2, true)
		_ENV = skillInfo.des
		skillInfo.des.num1 = val1
		skillInfo.des.num2 = val2
		desStr = i18n(skillInfo.des, skillInfo.des)
	elseif heroID == 1736 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		_ENV = skillInfo.des
		skillInfo.des.num1 = val1
		skillInfo.des.num2 = val2
		desStr = i18n(skillInfo.des, skillInfo.des)
	elseif heroID == 1737 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(2, true)
		local val3 = getShowVal(5, true)
		_ENV = skillMap.num
		skillMap.num.num1 = val1
		skillMap.num.num2 = val2
		skillMap.num.num3 = val3
		desStr = i18n(skillInfo.des, skillMap.num)
	elseif heroID == 1738 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		_ENV = skillInfo.des
		skillInfo.des.num1 = val1
		skillInfo.des.num2 = val2
		desStr = i18n(skillInfo.des, skillInfo.des)
	elseif heroID == 1739 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		_ENV = skillInfo.des
		skillInfo.des.num1 = val1
		skillInfo.des.num2 = val2
		desStr = i18n(skillInfo.des, skillInfo.des)
	elseif heroID == 1740 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(2, true)
		local val3 = getShowVal(3, true)
		_ENV = skillMap.num
		skillMap.num.num1 = val1
		skillMap.num.num2 = val2
		skillMap.num.num3 = val3
		desStr = i18n(skillInfo.des, skillMap.num)
	elseif heroID == 1741 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		_ENV = skillInfo.des
		skillInfo.des.num1 = val1
		skillInfo.des.num2 = val2
		desStr = i18n(skillInfo.des, skillInfo.des)
	elseif heroID == 1742 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		local val3 = getShowVal(5, true)
		_ENV = skillMap.num
		skillMap.num.num1 = val1
		skillMap.num.num2 = val2
		skillMap.num.num3 = val3
		desStr = i18n(skillInfo.des, skillMap.num)
	elseif heroID == 1743 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		local val3 = getShowVal(5, true)
		_ENV = skillMap.num
		skillMap.num.num1 = val1
		skillMap.num.num2 = val2
		skillMap.num.num3 = val3
		desStr = i18n(skillInfo.des, skillMap.num)
	elseif heroID == 1744 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		_ENV = skillInfo.des
		skillInfo.des.num1 = val1
		skillInfo.des.num2 = val2
		desStr = i18n(skillInfo.des, skillInfo.des)
	elseif heroID == 1745 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		local val3 = getShowVal(5, true)
		_ENV = skillMap.num
		skillMap.num.num1 = val1
		skillMap.num.num2 = val2
		skillMap.num.num3 = val3
		desStr = i18n(skillInfo.des, skillMap.num)
	elseif heroID == 1746 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		local val3 = getShowVal(5, true)
		_ENV = skillMap.num
		skillMap.num.num1 = val1
		skillMap.num.num2 = val2
		skillMap.num.num3 = val3
		desStr = i18n(skillInfo.des, skillMap.num)
	elseif heroID == 1747 then
		local val0 = getShowVal(1, true)
		local val1 = getShowVal(4, true)
		local val2 = getShowVal(5, true)
		local val3 = getShowVal(6, true)
		_ENV = 1 + awakeAddition / 1000
		;(1 + awakeAddition / 1000).num4 = val0
		;(1 + awakeAddition / 1000).num1 = val1
		;(1 + awakeAddition / 1000).num2 = val2
		;(1 + awakeAddition / 1000).num3 = val3
		desStr = i18n(skillInfo.des, 1 + awakeAddition / 1000)
	elseif heroID == 1748 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		local val3 = getShowVal(5, true)
		local val4 = getShowVal(6, true)
		_ENV = 1 + awakeAddition / 1000
		;(1 + awakeAddition / 1000).num1 = val1
		;(1 + awakeAddition / 1000).num2 = val2
		;(1 + awakeAddition / 1000).num3 = val3
		;(1 + awakeAddition / 1000).num4 = val4
		desStr = i18n(skillInfo.des, 1 + awakeAddition / 1000)
	elseif heroID == 1749 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		local val3 = getShowVal(5, true)
		local val4 = getShowVal(6, true)
		_ENV = 1 + awakeAddition / 1000
		;(1 + awakeAddition / 1000).num1 = val1
		;(1 + awakeAddition / 1000).num2 = val2
		;(1 + awakeAddition / 1000).num3 = val3
		;(1 + awakeAddition / 1000).num4 = val4
		desStr = i18n(skillInfo.des, 1 + awakeAddition / 1000)
	elseif heroID == 1750 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		local val3 = getShowVal(5, true)
		local val4 = getShowVal(6, true)
		_ENV = 1 + awakeAddition / 1000
		;(1 + awakeAddition / 1000).num1 = val1
		;(1 + awakeAddition / 1000).num2 = val2
		;(1 + awakeAddition / 1000).num3 = val3
		;(1 + awakeAddition / 1000).num4 = val4
		desStr = i18n(skillInfo.des, 1 + awakeAddition / 1000)
	elseif heroID == 1751 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		local val3 = getShowVal(5, true)
		_ENV = skillInfo.des
		skillInfo.des.num1 = val1
		skillInfo.des.num2 = val2
		skillInfo.des.num3 = val3
		desStr = i18n(skillInfo.des, skillInfo.des)
	elseif heroID == 1752 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		local val3 = getShowVal(5, true)
		local val4 = getShowVal(6, true)
		_ENV = 1 + awakeAddition / 1000
		;(1 + awakeAddition / 1000).num1 = val1
		;(1 + awakeAddition / 1000).num2 = val2
		;(1 + awakeAddition / 1000).num3 = val3
		;(1 + awakeAddition / 1000).num4 = val4
		desStr = i18n(skillInfo.des, 1 + awakeAddition / 1000)
	elseif heroID == 1753 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		local val3 = getShowVal(5, false, true)
		local val4 = getShowVal(6, true)
		_ENV = 1 + awakeAddition / 1000
		;(1 + awakeAddition / 1000).num1 = val1
		;(1 + awakeAddition / 1000).num2 = val2
		;(1 + awakeAddition / 1000).num3 = val3
		;(1 + awakeAddition / 1000).num4 = val4
		desStr = i18n(skillInfo.des, 1 + awakeAddition / 1000)
	elseif heroID == 1754 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		local val3 = getShowVal(5, true)
		_ENV = skillInfo.des
		skillInfo.des.num1 = val1
		skillInfo.des.num2 = val2
		skillInfo.des.num3 = val3
		desStr = i18n(skillInfo.des, skillInfo.des)
	elseif heroID == 1755 or heroID == 1756 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		local val3 = getShowVal(5, true)
		local val4 = getShowVal(6, true)
		_ENV = 1 + awakeAddition / 1000
		;(1 + awakeAddition / 1000).num1 = val1
		;(1 + awakeAddition / 1000).num2 = val2
		;(1 + awakeAddition / 1000).num3 = val3
		;(1 + awakeAddition / 1000).num4 = val4
		desStr = i18n(skillInfo.des, 1 + awakeAddition / 1000)
	elseif heroID == 1757 then
		local val1 = getShowVal(1, true)
		local val2 = getShowVal(4, true)
		local val3 = getShowVal(5, true)
		local val4 = getShowVal(6, true)
		local val5 = getShowVal(7, true)
		_ENV = heroltCtrl:getAwakeLvSkillData(heroID, heroInfo.level)
		heroltCtrl:getAwakeLvSkillData(heroID, heroInfo.level).num1 = val1
		heroltCtrl:getAwakeLvSkillData(heroID, heroInfo.level).num2 = val2
		heroltCtrl:getAwakeLvSkillData(heroID, heroInfo.level).num3 = val3
		heroltCtrl:getAwakeLvSkillData(heroID, heroInfo.level).num4 = val4
		heroltCtrl:getAwakeLvSkillData(heroID, heroInfo.level).num5 = val5
		desStr = i18n(skillInfo.des, heroltCtrl:getAwakeLvSkillData(heroID, heroInfo.level))
	else
		local val = getShowVal(1, true)
		_ENV = getShowVal(6, true)
		getShowVal(6, true).num = val
		getShowVal(6, true).num1 = val
		getShowVal(6, true).var1 = val
		getShowVal(6, true).add = skillMap.num
		desStr = i18n(skillInfo.des, (getShowVal(6, true)))
	end
	return desStr
end
function heroCtrl:getComboSkillDes(skillID)
	local skillInfo = heroltCtrl:getCombosSkillInfo(skillID)
	local desStr = ""
	heroltCtrl = skillID
	local skillID.num, values = skillInfo.dailyNum, skillID
	for i, v in ipairs(skillInfo.buffValue) do
		values["num" .. i] = skillInfo.buffMode[i] == 1 and SoraDPreciseDecimal(v / 100, 4) .. "%" or v
	end
	desStr = i18n(skillInfo.skillText, values)
	return desStr
end
function heroCtrl:getLieutenantByHeroID(heroID)
	local dressID = self:getHeroDressSeting(heroID)
	if dressID then
		local lieutenantHeroID = heroltCtrl:getDressLieutenant(dressID)
		return lieutenantHeroID
	end
	return 0
end
function heroCtrl:isOwnLieutenantByHeroID(heroID)
	local dressID = self:getHeroDressSeting(heroID)
	if dressID then
		return not heroltCtrl:isDefaultDress(dressID)
	end
	return false
end
function heroCtrl:getHeroAndLieutenant(list)
