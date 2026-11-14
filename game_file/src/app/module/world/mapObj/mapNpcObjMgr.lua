local npcconfigData = include("npcconfig")
local mapNpcObjMgr = class("mapNpcObjMgr")
function mapNpcObjMgr:ctor(kingdomMapCell)
	self.kingdomMapCell = kingdomMapCell
	self.kid = kingdomMapCell.kid
	self.mapNpcMap, _UPVALUE0_, self.uid = kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid
end
function mapNpcObjMgr:addMapObj(mapObjData)
	if mapObjData.type == gMapObjTypeDef.mapObjTypeNpc or mapObjData.type == gMapObjTypeDef.nebulaNpc or mapObjData.type == gMapObjTypeDef.mapTypeFortyThieves or mapObjData.type == gMapObjTypeDef.mapTypeSemluk or mapObjData.type == gMapObjTypeDef.footballMonster or mapObjData.type == gMapObjTypeDef.mapTypeHuntFair then
		if not mapObjData.npc then
			mapObjData.npc, _ENV = mapObjData.npc, mapObjData.npc
		end
		if mapObjData.type == gMapObjTypeDef.mapObjTypeNpc and worldMapDefine.checkIsWastelandMonster(mapObjData.class) then
			local wastelandCtrl = SoraDGetCtrl("wastelandCtrl")
			local maxCanKillLevel = wastelandCtrl:getMaxAttackBossLevel()
			mapObjData.npc.maxCanKillLevel = maxCanKillLevel
			mapObjData.npc.isCanKill = maxCanKillLevel >= npcconfigData[mapObjData.class].npcLevel
		else
			mapObjData.npc.maxCanKillLevel = self.kingdomMapCell.maxNpcLevel + 1
			mapObjData.npc.isCanKill = npcconfigData[mapObjData.class].npcLevel <= self.kingdomMapCell.maxNpcLevel + 1
		end
		self.mapNpcMap[mapObjData.id] = mapObjData
	end
end
function mapNpcObjMgr:removeMapObj(mapObjData)
	if mapObjData.type == gMapObjTypeDef.mapObjTypeNpc or mapObjData.type == gMapObjTypeDef.nebulaNpc or mapObjData.type == gMapObjTypeDef.mapTypeFortyThieves or mapObjData.type == gMapObjTypeDef.mapTypeSemluk or mapObjData.type == gMapObjTypeDef.footballMonster or mapObjData.type == gMapObjTypeDef.mapTypeHuntFair then
		self.mapNpcMap[mapObjData.id] = nil
	end
end
function mapNpcObjMgr:updateMapObj(mapObjData)
	self:addMapObj(mapObjData)
end
function mapNpcObjMgr:updateMapObjMerge(mapObjData)
end
function mapNpcObjMgr:getAllNpc()
	return self.mapNpcMap
end
function mapNpcObjMgr:clear()
	self.mapNpcMap, _UPVALUE0_ = nil, nil
end
function mapNpcObjMgr:dump()
	print("mapNpcObjMgr:dump", table.nums(self.mapNpcMap))
end
return mapNpcObjMgr
