local pyramidTreasureRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "pyramid_treasure_config"
	;(nil)[2] = true
	pyramidTreasureRead:defineValue("config", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "pyramid_treasure_refresh"
	;(nil)[2] = true
	pyramidTreasureRead:defineValue("refresh", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "pyramid_treasure_select"
	;(nil)[2] = true
	pyramidTreasureRead:defineValue("select", nil)
end
init()
function pyramidTreasureRead.getSelectList()
	local _ENV, list
	local groupType = SoraDGetCtrl("pyramidRareTreasureCtrl"):getGroupType()
	for k, v in ipairs(pyramidTreasureRead.select) do
		if groupType == v.group then
			_ENV = nil
			;(nil).id = v.Item[1]
			;(nil).count = v.Item[2]
			;(nil).index = v.Index
			table.insert(list, nil)
		end
	end
	return list
end
function pyramidTreasureRead.getBestCfg(index)
	local id, count
	local groupType = SoraDGetCtrl("pyramidRareTreasureCtrl"):getGroupType()
	for k, v in ipairs(pyramidTreasureRead.select) do
		if groupType == v.group and index == v.Index then
			id = v.Item[1]
			count = v.Item[2]
		end
	end
	return id, count
end
function pyramidTreasureRead.getRefreshGold(index)
	local gold = pyramidTreasureRead.refresh[#pyramidTreasureRead.refresh].gold
	for k, v in ipairs(pyramidTreasureRead.refresh) do
		if v.num == index then
			gold = v.gold
			break
		end
	end
	return gold
end
function pyramidTreasureRead.isJZIndex(index)
	local ret = false
	local groupType = SoraDGetCtrl("pyramidRareTreasureCtrl"):getGroupType()
	for k, v in ipairs(pyramidTreasureRead.config) do
		if groupType == v.group and index == v.Index and v.Item[1] == gIDDef.PYRAMID_RARE_TREASURE_KEY then
			ret = true
			break
		end
	end
	return ret
end
function pyramidTreasureRead.getNormalConfig()
	local _ENV, tbNoraml
	local groupType = SoraDGetCtrl("pyramidRareTreasureCtrl"):getGroupType()
	for k, v in ipairs(pyramidTreasureRead.config) do
		if groupType == v.group and next(v.Item) and v.Item[1] ~= gIDDef.PYRAMID_RARE_TREASURE_KEY then
			_ENV = nil
			;(nil).id = v.Item[1]
			;(nil).count = v.Item[2]
			;(nil).index = v.Index
			table.insert(tbNoraml, nil)
		end
	end
	return tbNoraml
end
function pyramidTreasureRead.getNormalCfg(index)
	local id, count
	local _ENV, itemList
	local groupType = SoraDGetCtrl("pyramidRareTreasureCtrl"):getGroupType()
	for k, v in ipairs(pyramidTreasureRead.config) do
		if groupType == v.group then
			table.insert(itemList, v)
		end
	end
	for i, v in ipairs(itemList) do
		if index == i then
			id = v.Item[1]
			count = v.Item[2]
		end
	end
	return id, count
end
function pyramidTreasureRead.getBDYConfig()
	local id, count
	local groupType = SoraDGetCtrl("pyramidRareTreasureCtrl"):getGroupType()
	for k, v in ipairs(pyramidTreasureRead.config) do
		if groupType == v.group and v.Item[1] and v.Item[1] == gIDDef.PYRAMID_RARE_TREASURE_KEY then
			id = v.Item[1]
			count = v.Item[2]
			break
		end
	end
	return id, count
end
return pyramidTreasureRead
