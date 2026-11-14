local petraRareTreasureRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	petraRareTreasureRead:defineValue("itemCfg", function()
		petraRareTreasureRead.itemCfg, petraRareTreasureRead = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.secret_treasure_config")
		for i, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.Item, nil)
			if not reward or not reward[1] then
				petraRareTreasureRead = reward[1]
			end
			petraRareTreasureRead.itemCfg[i] = reward[1]
		end
		return petraRareTreasureRead.itemCfg
	end)
	function _ENV()
		petraRareTreasureRead.itemCfg, petraRareTreasureRead = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.secret_treasure_config")
		for i, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.Item, nil)
			if not reward or not reward[1] then
				petraRareTreasureRead = reward[1]
			end
			petraRareTreasureRead.itemCfg[i] = reward[1]
		end
		return petraRareTreasureRead.itemCfg
	end
	;(function()
		petraRareTreasureRead.itemCfg, petraRareTreasureRead = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.secret_treasure_config")
		for i, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.Item, nil)
			if not reward or not reward[1] then
				petraRareTreasureRead = reward[1]
			end
			petraRareTreasureRead.itemCfg[i] = reward[1]
		end
		return petraRareTreasureRead.itemCfg
	end)[1] = "secret_treasure_refresh"
	;(function()
		petraRareTreasureRead.itemCfg, petraRareTreasureRead = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.secret_treasure_config")
		for i, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.Item, nil)
			if not reward or not reward[1] then
				petraRareTreasureRead = reward[1]
			end
			petraRareTreasureRead.itemCfg[i] = reward[1]
		end
		return petraRareTreasureRead.itemCfg
	end)[2] = true
	petraRareTreasureRead:defineValue("refreshCfg", function()
		petraRareTreasureRead.itemCfg, petraRareTreasureRead = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.secret_treasure_config")
		for i, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.Item, nil)
			if not reward or not reward[1] then
				petraRareTreasureRead = reward[1]
			end
			petraRareTreasureRead.itemCfg[i] = reward[1]
		end
		return petraRareTreasureRead.itemCfg
	end)
	petraRareTreasureRead:defineValue("selectCfg", function()
		petraRareTreasureRead.selectCfg, petraRareTreasureRead = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.secret_treasure_select")
		for i, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.Item, nil)
			if not reward or not reward[1] then
				local petraRareTreasureRead, data = reward[1], reward[1]
			end
			data.index = i
			petraRareTreasureRead.selectCfg[i] = data
		end
		return petraRareTreasureRead.selectCfg
	end)
end
init()
function petraRareTreasureRead:getItemCfg(index)
	if index then
		return self.itemCfg[index]
	else
		return self.itemCfg
	end
end
function petraRareTreasureRead:getRefreshCfg(index)
	if index then
		if index > #self.refreshCfg then
			return self.refreshCfg[#self.refreshCfg]
		else
			return self.refreshCfg[index]
		end
	else
		return self.refreshCfg
	end
end
function petraRareTreasureRead:getSelectItem(index)
	if index then
		return self.selectCfg[index]
	else
		return self.selectCfg
	end
end
return petraRareTreasureRead
