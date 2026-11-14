local warGemltCtrl = include("warGemltCtrl")
local warGemData = class("warGemData")
function warGemData:ctor()
	;(nil).holeColor8, _UPVALUE0_, (nil).holeColor7, _UPVALUE0_, (nil).holeColor6, _UPVALUE0_, (nil).holeColor5, _UPVALUE0_, (nil).holeColor4, _UPVALUE0_, (nil).holeColor3, _UPVALUE0_, (nil).holeColor2, _UPVALUE0_, (nil).holeColor1, _UPVALUE0_, (nil).enchantmentAttribute8, _UPVALUE0_, (nil).enchantmentAttribute7, _UPVALUE0_, (nil).enchantmentAttribute6, _UPVALUE0_, (nil).enchantmentAttribute5, _UPVALUE0_, (nil).enchantmentAttribute4, _UPVALUE0_, (nil).enchantmentAttribute3, _UPVALUE0_, (nil).enchantmentAttribute2, _UPVALUE0_, (nil).enchantmentAttribute1, _UPVALUE0_, (nil).panelName, _UPVALUE0_, (nil).panel, _UPVALUE0_, (nil).bag, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	;(nil).strongEssenceCount = 0
	self.gemData, (nil).actPanelId = nil, 1
	self.isClearBuffCache = true
end
function warGemData:setGemData(data)
	self.gemData = data
	self.isClearBuffCache = true
end
function warGemData:getGemData()
	return self.gemData
end
function warGemData:setPanelData(panel)
	self.gemData.panel = panel
end
function warGemData:newEmptyPanel(panelId)
	local warGemltCtrl, panel
	local gemPanelCfg = warGemltCtrl:getGemPanelCfg()
	for lv, cfg in pairs(gemPanelCfg) do
		panel[lv], warGemltCtrl = nil, nil
		for i, _ in pairs(cfg.placeClour) do
			panel[lv][i] = 0
		end
	end
	self.gemData.panel[panelId] = panel
	self.isClearBuffCache = true
	return panel
end
function warGemData:addToBag(id, count)
	local orgCount = self:getItemFromBag(id) or 0
	self.gemData.bag[tostring(id)] = orgCount + count
	return true
end
function warGemData:delFromBag(id, count)
	local orgCount = self:getItemFromBag(id) or 0
	local leftCount = orgCount - count
	if leftCount <= 0 then
		self.gemData.bag[tostring(id)] = nil
	else
		self.gemData.bag[tostring(id)] = leftCount
	end
	return true
end
function warGemData:getItemFromBag(id)
	return self.gemData.bag[tostring(id)]
end
function warGemData:getBag()
	return self.gemData.bag
end
function warGemData:getItemUseBagCellCount(id)
	local itemCount = self:getItemFromBag(id) or 0
	return math.ceil(itemCount / WAR_GEM_BAG_CELL_OVERLAP_MAX)
end
function warGemData:getBagUsedCellCount()
	local count = 0
	for id, _ in pairs(self.gemData.bag) do
		count = count + self:getItemUseBagCellCount(id)
	end
	return count
end
function warGemData:canAddToBag(id)
	local itemCount = self:getItemFromBag(id) or 0
	if itemCount % WAR_GEM_BAG_CELL_OVERLAP_MAX ~= 0 then
		return true
	elseif self:getBagUsedCellCount() < WAR_GEM_BAG_CELL_MAX then
		return true
	else
		return false
	end
end
function warGemData:getBagItemMaxMergeCount(id)
	local maxCount = 0
	local gemCfg = warGemltCtrl:getGemCfg(id)
	for _, cost in pairs(gemCfg.mergeCost) do
		local leftCount = self:getItemFromBag(cost.id) or 0
		if leftCount < cost.count then
			return 0
		end
		local thisMaxCount = math.floor(leftCount / cost.count)
		maxCount = math.min(maxCount, thisMaxCount)
	end
	return maxCount
end
function warGemData:addToPanel(panelId, id, lv, idx)
	if panelId and self.gemData.panel[panelId] then
		local itemId = self:getItemFromPanel(panelId, lv, idx)
		if not itemId or not (0 < itemId) then
			self.gemData.panel[panelId][tostring(lv)][idx] = id
			self.isClearBuffCache = true
			return true
		end
	end
	return false
end
function warGemData:delFromPanel(panelId, lv, idx)
	if panelId and self.gemData.panel[panelId] then
		local itemId = self:getItemFromPanel(panelId, lv, idx)
		if itemId and 0 < itemId then
			self.gemData.panel[panelId][tostring(lv)][idx] = 0
			self.isClearBuffCache = true
			return true
		end
	end
	return false
end
function warGemData:getItemFromPanel(panelId, lv, idx)
	return self.gemData.panel[panelId] and self.gemData.panel[panelId][tostring(lv)] and self.gemData.panel[panelId][tostring(lv)][idx]
end
function warGemData:getPanel(panelId)
	return self.gemData.panel[panelId]
end
function warGemData:canMergeInPanel(id)
	local gemCfg = warGemltCtrl:getGemCfg(id)
	for _, cost in pairs(gemCfg.mergeCost) do
		local leftCount = self:getItemFromBag(cost.id) or 0
		if leftCount + 1 < cost.count then
			return false
		end
	end
	return true
end
function warGemData:getActPanelId()
	return self.gemData.actPanelId
end
function warGemData:setActPanelId(actPanelId)
	self.gemData.actPanelId = actPanelId
end
function warGemData:setPanelName(panelId, name)
	if not self.gemData.panelName then
		self.gemData.panelName, _ENV = nil, nil
	end
	if not self.gemData.panelName[tostring(panelId)] then
		self.gemData.panelName[tostring(panelId)], _ENV = panelId, panelId
	end
	self.gemData.panelName[tostring(panelId)] = name
end
function warGemData:getPanelName(panelId)
	return self.gemData.panelName and self.gemData.panelName[tostring(panelId)]
end
function warGemData:updateEssence(count)
	self.gemData.strongEssenceCount = count
end
function warGemData:setIsClearBuffCache(isClearBuffCache)
	self.isClearBuffCache = isClearBuffCache
end
function warGemData:getIsClearBuffCache()
	return self.isClearBuffCache
end
return warGemData
