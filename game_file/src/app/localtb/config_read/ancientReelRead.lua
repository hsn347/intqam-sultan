local ancientReelRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	ancientReelRead:init()
end
function ancientReelRead:init()
	ancientReelRead:defineValue("levelList", function()
		local _ENV, levelList
		local levelListCfg = require_once("app." .. _G.LocalTblPath .. ".config_server.ancient_reel_lv_exp")
		for _, v in ipairs(levelListCfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local bronzeAward = serviceFunctions.tableFormat(v.bronzeAward, nil)
			v.bronzeAward = bronzeAward
			_UPVALUE2_ = "id"
			;("id")[1] = "id"
			;("id")[2] = "count"
			local goldAward = serviceFunctions.tableFormat(v.goldAward, "id")
			v.goldAward = goldAward
			v.index = v.lv
			levelList[v.lv] = v
		end
		return levelList
	end)
	ancientReelRead:defineValue("levelMaxList", function()
		local _ENV, levelMaxList
		local levelMaxListCfg = require_once("app." .. _G.LocalTblPath .. ".config_server.ancient_reel_lv_reward")
		for _, v in ipairs(levelMaxListCfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local award = serviceFunctions.tableFormat(v.award, nil)
			v.award = award
			local index = #ancientReelRead.levelList + 1
			v.index = index
			ancientReelRead.levelList[index] = v
			levelMaxList = v
		end
		return levelMaxList
	end)
	ancientReelRead:defineValue("expShopList", function()
		local _ENV, expShopList
		local tmp = require_once("app." .. _G.LocalTblPath .. ".config_server.ancient_reel_exp_shop")
		for _, v in ipairs(tmp) do
			expShopList[#expShopList + 1] = v
		end
		return expShopList
	end)
end
init()
function ancientReelRead:getLevelList(lv)
	if lv then
		return self.levelList[lv]
	end
	return self.levelList
end
function ancientReelRead:getLevelMaxList()
	return self.levelMaxList
end
function ancientReelRead:getExpShopList()
	return self.expShopList
end
return ancientReelRead
