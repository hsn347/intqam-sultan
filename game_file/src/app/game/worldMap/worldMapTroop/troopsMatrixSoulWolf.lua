local troopsMatrixBase = include("troopsMatrixBase")
local troopsMatrixSoulWolf = class("troopsMatrixSoulWolf", function(troopInstance)
	local target = troopsMatrixBase.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 350
local MatrixHeight = 140
function troopsMatrixSoulWolf:ctor(troopInstance)
end
_ENV, _UPVALUE6_, troopsMatrixSoulWolf.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_SoulWolf
end, function(self)
	return MatrixType.MatrixType_SoulWolf
end
;(nil).soldier = worldMapDefine.soldierType_chuan
_ENV, (nil).pos = cc.p(210, 50), cc.p(210, 50)
cc.p(210, 50).soldier = worldMapDefine.soldierType_xuelang
_ENV, cc.p(210, 50).pos = cc.p(320, 36), cc.p(320, 36)
cc.p(320, 36).soldier = worldMapDefine.soldierType_xuelang
_ENV, cc.p(320, 36).pos = cc.p(240, -9), cc.p(240, -9)
cc.p(240, -9).soldier = worldMapDefine.soldierType_xuelang
_ENV, cc.p(240, -9).pos = cc.p(385, 66), cc.p(385, 66)
cc.p(385, 66).soldier = worldMapDefine.soldierType_xuelang
_ENV, cc.p(385, 66).pos = cc.p(343, 103), cc.p(343, 103)
cc.p(343, 103).soldier = worldMapDefine.soldierType_xuelang
cc.p(343, 103).pos = cc.p(250, 124)
;(function(self)
	return MatrixType.MatrixType_SoulWolf
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_SoulWolf
end)[2] = cc.p(210, 50)
;(function(self)
	return MatrixType.MatrixType_SoulWolf
end)[3] = cc.p(320, 36)
;(function(self)
	return MatrixType.MatrixType_SoulWolf
end)[4] = cc.p(240, -9)
;(function(self)
	return MatrixType.MatrixType_SoulWolf
end)[5] = cc.p(385, 66)
local (function(self)
	return MatrixType.MatrixType_SoulWolf
end)[6], armyConfig = cc.p(343, 103), function(self)
	return MatrixType.MatrixType_SoulWolf
end
function troopsMatrixSoulWolf:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	for k, v in ipairs(armyData) do
		soliderModelNum_bubing = soliderModelNum_bubing + 1
	end
	self.halfRoundNum = soliderModelNum_bubing
	return armyData
end
function troopsMatrixSoulWolf:initSolider(isInit)
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
function troopsMatrixSoulWolf:showMatrix(isInit, moveing)
	self:initSolider(isInit)
	if isInit or moveing then
		self:showSoldierToMove()
	end
end
function troopsMatrixSoulWolf:beginWork()
	local troopInstance = self.troopInstance
	troopInstance:createTroopMatrixType()
	troopInstance:beginWork()
end
return troopsMatrixSoulWolf
