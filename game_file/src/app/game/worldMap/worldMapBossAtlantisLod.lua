local worldMapBossAtlantisLod = class("worldMapBossAtlantisLod", include("worldMapAtlantisWarLod"))
function worldMapBossAtlantisLod:_initData(...)
	worldMapBossAtlantisLod.super._initData(self)
	self.protectScale = 1.4
end
function worldMapBossAtlantisLod:_initUI()
	worldMapBossAtlantisLod.super._initUI(self)
	self.Node_kingdom:setVisible(false)
	self.Node_player:setVisible(false)
	local node = display.newNode()
	node:addTo(self, 2)
	node:setPosition(0, 150)
	self.Node_effect = node
	local effect = SoraDGetFightingEffectNew()
	effect:addTo(node)
	effect:setScale(0.5)
	effect:setPosition(0, 50)
end
function worldMapBossAtlantisLod:initInstanceData(objData, worldInstanceData, instanceData)
	self.siteClassID = objData.objId
	local bossClassID = worldInstanceData.subMapType
	local faceType = objData.faceTo
	local showTilePoint = worldInstanceData.tilePoint
	local _, imgNameAngle, isFlipX = worldMapFunction.getMonsterImgAngelEx(faceType, showTilePoint)
	local bossData = worldMapDefine.getWorldBossShow(bossClassID)
	local hasHD = worldMapDefine.hasBossHdRes(bossClassID, bossData.level)
	local imgName
	if hasHD then
		imgName = string.format("%s_dj_%s_%02d.png", bossData.effects, imgNameAngle, 20)
	else
		imgName = string.format("%s_dj_%s.png", bossData.effects, imgNameAngle)
	end
	self.Sprite_build:setSpriteFrame(imgName)
	self.Sprite_build:setScale(bossData.scale or 1.5)
	self.Sprite_build:setPositionY(bossData.offsety or 0)
	self.Sprite_build:setFlippedX(isFlipX)
	self.Node_protect:setScale(self.protectScale)
	self:initBuildTime()
	self:updateLodChange()
	self:updateData(objData)
end
function worldMapBossAtlantisLod:updateData(data, delayTime)
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	self:updateSafeState()
	if self:checkInWarStatus() then
		self.Node_effect:setVisible(true)
	else
		self.Node_effect:setVisible(false)
	end
end
function worldMapBossAtlantisLod:updateScaleChange(revertScale, scale)
	local realScale = revertScale * 0.65
	self.Node_buildTime:setScale(realScale * 2)
	self.Node_effect:setScale(realScale * 2)
end
function worldMapBossAtlantisLod:updateLodChange(...)
end
return worldMapBossAtlantisLod
