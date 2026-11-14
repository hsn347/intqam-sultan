local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixTrick = class("troopsMatrixTrick", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 270
local MatrixHeight = 100
function troopsMatrixTrick:ctor(troopInstance)
	self.troopInstance = self.troopInstance
end
_ENV, _UPVALUE11_, troopsMatrixTrick.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_Trick
end, function(self)
	return MatrixType.MatrixType_Trick
end
;(nil).soldier = worldMapDefine.soldierType_Trick
_ENV, (nil).pos = cc.p(237, 68), cc.p(237, 68)
cc.p(237, 68).soldier = worldMapDefine.soldierType_TrickLang
_ENV, cc.p(237, 68).pos = cc.p(205, 99), cc.p(205, 99)
cc.p(205, 99).soldier = worldMapDefine.soldierType_TrickGzsb
_ENV, cc.p(205, 99).pos = cc.p(205, 51), cc.p(205, 51)
cc.p(205, 51).soldier = worldMapDefine.soldierType_TrickGzsb
_ENV, cc.p(205, 51).pos = cc.p(149, 99), cc.p(149, 99)
cc.p(149, 99).soldier = worldMapDefine.soldierType_TrickGzsb
_ENV, cc.p(149, 99).pos = cc.p(103, 31), cc.p(103, 31)
cc.p(103, 31).soldier = worldMapDefine.soldierType_TrickGzsb
_ENV, cc.p(103, 31).pos = cc.p(48, 59), cc.p(48, 59)
cc.p(48, 59).soldier = worldMapDefine.soldierType_TrickLang
_ENV, cc.p(48, 59).pos = cc.p(47, 103), cc.p(47, 103)
cc.p(47, 103).soldier = worldMapDefine.soldierType_TrickLang
_ENV, cc.p(47, 103).pos = cc.p(150, 31), cc.p(150, 31)
cc.p(150, 31).soldier = worldMapDefine.soldierType_TrickLang
_ENV, cc.p(150, 31).pos = cc.p(159, 63), cc.p(159, 63)
cc.p(159, 63).soldier = worldMapDefine.soldierType_TrickLang
_ENV, cc.p(159, 63).pos = cc.p(103, 92), cc.p(103, 92)
cc.p(103, 92).soldier = worldMapDefine.soldierType_TrickLang
cc.p(103, 92).pos = cc.p(48, 31)
;(function(self)
	return MatrixType.MatrixType_Trick
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_Trick
end)[2] = cc.p(237, 68)
;(function(self)
	return MatrixType.MatrixType_Trick
end)[3] = cc.p(205, 99)
;(function(self)
	return MatrixType.MatrixType_Trick
end)[4] = cc.p(205, 51)
;(function(self)
	return MatrixType.MatrixType_Trick
end)[5] = cc.p(149, 99)
;(function(self)
	return MatrixType.MatrixType_Trick
end)[6] = cc.p(103, 31)
;(function(self)
	return MatrixType.MatrixType_Trick
end)[7] = cc.p(48, 59)
;(function(self)
	return MatrixType.MatrixType_Trick
end)[8] = cc.p(47, 103)
;(function(self)
	return MatrixType.MatrixType_Trick
end)[9] = cc.p(150, 31)
;(function(self)
	return MatrixType.MatrixType_Trick
end)[10] = cc.p(159, 63)
local (function(self)
	return MatrixType.MatrixType_Trick
end)[11], armyConfig = cc.p(103, 92), function(self)
	return MatrixType.MatrixType_Trick
end
function troopsMatrixTrick:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	local soliderModelNum_gongbing = 0
	for _, v in ipairs(armyData) do
		if v.soldier == worldMapDefine.soldierType_Trick then
			soliderModelNum_gongbing = soliderModelNum_gongbing + 1
		else
			soliderModelNum_bubing = soliderModelNum_bubing + 1
		end
	end
	self.halfRoundNum = soliderModelNum_bubing
	self.gongjianNum = soliderModelNum_gongbing
	return armyData
end
function troopsMatrixTrick:initSolider(isInit)
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
			local length = MatrixWidth - v.pos.x - 50
			MatrixWidth = v.pos.x
			v.pos.x.length = length
			local v.pos.x.soldierArray, rankSoldiers = rankSoldierArray, v.pos.x
			self:addShowRankSoldier(rankSoldiers)
		end
	end
	self:createDivineBeast(isInit, #armyData)
end
return troopsMatrixTrick
