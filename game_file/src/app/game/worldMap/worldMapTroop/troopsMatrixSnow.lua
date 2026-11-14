local troopsMatrixBase = include("troopsMatrixBase")
local troopsMatrixSnow = class("troopsMatrixSnow", function(troopInstance)
	local target = troopsMatrixBase.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
function troopsMatrixSnow:ctor(troopInstance)
end
function troopsMatrixSnow:getMatrixType()
	return MatrixType.MatrixType_Snow
end
function troopsMatrixSnow:showMatrix(isInit, moveing)
	self:initSolider(isInit)
	if isInit or moveing then
		self:showSoldierToMove()
	end
end
function troopsMatrixSnow:initSolider(isInit)
	local size = self.troopInstance:getTroopContentSize()
	local troopSolider = include("troopSolider")
	local soldier = self:createSolider(worldMapDefine.soldierType_Snow, 99, isInit)
	local cellWidth = troopsMatrixUtil.getSoldierWidth(worldMapDefine.soldierType_Snow)
	soldier:setSoldierPos(cc.p(size.width, size.height / 2))
	local isFlipX = self.troopInstance.isFlipX
	local moveAngle = self.troopInstance.moveAngle
	local imgNameAngle = self.troopInstance.imgNameAngle
	local soliderImg = soldier:getSoliderImg()
	soliderImg:setFlippedX(isFlipX)
	soliderImg:setRotation(-moveAngle)
	print("imgNameAngle,moveAngle======", imgNameAngle, moveAngle)
	if imgNameAngle == "ws" and isFlipX and -moveAngle == -45 then
		soliderImg:setRotation(-moveAngle + 15)
		soldier:setSoldierPos(cc.p(size.width, size.height / 2))
	elseif imgNameAngle == "ws" and not isFlipX and -moveAngle == -135 then
		soliderImg:setRotation(-moveAngle - 20)
	elseif imgNameAngle == "w" and moveAngle == 0 then
		soldier:setSoldierPos(cc.p(size.width, size.height / 2))
	elseif imgNameAngle == "w" and moveAngle == 180 and not isFlipX then
		soldier:setSoldierPos(cc.p(size.width, size.height / 2))
	elseif imgNameAngle == "wn" and -moveAngle == 45 then
		soliderImg:setRotation(-moveAngle - 15)
		soldier:setSoldierPos(cc.p(size.width - 65, size.height / 2))
	elseif imgNameAngle == "wn" and -moveAngle == 135 then
		soliderImg:setRotation(-moveAngle + 15)
	elseif imgNameAngle == "s" and moveAngle == 90 and not isFlipX then
		soldier:setSoldierPos(cc.p(size.width, size.height / 2 + 65))
	elseif imgNameAngle == "s" and moveAngle == 90 and isFlipX then
		soldier:setSoldierPos(cc.p(size.width, size.height / 2))
	end
	if isInit then
		_ENV = soldier.setSoldierPos
		troopsMatrixUtil, soldier.setSoldierPos.length = size.width - 50, size.width - 50
		soldier.setSoldierPos.soldierArray, (size.width - 50)[1] = size.width - 50, soldier
		local rankSoldiers = soldier.setSoldierPos
		self:addShowRankSoldier(rankSoldiers)
	end
	self:createDivineBeast(isInit, 2)
end
function troopsMatrixSnow:beginWork()
	local troopInstance = self.troopInstance
	troopInstance:createTroopMatrixType()
	troopInstance:beginWork()
end
return troopsMatrixSnow
