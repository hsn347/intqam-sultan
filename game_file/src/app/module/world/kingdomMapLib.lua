local _ENV, kingdomMapLib
function kingdomMapLib:getMapKey(x, y)
	return x * 10000 + y
end
function kingdomMapLib:isInRang(x, y, rang)
	if x >= rang.startX and x <= rang.endX and y >= rang.startY and y <= rang.endY then
		return true
	else
		return false
	end
end
return kingdomMapLib
