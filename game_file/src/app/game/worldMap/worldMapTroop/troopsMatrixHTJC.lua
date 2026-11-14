local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixHTJC = class("troopsMatrixHTJC", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 350
local MatrixHeight = 140
function troopsMatrixHTJC:ctor(troopInstance)
	self.troopInstance = self.troopInstance
end
_ENV, _UPVALUE6_, troopsMatrixHTJC.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_HTJC
end, function(self)
	return MatrixType.MatrixType_HTJC
end
;(nil).soldier = worldMapDefine.soldierType_HTJCJiangLing
_ENV, (nil).pos = cc.p(285.31, 83.73), cc.p(285.31, 83.73)
cc.p(285.31, 83.73).soldier = worldMapDefine.soldierType_HTJCXiaoBing
_ENV, cc.p(285.31, 83.73).pos = cc.p(174.81, 117.16), cc.p(174.81, 117.16)
cc.p(174.81, 117.16).soldier = worldMapDefine.soldierType_HTJCXiaoBing
_ENV, cc.p(174.81, 117.16).pos = cc.p(162.03, 45.97), cc.p(162.03, 45.97)
cc.p(162.03, 45.97).soldier = worldMapDefine.soldierType_HTJCXiaoBing
_ENV, cc.p(162.03, 45.97).pos = cc.p(69.88, 85.35), cc.p(69.88, 85.35)
cc.p(69.88, 85.35).soldier = worldMapDefine.soldierType_HTJCXiaoBing
_ENV, cc.p(69.88, 85.35).pos = cc.p(-17.43, 130.09), cc.p(-17.43, 130.09)
cc.p(-17.43, 130.09).soldier = worldMapDefine.soldierType_HTJCXiaoBing
cc.p(-17.43, 130.09).pos = cc.p(-46.93, 43.88)
;(function(self)
	return MatrixType.MatrixType_HTJC
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_HTJC
end)[2] = cc.p(285.31, 83.73)
;(function(self)
	return MatrixType.MatrixType_HTJC
end)[3] = cc.p(174.81, 117.16)
;(function(self)
	return MatrixType.MatrixType_HTJC
end)[4] = cc.p(162.03, 45.97)
;(function(self)
	return MatrixType.MatrixType_HTJC
end)[5] = cc.p(69.88, 85.35)
local (function(self)
	return MatrixType.MatrixType_HTJC
end)[6], armyConfig = cc.p(-17.43, 130.09), function(self)
	return MatrixType.MatrixType_HTJC
end
function troopsMatrixHTJC:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	local soliderModelNum_gongbing = 0
	for _, v in ipairs(armyData) do
		if v.soldier == worldMapDefine.soldierType_HTJCJiangLing then
			soliderModelNum_gongbing = soliderModelNum_gongbing + 1
		else
			soliderModelNum_bubing = soliderModelNum_bubing + 1
		end
	end
	self.halfRoundNum = soliderModelNum_bubing
	self.gongjianNum = soliderModelNum_gongbing
	return armyData
end
function troopsMatrixHTJC:initSolider(isInit)
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
return troopsMatrixHTJC
