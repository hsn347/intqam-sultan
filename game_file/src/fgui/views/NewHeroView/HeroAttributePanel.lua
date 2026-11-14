local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local buffDesRead = include("buffDesRead")
local buffLogic = include("buffLogic")
local cityltCtrl = include("cityltCtrl")
local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local constantRead = include("constantRead")
local heroWeaponRead = include("heroWeaponRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroAttributePanel = class("HeroAttributePanel", baseFguiPanel)
function HeroAttributePanel:ctor(...)
	HeroAttributePanel.super.ctor(self, ...)
	print("HeroAttributePanel:ctor", self.viewName)
end
function HeroAttributePanel:onInit()
	print("=======HeroAttributePanel:onInit")
	self.buffList, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("hero_palace_text_02"))
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
end
function HeroAttributePanel:onListRenderer(index, obj)
	obj:initData(self.buffList[index + 1])
end
function HeroAttributePanel:onShow()
	print("=======HeroAttributePanel:onShow")
	self.buffList, _ENV, self.heroID = self.param.heroID, self.param.heroID, self.param.heroID
	if SoraDGetBuildStarLv() >= constantRead.getConstValue("HERO_APPOINT_LIMIT_LV") then
		_ENV = "HERO_APPOINT_LIMIT_LV"
		;("HERO_APPOINT_LIMIT_LV").isTitle = true
		;("HERO_APPOINT_LIMIT_LV").des = i18n("hero_appoint_40")
		table.insert(self.buffList, "HERO_APPOINT_LIMIT_LV")
		local attrTb = heroltCtrl:getHeroAppointAttr(self.heroID)
		local index = 1
		for k, v in ipairs(attrTb) do
			_ENV = nil
			_ENV = nil
			;(nil).des = cityltCtrl.getHeroAttrName(k)
			;(nil).num = v
			;(nil).des = i18n("%{des}:%{num}", nil)
			;(nil).index = index
			table.insert(self.buffList, nil)
			index = index + 1
		end
	end
	_ENV = ipairs(attrTb)
	ipairs(attrTb).isTitle = true
	ipairs(attrTb).des = i18n("hero_appoint_41")
	table.insert(self.buffList, ipairs(attrTb))
	local _ENV, buffArray = table.insert, table.insert
	local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	local skillAddition, awakeAddition, stuntAddition, masteryAddition = heroCtrl:getHeroPalaceBuff(self.heroID)
	for k, v in pairs(heroInfo.skillList) do
		if v.isActive then
			local skillCfg = heroltCtrl:getSkillCfg(v.skillType, heroInfo.quality)
			local addition = heroltCtrl:isScreenBuff(skillCfg.buffType) and 0 or skillAddition / 1000
			buffArray[skillCfg.buffType] = (buffArray[skillCfg.buffType] or 0) + skillCfg.buffValue * (1 + addition)
		end
	end
	if not heroltCtrl:getAwakeLvSkillData(self.heroID, heroInfo.level) then
		local _ENV, skillMap = heroltCtrl:getAwakeLvSkillData(self.heroID, heroInfo.level), heroltCtrl:getAwakeLvSkillData(self.heroID, heroInfo.level)
	end
	if not skillMap.buffType then
		_ENV = skillMap.buffType
	end
	for k, v in ipairs(skillMap.buffType) do
		local addition = heroltCtrl:isScreenBuff(v) and 0 or awakeAddition / 1000
		buffArray[v] = (buffArray[v] or 0) + skillMap.buffValue[k] / 10 * (1 + addition)
	end
	if not heroInfo.powerSkill then
		_ENV = heroInfo.powerSkill
	end
	for k, v in pairs(heroInfo.powerSkill) do
		local skillInfo = heroltCtrl:queryPowerSkillByID(v.skillID)
		local addition = heroltCtrl:isScreenBuff(skillInfo.buffData.buffType) and 0 or stuntAddition / 1000
		buffArray[skillInfo.buffData.buffType] = (buffArray[skillInfo.buffData.buffType] or 0) + v.buffValue * (1 + addition)
	end
	if heroInfo.advancedSkill and next(heroInfo.advancedSkill) then
		local mSkillCfg = heroltCtrl:getMasterySkillInfo(heroInfo.advancedSkill.skillID)
		for k, v in ipairs(mSkillCfg.buffType) do
			local addition = heroltCtrl:isScreenBuff(v) and 0 or masteryAddition / 1000
			buffArray[v] = (buffArray[v] or 0) + mSkillCfg.buffValue[k] * (1 + addition)
		end
	end
	local heroLevelInfo = heroltCtrl:getHeroLevelInfo(self.heroID, heroInfo.level)
	buffArray[gBuffEffect.MARCH_VALUE_LIMIT_BOOST] = (buffArray[gBuffEffect.MARCH_VALUE_LIMIT_BOOST] or 0) + heroLevelInfo.march_add
	local dressList = heroltCtrl:getHeroDress(self.heroID)
	for k, v in ipairs(dressList) do
		if not heroltCtrl:isDefaultDress(v) then
			local isOwn = heroCtrl:isOwnDressID(self.heroID, v)
			if not isOwn or not heroltCtrl:getOwnBuff(v) then
				local _ENV, ownBuff = heroltCtrl:getOwnBuff(v), heroltCtrl:getOwnBuff(v)
			end
			for _, buff in ipairs(ownBuff) do
				buffArray[buff.id] = (buffArray[buff.id] or 0) + buff.value
			end
			local dressBuff = heroltCtrl:getDressBuff(heroCtrl:getHeroDressSeting(self.heroID))
			for _, buff in ipairs(dressBuff) do
				buffArray[buff.id] = (buffArray[buff.id] or 0) + buff.value
			end
		end
	end
	if heroInfo.weaponUid and 0 < heroInfo.weaponUid then
		local weapon = heroWeaponCtrl:getWeaponByUid(heroInfo.weaponUid)
		local baseAttr = heroWeaponRead.getBasicRealAttr(weapon)
		for _, v in ipairs(baseAttr) do
			buffArray[v.id] = (buffArray[v.id] or 0) + v.result / 10
		end
		local _, specialAttr = heroWeaponRead.getSpecialAttr(weapon)
		for _, v in ipairs(specialAttr) do
			buffArray[v.id] = (buffArray[v.id] or 0) + v.val / 10
		end
	end
	local _ENV, buffTb = weapon, heroWeaponCtrl:getWeaponByUid(heroInfo.weaponUid)
	for k, v in pairs(buffArray) do
		local base, data = buffDesRead.getTitleBase(k, true)
		if data.effectType == 2 then
			if buffLogic.isNeedThousand(k) then
				v = v / 1000 or v
			end
		else
			v = SoraDPreciseDecimal(v, 1)
		end
		if 0 < v and not heroltCtrl:isScreenBuff(k) and buffDesRead.isShowInHeroSelect(k) then
			_ENV = k
			k.buffType = k
			k.buffValue = v
			k.des = buffDesRead.getTitleWithValue(k, v)
			table.insert(buffTb, k)
		end
	end
	table.sort(buffTb, function(a, b)
		return a.buffType < b.buffType
	end)
	local index = 1
	for k, v in ipairs(buffTb) do
		v.index = index
		table.insert(self.buffList, v)
		index = index + 1
	end
	self.fields.List:setNumItems(#self.buffList)
end
return HeroAttributePanel
