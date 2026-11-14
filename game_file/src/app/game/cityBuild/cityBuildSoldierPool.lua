local worldMapFunction = include("worldMapFunction")
local worldMapDefine = include("worldMapDefine")
cityBuildSoldierPool, _ENV = "worldMapDefine", "worldMapDefine"
_ENV = nil
;(nil)[tostring(worldMapDefine.soldierType_BuBing)], _ENV = worldMapDefine.soldierType_BuBing, worldMapDefine.soldierType_BuBing
;(nil)[tostring(worldMapDefine.soldierType_QiBing)], _ENV = worldMapDefine.soldierType_QiBing, worldMapDefine.soldierType_QiBing
;(nil)[tostring(worldMapDefine.soldierType_GongjianBing)], _ENV = worldMapDefine.soldierType_GongjianBing, worldMapDefine.soldierType_GongjianBing
;(nil)[tostring(worldMapDefine.soldierType_ZhanChe)], _ENV = worldMapDefine.soldierType_ZhanChe, worldMapDefine.soldierType_ZhanChe
cityBuildSoldierPool.tblSoldierTypePool, (nil)[tostring(worldMapDefine.soldierType_JingYing)], _ENV = nil, worldMapDefine.soldierType_JingYing, worldMapDefine.soldierType_JingYing
cityBuildSoldierPool.tblSoldierPool, _ENV = nil, nil
cityBuildSoldierPool.tblSoldierPoolElite, _ENV = nil, nil
function cityBuildSoldierPool:init()
end
function cityBuildSoldierPool:cleanSoldierPool(soldierPool)
	local count = 0
	for i, v in ipairs(soldierPool) do
		if v then
			v:release()
			count = count + 1
		end
	end
	return count
end
function cityBuildSoldierPool:removeAll()
	local count = 0
	count = count + self:cleanSoldierPool(self.tblSoldierTypePool[tostring(worldMapDefine.soldierType_BuBing)])
	count = count + self:cleanSoldierPool(self.tblSoldierTypePool[tostring(worldMapDefine.soldierType_QiBing)])
	count = count + self:cleanSoldierPool(self.tblSoldierTypePool[tostring(worldMapDefine.soldierType_GongjianBing)])
	count = count + self:cleanSoldierPool(self.tblSoldierTypePool[tostring(worldMapDefine.soldierType_ZhanChe)])
	count = count + self:cleanSoldierPool(self.tblSoldierTypePool[tostring(worldMapDefine.soldierType_JingYing)])
	count = count + self:cleanSoldierPool(self.tblSoldierPool)
	count = count + self:cleanSoldierPool(self.tblSoldierPoolElite)
	self.tblSoldierTypePool[tostring(worldMapDefine.soldierType_BuBing)], _ENV = worldMapDefine.soldierType_BuBing, worldMapDefine.soldierType_BuBing
	self.tblSoldierTypePool[tostring(worldMapDefine.soldierType_QiBing)], _ENV = worldMapDefine.soldierType_QiBing, worldMapDefine.soldierType_QiBing
	self.tblSoldierTypePool[tostring(worldMapDefine.soldierType_GongjianBing)], _ENV = worldMapDefine.soldierType_GongjianBing, worldMapDefine.soldierType_GongjianBing
	self.tblSoldierTypePool[tostring(worldMapDefine.soldierType_ZhanChe)], _ENV = worldMapDefine.soldierType_ZhanChe, worldMapDefine.soldierType_ZhanChe
	self.tblSoldierPoolElite, _ENV, self.tblSoldierPool, _ENV, self.tblSoldierTypePool[tostring(worldMapDefine.soldierType_JingYing)], _ENV = self.tblSoldierTypePool, self.tblSoldierTypePool, self.tblSoldierTypePool, self.tblSoldierTypePool, worldMapDefine.soldierType_JingYing, worldMapDefine.soldierType_JingYing
	self:dump()
