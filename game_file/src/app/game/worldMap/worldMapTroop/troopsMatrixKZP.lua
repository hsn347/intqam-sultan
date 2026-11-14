local troopsMatrixBase = include("troopsMatrixBase")
local troopsMatrixKZP = class("troopsMatrixKZP", function(troopInstance)
	local target = troopsMatrixBase.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 350
local MatrixHeight = 140
function troopsMatrixKZP:ctor(troopInstance)
end
_ENV, _UPVALUE4_, troopsMatrixKZP.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_KZP
end, function(self)
	return MatrixType.MatrixType_KZP
end
;(nil).soldier = worldMapDefine.soldierType_kzpDP
_ENV, (nil).pos = cc.p(427.76, 80.5), cc.p(427.76, 80.5)
cc.p(427.76, 80.5).soldier = worldMapDefine.soldierType_kzpXP
_ENV, cc.p(427.76, 80.5).pos = cc.p(252.93, 120.2), cc.p(252.93, 120.2)
cc.p(252.93, 120.2).soldier = worldMapDefine.soldierType_kzpXP
_ENV, cc.p(252.93, 120.2).pos = cc.p(183.93, 41.2), cc.p(183.93, 41.2)
cc.p(183.93, 41.2).soldier = worldMapDefine.soldierType_kzpXP
cc.p(183.93, 41.2).pos = cc.p(56.93, 93.2)
;(function(self)
	return MatrixType.MatrixType_KZP
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_KZP
end)[2] = cc.p(427.76, 80.5)
;(function(self)
	return MatrixType.MatrixType_KZP
end)[3] = cc.p(252.93, 120.2)
local (function(self)
	return MatrixType.MatrixType_KZP
end)[4], armyConfig = cc.p(183.93, 41.2), function(self)
	return MatrixType.MatrixType_KZP
end
function troopsMatrixKZP:createMatrixData()
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
function troopsMatrixKZP:initSolider(isInit)
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
function troopsMatrixKZP:showMatrix(isInit, moveing)
	self:initSolider(isInit)
	if isInit or moveing then
		self:showSoldierToMove()
	end
end
function troopsMatrixKZP:beginWork()
	local troopInstance = self.troopInstance
	troopInstance:createTroopMatrixType()
	troopInstance:beginWork()
end
return troopsMatrixKZP
