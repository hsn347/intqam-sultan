local soldierRushRead = include("aAReadClass").new()
soldierRushRead.isInit = false
function soldierRushRead.init()
	if soldierRushRead.isInit then
		return
	end
	soldierRushRead.isInit = true
	_UPVALUE2_ = nil
	;(nil)[1] = "soldier_rush_constant"
	;(nil)[2] = true
	soldierRushRead:defineValue("constant", nil)
	_ENV = nil
	;(nil)[1] = "soldier_rush_ai"
	soldierRushRead:defineValue("ai", nil)
	_ENV = nil
	;(nil)[1] = "soldier_rush_skill"
	soldierRushRead:defineValue("skill", nil)
	_ENV = nil
	;(nil)[1] = "soldier_rush_army"
	soldierRushRead:defineValue("army", nil)
	_ENV = nil
	;(nil)[1] = "soldier_rush_build"
	soldierRushRead:defineValue("build", nil)
	soldierRushRead:defineValue("buildCfg", function()
		soldierRushRead.buildCfg, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.soldier_rush_build")
		for k, v in pairs(cfg) do
			if not soldierRushRead.buildCfg[v.Type] then
				soldierRushRead.buildCfg[v.Type], soldierRushRead = nil, nil
			end
			soldierRushRead.buildCfg[v.Type][v.Level] = v
		end
		return soldierRushRead.buildCfg
	end)
	soldierRushRead:defineValue("map", function()
		soldierRushRead.map, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.soldier_rush_map")
		for k, v in pairs(cfg) do
			soldierRushRead = nil
			;(nil).SceneID = v.SceneID
			;(nil).CannotPassRegion = v.CannotPassRegion
			_UPVALUE7_ = nil
			;(nil)[1] = "bid"
			;(nil)[2] = "force"
			;(nil)[3] = "bType"
			;(nil)[4] = "initLv"
			;(nil)[5] = "initArmy"
			;(nil)[6] = "x"
			;(nil)[7] = "y"
			soldierRushRead.map[v.MapID], (nil).BuildConstant = nil, serviceFunctions.tableFormat(v.BuildConstant, nil)
		end
		return soldierRushRead.map
	end)
	function _UPVALUE2_()
		soldierRushRead.map, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.soldier_rush_map")
		for k, v in pairs(cfg) do
			soldierRushRead = nil
			;(nil).SceneID = v.SceneID
			;(nil).CannotPassRegion = v.CannotPassRegion
			_UPVALUE7_ = nil
			;(nil)[1] = "bid"
			;(nil)[2] = "force"
			;(nil)[3] = "bType"
			;(nil)[4] = "initLv"
			;(nil)[5] = "initArmy"
			;(nil)[6] = "x"
			;(nil)[7] = "y"
			soldierRushRead.map[v.MapID], (nil).BuildConstant = nil, serviceFunctions.tableFormat(v.BuildConstant, nil)
		end
		return soldierRushRead.map
	end
	;(function()
		soldierRushRead.map, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.soldier_rush_map")
		for k, v in pairs(cfg) do
			soldierRushRead = nil
			;(nil).SceneID = v.SceneID
			;(nil).CannotPassRegion = v.CannotPassRegion
			_UPVALUE7_ = nil
			;(nil)[1] = "bid"
			;(nil)[2] = "force"
			;(nil)[3] = "bType"
			;(nil)[4] = "initLv"
			;(nil)[5] = "initArmy"
			;(nil)[6] = "x"
			;(nil)[7] = "y"
			soldierRushRead.map[v.MapID], (nil).BuildConstant = nil, serviceFunctions.tableFormat(v.BuildConstant, nil)
		end
		return soldierRushRead.map
	end)[1] = "soldier_rush_chapter"
	;(function()
		soldierRushRead.map, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.soldier_rush_map")
		for k, v in pairs(cfg) do
			soldierRushRead = nil
			;(nil).SceneID = v.SceneID
			;(nil).CannotPassRegion = v.CannotPassRegion
			_UPVALUE7_ = nil
			;(nil)[1] = "bid"
			;(nil)[2] = "force"
			;(nil)[3] = "bType"
			;(nil)[4] = "initLv"
			;(nil)[5] = "initArmy"
			;(nil)[6] = "x"
			;(nil)[7] = "y"
			soldierRushRead.map[v.MapID], (nil).BuildConstant = nil, serviceFunctions.tableFormat(v.BuildConstant, nil)
		end
		return soldierRushRead.map
	end)[2] = true
	soldierRushRead:defineValue("chapter", function()
		soldierRushRead.map, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.soldier_rush_map")
		for k, v in pairs(cfg) do
			soldierRushRead = nil
			;(nil).SceneID = v.SceneID
			;(nil).CannotPassRegion = v.CannotPassRegion
			_UPVALUE7_ = nil
			;(nil)[1] = "bid"
			;(nil)[2] = "force"
			;(nil)[3] = "bType"
			;(nil)[4] = "initLv"
			;(nil)[5] = "initArmy"
			;(nil)[6] = "x"
			;(nil)[7] = "y"
			soldierRushRead.map[v.MapID], (nil).BuildConstant = nil, serviceFunctions.tableFormat(v.BuildConstant, nil)
		end
		return soldierRushRead.map
	end)
	function _UPVALUE2_()
		soldierRushRead.map, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.soldier_rush_map")
		for k, v in pairs(cfg) do
			soldierRushRead = nil
			;(nil).SceneID = v.SceneID
			;(nil).CannotPassRegion = v.CannotPassRegion
			_UPVALUE7_ = nil
			;(nil)[1] = "bid"
			;(nil)[2] = "force"
			;(nil)[3] = "bType"
			;(nil)[4] = "initLv"
			;(nil)[5] = "initArmy"
			;(nil)[6] = "x"
			;(nil)[7] = "y"
			soldierRushRead.map[v.MapID], (nil).BuildConstant = nil, serviceFunctions.tableFormat(v.BuildConstant, nil)
		end
		return soldierRushRead.map
	end
	;(function()
		soldierRushRead.map, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.soldier_rush_map")
		for k, v in pairs(cfg) do
			soldierRushRead = nil
			;(nil).SceneID = v.SceneID
			;(nil).CannotPassRegion = v.CannotPassRegion
			_UPVALUE7_ = nil
			;(nil)[1] = "bid"
			;(nil)[2] = "force"
			;(nil)[3] = "bType"
			;(nil)[4] = "initLv"
			;(nil)[5] = "initArmy"
			;(nil)[6] = "x"
			;(nil)[7] = "y"
			soldierRushRead.map[v.MapID], (nil).BuildConstant = nil, serviceFunctions.tableFormat(v.BuildConstant, nil)
		end
		return soldierRushRead.map
	end)[1] = "soldier_rush_level"
	;(function()
		soldierRushRead.map, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.soldier_rush_map")
		for k, v in pairs(cfg) do
			soldierRushRead = nil
			;(nil).SceneID = v.SceneID
			;(nil).CannotPassRegion = v.CannotPassRegion
			_UPVALUE7_ = nil
			;(nil)[1] = "bid"
			;(nil)[2] = "force"
			;(nil)[3] = "bType"
			;(nil)[4] = "initLv"
			;(nil)[5] = "initArmy"
			;(nil)[6] = "x"
			;(nil)[7] = "y"
			soldierRushRead.map[v.MapID], (nil).BuildConstant = nil, serviceFunctions.tableFormat(v.BuildConstant, nil)
		end
		return soldierRushRead.map
	end)[2] = true
	soldierRushRead:defineValue("level", function()
		soldierRushRead.map, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.soldier_rush_map")
		for k, v in pairs(cfg) do
			soldierRushRead = nil
			;(nil).SceneID = v.SceneID
			;(nil).CannotPassRegion = v.CannotPassRegion
			_UPVALUE7_ = nil
			;(nil)[1] = "bid"
			;(nil)[2] = "force"
			;(nil)[3] = "bType"
			;(nil)[4] = "initLv"
			;(nil)[5] = "initArmy"
			;(nil)[6] = "x"
			;(nil)[7] = "y"
			soldierRushRead.map[v.MapID], (nil).BuildConstant = nil, serviceFunctions.tableFormat(v.BuildConstant, nil)
		end
		return soldierRushRead.map
	end)
	soldierRushRead:defineValue("levelCfg", function()
		soldierRushRead.levelCfg, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.soldier_rush_level")
		for k, v in pairs(cfg) do
			if not soldierRushRead.levelCfg[v.Chapter] then
				soldierRushRead.levelCfg[v.Chapter], soldierRushRead = nil, nil
			end
			soldierRushRead.levelCfg[v.Chapter][v.LevelId] = v
		end
		return soldierRushRead.levelCfg
	end)
	function _ENV()
		soldierRushRead.levelCfg, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.soldier_rush_level")
		for k, v in pairs(cfg) do
			if not soldierRushRead.levelCfg[v.Chapter] then
				soldierRushRead.levelCfg[v.Chapter], soldierRushRead = nil, nil
			end
			soldierRushRead.levelCfg[v.Chapter][v.LevelId] = v
		end
		return soldierRushRead.levelCfg
	end
	;(function()
		soldierRushRead.levelCfg, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.soldier_rush_level")
		for k, v in pairs(cfg) do
			if not soldierRushRead.levelCfg[v.Chapter] then
				soldierRushRead.levelCfg[v.Chapter], soldierRushRead = nil, nil
			end
			soldierRushRead.levelCfg[v.Chapter][v.LevelId] = v
		end
		return soldierRushRead.levelCfg
	end)[1] = "solidier_rush_coefficient"
	soldierRushRead:defineValue("coefficient", function()
		soldierRushRead.levelCfg, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.soldier_rush_level")
		for k, v in pairs(cfg) do
			if not soldierRushRead.levelCfg[v.Chapter] then
				soldierRushRead.levelCfg[v.Chapter], soldierRushRead = nil, nil
			end
			soldierRushRead.levelCfg[v.Chapter][v.LevelId] = v
		end
		return soldierRushRead.levelCfg
	end)
	soldierRushRead:defineValue("castleIncrease", function()
		soldierRushRead.castleIncrease, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.soldier_rush_castle_increase")
		for k, v in pairs(cfg) do
			soldierRushRead.castleIncrease[v.CastleLv] = v.Increase
		end
		return soldierRushRead.castleIncrease
	end)
	function _UPVALUE2_()
		soldierRushRead.castleIncrease, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.soldier_rush_castle_increase")
		for k, v in pairs(cfg) do
			soldierRushRead.castleIncrease[v.CastleLv] = v.Increase
		end
		return soldierRushRead.castleIncrease
	end
	;(function()
		soldierRushRead.castleIncrease, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.soldier_rush_castle_increase")
		for k, v in pairs(cfg) do
			soldierRushRead.castleIncrease[v.CastleLv] = v.Increase
		end
		return soldierRushRead.castleIncrease
	end)[1] = "soldier_rush_territory_income"
	;(function()
		soldierRushRead.castleIncrease, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.soldier_rush_castle_increase")
		for k, v in pairs(cfg) do
			soldierRushRead.castleIncrease[v.CastleLv] = v.Increase
		end
		return soldierRushRead.castleIncrease
	end)[2] = true
	soldierRushRead:defineValue("territoryIncome", function()
		soldierRushRead.castleIncrease, soldierRushRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.soldier_rush_castle_increase")
		for k, v in pairs(cfg) do
			soldierRushRead.castleIncrease[v.CastleLv] = v.Increase
		end
		return soldierRushRead.castleIncrease
	end)
