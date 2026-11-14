local kohMigrateRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "migrant_move_kingdom"
;(nil)[2] = true
kohMigrateRead:defineValue("migrant_move_kingdom", nil)
kohMigrateRead:defineValue("kingdomConfig", function()
	local _ENV, ret
	for k, v in pairs(kohMigrateRead.migrant_move_kingdom) do
		ret[v.kid] = v
	end
	return ret
end)
function kohMigrateRead.getKingdomConfig(kid)
	return kohMigrateRead.kingdomConfig[kid] or kohMigrateRead.kingdomConfig[0]
end
function kohMigrateRead.getKingdomByKey(kid, key)
	local cfg = kohMigrateRead.getKingdomConfig(kid)
	return cfg[key] or 0
end
function kohMigrateRead.getKingdom_legendlimit(kid)
	return kohMigrateRead.getKingdomByKey(kid, "legendlimit")
end
function kohMigrateRead.getKingdom_legendplayer(kid)
	return kohMigrateRead.getKingdomByKey(kid, "legendplayer")
end
function kohMigrateRead.getKingdom_highplayer(kid)
	return kohMigrateRead.getKingdomByKey(kid, "highplayer")
end
function kohMigrateRead.getKingdom_lowplayer(kid)
	return kohMigrateRead.getKingdomByKey(kid, "lowplayer")
end
function kohMigrateRead.getKingdom_powerlimit(kid)
	return kohMigrateRead.getKingdomByKey(kid, "powerlimit")
end
function kohMigrateRead.getKingdom_inviteplayer(kid)
	return kohMigrateRead.getKingdomByKey(kid, "inviteplayer")
end
function _UPVALUE2_()
	local _ENV, ret
	for k, v in pairs(kohMigrateRead.migrant_move_kingdom) do
		ret[v.kid] = v
	end
	return ret
end
;(function()
	local _ENV, ret
	for k, v in pairs(kohMigrateRead.migrant_move_kingdom) do
		ret[v.kid] = v
	end
	return ret
end)[1] = "migrant_move_legend_play"
;(function()
	local _ENV, ret
	for k, v in pairs(kohMigrateRead.migrant_move_kingdom) do
		ret[v.kid] = v
	end
	return ret
end)[2] = true
kohMigrateRead:defineValue("migrant_move_legend_play", function()
	local _ENV, ret
	for k, v in pairs(kohMigrateRead.migrant_move_kingdom) do
		ret[v.kid] = v
	end
	return ret
end)
kohMigrateRead:defineValue("kingdomLegendConfig", function()
	local _ENV, ret
	for __, v in pairs(kohMigrateRead.migrant_move_legend_play) do
		ret[v.kid] = (ret[v.kid] or 0) + v.legend
	end
	return ret
end)
function kohMigrateRead.getKingdmBeginLegend(kid)
	return kohMigrateRead.kingdomLegendConfig[kid] or 0
end
function kohMigrateRead.getPlayerLegend(uid)
	local cfg = kohMigrateRead.migrant_move_legend_play[uid]
	return cfg and cfg.legend
end
function kohMigrateRead.getIsLegendPlayer(uid)
	local legend = kohMigrateRead.getPlayerLegend(uid)
	return legend ~= nil
end
function kohMigrateRead.getLegendPlayerNumber(...)
	return table.nums(kohMigrateRead.migrant_move_legend_play)
end
function _UPVALUE2_()
	local _ENV, ret
	for __, v in pairs(kohMigrateRead.migrant_move_legend_play) do
		ret[v.kid] = (ret[v.kid] or 0) + v.legend
	end
	return ret
end
;(function()
	local _ENV, ret
	for __, v in pairs(kohMigrateRead.migrant_move_legend_play) do
		ret[v.kid] = (ret[v.kid] or 0) + v.legend
	end
	return ret
end)[1] = "migrant_constant"
;(function()
	local _ENV, ret
	for __, v in pairs(kohMigrateRead.migrant_move_legend_play) do
		ret[v.kid] = (ret[v.kid] or 0) + v.legend
	end
	return ret
end)[2] = true
kohMigrateRead:defineValue("migrant_constant", function()
	local _ENV, ret
	for __, v in pairs(kohMigrateRead.migrant_move_legend_play) do
		ret[v.kid] = (ret[v.kid] or 0) + v.legend
	end
	return ret
end)
function kohMigrateRead.getConstValue(key, defaultValue)
	local array = kohMigrateRead.getConstArray(key)
	return array[1] or defaultValue
end
function kohMigrateRead.getConstArray(key, defaultValue)
