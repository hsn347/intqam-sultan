local endlessTreasureRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "endless_treasures_config"
	;(nil)[2] = true
	endlessTreasureRead:defineValue("config", nil)
	endlessTreasureRead:defineValue("cfg", function()
		endlessTreasureRead.cfg, endlessTreasureRead = nil, nil
		for k, v in ipairs(endlessTreasureRead.config) do
			endlessTreasureRead.cfg[v.depositsID] = v
		end
		return endlessTreasureRead.cfg
	end)
end
init()
function endlessTreasureRead.getTreasureTime(tID)
	return endlessTreasureRead.cfg[tID] and endlessTreasureRead.cfg[tID].time or 0
end
function endlessTreasureRead.getTreasureIcon(tID)
	return endlessTreasureRead.cfg[tID] and endlessTreasureRead.cfg[tID].icon or "icon_wjbz_bz_01.png"
end
function endlessTreasureRead.getTreasureEffect(tID)
	local endlessTreasureRead, icon = nil, endlessTreasureRead.cfg[tID] and endlessTreasureRead.cfg[tID].icon or "icon_wjbz_bz_01.png"
	;(nil)["icon_wjbz_bz_01.png"] = "animationETType1"
	;(nil)["icon_wjbz_bz_02.png"] = "animationETType2"
	;(nil)["icon_wjbz_bz_03.png"] = "animationETType3"
	local (nil)["icon_wjbz_bz_04.png"], effectCfg = "animationETType4", nil
	return effectCfg[icon]
end
function endlessTreasureRead.getTreasureName(tID)
	print("tID=========", tID)
	if not endlessTreasureRead.cfg[tID] or not i18n(endlessTreasureRead.cfg[tID].name) then
		_ENV = tID
		tID.num = 1
	end
	return (i18n("endless_treasures_text_41", tID))
end
function endlessTreasureRead.getTreasureAward(tID)
	local endlessTreasureRead, ret
	if endlessTreasureRead.cfg[tID] then
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		ret[1] = serviceFunctions.tableFormat(endlessTreasureRead.cfg[tID].award1, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		ret[2] = serviceFunctions.tableFormat(endlessTreasureRead.cfg[tID].award2, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		ret[3] = serviceFunctions.tableFormat(endlessTreasureRead.cfg[tID].award3, nil)
	end
	return ret
end
return endlessTreasureRead
