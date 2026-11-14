local kingPacksRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	kingPacksRead = nil
	;(nil)[1] = "kingpacksconfig"
	kingPacksRead:defineValue("data", nil)
end
init()
function kingPacksRead.getTblKeys(_rank, kingdomLv)
	_rank = _rank or 1
	local _ENV, reTbl
	for _, v in ipairs(kingPacksRead.data) do
		if v.rank == _rank and v.serverLevType == kingdomLv then
			table.insert(reTbl, v.type)
		end
	end
	return reTbl
end
function kingPacksRead.getTblGift(isKing, kingdomLv)
	local _ENV, reTbl
	if isKing then
		for _, v in ipairs(kingPacksRead.data) do
			if v.rank == 1 and v.serverLevType == kingdomLv then
				table.insert(reTbl, v)
			end
		end
	else
		for _, v in ipairs(kingPacksRead.data) do
			if v.rank ~= 1 and v.serverLevType == kingdomLv then
				table.insert(reTbl, v)
			end
		end
	end
	return reTbl
end
function kingPacksRead.type2Rank(typeNum, kingdomLv)
	typeNum = tonumber(typeNum)
	local _rank = 0
	for _, v in ipairs(kingPacksRead.data) do
		if v.type == typeNum and v.serverLevType == kingdomLv then
			_rank = v.rank
		end
	end
	return _rank
end
function kingPacksRead.getItem(type)
	return kingPacksRead.data[type]
end
function kingPacksRead.getTotalNumByRank(rank)
	local ret = 0
	for _, value in pairs(kingPacksRead.data) do
		if value.rank == rank then
			ret = ret + value.num
		end
	end
	return ret
end
return kingPacksRead