end
soldierRushRead.init()
function soldierRushRead.getTerritoryIncomeList()
	return soldierRushRead.territoryIncome
end
function soldierRushRead.getCoefficientVal(lvDiff)
	local diff = 1
	for k, v in ipairs(soldierRushRead.coefficient) do
		if v.num == lvDiff then
			diff = v.coefficient
			break
		end
	end
	return diff
end
function soldierRushRead.getCastleBonusList()
	return soldierRushRead.castleIncrease
end
function soldierRushRead.getCastleBonus(lv)
	local lv = math.min(lv, 30)
	return soldierRushRead.castleIncrease[lv]
end
function soldierRushRead.getConstantVal(key)
	return soldierRushRead.constant[key].value
end
function soldierRushRead.getAiCfg(id)
	return soldierRushRead.ai[id]
end
function soldierRushRead.getSkillCfg(id)
	return soldierRushRead.skill[id]
end
function soldierRushRead.getAllSkillCfg()
	return soldierRushRead.skill
end
function soldierRushRead.getSkillID(heroID, quality)
	for k, v in ipairs(soldierRushRead.skill) do
		if v.HeroId == heroID and v.SkillQuality == quality then
			return v.Index
		end
	end
end
function soldierRushRead.getShowArmyCfg()
	local _ENV, cfg
	for k, v in ipairs(soldierRushRead.army) do
		if v.show == 1 then
			table.insert(cfg, v)
		end
	end
	return cfg
