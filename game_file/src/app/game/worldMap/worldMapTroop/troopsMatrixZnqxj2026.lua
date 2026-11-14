local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixZnqxj2026 = class("troopsMatrixZnqxj2026", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 350
local MatrixHeight = 140
function troopsMatrixZnqxj2026:ctor(troopInstance)
end
_ENV, _UPVALUE1_, troopsMatrixZnqxj2026.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_znqxj2026
end, function(self)
	return MatrixType.MatrixType_znqxj2026
end
;(nil).soldier = worldMapDefine.soldierType_znqxj2026
_ENV, (nil).pos = cc.p(280, 65), cc.p(280, 65)
cc.p(280, 65).w = cc.p(0, -40)
cc.p(280, 65).wn = cc.p(0, -10)
cc.p(280, 65).n = cc.p(0, 0)
cc.p(280, 65).ws = cc.p(0, -20)
;(nil).visualOffset, cc.p(280, 65).s = cc.p(280, 65), cc.p(0, 0)
local (function(self)
	return MatrixType.MatrixType_znqxj2026
end)[1], armyConfig = nil, function(self)
	return MatrixType.MatrixType_znqxj2026
end
function troopsMatrixZnqxj2026:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	for k, v in ipairs(armyData) do
		soliderModelNum_bubing = soliderModelNum_bubing + 1
	end
	self.halfRoundNum = soliderModelNum_bubing
	return armyData
end
function troopsMatrixZnqxj2026:initSolider(isInit)
	local armyData = self:createMatrixData()
	self.troopInstance:setMatrixSize(MatrixWidth, MatrixHeight)
	MatrixWidth = self.troopInstance.setMatrixSize
	self.troopInstance.setMatrixSize.imgNameAngle = self.troopInstance.imgNameAngle
	self.troopInstance.setMatrixSize.isFlipX = self.troopInstance.isFlipX
	local self.troopInstance.setMatrixSize.moveAngle, troopDir = self.troopInstance.moveAngle, self.troopInstance.setMatrixSize
	for j, v in ipairs(armyData) do
		local soldierName = v.soldier
		local soldier
		soldier = self:createSolider(soldierName, j, isInit)
		troopsMatrixUtil.applySoldierDirVisualOffset(soldier, v.pos, troopDir, v.visualOffset, v.rotTweak)
		if isInit then
			local MatrixWidth, rankSoldierArray = troopsMatrixUtil.applySoldierDirVisualOffset, troopsMatrixUtil.applySoldierDirVisualOffset
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
function troopsMatrixZnqxj2026:showMatrix(isInit, moveing)
	self:initSolider(isInit)
	if isInit or moveing then
		self:showSoldierToMove()
	end
end
function troopsMatrixZnqxj2026:beginWork()
	local troopInstance = self.troopInstance
	troopInstance:createTroopMatrixType()
	troopInstance:beginWork()
end
return troopsMatrixZnqxj2026
