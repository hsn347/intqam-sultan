local kingCityUpgradeRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	kingCityUpgradeRead:defineValue("awardConfig", function()
		kingCityUpgradeRead.awardConfig, kingCityUpgradeRead = nil, nil
		local awardConfig = require_once("app." .. LocalTblPath .. ".config_server.new_player_castle_lv")
		for i, v in ipairs(awardConfig) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.award = serviceFunctions.tableFormat(v.award, nil)
			table.insert(kingCityUpgradeRead.awardConfig, v)
		end
		return kingCityUpgradeRead.awardConfig
	end)
end
init()
function kingCityUpgradeRead.getHasHeroItemByLv(lv)
	for _, value in pairs(kingCityUpgradeRead.getRewardByLv(lv)) do
		local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
		if backpackltCtrl:getItemType(value.id) == gItemType.HERO_CHIP then
			return value
		end
	end
	return nil
end
function kingCityUpgradeRead.getRewardByLv(lv)
	for i, v in ipairs(kingCityUpgradeRead.awardConfig) do
		if v.castlelv == lv then
			return v.award
		end
	end
	_ENV = (for generator)
	return ipairs(kingCityUpgradeRead.awardConfig)
end
function kingCityUpgradeRead.getAwardConfig()
	if not kingCityUpgradeRead.awardConfig then
		kingCityUpgradeRead = kingCityUpgradeRead.awardConfig
	end
	return kingCityUpgradeRead.awardConfig
end
function kingCityUpgradeRead.getConfigNum()
	return table.nums(kingCityUpgradeRead.awardConfig)
end
return kingCityUpgradeRead