end
function soldierRushRead.getArmyCfg(lv)
	for k, v in ipairs(soldierRushRead.army) do
		if math.floor(v.Level + 0.05) == math.floor(lv + 0.05) then
			return v
		end
	end
end
function soldierRushRead.getArmyLv()
	local lv = 1
	for k, v in ipairs(soldierRushRead.army) do
		if SoraDGetCastleLv() >= v.CastleLv then
			lv = math.max(lv, v.Level)
		end
	end
	return lv
end
function soldierRushRead.getCastleLv(armyLv)
	local lv = 1
	for k, v in ipairs(soldierRushRead.army) do
		if armyLv == v.Level then
			lv = v.CastleLv
		end
	end
	return lv
end
function soldierRushRead.getCurArmyCfg()
	local id = 1
	for k, v in ipairs(soldierRushRead.army) do
		if SoraDGetCastleLv() >= v.CastleLv then
			id = math.max(id, v.ID)
		end
	end
	return soldierRushRead.army[id]
end
function soldierRushRead.getMyArmyCfg(gateID)
	local gateCfg = soldierRushRead.getLevelCfg(gateID)
	local soldierRushRead, cfg = gateID, gateID
	for k, v in ipairs(soldierRushRead.army) do
		if SoraDGetCastleLv() >= v.CastleLv and v.Level <= gateCfg.SoldierLvLimit then
			cfg = v
		end
	end
	return cfg
