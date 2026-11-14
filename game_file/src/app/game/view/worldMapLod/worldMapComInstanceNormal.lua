local worldMapComInstanceNormal = class("worldMapComInstanceNormal", include("worldMapComInstance"))
local instanceBuilderNormal = include("instanceBuilderNormal")
local worldMapDefine = include("worldMapDefine")
local LOD1 = worldMapDefine.worldLodDef.LOD1
local LODKEEP = worldMapDefine.worldLodDef.LOD6
function worldMapComInstanceNormal:ctor()
	worldMapComInstanceNormal.super.ctor(self, "worldMapComInstanceNormal")
	self.builder = instanceBuilderNormal.new(self)
end
function worldMapComInstanceNormal:init()
	worldMapComInstanceNormal.super.init(self)
end
function worldMapComInstanceNormal:onMessageListener()
	worldMapComInstanceNormal.super.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_INSTANCE_FLASH", handler(self, self.serverMessage_FlashMapInstace))
end
function worldMapComInstanceNormal:checkLodFocus(lod)
	return lod == LOD1
end
function worldMapComInstanceNormal:checkLodKeep(lod)
	return lod <= LODKEEP
end
function worldMapComInstanceNormal:flashMapInstance(instance, updateData)
	if updateData.score then
		_UPVALUE0_ = updateData.score
		updateData.score.value = updateData.score
		local updateData.score.camp, data = updateData.camp, updateData.score
		instance:updateScoreTips(data)
	end
	if updateData.hp then
		_UPVALUE0_ = updateData.hp
		updateData.hp.value = updateData.hp
		local updateData.hp.isCrit, data = updateData.isCrit, updateData.hp
		instance:updateHpTips(data)
	end
	if updateData.shoot then
		_UPVALUE0_ = updateData.shoot
		local updateData.shoot.damage, data = updateData.shoot, updateData.shoot
		instance:updateShot(data)
	end
end
function worldMapComInstanceNormal:serverMessage_FlashMapInstace(target, data)
	local tilesDataArray = data.data
	local lod = data.lod or self.target_:getCurLod()
	if self:checkLodFocus(lod) then
		for _, v in pairs(tilesDataArray) do
			local instance = self:getShowInstanceByMap(v)
			if instance and instance.__cname then
				local kingdomID = v.kid or self.myKindomID
				if instance:getInstanceID() == v.id and instance:getKingdomID() == kingdomID then
					self:flashMapInstance(instance, v)
				end
			end
		end
	end
end
function worldMapComInstanceNormal:resetData()
	worldMapComInstanceNormal.super.resetData(self)
	self.currentShowTilesArray, worldMapComInstanceNormal = worldMapComInstanceNormal.super.resetData, worldMapComInstanceNormal.super.resetData
end
function worldMapComInstanceNormal:updateMapInstance(instance, objData, updateData)
	if objData then
		instance:updateInstanceData(objData, updateData)
	end
	if updateData.fightTime then
		instance:updateFightTime(updateData.fightTime, updateData)
	end
	if updateData.ref then
		instance:setMassRef(updateData.ref)
	end
end
function worldMapComInstanceNormal:onAddInstance(tileInstance, instanceData)
	if not instanceData.isLocal then
		local tilesArray = tileInstance:getTilesArray()
		for _, v in pairs(tilesArray) do
			self.currentShowTilesArray[v] = tileInstance
		end
	end
end
function worldMapComInstanceNormal:onRemoveInstance(tileInstance)
	local tilesArray = tileInstance:getTilesArray()
	for _, v in pairs(tilesArray) do
		local instance = self.currentShowTilesArray[v]
		if instance and instance == tileInstance then
			self.currentShowTilesArray[v] = nil
		end
	end
