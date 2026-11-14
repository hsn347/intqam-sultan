local _ENV, starRhapsodyDef
local ROW_NUM = 3
starRhapsodyDef.isStar = true
starRhapsodyDef.ROW_NUM = ROW_NUM
function starRhapsodyDef.indexToXY(index)
	local x = (index - 1) % ROW_NUM + 1
	local y = math.ceil(index / ROW_NUM)
	return x, y
end
function starRhapsodyDef.xyToIndex(x, y)
	return (y - 1) * ROW_NUM + x
end
_ENV, starRhapsodyDef.GOLD_RESET_MAX_NUM = function(x, y)
	return (y - 1) * ROW_NUM + x
end, 3
;(function(x, y)
	return (y - 1) * ROW_NUM + x
end).RED = 1
;(function(x, y)
	return (y - 1) * ROW_NUM + x
end).YELLOW = 2
starRhapsodyDef.colorEnum, (function(x, y)
	return (y - 1) * ROW_NUM + x
end).BLUE = function(x, y)
	return (y - 1) * ROW_NUM + x
end, 3
if starRhapsodyDef.isStar then
	starRhapsodyDef.MOON_ITEM_ID = 816201
else
	starRhapsodyDef.MOON_ITEM_ID = 816601
end
return starRhapsodyDef
