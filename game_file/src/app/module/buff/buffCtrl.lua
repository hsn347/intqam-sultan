local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local buffMgr = gModuleMgr.sharedMgr("buffMgr")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local itemLogic = include("itemLogic")
local msgCtrl = include("msgCtrl")
local equipmentAdditionMgr = include("equipmentAdditionMgr")
local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
local attributeSystem = include("attributeSystem")
local buffCtrl = class("buffCtrl", gameModule)
_UPVALUE28_ = "buffCtrl"
;("buffCtrl")[1] = gBuffSource.EQUIPMENT
;("buffCtrl")[2] = gBuffSource.MILITARY
;("buffCtrl")[3] = gBuffSource.PET
;("buffCtrl")[4] = gBuffSource.KINGDOM_LEVEL
;("buffCtrl")[5] = gBuffSource.WAR_GEM
;("buffCtrl")[6] = gBuffSource.PARLIAMENT
;("buffCtrl")[7] = gBuffSource.LEGEND_TITLE
;("buffCtrl")[8] = gBuffSource.HEGEMON_TITLE
;("buffCtrl")[9] = gBuffSource.ALLIANCE_OFFICIAL
;("buffCtrl")[10] = gBuffSource.ABEAST_BLESSING
;("buffCtrl")[11] = gBuffSource.HERO_CENOTAPH
;("buffCtrl")[12] = gBuffSource.HERO_SYSTEM
;("buffCtrl")[13] = gBuffSource.MIRACULOUS_WEAPON
;("buffCtrl")[14] = gBuffSource.BUILD_MASTERY
;("buffCtrl")[15] = gBuffSource.GUARD_ACTIVITY
;("buffCtrl")[16] = gBuffSource.BUILD_STAR
;("buffCtrl")[17] = gBuffSource.ALLIANCE_PROSPERITY
;("buffCtrl")[18] = gBuffSource.HERO_BIOGRAPHY
;("buffCtrl")[19] = gBuffSource.ANN20_CAMPFIRE
;("buffCtrl")[20] = gBuffSource.SULTAN_BACK_REBATE
;("buffCtrl")[21] = gBuffSource.KINGDOM_CHRONICLES
;("buffCtrl")[22] = gBuffSource.ATLANTIS_PRIVILEGE
;("buffCtrl")[23] = gBuffSource.NEBULA_PRIVILEGE
;("buffCtrl")[24] = gBuffSource.ATLANTIS_SKILL
;("buffCtrl")[25] = gBuffSource.ALLIANCE_STRONGHOLD
;("buffCtrl")[26] = gBuffSource.FOREIGN_PAVILION
;("buffCtrl")[27] = gBuffSource.ATLANTIS_WIN_SEASON
;("buffCtrl")[28] = gBuffSource.PALACE_OF_WISDOM_ACTIVITY
;("buffCtrl")[29] = gBuffSource.METEOR_MAGIC
;("buffCtrl")[30] = gBuffSource.NEBULA_WAR_FINISH_OCCUPY
;("buffCtrl")[31] = gBuffSource.NEBULA_TOWER
;("buffCtrl")[32] = gBuffSource.MAGIC_LAMP
;("buffCtrl")[33] = gBuffSource.EQUIP_RESONANCE
;("buffCtrl")[34] = gBuffSource.NEBULA_EMPEROR_TITLE
;("buffCtrl")[35] = gBuffSource.NEBULA_EMPEROR_WAR
;("buffCtrl")[36] = gBuffSource.DIVINE_BEAST
;("buffCtrl")[37] = gBuffSource.WAR_ORDER
;("buffCtrl")[38] = gBuffSource.WAR_HORN
;("buffCtrl")[39] = gBuffSource.NEBULA_ALLSTAR_WAR
;("buffCtrl")[40] = gBuffSource.HONOR_BACK_PRIVILEGES
;("buffCtrl")[41] = gBuffSource.GHOLD_EMERGENCE
;("buffCtrl")[42] = gBuffSource.HERO_APPOINT
;("buffCtrl")[43] = gBuffSource.ROARING_FLAME_WAR
;("buffCtrl")[44] = gBuffSource.GARDEN
local ("buffCtrl")[45], _sourceList = gBuffSource.NACKLACE_TEC, "buffCtrl"
local _ENV, RSP = gBuffSource.EQUIPMENT, gBuffSource.EQUIPMENT
function buffCtrl:ctor(properties)
	buffCtrl.super.ctor(self, properties)
	self:resetData()
