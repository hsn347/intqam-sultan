local iceDragonCaveRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "dragoncave_draw"
;(nil)[2] = true
iceDragonCaveRead:defineValue("dragoncave_draw", nil)
_UPVALUE1_ = nil
;(nil)[1] = "dragoncave_show"
iceDragonCaveRead:defineValue("dragoncave_show", nil)
_UPVALUE2_ = nil
;(nil)[1] = "dragoncave_reward"
;(nil)[2] = true
iceDragonCaveRead:defineValue("dragoncave_reward", nil)
iceDragonCaveRead:defineValue("drawCfg", function()
	iceDragonCaveRead.drawCfg, iceDragonCaveRead = nil, nil
	for i, v in ipairs(iceDragonCaveRead.dragoncave_draw) do
		if iceDragonCaveRead.drawCfg[v.group] == nil then
			iceDragonCaveRead.drawCfg[v.group], iceDragonCaveRead = nil, nil
		end
		_UPVALUE3_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		;(nil)[3] = "rate"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(iceDragonCaveRead.drawCfg[v.group], v)
	end
	return iceDragonCaveRead.drawCfg
end)
iceDragonCaveRead:defineValue("showCfg", function()
	iceDragonCaveRead.showCfg, iceDragonCaveRead = nil, nil
	for i, v in ipairs(iceDragonCaveRead.dragoncave_show) do
		iceDragonCaveRead.showCfg[v.group] = v
	end
	return iceDragonCaveRead.showCfg
end)
iceDragonCaveRead:defineValue("rewardCfg", function()
	iceDragonCaveRead.rewardCfg, iceDragonCaveRead = nil, nil
	for i, v in ipairs(iceDragonCaveRead.dragoncave_reward) do
		if iceDragonCaveRead.rewardCfg[v.group] == nil then
			iceDragonCaveRead.rewardCfg[v.group], iceDragonCaveRead = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(iceDragonCaveRead.rewardCfg[v.group], v)
	end
	return iceDragonCaveRead.rewardCfg
end)
function iceDragonCaveRead.getDrawCfgList()
	local group = SoraDGetCtrl("iceDragonCaveCtrl"):getGroup()
	return iceDragonCaveRead.drawCfg[group]
end
function iceDragonCaveRead.getRewardCfgList()
	local group = SoraDGetCtrl("iceDragonCaveCtrl"):getGroup()
	return iceDragonCaveRead.rewardCfg[group]
end
function iceDragonCaveRead.getShowCfg()
	local group = SoraDGetCtrl("iceDragonCaveCtrl"):getGroup()
	return iceDragonCaveRead.showCfg[group]
end
function iceDragonCaveRead.getDrawCfg(draw)
	local group = SoraDGetCtrl("iceDragonCaveCtrl"):getGroup()
	local cfgs = iceDragonCaveRead.drawCfg[group]
	for i, v in ipairs(cfgs) do
		if v.draw == draw then
			return v
		end
	end
	return nil
end
function iceDragonCaveRead.getRewardCfg(draw)
	local group = SoraDGetCtrl("iceDragonCaveCtrl"):getGroup()
	local cfgs = iceDragonCaveRead.rewardCfg[group]
	for i, v in ipairs(cfgs) do
		if v.draw == draw then
			return v
		end
	end
	return nil
end
return iceDragonCaveRead
