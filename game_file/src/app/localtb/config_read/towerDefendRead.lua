local towerDefendRead = include("aAReadClass").new()
_UPVALUE1_ = nil
;(nil)[1] = "ep_td_config"
towerDefendRead:defineValue("gameConfig", nil)
_UPVALUE1_ = nil
;(nil)[1] = "ep_td_wave"
towerDefendRead:defineValue("coutMonsterConfig", nil)
_UPVALUE1_ = nil
;(nil)[1] = "ep_td_monster_lv"
towerDefendRead:defineValue("monsterLv", nil)
_UPVALUE1_ = nil
;(nil)[1] = "ep_td_tower_lv"
towerDefendRead:defineValue("towerLv", nil)
_UPVALUE1_ = nil
;(nil)[1] = "ep_td_tower_advance"
towerDefendRead:defineValue("towerAdvance", nil)
_UPVALUE1_ = nil
;(nil)[1] = "ep_td_exskill"
towerDefendRead:defineValue("skill", nil)
function towerDefendRead.getGameConfig()
	return towerDefendRead.gameConfig[1]
end
function towerDefendRead.setPanelFixHeight(fixHeight)
	towerDefendRead.fixHeight = fixHeight
	dump(towerDefendRead.fixHeight, "fjskfjdfjkdfjkdj")
end
function towerDefendRead.setPanelRealHeight(realHeight)
	towerDefendRead.realHeight = realHeight
	dump(towerDefendRead.realHeight, "fjskfjdfj5435435kdfjkdj")
end
_ENV, towerDefendRead.getHeightScale = function()
	local fitHeight = 1136
	local scale = fitHeight / towerDefendRead.realHeight
	dump(scale, "fjskldfjsdjfkdjfkdjfk")
	return scale
end, function()
	local fitHeight = 1136
	local scale = fitHeight / towerDefendRead.realHeight
	dump(scale, "fjskldfjsdjfkdjfkdjfk")
	return scale
end
;(function()
	local fitHeight = 1136
	local scale = fitHeight / towerDefendRead.realHeight
	dump(scale, "fjskldfjsdjfkdjfkdjfk")
	return scale
end).BALLISTA = 101
;(function()
	local fitHeight = 1136
	local scale = fitHeight / towerDefendRead.realHeight
	dump(scale, "fjskldfjsdjfkdjfkdjfk")
	return scale
end).FORT = 102
;(function()
	local fitHeight = 1136
	local scale = fitHeight / towerDefendRead.realHeight
	dump(scale, "fjskldfjsdjfkdjfkdjfk")
	return scale
end).MAGETOWER = 103
local _ENV, (function()
	local fitHeight = 1136
	local scale = fitHeight / towerDefendRead.realHeight
	dump(scale, "fjskldfjsdjfkdjfkdjfk")
	return scale
end).MAINTOWER, TowerID = towerDefendRead, 104, function()
	local fitHeight = 1136
	local scale = fitHeight / towerDefendRead.realHeight
	dump(scale, "fjskldfjsdjfkdjfkdjfk")
	return scale
end
towerDefendRead.SOLDIER = 101
towerDefendRead.GENERAL = 102
local _ENV, towerDefendRead.BOSS, MosterID = "skill", 103, towerDefendRead
;("skill").BUILD = 1
;("skill").UPGRADE = 2
local _ENV, ("skill").RETROFIT, BuildType = nil, 3, "skill"
;(nil).BALLISTA = 1
;(nil).FORT = 2
;(nil).MAGETOWER = 3
local _ENV, (nil).MAINTOWER, TowerType = "ep_td_exskill", 4, nil
;("ep_td_exskill").SOLDIER = 1
;("ep_td_exskill").GENERAL = 2
local ("ep_td_exskill").BOSS, MosterType = 3, "ep_td_exskill"
towerDefendRead.gold = towerDefendRead.getGameConfig().initGold
function towerDefendRead.isMonserGenerateFinish(wave)
	return wave >= table.nums(towerDefendRead.coutMonsterConfig)
end
function towerDefendRead.getMonsterTotalNumByWave(wave)
	local totalMonsterNum = 0
	local monsterData = towerDefendRead.coutMonsterConfig[wave].monsterCounter
	dump(towerDefendRead.coutMonsterConfig, "fjksdfjkdfjkdfjkd")
	_UPVALUE3_ = dump
	dump[1] = "monsterID"
	dump[2] = "num"
	local dump[3], keys = "level", dump
	monsterData = serviceFunctions.tableFormat(monsterData, keys)
	for i, v in ipairs(monsterData) do
		totalMonsterNum = totalMonsterNum + v.num
	end
	return monsterData, totalMonsterNum
