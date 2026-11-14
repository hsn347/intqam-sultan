local starRhapsodyRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	starRhapsodyRead:defineValue("resetCfg", function()
		starRhapsodyRead.resetCfg, starRhapsodyRead = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.star_lamp_reset")
		for i, v in ipairs(cfg) do
			starRhapsodyRead.resetCfg[i] = v.cost and v.cost[2] or 0
		end
		return starRhapsodyRead.resetCfg
	end)
	starRhapsodyRead:defineValue("combCfg", function()
		starRhapsodyRead.combCfg, starRhapsodyRead = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.star_lamp_comb")
		for i, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.reward, nil)
			v.reward = reward
			if not starRhapsodyRead.combCfg[v.classType] then
				starRhapsodyRead = starRhapsodyRead.combCfg[v.classType]
			end
			starRhapsodyRead.combCfg[v.classType] = starRhapsodyRead.combCfg[v.classType]
			table.insert(starRhapsodyRead.combCfg[v.classType], v)
		end
		return starRhapsodyRead.combCfg
	end)
	starRhapsodyRead:defineValue("awardCfg", function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		_UPVALUE0_, (nil)[1], (nil).name = nil, nil, "starlight_name_01"
		_UPVALUE0_, (nil)[2], (nil).name = nil, nil, "starlight_name_02"
		_UPVALUE0_, (nil)[3], (nil).name = nil, nil, "starlight_name_03"
		;(nil)[4], (nil).name = nil, "starlight_name_04"
		return nil
	end)
end
init()
function starRhapsodyRead:getResetGold(index)
	if index > #self.resetCfg then
		return self.resetCfg[#self.resetCfg]
	end
	return self.resetCfg[index]
end
function starRhapsodyRead:getCombCfg(index)
	local groupID = SoraDGetCtrl("starRhapsodyCtrl"):getGroupID()
	if index then
		return self.combCfg[groupID][index]
	else
		return self.combCfg[groupID]
	end
end
function starRhapsodyRead:getAwardNmae(index)
	local cfg = self.awardCfg[index]
	if cfg then
		return i18n(cfg.name)
	end
end
return starRhapsodyRead
