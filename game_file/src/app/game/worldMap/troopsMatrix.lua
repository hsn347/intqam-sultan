local size_zero = cc.size(0, 0)
local pos_zero = cc.p(0, 0)
local worldMapTroopInstance = include("worldMapTroopInstance")
local troopsMatrix = class("troopsMatrix", function()
	local view = worldMapTroopInstance.new(size_zero)
	return view
end)
local dressltCtrl = include("dressltCtrl")
local troopsMatrixUtil = include("troopsMatrixUtil")
local mapObjUtil = include("mapObjUtil")
local troopsHelper = include("troopsHelper")
local troopSolider = include("troopSolider")
local EffectType = troopsMatrixUtil.EffectType
local MatrixType = troopsMatrixUtil.MatrixType
local getNeedMoving = function(subType)
	local cfg = troopsHelper.getMarchEffect(subType)
	return cfg.needMoving or false
end
local getMatrixType = function(subType)
	local cfg = troopsHelper.getMarchEffect(subType)
	return cfg.matrixType or 0
end
local getEffectType = function(subType)
	local cfg = troopsHelper.getMarchEffect(subType)
	return cfg.effectType or 0
end
function troopsMatrix:ctor()
	self.radius = 0
	self.batchNode, EffectType, self.armyData, EffectType, self.effectType = EffectType.EffectType_None, EffectType.EffectType_None, EffectType.EffectType_None, EffectType.EffectType_None, EffectType.EffectType_None
	self.effectSkinId = 0
	self.effectSkinShowId = 0
	self.emojiID = 0
	self.hasHeroBack = false
	self.isBackFailQueue = false
	self.isPreview = false
	self.soliderNode:setAnchorPoint(1.0, 0.5)
	self.soliderNode:setContentSize(40, 80)
end
function troopsMatrix:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, toObjectType, data, toObjectID, setRadius, userData)
	self.beginPoint = beginPoint
	self.endPoint = endPoint
	self.beginTilePoint = beginTilePoint
	self.endTilePoint = endTilePoint
	if setRadius then
		self.radius = setRadius
	else
		self.radius = mapObjUtil.getRadiusByObjectType(toObjectType, toObjectID)
	end
	if toObjectType == gMapObjTypeDef.mapObjTypeLegendLord then
		local offsetLength = 150
		local distance = cc.pGetDistance(beginPoint, endPoint)
		local xOffset = offsetLength * (endPoint.x - beginPoint.x) / distance
		local yOffset = offsetLength * (endPoint.y - beginPoint.y) / distance
		self.endPoint.x = self.endPoint.x - xOffset
		self.endPoint.y = self.endPoint.y - yOffset
	end
	if userData then
		if userData.effectId then
			self.effectSkinId = userData.effectId
		end
		self.hasHeroBack = userData.captureHeroAsAttacker
		self.isBackFailQueue = userData.isBackFailQueue
	end
	if self.effectSkinId > 0 then
		self.effectSkinShowId = dressltCtrl.getSubType(self.effectSkinId)
	end
	if self.isBackFailQueue then
		self.effectSkinShowId = 0
		self.effectType = EffectType.EffectType_None
	end
	if worldMapDefine.isNebulaAllStarKingdomID() then
		self.effectSkinShowId = gDressSubType.MARCH_EFFECT_STARSHIP
	end
	self.armyData = data
	local rotation, imgNameAngle, isFlipX, moveAngle = worldMapFunction.getSoliderImgAngel(beginPoint, endPoint)
	self.rotation = rotation
	self.imgNameAngle = imgNameAngle
	self.isFlipX = isFlipX
	self.moveAngle = moveAngle
	self.soliderNode:setRotation(self.rotation)
	self:initCheckVisible()
	self:updateTroopEffectType(false, true)
end
function troopsMatrix:setMatrixSize(width, height)
	self.soliderNode:setContentSize(cc.size(width, height))
	if self.particle_node then
		self.particle_node:setPosition(cc.p(width, height * 0.5))
	end
	self:initCheckRect()
end
function troopsMatrix:setIsKing(isKing, isshow)
end
function troopsMatrix:setMedalEffect(effectSkinId, isShow)
	effectSkinId = effectSkinId or 0
	isShow = nil == isShow and true or isShow
	if self.effectSkinId == effectSkinId then
		return
	end
	self.effectSkinId = effectSkinId
	local effectId = 0
	if 0 < self.effectSkinId then
		effectId = dressltCtrl.getSubType(self.effectSkinId)
	end
	self.effectSkinShowId = effectId
	self:updateTroopEffectType(isShow)
end
function troopsMatrix:beginWorkPre()
	self:stopMarchEffect()
	worldMapTroopInstance.beginWork(self)
end
function troopsMatrix:beginWork()
	if self.matrix then
		self.matrix:beginWork()
	end
end
function troopsMatrix:stopMarchEffect()
	self:hideTroopEffectType()
end
function troopsMatrix:getOrCreateParticleNode()
	local particle_node = display.newNode()
	self.soliderNode:addChild(particle_node)
	local size = self:getTroopContentSize()
	particle_node:setPosition(cc.p(size.width, size.height * 0.5))
	return particle_node
