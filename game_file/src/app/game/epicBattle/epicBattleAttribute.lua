local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local epicBattleDef = include("epicBattleDef")
local epicBattleAttribute = class("epicBattleAttribute", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicBattleAttribute")
	end
	return target
end)
function epicBattleAttribute:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.bossID = nil
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("hero_title_03"))
	self.Text_mine = SoraDGetChildByName(self, "Text_mine")
	self.Text_mine:setString(i18n("hero_title_04"))
	self.Text_boss = SoraDGetChildByName(self, "Text_boss")
	self.scroll = SoraDGetChildByName(self, "ScrollView_content")
	self.Node_attribute = SoraDGetChildByName(self, "Node_attribute")
end
function epicBattleAttribute:initData(bossID, heros, lieuTenantHeros)
	self.bossID = bossID
	local heroID = epicWarltCtrl.getBossHeroID(self.bossID)
	epicWarltCtrl = nil
	;(nil).bossName = i18n(epicWarltCtrl.getBossHeroName(heroID))
	self.Text_boss:setString(i18n("hero_title_05", nil))
	local bonus, bonusArray = epicWarltCtrl.getBossBonus(self.bossID)
	local lordArray = epicWarCtrl:getBuffInfo(true)
	local effectTbl = heroltCtrl:getSomeSkillValue(heros, gSkillActiveType.BATTLE_SKILL, lieuTenantHeros)
	local createSingle = function(index, info)
		local single = self.Node_attribute:clone()
		single:setVisible(true)
		local Image_aBg = SoraDGetChildByName(single, "Image_aBg")
		local Node_boss = SoraDGetChildByName(single, "Node_boss")
		local Text_attribute_boss = SoraDGetChildByName(Node_boss, "Text_attribute")
		local Text_value_boss = SoraDGetChildByName(Node_boss, "Text_value")
		local Node_mine = SoraDGetChildByName(single, "Node_mine")
		local Text_attribute_mine = SoraDGetChildByName(Node_mine, "Text_attribute")
		local Text_value_mine = SoraDGetChildByName(Node_mine, "Text_value")
		self = nil
		;(nil).value = tostring(info.value / 10) .. "%"
		local value_boss = i18n("common_text_1952", nil)
		Image_aBg:setVisible(index % 2 == 0)
		Text_attribute_boss:setString(i18n(info.key))
		Text_value_boss:setString(value_boss)
		SoraDToCenter(Node_boss, 20)
		Text_attribute_mine:setString(i18n(info.key))
		local mineValue = lordArray[tostring(info.buff)] and lordArray[tostring(info.buff)] / 10 or 0
		mineValue = mineValue + (effectTbl[info.buff] and effectTbl[info.buff] / 10 or 0)
		if (effectTbl[gBuffEffect.TROOP_ATTACK_BOOST] or lordArray[tostring(gBuffEffect.TROOP_ATTACK_BOOST)]) and info.own == gBuffEffect.TROOP_ATTACK_BOOST then
			print("全属性攻击增加")
			mineValue = mineValue + (effectTbl[gBuffEffect.TROOP_ATTACK_BOOST] or 0) / 10
			mineValue = mineValue + (lordArray[tostring(gBuffEffect.TROOP_ATTACK_BOOST)] or 0) / 10
		end
		if (effectTbl[gBuffEffect.TROOP_DEFENSE_BOOST] or lordArray[tostring(gBuffEffect.TROOP_DEFENSE_BOOST)]) and info.own == gBuffEffect.TROOP_DEFENSE_BOOST then
			print("全属防御增加")
			mineValue = mineValue + (effectTbl[gBuffEffect.TROOP_DEFENSE_BOOST] or 0) / 10
			mineValue = mineValue + (lordArray[tostring(gBuffEffect.TROOP_DEFENSE_BOOST)] or 0) / 10
		end
		if (effectTbl[gBuffEffect.TROOP_HP_BOOST] or lordArray[tostring(gBuffEffect.TROOP_HP_BOOST)]) and info.own == gBuffEffect.TROOP_HP_BOOST then
			print("全属性生命增加")
			mineValue = mineValue + (effectTbl[gBuffEffect.TROOP_HP_BOOST] or 0) / 10
			mineValue = mineValue + (lordArray[tostring(gBuffEffect.TROOP_HP_BOOST)] or 0) / 10
		end
		if lordArray[tostring(gBuffEffect.TROOP_ATTACK_REDUCE)] and info.own == gBuffEffect.TROOP_ATTACK_BOOST then
			print("全属性攻击减少")
			mineValue = mineValue - (lordArray[tostring(gBuffEffect.TROOP_ATTACK_REDUCE)] or 0) / 10
		end
		if lordArray[tostring(gBuffEffect.TROOP_DEFENSE_REDUCE)] and info.own == gBuffEffect.TROOP_DEFENSE_BOOST then
			print("全属性防御减少")
			mineValue = mineValue - (lordArray[tostring(gBuffEffect.TROOP_DEFENSE_REDUCE)] or 0) / 10
		end
		if lordArray[tostring(gBuffEffect.TROOP_HP_BOOST_REDUCE)] and info.own == gBuffEffect.TROOP_HP_BOOST then
			print("全属性生命减少")
			mineValue = mineValue - (lordArray[tostring(gBuffEffect.TROOP_HP_BOOST_REDUCE)] or 0) / 10
		end
		if info.own == gBuffEffect.TROOP_ATTACK_BOOST then
			mineValue = mineValue + epicWarCtrl:getMutBuffInfo(epicBattleDef.gBlessEffctType.KILL_BOSS_TROOP_ATTACK_BOOST)
		end
		if info.own == gBuffEffect.TROOP_DEFENSE_BOOST then
			mineValue = mineValue + epicWarCtrl:getMutBuffInfo(epicBattleDef.gBlessEffctType.KILL_BOSS_TROOP_DEFENSE_BOOST)
		end
		if info.own == gBuffEffect.TROOP_HP_BOOST then
			mineValue = mineValue + epicWarCtrl:getMutBuffInfo(epicBattleDef.gBlessEffctType.KILL_BOSS_TROOP_HP_BOOST)
		end
		local dir = 0 <= mineValue and "+" or ""
		local value_mine = string.format("%s%s%%", dir, SoraDPreciseDecimal(mineValue, 1))
		Text_value_mine:setString(value_mine)
		SoraDToCenter(Node_mine, 20)
		if SoraDGetDefaultLanguage() ~= "zh-CN" or SoraDGetDefaultLanguage() ~= "zh-TW" then
			SoraDSetTextWidthHeight(Text_attribute_mine, cc.size(200, 45))
			SoraDSetTextWidthHeight(Text_attribute_boss, cc.size(200, 45))
		end
		return single
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, #bonusArray * 40)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for k, v in ipairs(bonusArray) do
		local single = createSingle(k, v)
		single:setPosition(sSize.width / 2, sH - k * 40 + 20)
		single:addTo(self.scroll)
	end
end
return epicBattleAttribute
