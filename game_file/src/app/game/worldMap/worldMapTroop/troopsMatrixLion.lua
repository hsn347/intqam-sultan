local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixLion = class("troopsMatrixLion", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 400
local MatrixHeight = 140
function troopsMatrixLion:ctor(troopInstance)
end
_ENV, _UPVALUE11_, troopsMatrixLion.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_Lion
end, function(self)
	return MatrixType.MatrixType_Lion
end
;(nil).soldier = worldMapDefine.soldierType_Lion
_ENV, (nil).pos = cc.p(400, 60), cc.p(400, 60)
cc.p(400, 60).soldier = worldMapDefine.soldierType_LionQi
_ENV, cc.p(400, 60).pos = cc.p(330.55, 100.62), cc.p(330.55, 100.62)
cc.p(330.55, 100.62).soldier = worldMapDefine.soldierType_LionQi
_ENV, cc.p(330.55, 100.62).pos = cc.p(337.7, 60.57), cc.p(337.7, 60.57)
cc.p(337.7, 60.57).soldier = worldMapDefine.soldierType_LionQi
_ENV, cc.p(337.7, 60.57).pos = cc.p(270, 88.79), cc.p(270, 88.79)
cc.p(270, 88.79).soldier = worldMapDefine.soldierType_LionQi
_ENV, cc.p(270, 88.79).pos = cc.p(204.26, 115.46), cc.p(204.26, 115.46)
cc.p(204.26, 115.46).soldier = worldMapDefine.soldierType_LionQi
_ENV, cc.p(204.26, 115.46).pos = cc.p(126.08, 34.56), cc.p(126.08, 34.56)
cc.p(126.08, 34.56).soldier = worldMapDefine.soldierType_LionQi
_ENV, cc.p(126.08, 34.56).pos = cc.p(302.09, 26.2), cc.p(302.09, 26.2)
cc.p(302.09, 26.2).soldier = worldMapDefine.soldierType_LionQi
_ENV, cc.p(302.09, 26.2).pos = cc.p(57.53, 58.89), cc.p(57.53, 58.89)
cc.p(57.53, 58.89).soldier = worldMapDefine.soldierType_LionQi
_ENV, cc.p(57.53, 58.89).pos = cc.p(140.39, 78.94), cc.p(140.39, 78.94)
cc.p(140.39, 78.94).soldier = worldMapDefine.soldierType_Lion
_ENV, cc.p(140.39, 78.94).pos = cc.p(204.62, 47.31), cc.p(204.62, 47.31)
cc.p(204.62, 47.31).soldier = worldMapDefine.soldierType_Lion
cc.p(204.62, 47.31).pos = cc.p(103.92, 101.36)
;(function(self)
	return MatrixType.MatrixType_Lion
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_Lion
end)[2] = cc.p(400, 60)
;(function(self)
	return MatrixType.MatrixType_Lion
end)[3] = cc.p(330.55, 100.62)
;(function(self)
	return MatrixType.MatrixType_Lion
end)[4] = cc.p(337.7, 60.57)
;(function(self)
	return MatrixType.MatrixType_Lion
end)[5] = cc.p(270, 88.79)
;(function(self)
	return MatrixType.MatrixType_Lion
end)[6] = cc.p(204.26, 115.46)
;(function(self)
	return MatrixType.MatrixType_Lion
end)[7] = cc.p(126.08, 34.56)
;(function(self)
	return MatrixType.MatrixType_Lion
end)[8] = cc.p(302.09, 26.2)
;(function(self)
	return MatrixType.MatrixType_Lion
end)[9] = cc.p(57.53, 58.89)
;(function(self)
	return MatrixType.MatrixType_Lion
end)[10] = cc.p(140.39, 78.94)
local (function(self)
	return MatrixType.MatrixType_Lion
end)[11], armyConfig = cc.p(204.62, 47.31), function(self)
	return MatrixType.MatrixType_Lion
end
function troopsMatrixLion:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	for _, v in ipairs(armyData) do
		soliderModelNum_bubing = soliderModelNum_bubing + 1
	end
	self.halfRoundNum = soliderModelNum_bubing
	return armyData
end
function troopsMatrixLion:initSolider(isInit)
	local armyData = self:createMatrixData()
	self.troopInstance:setMatrixSize(MatrixWidth, MatrixHeight)
	for j, v in ipairs(armyData) do
		local soldierName = v.soldier
		local soldier
		soldier = self:createSolider(soldierName, j, isInit)
		soldier:setSoldierPos(v.pos)
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
return troopsMatrixLion
