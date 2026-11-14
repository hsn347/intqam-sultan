local activity_9001655_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "constellation_departure_config"
;(nil)[2] = true
activity_9001655_Read:defineValue("config", nil)
function activity_9001655_Read.getAwardByValue()
	local activity_9001655_Read, backTbl
	local tmpTbl = activity_9001655_Read.config
	table.sort(tmpTbl, function(l, r)
		if l.Value ~= r.Value then
			return l.Value < r.Value
		end
		return l.position < r.position
	end)
	for i, v in ipairs(tmpTbl) do
		activity_9001655_Read = nil
		;(nil).id = v.rewards[1]
		;(nil).count = v.rewards[2]
		;(nil).position = v.position
		table.insert(backTbl, nil)
	end
	return backTbl
end
function activity_9001655_Read.getConfigNum()
	return table.nums(activity_9001643_Read.config)
end
function activity_9001655_Read.getRewardByPos(position)
	for i, v in ipairs(activity_9001655_Read.config) do
		if v.position == position then
			_ENV = v.position
			v.position.id = v.rewards[1]
			v.position.count = v.rewards[2]
			return v.position
		end
	end
end
function activity_9001655_Read.isRare(position)
	for i, v in ipairs(activity_9001655_Read.config) do
		if v.position == position and v.rare == 1 then
			return true
		end
	end
end
function activity_9001655_Read.getRareItem()
	for i, v in ipairs(activity_9001655_Read.config) do
		if v.rare == 1 then
			_ENV = v.rare
			v.rare.id = v.rewards[1]
			v.rare.count = v.rewards[2]
			return v.rare
		end
	end
end
_UPVALUE2_ = nil
;(nil)[1] = "constellation_departure_lock"
;(nil)[2] = true
activity_9001655_Read:defineValue("lock", nil)
function activity_9001655_Read.getCostByRound(round)
	local round = math.min(round, #activity_9001655_Read.lock)
	for i, v in ipairs(activity_9001655_Read.lock) do
		if v.round == round then
			_ENV = v.round
			v.round.id = v.cost[1]
			v.round.count = v.cost[2]
			return v.round
		end
	end
end
function activity_9001655_Read.getStarSignPng(style)
	_UPVALUE0_ = nil
	;(nil)[1] = "frame_9001655_shuiping.png"
	;(nil)[2] = "frame_9001655_shuangyu.png"
	;(nil)[3] = "frame_9001655_baiyang.png"
	;(nil)[4] = "frame_9001655_jinniu.png"
	;(nil)[5] = "frame_9001655_shuangzi.png"
	;(nil)[6] = "frame_9001655_juxie.png"
	;(nil)[7] = "frame_9001655_shizi.png"
	;(nil)[8] = "frame_9001655_chunv.png"
	;(nil)[9] = "frame_9001655_tiancheng.png"
	;(nil)[10] = "frame_9001655_tianxie.png"
	;(nil)[11] = "frame_9001655_sheshou.png"
	local (nil)[12], pngCfg = "frame_9001655_mojie.png", nil
	return pngCfg[style]
end
return activity_9001655_Read
