local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixHuaChe = class("troopsMatrixHuaChe", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 450
local MatrixHeight = 140
function troopsMatrixHuaChe:ctor(troopInstance)
end
_ENV, _UPVALUE4_, troopsMatrixHuaChe.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_HuaChe
end, function(self)
	return MatrixType.MatrixType_HuaChe
end
;(nil).soldier = worldMapDefine.soldierType_huachedj
_ENV, (nil).pos = cc.p(340, 43), cc.p(340, 43)
cc.p(340, 43).soldier = worldMapDefine.soldierType_huachexb
_ENV, cc.p(340, 43).pos = cc.p(165, 25), cc.p(165, 25)
cc.p(165, 25).soldier = worldMapDefine.soldierType_huachexb
_ENV, cc.p(165, 25).pos = cc.p(110, 65), cc.p(110, 65)
cc.p(110, 65).soldier = worldMapDefine.soldierType_huachexb
cc.p(110, 65).pos = cc.p(65, 20)
;(function(self)
	return MatrixType.MatrixType_HuaChe
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_HuaChe
end)[2] = cc.p(340, 43)
;(function(self)
	return MatrixType.MatrixType_HuaChe
end)[3] = cc.p(165, 25)
local (function(self)
	return MatrixType.MatrixType_HuaChe
end)[4], armyConfig = cc.p(110, 65), function(self)
	return MatrixType.MatrixType_HuaChe
end
function troopsMatrixHuaChe:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	for k, v in ipairs(armyData) do
		soliderModelNum_bubing = soliderModelNum_bubing + 1
	end
	self.halfRoundNum = soliderModelNum_bubing
	return armyData
end
function troopsMatrixHuaChe:initSolider(isInit)
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
return troopsMatrixHuaChe