end
function buffCtrl:resetData()
	self.buffMgr = nil
	self.buffMgr = buffMgr.new()
end
function buffCtrl:EnterGame()
	buffCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_BUFF_MODULE, gCmd.REQ_INIT_BUFFDATA, handler(self, RSP.initDataRsp))
	msgCtrl.register(gCmd.CMD_BUFF_MODULE, gCmd.REQ_RESTORE_CASTLE_DRESS, handler(self, RSP.restoreDressOfCastleRsp))
	msgCtrl.register(gCmd.CMD_BUFF_MODULE, gCmd.REQ_CLOSE_BUFF, handler(self, RSP.closeBuffRsp))
	msgCtrl.register(gCmd.CMD_BUFF_MODULE, gCmd.REQ_USE_VIRTUAL_BUFF, handler(self, RSP.useVirtualBuffRsp))
	msgCtrl.register(gCmd.CMD_BUFF_MODULE, gCmd.REQ_GET_LAST_VIRTUAL_BUFF, handler(self, RSP.getLastVirtualBuffRsp))
end
function buffCtrl:Logout()
	buffCtrl.super.Logout(self)
	self.handle_buff_notify = nil
	self:resetData()
end
function buffCtrl:queryCityBuff(effectType)
	return self.buffMgr:queryBuff(gBuffSource.CITY, effectType)
end
function buffCtrl:queryNewPlayerBuff(effectType)
	return self.buffMgr:queryBuff(gBuffSource.NEWBIE, effectType)
end
function buffCtrl:queryHalloweenBuff(effectType)
	return self.buffMgr:queryBuff(gBuffSource.HALLOWEEN, effectType)
end
function buffCtrl:getBuffEffect(effectType, source, noHero)
	if effectType == gBuffEffect.NULL then
		return nil
	end
	if source then
		return self:getBuffEffectFromSource(effectType, source, noHero)
	end
	local buffEffect = self.buffMgr:getBuffEffect(effectType, source)
	local totalEffect = buffEffect
	local achievementctrl = gametop.playertop_:getModule("achievementctrl")
	local achievementEffect = achievementctrl:getBuffValue(effectType)
	if achievementEffect then
		if not totalEffect then
			totalEffect = achievementEffect
		elseif gBuffEffect.MARCH_EFFECT ~= effectType and gBuffEffect.LORD_NAME_DRESS_UP ~= effectType then
			totalEffect = totalEffect + achievementEffect
		end
	end
	local activityBuffCtrl = gametop.playertop_:getModule("activityBuffCtrl")
	local activityEffect = activityBuffCtrl:getActivityBoost(effectType)
	if activityEffect then
		if not totalEffect then
			totalEffect = activityEffect
		else
			totalEffect = totalEffect + activityEffect
		end
	end
	local _ENV, buffList = activityBuffCtrl, activityBuffCtrl
	for __, effectSource in ipairs(_sourceList) do
		local effectValue = self:getBuffEffectFromSource(effectType, effectSource, noHero)
		if effectValue and effectValue ~= 0 then
			totalEffect = (totalEffect or 0) + effectValue
			if not buffList[effectSource] then
				buffList[effectSource], _ENV = buffList[effectSource], buffList[effectSource]
			end
			buffList[effectSource][effectType] = effectValue
		end
	end
	local _ENV, buffListLog = (for generator), ipairs(_sourceList)
	for source, tb in pairs(buffList) do
		for effectType, effect in pairs(tb) do
			_ENV = nil
			;(nil).source = source
			;(nil).effectType = effectType
			;(nil).effect = effect
			table.insert(buffListLog, nil)
		end
	end
	return totalEffect, buffListLog
