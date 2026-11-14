local worldMapIconLodBoss = class("worldMapIconLodBoss", include("worldMapIconLod"))
function worldMapIconLodBoss:ctor()
	worldMapIconLodBoss.super.ctor(self)
end
local worldMapDefine = include("worldMapDefine")
local gMapObjTypeDef = _G.gMapObjTypeDef
function worldMapIconLodBoss:initInstanceData(objData, worldInstanceData, instanceData)
	local classID = worldInstanceData.class
	local instanceType = self:getInstanceType()
	local imgName
	if instanceType == gMapObjTypeDef.mapTypeWrathBeast then
		classID = objData.bossType
	elseif instanceType == gMapObjTypeDef.captureMonkey then
		classID = gBossType.monkeyBoss
	end
	local bossData = worldMapDefine.getWorldBossShow(classID)
	imgName = bossData and bossData.iconLod
	if imgName then
		self:setIcon(imgName)
	end
end
return worldMapIconLodBoss
