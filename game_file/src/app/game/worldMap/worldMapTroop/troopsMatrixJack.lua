local troopsMatrixBase = include("troopsMatrixBase")
local troopsMatrixJack = class("troopsMatrixJack", function(troopInstance)
	local target = troopsMatrixBase.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
function troopsMatrixJack:ctor(troopInstance)
end
function troopsMatrixJack:getMatrixType()
	return MatrixType.MatrixType_Jack
end
function troopsMatrixJack:showMatrix(isInit, moveing)
	self:initSolider(isInit)
	if isInit or moveing then
		self:showSoldierToMove()
	end
end
function troopsMatrixJack:initSolider(isInit)
	local _ENV, soldierNumArray
	local soliderNum = 0
	local armyData = self.troopInstance:getAmryData()
	for _, data in pairs(armyData) do
		for _, v in pairs(data.armyList) do
			soliderNum = soliderNum + v.num
		end
	end
	if 1 <= soliderNum and soliderNum < 10000 then
		soldierNumArray[#soldierNumArray + 1] = 1
		soldierNumArray[#soldierNumArray + 1] = 2
	elseif 10000 <= soliderNum and soliderNum < 50000 then
		soldierNumArray[#soldierNumArray + 1] = 2
		soldierNumArray[#soldierNumArray + 1] = 2
	else
		soldierNumArray[#soldierNumArray + 1] = 2
		soldierNumArray[#soldierNumArray + 1] = 2
		soldierNumArray[#soldierNumArray + 1] = 2
	end
	local cellWidth = 70
	local width = #soldierNumArray * cellWidth
	local height = self.troopInstance:getTroopContentSize().height
	self.troopInstance:setMatrixSize(width, height)
	local tempWidth = 0
	local count = 0
	for i = 0, #soldierNumArray - 1 do
		local soldierNum = soldierNumArray[i + 1]
		local _ENV, rankSoldierArray = v.num, v.num
		local soldier
		tempWidth = tempWidth + cellWidth
		for j = 0, soldierNum - 1 do
			soldier = self:createSolider(worldMapDefine.soldierType_Jack, j, isInit)
			local offsetX = math.random(1, 3)
			local offsetY = math.random(1, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = j == 1 and 1 or -1
			soldier:setSoldierPos(cc.p(width - tempWidth + cellWidth / 2 + offsetX * needFlipX, height / (soldierNum * 2) + height / soldierNum * j + offsetY * needFlipY))
			if isInit then
				rankSoldierArray[#rankSoldierArray + 1] = soldier
			end
			count = count + 1
		end
		if isInit then
			_ENV = 0
			;(0).length = tempWidth - 50
			local (0).soldierArray, rankSoldiers = rankSoldierArray, 0
			self:addShowRankSoldier(rankSoldiers)
		end
	end
	self:createDivineBeast(isInit, count + 1)
end
function troopsMatrixJack:beginWork()
	local troopInstance = self.troopInstance
	troopInstance:createTroopMatrixType()
	troopInstance:beginWork()
end
return troopsMatrixJack
