local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixHYFL = class("troopsMatrixHYFL", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 350
local MatrixHeight = 140
function troopsMatrixHYFL:ctor(troopInstance)
	self.troopInstance = self.troopInstance
end
_ENV, _UPVALUE6_, troopsMatrixHYFL.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_HYFL
end, function(self)
	return MatrixType.MatrixType_HYFL
end
;(nil).soldier = worldMapDefine.soldierType_HYFLHuoLong
_ENV, (nil).pos = cc.p(351.72, 80.43), cc.p(351.72, 80.43)
cc.p(351.72, 80.43).soldier = worldMapDefine.soldierType_HYFLXiaoLong
_ENV, cc.p(351.72, 80.43).pos = cc.p(237.56, 107.48), cc.p(237.56, 107.48)
cc.p(237.56, 107.48).soldier = worldMapDefine.soldierType_HYFLXiaoLong
_ENV, cc.p(237.56, 107.48).pos = cc.p(198.34, 63.36), cc.p(198.34, 63.36)
cc.p(198.34, 63.36).soldier = worldMapDefine.soldierType_HYFLXiaoLong
_ENV, cc.p(198.34, 63.36).pos = cc.p(81.23, 49.2), cc.p(81.23, 49.2)
cc.p(81.23, 49.2).soldier = worldMapDefine.soldierType_HYFLXiaoLong
_ENV, cc.p(81.23, 49.2).pos = cc.p(125.35, 115.65), cc.p(125.35, 115.65)
cc.p(125.35, 115.65).soldier = worldMapDefine.soldierType_HYFLXiaoLong
cc.p(125.35, 115.65).pos = cc.p(19.49, 96.23)
;(function(self)
	return MatrixType.MatrixType_HYFL
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_HYFL
end)[2] = cc.p(351.72, 80.43)
;(function(self)
	return MatrixType.MatrixType_HYFL
end)[3] = cc.p(237.56, 107.48)
;(function(self)
	return MatrixType.MatrixType_HYFL
end)[4] = cc.p(198.34, 63.36)
;(function(self)
	return MatrixType.MatrixType_HYFL
end)[5] = cc.p(81.23, 49.2)
local (function(self)
	return MatrixType.MatrixType_HYFL
end)[6], armyConfig = cc.p(125.35, 115.65), function(self)
	return MatrixType.MatrixType_HYFL
end
function troopsMatrixHYFL:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	local soliderModelNum_gongbing = 0
	for _, v in ipairs(armyData) do
		if v.soldier == worldMapDefine.soldierType_HYFLHuoLong then
			soliderModelNum_gongbing = soliderModelNum_gongbing + 1
		else
			soliderModelNum_bubing = soliderModelNum_bubing + 1
		end
	end
	self.halfRoundNum = soliderModelNum_bubing
	self.gongjianNum = soliderModelNum_gongbing
	return armyData
end
function troopsMatrixHYFL:initSolider(isInit)
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
return troopsMatrixHYFL
