local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixTrain = class("troopsMatrixTrain", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 350
local MatrixHeight = 140
function troopsMatrixTrain:ctor(troopInstance)
end
_ENV, _UPVALUE1_, troopsMatrixTrain.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_Train
end, function(self)
	return MatrixType.MatrixType_Train
end
;(nil).soldier = worldMapDefine.soldierType_train
;(nil).pos = cc.p(220, 60)
local (function(self)
	return MatrixType.MatrixType_Train
end)[1], armyConfig = nil, function(self)
	return MatrixType.MatrixType_Train
end
function troopsMatrixTrain:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	for k, v in ipairs(armyData) do
		soliderModelNum_bubing = soliderModelNum_bubing + 1
	end
	self.halfRoundNum = soliderModelNum_bubing
	return armyData
end
function troopsMatrixTrain:initSolider(isInit)
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
function troopsMatrixTrain:showMatrix(isInit, moveing)
	self:initSolider(isInit)
	if isInit or moveing then
		self:showSoldierToMove()
	end
end
function troopsMatrixTrain:beginWork()
	local troopInstance = self.troopInstance
	troopInstance:createTroopMatrixType()
	troopInstance:beginWork()
end
return troopsMatrixTrain
