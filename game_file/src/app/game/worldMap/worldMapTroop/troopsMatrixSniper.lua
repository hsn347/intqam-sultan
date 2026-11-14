local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixSniper = class("troopsMatrixSniper", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 260
local MatrixHeight = 160
function troopsMatrixSniper:ctor(troopInstance)
	self.troopInstance = self.troopInstance
end
_ENV, _UPVALUE9_, troopsMatrixSniper.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_Sniper
end, function(self)
	return MatrixType.MatrixType_Sniper
end
;(nil).soldier = worldMapDefine.soldierType_SniperBing
_ENV, (nil).pos = cc.p(36.79, 53.85), cc.p(36.79, 53.85)
cc.p(36.79, 53.85).soldier = worldMapDefine.soldierType_SniperBing
_ENV, cc.p(36.79, 53.85).pos = cc.p(56.27, 112.74), cc.p(56.27, 112.74)
cc.p(56.27, 112.74).soldier = worldMapDefine.soldierType_SniperBing
_ENV, cc.p(56.27, 112.74).pos = cc.p(87.85, 81.25), cc.p(87.85, 81.25)
cc.p(87.85, 81.25).soldier = worldMapDefine.soldierType_SniperBing
_ENV, cc.p(87.85, 81.25).pos = cc.p(114.33, 35.41), cc.p(114.33, 35.41)
cc.p(114.33, 35.41).soldier = worldMapDefine.soldierType_SniperBing
_ENV, cc.p(114.33, 35.41).pos = cc.p(104.72, 133.83), cc.p(104.72, 133.83)
cc.p(104.72, 133.83).soldier = worldMapDefine.soldierType_SniperBing
_ENV, cc.p(104.72, 133.83).pos = cc.p(140.89, 95.25), cc.p(140.89, 95.25)
cc.p(140.89, 95.25).soldier = worldMapDefine.soldierType_SniperBing
_ENV, cc.p(140.89, 95.25).pos = cc.p(170.82, 52.58), cc.p(170.82, 52.58)
cc.p(170.82, 52.58).soldier = worldMapDefine.soldierType_SniperBing
_ENV, cc.p(170.82, 52.58).pos = cc.p(185.52, 116.04), cc.p(185.52, 116.04)
cc.p(185.52, 116.04).soldier = worldMapDefine.soldierType_Sniper
cc.p(185.52, 116.04).pos = cc.p(226.53, 91.45)
;(function(self)
	return MatrixType.MatrixType_Sniper
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_Sniper
end)[2] = cc.p(36.79, 53.85)
;(function(self)
	return MatrixType.MatrixType_Sniper
end)[3] = cc.p(56.27, 112.74)
;(function(self)
	return MatrixType.MatrixType_Sniper
end)[4] = cc.p(87.85, 81.25)
;(function(self)
	return MatrixType.MatrixType_Sniper
end)[5] = cc.p(114.33, 35.41)
;(function(self)
	return MatrixType.MatrixType_Sniper
end)[6] = cc.p(104.72, 133.83)
;(function(self)
	return MatrixType.MatrixType_Sniper
end)[7] = cc.p(140.89, 95.25)
;(function(self)
	return MatrixType.MatrixType_Sniper
end)[8] = cc.p(170.82, 52.58)
local (function(self)
	return MatrixType.MatrixType_Sniper
end)[9], armyConfig = cc.p(185.52, 116.04), function(self)
	return MatrixType.MatrixType_Sniper
end
function troopsMatrixSniper:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_leadbing = 0
	local soliderModelNum_gongbing = 0
	for _, v in ipairs(armyData) do
		soliderModelNum_gongbing = soliderModelNum_gongbing + 1
	end
	self.gongjianNum = soliderModelNum_gongbing
	return armyData
end
function troopsMatrixSniper:initSolider(isInit)
	print("troopsMatrixSniper")
	local armyData = self:createMatrixData()
	self.troopInstance:setMatrixSize(MatrixWidth, MatrixHeight)
	for j, v in ipairs(armyData) do
		local soldierName = v.soldier
		local soldier
		soldier = self:createSolider(soldierName, j, isInit)
		soldier:setSoldierPos(v.pos)
		if isInit then
			local _ENV, rankSoldierArray = soldier.setSoldierPos, soldier.setSoldierPos
			rankSoldierArray[#rankSoldierArray + 1] = soldier
			local length = MatrixWidth - v.pos.x
			_ENV = v.pos.x
			v.pos.x.length = length
			local v.pos.x.soldierArray, rankSoldiers = rankSoldierArray, v.pos.x
			self:addShowRankSoldier(rankSoldiers)
		end
	end
	self:createDivineBeast(isInit, #armyData)
end
return troopsMatrixSniper
