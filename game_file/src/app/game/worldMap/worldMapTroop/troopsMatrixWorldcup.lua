local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixWorldcup = class("troopsMatrixWorldcup", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 260
local MatrixHeight = 140
function troopsMatrixWorldcup:ctor(troopInstance)
	self.troopInstance = self.troopInstance
end
_ENV, _UPVALUE8_, troopsMatrixWorldcup.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_Worldcup
end, function(self)
	return MatrixType.MatrixType_Worldcup
end
;(nil).soldier = worldMapDefine.soldierType_SJB
_ENV, (nil).pos = cc.p(202.56, 61.73), cc.p(202.56, 61.73)
cc.p(202.56, 61.73).soldier = worldMapDefine.soldierType_SJBXB
_ENV, cc.p(202.56, 61.73).pos = cc.p(161.03, 78.38), cc.p(161.03, 78.38)
cc.p(161.03, 78.38).soldier = worldMapDefine.soldierType_SJBXB
_ENV, cc.p(161.03, 78.38).pos = cc.p(157.91, 37.49), cc.p(157.91, 37.49)
cc.p(157.91, 37.49).soldier = worldMapDefine.soldierType_SJBXB
_ENV, cc.p(157.91, 37.49).pos = cc.p(119.21, 92.77), cc.p(119.21, 92.77)
cc.p(119.21, 92.77).soldier = worldMapDefine.soldierType_SJBXB
_ENV, cc.p(119.21, 92.77).pos = cc.p(110.21, 27.79), cc.p(110.21, 27.79)
cc.p(110.21, 27.79).soldier = worldMapDefine.soldierType_SJBXB
_ENV, cc.p(110.21, 27.79).pos = cc.p(77.92, 86.08), cc.p(77.92, 86.08)
cc.p(77.92, 86.08).soldier = worldMapDefine.soldierType_SJBXB
_ENV, cc.p(77.92, 86.08).pos = cc.p(58.8, 33.82), cc.p(58.8, 33.82)
cc.p(58.8, 33.82).soldier = worldMapDefine.soldierType_SJBXB
cc.p(58.8, 33.82).pos = cc.p(29.15, 63.43)
;(function(self)
	return MatrixType.MatrixType_Worldcup
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_Worldcup
end)[2] = cc.p(202.56, 61.73)
;(function(self)
	return MatrixType.MatrixType_Worldcup
end)[3] = cc.p(161.03, 78.38)
;(function(self)
	return MatrixType.MatrixType_Worldcup
end)[4] = cc.p(157.91, 37.49)
;(function(self)
	return MatrixType.MatrixType_Worldcup
end)[5] = cc.p(119.21, 92.77)
;(function(self)
	return MatrixType.MatrixType_Worldcup
end)[6] = cc.p(110.21, 27.79)
;(function(self)
	return MatrixType.MatrixType_Worldcup
end)[7] = cc.p(77.92, 86.08)
local (function(self)
	return MatrixType.MatrixType_Worldcup
end)[8], armyConfig = cc.p(58.8, 33.82), function(self)
	return MatrixType.MatrixType_Worldcup
end
function troopsMatrixWorldcup:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	local soliderModelNum_gongbing = 0
	for _, v in ipairs(armyData) do
		if v.soldier == worldMapDefine.soldierType_SJB then
			soliderModelNum_gongbing = soliderModelNum_gongbing + 1
		else
			soliderModelNum_bubing = soliderModelNum_bubing + 1
		end
	end
	self.halfRoundNum = soliderModelNum_bubing
	self.gongjianNum = soliderModelNum_gongbing
	return armyData
end
function troopsMatrixWorldcup:initSolider(isInit)
	local armyData = self:createMatrixData()
	self.troopInstance:setMatrixSize(MatrixWidth, MatrixHeight)
	for j, v in ipairs(armyData) do
		local soldierName = v.soldier
		local soldier
		soldier = self:createSolider(soldierName, j, isInit)
		soldier:setSoldierPos(cc.p(v.pos.x + 50, v.pos.y + 20))
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
return troopsMatrixWorldcup
