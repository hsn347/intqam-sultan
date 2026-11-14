local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixBalloon = class("troopsMatrixBalloon", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 350
local MatrixHeight = 140
function troopsMatrixBalloon:ctor(troopInstance)
end
_ENV, _UPVALUE4_, troopsMatrixBalloon.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_Balloon
end, function(self)
	return MatrixType.MatrixType_Balloon
end
;(nil).soldier = worldMapDefine.soldierType_zsjdq
_ENV, (nil).pos = cc.p(290, 70), cc.p(290, 70)
cc.p(290, 70).soldier = worldMapDefine.soldierType_zsjxq
_ENV, cc.p(290, 70).pos = cc.p(145, 45), cc.p(145, 45)
cc.p(145, 45).soldier = worldMapDefine.soldierType_zsjxq
_ENV, cc.p(145, 45).pos = cc.p(90, 85), cc.p(90, 85)
cc.p(90, 85).soldier = worldMapDefine.soldierType_zsjxq
cc.p(90, 85).pos = cc.p(45, 40)
;(function(self)
	return MatrixType.MatrixType_Balloon
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_Balloon
end)[2] = cc.p(290, 70)
;(function(self)
	return MatrixType.MatrixType_Balloon
end)[3] = cc.p(145, 45)
local (function(self)
	return MatrixType.MatrixType_Balloon
end)[4], armyConfig = cc.p(90, 85), function(self)
	return MatrixType.MatrixType_Balloon
end
function troopsMatrixBalloon:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	for k, v in ipairs(armyData) do
		soliderModelNum_bubing = soliderModelNum_bubing + 1
	end
	self.halfRoundNum = soliderModelNum_bubing
	return armyData
end
function troopsMatrixBalloon:initSolider(isInit)
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
function troopsMatrixBalloon:showMatrix(isInit, moveing)
	self:initSolider(isInit)
	if isInit or moveing then
		self:showSoldierToMove()
	end
end
function troopsMatrixBalloon:beginWork()
	local troopInstance = self.troopInstance
	troopInstance:createTroopMatrixType()
	troopInstance:beginWork()
end
return troopsMatrixBalloon