end
local categoryMonsterInfo = function()
	local _ENV, monsterInfo
	for i, v in ipairs(towerDefendRead.monsterLv) do
		monsterInfo[v.monsterID .. "" .. v.level] = v
	end
	return monsterInfo
end
towerDefendRead.monsterInfo = categoryMonsterInfo()
function towerDefendRead.getMonsterInfoByIDLevel(monsterID, level)
	return towerDefendRead.monsterInfo[monsterID .. "" .. level]
end
local categoryTowerInfo = function()
	local _ENV, towerInfo
	for i, v in ipairs(towerDefendRead.towerLv) do
		towerInfo[v.towerID .. "" .. v.level] = v
	end
	return towerInfo
end
towerDefendRead.towerInfoInfo = categoryTowerInfo()
function towerDefendRead.getTowerInfoByIDLevel(towerID, level)
	return towerDefendRead.towerInfoInfo[towerID .. "" .. level]
end
_ENV, _ENV, towerDefendRead.maxLevel = towerDefendRead.towerLv, table.nums(towerDefendRead.towerLv), table.nums(towerDefendRead.towerLv)
towerDefendRead.towerLv.towerType = 1
towerDefendRead.towerLv.towerStandby = "fytn_dj_n_0%02d.png"
towerDefendRead.towerLv.towerAtk = "fytn_gj_n__0%02d.png"
towerDefendRead.towerLv.towerRotate = "nujixuanzhuan_%02d.png"
_ENV, table.nums(towerDefendRead.towerLv)[101], towerDefendRead.towerLv.towerPic = towerDefendRead.towerLv, towerDefendRead.towerLv, "nujixuanzhuan_01.png"
towerDefendRead.towerLv.towerType = 2
towerDefendRead.towerLv.towerStandby = "fytp_dj_n_0%02d.png"
towerDefendRead.towerLv.towerAtk = "tf_paotai02_gj_%02d.png"
towerDefendRead.towerLv.towerRotate = "paotaixuanzhuan_%02d.png"
_ENV, table.nums(towerDefendRead.towerLv)[102], towerDefendRead.towerLv.towerPic = towerDefendRead.towerLv, towerDefendRead.towerLv, "paotaixuanzhuan_01.png"
towerDefendRead.towerLv.towerType = 3
towerDefendRead.towerLv.towerStandby = ""
towerDefendRead.towerLv.towerAtk = "dh_Tex_XL_mnytf06_0%02d.png"
towerDefendRead.towerLv.towerRotate = "shizipaotai_%02d.png"
_ENV, table.nums(towerDefendRead.towerLv)[103], towerDefendRead.towerLv.towerPic = towerDefendRead.towerLv, towerDefendRead.towerLv, "1shizipaotai_01.png"
towerDefendRead.towerLv.towerType = 4
towerDefendRead.towerLv.towerStandby = "fytp_dj_n_0%02d.png"
towerDefendRead.towerLv.towerAtk = "fytp_gj_n_0%02d.png"
towerDefendRead.towerLv.towerRotate = "shizipaotai_%02d.png"
_ENV, _ENV, towerDefendRead.towerConfig, table.nums(towerDefendRead.towerLv)[104], towerDefendRead.towerLv.towerPic = towerDefendRead.towerLv, table.nums(towerDefendRead.towerLv), table.nums(towerDefendRead.towerLv), towerDefendRead.towerLv, "paotaixuanzhuan_01.png"
towerDefendRead.towerLv.monsterType = 1
towerDefendRead.towerLv.monsterStandby = "munaiyi_dj_s_%02d.png"
towerDefendRead.towerLv.monsterBorn = "munaiyi_chuxian_%02d.png"
towerDefendRead.towerLv.monsterWalk = "munaiyi_yd_s_%02d.png"
towerDefendRead.towerLv.monsterAtk = "munaiyi_gj_s_%02d.png"
towerDefendRead.towerLv.monsterDie = "dh_Tex_XL_mnytf01_0%02d.png"
towerDefendRead.towerLv.monsterHurt = "munaiyi_sj_s_%02d.png"
_ENV, table.nums(towerDefendRead.towerLv)[101], towerDefendRead.towerLv.monsterPic = towerDefendRead.towerLv, towerDefendRead.towerLv, "8425.png"
towerDefendRead.towerLv.monsterType = 2
towerDefendRead.towerLv.monsterStandby = "jinsemunaiyi_dj_s_%02d.png"
towerDefendRead.towerLv.monsterBorn = "jinsemunaiyi_chuxian_%02d.png"
towerDefendRead.towerLv.monsterWalk = "jinsemunaiyi_yd_s_%02d.png"
towerDefendRead.towerLv.monsterAtk = "jinsemunaiyi_gj_s_%02d.png"
towerDefendRead.towerLv.monsterDie = "dh_Tex_XL_mnytf01_0%02d.png"
towerDefendRead.towerLv.monsterHurt = "jinsemunaiyi_sj_s_%02d.png"
_ENV, table.nums(towerDefendRead.towerLv)[102], towerDefendRead.towerLv.monsterPic = towerDefendRead.towerLv, towerDefendRead.towerLv, "8426.png"
towerDefendRead.towerLv.monsterType = 3
towerDefendRead.towerLv.monsterStandby = "anubisi_dj_s_%02d.png"
towerDefendRead.towerLv.monsterBorn = "anubisi_dj_s_%02d.png"
towerDefendRead.towerLv.monsterWalk = "anubisi_yd_s_%02d.png"
towerDefendRead.towerLv.monsterAtk = "anubisi_gj_s_%02d.png"
towerDefendRead.towerLv.monsterDie = "dh_Tex_XL_mnytf01_0%02d.png"
towerDefendRead.towerLv.monsterHurt = "anubisi_sj_s_%02d.png"
towerDefendRead.monsterConfig, table.nums(towerDefendRead.towerLv)[103], towerDefendRead.towerLv.monsterPic = table.nums(towerDefendRead.towerLv), towerDefendRead.towerLv, "8427.png"
function towerDefendRead.getAdvanceLevel(towerID)
	if towerID == TowerID.FORT then
		return towerDefendRead.towerAdvance[TowerID.BALLISTA].advanceID[2]
	end
	return towerDefendRead.towerAdvance[TowerID.BALLISTA].advanceID[4]
