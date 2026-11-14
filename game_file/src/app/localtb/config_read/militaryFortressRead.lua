local militaryFortressRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	local createData2 = function(name)
		local powerModulus = require_once("app." .. LocalTblPath .. ".config_server.military_fortress_modulus_poewr")
		militaryFortressRead.powerModulus, _ENV = "app." .. LocalTblPath .. ".config_server.military_fortress_modulus_poewr", "app." .. LocalTblPath .. ".config_server.military_fortress_modulus_poewr"
		for i, v in ipairs(powerModulus) do
			if not militaryFortressRead.powerModulus[v.aim] then
				militaryFortressRead.powerModulus[v.aim], _ENV = nil, nil
			end
			if not militaryFortressRead.powerModulus[v.aim][v.rarity] then
				militaryFortressRead.powerModulus[v.aim][v.rarity], _ENV = nil, nil
			end
			local nextPower
			if powerModulus[i + 1] and powerModulus[i + 1].rarity == v.rarity and powerModulus[i + 1].aim == v.aim then
				nextPower = powerModulus[i + 1].power
			end
			_UPVALUE2_, _ENV = nil, v.rarity
			v.rarity.power, (nil)[1] = nil, v.power
			v.rarity.power, (nil)[2] = nil, nextPower
			v.rarity.addition = v.addition
			table.insert(militaryFortressRead.powerModulus[v.aim][v.rarity], v.rarity)
		end
		local lvModulus = require_once("app." .. LocalTblPath .. ".config_server.military_fortress_modulus_herlv")
		militaryFortressRead.lvModulus, _ENV = "app." .. LocalTblPath .. ".config_server.military_fortress_modulus_herlv", "app." .. LocalTblPath .. ".config_server.military_fortress_modulus_herlv"
		for i, v in ipairs(lvModulus) do
			if not militaryFortressRead.lvModulus[v.aim] then
				militaryFortressRead.lvModulus[v.aim], _ENV = v.rarity, v.rarity
			end
			if not militaryFortressRead.lvModulus[v.aim][v.rarity] then
				militaryFortressRead.lvModulus[v.aim][v.rarity], _ENV = v.rarity, v.rarity
			end
			local nextLv
			if lvModulus[i + 1] and lvModulus[i + 1].rarity == v.rarity and powerModulus[i + 1].aim == v.aim then
				nextLv = lvModulus[i + 1].lv
			end
			_UPVALUE2_, _ENV = v.power, v.rarity
			v.rarity.lv, v.power[1] = v.power, v.lv
			v.rarity.lv, v.power[2] = v.power, nextLv
			v.rarity.addition = v.addition
			table.insert(militaryFortressRead.lvModulus[v.aim][v.rarity], v.rarity)
		end
		if name == "powerModulus" then
			return militaryFortressRead.powerModulus
		elseif name == "lvModulus" then
			return militaryFortressRead.lvModulus
		end
	end
	militaryFortressRead:defineValue("powerModulus", createData2)
	militaryFortressRead:defineValue("lvModulus", createData2)
	militaryFortressRead:defineValue("rarityModulus", function()
		local rarityModulus = require_once("app." .. LocalTblPath .. ".config_server.military_fortress_modulus_hero")
		militaryFortressRead.rarityModulus, _ENV = "app." .. LocalTblPath .. ".config_server.military_fortress_modulus_hero", "app." .. LocalTblPath .. ".config_server.military_fortress_modulus_hero"
		for i, v in ipairs(rarityModulus) do
			if not militaryFortressRead.rarityModulus[v.aim] then
				militaryFortressRead.rarityModulus[v.aim], _ENV = nil, nil
			end
			militaryFortressRead.rarityModulus[v.aim][v.rarity] = v.addition
		end
		return militaryFortressRead.rarityModulus
	end)
	local createData = function(name)
		local buffConfig = require_once("app." .. LocalTblPath .. ".config_server.military_fortress_buff")
		militaryFortressRead.buffLimit, _ENV, militaryFortressRead.buffConfig, _ENV = "app." .. LocalTblPath .. ".config_server.military_fortress_buff", "app." .. LocalTblPath .. ".config_server.military_fortress_buff", "app." .. LocalTblPath .. ".config_server.military_fortress_buff", "app." .. LocalTblPath .. ".config_server.military_fortress_buff"
		for i, v in ipairs(buffConfig) do
			if not militaryFortressRead.buffConfig[v.type] then
				militaryFortressRead.buffConfig[v.type], _ENV = nil, nil
			end
			if not militaryFortressRead.buffConfig[v.type][v.aim] then
				militaryFortressRead.buffConfig[v.type][v.aim], _ENV = nil, nil
			end
			militaryFortressRead.buffConfig[v.type][v.aim][v.position] = v.buff
			militaryFortressRead.buffLimit[v.buff] = v.limit
		end
		if name == "buffConfig" then
			return militaryFortressRead.buffConfig
		elseif name == "buffLimit" then
			return militaryFortressRead.buffLimit
		end
	end
	militaryFortressRead:defineValue("buffConfig", createData)
	militaryFortressRead:defineValue("buffLimit", createData)
