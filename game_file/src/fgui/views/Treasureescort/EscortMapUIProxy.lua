local baseProxy = require("fgui.base.baseProxy")
local EscortMapUIProxy = class("EscortMapUIProxy", baseProxy)
function EscortMapUIProxy:onRegisterEvent()
	print("=======EscortMapUIProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCEESCORT_UPDATE", handler(self.view, self.view.refreshView))
end
function EscortMapUIProxy:getArmyByHeroList(heroList)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local grade = activityShowCtrl:getParamClassType(gActivityTimeActivityID.ALLIANCE_ESCORT_ACTIVITY)
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local _ENV, heroNumList = "heroltCtrl", "heroltCtrl"
	for i, v in ipairs(heroList) do
		local heroType = heroltCtrl.getHeroType(v.heroID)
		heroNumList[tostring(heroType)] = (heroNumList[tostring(heroType)] or 0) + 1
	end
	local _ENV, ret = (for generator), ipairs(heroList)
	local treasureescortsoldier = require_data("treasureescortsoldier", true).data
	for i, v in ipairs(treasureescortsoldier) do
		if not ret[v.grade] then
			_ENV = ret[v.grade]
		end
		ret[v.grade] = ret[v.grade]
		ret[v.grade][v.type] = v.soldier
	end
	local escortSoldierCfg = ret[grade]
	local _ENV, npcNumList = ipairs(treasureescortsoldier)
	for heroType, num in pairs(heroNumList) do
		local npcId = escortSoldierCfg[tonumber(heroType)]
		npcNumList[npcId] = num
	end
	local _ENV, npcSetting = (for generator), pairs(heroNumList)
	local npc = require_data("npc", true).data
	for i, v in ipairs(npc) do
		npcSetting[v.id] = v
	end
	local _ENV, armyNumMap = (for generator), ipairs(npc)
	for npcId, npcNum in pairs(npcNumList) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		local arrArmy = serviceFunctions.tableFormat(npcSetting[npcId].army, nil)
		for _, v in ipairs(arrArmy) do
			armyNumMap[v.id] = (armyNumMap[v.id] or 0) + v.num * npcNum
		end
	end
	local _ENV, ret = (for generator), pairs(npcNumList)
	for id, num in pairs(armyNumMap) do
		_ENV = ipairs(arrArmy)
		ipairs(arrArmy).id = id
		ipairs(arrArmy).num = num
		table.insert(ret, ipairs(arrArmy))
	end
	return ret
end
return EscortMapUIProxy
