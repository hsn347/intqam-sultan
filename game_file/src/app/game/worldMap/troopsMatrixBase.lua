local troopsMatrixBase = class("troopsMatrixBase", function(troopInstance)
	local target = display.newNode()
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local EffectType = troopsMatrixUtil.EffectType
function troopsMatrixBase:ctor(troopInstance)
	self.rankSoldiersArray, _UPVALUE0_, self.soldiersArray, _UPVALUE0_, self.troopInstance = nil, nil, nil, nil, troopInstance
end
function troopsMatrixBase:isSwitchMatrix(matrixType)
	local selfMatrixType = self:getMatrixType()
	return selfMatrixType ~= matrixType
end
function troopsMatrixBase:isSwitchMatrixOnShow()
	return false
end
function troopsMatrixBase:getMatrixType()
	return MatrixType.MatrixType_Normal
end
function troopsMatrixBase:showMatrix(isInit, moveing)
end
function troopsMatrixBase:showSoldierToMove()
	for _, v in pairs(self.soldiersArray) do
		v:setVisible(true)
		v:moveing()
	end
end
function troopsMatrixBase:removeMatrix()
	self:removeSoldierArray()
	self:removeShowRankTimer()
end
function troopsMatrixBase:removeSoldierArray()
	for _, v in pairs(self.soldiersArray) do
		local soliderImg = v:getSoliderImg()
		v:pushSprite(soliderImg)
		v:removeFromParent()
	end
	self.soldiersArray, _ENV = pairs(self.soldiersArray)
end
function troopsMatrixBase:createSolider(soldierName, zOrder, isInit)
	local soldier = self.troopInstance:createSolider(soldierName, zOrder)
	self.soldiersArray[#self.soldiersArray + 1] = soldier
	if isInit then
		soldier:showAnimation(false)
	else
		soldier:showAnimation(true)
		self:setSoldierEffect(soldier)
	end
	return soldier
end
function troopsMatrixBase:setSoldierEffect(soldier)
end
function troopsMatrixBase:marchEffect(effectId, showNow)
	self.troopInstance:marchEffect_imp(effectId, showNow)
end
function troopsMatrixBase:removeShowRankTimer()
	if self.updateRankSodierTimer then
		SoraDManagerRemoveTimer(self, self.updateRankSodierTimer)
		self.updateRankSodierTimer = nil
	end
end
function troopsMatrixBase:addShowRankSoldier(rankSoldiers)
	self.rankSoldiersArray[#self.rankSoldiersArray + 1] = rankSoldiers
	if not self.updateRankSodierTimer then
		self.beginPoint = self.troopInstance:getBeginPoint()
		self.updateRankSodierTimer = SoradCreateTimer(self, handler(self, self.updateShowRankSoldier), true)
	end
end
function troopsMatrixBase:updateShowRankSoldier(dt)
	if self.rankSoldiersArray and #self.rankSoldiersArray <= 0 or not self.rankSoldiersArray then
		if tolua.isnull(self) then
			SoraDManagerRemoveTimerByTarget(self)
		else
			self:removeShowRankTimer()
		end
		return
	end
	local pointX, pointY = self.troopInstance:getPosition()
	local currentPoint = cc.p(pointX, pointY)
	local distance = cc.pGetDistance(self.beginPoint, currentPoint)
	for k, v in pairs(self.rankSoldiersArray) do
		local rankSoldiers = v
		if rankSoldiers and distance >= rankSoldiers.length then
			local soldiersArray = rankSoldiers.soldierArray
			for _, soldier in pairs(soldiersArray) do
				soldier:showAnimation(true)
				self:setSoldierEffect(soldier)
			end
			table.remove(self.rankSoldiersArray, k)
			break
		end
	end
end
function troopsMatrixBase:showTroopEffectType(effectType, isPreview)
	if effectType ~= EffectType.EffectType_None then
		for _, v in pairs(self.soldiersArray) do
			v:showTroopEffectTypeSoldier(effectType, isPreview)
		end
	end
end
function troopsMatrixBase:showTroopEffectTypeSoldier(effectType, soldier, isPreview)
	soldier:showTroopEffectTypeSoldier(effectType, isPreview)
end
function troopsMatrixBase:hideTroopEffectType(effectType)
	if effectType == EffectType.EffectType_None then
		return
	end
	for _, v in pairs(self.soldiersArray) do
		v:hideTroopEffectType(effectType)
	end
end
function troopsMatrixBase:createDivineBeast(isInit, order, pos)
	local armyData = self.troopInstance:getAmryData()
	local hasDivineBeast = _G.g_is_divinebeast_test_on
	local divineBeastId
	if armyData then
		for k, data in pairs(armyData) do
			if data.divineBeastInfo and data.divineBeastInfo[1] and data.divineBeastInfo[1].marchShow then
				hasDivineBeast = true
				divineBeastId = tonumber(data.divineBeastInfo[1].beastId)
				break
			end
		end
	end
	if _G.g_is_divinebeast_test_on then
		hasDivineBeast = true
		divineBeastId = 1901
	end
	if not hasDivineBeast or divineBeastId == nil then
		return
	end
	local divineBeastRead = include("divineBeastRead")
	local dbCfg = divineBeastRead.getDbCfg(divineBeastId)
	local selfMatrixType = self:getMatrixType()
	local soldier
	soldier = self:createSolider(dbCfg.modelType or worldMapDefine.soldierType_DivineBeast, order, isInit)
	pos = pos or cc.p(-40, 30)
	local marchCfg = divineBeastRead.getMarchCfg(selfMatrixType)
	dump(marchCfg, "marchCfg")
	if marchCfg then
		soldier:setSoldierPos(cc.p(pos.x + marchCfg.posX, pos.y + marchCfg.posY))
	else
		soldier:setSoldierPos(cc.p(pos.x, pos.y))
	end
	if _G.g_is_divinebeast_test_on then
		self._divineBeast = soldier
	end
	self.halfRoundNum = self.halfRoundNum + 1
	if isInit then
		_UPVALUE1_ = self.halfRoundNum + 1
		local (self.halfRoundNum + 1)[1], rankSoldierArray = soldier, self.halfRoundNum + 1
		local length = 350 - pos.x
		_ENV = cc.p(pos.x, pos.y)
		cc.p(pos.x, pos.y).length = length
		local cc.p(pos.x, pos.y).soldierArray, rankSoldiers = rankSoldierArray, cc.p(pos.x, pos.y)
		self:addShowRankSoldier(rankSoldiers)
	end
end
function troopsMatrixBase:beginWork()
end
return troopsMatrixBase
