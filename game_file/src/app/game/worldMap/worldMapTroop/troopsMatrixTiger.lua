local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixTiger = class("troopsMatrixTiger", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 400
local MatrixHeight = 140
function troopsMatrixTiger:ctor(troopInstance)
	self.troopInstance = self.troopInstance
end
_ENV, _UPVALUE12_, troopsMatrixTiger.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_Tiger
end, function(self)
	return MatrixType.MatrixType_Tiger
end
;(nil).soldier = worldMapDefine.soldierType_whiteTiger
_ENV, (nil).pos = cc.p(137.83, 113.53999999999999), cc.p(137.83, 113.53999999999999)
cc.p(137.83, 113.53999999999999).soldier = worldMapDefine.soldierType_whiteTiger2Qi
_ENV, cc.p(137.83, 113.53999999999999).pos = cc.p(247.5, 89.0), cc.p(247.5, 89.0)
cc.p(247.5, 89.0).soldier = worldMapDefine.soldierType_whiteTiger
_ENV, cc.p(247.5, 89.0).pos = cc.p(357.0, 91.5), cc.p(357.0, 91.5)
cc.p(357.0, 91.5).soldier = worldMapDefine.soldierType_whiteTiger
_ENV, cc.p(357.0, 91.5).pos = cc.p(451.0, 78.0), cc.p(451.0, 78.0)
cc.p(451.0, 78.0).soldier = worldMapDefine.soldierType_whiteTigerQi
_ENV, cc.p(451.0, 78.0).pos = cc.p(413.0, 65.5), cc.p(413.0, 65.5)
cc.p(413.0, 65.5).soldier = worldMapDefine.soldierType_whiteTiger
_ENV, cc.p(413.0, 65.5).pos = cc.p(267.55, 57.900000000000006), cc.p(267.55, 57.900000000000006)
cc.p(267.55, 57.900000000000006).soldier = worldMapDefine.soldierType_whiteTiger2Qi
_ENV, cc.p(267.55, 57.900000000000006).pos = cc.p(345.99, 47.709999999999994), cc.p(345.99, 47.709999999999994)
cc.p(345.99, 47.709999999999994).soldier = worldMapDefine.soldierType_whiteTiger2Qi
_ENV, cc.p(345.99, 47.709999999999994).pos = cc.p(62.17, 87.02), cc.p(62.17, 87.02)
cc.p(62.17, 87.02).soldier = worldMapDefine.soldierType_whiteTiger
_ENV, cc.p(62.17, 87.02).pos = cc.p(93.0, 58.0), cc.p(93.0, 58.0)
cc.p(93.0, 58.0).soldier = worldMapDefine.soldierType_whiteTiger
_ENV, cc.p(93.0, 58.0).pos = cc.p(301.32, 27.869999999999997), cc.p(301.32, 27.869999999999997)
cc.p(301.32, 27.869999999999997).soldier = worldMapDefine.soldierType_whiteTiger
_ENV, cc.p(301.32, 27.869999999999997).pos = cc.p(170.0, 77.5), cc.p(170.0, 77.5)
cc.p(170.0, 77.5).soldier = worldMapDefine.soldierType_whiteTiger2Qi
cc.p(170.0, 77.5).pos = cc.p(189.9, 32.14)
;(function(self)
	return MatrixType.MatrixType_Tiger
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_Tiger
end)[2] = cc.p(137.83, 113.53999999999999)
;(function(self)
	return MatrixType.MatrixType_Tiger
end)[3] = cc.p(247.5, 89.0)
;(function(self)
	return MatrixType.MatrixType_Tiger
end)[4] = cc.p(357.0, 91.5)
;(function(self)
	return MatrixType.MatrixType_Tiger
end)[5] = cc.p(451.0, 78.0)
;(function(self)
	return MatrixType.MatrixType_Tiger
end)[6] = cc.p(413.0, 65.5)
;(function(self)
	return MatrixType.MatrixType_Tiger
end)[7] = cc.p(267.55, 57.900000000000006)
;(function(self)
	return MatrixType.MatrixType_Tiger
end)[8] = cc.p(345.99, 47.709999999999994)
;(function(self)
	return MatrixType.MatrixType_Tiger
end)[9] = cc.p(62.17, 87.02)
;(function(self)
	return MatrixType.MatrixType_Tiger
end)[10] = cc.p(93.0, 58.0)
;(function(self)
	return MatrixType.MatrixType_Tiger
end)[11] = cc.p(301.32, 27.869999999999997)
local (function(self)
	return MatrixType.MatrixType_Tiger
end)[12], armyConfig = cc.p(170.0, 77.5), function(self)
	return MatrixType.MatrixType_Tiger
end
function troopsMatrixTiger:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	for _, v in ipairs(armyData) do
		soliderModelNum_bubing = soliderModelNum_bubing + 1
	end
	self.halfRoundNum = soliderModelNum_bubing
	return armyData
end
function troopsMatrixTiger:initSolider(isInit)
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
return troopsMatrixTiger