end
function soldierRushRead.getBuildCfg(id)
	return soldierRushRead.build[id]
end
function soldierRushRead.getBuildCfgByTypeAndLv(bType, lv)
	return soldierRushRead.buildCfg[bType][lv]
end
function soldierRushRead.getBuildCfgByType(bType)
	return soldierRushRead.buildCfg[bType]
end
function soldierRushRead.getMapCfg(id)
	return soldierRushRead.map[id]
end
function soldierRushRead.getAllChapterCfg()
	return soldierRushRead.chapter
end
function soldierRushRead.getChapterCfg(id)
	return soldierRushRead.chapter[id]
end
function soldierRushRead.getChapterStarCfg(id, index)
	_UPVALUE2_ = "StarReward" .. index
	;("StarReward" .. index)[1] = "id"
	;("StarReward" .. index)[2] = "count"
	return soldierRushRead.chapter[id]["StarRequire" .. index], serviceFunctions.tableFormat(soldierRushRead.chapter[id]["StarReward" .. index], "StarReward" .. index)
end
function soldierRushRead.getMaxNeedStars(id)
	return soldierRushRead.chapter[id].StarRequire3
end
function soldierRushRead.getLevelCfgList()
	return soldierRushRead.level
end
function soldierRushRead.getLevelCfg(id)
	return soldierRushRead.level[id]
end
function soldierRushRead.getLevelStarCfg(id)
	local cfg = soldierRushRead.level[id]
	local soldierRushRead, soldierRushRead, condition
	;(nil).index = 1
	soldierRushRead, condition[1], (nil).val = nil, nil, cfg.RuleType
	;(nil).index = 2
	;(nil).key = cfg.StarCondition1[1]
	;(nil).val1 = cfg.StarCondition1[2]
	;(nil).val2 = cfg.StarCondition1[3]
	soldierRushRead, condition[2], (nil).val3 = nil, nil, cfg.StarCondition1[4]
	;(nil).index = 3
	;(nil).key = cfg.StarCondition2[1]
	;(nil).val1 = cfg.StarCondition2[2]
	;(nil).val2 = cfg.StarCondition2[3]
	condition[3], (nil).val3 = nil, cfg.StarCondition2[4]
	return condition
