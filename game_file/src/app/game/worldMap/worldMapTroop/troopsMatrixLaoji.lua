local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixLaoji = class("troopsMatrixLaoji", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 350
local MatrixHeight = 140
function troopsMatrixLaoji:ctor(troopInstance)
	self.troopInstance = self.troopInstance
end
_ENV, _UPVALUE9_, troopsMatrixLaoji.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_Laoji
end, function(self)
	return MatrixType.MatrixType_Laoji
end
;(nil).soldier = worldMapDefine.soldierType_LaojiYingXiong
_ENV, (nil).pos = cc.p(285.13, 83.72), cc.p(285.13, 83.72)
cc.p(285.13, 83.72).soldier = worldMapDefine.soldierType_LaojiXiaoBing
_ENV, cc.p(285.13, 83.72).pos = cc.p(229.3, 100.07), cc.p(229.3, 100.07)
cc.p(229.3, 100.07).soldier = worldMapDefine.soldierType_LaojiXiaoBing
_ENV, cc.p(229.3, 100.07).pos = cc.p(200.19, 44.81), cc.p(200.19, 44.81)
cc.p(200.19, 44.81).soldier = worldMapDefine.soldierType_LaojiXiaoBing
_ENV, cc.p(200.19, 44.81).pos = cc.p(173.34, 112.89), cc.p(173.34, 112.89)
cc.p(173.34, 112.89).soldier = worldMapDefine.soldierType_LaojiXiaoBing
_ENV, cc.p(173.34, 112.89).pos = cc.p(145.88, 64.71), cc.p(145.88, 64.71)
cc.p(145.88, 64.71).soldier = worldMapDefine.soldierType_LaojiXiaoBing
_ENV, cc.p(145.88, 64.71).pos = cc.p(109.53, 80.03), cc.p(109.53, 80.03)
cc.p(109.53, 80.03).soldier = worldMapDefine.soldierType_LaojiXiaoBing
_ENV, cc.p(109.53, 80.03).pos = cc.p(81.74, 111.33), cc.p(81.74, 111.33)
cc.p(81.74, 111.33).soldier = worldMapDefine.soldierType_LaojiXiaoBing
_ENV, cc.p(81.74, 111.33).pos = cc.p(65.6, 41.53), cc.p(65.6, 41.53)
cc.p(65.6, 41.53).soldier = worldMapDefine.soldierType_LaojiXiaoBing
cc.p(65.6, 41.53).pos = cc.p(29.05, 83.42)
;(function(self)
	return MatrixType.MatrixType_Laoji
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_Laoji
end)[2] = cc.p(285.13, 83.72)
;(function(self)
	return MatrixType.MatrixType_Laoji
end)[3] = cc.p(229.3, 100.07)
;(function(self)
	return MatrixType.MatrixType_Laoji
end)[4] = cc.p(200.19, 44.81)
;(function(self)
	return MatrixType.MatrixType_Laoji
end)[5] = cc.p(173.34, 112.89)
;(function(self)
	return MatrixType.MatrixType_Laoji
end)[6] = cc.p(145.88, 64.71)
;(function(self)
	return MatrixType.MatrixType_Laoji
end)[7] = cc.p(109.53, 80.03)
;(function(self)
	return MatrixType.MatrixType_Laoji
end)[8] = cc.p(81.74, 111.33)
local (function(self)
	return MatrixType.MatrixType_Laoji
end)[9], armyConfig = cc.p(65.6, 41.53), function(self)
	return MatrixType.MatrixType_Laoji
end
function troopsMatrixLaoji:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	local soliderModelNum_gongbing = 0
	for _, v in ipairs(armyData) do
		if v.soldier == worldMapDefine.soldierType_LaojiYingXiong then
			soliderModelNum_gongbing = soliderModelNum_gongbing + 1
		else
			soliderModelNum_bubing = soliderModelNum_bubing + 1
		end
	end
	self.halfRoundNum = soliderModelNum_bubing
	self.gongjianNum = soliderModelNum_gongbing
	return armyData
end
function troopsMatrixLaoji:initSolider(isInit)
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
return troopsMatrixLaoji