end
function towerDefendRead.isMaxLv(curLevel, lvIndex, towerID)
	if lvIndex >= table.nums(towerDefendRead.towerLv) then
		return true
	end
	if lvIndex == 0 or curLevel == towerDefendRead.towerAdvance[TowerID.BALLISTA].level then
		return false
	end
	if towerDefendRead.towerLv[lvIndex].towerID ~= towerDefendRead.towerLv[lvIndex + 1].towerID then
		return true
	end
	return false
end
function towerDefendRead.isTowerMaxLevel(curLevel, lvIndex)
	if curLevel == towerDefendRead.towerAdvance[TowerID.BALLISTA].level then
		return true
	end
	if lvIndex >= table.nums(towerDefendRead.towerLv) then
		return true
	elseif towerDefendRead.towerLv[lvIndex].towerID ~= towerDefendRead.towerLv[lvIndex + 1].towerID then
		return true
	end
	return false
end
function towerDefendRead.getLvInfo(towerID, level)
	local lvIndex = towerDefendRead.getLvIndex(towerID, level)
	return towerDefendRead.towerLv[lvIndex]
end
_ENV, towerDefendRead.getLvIndex = function(towerID, level)
	dump(towerDefendRead.towerLv, "fjskdfjkdfjkdjfkdjfk")
	for i, v in ipairs(towerDefendRead.towerLv) do
		if v.towerID == towerID and v.level == level then
			return i
		end
	end
	return 1
end, function(towerID, level)
	dump(towerDefendRead.towerLv, "fjskdfjkdfjkdjfkdjfk")
	for i, v in ipairs(towerDefendRead.towerLv) do
		if v.towerID == towerID and v.level == level then
			return i
		end
	end
	return 1
end
;(function(towerID, level)
	dump(towerDefendRead.towerLv, "fjskdfjkdfjkdjfkdjfk")
	for i, v in ipairs(towerDefendRead.towerLv) do
		if v.towerID == towerID and v.level == level then
			return i
		end
	end
	return 1
end).ALIVE = 1
;(function(towerID, level)
	dump(towerDefendRead.towerLv, "fjskdfjkdfjkdjfkdjfk")
	for i, v in ipairs(towerDefendRead.towerLv) do
		if v.towerID == towerID and v.level == level then
			return i
		end
	end
	return 1
end).DIE = 2
local towerDefendRead.aliveMonster, _ENV, (function(towerID, level)
	dump(towerDefendRead.towerLv, "fjskdfjkdfjkdjfkdjfk")
	for i, v in ipairs(towerDefendRead.towerLv) do
		if v.towerID == towerID and v.level == level then
			return i
		end
	end
	return 1
end).ATTACK, MonsterState = towerDefendRead.towerLv, towerDefendRead.towerLv, 3, function(towerID, level)
	dump(towerDefendRead.towerLv, "fjskdfjkdfjkdjfkdjfk")
	for i, v in ipairs(towerDefendRead.towerLv) do
		if v.towerID == towerID and v.level == level then
			return i
		end
	end
	return 1
end
function towerDefendRead.addMonsterObject(info, pos)
	if pos and towerDefendRead.aliveMonster[pos] then
		return pos
	end
	table.insert(towerDefendRead.aliveMonster, info)
	return table.nums(towerDefendRead.aliveMonster)
