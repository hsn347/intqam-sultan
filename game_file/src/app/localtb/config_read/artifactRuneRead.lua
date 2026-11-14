local artifactRuneRead = include("aAReadClass").new()
local _ENV, runeMaxCfg = "aAReadClass", "aAReadClass"
local _ENV, _ENV, attrMaxCfg
;(nil)[1] = cc.c3b(116, 110, 101)
;(nil)[2] = cc.c3b(48, 94, 33)
;(nil)[3] = cc.c3b(37, 79, 105)
;(nil)[4] = cc.c3b(79, 37, 98)
local _ENV, (nil)[5], unActiveColorCfg = cc.c3b(114, 67, 11), cc.c3b(114, 67, 11), nil
cc.c3b(114, 67, 11)[1] = cc.c3b(255, 255, 255)
cc.c3b(114, 67, 11)[2] = cc.c3b(76, 230, 26)
cc.c3b(114, 67, 11)[3] = cc.c3b(62, 170, 238)
cc.c3b(114, 67, 11)[4] = cc.c3b(182, 43, 246)
local cc.c3b(114, 67, 11)[5], activeColorCfg = cc.c3b(210, 75, 1), cc.c3b(114, 67, 11)
artifactRuneRead.isInit = false
function artifactRuneRead.init()
	if artifactRuneRead.isInit then
		return
	end
	artifactRuneRead.isInit = true
	runeMaxCfg = nil
	;(nil)[1] = "multipleconfig"
	;(nil)[2] = true
	artifactRuneRead:defineValue("multipleconfig", nil)
	runeMaxCfg = nil
	;(nil)[1] = "luckyvalueconfig"
	;(nil)[2] = true
	artifactRuneRead:defineValue("luckyvalueconfig", nil)
	runeMaxCfg = nil
	;(nil)[1] = "rune_constant"
	;(nil)[2] = true
	artifactRuneRead:defineValue("constant", nil)
	artifactRuneRead.constant = artifactRuneRead.constant[1]
	runeMaxCfg = nil
	;(nil)[1] = "artifact_rune_hole"
	;(nil)[2] = true
	artifactRuneRead:defineValue("hole", nil)
	artifactRuneRead:defineValue("holeConfig", function()
		local _ENV, ret
		for k, v in pairs(artifactRuneRead.hole) do
			if not ret[v.type] then
				_ENV = ret[v.type]
			end
			ret[v.type] = ret[v.type]
			if not ret[v.type][v.WeaponID] then
				_ENV = ret[v.type][v.WeaponID]
			end
			ret[v.type][v.WeaponID] = ret[v.type][v.WeaponID]
			table.insert(ret[v.type][v.WeaponID], v)
		end
		return ret
	end)
	artifactRuneRead:defineValue("holeMap", function()
		local _ENV, ret
		for k, v in ipairs(artifactRuneRead.hole) do
			if not ret[v.WeaponID] then
				ret[v.WeaponID] = v
			end
		end
		return ret
	end)
	function runeMaxCfg()
		local _ENV, ret
		for k, v in ipairs(artifactRuneRead.hole) do
			if not ret[v.WeaponID] then
				ret[v.WeaponID] = v
			end
		end
		return ret
	end
	;(function()
		local _ENV, ret
		for k, v in ipairs(artifactRuneRead.hole) do
			if not ret[v.WeaponID] then
				ret[v.WeaponID] = v
			end
		end
		return ret
	end)[1] = "rune_config"
	;(function()
		local _ENV, ret
		for k, v in ipairs(artifactRuneRead.hole) do
			if not ret[v.WeaponID] then
				ret[v.WeaponID] = v
			end
		end
		return ret
	end)[2] = true
	artifactRuneRead:defineValue("config", function()
		local _ENV, ret
		for k, v in ipairs(artifactRuneRead.hole) do
			if not ret[v.WeaponID] then
				ret[v.WeaponID] = v
			end
		end
		return ret
	end)
	artifactRuneRead:defineValue("rune_map", function()
		artifactRuneRead.rune_map, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_config")
		for k, v in pairs(cfg) do
			artifactRuneRead.rune_map[k] = clone(v)
			artifactRuneRead = clone(v)
			clone(v).buffType = v.BasicProperties[1]
			clone(v).buffMode = v.BasicProperties[2]
			clone(v).buffVal = v.BasicProperties[3]
			artifactRuneRead.rune_map[k].BasicProperties, clone(v).growType = clone(v), v.BasicProperties[4]
		end
		return artifactRuneRead.rune_map
	end)
	function runeMaxCfg()
		artifactRuneRead.rune_map, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_config")
		for k, v in pairs(cfg) do
			artifactRuneRead.rune_map[k] = clone(v)
			artifactRuneRead = clone(v)
			clone(v).buffType = v.BasicProperties[1]
			clone(v).buffMode = v.BasicProperties[2]
			clone(v).buffVal = v.BasicProperties[3]
			artifactRuneRead.rune_map[k].BasicProperties, clone(v).growType = clone(v), v.BasicProperties[4]
		end
		return artifactRuneRead.rune_map
	end
	;(function()
		artifactRuneRead.rune_map, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_config")
		for k, v in pairs(cfg) do
			artifactRuneRead.rune_map[k] = clone(v)
			artifactRuneRead = clone(v)
			clone(v).buffType = v.BasicProperties[1]
			clone(v).buffMode = v.BasicProperties[2]
			clone(v).buffVal = v.BasicProperties[3]
			artifactRuneRead.rune_map[k].BasicProperties, clone(v).growType = clone(v), v.BasicProperties[4]
		end
		return artifactRuneRead.rune_map
	end)[1] = "artifact_suit_config"
	;(function()
		artifactRuneRead.rune_map, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_config")
		for k, v in pairs(cfg) do
			artifactRuneRead.rune_map[k] = clone(v)
			artifactRuneRead = clone(v)
			clone(v).buffType = v.BasicProperties[1]
			clone(v).buffMode = v.BasicProperties[2]
			clone(v).buffVal = v.BasicProperties[3]
			artifactRuneRead.rune_map[k].BasicProperties, clone(v).growType = clone(v), v.BasicProperties[4]
		end
		return artifactRuneRead.rune_map
	end)[2] = true
	artifactRuneRead:defineValue("suit", function()
		artifactRuneRead.rune_map, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_config")
		for k, v in pairs(cfg) do
			artifactRuneRead.rune_map[k] = clone(v)
			artifactRuneRead = clone(v)
			clone(v).buffType = v.BasicProperties[1]
			clone(v).buffMode = v.BasicProperties[2]
			clone(v).buffVal = v.BasicProperties[3]
			artifactRuneRead.rune_map[k].BasicProperties, clone(v).growType = clone(v), v.BasicProperties[4]
		end
		return artifactRuneRead.rune_map
	end)
	artifactRuneRead:defineValue("suitConfig", function()
		local _ENV, ret
		for k, v in pairs(artifactRuneRead.suit) do
			if not ret[v.type] then
				_ENV = ret[v.type]
			end
			ret[v.type] = ret[v.type]
			ret[v.type][v.WeaponID] = v
		end
		return ret
	end)
	function runeMaxCfg()
		local _ENV, ret
		for k, v in pairs(artifactRuneRead.suit) do
			if not ret[v.type] then
				_ENV = ret[v.type]
			end
			ret[v.type] = ret[v.type]
			ret[v.type][v.WeaponID] = v
		end
		return ret
	end
	;(function()
		local _ENV, ret
		for k, v in pairs(artifactRuneRead.suit) do
			if not ret[v.type] then
				_ENV = ret[v.type]
			end
			ret[v.type] = ret[v.type]
			ret[v.type][v.WeaponID] = v
		end
		return ret
	end)[1] = "rune_level_config"
	;(function()
		local _ENV, ret
		for k, v in pairs(artifactRuneRead.suit) do
			if not ret[v.type] then
				_ENV = ret[v.type]
			end
			ret[v.type] = ret[v.type]
			ret[v.type][v.WeaponID] = v
		end
		return ret
	end)[2] = true
	artifactRuneRead:defineValue("level", function()
		local _ENV, ret
		for k, v in pairs(artifactRuneRead.suit) do
			if not ret[v.type] then
				_ENV = ret[v.type]
			end
			ret[v.type] = ret[v.type]
			ret[v.type][v.WeaponID] = v
		end
		return ret
	end)
	artifactRuneRead:defineValue("levelCfg", function()
		artifactRuneRead.levelCfg, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_level_config")
		for k, v in ipairs(cfg) do
			if not artifactRuneRead.levelCfg[v.ExpGrowingType] then
				artifactRuneRead.levelCfg[v.ExpGrowingType], artifactRuneRead = nil, nil
			end
			if not runeMaxCfg[v.season] then
				runeMaxCfg[v.season] = 1
			end
			runeMaxCfg[v.season] = math.max(runeMaxCfg[v.season], v.Slevel)
			artifactRuneRead.levelCfg[v.ExpGrowingType][v.Slevel] = v
		end
		return artifactRuneRead.levelCfg
	end)
	artifactRuneRead:defineValue("levelMax", function()
		artifactRuneRead.levelMax, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_level_config")
		for k, v in ipairs(cfg) do
			if not artifactRuneRead.levelMax[v.ExpGrowingType] then
				artifactRuneRead.levelMax[v.ExpGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.levelMax[v.ExpGrowingType][v.season] = math.max(artifactRuneRead.levelMax[v.ExpGrowingType][v.season] or 1, v.Slevel)
		end
		return artifactRuneRead.levelMax
	end)
	function runeMaxCfg()
		artifactRuneRead.levelMax, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_level_config")
		for k, v in ipairs(cfg) do
			if not artifactRuneRead.levelMax[v.ExpGrowingType] then
				artifactRuneRead.levelMax[v.ExpGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.levelMax[v.ExpGrowingType][v.season] = math.max(artifactRuneRead.levelMax[v.ExpGrowingType][v.season] or 1, v.Slevel)
		end
		return artifactRuneRead.levelMax
	end
	;(function()
		artifactRuneRead.levelMax, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_level_config")
		for k, v in ipairs(cfg) do
			if not artifactRuneRead.levelMax[v.ExpGrowingType] then
				artifactRuneRead.levelMax[v.ExpGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.levelMax[v.ExpGrowingType][v.season] = math.max(artifactRuneRead.levelMax[v.ExpGrowingType][v.season] or 1, v.Slevel)
		end
		return artifactRuneRead.levelMax
	end)[1] = "artifact_suit_skill"
	;(function()
		artifactRuneRead.levelMax, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_level_config")
		for k, v in ipairs(cfg) do
			if not artifactRuneRead.levelMax[v.ExpGrowingType] then
				artifactRuneRead.levelMax[v.ExpGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.levelMax[v.ExpGrowingType][v.season] = math.max(artifactRuneRead.levelMax[v.ExpGrowingType][v.season] or 1, v.Slevel)
		end
		return artifactRuneRead.levelMax
	end)[2] = true
	artifactRuneRead:defineValue("suit_skill", function()
		artifactRuneRead.levelMax, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_level_config")
		for k, v in ipairs(cfg) do
			if not artifactRuneRead.levelMax[v.ExpGrowingType] then
				artifactRuneRead.levelMax[v.ExpGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.levelMax[v.ExpGrowingType][v.season] = math.max(artifactRuneRead.levelMax[v.ExpGrowingType][v.season] or 1, v.Slevel)
		end
		return artifactRuneRead.levelMax
	end)
	function runeMaxCfg()
		artifactRuneRead.levelMax, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_level_config")
		for k, v in ipairs(cfg) do
			if not artifactRuneRead.levelMax[v.ExpGrowingType] then
				artifactRuneRead.levelMax[v.ExpGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.levelMax[v.ExpGrowingType][v.season] = math.max(artifactRuneRead.levelMax[v.ExpGrowingType][v.season] or 1, v.Slevel)
		end
		return artifactRuneRead.levelMax
	end
	;(function()
		artifactRuneRead.levelMax, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_level_config")
		for k, v in ipairs(cfg) do
			if not artifactRuneRead.levelMax[v.ExpGrowingType] then
				artifactRuneRead.levelMax[v.ExpGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.levelMax[v.ExpGrowingType][v.season] = math.max(artifactRuneRead.levelMax[v.ExpGrowingType][v.season] or 1, v.Slevel)
		end
		return artifactRuneRead.levelMax
	end)[1] = "rune_property_config"
	;(function()
		artifactRuneRead.levelMax, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_level_config")
		for k, v in ipairs(cfg) do
			if not artifactRuneRead.levelMax[v.ExpGrowingType] then
				artifactRuneRead.levelMax[v.ExpGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.levelMax[v.ExpGrowingType][v.season] = math.max(artifactRuneRead.levelMax[v.ExpGrowingType][v.season] or 1, v.Slevel)
		end
		return artifactRuneRead.levelMax
	end)[2] = true
	artifactRuneRead:defineValue("property", function()
		artifactRuneRead.levelMax, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_level_config")
		for k, v in ipairs(cfg) do
			if not artifactRuneRead.levelMax[v.ExpGrowingType] then
				artifactRuneRead.levelMax[v.ExpGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.levelMax[v.ExpGrowingType][v.season] = math.max(artifactRuneRead.levelMax[v.ExpGrowingType][v.season] or 1, v.Slevel)
		end
		return artifactRuneRead.levelMax
	end)
	function runeMaxCfg()
		artifactRuneRead.levelMax, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_level_config")
		for k, v in ipairs(cfg) do
			if not artifactRuneRead.levelMax[v.ExpGrowingType] then
				artifactRuneRead.levelMax[v.ExpGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.levelMax[v.ExpGrowingType][v.season] = math.max(artifactRuneRead.levelMax[v.ExpGrowingType][v.season] or 1, v.Slevel)
		end
		return artifactRuneRead.levelMax
	end
	;(function()
		artifactRuneRead.levelMax, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_level_config")
		for k, v in ipairs(cfg) do
			if not artifactRuneRead.levelMax[v.ExpGrowingType] then
				artifactRuneRead.levelMax[v.ExpGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.levelMax[v.ExpGrowingType][v.season] = math.max(artifactRuneRead.levelMax[v.ExpGrowingType][v.season] or 1, v.Slevel)
		end
		return artifactRuneRead.levelMax
	end)[1] = "rune_property_strengthen"
	;(function()
		artifactRuneRead.levelMax, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_level_config")
		for k, v in ipairs(cfg) do
			if not artifactRuneRead.levelMax[v.ExpGrowingType] then
				artifactRuneRead.levelMax[v.ExpGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.levelMax[v.ExpGrowingType][v.season] = math.max(artifactRuneRead.levelMax[v.ExpGrowingType][v.season] or 1, v.Slevel)
		end
		return artifactRuneRead.levelMax
	end)[2] = true
	artifactRuneRead:defineValue("strengthen", function()
		artifactRuneRead.levelMax, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_level_config")
		for k, v in ipairs(cfg) do
			if not artifactRuneRead.levelMax[v.ExpGrowingType] then
				artifactRuneRead.levelMax[v.ExpGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.levelMax[v.ExpGrowingType][v.season] = math.max(artifactRuneRead.levelMax[v.ExpGrowingType][v.season] or 1, v.Slevel)
		end
		return artifactRuneRead.levelMax
	end)
	artifactRuneRead:defineValue("rpsCfg", function()
		artifactRuneRead.rpsCfg, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_property_strengthen")
		for k, v in ipairs(cfg) do
			if not artifactRuneRead.rpsCfg[v.Season] then
				artifactRuneRead.rpsCfg[v.Season], artifactRuneRead = nil, nil
			end
			artifactRuneRead.rpsCfg[v.Season][v.RuneClass] = math.max(v.Level, artifactRuneRead.rpsCfg[v.Season][v.RuneClass] or 1)
		end
		return artifactRuneRead.rpsCfg
	end)
	artifactRuneRead:defineValue("propertiescfg", function()
		artifactRuneRead.propertiescfg, artifactRuneRead = nil, nil
		local cfg1 = require_once("app." .. LocalTblPath .. ".config_server.rune_properties_level_config")
		local cfg2 = require_once("app." .. LocalTblPath .. ".config_server.properties_level_config")
		for k, v in ipairs(cfg1) do
			if not artifactRuneRead.propertiescfg[v.PropertiesGrowingType] then
				artifactRuneRead.propertiescfg[v.PropertiesGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.propertiescfg[v.PropertiesGrowingType][v.Slevel] = v
		end
		for k, v in ipairs(cfg2) do
			if not artifactRuneRead.propertiescfg[v.PropertiesGrowingType] then
				artifactRuneRead.propertiescfg[v.PropertiesGrowingType], artifactRuneRead = nil, nil
			end
			for i = v.Slevel[1], v.Slevel[2] do
				artifactRuneRead = v.PropertiesGrowingType
				v.PropertiesGrowingType.ID = v.ID
				v.PropertiesGrowingType.PropertiesGrowingType = v.PropertiesGrowingType
				v.PropertiesGrowingType.Slevel = i
				v.PropertiesGrowingType.GrowingValue = v.GrowingValue[1] + (i - 1) * v.GrowingValue[2]
				artifactRuneRead.propertiescfg[v.PropertiesGrowingType][i], v.PropertiesGrowingType.Power = v.PropertiesGrowingType, v.Power[1] + (i - 1) * v.Power[2]
			end
			attrMaxCfg[v.PropertiesGrowingType] = v.Slevel[2]
		end
		return artifactRuneRead.propertiescfg
	end)
	function runeMaxCfg()
		artifactRuneRead.propertiescfg, artifactRuneRead = nil, nil
		local cfg1 = require_once("app." .. LocalTblPath .. ".config_server.rune_properties_level_config")
		local cfg2 = require_once("app." .. LocalTblPath .. ".config_server.properties_level_config")
		for k, v in ipairs(cfg1) do
			if not artifactRuneRead.propertiescfg[v.PropertiesGrowingType] then
				artifactRuneRead.propertiescfg[v.PropertiesGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.propertiescfg[v.PropertiesGrowingType][v.Slevel] = v
		end
		for k, v in ipairs(cfg2) do
			if not artifactRuneRead.propertiescfg[v.PropertiesGrowingType] then
				artifactRuneRead.propertiescfg[v.PropertiesGrowingType], artifactRuneRead = nil, nil
			end
			for i = v.Slevel[1], v.Slevel[2] do
				artifactRuneRead = v.PropertiesGrowingType
				v.PropertiesGrowingType.ID = v.ID
				v.PropertiesGrowingType.PropertiesGrowingType = v.PropertiesGrowingType
				v.PropertiesGrowingType.Slevel = i
				v.PropertiesGrowingType.GrowingValue = v.GrowingValue[1] + (i - 1) * v.GrowingValue[2]
				artifactRuneRead.propertiescfg[v.PropertiesGrowingType][i], v.PropertiesGrowingType.Power = v.PropertiesGrowingType, v.Power[1] + (i - 1) * v.Power[2]
			end
			attrMaxCfg[v.PropertiesGrowingType] = v.Slevel[2]
		end
		return artifactRuneRead.propertiescfg
	end
	;(function()
		artifactRuneRead.propertiescfg, artifactRuneRead = nil, nil
		local cfg1 = require_once("app." .. LocalTblPath .. ".config_server.rune_properties_level_config")
		local cfg2 = require_once("app." .. LocalTblPath .. ".config_server.properties_level_config")
		for k, v in ipairs(cfg1) do
			if not artifactRuneRead.propertiescfg[v.PropertiesGrowingType] then
				artifactRuneRead.propertiescfg[v.PropertiesGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.propertiescfg[v.PropertiesGrowingType][v.Slevel] = v
		end
		for k, v in ipairs(cfg2) do
			if not artifactRuneRead.propertiescfg[v.PropertiesGrowingType] then
				artifactRuneRead.propertiescfg[v.PropertiesGrowingType], artifactRuneRead = nil, nil
			end
			for i = v.Slevel[1], v.Slevel[2] do
				artifactRuneRead = v.PropertiesGrowingType
				v.PropertiesGrowingType.ID = v.ID
				v.PropertiesGrowingType.PropertiesGrowingType = v.PropertiesGrowingType
				v.PropertiesGrowingType.Slevel = i
				v.PropertiesGrowingType.GrowingValue = v.GrowingValue[1] + (i - 1) * v.GrowingValue[2]
				artifactRuneRead.propertiescfg[v.PropertiesGrowingType][i], v.PropertiesGrowingType.Power = v.PropertiesGrowingType, v.Power[1] + (i - 1) * v.Power[2]
			end
			attrMaxCfg[v.PropertiesGrowingType] = v.Slevel[2]
		end
		return artifactRuneRead.propertiescfg
	end)[1] = "random_property_pool"
	;(function()
		artifactRuneRead.propertiescfg, artifactRuneRead = nil, nil
		local cfg1 = require_once("app." .. LocalTblPath .. ".config_server.rune_properties_level_config")
		local cfg2 = require_once("app." .. LocalTblPath .. ".config_server.properties_level_config")
		for k, v in ipairs(cfg1) do
			if not artifactRuneRead.propertiescfg[v.PropertiesGrowingType] then
				artifactRuneRead.propertiescfg[v.PropertiesGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.propertiescfg[v.PropertiesGrowingType][v.Slevel] = v
		end
		for k, v in ipairs(cfg2) do
			if not artifactRuneRead.propertiescfg[v.PropertiesGrowingType] then
				artifactRuneRead.propertiescfg[v.PropertiesGrowingType], artifactRuneRead = nil, nil
			end
			for i = v.Slevel[1], v.Slevel[2] do
				artifactRuneRead = v.PropertiesGrowingType
				v.PropertiesGrowingType.ID = v.ID
				v.PropertiesGrowingType.PropertiesGrowingType = v.PropertiesGrowingType
				v.PropertiesGrowingType.Slevel = i
				v.PropertiesGrowingType.GrowingValue = v.GrowingValue[1] + (i - 1) * v.GrowingValue[2]
				artifactRuneRead.propertiescfg[v.PropertiesGrowingType][i], v.PropertiesGrowingType.Power = v.PropertiesGrowingType, v.Power[1] + (i - 1) * v.Power[2]
			end
			attrMaxCfg[v.PropertiesGrowingType] = v.Slevel[2]
		end
		return artifactRuneRead.propertiescfg
	end)[2] = true
	artifactRuneRead:defineValue("pool", function()
		artifactRuneRead.propertiescfg, artifactRuneRead = nil, nil
		local cfg1 = require_once("app." .. LocalTblPath .. ".config_server.rune_properties_level_config")
		local cfg2 = require_once("app." .. LocalTblPath .. ".config_server.properties_level_config")
		for k, v in ipairs(cfg1) do
			if not artifactRuneRead.propertiescfg[v.PropertiesGrowingType] then
				artifactRuneRead.propertiescfg[v.PropertiesGrowingType], artifactRuneRead = nil, nil
			end
			artifactRuneRead.propertiescfg[v.PropertiesGrowingType][v.Slevel] = v
		end
		for k, v in ipairs(cfg2) do
			if not artifactRuneRead.propertiescfg[v.PropertiesGrowingType] then
				artifactRuneRead.propertiescfg[v.PropertiesGrowingType], artifactRuneRead = nil, nil
			end
			for i = v.Slevel[1], v.Slevel[2] do
				artifactRuneRead = v.PropertiesGrowingType
				v.PropertiesGrowingType.ID = v.ID
				v.PropertiesGrowingType.PropertiesGrowingType = v.PropertiesGrowingType
				v.PropertiesGrowingType.Slevel = i
				v.PropertiesGrowingType.GrowingValue = v.GrowingValue[1] + (i - 1) * v.GrowingValue[2]
				artifactRuneRead.propertiescfg[v.PropertiesGrowingType][i], v.PropertiesGrowingType.Power = v.PropertiesGrowingType, v.Power[1] + (i - 1) * v.Power[2]
			end
			attrMaxCfg[v.PropertiesGrowingType] = v.Slevel[2]
		end
		return artifactRuneRead.propertiescfg
	end)
	artifactRuneRead:defineValue("heritcost", function()
		artifactRuneRead.heritcost, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.rune_heritcost")
		for k, v in ipairs(cfg) do
			if not artifactRuneRead.heritcost[v.HeritType] then
				artifactRuneRead.heritcost[v.HeritType], artifactRuneRead = nil, nil
			end
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			artifactRuneRead.heritcost[v.HeritType][v.PropertyQuality] = serviceFunctions.tableFormat(v.Cost, nil)
		end
		return artifactRuneRead.heritcost
	end)
	artifactRuneRead:defineValue("skip", function()
		artifactRuneRead.skip, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.artifact_rune_skip")
		for k, v in ipairs(cfg) do
			artifactRuneRead.skip[v.HoleType] = v.Item
		end
		return artifactRuneRead.skip
	end)
	function runeMaxCfg()
		artifactRuneRead.skip, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.artifact_rune_skip")
		for k, v in ipairs(cfg) do
			artifactRuneRead.skip[v.HoleType] = v.Item
		end
		return artifactRuneRead.skip
	end
	;(function()
		artifactRuneRead.skip, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.artifact_rune_skip")
		for k, v in ipairs(cfg) do
			artifactRuneRead.skip[v.HoleType] = v.Item
		end
		return artifactRuneRead.skip
	end)[1] = "rune_return"
	;(function()
		artifactRuneRead.skip, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.artifact_rune_skip")
		for k, v in ipairs(cfg) do
			artifactRuneRead.skip[v.HoleType] = v.Item
		end
		return artifactRuneRead.skip
	end)[2] = true
	artifactRuneRead:defineValue("rune_return", function()
		artifactRuneRead.skip, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.artifact_rune_skip")
		for k, v in ipairs(cfg) do
			artifactRuneRead.skip[v.HoleType] = v.Item
		end
		return artifactRuneRead.skip
	end)
	function runeMaxCfg()
		artifactRuneRead.skip, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.artifact_rune_skip")
		for k, v in ipairs(cfg) do
			artifactRuneRead.skip[v.HoleType] = v.Item
		end
		return artifactRuneRead.skip
	end
	;(function()
		artifactRuneRead.skip, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.artifact_rune_skip")
		for k, v in ipairs(cfg) do
			artifactRuneRead.skip[v.HoleType] = v.Item
		end
		return artifactRuneRead.skip
	end)[1] = "artifact_rune_set_config"
	;(function()
		artifactRuneRead.skip, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.artifact_rune_skip")
		for k, v in ipairs(cfg) do
			artifactRuneRead.skip[v.HoleType] = v.Item
		end
		return artifactRuneRead.skip
	end)[2] = true
	artifactRuneRead:defineValue("rune_set", function()
		artifactRuneRead.skip, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.artifact_rune_skip")
		for k, v in ipairs(cfg) do
			artifactRuneRead.skip[v.HoleType] = v.Item
		end
		return artifactRuneRead.skip
	end)
	function runeMaxCfg()
		artifactRuneRead.skip, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.artifact_rune_skip")
		for k, v in ipairs(cfg) do
			artifactRuneRead.skip[v.HoleType] = v.Item
		end
		return artifactRuneRead.skip
	end
	;(function()
		artifactRuneRead.skip, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.artifact_rune_skip")
		for k, v in ipairs(cfg) do
			artifactRuneRead.skip[v.HoleType] = v.Item
		end
		return artifactRuneRead.skip
	end)[1] = "artifact_rune_limit"
	;(function()
		artifactRuneRead.skip, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.artifact_rune_skip")
		for k, v in ipairs(cfg) do
			artifactRuneRead.skip[v.HoleType] = v.Item
		end
		return artifactRuneRead.skip
	end)[2] = true
	artifactRuneRead:defineValue("artifact_rune_limit", function()
		artifactRuneRead.skip, artifactRuneRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.artifact_rune_skip")
		for k, v in ipairs(cfg) do
			artifactRuneRead.skip[v.HoleType] = v.Item
		end
		return artifactRuneRead.skip
	end)
end
artifactRuneRead.init()
function artifactRuneRead.getLimitSeaonCfg(season)
	local isUnLock = false
	local classLimit, levlLimit, unlockClass, unlockLevel
	local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
	local activity_9001656_Ctrl = SoraDGetCtrl("activity_9001656_Ctrl")
	for k, v in ipairs(artifactRuneRead.artifact_rune_limit) do
		if v.season == season then
			classLimit = v.classLimit
			levlLimit = v.levlLimit
			if artifactRuneRead.isSuitPrepareForWar() then
				unlockClass = activity_9001656_Ctrl:getMileStoneValue(v.classFunction)
				unlockLevel = activity_9001656_Ctrl:getMileStoneValue(v.levelFunction)
			else
				unlockClass = nebulaMileStoneCtrl:getPlusByUnlockType(v.classFunction)
				unlockLevel = nebulaMileStoneCtrl:getPlusByUnlockType(v.levelFunction)
			end
			isUnLock = unlockClass and unlockLevel and true or false
		end
	end
	if isUnLock then
		classLimit = unlockClass
		levlLimit = unlockLevel
	end
	levlLimit = math.min(levlLimit, artifactRuneRead.getConfigMaxLv(season))
	print("isUnLock,classLimit,levlLimit===", isUnLock, classLimit, levlLimit)
	return isUnLock, classLimit, levlLimit
end
function artifactRuneRead.getRuneLimitLv(rid)
	local cfg = artifactRuneRead.getRuneConfig(rid)
	return artifactRuneRead.levelMax[cfg.ExpGrowingType][cfg.Season]
end
function artifactRuneRead.getRemakeCfg()
	return artifactRuneRead.constant.RemakeCost[1], artifactRuneRead.constant.RemakeCost[2]
end
function artifactRuneRead.getLockCost(num)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local cfg = serviceFunctions.tableFormat(artifactRuneRead.constant.LockCost, nil)
	return cfg[num]
end
function artifactRuneRead.getInheritCfg(heritType, quality)
	return artifactRuneRead.heritcost[heritType][quality]
end
function artifactRuneRead.getUnlockCfg()
	return artifactRuneRead.constant.UnlockCondition[1], artifactRuneRead.constant.UnlockCondition[2]
end
function artifactRuneRead.getRuneBagLimit()
	return artifactRuneRead.constant.RuneBagLimit
end
function artifactRuneRead.getRuneClassRare()
	return artifactRuneRead.constant.RuneClassRare
end
function artifactRuneRead.getRuneExpRuneUnitMax()
	return artifactRuneRead.constant.ExpRuneUnitMax
end
function artifactRuneRead.checkCostRune()
	return artifactRuneRead.constant.RuneCostType ~= 0
end
function artifactRuneRead.getRuneHeritRatio()
	return artifactRuneRead.constant.HeritRatio
end
function artifactRuneRead.getHoleInfo(weaponID)
	local _ENV, info
	local nebulaWarUtil = include("nebulaWarUtil")
	local group = nebulaWarUtil.getRegionGroup()
	if not artifactRuneRead.holeConfig[group][weaponID] then
		_ENV = artifactRuneRead.holeConfig[group][weaponID]
	end
	for i, v in ipairs(artifactRuneRead.holeConfig[group][weaponID]) do
		if v.Unlock[1] == 3 then
			_ENV = nil
			_ENV, (nil).HoleType = v.HoleType, v.HoleType
			v.HoleType.key = v.Unlock[1]
			v.HoleType.val = v.Unlock[2]
			info[v.PlaceNo], (nil).Unlock, v.HoleType.lv = nil, v.HoleType, v.Unlock[3]
		else
			_ENV = nil
			_ENV, (nil).HoleType = v.HoleType, v.HoleType
			v.HoleType.key = v.Unlock[1]
			info[v.PlaceNo], (nil).Unlock, v.HoleType.val = nil, v.HoleType, v.Unlock[2]
		end
	end
	return info
end
function artifactRuneRead.getRuneConfig(rid)
	if rid then
		return artifactRuneRead.config[rid]
	end
	return artifactRuneRead.config
end
function artifactRuneRead.isartifactRune(itemID)
	if artifactRuneRead.config[itemID] then
		return true
	end
	return false
end
function artifactRuneRead.getPropertyActivationClass(rid, index)
	local cfg = artifactRuneRead.config[rid]
	if cfg then
		return cfg.PropertyActivationClass[index]
	end
end
function artifactRuneRead.getRuneInfo(id)
	return artifactRuneRead.rune_map[id]
end
function artifactRuneRead.getRuneGrowType(rid)
	local cfg = artifactRuneRead.config[rid]
	if cfg then
		return cfg.BasicProperties[4]
	end
end
function artifactRuneRead.getRuneBasicProperties(rid)
	local cfg = artifactRuneRead.config[rid]
	if cfg then
		return cfg.BasicProperties[1], cfg.BasicProperties[2], cfg.BasicProperties[3]
	end
end
function artifactRuneRead.getRuneHeritType(rid)
	local cfg = artifactRuneRead.config[rid]
	if cfg then
		return cfg.HeritType
	end
end
function artifactRuneRead.getRuneSeason(rid)
	local cfg = artifactRuneRead.config[rid]
	if cfg then
		return cfg.Season
	end
end
function artifactRuneRead.getRuneSubscript(rid)
	local cfg = artifactRuneRead.config[rid]
	if cfg and cfg.subscript ~= "" then
		return cfg.subscript
	end
end
function artifactRuneRead.getRuneExpGrowingType(rid)
	local cfg = artifactRuneRead.config[rid]
	if cfg then
		return cfg.ExpGrowingType
	end
end
function artifactRuneRead.getRuneName(rid)
	local cfg = artifactRuneRead.config[rid]
	if cfg then
		return i18n(cfg.RuneName)
	end
end
function artifactRuneRead.getRuneDes(rid)
	local cfg = artifactRuneRead.config[rid]
	if cfg then
		return i18n(cfg.RuneDes)
	end
end
function artifactRuneRead.getRuneIcon(rid)
	local cfg = artifactRuneRead.config[rid]
	if cfg then
		return cfg.Runelcon
	end
end
function artifactRuneRead.getRuneCfgByType(runeType)
	local _ENV, cfg
	for id, v in pairs(artifactRuneRead.config) do
		if runeType == 0 then
			if v.RuneType ~= 5 then
				table.insert(cfg, id)
			end
		elseif v.RuneType == runeType then
			table.insert(cfg, id)
		end
	end
	table.sort(cfg)
	return cfg
end
function artifactRuneRead.getSuitInfo(id)
	local _ENV, info
	local nebulaWarUtil = include("nebulaWarUtil")
	local group = nebulaWarUtil.getRegionGroup()
	local cfg = artifactRuneRead.suitConfig[group][id]
	if cfg then
		for i = 1, #cfg.SuitCondition do
			_ENV = nil
			;(nil).lv = cfg.SuitCondition[i]
			;(nil).skill = cfg.SuitSkill[i]
			table.insert(info, nil)
		end
		table.sort(info, function(a, b)
			return a.lv < b.lv
		end)
	end
	return info
end
function artifactRuneRead.getRuneClass(id, level)
	local ExpGrowingType = artifactRuneRead.getRuneExpGrowingType(id)
	return artifactRuneRead.levelCfg[ExpGrowingType][level].Class
end
function artifactRuneRead.getRuneCLevel(id, level)
	local ExpGrowingType = artifactRuneRead.getRuneExpGrowingType(id)
	return artifactRuneRead.levelCfg[ExpGrowingType][level].Level
end
function artifactRuneRead.getRuneLvCfg(ExpGrowingType, Slevel)
	return artifactRuneRead.levelCfg[ExpGrowingType][Slevel]
end
function artifactRuneRead.getRuneMaxClassAndLv(ExpGrowingType)
	local class = 0
	local lv = 1
	for k, v in ipairs(artifactRuneRead.level) do
		if v.ExpGrowingType == ExpGrowingType then
			class = math.max(class, v.Class)
			lv = math.max(lv, v.Slevel)
		end
	end
	return class, lv
end
function artifactRuneRead.getMaxSLevel(ExpGrowingType, Class)
	local level = 0
	for k, v in ipairs(artifactRuneRead.level) do
		if v.ExpGrowingType == ExpGrowingType and v.Class == Class then
			level = math.max(level, v.Slevel)
		end
	end
	return level
end
function artifactRuneRead.getNeedEXP(ExpGrowingType, CurLv, CurExp)
	local exp = 0
	for k, v in ipairs(artifactRuneRead.level) do
		if v.ExpGrowingType == ExpGrowingType and CurLv <= v.Slevel then
			local isUnlock, classLimit, levlLimit = artifactRuneRead.getLimitSeaonCfg(v.season)
			local maxLv = levlLimit
			if next(v.AdviceClassRequire) or maxLv <= v.Slevel then
				break
			end
			exp = exp + v.Exp
		end
	end
	return exp - CurExp
end
function artifactRuneRead.getNewRuneLv(ExpGrowingType, CurLv, CurExp, TotalEXP, Season)
	local newLv = CurLv
	local newExp = CurExp
	local leftExp = TotalEXP + CurExp
	local isToLimit = false
	local deExp = 0
	local isUnlock, classLimit, levlLimit = artifactRuneRead.getLimitSeaonCfg(Season)
	local maxLv = levlLimit
	while 0 <= leftExp do
		if newLv >= maxLv then
			isToLimit = true
			newExp = TotalEXP + CurExp - deExp
			break
		end
		local lvCfg = artifactRuneRead.getRuneLvCfg(ExpGrowingType, newLv)
		if leftExp >= lvCfg.Exp then
			if next(lvCfg.AdviceClassRequire) then
				newLv = lvCfg.Slevel
				isToLimit = true
				newExp = math.abs(TotalEXP + CurExp - deExp)
				break
			end
			leftExp = math.abs(leftExp - lvCfg.Exp)
			newLv = lvCfg.Slevel + 1
			newExp = leftExp
			deExp = deExp + lvCfg.Exp
		else
			newLv = lvCfg.Slevel
			newExp = leftExp
			break
		end
	end
	return newLv, newExp, isToLimit
end
function artifactRuneRead.isCanAdvance(ExpGrowingType, Level)
	local ret = false
	local artifactRuneRead, cost
	local cfg = artifactRuneRead.getRuneLvCfg(ExpGrowingType, Level)
	if cfg and next(cfg.AdviceClassRequire) then
		ret = true
		_UPVALUE3_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "id"
		;(nil)[3] = "count"
		cost = serviceFunctions.tableFormat(cfg.AdviceClassRequire, nil)
	end
	return ret, cost
end
function artifactRuneRead.getTotalEXP(ExpGrowingType, Level, Exp)
	local lvExp = 0
	local exp = Exp or 0
	for k, v in ipairs(artifactRuneRead.level) do
		if v.ExpGrowingType == ExpGrowingType and Level > v.Slevel then
			lvExp = lvExp + v.Exp
		end
	end
	return lvExp + math.max(0, exp)
end
function artifactRuneRead.getInheritPreCost(extraProperty, ratio)
	local _ENV, ret_item
	local _ENV, ret
	for k, v in ipairs(extraProperty) do
		local array, quality, power, growType = artifactRuneRead.getPropertyArray(v[1])
		local costArray = artifactRuneRead.getTotalCost(growType, v[2])
		for id, count in pairs(costArray) do
			if ret_item[id] then
				ret_item[id] = ret_item[id] + count * ratio / 100
			else
				ret_item[id] = count * ratio / 100
			end
		end
	end
	for k, v in pairs(ret_item) do
		_ENV = artifactRuneRead.getPropertyArray(v[1])
		artifactRuneRead.getPropertyArray(v[1]).id = k
		artifactRuneRead.getPropertyArray(v[1]).count = math.floor(v)
		table.insert(ret, artifactRuneRead.getPropertyArray(v[1]))
	end
	table.sort(ret, function(a, b)
		return a.id < b.id
	end)
	return ret
end
function artifactRuneRead.getInheritPre(ExpGrowingType, Level, ratio, exp)
	local artifactRuneRead, itemArray
	local artifactRuneRead, runeArray
	local artifactRuneRead, expArray
	local ratio = ratio or artifactRuneRead.getRuneHeritRatio()
	local cfg = artifactRuneRead.getRuneLvCfg(ExpGrowingType, Level)
	local produceExp = cfg.ProduceExp * ratio / 100 + (exp or 0)
	for k, v in ipairs(artifactRuneRead.level) do
		if v.ExpGrowingType == ExpGrowingType and Level > v.Slevel and next(v.AdviceClassRequire) then
			_UPVALUE3_ = nil
			;(nil)[1] = "type"
			;(nil)[2] = "id"
			;(nil)[3] = "count"
			local costCfg = serviceFunctions.tableFormat(v.AdviceClassRequire, nil)
			for m, n in ipairs(costCfg) do
				if n.type == 1 then
					itemArray[n.id] = (itemArray[n.id] or 0) + n.count
				end
				if n.type == 2 then
					runeArray[n.id] = (runeArray[n.id] or 0) + n.count
				end
			end
		end
	end
	local artifactRuneRead, ret_item = (for generator), ipairs(artifactRuneRead.level)
	for k, v in pairs(itemArray) do
		if 0 < math.floor(v * ratio / 100) then
			artifactRuneRead = ipairs(costCfg)
			ipairs(costCfg).id = k
			ipairs(costCfg).count = math.floor(v * ratio / 100)
			table.insert(ret_item, ipairs(costCfg))
		end
	end
	table.sort(ret_item, function(a, b)
		return a.id < b.id
	end)
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local artifactRuneRead, ret_rune = "backpackltCtrl", "backpackltCtrl"
	for k, v in pairs(runeArray) do
		local chips = backpackltCtrl:getMaterialOfMergeItem(k)
		for ki, vi in ipairs(chips) do
			if 0 < math.floor(v * vi.count * ratio / 100) then
				artifactRuneRead = nil
				;(nil).id = vi.id
				;(nil).count = math.floor(v * vi.count * ratio / 100)
				table.insert(ret_rune, nil)
			end
		end
	end
	table.sort(ret_rune, function(a, b)
		return a.id < b.id
	end)
	print("produceExp====", produceExp)
	if 1000 <= produceExp then
		local exp_1000 = math.floor(produceExp / 1000)
		produceExp = produceExp - exp_1000 * 1000
		expArray[7010504] = exp_1000
	end
	if 500 <= produceExp then
		local exp_500 = math.floor(produceExp / 500)
		produceExp = produceExp - exp_500 * 500
		expArray[7010503] = exp_500
	end
	if 200 <= produceExp then
		local exp_200 = math.floor(produceExp / 200)
		produceExp = produceExp - exp_200 * 200
		expArray[7010502] = exp_200
	end
	if 100 <= produceExp then
		local exp_100 = math.floor(produceExp / 100)
		expArray[7010501] = exp_100
	end
	local artifactRuneRead, ret_exp = exp_100, math.floor(produceExp / 100)
	for k, v in pairs(expArray) do
		artifactRuneRead = ipairs(chips)
		ipairs(chips).id = k
		ipairs(chips).count = v
		table.insert(ret_exp, ipairs(chips))
	end
	table.sort(ret_exp, function(a, b)
		return a.id < b.id
	end)
	return ret_item, ret_rune, ret_exp
end
function artifactRuneRead.getSuitSkillInfo(id)
	return artifactRuneRead.suit_skill[id]
end
function artifactRuneRead.getPropertyArray(id)
	local artifactRuneRead, array
	local quality = 1
	local power = 0
	local growType = 1
	local PropertiesGrowingType
	local cfg = artifactRuneRead.property[id]
	if cfg then
		_UPVALUE4_ = nil
		;(nil)[1] = "buffType"
		;(nil)[2] = "buffMode"
		;(nil)[3] = "buffVal"
		;(nil)[4] = "growType"
		array = serviceFunctions.tableFormat(cfg.Attribute, nil)
		quality = cfg.Quality
		power = cfg.Power
		growType = cfg.GrowingType
		PropertiesGrowingType = cfg.Attribute[4]
	end
	return array, quality, power, growType, PropertiesGrowingType
end
function artifactRuneRead.getCost(GrowingType, Level)
	local _ENV, array
	for k, v in ipairs(artifactRuneRead.strengthen) do
		if v.GrowingType == GrowingType and v.Level == Level and next(v.Cost) then
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			array = serviceFunctions.tableFormat(v.Cost, nil)
			break
		end
	end
	return array
end
function artifactRuneRead.getCostNeed(GrowingType, Level, AddLv)
	local count = 0
	for k, v in ipairs(artifactRuneRead.strengthen) do
		if v.GrowingType == GrowingType and Level <= v.Level and v.Level <= Level + AddLv - 1 and next(v.Cost) then
			count = count + v.Cost[2]
		end
	end
	return count
end
function artifactRuneRead.getTotalCost(GrowingType, Level)
	local _ENV, array
	for k, v in ipairs(artifactRuneRead.strengthen) do
		if v.GrowingType == GrowingType and Level > v.Level and next(v.Cost) then
			for i = 1, #v.Cost - 1, 2 do
				if array[v.Cost[i]] then
					array[v.Cost[i]] = array[v.Cost[i]] + v.Cost[i + 1]
				else
					array[v.Cost[i]] = v.Cost[i + 1]
				end
			end
		end
	end
	return array
end
function artifactRuneRead.getRandomMaxSLV(season, class)
	print("season,class=====", season, class)
	return artifactRuneRead.rpsCfg[season][class]
end
function artifactRuneRead.getPropertiesLvCfg(pType, sLevel)
	return artifactRuneRead.propertiescfg[pType][sLevel]
end
function artifactRuneRead.getMayRandomBuff(poolID)
	local cfg = artifactRuneRead.pool[poolID]
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "percent"
	local groupArray = serviceFunctions.tableFormat(cfg.PropertyPool, nil)
	local str = ""
	local buffDesRead = include("buffDesRead")
	local artifactRuneRead, addType = "buffDesRead", "buffDesRead"
	for k, v in ipairs(groupArray) do
		local array = artifactRuneRead.getPropertyArray(v.id)
		for ki, vi in ipairs(array) do
			if not addType[vi.buffType] then
				str = str .. buffDesRead.getTitleBase(vi.buffType) .. "\n"
				addType[vi.buffType] = true
			end
		end
	end
	return str
end
function artifactRuneRead.getRandomBuffCfg(poolID)
	return artifactRuneRead.pool[poolID]
end
function artifactRuneRead.getRuneSkip(holeType)
	return artifactRuneRead.skip[holeType]
end
function artifactRuneRead.getReturnCost(rid, level)
	for k, v in ipairs(artifactRuneRead.rune_return) do
		if v.RuneID == rid and level >= v.SLvRange[1] and level <= v.SLvRange[2] then
			return v.Cost[1], v.Cost[2]
		end
	end
end
function artifactRuneRead.getRuneSetCfg()
	local _ENV, setList
	for k, v in ipairs(artifactRuneRead.rune_set) do
		if next(v.condition) then
			if v.condition[1] == 2 then
				local vipLevel, isActive = SoraDGetVipLv()
				_ENV = nil
				;(nil).setID = v.setID
				;(nil).isLock = not (vipLevel >= v.condition[2]) or not isActive
				table.insert(setList, nil)
			end
		else
			_ENV = table.insert
			table.insert.setID = v.setID
			table.insert.isLock = false
			table.insert(setList, table.insert)
		end
	end
	return setList
end
function artifactRuneRead.isRuneSetLock(setID)
	local ret = false
	if not artifactRuneRead.rune_set[setID] or not artifactRuneRead.rune_set[setID].condition then
		local artifactRuneRead, condition = artifactRuneRead.rune_set[setID].condition, artifactRuneRead.rune_set[setID].condition
	end
	if next(condition) and condition[1] == 2 then
		local vipLevel, isActive = SoraDGetVipLv()
		if not (vipLevel >= condition[2]) or not isActive then
			ret = true
		end
	end
	return ret
end
function artifactRuneRead.isSuitPrepareForWar()
	local regionType = SoraDGetCtrl("nebulaActivityCtrl"):getKingdomRegionType()
	if regionType == NEBULA_REGION_TYPE.PREPARE_FOR_WAR then
		local activity_9001656_Ctrl = SoraDGetCtrl("activity_9001656_Ctrl")
		if activity_9001656_Ctrl:getStatusbyUnlockType(gNebulaMileStoneUnlockType.UNLOCK_WAR_LINE_SYS) then
			return true
		end
	end
	return false
end
function artifactRuneRead.getMaxLv(Season)
	local season = Season or SoraDGetCtrl("nebulaActivityCtrl"):getCurSeason()
	local maxLv = runeMaxCfg[season] or runeMaxCfg[#runeMaxCfg]
	if artifactRuneRead.isSuitPrepareForWar() then
		local isUnLock, classLimit, levlLimit = artifactRuneRead.getLimitSeaonCfg(season)
		maxLv = levlLimit
	end
	return maxLv
end
function artifactRuneRead.getConfigMaxLv(Season)
	local season = Season or SoraDGetCtrl("nebulaActivityCtrl"):getCurSeason()
	return runeMaxCfg[season] or runeMaxCfg[#runeMaxCfg]
end
function artifactRuneRead.getAttrMaxLv(pgType)
	return attrMaxCfg[pgType] or 60
end
function artifactRuneRead.getColor(quality, isActive)
	if isActive then
		return activeColorCfg[quality] or activeColorCfg[1]
	else
		return unActiveColorCfg[quality] or unActiveColorCfg[1]
	end
end
function artifactRuneRead.getLuckyValueLimit()
	dump(artifactRuneRead.luckyvalueconfig, "artifactRuneRead.luckyvalueconfig")
	print("artifactRuneRead.luckyvalueconfig", artifactRuneRead.luckyvalueconfig[1].luckValueLimit)
	return artifactRuneRead.luckyvalueconfig[1].luckValueLimit
end
function artifactRuneRead.getMultiConfig(index)
	return artifactRuneRead.multipleconfig[index]
end
function artifactRuneRead.getHoleMap()
	return artifactRuneRead.holeMap
end
return artifactRuneRead
