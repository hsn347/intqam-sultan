local djRead = include("aAReadClass").new()
_ENV = "aAReadClass"
;("aAReadClass").month_lv = 1
;("aAReadClass").mohth_rank = 2
;("aAReadClass").live_honor = 3
;("aAReadClass").live_rank = 4
_ENV, djRead.detailEnum, ("aAReadClass").anchor_lv = "aAReadClass", "aAReadClass", 5
;("aAReadClass")[1] = "#4CE61A"
;("aAReadClass")[2] = "#3EAAEE"
;("aAReadClass")[3] = "#B62BF6"
;("aAReadClass")[4] = "#E2C53D"
_ENV, djRead.colorDef, ("aAReadClass")[5] = "aAReadClass", "aAReadClass", "#EA1716"
;("aAReadClass").ONE_KINGDOM_WEEK = 1
;("aAReadClass").ONE_KINGDOM_MONTH = 2
;("aAReadClass").ONE_KINGDOM_TOTAL = 3
;("aAReadClass").ALL_KINGDOM_WEEK = 4
;("aAReadClass").ALL_KINGDOM_MONTH = 5
;("aAReadClass").ALL_KINGDOM_TOTAL = 6
;("aAReadClass").ANCHOR_POPULARITY_WEEK = 7
;("aAReadClass").ANCHOR_POPULARITY_MONTH = 8
;("aAReadClass").ANCHOR_POPULARITY_TOTAL = 9
;("aAReadClass").MEMBER_MONTH = 10
djRead.gChatAnchorRankType, ("aAReadClass").MEMBER_TOTAL = "aAReadClass", 11
djRead:defineValue("month_lv", function()
	local config = require_data("month_lv", true, true).data
	local _ENV, ret = "month_lv", "month_lv"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewardMonth = serviceFunctions.tableFormat(v.rewardMonth, nil)
		ret[v.lvMonth] = v
	end
	return ret
end)
function djRead.getMonthLvCfg(lv)
	return lv and djRead.month_lv[lv] or djRead.month_lv
end
function djRead.getMonthMaxLv()
	return #djRead.month_lv
end
function djRead.getMonthLvByExp(exp)
	local lv = 0
	for _, v in ipairs(djRead.month_lv) do
		if exp >= v.valueMonth then
			lv = v.lvMonth
		end
	end
	return lv
end
djRead:defineValue("lifelong_lv", function()
	local config = require_data("lifelong_lv", true, true).data
	local _ENV, ret = "lifelong_lv", "lifelong_lv"
	for k, v in ipairs(config) do
		ret[v.lvLife] = v
	end
	return ret
end)
function djRead.getLifeLvCfg(lv)
	return lv and djRead.lifelong_lv[lv] or djRead.lifelong_lv
end
function djRead.getLifeLvByExp(exp)
	local lv = 0
	for _, v in ipairs(djRead.lifelong_lv) do
		if exp >= v.valueLife then
			lv = v.lvLife
		end
	end
	return lv
end
djRead:defineValue("anchor_lv", function()
	local config = require_data("anchor_lv", true, true).data
	local _ENV, ret = "anchor_lv", "anchor_lv"
	for k, v in ipairs(config) do
		ret[v.lvAnchor] = v
	end
	return ret
end)
function djRead.getAnchorLvCfg(lv)
	return lv and djRead.anchor_lv[lv] or djRead.anchor_lv
end
function djRead.getAnchorLvByExp(exp)
	local lv = 0
	for _, v in ipairs(djRead.anchor_lv) do
		if exp >= v.valueAnchor then
			lv = v.lvAnchor
		end
	end
	return lv
end
djRead:defineValue("blacklist", function()
	local config = require_data("blacklist", true, true).data
	local _ENV, ret = "blacklist", "blacklist"
	for k, v in ipairs(config) do
		if not ret[v.limitType] then
			ret[v.limitType], _ENV = nil, nil
		end
		ret[v.limitType][v.behavior] = v.parameter
	end
	return ret
end)
function djRead.getBlacklistCfg(limitType, behavior)
	return djRead.blacklist[limitType][behavior]
end
function djRead.getColorByLv(lv, tbType)
	local color = 1
	if tbType == 1 then
		for _, v in ipairs(djRead.month_lv) do
			if lv == v.lvMonth then
				color = v.color
				break
			end
		end
	elseif tbType == 2 then
		for _, v in ipairs(djRead.lifelong_lv) do
			if lv == v.lvLife then
				color = v.color
				break
			end
		end
	elseif tbType == 3 then
		for _, v in ipairs(djRead.anchor_lv) do
			if lv == v.lvAnchor then
				color = v.color
				break
			end
		end
	end
	return djRead.colorDef[color]
end
return djRead
