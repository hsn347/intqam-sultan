local recruitmentRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "novice_gift"
	;(nil)[2] = true
	recruitmentRead:defineValue("info", nil)
end
init()
function recruitmentRead.getDayAndAwardsList()
	local _ENV, tbl
	for i, v in ipairs(recruitmentRead.info) do
		_ENV = nil
		;(nil).taskID = v.index
		;(nil).isAct = 0
		;(nil).total = v.index
		recruitmentRead, (nil).award = recruitmentRead.checkAward(v.award), recruitmentRead.checkAward(v.award)
		recruitmentRead.checkAward(v.award).num = v.index
		;(nil).taskDes, recruitmentRead.checkAward(v.award)[1] = recruitmentRead.checkAward(v.award), "king_road_01"
		table.insert(tbl, nil)
	end
	return tbl
end
function recruitmentRead.checkAward(award)
	local _ENV, ret
	for i = 1, #award, 2 do
		_ENV = nil
		;(nil).id = award[i]
		local (nil).count, v = award[i + 1], nil
		if award[i] == 900012 then
			v.heightLight = true
		end
		table.insert(ret, v)
	end
	return ret
end
function recruitmentRead.getIconByDay(day)
	return recruitmentRead.info[math.min(day, recruitmentRead.getMaxDay())].rewardShow
end
function recruitmentRead.getMaxDay()
	return #recruitmentRead.info
end
return recruitmentRead
