local troopsHelper = include("troopsHelper")
local troopsMatrixBase = include("troopsMatrixBase")
local troopsMatrixNormal = class("troopsMatrixNormal", function(troopInstance)
	local target = troopsMatrixBase.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
function troopsMatrixNormal:ctor(troopInstance)
	self.hasHero = false
	self.halfRoundDotPoint = nil
	self.halfRoundAreaPointArray, _UPVALUE0_, self.halfRoundNum = nil, nil, 0
	self.gongjianPointArray, _UPVALUE0_, self.gongjianNum = nil, nil, 0
	self.zhanchePointArray, _UPVALUE0_, self.zhancheNum = nil, nil, 0
end
function troopsMatrixNormal:showMatrix(isInit, moveing)
	self:initSolider(isInit)
	if isInit or moveing then
		self:showSoldierToMove()
	end
end
function troopsMatrixNormal:setMatrixSize(soldierNumArray)
	local width = 0
	local height = self.troopInstance:getTroopContentSize().height
	for i = 1, #soldierNumArray do
		local soldierName = soldierNumArray[i]
		local cellWidth = troopsMatrixUtil.getSoldierWidth(soldierName)
		width = width + cellWidth
	end
	width = width + 20
	self.troopInstance:setMatrixSize(width, height)
end
function troopsMatrixNormal:createMatrixData(armyData)
	dump(armyData, "troopsMatrixNormal:createMatrixData")
	_ENV = dump
	dump[worldMapDefine.soldierType_BuBing] = 0
	dump[worldMapDefine.soldierType_QiBing] = 0
	dump[worldMapDefine.soldierType_GongjianBing] = 0
	dump[worldMapDefine.soldierType_ZhanChe] = 0
	dump[worldMapDefine.soldierType_XiangBing] = 0
	dump[worldMapDefine.soldierType_JingYing] = 0
	dump[worldMapDefine.soldierType_StarBuBing] = 0
	dump[worldMapDefine.soldierType_StarQiBing] = 0
	dump[worldMapDefine.soldierType_StarNuBing] = 0
	dump[worldMapDefine.soldierType_StarCheBing] = 0
	dump[worldMapDefine.soldierType_DivineBeast] = 0
	local dump[worldMapDefine.soldierType_DivineBeast_1901], soldierNumArray = 0, dump
	for _, data in pairs(armyData) do
		for _, v in pairs(data.armyList) do
			local soldierModel = worldMapDefine.getSoliderModelType(v.id)
			soldierNumArray[soldierModel] = soldierNumArray[soldierModel] + v.num
		end
		if data.divineBeastInfo then
			for _, v in pairs(data.divineBeastInfo) do
				if v.marchShow then
					if v.beastId == 1901 then
						soldierNumArray[worldMapDefine.soldierType_DivineBeast_1901] = soldierNumArray[worldMapDefine.soldierType_DivineBeast_1901] + 1
					else
						soldierNumArray[worldMapDefine.soldierType_DivineBeast] = soldierNumArray[worldMapDefine.soldierType_DivineBeast] + 1
					end
				end
			end
		end
	end
	local _ENV, modelTypeArray = (for generator), pairs(armyData)
	local _ENV, modelNumArray = pairs(armyData)
	local soliderModelNum_bubing = 0
	local soliderModelNum_qibing = 0
	local soliderModelNum_gongbing = 0
	local soliderModelNum_chebing = 0
	local soliderModelNum_xiangbing = 0
	local soliderModelNum_jingying = 0
	if self:getMatrixType() ~= troopsMatrixUtil.MatrixType.MatrixType_Charge and self.hasHero then
		modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_Hero
		modelNumArray[#modelNumArray + 1] = 1
		soliderModelNum_bubing = soliderModelNum_bubing + 1
	end
	if self.isLegendLord or self.isLegendLordForSep then
		modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_LegendLord
		modelNumArray[#modelNumArray + 1] = 4
	end
	if 0 < soldierNumArray[worldMapDefine.soldierType_XiangBing] then
		local num = soldierNumArray[worldMapDefine.soldierType_XiangBing]
		if 1 <= num and num < 10000 then
			modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_XiangBing
			modelNumArray[#modelNumArray + 1] = 1
			soliderModelNum_xiangbing = soliderModelNum_xiangbing + 1
		else
			modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_XiangBing
			modelNumArray[#modelNumArray + 1] = 2
			soliderModelNum_xiangbing = soliderModelNum_xiangbing + 2
		end
	end
	if 0 < soldierNumArray[worldMapDefine.soldierType_BuBing] + soldierNumArray[worldMapDefine.soldierType_StarBuBing] then
		local num = soldierNumArray[worldMapDefine.soldierType_BuBing] + soldierNumArray[worldMapDefine.soldierType_StarBuBing]
		if 1 <= num and num < 10000 then
			if 0 < soldierNumArray[worldMapDefine.soldierType_StarBuBing] then
				modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_StarBuBing
			else
				modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_BuBing
			end
			modelNumArray[#modelNumArray + 1] = 4
			soliderModelNum_bubing = soliderModelNum_bubing + 4
		elseif 10000 <= num and num < 50000 then
			for _ = 1, 2 do
				if 0 < soldierNumArray[worldMapDefine.soldierType_StarBuBing] then
					modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_StarBuBing
				else
					modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_BuBing
				end
				modelNumArray[#modelNumArray + 1] = 5
				soliderModelNum_bubing = soliderModelNum_bubing + 5
			end
		else
			for _ = 1, 3 do
				if 0 < soldierNumArray[worldMapDefine.soldierType_StarBuBing] then
					modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_StarBuBing
				else
					modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_BuBing
				end
				modelNumArray[#modelNumArray + 1] = 6
				soliderModelNum_bubing = soliderModelNum_bubing + 6
			end
		end
	end
	if 0 < soldierNumArray[worldMapDefine.soldierType_QiBing] + soldierNumArray[worldMapDefine.soldierType_StarQiBing] then
		local num = soldierNumArray[worldMapDefine.soldierType_QiBing] + soldierNumArray[worldMapDefine.soldierType_StarQiBing]
		if 1 <= num and num < 10000 then
			if 0 < soldierNumArray[worldMapDefine.soldierType_StarQiBing] then
				modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_StarQiBing
			else
				modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_QiBing
			end
			modelNumArray[#modelNumArray + 1] = 3
			soliderModelNum_qibing = soliderModelNum_qibing + 3
		elseif 10000 <= num and num < 50000 then
			for _ = 1, 2 do
				if 0 < soldierNumArray[worldMapDefine.soldierType_StarQiBing] then
					modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_StarQiBing
				else
					modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_QiBing
				end
				modelNumArray[#modelNumArray + 1] = 3
				soliderModelNum_qibing = soliderModelNum_qibing + 3
			end
		else
			for _ = 1, 2 do
				if 0 < soldierNumArray[worldMapDefine.soldierType_StarQiBing] then
					modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_StarQiBing
				else
					modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_QiBing
				end
				modelNumArray[#modelNumArray + 1] = 5
				soliderModelNum_qibing = soliderModelNum_qibing + 5
			end
		end
	end
	if 0 < soldierNumArray[worldMapDefine.soldierType_GongjianBing] + soldierNumArray[worldMapDefine.soldierType_StarNuBing] then
		local num = soldierNumArray[worldMapDefine.soldierType_GongjianBing] + soldierNumArray[worldMapDefine.soldierType_StarNuBing]
		if 1 <= num and num < 10000 then
			if 0 < soldierNumArray[worldMapDefine.soldierType_StarNuBing] then
				modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_StarNuBing
			else
				modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_GongjianBing
			end
			modelNumArray[#modelNumArray + 1] = 4
			soliderModelNum_gongbing = soliderModelNum_gongbing + 4
		elseif 10000 <= num and num < 50000 then
			for _ = 1, 2 do
				if 0 < soldierNumArray[worldMapDefine.soldierType_StarNuBing] then
					modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_StarNuBing
				else
					modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_GongjianBing
				end
				modelNumArray[#modelNumArray + 1] = 5
				soliderModelNum_gongbing = soliderModelNum_gongbing + 5
			end
		else
			for _ = 1, 3 do
				if 0 < soldierNumArray[worldMapDefine.soldierType_StarNuBing] then
					modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_StarNuBing
				else
					modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_GongjianBing
				end
				modelNumArray[#modelNumArray + 1] = 6
				soliderModelNum_gongbing = soliderModelNum_gongbing + 6
			end
		end
	end
	if 0 < soldierNumArray[worldMapDefine.soldierType_ZhanChe] + soldierNumArray[worldMapDefine.soldierType_StarCheBing] then
		local num = soldierNumArray[worldMapDefine.soldierType_ZhanChe] + soldierNumArray[worldMapDefine.soldierType_StarCheBing]
		if 1 <= num and num < 10000 then
			if 0 < soldierNumArray[worldMapDefine.soldierType_StarCheBing] then
				modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_StarCheBing
			else
				modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_ZhanChe
			end
			modelNumArray[#modelNumArray + 1] = 1
			soliderModelNum_chebing = soliderModelNum_chebing + 1
		elseif 10000 <= num and num < 50000 then
			for _ = 1, 2 do
				if 0 < soldierNumArray[worldMapDefine.soldierType_StarCheBing] then
					modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_StarCheBing
				else
					modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_ZhanChe
				end
				modelNumArray[#modelNumArray + 1] = 2
				soliderModelNum_chebing = soliderModelNum_chebing + 2
			end
		else
			for _ = 1, 3 do
				if 0 < soldierNumArray[worldMapDefine.soldierType_StarCheBing] then
					modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_StarCheBing
				else
					modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_ZhanChe
				end
				modelNumArray[#modelNumArray + 1] = 3
				soliderModelNum_chebing = soliderModelNum_chebing + 3
			end
		end
	end
	if 0 < soldierNumArray[worldMapDefine.soldierType_JingYing] then
		modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_JingYing
		modelNumArray[#modelNumArray + 1] = 1
		soliderModelNum_jingying = soliderModelNum_jingying + 1
	end
	if 0 < soldierNumArray[worldMapDefine.soldierType_DivineBeast] then
		modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_DivineBeast
		modelNumArray[#modelNumArray + 1] = 1
		soliderModelNum_bubing = soliderModelNum_bubing + 1
	end
	if 0 < soldierNumArray[worldMapDefine.soldierType_DivineBeast_1901] then
		modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_DivineBeast_1901
		modelNumArray[#modelNumArray + 1] = 1
		soliderModelNum_bubing = soliderModelNum_bubing + 1
	end
	if self.troopInstance:isHasHeroBack() then
		modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_HeroBack
		modelNumArray[#modelNumArray + 1] = 1
		soliderModelNum_bubing = soliderModelNum_bubing + 1
	end
	if self.troopInstance:isFailBack() then
		modelNumArray, _ENV, modelTypeArray, _ENV = self.troopInstance:isFailBack(), self.troopInstance:isFailBack(), self.troopInstance:isFailBack(), self.troopInstance:isFailBack()
		modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_zbsb
		modelNumArray[#modelNumArray + 1] = 1
		soliderModelNum_bubing = soliderModelNum_bubing + 1
		for _ = 1, 3 do
			modelTypeArray[#modelTypeArray + 1] = worldMapDefine.soldierType_zbxb
			modelNumArray[#modelNumArray + 1] = 1
			soliderModelNum_bubing = soliderModelNum_bubing + 1
		end
	end
	self.halfRoundNum = soliderModelNum_bubing + soliderModelNum_qibing + soliderModelNum_xiangbing
	self.gongjianNum = soliderModelNum_gongbing + soliderModelNum_jingying
	self.zhancheNum = soliderModelNum_chebing
	return modelTypeArray, modelNumArray
end
function troopsMatrixNormal:initPoint()
	local size = self.troopInstance:getTroopContentSize()
	local width = size.width
	local height = size.height
	local halfHeight = height * 0.5
	self.halfRoundDotPoint = cc.p(width, halfHeight)
	self.radius = self.troopInstance:getRadius()
	self:initHalfRoundAreaPoint(self.halfRoundNum, width, halfHeight)
	self:initGongjianPoint(self.gongjianNum, width, height)
	self:initZhanchePoint(self.zhancheNum, width, height)
end
function troopsMatrixNormal:initHalfRoundAreaPoint(soldierNum, dotPointX, dotPointY)
	local num
	if soldierNum <= 8 then
		num = 8
	else
		num = soldierNum
	end
	local indexCount = math.floor(num / 2) + 1
	local cellAngle = 180 / num
	for i = 0, indexCount - 1 do
		local angle = math.angle2radian(180 - cellAngle * 0.5 - cellAngle * i)
		local pointX = dotPointX + self.radius * math.cos(angle)
		local pointY1 = dotPointY + self.radius * math.sin(angle)
		local pointY2 = dotPointY - self.radius * math.sin(angle)
		self.halfRoundAreaPointArray[#self.halfRoundAreaPointArray + 1] = cc.p(pointX, pointY1)
		self.halfRoundAreaPointArray[#self.halfRoundAreaPointArray + 1] = cc.p(pointX, pointY2)
	end
end
function troopsMatrixNormal:initGongjianPoint(soldierNum, width, height)
	local soldierNum1 = math.floor(soldierNum / 2)
	for i = 0, soldierNum1 - 1 do
		local pointX = width - self.radius - 30
		local pointY = height / (soldierNum1 * 2) + height / soldierNum1 * i
		self.gongjianPointArray[#self.gongjianPointArray + 1] = cc.p(pointX, pointY)
	end
	local soldierNum2 = soldierNum - soldierNum1
	for i = 0, soldierNum2 - 1 do
		local pointX = width - self.radius - 60
		local pointY = height / (soldierNum2 * 2) + height / soldierNum2 * i
		self.gongjianPointArray[#self.gongjianPointArray + 1] = cc.p(pointX, pointY)
	end
end
function troopsMatrixNormal:initZhanchePoint(soldierNum, width, height)
	for i = 0, soldierNum - 1 do
		local pointX = width - self.radius - 100
		local pointY = height / (soldierNum * 2) + height / soldierNum * i
		self.zhanchePointArray[#self.zhanchePointArray + 1] = cc.p(pointX, pointY)
	end
end
function troopsMatrixNormal:initSolider(isInit)
	local _ENV, soldierNumArray
	local _ENV, soldierTypeArray
	local armyData = self.troopInstance:getAmryData()
	if armyData then
		local hasHero = false
		for _, data in pairs(armyData) do
			if data.heroInfo and #data.heroInfo > 0 then
				hasHero = true
				break
			end
		end
		self.hasHero = hasHero
		soldierTypeArray, soldierNumArray = self:createMatrixData(armyData)
		self:setMatrixSize(soldierTypeArray)
	end
	local size = self.troopInstance:getTroopContentSize()
	local tempWidth = 0
	for i = 0, #soldierNumArray - 1 do
		local soldierName = soldierTypeArray[i + 1]
		local soldierNum = soldierNumArray[i + 1]
		local cellWidth = troopsMatrixUtil.getSoldierWidth(soldierName)
		tempWidth = tempWidth + cellWidth
		local soldier
		local _ENV, rankSoldierArray
		for j = 0, soldierNum - 1 do
			soldier = self:createSolider(soldierName, j, isInit)
			soldier:setSoldierPos(cc.p(size.width - tempWidth + cellWidth / 2, size.height / (soldierNum * 2) + size.height / soldierNum * j))
			if isInit then
				rankSoldierArray[#rankSoldierArray + 1] = soldier
			end
		end
		if self.troopInstance:isFailBack() and 0 < i then
			_UPVALUE3_ = self.troopInstance:isFailBack()
			self.troopInstance:isFailBack()[1] = 0
			self.troopInstance:isFailBack()[2] = 60
			local self.troopInstance:isFailBack()[3], dirOffset = 20, self.troopInstance:isFailBack()
			soldier:setSoldierPos(cc.p(size.width - tempWidth + cellWidth / 2, cellWidth - dirOffset[i]))
		end
		if isInit then
			_ENV = self.troopInstance:isFailBack()
			self.troopInstance:isFailBack().length = tempWidth - 50
			local self.troopInstance:isFailBack().soldierArray, rankSoldiers = rankSoldierArray, self.troopInstance:isFailBack()
			self:addShowRankSoldier(rankSoldiers)
		end
	end
end
function troopsMatrixNormal:setSoldierEffect(soldier)
	local effectType = self.troopInstance:getEffectType()
	self:showTroopEffectTypeSoldier(effectType, soldier)
end
function troopsMatrixNormal:beginWork()
	self:initPoint()
	self.troopInstance:beginWorkPre()
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	for _, v in pairs(self.soldiersArray) do
		local soliderType = v:getSoliderType()
		local solierPointsArray
		local soldierPType = troopsHelper.getSoldierPointsType(soliderType)
		if soliderType == worldMapDefine.soldierType_DivineBeast then
			soldierPType = worldMapDefine.pointsType_CHARIOT
		end
		if soliderType == worldMapDefine.soldierType_DivineBeast_1901 then
			soldierPType = worldMapDefine.pointsType_CHARIOT
		end
		if soldierPType == worldMapDefine.pointsType_CHARIOT then
			solierPointsArray = self.halfRoundAreaPointArray
		elseif soldierPType == worldMapDefine.pointsType_RANGE then
			solierPointsArray = self.gongjianPointArray
		elseif soldierPType == worldMapDefine.pointsType_BARRACKS then
			solierPointsArray = self.zhanchePointArray
		elseif soldierPType == worldMapDefine.pointsType_HIDE then
			v.soliderImg:stopAllActions()
			v:stopAllActions()
			v:setVisible(false)
			v.soliderImg:setVisible(false)
		end
		if solierPointsArray and 0 < #solierPointsArray then
			local count = #solierPointsArray
			local index = math.random(count)
			local goPoint = solierPointsArray[index]
			v:setVisible(true)
			v:goFighting(goPoint, self.halfRoundDotPoint)
			table.remove(solierPointsArray, index)
		end
	end
end
return troopsMatrixNormal