end
function soldierRushRead.getLevelFrontCfg(chapter, gate)
	local frontLevel = soldierRushRead.levelCfg[chapter][gate].FrontLevel
	if frontLevel ~= 0 then
		return soldierRushRead.level[frontLevel]
	end
end
function soldierRushRead.getLevelID(chapter, gate)
	return soldierRushRead.levelCfg[chapter][gate].ID
end
function soldierRushRead.getLevelCfgByChapter(chapter)
	return soldierRushRead.levelCfg[chapter]
end
function soldierRushRead.getLevelMapCfg()
	return soldierRushRead.levelCfg
end
function soldierRushRead.getChapterLevel(index)
	for k, v in ipairs(soldierRushRead.levelCfg) do
		for ki, vi in ipairs(v) do
			if index == 1 then
				return vi.ID
			else
				index = index - 1
			end
		end
	end
end
function soldierRushRead.getChapterAllStars(id)
	local stars = 0
	for k, v in pairs(soldierRushRead.level) do
		if v.Chapter == id then
			stars = stars + 3
		end
	end
	return stars
end
function soldierRushRead.getPathRange(gate)
	_UPVALUE36_ = nil
	;(nil)[1] = 3
	;(nil)[2] = 15
	;(nil)[3] = 19
	;(nil)[4] = 29
	;(nil)[5] = 41
	;(nil)[6] = 50
	;(nil)[7] = 54
	;(nil)[8] = 58
	;(nil)[9] = 63
	;(nil)[10] = 66
	;(nil)[11] = 71
	;(nil)[12] = 77
	;(nil)[13] = 82
	;(nil)[14] = 86
	;(nil)[15] = 88
	;(nil)[16] = 92
	;(nil)[17] = 96
	;(nil)[18] = 99
	;(nil)[19] = 104
	;(nil)[20] = 107
	;(nil)[21] = 111
	;(nil)[22] = 115
	;(nil)[23] = 118
	;(nil)[24] = 123
	;(nil)[25] = 127
	;(nil)[26] = 131
	;(nil)[27] = 134
	;(nil)[28] = 141
	;(nil)[29] = 147
	;(nil)[30] = 151
	;(nil)[31] = 154
	;(nil)[32] = 158
	;(nil)[33] = 161
	;(nil)[34] = 167
	;(nil)[35] = 170
	;(nil)[36] = 173
	;(nil)[37] = 177
	;(nil)[38] = 181
	;(nil)[39] = 187
	;(nil)[40] = 194
	;(nil)[41] = 198
	;(nil)[42] = 203
	;(nil)[43] = 208
	;(nil)[44] = 212
	;(nil)[45] = 214
	;(nil)[46] = 220
	;(nil)[47] = 224
	;(nil)[48] = 227
	;(nil)[49] = 231
	;(nil)[50] = 239
	;(nil)[51] = 243
	;(nil)[52] = 246
	;(nil)[53] = 250
	;(nil)[54] = 255
	;(nil)[55] = 258
	;(nil)[56] = 264
	;(nil)[57] = 272
	;(nil)[58] = 275
	;(nil)[59] = 280
	;(nil)[60] = 285
	;(nil)[61] = 293
	;(nil)[62] = 298
	;(nil)[63] = 301
	;(nil)[64] = 305
	;(nil)[65] = 309
	;(nil)[66] = 312
	;(nil)[67] = 315
	;(nil)[68] = 319
	;(nil)[69] = 324
	;(nil)[70] = 328
	;(nil)[71] = 332
	;(nil)[72] = 337
	;(nil)[73] = 341
	;(nil)[74] = 347
	;(nil)[75] = 350
	;(nil)[76] = 353
	;(nil)[77] = 357
	;(nil)[78] = 362
	;(nil)[79] = 366
	;(nil)[80] = 370
	;(nil)[81] = 375
	;(nil)[82] = 382
	;(nil)[83] = 386
	;(nil)[84] = 389
	;(nil)[85] = 393
	;(nil)[86] = 398
	;(nil)[87] = 402
	;(nil)[88] = 405
	;(nil)[89] = 409
	;(nil)[90] = 414
	;(nil)[91] = 418
	;(nil)[92] = 422
	;(nil)[93] = 425
	;(nil)[94] = 432
	;(nil)[95] = 436
	local (nil)[96], pathCfg = 441, nil
	return pathCfg[gate]