end
towerDefendRead.deadMonster, _ENV, towerDefendRead.getMonsterObject = function()
	return towerDefendRead.aliveMonster
end, function()
	return towerDefendRead.aliveMonster
end, function()
	return towerDefendRead.aliveMonster
end
function towerDefendRead.addDeadMonsterObject(pos)
	towerDefendRead.aliveMonster[pos].state = MonsterState.DIE
	table.insert(towerDefendRead.deadMonster, pos)
end
function towerDefendRead.hasRemainMonsterObject()
	if towerDefendRead.deadMonster and next(towerDefendRead.deadMonster) then
		return true
	end
	return false
end
towerDefendRead.outAttack, _ENV, towerDefendRead.getRecycleMonsterObject = function()
	if towerDefendRead.hasRemainMonsterObject() then
		local pos = table.remove(towerDefendRead.deadMonster)
		return towerDefendRead.aliveMonster[pos].instance, pos
	end
	return nil, nil
end, function()
	if towerDefendRead.hasRemainMonsterObject() then
		local pos = table.remove(towerDefendRead.deadMonster)
		return towerDefendRead.aliveMonster[pos].instance, pos
	end
	return nil, nil
end, function()
	if towerDefendRead.hasRemainMonsterObject() then
		local pos = table.remove(towerDefendRead.deadMonster)
		return towerDefendRead.aliveMonster[pos].instance, pos
	end
	return nil, nil
end
function towerDefendRead.addAttackObject(obj)
	table.insert(towerDefendRead.outAttack, obj)
end
_ENV, towerDefendRead.getRecycleAttackObject = function()
	if towerDefendRead.hasRemainAttackObject() then
		return table.remove(towerDefendRead.outAttack)
	end
	return nil
end, function()
	if towerDefendRead.hasRemainAttackObject() then
		return table.remove(towerDefendRead.outAttack)
	end
	return nil
end
;(function()
	if towerDefendRead.hasRemainAttackObject() then
		return table.remove(towerDefendRead.outAttack)
	end
	return nil
end).IN = 1
local towerDefendRead.outShootLine, _ENV, (function()
	if towerDefendRead.hasRemainAttackObject() then
		return table.remove(towerDefendRead.outAttack)
	end
	return nil
end).OUT, FlyState = nil, nil, 2, function()
	if towerDefendRead.hasRemainAttackObject() then
		return table.remove(towerDefendRead.outAttack)
	end
	return nil
end
function towerDefendRead.addShootLineObject(obj)
	table.insert(towerDefendRead.outShootLine, obj)
end
function towerDefendRead.getRecycleShootLineObject()
	if towerDefendRead.hasRemainAttackObject() then
		return table.remove(towerDefendRead.outShootLine)
	end
	return nil
end
_ENV, towerDefendRead.hasRemainAttackObject = function()
	if towerDefendRead.outShootLine and next(towerDefendRead.outShootLine) then
		return true
	end
	return false
end, function()
	if towerDefendRead.outShootLine and next(towerDefendRead.outShootLine) then
		return true
	end
	return false
end
;(function()
	if towerDefendRead.outShootLine and next(towerDefendRead.outShootLine) then
		return true
	end
	return false
end).IN = 1
local towerDefendRead.outDropCoin, _ENV, (function()
	if towerDefendRead.outShootLine and next(towerDefendRead.outShootLine) then
		return true
	end
	return false
end).OUT, DropState = nil, nil, 2, function()
	if towerDefendRead.outShootLine and next(towerDefendRead.outShootLine) then
		return true
	end
	return false
end
function towerDefendRead.addDropCoinObject(obj)
	table.insert(towerDefendRead.outDropCoin, obj)
end
function towerDefendRead.getRecycleDropCoinObject()
	if towerDefendRead.hasRemainDropCoinObject() then
		return table.remove(towerDefendRead.outDropCoin)
	end
	return nil
end
function towerDefendRead.hasRemainDropCoinObject()
	if towerDefendRead.outDropCoin and next(towerDefendRead.outDropCoin) then
		return true
	end
	return false
end
towerDefendRead.killNum = 0
function towerDefendRead.clearKillNum()
	towerDefendRead.killNum = 0
end
function towerDefendRead.increaseKillNum()
	towerDefendRead.killNum = towerDefendRead.killNum + 1
end
function towerDefendRead.clearAll()
	towerDefendRead.outDropCoin, towerDefendRead, towerDefendRead.outShootLine, towerDefendRead, towerDefendRead.outAttack, towerDefendRead, towerDefendRead.inAttack, towerDefendRead, towerDefendRead.deadMonster, towerDefendRead, towerDefendRead.aliveMonster, towerDefendRead = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	towerDefendRead.gold = towerDefendRead.getGameConfig().initGold
	towerDefendRead.killNum = 0
end
return towerDefendRead
