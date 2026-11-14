local worldMapBossAtlantisLod4 = class("worldMapBossAtlantisLod4", include("worldMapAtlantisWarLod4"))
function worldMapBossAtlantisLod4:_initData(...)
	worldMapBossAtlantisLod4.super._initData(self)
	self.protectScale = 1.4
end
function worldMapBossAtlantisLod4:initInstanceData(objData, worldInstanceData, instanceData)
	self.siteClassID = objData.objId
	local bossData = worldMapDefine.getWorldBossShow(worldInstanceData.subMapType)
	local imgName = bossData.iconLod or "lod_monster.png"
	self.Sprite_build:setSpriteFrame(imgName)
	self.Sprite_build:setScale(6)
	self.Node_protect:setScale(self.protectScale)
	self:updateData(objData)
end
function worldMapBossAtlantisLod4:getSpriteBuild(...)
	return self.Sprite_build
end
function worldMapBossAtlantisLod4:getBuildId(...)
	return self.siteClassID
end
return worldMapBossAtlantisLod4
