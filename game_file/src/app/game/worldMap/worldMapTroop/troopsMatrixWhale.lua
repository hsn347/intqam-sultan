local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixWhale = class("troopsMatrixWhale", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 350
local MatrixHeight = 140
function troopsMatrixWhale:ctor(troopInstance)
end
_ENV, _UPVALUE1_, troopsMatrixWhale.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_Whale
end, function(self)
	return MatrixType.MatrixType_Whale
end
;(nil).soldier = worldMapDefine.soldierType_whale
;(nil).pos = cc.p(220, 60)
local (function(self)
	return MatrixType.MatrixType_Whale
end)[1], armyConfig = nil, function(self)
	return MatrixType.MatrixType_Whale
end
function troopsMatrixWhale:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	for k, v in ipairs(armyData) do
		soliderModelNum_bubing = soliderModelNum_bubing + 1
	end
	self.halfRoundNum = soliderModelNum_bubing
	return armyData
end
function troopsMatrixWhale:initSolider(isInit)
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
function troopsMatrixWhale:showMatrix(isInit, moveing)
	self:initSolider(isInit)
	if isInit or moveing then
		self:showSoldierToMove()
	end
end
function troopsMatrixWhale:beginWork()
	local troopInstance = self.troopInstance
	troopInstance:createTroopMatrixType()
	troopInstance:beginWork()
end
return troopsMatrixWhale