end
buffCtrl.getBuffEffect = SoraDCacheByFrameTwo(buffCtrl.getBuffEffect)
function buffCtrl:getBuffEffectWithList(effectType, source, noHero)
	if effectType == gBuffEffect.NULL then
		return nil
	end
	if source then
		return self:getBuffEffectFromSource(effectType, source, noHero)
	end
	local buffEffect, bufflist = self.buffMgr:getBuffEffect(effectType, source)
	if not bufflist then
		bufflist, _ENV = effectType, effectType
	end
	local totalEffect = buffEffect
	local achievementctrl = gametop.playertop_:getModule("achievementctrl")
	local achievementEffect = achievementctrl:getBuffValue(effectType)
	if achievementEffect then
		if not totalEffect then
			totalEffect = achievementEffect
			_ENV = nil
			;(nil).effect = achievementEffect
			;(nil).effectType = effectType
			;(nil).source = gBuffSource.ACHIEVEMENT
			;(nil).beginTime = 0
			;(nil).time = 0
			;(nil).id = 0
			table.insert(bufflist, nil)
		elseif gBuffEffect.MARCH_EFFECT ~= effectType and gBuffEffect.LORD_NAME_DRESS_UP ~= effectType then
			totalEffect = totalEffect + achievementEffect
			_ENV = nil
			;(nil).effect = achievementEffect
			;(nil).effectType = effectType
			;(nil).source = gBuffSource.ACHIEVEMENT
			;(nil).beginTime = 0
			;(nil).time = 0
			;(nil).id = 0
			table.insert(bufflist, nil)
		end
	end
	local activityBuffCtrl = gametop.playertop_:getModule("activityBuffCtrl")
	local activityEffect, actlist = activityBuffCtrl:getActivityBoost(effectType)
	if activityEffect then
		if not totalEffect then
			totalEffect = activityEffect
		else
			totalEffect = totalEffect + activityEffect
		end
		for actID, v in pairs(actlist) do
			_ENV = nil
			;(nil).effect = v
			;(nil).effectType = effectType
			;(nil).source = gBuffSource.ACTIVITY
			;(nil).beginTime = 0
			;(nil).time = 0
			;(nil).id = actID
			table.insert(bufflist, nil)
		end
	end
	for __, effectSource in ipairs(_sourceList) do
		local effectValue = self:getBuffEffectFromSource(effectType, effectSource, noHero)
		if effectValue and effectValue ~= 0 then
			totalEffect = (totalEffect or 0) + effectValue
			_ENV = effectSource
			effectSource.effect = effectValue
			effectSource.effectType = effectType
			effectSource.source = effectSource
			effectSource.beginTime = 0
			effectSource.time = 0
			effectSource.id = 0
			table.insert(bufflist, effectSource)
		end
	end
	return totalEffect, bufflist
