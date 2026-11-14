local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixIcedragon = class("troopsMatrixIcedragon", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 350
local MatrixHeight = 140
function troopsMatrixIcedragon:ctor(troopInstance)
	self.troopInstance = self.troopInstance
end
_ENV, _UPVALUE8_, troopsMatrixIcedragon.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_Icedragon
end, function(self)
	return MatrixType.MatrixType_Icedragon
end
;(nil).soldier = worldMapDefine.soldierType_IceDragon
_ENV, (nil).pos = cc.p(363.15, 129.12), cc.p(363.15, 129.12)
cc.p(363.15, 129.12).soldier = worldMapDefine.soldierType_IceCavalry
_ENV, cc.p(363.15, 129.12).pos = cc.p(257.48, 125.97), cc.p(257.48, 125.97)
cc.p(257.48, 125.97).soldier = worldMapDefine.soldierType_IceCavalry
_ENV, cc.p(257.48, 125.97).pos = cc.p(224.11, 77.38), cc.p(224.11, 77.38)
cc.p(224.11, 77.38).soldier = worldMapDefine.soldierType_IceCavalry
_ENV, cc.p(224.11, 77.38).pos = cc.p(162.86, 116.89), cc.p(162.86, 116.89)
cc.p(162.86, 116.89).soldier = worldMapDefine.soldierType_IceCavalry
_ENV, cc.p(162.86, 116.89).pos = cc.p(75.35, 106.46), cc.p(75.35, 106.46)
cc.p(75.35, 106.46).soldier = worldMapDefine.soldierType_IceCavalry
_ENV, cc.p(75.35, 106.46).pos = cc.p(143.63, 44.24), cc.p(143.63, 44.24)
cc.p(143.63, 44.24).soldier = worldMapDefine.soldierType_IceCavalry
_ENV, cc.p(143.63, 44.24).pos = cc.p(311.4, 59.19), cc.p(311.4, 59.19)
cc.p(311.4, 59.19).soldier = worldMapDefine.soldierType_IceCavalry
cc.p(311.4, 59.19).pos = cc.p(41.9, 62.03)
;(function(self)
	return MatrixType.MatrixType_Icedragon
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_Icedragon
end)[2] = cc.p(363.15, 129.12)
;(function(self)
	return MatrixType.MatrixType_Icedragon
end)[3] = cc.p(257.48, 125.97)
;(function(self)
	return MatrixType.MatrixType_Icedragon
end)[4] = cc.p(224.11, 77.38)
;(function(self)
	return MatrixType.MatrixType_Icedragon
end)[5] = cc.p(162.86, 116.89)
;(function(self)
	return MatrixType.MatrixType_Icedragon
end)[6] = cc.p(75.35, 106.46)
;(function(self)
	return MatrixType.MatrixType_Icedragon
end)[7] = cc.p(143.63, 44.24)
local (function(self)
	return MatrixType.MatrixType_Icedragon
end)[8], armyConfig = cc.p(311.4, 59.19), function(self)
	return MatrixType.MatrixType_Icedragon
end
function troopsMatrixIcedragon:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	local soliderModelNum_gongbing = 0
	for _, v in ipairs(armyData) do
		if v.soldier == worldMapDefine.soldierType_IceDragon then
			soliderModelNum_gongbing = soliderModelNum_gongbing + 1
		else
			soliderModelNum_bubing = soliderModelNum_bubing + 1
		end
	end
	self.halfRoundNum = soliderModelNum_bubing
	self.gongjianNum = soliderModelNum_gongbing
	return armyData
end
function troopsMatrixIcedragon:initSolider(isInit)
	local armyData = self:createMatrixData()
	self.troopInstance:setMatrixSize(MatrixWidth, MatrixHeight)
	for j, v in ipairs(armyData) do
		local soldierName = v.soldier
		local soldier
		soldier = self:createSolider(soldierName, j, isInit)
		soldier:setSoldierPos(cc.p(v.pos.x, v.pos.y - 20))
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
return troopsMatrixIcedragon