end
function cityBuildSoldierPool:getSoldierSprite(soldierType, direction, index)
	local ret
	local isNeedRelease = false
	local index = index or "01"
	if soldierType ~= worldMapDefine.soldierType_JingYing and direction == "wn" or soldierType == worldMapDefine.soldierType_JingYing and direction == "n" then
		local soldierPool = self.tblSoldierTypePool[tostring(soldierType)]
		if 0 < #soldierPool then
			ret = soldierPool[#soldierPool]
			table.remove(soldierPool, #soldierPool)
			isNeedRelease = true
			return ret, isNeedRelease
		end
	end
	if soldierType ~= worldMapDefine.soldierType_JingYing and 0 < #self.tblSoldierPool then
		ret = self.tblSoldierPool[#self.tblSoldierPool]
		table.remove(self.tblSoldierPool, #self.tblSoldierPool)
		local spriteFrameName = worldMapDefine.getSoliderImageNameByType(soldierType) .. "_gj_" .. direction .. "_" .. index .. ".png"
		ret:setSpriteFrame(spriteFrameName)
		return ret, isNeedRelease
	elseif soldierType == worldMapDefine.soldierType_JingYing and 0 < #self.tblSoldierPoolElite then
		ret = self.tblSoldierPoolElite[#self.tblSoldierPoolElite]
		table.remove(self.tblSoldierPoolElite, #self.tblSoldierPoolElite)
		local spriteFrameName = worldMapDefine.getSoliderImageNameByType(soldierType) .. "_gj_" .. direction .. "_" .. index .. ".png"
		ret:setSpriteFrame(spriteFrameName)
		return ret, isNeedRelease
	end
	local soldierName = "#" .. worldMapDefine.getSoliderImageNameByType(soldierType) .. "_gj_" .. direction .. "_" .. index .. ".png"
	local soldier = display.newSpriteNoChild(soldierName)
	isNeedRelease = false
	return soldier, isNeedRelease
end
function cityBuildSoldierPool:addToSoldierPool(soldierType, direction, node)
	if soldierType ~= worldMapDefine.soldierType_JingYing and direction == "wn" or soldierType == worldMapDefine.soldierType_JingYing and direction == "n" then
		local soldierPool = self.tblSoldierTypePool[tostring(soldierType)]
		if soldierPool then
			table.insert(soldierPool, #soldierPool + 1, node)
			node:retain()
			return
		end
	end
	if soldierType == worldMapDefine.soldierType_JingYing then
		table.insert(self.tblSoldierPoolElite, #self.tblSoldierPoolElite + 1, node)
		node:retain()
	else
		table.insert(self.tblSoldierPool, #self.tblSoldierPool + 1, node)
		node:retain()
	end
end
function cityBuildSoldierPool:dump()
	do return end
	print("===================================================:")
	print("当前回收池情况:")
	print("士兵类型: worldMapDefine.soldierType_BuBing, 个数:" .. #self.tblSoldierTypePool[tostring(worldMapDefine.soldierType_BuBing)])
	print("士兵类型: worldMapDefine.soldierType_QiBing , 个数:" .. #self.tblSoldierTypePool[tostring(worldMapDefine.soldierType_QiBing)])
	print("士兵类型: worldMapDefine.soldierType_GongjianBing , 个数:" .. #self.tblSoldierTypePool[tostring(worldMapDefine.soldierType_GongjianBing)])
	print("士兵类型: worldMapDefine.soldierType_ZhanChe , 个数:" .. #self.tblSoldierTypePool[tostring(worldMapDefine.soldierType_ZhanChe)])
	print("士兵类型: worldMapDefine.soldierType_JingYing , 个数:" .. #self.tblSoldierTypePool[tostring(worldMapDefine.soldierType_JingYing)])
	print("士兵类型: 通用, 个数", #self.tblSoldierPool)
	print("===================================================:")
end
return cityBuildSoldierPool