end
function worldMapComInstanceNormal:getClosestInstanceFromManager_imp(instanceType, havePlayer, params)
	havePlayer = havePlayer or false
	local worldInstance
	local closestDistace = 1000
	local point = params.point
	if not point then
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		point = cityCtrl:getCurCityPos()
	end
	local getInstanceDistance = function(tileInstance)
		if not tileInstance then
			return -1
		end
		local showTilePoint = tileInstance:getTilePoint()
		local distance = cc.pGetDistance(point, showTilePoint)
		return distance
	end
	for _, v in pairs(self.currentShowTilesArray) do
		local tileInstance = v
		local instanceDistance = -1
		local isContinue
		if tileInstance.kingdomID == self.myKindomID then
			isContinue = true
		else
			isContinue = false
		end
		if SoraDGetCtrl("kingdomMapCtrl"):checkIsInNormalFog(tileInstance:getTilePoint(), tileInstance.kingdomID) then
			isContinue = false
		end
		if isContinue then
			if tileInstance and tileInstance.instanceType == instanceType then
				if params and params.resourceType and instanceType == gMapObjTypeDef.mapObjTypeResource then
					if tileInstance.resourceType == params.resourceType then
						isContinue = true
					else
						isContinue = false
					end
				elseif instanceType == gMapObjTypeDef.mapObjTypeNpc and tileInstance:checkIsWastelandMonster() then
					isContinue = false
				else
					isContinue = true
				end
			else
				isContinue = false
			end
		end
		if isContinue then
			if params and params.lowLevel and params.highLevel then
				if tileInstance.instanceLevel >= params.lowLevel and tileInstance.instanceLevel <= params.highLevel then
					isContinue = true
				else
					isContinue = false
				end
			else
				isContinue = true
			end
		end
		if isContinue then
			local playerID = tileInstance.playerID or 0
			if havePlayer and 0 < playerID then
				isContinue = true
			elseif not havePlayer and playerID == 0 then
				isContinue = true
			else
				isContinue = false
			end
		end
		if isContinue then
			instanceDistance = getInstanceDistance(tileInstance)
		end
		if 0 <= instanceDistance and closestDistace > instanceDistance then
			closestDistace = instanceDistance
			worldInstance = tileInstance
		end
		if closestDistace == 1 then
			return worldInstance
		end
	end
	return worldInstance
end
function worldMapComInstanceNormal:getBelongBuild(pos)
	local instanceType = gMapObjTypeDef.mapTypeRadianceWarBeacon
	for _, v in pairs(self.currentShowTilesArray) do
		if v and v.instanceType == instanceType and v:isInSelfManor(pos) then
			return v:getTilePoint()
		end
	end
end
function worldMapComInstanceNormal:getBelongMonsterList(instanceID)
	local _ENV, ret
	for _, tileInstance in pairs(self.currentShowTilesArray) do
		if tileInstance and tileInstance.instanceType == gMapObjTypeDef.mapObjTypeNpc and tileInstance:checkIsWastelandMonster() and tileInstance:getBelongInstanceID() == instanceID then
			table.insert(ret, tileInstance)
		end
	end
	return ret
end
function worldMapComInstanceNormal:hasShowTilesData()
	return #self.updateTilesDataArray > 0
end
function worldMapComInstanceNormal:getShowInstance(pos)
	if self.target_.getTilePointFakeInstance then
		local instance = self.target_:getTilePointFakeInstance(pos)
		if instance and instance.__cname then
			return instance
		end
	end
	if self.target_.getSpecailInstance then
		local instance = self.target_:getSpecailInstance(pos)
		if instance and instance.__cname then
			return instance
		end
	end
	local key = pos.x .. "," .. pos.y
	local instance = self.currentShowTilesArray[key]
	if instance and instance.__cname then
		return instance
	end
	if self.target_.getCommandHallNpc then
		local instance = self.target_:getCommandHallNpc(pos)
		if instance and instance.__cname then
			return instance
		end
	end
end
function worldMapComInstanceNormal:getShowTilesArray()
	return self.currentShowTilesArray
end
function worldMapComInstanceNormal:exportMethods()
	_UPVALUE6_ = nil
	;(nil)[1] = "hasShowTilesData"
	;(nil)[2] = "getShowInstance"
	;(nil)[3] = "getShowTilesArray"
	;(nil)[4] = "getClosestInstanceFromManager_imp"
	;(nil)[5] = "getBelongBuild"
	;(nil)[6] = "getBelongMonsterList"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComInstanceNormal
