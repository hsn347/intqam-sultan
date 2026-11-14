local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixPJSS = class("troopsMatrixPJSS", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 350
local MatrixHeight = 140
function troopsMatrixPJSS:ctor(troopInstance)
	self.troopInstance = self.troopInstance
end
_ENV, _UPVALUE6_, troopsMatrixPJSS.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_PJSS
end, function(self)
	return MatrixType.MatrixType_PJSS
end
;(nil).soldier = worldMapDefine.soldierType_PJSSJL
_ENV, (nil).pos = cc.p(321.97, 84.82), cc.p(321.97, 84.82)
cc.p(321.97, 84.82).soldier = worldMapDefine.soldierType_PJSSXB
_ENV, cc.p(321.97, 84.82).pos = cc.p(237.69, 124.0), cc.p(237.69, 124.0)
cc.p(237.69, 124.0).soldier = worldMapDefine.soldierType_PJSSXB
_ENV, cc.p(237.69, 124.0).pos = cc.p(215.59, 55.65), cc.p(215.59, 55.65)
cc.p(215.59, 55.65).soldier = worldMapDefine.soldierType_PJSSXB
_ENV, cc.p(215.59, 55.65).pos = cc.p(141.85, 84.31), cc.p(141.85, 84.31)
cc.p(141.85, 84.31).soldier = worldMapDefine.soldierType_PJSSXB
_ENV, cc.p(141.85, 84.31).pos = cc.p(75.11, 128.08), cc.p(75.11, 128.08)
cc.p(75.11, 128.08).soldier = worldMapDefine.soldierType_PJSSXB
cc.p(75.11, 128.08).pos = cc.p(52.65, 50.23)
;(function(self)
	return MatrixType.MatrixType_PJSS
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_PJSS
end)[2] = cc.p(321.97, 84.82)
;(function(self)
	return MatrixType.MatrixType_PJSS
end)[3] = cc.p(237.69, 124.0)
;(function(self)
	return MatrixType.MatrixType_PJSS
end)[4] = cc.p(215.59, 55.65)
;(function(self)
	return MatrixType.MatrixType_PJSS
end)[5] = cc.p(141.85, 84.31)
local (function(self)
	return MatrixType.MatrixType_PJSS
end)[6], armyConfig = cc.p(75.11, 128.08), function(self)
	return MatrixType.MatrixType_PJSS
end
function troopsMatrixPJSS:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	local soliderModelNum_gongbing = 0
	for _, v in ipairs(armyData) do
		if v.soldier == worldMapDefine.soldierType_PJSSJL then
			soliderModelNum_gongbing = soliderModelNum_gongbing + 1
		else
			soliderModelNum_bubing = soliderModelNum_bubing + 1
		end
	end
	self.halfRoundNum = soliderModelNum_bubing
	self.gongjianNum = soliderModelNum_gongbing
	return armyData
end
function troopsMatrixPJSS:initSolider(isInit)
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
return troopsMatrixPJSS