end
function buffCtrl:getBuffEffectFromSource(effectType, source, noHero)
	if effectType == gBuffEffect.MARCH_LIMIT_BOOST or effectType == gBuffEffect.MARCH_VALUE_LIMIT_BOOST then
		noHero = true
	end
	if not source then
		return 0
	end
	if source == gBuffSource.NULL then
		return nil
	end
	if source == gBuffSource.EQUIPMENT then
		return equipmentAdditionMgr.queryByBuffEffectType(effectType)
	elseif source == gBuffSource.EQUIP_RESONANCE then
		local equipmentMgr = include("equipmentMgr")
		return equipmentMgr.getWearWeaponEnhanceBuff(effectType)
	elseif source == gBuffSource.ACHIEVEMENT then
		local achievementctrl = gametop.playertop_:getModule("achievementctrl")
		return achievementctrl:getBuffValue(effectType)
	elseif source == gBuffSource.ACTIVITY then
		local activityBuffCtrl = gametop.playertop_:getModule("activityBuffCtrl")
		return activityBuffCtrl:getActivityBoost(effectType)
	elseif source == gBuffSource.MILITARY then
		local militaryRankCtrl = gametop.playertop_:getModule("militaryRankCtrl")
		return militaryRankCtrl:getTotalBuffValue(effectType)
	elseif source == gBuffSource.PET then
		local petCtrl = gametop.playertop_:getModule("petCtrl")
		return petCtrl:getPetAttributeAdd(effectType)
	elseif source == gBuffSource.KINGDOM_LEVEL then
		return kingdomLevelDataModuleAPI:getBuff(effectType)
	elseif source == gBuffSource.WAR_GEM then
		local warGemCtrl = gametop.playertop_:getModule("warGemCtrl")
		return warGemCtrl:getBuffPlus(effectType)
	elseif source == gBuffSource.PARLIAMENT then
		local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
		return intetiorCtrl:getBuffPlus(effectType)
	elseif source == gBuffSource.LEGEND_TITLE then
		local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
		local legendLordBuffValue = legendLordCtrl:getBuff(effectType)
		local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
		local kingStarBuffValue = kingStarCtrl:getBuff(effectType)
		return (legendLordBuffValue and legendLordBuffValue or 0) + (kingStarBuffValue and kingStarBuffValue or 0)
	elseif source == gBuffSource.HEGEMON_TITLE then
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		return hegemonCtrl:getBuff(effectType)
	elseif source == gBuffSource.ALLIANCE_OFFICIAL then
		local allianceCtrl = gametop.playertop_:getModule("allianceCtrl")
		return allianceCtrl:getBuffEffect(effectType)
	elseif source == gBuffSource.ABEAST_BLESSING then
		local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
		return alliancePetCtrl:getBuffEffect(effectType)
	elseif source == gBuffSource.HERO_CENOTAPH then
		local heroCenotaphCtrl = gametop.playertop_:getModule("heroCenotaphCtrl")
		return heroCenotaphCtrl:getHeroCenotaphBuffEffect(effectType)
	elseif source == gBuffSource.HERO_SYSTEM then
		if noHero then
			return 0
		else
			local heroCtrl = gametop.playertop_:getModule("heroCtrl")
			return heroCtrl:getHeroTotalPassiveBuff(effectType)
		end
	elseif source == gBuffSource.MIRACULOUS_WEAPON then
		local miraculousWeaponCtrl = gametop.playertop_:getModule("miraculousWeaponCtrl")
		return miraculousWeaponCtrl:getBuffEffect(effectType)
	elseif source == gBuffSource.BUILD_MASTERY then
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		return cityCtrl:getBuildMasteryEffect(effectType)
	elseif source == gBuffSource.GUARD_ACTIVITY then
		local guardianCtrl = gametop.playertop_:getModule("guardianCtrl")
		return guardianCtrl:getBuffEffect(effectType)
	elseif source == gBuffSource.BUILD_STAR then
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		return cityCtrl:getBuffEffect(effectType)
	elseif source == gBuffSource.ALLIANCE_PROSPERITY then
		return SoraDGetCtrl("allianceScience"):getProsperityBuffEffect(effectType)
	elseif source == gBuffSource.HERO_BIOGRAPHY then
		return SoraDGetCtrl("heroBiographyCtrl"):queryHeroBiographyBuff(effectType)
	elseif source == gBuffSource.SULTAN_BACK_REBATE then
		local sultansBackRebateUtil = include("sultansBackRebateUtil")
		return sultansBackRebateUtil.getBuffEffect(effectType)
	elseif source == gBuffSource.PRINCE_GIFT_ACTIVITY then
		local princeGiftRead = include("princeGiftRead")
		return princeGiftRead.getBuffEffect(effectType)
	elseif source == gBuffSource.PRINCE_GIFT_NEW then
		local princeGiftNewCtrl = SoraDGetCtrl("princeGiftNewCtrl")
		return princeGiftNewCtrl:getBuffEffect()
	elseif source == gBuffSource.KINGDOM_CHRONICLES then
		local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
		return legendMCtrl:getKingdomAchiBuffEffect(effectType)
	elseif source == gBuffSource.ATLANTIS_PRIVILEGE then
		local atlantisPrivilegeCtrl = gametop.playertop_:getModule("atlantisPrivilegeCtrl")
		return atlantisPrivilegeCtrl:getBuff(effectType)
	elseif source == gBuffSource.NEBULA_PRIVILEGE then
		local nebulaPrivilegeCtrl = gametop.playertop_:getModule("nebulaPrivilegeCtrl")
		return nebulaPrivilegeCtrl:getBuff(effectType)
	elseif source == gBuffSource.ATLANTIS_SKILL then
		local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
		return atlantisActivityCtrl:getBuffEffect(effectType)
	elseif source == gBuffSource.ALLIANCE_STRONGHOLD then
		local allianceStrontholdCtrl = SoraDGetCtrl("allianceStrontholdCtrl")
		return allianceStrontholdCtrl:getStrongholdBuffByType(effectType)
	elseif source == gBuffSource.FOREIGN_PAVILION then
		local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
		return exoticPavilionCtrl:getBuffByType(effectType)
	elseif source == gBuffSource.ATLANTIS_WIN_SEASON then
		local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
		return atlantisActivityCtrl:getPalaceBuffEffect(effectType)
	elseif source == gBuffSource.PALACE_OF_WISDOM_ACTIVITY then
		local wiseTutorCtrl = SoraDGetCtrl("wiseTutorCtrl")
		local artisanHouseCtrl = SoraDGetCtrl("artisanHouseCtrl")
		local effectValueW = wiseTutorCtrl:getBuffVale(effectType)
		local effectValueA = artisanHouseCtrl:getBuffVale(effectType)
		return math.max(effectValueA, effectValueW)
	elseif source == gBuffSource.METEOR_MAGIC then
		local meteorMagicCtrl = SoraDGetCtrl("meteorMagicCtrl")
		return meteorMagicCtrl:getBuffEffect(effectType)
	elseif source == gBuffSource.NEBULA_WAR_FINISH_OCCUPY then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		return nebulaActivityCtrl:getBuffEffect(effectType)
	elseif source == gBuffSource.NEBULA_TOWER then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		return nebulaActivityCtrl:getNebulaTowerBuffEffect(effectType)
	elseif source == gBuffSource.MAGIC_LAMP then
		local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
		return magicLampCtrl:getBuffEffect(effectType)
	elseif source == gBuffSource.NEBULA_EMPEROR_TITLE then
		local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
		return nebulaEmperorCtrl:getTitleBuff(effectType)
	elseif source == gBuffSource.NEBULA_EMPEROR_WAR then
		local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
		return nebulaEmperorCtrl:getBuffEffect(effectType)
	elseif source == gBuffSource.DIVINE_BEAST then
		local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
		return divineBeastCtrl:getBuffEffect(effectType)
	elseif source == gBuffSource.WAR_ORDER then
		local warOrderCtrl = SoraDGetCtrl("warOrderCtrl")
		local effectValue = warOrderCtrl:getBuffVale(effectType)
		return effectValue
	elseif source == gBuffSource.WAR_HORN then
		local warHornCtrl = SoraDGetCtrl("warHornCtrl")
		local effectValue = warHornCtrl:getBuffVale(effectType)
		return effectValue
	elseif source == gBuffSource.RECHARGE_ACTIVITY then
		local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
		return rechargeActivityCtrl:getRechargeBuffValue(effectType)
	elseif source == gBuffSource.ACTIVITY_9001565 then
		local activity_9001565_Ctrl = SoraDGetCtrl("activity_9001565_Ctrl")
		return activity_9001565_Ctrl:getBuffVale(effectType)
	elseif source == gBuffSource.NEBULA_ALLSTAR_WAR then
		local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
		return nebulaAllStarCtrl:getBuffEffect(effectType)
	elseif source == gBuffSource.ACTIVITY_9001601 then
		local activity_9001601_Ctrl = SoraDGetCtrl("activity_9001601_Ctrl")
		return activity_9001601_Ctrl:getBuffVale(effectType)
	elseif source == gBuffSource.ACTIVITY_9001656 then
		local activity_9001656_Ctrl = SoraDGetCtrl("activity_9001656_Ctrl")
		return activity_9001656_Ctrl:getBuffVale(effectType)
	elseif source == gBuffSource.HERO_APPOINT then
		local heroAppointCtrl = SoraDGetCtrl("heroAppointCtrl")
		return heroAppointCtrl:getBuffVale(effectType)
	elseif source == gBuffSource.ACTIVITY_9001683 then
		local activity_9001683_Ctrl = SoraDGetCtrl("activity_9001683_Ctrl")
		return activity_9001683_Ctrl:getBuffVale(effectType)
	elseif source == gBuffSource.ROARING_FLAME_WAR then
		local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
		return roaringFlameWarCtrl:getBuffEffect(effectType)
	elseif source == gBuffSource.ACTIVITY_9001701 then
		local activity_9001701_Ctrl = SoraDGetCtrl("activity_9001701_Ctrl")
		return activity_9001701_Ctrl:getBuffVale(effectType)
	elseif source == gBuffSource.KOH_MIGRATE_HELP_9001708 then
		local activity_9001708_Ctrl = SoraDGetCtrl("activity_9001708_Ctrl")
		return activity_9001708_Ctrl:getBuffVale(effectType)
	elseif source == gBuffSource.GARDEN then
		local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
		return manorCityCtrl:getBuffVale(effectType)
	elseif source == gBuffSource.NACKLACE_TEC then
		local necklaceTecCtrl = SoraDGetCtrl("necklaceTecCtrl")
		return necklaceTecCtrl:getBuffVale(effectType)
	else
		return self.buffMgr:getBuffEffect(effectType, source)
	end
end
function buffCtrl:getResourceBoostEffect(effectType, bid, iid)
	effectType = effectType .. "@bid_" .. bid .. "_iid_" .. iid
	return self.buffMgr:getBuffEffect(effectType)
end
function buffCtrl:getResourceBoostBuff(effectType, bid, iid)
	effectType = effectType .. "@" .. "bid" .. "_" .. bid .. "_" .. "iid" .. "_" .. iid
	return self.buffMgr:queryBuff(gBuffSource.CITY, effectType)
end
function buffCtrl:getBuffItemArray(effectType)
