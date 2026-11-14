local troopsMatrix = include("troopsMatrix")
local troopsHelper = include("troopsHelper")
local troopsMatrixPreview = class("troopsMatrixPreview", function()
	local view = troopsMatrix.new()
	return view
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local EffectType = troopsMatrixUtil.EffectType
local isMarchArmyEffectId = function(subType)
	local cfg = troopsHelper.getMarchEffect(subType)
	return cfg.needMoving or false
end
function troopsMatrixPreview:ctor()
	self.matrixState = gMapMoveLineStatusType.moveLineStatusTypeMoving
end
function troopsMatrixPreview:marchEffect(effectId, withoutBatch, scale, armyEffectId)
	if self.effectType ~= 0 then
		self:hideTroopEffectType()
		if self.particle_node_bg then
			self:hideTroopEffectParticle(self.particle_node_bg)
		end
	end
	self.effectSkinShowId = effectId
	if armyEffectId and isMarchArmyEffectId(self.effectSkinShowId) then
		self.marchArmyEffectId = armyEffectId
	else
		self.marchArmyEffectId = 0
	end
	local effectType = self:getTroopEffectType()
	self.effectType = effectType
	self:createTroopMatrixType(false)
	if not self.particle_node then
		self.particle_node = self:getOrCreateParticleNode()
		self.particle_node:setLocalZOrder(10)
	end
	if not self.particle_node_bg then
		self.particle_node_bg = self:getOrCreateParticleNode()
		self.particle_node_bg:setLocalZOrder(-10)
	end
	if effectType == EffectType.EffectType_King or effectType == EffectType.EffectType_None or effectType == EffectType.EffectType_Medal then
		self:showTroopEffectType(true, false)
	else
		include("troopsHelper").createMarchEffectPreview(effectId, self.particle_node, self.particle_node_bg)
		self:setParticleNodeScale(scale or 1)
		if self.effectType ~= EffectType.EffectType_Skin and self.matrix then
			self.matrix:showTroopEffectType(self.effectType, true)
		end
	end
end
function troopsMatrixPreview:setParticleNodeScale(scale)
	if self.particle_node then
		self.particle_node:setScale(scale)
	end
	if self.particle_node_bg then
		self.particle_node_bg:setScale(scale)
	end
end
function troopsMatrixPreview:getSoliderNodeBatch(batchType)
	if self.batchNode[batchType] then
		return self.batchNode[batchType]
	end
	local node = troopsMatrixUtil.createSoliderNodeBatch(batchType)
	if node then
		node:setGroupID(0)
		self.soliderNode:addChild(node)
		self.batchNode[batchType] = node
	end
	return node
end
function troopsMatrixPreview:setMatrixSize(width, height)
	self.soliderNode:setContentSize(cc.size(width, height))
	if self.particle_node then
		self.particle_node:setPosition(cc.p(width, height * 0.5))
	end
	if self.particle_node_bg then
		self.particle_node_bg:setPosition(cc.p(width, height * 0.5))
	end
end
function troopsMatrixPreview:getTroopMatrixType()
	return self:getTroopMatrixType_imp()
end
return troopsMatrixPreview
