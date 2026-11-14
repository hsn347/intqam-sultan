local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixCharge = class("troopsMatrixCharge", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 180
local MatrixHeight = 160
_UPVALUE3_ = nil
_UPVALUE3_, (nil)[1] = worldMapDefine.soldierType_NvLingZhu, worldMapDefine.soldierType_NvLingZhu
_UPVALUE3_, (nil)[2] = worldMapDefine.soldierType_NvLingZhu, worldMapDefine.soldierType_Madelin
local _UPVALUE3_, (nil)[3], soldierNames = worldMapDefine.soldierType_NvLingZhu, worldMapDefine.soldierType_Madelin, nil
worldMapDefine.soldierType_NvLingZhu[1] = 1
worldMapDefine.soldierType_NvLingZhu[2] = 5
local worldMapDefine.soldierType_NvLingZhu[3], soldierNums = 5, worldMapDefine.soldierType_NvLingZhu
function troopsMatrixCharge:ctor(troopInstance)
	self.troopInstance = self.troopInstance
end
function troopsMatrixCharge:getMatrixType()
	return MatrixType.MatrixType_Charge
end
function troopsMatrixCharge:initSolider(isInit)
	local size = cc.size(MatrixWidth, MatrixHeight)
	self.troopInstance:setMatrixSize(MatrixWidth, MatrixHeight)
	self.halfRoundNum = 11
	local tempWidth = 0
	for i = 0, #soldierNames - 1 do
		local soldierName = soldierNames[i + 1]
		local cellWidth = troopsMatrixUtil.getSoldierWidth(soldierName)
		tempWidth = tempWidth + cellWidth
		local soldier
		local _ENV, rankSoldierArray
		local soldierNum = soldierNums[i + 1]
		for j = 0, soldierNum - 1 do
			soldier = self:createSolider(soldierName, j, isInit)
			soldier:setSoldierPos(cc.p(size.width - tempWidth + cellWidth / 2 + 50, size.height / (soldierNum * 2) + size.height / soldierNum * j))
			if isInit then
				rankSoldierArray[#rankSoldierArray + 1] = soldier
			end
		end
		if isInit then
			_ENV = 0
			;(0).length = tempWidth - 50
			local (0).soldierArray, rankSoldiers = rankSoldierArray, 0
			self:addShowRankSoldier(rankSoldiers)
		end
	end
	self:createDivineBeast(isInit, #soldierNames)
end
return troopsMatrixCharge
