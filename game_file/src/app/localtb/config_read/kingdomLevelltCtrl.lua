local kingdomLevelltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	kingdomLevelltCtrl:initialize()
end
function kingdomLevelltCtrl:initialize()
	if self.data then
		return
	end
	local createConfig = function()
		local kingdom_lv_config = require_once("app." .. LocalTblPath .. ".config_server.kingdom_lv_config")
		local _ENV, kingdomLvConfig = "app." .. LocalTblPath .. ".config_server.kingdom_lv_config", "app." .. LocalTblPath .. ".config_server.kingdom_lv_config"
		for k, v in pairs(kingdom_lv_config) do
			kingdomLvConfig[v.kingdomLv] = v
			v.buff = serviceFunctions.tableFormatToMap(v.buff)
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.rewards = serviceFunctions.tableFormat(v.rewards, nil)
			v.castleMin = v.castleLV[1] or 0
			v.castleMax = v.castleLV[2] or 0
			v.castleLV = nil
		end
		_ENV = (for generator)
		pairs(kingdom_lv_config).kingdomLvConfig = kingdomLvConfig
		return pairs(kingdom_lv_config)
	end
	kingdomLevelltCtrl:defineValue("data", createConfig)
end
init()
function kingdomLevelltCtrl:getUpgradeNeedExp(kingdomLevel)
	return self:getKingdomLvConfigProperty(kingdomLevel, "needExp")
end
function kingdomLevelltCtrl:getDailyExpLimit(kingdomLevel)
	return self:getKingdomLvConfigProperty(kingdomLevel, "limit")
end
function kingdomLevelltCtrl:getBuffList(kingdomLevel)
	return self:getKingdomLvConfigProperty(kingdomLevel, "buff")
end
function kingdomLevelltCtrl:getCostResBuffCastleLevelMin(kingdomLevel)
	return self:getKingdomLvConfigProperty(kingdomLevel, "castleMin")
end
function kingdomLevelltCtrl:getCostResBuffCastleLevelMax(kingdomLevel)
	return self:getKingdomLvConfigProperty(kingdomLevel, "castleMax")
end
function kingdomLevelltCtrl:buffValid(effectType, kingdomLevel, castleLevel)
	if gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE == effectType then
		local castleMin = self:getKingdomLvConfigProperty(kingdomLevel, "castleMin")
		local castleMax = self:getKingdomLvConfigProperty(kingdomLevel, "castleMax")
		if castleLevel and castleMin and castleMax and castleLevel >= castleMin and castleLevel <= castleMax then
			return true
		end
		return false
	else
		local castleMin = self:getBuffValidCastleLvMin()
		if castleLevel and castleMin and castleLevel >= castleMin then
			return true
		end
		return false
	end
end
function kingdomLevelltCtrl:getBuffValidCastleLvMin()
	return 6
end
function kingdomLevelltCtrl:getBuff(kingdomLevel, effectType)
	if not effectType then
		return
	end
	local buffList = self:getBuffList(kingdomLevel)
	return buffList[effectType]
end
function kingdomLevelltCtrl:getRewards(kingdomLevel)
	local rewards = self:getKingdomLvConfigProperty(kingdomLevel, "rewards")
	if rewards then
		return serviceFunctions.table_copy_table(rewards)
	end
end
function kingdomLevelltCtrl:getKingdomLvConfigProperty(kingdomLevel, propertyName)
	local config = kingdomLevel and self.data.kingdomLvConfig[kingdomLevel]
	if config then
		return config[propertyName]
	end
end
return kingdomLevelltCtrl
