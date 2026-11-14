local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixStarShip = class("troopsMatrixStarShip", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 350
local MatrixHeight = 140
function troopsMatrixStarShip:ctor(troopInstance)
	self.troopInstance = self.troopInstance
end
_ENV, _UPVALUE5_, troopsMatrixStarShip.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_StarShip
end, function(self)
	return MatrixType.MatrixType_StarShip
end
;(nil).soldier = worldMapDefine.soldierType_starship
_ENV, (nil).pos = cc.p(339.24, 47.62), cc.p(339.24, 47.62)
cc.p(339.24, 47.62).soldier = worldMapDefine.soldierType_starshipx
_ENV, cc.p(339.24, 47.62).pos = cc.p(181.37, 93.71), cc.p(181.37, 93.71)
cc.p(181.37, 93.71).soldier = worldMapDefine.soldierType_starshipx
_ENV, cc.p(181.37, 93.71).pos = cc.p(164.88, -18.51), cc.p(164.88, -18.51)
cc.p(164.88, -18.51).soldier = worldMapDefine.soldierType_starshipx
_ENV, cc.p(164.88, -18.51).pos = cc.p(76.35, 126.21), cc.p(76.35, 126.21)
cc.p(76.35, 126.21).soldier = worldMapDefine.soldierType_starshipx
cc.p(76.35, 126.21).pos = cc.p(39.67, -40.04)
;(function(self)
	return MatrixType.MatrixType_StarShip
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_StarShip
end)[2] = cc.p(339.24, 47.62)
;(function(self)
	return MatrixType.MatrixType_StarShip
end)[3] = cc.p(181.37, 93.71)
;(function(self)
	return MatrixType.MatrixType_StarShip
end)[4] = cc.p(164.88, -18.51)
local (function(self)
	return MatrixType.MatrixType_StarShip
end)[5], armyConfig = cc.p(76.35, 126.21), function(self)
	return MatrixType.MatrixType_StarShip
end
function troopsMatrixStarShip:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	local soliderModelNum_gongbing = 0
	for k, v in ipairs(armyData) do
		soliderModelNum_gongbing = soliderModelNum_gongbing + 1
	end
	self.halfRoundNum = soliderModelNum_bubing
	self.gongjianNum = soliderModelNum_gongbing
	return armyData
end
function troopsMatrixStarShip:initSolider(isInit)
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
return troopsMatrixStarShip