end
init()
function militaryFortressRead.getPowerModulus(campType, rarity, power)
	for i, v in ipairs(militaryFortressRead.powerModulus[campType][rarity]) do
		if power >= v.power[1] and (not v.power[2] or power < v.power[2]) then
			return v.addition
		end
	end
	return 0
end
function militaryFortressRead.getLvModulus(campType, rarity, lv)
	for i, v in ipairs(militaryFortressRead.lvModulus[campType][rarity]) do
		if lv >= v.lv[1] and (not v.lv[2] or lv < v.lv[2]) then
			return v.addition
		end
	end
	return 0
end
function militaryFortressRead.getRarityModulus(campType, rarity)
	return militaryFortressRead.rarityModulus[campType][rarity] or 0
end
function militaryFortressRead.getBuffConfig(campType, fortessType)
	return militaryFortressRead.buffConfig[fortessType][campType]
end
function militaryFortressRead.getTotalModulus(campType, heroID)
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	if not heroID then
		return nil
	end
	local level = heroCtrl:getHeroInfoByID(heroID).level
	local rarity = heroltCtrl:getRarity(heroID)
	local power = heroCtrl:getHeroPower(heroID)
	local total = militaryFortressRead.getRarityModulus(campType, rarity)
	total = total + militaryFortressRead.getLvModulus(campType, rarity, level)
	total = total + militaryFortressRead.getPowerModulus(campType, rarity, power)
	return total
end
function militaryFortressRead.getFortessTitle(fortessType)
	_UPVALUE0_ = nil
	;(nil)[1] = "fortress_name_02"
	;(nil)[2] = "fortress_name_03"
	;(nil)[3] = "fortress_name_04"
	local (nil)[4], fortessTitle = "fortress_name_05", nil
	return fortessTitle[fortessType]
end
function militaryFortressRead.getCampTitle(campType)
	_UPVALUE0_ = nil
	;(nil)[1] = "fortress_name_07"
	local (nil)[2], campTitle = "fortress_name_06", nil
	return campTitle[campType]
end
function militaryFortressRead.getFortessIcon(fortessType)
	_UPVALUE0_ = nil
	;(nil)[1] = "frame_fortress_build_bb.png"
	;(nil)[2] = "frame_fortress_build_qb.png"
	;(nil)[3] = "frame_fortress_build_gb.png"
	local (nil)[4], fortessIcon = "frame_fortress_build_cb.png", nil
	return fortessIcon[fortessType]
end
function militaryFortressRead.getTitleAndValueStr(attrID, attrValue)
	local buffDesRead = include("buffDesRead")
	local titleStr = buffDesRead.getTitleBase(attrID, nil, true)
	local valueStr
	if attrValue then
		valueStr = buffDesRead.getTitleValueWithValue(attrID, attrValue)
	else
		valueStr = "?"
	end
	return titleStr, valueStr
end
function militaryFortressRead.getBuffLimit(buffID)
	return militaryFortressRead.buffLimit[buffID]
end
return militaryFortressRead
