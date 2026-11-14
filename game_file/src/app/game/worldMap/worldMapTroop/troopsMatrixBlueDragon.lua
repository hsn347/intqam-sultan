local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixBlueDragon = class("troopsMatrixBlueDragon", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 350
local MatrixHeight = 140
function troopsMatrixBlueDragon:ctor(troopInstance)
	self.troopInstance = self.troopInstance
end
_ENV, _UPVALUE6_, troopsMatrixBlueDragon.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_BlueDragon
end, function(self)
	return MatrixType.MatrixType_BlueDragon
end
;(nil).soldier = worldMapDefine.soldierType_lanlong
_ENV, (nil).pos = cc.p(351.99, 80.18), cc.p(351.99, 80.18)
cc.p(351.99, 80.18).soldier = worldMapDefine.soldierType_lansexml
_ENV, cc.p(351.99, 80.18).pos = cc.p(239.57, 108.26), cc.p(239.57, 108.26)
cc.p(239.57, 108.26).soldier = worldMapDefine.soldierType_lansexml
_ENV, cc.p(239.57, 108.26).pos = cc.p(199.74, 63.38), cc.p(199.74, 63.38)
cc.p(199.74, 63.38).soldier = worldMapDefine.soldierType_lansexml
_ENV, cc.p(199.74, 63.38).pos = cc.p(124.68, 115.74), cc.p(124.68, 115.74)
cc.p(124.68, 115.74).soldier = worldMapDefine.soldierType_lansexml
_ENV, cc.p(124.68, 115.74).pos = cc.p(80.81, 48.67), cc.p(80.81, 48.67)
cc.p(80.81, 48.67).soldier = worldMapDefine.soldierType_lansexml
cc.p(80.81, 48.67).pos = cc.p(18.87, 96.49)
;(function(self)
	return MatrixType.MatrixType_BlueDragon
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_BlueDragon
end)[2] = cc.p(351.99, 80.18)
;(function(self)
	return MatrixType.MatrixType_BlueDragon
end)[3] = cc.p(239.57, 108.26)
;(function(self)
	return MatrixType.MatrixType_BlueDragon
end)[4] = cc.p(199.74, 63.38)
;(function(self)
	return MatrixType.MatrixType_BlueDragon
end)[5] = cc.p(124.68, 115.74)
local (function(self)
	return MatrixType.MatrixType_BlueDragon
end)[6], armyConfig = cc.p(80.81, 48.67), function(self)
	return MatrixType.MatrixType_BlueDragon
end
function troopsMatrixBlueDragon:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	local soliderModelNum_gongbing = 0
	for _, v in ipairs(armyData) do
		if v.soldier == worldMapDefine.soldierType_lanlong then
			soliderModelNum_gongbing = soliderModelNum_gongbing + 1
		else
			soliderModelNum_bubing = soliderModelNum_bubing + 1
		end
	end
	self.halfRoundNum = soliderModelNum_bubing
	self.gongjianNum = soliderModelNum_gongbing
	return armyData
end
function troopsMatrixBlueDragon:initSolider(isInit)
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
return troopsMatrixBlueDragon
