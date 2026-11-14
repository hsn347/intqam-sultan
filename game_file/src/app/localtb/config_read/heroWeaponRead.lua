local heroWeaponRead = include("aAReadClass").new()
heroWeaponRead.maxStage = 5
heroWeaponRead.maxLv = 50
_UPVALUE1_ = nil
;(nil)[1] = "weapon_config"
heroWeaponRead:defineValue("weapon_config", nil)
function heroWeaponRead.getWeaponIcon(weaponId)
	return heroWeaponRead.weapon_config[weaponId].icon
end
function heroWeaponRead.getWeaponBasePng(quality)
	quality = math.min(quality + 1, gQualityDef.RED + 1)
	return string.format("frame_item_base_%.2d.png", quality)
end
heroWeaponRead:defineValue("weapon_basic", function()
	local _ENV, config
	local weapon_basic = require_data("weapon_basic", true).data
	for i, v in ipairs(weapon_basic) do
		if not config[v.weaponId] then
			config[v.weaponId], _ENV = nil, nil
		end
		config[v.weaponId][v.stage] = v
		heroWeaponRead.maxStage = math.max(heroWeaponRead.maxStage, v.stage)
	end
	heroWeaponRead.weapon_basic = config
	return heroWeaponRead.weapon_basic
end)
function heroWeaponRead.getWeaponName(weaponId)
	return i18n(heroWeaponRead.weapon_config[weaponId].weaponName)
end
function heroWeaponRead.getRecipientName(weaponId, isSp)
	local recipient = heroWeaponRead.weapon_basic[weaponId][0].recipient
	if 0 < recipient then
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		heroWeaponRead = nil
		;(nil).name = i18n(heroltCtrl.getHeroName(recipient))
		return i18n(isSp and "HeroWeapon_55" or "HeroWeapon_54", nil)
	end
end
function heroWeaponRead.getQuality(weaponId)
	return heroWeaponRead.weapon_basic[weaponId][0].quality
end
function heroWeaponRead.getBg(weaponId)
	local quality = heroWeaponRead.getQuality(weaponId)
	return heroWeaponRead.getWeaponBasePng(quality)
end
function heroWeaponRead.getWeaponComBg(weaponId)
	local quality = heroWeaponRead.getQuality(weaponId)
	heroWeaponRead = weaponId
	weaponId[gQualityDef.PURPLE] = "frame_hero_weapon01.png"
	weaponId[gQualityDef.ORANGE] = "frame_hero_weapon02.png"
	local weaponId[gQualityDef.GOLD], cfg = "frame_hero_weapon03.png", weaponId
	return cfg[quality] or "frame_hero_weapon01.png"
end
function heroWeaponRead.getWeaponNBg(weaponId)
	local quality = heroWeaponRead.getQuality(weaponId)
	heroWeaponRead = weaponId
	weaponId[gQualityDef.PURPLE] = "bg_heroicweapon_color04.png"
	weaponId[gQualityDef.ORANGE] = "bg_heroicweapon_color05.png"
	local weaponId[gQualityDef.GOLD], cfg = "bg_heroicweapon_color06.png", weaponId
	return cfg[quality] or "bg_heroicweapon_color04.png"
end
function heroWeaponRead.getWeaponMapCfg()
	local _ENV, cfg
	for k, v in pairs(heroWeaponRead.weapon_basic) do
		table.insert(cfg, v[0])
	end
	table.sort(cfg, function(a, b)
		return a.weaponId < b.weaponId
	end)
	return cfg
end
function heroWeaponRead.getWeaponCfg(weaponId, stage)
	return heroWeaponRead.weapon_basic[weaponId][stage]
end
function heroWeaponRead.getWeaponSellCfg(weaponId, stage)
	return heroWeaponRead.weapon_basic[weaponId][stage].saleReturn[2]
end
function heroWeaponRead.getWeaponLvLimit(weaponId, stage)
	return heroWeaponRead.weapon_basic[weaponId][stage].levelLimit
end
function heroWeaponRead.getWeaponStageCost(weaponId, stage)
	local cfg = heroWeaponRead.weapon_basic[weaponId][stage].stageCost
	return cfg[1], cfg[2]
end
function heroWeaponRead.getWeaponStageToMaxNeed(weaponId, stage)
	local needNum = 0
	local maxStage = heroWeaponRead.getWeaponStageLimit(weaponId)
	local cfg = heroWeaponRead.weapon_basic[weaponId]
	for s = 0, #cfg do
		if stage <= s then
			local stageCost = cfg[s].stageCost
			if stageCost and stageCost[2] then
				needNum = needNum + stageCost[2]
			end
		end
	end
	return needNum
end
function heroWeaponRead.getWeaponRebuildReturn(weaponId, stage)
	local cfg = heroWeaponRead.weapon_basic[weaponId][stage].rebuildReturn
	return cfg[1], cfg[2]
end
function heroWeaponRead.getWeaponStageLimit(weaponId)
	return #heroWeaponRead.weapon_basic[weaponId]
end
function heroWeaponRead.getWeaponPower(weapon)
	local power = 0
	local weaponId = weapon.weaponID or weapon.weaponId
	local stage = weapon.stage or 0
	local lv = weapon.lv or 0
	local cfg = heroWeaponRead.weapon_basic[weaponId]
	local preLimit = 0
	for s = 0, #cfg do
		if stage > cfg[s].stage then
			power = power + cfg[s].stageValue + cfg[s].valueArise * (cfg[s].levelLimit - preLimit)
		elseif stage == cfg[s].stage then
			power = power + cfg[s].stageValue + cfg[s].valueArise * math.max(0, lv - preLimit)
		end
		preLimit = cfg[s].levelLimit
	end
	return power
