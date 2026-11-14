local castleRewardRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "new_player_castle_exlv"
	;(nil)[2] = true
	castleRewardRead:defineValue("listView", nil)
	castleRewardRead = nil
	;(nil)[1] = "new_player_castle_exlv_show"
	castleRewardRead:defineValue("exRewardShow", nil)
	local createData = function(name)
		castleRewardRead.maxLv = 1
		local castleRewardRead, showRewards
		local castleRewardRead, cfgs
		local castleRewardRead, tmpCfgs
		for i, v in ipairs(castleRewardRead.listView) do
			if not cfgs[v.castlelv] then
				castleRewardRead = nil
				cfgs[v.castlelv], (nil).castlelv = nil, v.castlelv
				table.insert(tmpCfgs, cfgs[v.castlelv])
			end
			cfgs[v.castlelv][v.type] = v
			if v.castlelv > castleRewardRead.maxLv then
				castleRewardRead.maxLv = v.castlelv
			end
			for i2, v2 in pairs(v.show) do
				table.insert(showRewards, v2)
				if i2 % 2 == 0 then
					table.insert(showRewards, v.castlelv)
				end
			end
		end
		castleRewardRead.cfgs = tmpCfgs
		castleRewardRead.showRewards = showRewards
		if name == "maxLv" then
			return castleRewardRead.maxLv
		elseif name == "cfgs" then
			return castleRewardRead.cfgs
		elseif name == "showRewards" then
			return castleRewardRead.showRewards
		end
	end
	castleRewardRead:defineValue("maxLv", createData)
	castleRewardRead:defineValue("cfgs", createData)
	castleRewardRead:defineValue("showRewards", createData)
end
init()
function castleRewardRead.getCfgs()
	return castleRewardRead.cfgs
end
function castleRewardRead.getMaxLv()
	return castleRewardRead.maxLv
end
function castleRewardRead.getGoldShowReward()
	return castleRewardRead.exRewardShow[1].show
end
function castleRewardRead.getShowRewards()
	return castleRewardRead.showRewards
end
return castleRewardRead
