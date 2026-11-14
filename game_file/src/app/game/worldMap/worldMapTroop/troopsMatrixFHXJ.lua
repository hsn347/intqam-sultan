local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixFHXJ = class("troopsMatrixFHXJ", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 350
local MatrixHeight = 140
function troopsMatrixFHXJ:ctor(troopInstance)
	self.troopInstance = self.troopInstance
end
_ENV, _UPVALUE4_, troopsMatrixFHXJ.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_FHXJ
end, function(self)
	return MatrixType.MatrixType_FHXJ
end
;(nil).soldier = worldMapDefine.soldierType_fhxj
_ENV, (nil).pos = cc.p(357.3, 92.26), cc.p(357.3, 92.26)
cc.p(357.3, 92.26).soldier = worldMapDefine.soldierType_fhxbxj
_ENV, cc.p(357.3, 92.26).pos = cc.p(179.52, 72.51), cc.p(179.52, 72.51)
cc.p(179.52, 72.51).soldier = worldMapDefine.soldierType_fhxbxj
_ENV, cc.p(179.52, 72.51).pos = cc.p(127.08, 37.96), cc.p(127.08, 37.96)
cc.p(127.08, 37.96).soldier = worldMapDefine.soldierType_fhxbxj
cc.p(127.08, 37.96).pos = cc.p(42.96, 64.85)
;(function(self)
	return MatrixType.MatrixType_FHXJ
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_FHXJ
end)[2] = cc.p(357.3, 92.26)
;(function(self)
	return MatrixType.MatrixType_FHXJ
end)[3] = cc.p(179.52, 72.51)
local (function(self)
	return MatrixType.MatrixType_FHXJ
end)[4], armyConfig = cc.p(127.08, 37.96), function(self)
	return MatrixType.MatrixType_FHXJ
end
function troopsMatrixFHXJ:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	for _, v in ipairs(armyData) do
		soliderModelNum_bubing = soliderModelNum_bubing + 1
	end
	self.halfRoundNum = soliderModelNum_bubing
	return armyData
end
function troopsMatrixFHXJ:initSolider(isInit)
	local armyData = self:createMatrixData()
	self.troopInstance:setMatrixSize(MatrixWidth, MatrixHeight)
	for j, v in ipairs(armyData) do
		local soldierName = v.soldier
		local soldier
		soldier = self:createSolider(soldierName, j, isInit)
		soldier:setSoldierPos(cc.p(v.pos.x, v.pos.y))
		if isInit then
			local MatrixWidth, rankSoldierArray = soldier.setSoldierPos, soldier.setSoldierPos
			rankSoldierArray[#rankSoldierArray + 1] = soldier
			local length = MatrixWidth - v.pos.x
			MatrixWidth = v.pos.x
			v.pos.x.length = length
			local v.pos.x.soldierArray, rankSoldiers = rankSoldierArray, v.pos.x
			self:addShowRankSoldier(rankSoldiers)
		end
	end
	self:createDivineBeast(isInit, #armyData)
end
return troopsMatrixFHXJ