end
function heroWeaponRead.getBasicAttr(weapon, stage)
	local weaponId = weapon.weaponID or weapon.weaponId
	local stage = stage or weapon.stage
	local cfg = heroWeaponRead.weapon_basic[weaponId][stage]
	_UPVALUE4_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "type"
	;(nil)[3] = "base"
	;(nil)[4] = "val"
	return serviceFunctions.tableFormat(cfg.attributeBasic, nil)
end
function heroWeaponRead.getBasicRealAttr(weapon, preStage, preLv, isMax)
	local weaponId = weapon.weaponID or weapon.weaponId
	local stage = weapon.stage or 0
	local lv = weapon.lv or 0
	local _preStage = preStage or stage
	local _preLv = preLv or lv
	local cfg = heroWeaponRead.weapon_basic[weaponId]
	local heroWeaponRead, attrResult
	local preLimit = 0
	for s = 0, #cfg do
		_UPVALUE4_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "type"
		;(nil)[3] = "base"
		;(nil)[4] = "val"
		local attr = serviceFunctions.tableFormat(cfg[s].attributeBasic, nil)
		for i, v in ipairs(attr) do
			if not attrResult[v.id] then
				attrResult[v.id], heroWeaponRead = nil, nil
				attrResult[v.id].type = v.type
				attrResult[v.id].result = 0
				attrResult[v.id].pre = 0
				attrResult[v.id].isMax = isMax
			end
			if cfg[s].stage == stage then
				attrResult[v.id].result = attrResult[v.id].result + v.base
			end
			attrResult[v.id].result = attrResult[v.id].result + v.val * math.max(0, math.min(cfg[s].levelLimit, lv) - preLimit)
			if _preStage and _preLv then
				if cfg[s].stage == _preStage then
					attrResult[v.id].pre = attrResult[v.id].pre + v.base
				end
				attrResult[v.id].pre = attrResult[v.id].pre + v.val * math.max(0, math.min(cfg[s].levelLimit, _preLv) - preLimit)
			end
		end
		preLimit = cfg[s].levelLimit
	end
	local heroWeaponRead, result = (for index), 0
	for id, val in pairs(attrResult) do
		heroWeaponRead = "type"
		;("type").id = id
		;("type").result = val.result
		;("type").pre = val.pre
		;("type").type = val.type
		;("type").isMax = val.isMax
		table.insert(result, "type")
	end
	table.sort(result, function(a, b)
		return a.id < b.id
	end)
	return result
end
heroWeaponRead:defineValue("weapon_special", function()
	local _ENV, config
	local cfg = require_data("weapon_special", true).data
	for i, v in ipairs(cfg) do
		config[v.attributeId] = v
	end
	heroWeaponRead.weapon_special = config
	return heroWeaponRead.weapon_special
end)
function heroWeaponRead.getSpecialAttr(weapon, stage)
	local spID = 0
	local desc = ""
	local heroWeaponRead, effectCfg
	local weaponId = weapon.weaponID or weapon.weaponId
	local stage = stage or weapon.stage
	local cfg = heroWeaponRead.weapon_basic[weaponId][stage]
	spID = cfg.attributeSpecial
	if 0 < spID then
		local describe = heroWeaponRead.weapon_special[spID].describe
		_UPVALUE3_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "type"
		;(nil)[3] = "val"
		local effectNum = serviceFunctions.tableFormat(heroWeaponRead.weapon_special[spID].effectNum, nil)
		effectCfg = effectNum
		local key
		for _, lang in ipairs(describe) do
			key = lang
			break
		end
		local heroWeaponRead, param = (for generator), ipairs(describe)
		param.num = effectNum[1].val / 100 .. "%"
		for k, v in ipairs(effectNum) do
			param["num" .. k] = v.val / 100 .. "%"
		end
		if key == "weapon_effect_02" then
			local shield
			for k, v in ipairs(effectNum) do
				if v.id == gBuffEffect.FIRST_ROUND_INFANTRY_HP_SHIELD_PLUS then
					shield = v.val / 100 .. "%"
				end
			end
			param.num2 = shield
		elseif key == "weapon_effect_03" then
			local shield
			for k, v in ipairs(effectNum) do
				if v.id == gBuffEffect.FIRST_ROUND_INFANTRY_HP_SHIELD_PLUS then
					shield = v.val / 100 .. "%"
				end
			end
			param.num = shield
		end
		desc = i18n(key, param)
	end
	return desc, effectCfg
end
heroWeaponRead:defineValue("weapon_levelup", function()
	local _ENV, config
	local cfg = require_data("weapon_levelup", true).data
	for i, v in ipairs(cfg) do
		if not config[v.quality] then
			config[v.quality], _ENV = nil, nil
		end
		config[v.quality][v.level] = v
	end
	heroWeaponRead.weapon_levelup = config
	return heroWeaponRead.weapon_levelup
end)
function heroWeaponRead.getLvUpEXP(quality, lv)
	return heroWeaponRead.weapon_levelup[quality][lv].exp
end
function heroWeaponRead.getLvEXP(quality, lv, exp)
	local totalExp = exp
	for i = 0, heroWeaponRead.getMaxLv() do
		if i < lv then
			totalExp = totalExp + heroWeaponRead.weapon_levelup[quality][i].exp
		end
	end
	return totalExp
end
function heroWeaponRead.getMaxStage()
	return heroWeaponRead.maxStage
end
function heroWeaponRead.getMaxLv()
	return heroWeaponRead.maxLv
end
function heroWeaponRead.getWeaponResetCost(weaponId, stage, lv, quality)
	local stageCost = heroWeaponRead.weapon_basic[weaponId][stage].rebuildCost
	local lvCost = heroWeaponRead.weapon_levelup[quality][lv].rebuildCost
	return stageCost + lvCost
end
return heroWeaponRead