end
function soldierRushRead.getChapterOffset(chapter)
	_ENV = nil
	;(nil)[1] = cc.p(70, -80)
	;(nil)[2] = cc.p(30, -30)
	;(nil)[3] = cc.p(20, -70)
	;(nil)[4] = cc.p(-20, -50)
	;(nil)[5] = cc.p(-20, -60)
	;(nil)[6] = cc.p(0, -80)
	;(nil)[7] = cc.p(0, -70)
	;(nil)[8] = cc.p(-30, -70)
	;(nil)[9] = cc.p(-50, -80)
	local (nil)[10], offsetCfg = cc.p(0, 0), nil
	return offsetCfg[chapter]
end
function soldierRushRead.getArmyShowCfg(rotation)
	local dir = "n"
	local isFlipX = false
	local index = 0
	if 67.5 <= rotation and rotation <= 112.5 then
		dir = "n"
		index = 0
	elseif 22.5 <= rotation and rotation < 67.5 then
		dir = "wn"
		index = 4
	elseif -22.5 <= rotation and rotation < 22.5 then
		dir = "w"
		index = 2
	elseif -67.5 <= rotation and rotation < -22.5 then
		dir = "ws"
		index = 5
	elseif -112.5 <= rotation and rotation < -67.5 then
		dir = "s"
		index = 1
	elseif -157.5 <= rotation and rotation < -112.5 then
		dir = "ws"
		isFlipX = true
		index = 7
	elseif 157.5 <= rotation and rotation <= 180 or rotation < -157.5 and -180 <= rotation then
		dir = "w"
		isFlipX = true
		index = 3
	elseif 112.5 < rotation and rotation < 157.5 then
		dir = "wn"
		isFlipX = true
		index = 6
	end
	return index, dir, isFlipX
end
function soldierRushRead.getArmyModel(force, gateID)
	local npcHead = "lvse"
	local armyCfg = soldierRushRead.getArmyConfig(force, gateID)
	if force == 1 then
		npcHead = armyCfg.OwnLook
	elseif force == 2 then
		npcHead = armyCfg.NeutralLook
	elseif force == 3 then
		npcHead = armyCfg.EnemyLook1
	elseif force == 4 then
		npcHead = armyCfg.EnemyLook2
	end
	return npcHead
end
function soldierRushRead.getArmySoul(force)
	_UPVALUE0_ = nil
	;(nil)[1] = "dh_lan.png"
	;(nil)[2] = "dh_hui.png"
	;(nil)[3] = "dh_hong.png"
	local (nil)[4], soulCfg = "dh_zi.png", nil
	return soulCfg[force]
end
function soldierRushRead.getArmyConfig(force, gateID)
	local gateCfg = soldierRushRead.getLevelCfg(gateID)
	local armyCfg = force == 1 and soldierRushRead.getMyArmyCfg(gateID) or soldierRushRead.getArmyCfg(gateCfg.EnemySoldierLv)
	return armyCfg
end
function soldierRushRead.getDirOffset(index)
	_ENV = nil
	;(nil)[0] = cc.p(0, 30)
	;(nil)[1] = cc.p(0, -20)
	;(nil)[2] = cc.p(20, 20)
	;(nil)[3] = cc.p(-20, 20)
	;(nil)[4] = cc.p(20, 30)
	;(nil)[5] = cc.p(20, 20)
	;(nil)[6] = cc.p(-20, 30)
	local (nil)[7], offsetCfg = cc.p(-20, 20), nil
	return offsetCfg[index]
end
return soldierRushRead