end
function troopsMatrix:marchEffect_imp(effectId, showNow)
	if 0 < effectId then
		if not self.particle_node then
			self.particle_node = self:getOrCreateParticleNode()
		end
		if showNow then
			troopsHelper.createMarchEffect(effectId, self.particle_node)
		else
			local showParticle = function()
				troopsHelper.createMarchEffect(effectId, self.particle_node)
			end
			_ENV = nil
			;(nil)[1] = cca.delay(0.5)
			;(nil)[2] = cca.callFunc(showParticle)
			;(nil)[3] = cca.callFunc(showParticle)
			self.particle_node:runAction(cca.seq(nil))
		end
	end
end
function troopsMatrix:showEmoji(emojiID)
	self:addEmoji(emojiID, pos_zero)
end
function troopsMatrix:getTroopContentSize()
	local size = self.soliderNode:getContentSize()
	return size
end
function troopsMatrix:getTroopEffectType()
	if self.effectSkinShowId > 0 then
		return getEffectType(self.effectSkinShowId) or EffectType.EffectType_Skin
	end
	return EffectType.EffectType_None
end
function troopsMatrix:showTroopEffectType(showNow, isInit)
	if self.matrix then
		self.matrix:marchEffect(self.effectSkinShowId, showNow)
		if not isInit and showNow then
			local effectType = self.effectType
			self.matrix:showTroopEffectType(effectType)
		end
	end
end
function troopsMatrix:hideTroopEffectParticle(particle_node)
	if particle_node then
		local effectType = self.effectType
		if effectType ~= EffectType.EffectType_King or effectType ~= EffectType.EffectType_Medal then
			particle_node:stopAllActions()
			particle_node:removeAllChildren()
		end
	end
end
function troopsMatrix:hideTroopEffectType()
	local effectType = self.effectType
	if effectType == EffectType.EffectType_None then
		return
	end
	if self.particle_node then
		self:hideTroopEffectParticle(self.particle_node)
	end
	if self.matrix then
		self.matrix:hideTroopEffectType(effectType)
	end
end
function troopsMatrix:updateTroopEffectType(isShow, isInit)
	if self.effectType ~= EffectType.EffectType_None then
		self:hideTroopEffectType()
	end
	local effectType = self:getTroopEffectType()
	self.effectType = effectType
	if self.isBackFailQueue then
		self.effectSkinShowId = 0
		self.effectType = EffectType.EffectType_None
	end
	self:createTroopMatrixType(isInit)
	self:showTroopEffectType(isShow, isInit)
end
function troopsMatrix:getTroopMatrixType()
	if not self.commandHallTaskType then
		local isRunning = self.soliderNode:isRunning()
		if not isRunning then
			return MatrixType.MatrixType_Empty
		end
	end
	return self:getTroopMatrixType_imp()
end
function troopsMatrix:getTroopMatrixType_imp()
	if self.effectSkinShowId > 0 then
		local needMoving = getNeedMoving(self.effectSkinShowId)
		if not needMoving or needMoving and self.matrixState == gMapMoveLineStatusType.moveLineStatusTypeMoving then
			return getMatrixType(self.effectSkinShowId)
		end
	end
	return MatrixType.MatrixType_Normal
end
function troopsMatrix:createTroopMatrixType(isInit)
	local matrixType = self:getTroopMatrixType()
	if not self.matrix or self.matrix:isSwitchMatrix(matrixType) then
		local matrix = troopsHelper.newTroopInstance(matrixType, self)
		self:switchTroopMatrixType(matrix, isInit)
	end
end
function troopsMatrix:switchTroopMatrixType(matrix, isInit)
	if nil == matrix then
		return
	end
	if self.matrix then
		self.matrix:removeMatrix()
		self.matrix:removeFromParent()
	end
	self.matrix = matrix
	self.matrix:addTo(self)
	local moving = self.matrixState == gMapMoveLineStatusType.moveLineStatusTypeMoving
	self.matrix:showMatrix(isInit, moving)
end
function troopsMatrix:getAmryData()
	if not self.armyData then
		_UPVALUE0_ = self.armyData
	end
	return self.armyData
end
function troopsMatrix:isHasHeroBack()
	return self.hasHeroBack
end
function troopsMatrix:isFailBack()
	return self.isBackFailQueue
end
function troopsMatrix:getRadius()
	return self.radius
end
function troopsMatrix:getBeginPoint()
	return self.beginPoint
end
function troopsMatrix:getEffectType()
	return self.effectType
end
function troopsMatrix:getSoliderNodeBatch(batchType)
	if self.batchNode[batchType] then
		return self.batchNode[batchType]
	end
	local node = troopsMatrixUtil.createSoliderNodeBatch(batchType)
	if node then
		self.soliderNode:addChild(node)
		self.batchNode[batchType] = node
	end
	return node
end
function troopsMatrix:createSolider(soldierName, zOrder)
	local soldier = troopSolider.new(soldierName, self.imgNameAngle, self)
	self.soliderNode:addChild(soldier, 1)
	local soliderImg = soldier:getSoliderImg()
	soliderImg:setFlippedX(self.isFlipX)
	soliderImg:setRotation(-self.moveAngle)
	return soldier
end
function troopsMatrix:onExitOther()
	self:removeSoliderNode()
	if self.matrix then
		self.matrix:removeShowRankTimer()
	end
end
function troopsMatrix:onSoliderNodeShow()
	if self.matrix and self.matrix:isSwitchMatrixOnShow() then
		self:updateTroopEffectType(true)
	end
end
return troopsMatrix
