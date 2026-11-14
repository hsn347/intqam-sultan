kingdomPointDefine, _ENV = nil, nil
kingdomPointDefine.CIRCLE = 15
kingdomPointDefine.index2point1, _ENV = nil, nil
kingdomPointDefine.index2point2, _ENV = nil, nil
kingdomPointDefine.point2index1, _ENV = nil, nil
kingdomPointDefine.point2index2, _ENV = nil, nil
kingdomPointDefine.index2kid, _ENV = nil, nil
kingdomPointDefine.kid2index, _ENV = nil, nil
function kingdomPointDefine.getKidBgPos(x, y)
	local kid = 0
	local t = math.max(math.abs(x), math.abs(y))
	local max_value = (2 * t + 1) * (2 * t + 1)
	if x == -t then
		kid = max_value + (y - 5 * t)
	elseif x == t then
		kid = max_value + (-y - t)
	elseif y == -t then
		kid = max_value + (-7 * t - x)
	else
		kid = max_value + (x - 3 * t)
	end
	return kid
end
function kingdomPointDefine.init()
	for x = -kingdomPointDefine.CIRCLE, kingdomPointDefine.CIRCLE do
		for y = -kingdomPointDefine.CIRCLE, kingdomPointDefine.CIRCLE do
			local index = kingdomPointDefine.getKidBgPos(x, y)
			kingdomPointDefine.index2point1[index] = cc.p(x, y)
			local key = x .. "_" .. y
			kingdomPointDefine.point2index1[key] = index
		end
	end
	_UPVALUE8_, _UPVALUE12_ = kingdomPointDefine.CIRCLE, (for index)
	_UPVALUE8_, kingdomPointDefine.CIRCLE[1] = 24, 24
	_UPVALUE8_, kingdomPointDefine.CIRCLE[2] = 24, 18
	_UPVALUE8_, kingdomPointDefine.CIRCLE[3] = 24, 12
	_UPVALUE8_, kingdomPointDefine.CIRCLE[4] = 24, 6
	_UPVALUE8_, kingdomPointDefine.CIRCLE[5] = 24, 30
	_UPVALUE8_, kingdomPointDefine.CIRCLE[6] = 24, 36
	_UPVALUE8_, kingdomPointDefine.CIRCLE[7] = 24, 42
	_UPVALUE8_, kingdomPointDefine.CIRCLE[8] = 24, 48
	_UPVALUE8_, (24)[1] = 23, 23
	_UPVALUE8_, (24)[2] = 23, 17
	_UPVALUE8_, (24)[3] = 23, 11
	_UPVALUE8_, (24)[4] = 23, 5
	_UPVALUE8_, (24)[5] = 23, 29
	_UPVALUE8_, (24)[6] = 23, 35
	_UPVALUE8_, (24)[7] = 23, 41
	_UPVALUE8_, (24)[8] = 23, 47
	_UPVALUE8_, (23)[1] = 22, 22
	_UPVALUE8_, (23)[2] = 22, 16
	_UPVALUE8_, (23)[3] = 22, 10
	_UPVALUE8_, (23)[4] = 22, 4
	_UPVALUE8_, (23)[5] = 22, 28
	_UPVALUE8_, (23)[6] = 22, 34
	_UPVALUE8_, (23)[7] = 22, 40
	_UPVALUE8_, (23)[8] = 22, 46
	_UPVALUE8_, (22)[1] = 21, 21
	_UPVALUE8_, (22)[2] = 21, 15
	_UPVALUE8_, (22)[3] = 21, 9
	_UPVALUE8_, (22)[4] = 21, 3
	_UPVALUE8_, (22)[5] = 21, 27
	_UPVALUE8_, (22)[6] = 21, 33
	_UPVALUE8_, (22)[7] = 21, 39
	_UPVALUE8_, (22)[8] = 21, 45
	_UPVALUE8_, (21)[1] = 20, 20
	_UPVALUE8_, (21)[2] = 20, 14
	_UPVALUE8_, (21)[3] = 20, 8
	_UPVALUE8_, (21)[4] = 20, 2
	_UPVALUE8_, (21)[5] = 20, 26
	_UPVALUE8_, (21)[6] = 20, 32
	_UPVALUE8_, (21)[7] = 20, 38
	_UPVALUE8_, (21)[8] = 20, 44
	_UPVALUE8_, (20)[1] = 19, 19
	_UPVALUE8_, (20)[2] = 19, 13
	_UPVALUE8_, (20)[3] = 19, 7
	_UPVALUE8_, (20)[4] = 19, 1
	_UPVALUE8_, (20)[5] = 19, 25
	_UPVALUE8_, (20)[6] = 19, 31
	_UPVALUE8_, (20)[7] = 19, 37
	_UPVALUE8_, (20)[8] = 19, 43
	_UPVALUE8_, (19)[1] = 67, 67
	_UPVALUE8_, (19)[2] = 67, 61
	_UPVALUE8_, (19)[3] = 67, 55
	_UPVALUE8_, (19)[4] = 67, 49
	_UPVALUE8_, (19)[5] = 67, 73
	_UPVALUE8_, (19)[6] = 67, 79
	_UPVALUE8_, (19)[7] = 67, 85
	_UPVALUE8_, (19)[8] = 67, 91
	_UPVALUE8_, (67)[1] = 68, 68
	_UPVALUE8_, (67)[2] = 68, 62
	_UPVALUE8_, (67)[3] = 68, 56
	_UPVALUE8_, (67)[4] = 68, 50
	_UPVALUE8_, (67)[5] = 68, 74
	_UPVALUE8_, (67)[6] = 68, 80
	_UPVALUE8_, (67)[7] = 68, 86
	_UPVALUE8_, (67)[8] = 68, 92
	_UPVALUE8_, (68)[1] = 69, 69
	_UPVALUE8_, (68)[2] = 69, 63
	_UPVALUE8_, (68)[3] = 69, 57
	_UPVALUE8_, (68)[4] = 69, 51
	_UPVALUE8_, (68)[5] = 69, 75
	_UPVALUE8_, (68)[6] = 69, 81
	_UPVALUE8_, (68)[7] = 69, 87
	_UPVALUE8_, (68)[8] = 69, 93
	_UPVALUE8_, (69)[1] = 70, 70
	_UPVALUE8_, (69)[2] = 70, 64
	_UPVALUE8_, (69)[3] = 70, 58
	_UPVALUE8_, (69)[4] = 70, 52
	_UPVALUE8_, (69)[5] = 70, 76
	_UPVALUE8_, (69)[6] = 70, 82
	_UPVALUE8_, (69)[7] = 70, 88
	_UPVALUE8_, (69)[8] = 70, 94
	_UPVALUE8_, (70)[1] = 71, 71
	_UPVALUE8_, (70)[2] = 71, 65
	_UPVALUE8_, (70)[3] = 71, 59
	_UPVALUE8_, (70)[4] = 71, 53
	_UPVALUE8_, (70)[5] = 71, 77
	_UPVALUE8_, (70)[6] = 71, 83
	_UPVALUE8_, (70)[7] = 71, 89
	_UPVALUE8_, (70)[8] = 71, 95
	;(71)[1] = 72
	;(71)[2] = 66
	;(71)[3] = 60
	;(71)[4] = 54
	;(71)[5] = 78
	;(71)[6] = 84
	;(71)[7] = 90
	;(71)[8] = 96
	;(-kingdomPointDefine.CIRCLE)[1] = kingdomPointDefine.CIRCLE
	;(-kingdomPointDefine.CIRCLE)[2] = 24
	;(-kingdomPointDefine.CIRCLE)[3] = 23
	;(-kingdomPointDefine.CIRCLE)[4] = 22
	;(-kingdomPointDefine.CIRCLE)[5] = 21
	;(-kingdomPointDefine.CIRCLE)[6] = 20
	;(-kingdomPointDefine.CIRCLE)[7] = 19
	;(-kingdomPointDefine.CIRCLE)[8] = 67
	;(-kingdomPointDefine.CIRCLE)[9] = 68
	;(-kingdomPointDefine.CIRCLE)[10] = 69
	;(-kingdomPointDefine.CIRCLE)[11] = 70
	local (-kingdomPointDefine.CIRCLE)[12], config = 71, -kingdomPointDefine.CIRCLE
	local max_x = 8
	local max_y = 12
	local zero = cc.p(-max_x / 2, max_y / 2)
	for y = 1, max_y do
		for x = 1, max_x do
			local pos = cc.p(zero.x + x, zero.y - y)
			local index = config[y][x]
			kingdomPointDefine.index2point2[index] = pos
			local key = pos.x .. "_" .. pos.y
			kingdomPointDefine.point2index2[key] = index
		end
	end
end
function kingdomPointDefine.getKingdomPointWithID(kingdomID)
	if not kingdomID or kingdomID == 0 then
		return cc.p(0, 0)
	end
	local mapClassType = worldMapDefine.getKingdomMapClassByKingdomId(kingdomID)
	if mapClassType ~= gKingdomClassType.normal then
		return cc.p(0, 0)
	end
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local regionType, regionId = nebulaActivityCtrl:getKingdomRegionType(kingdomID)
	local index = kingdomPointDefine.getIndexByKid(kingdomID)
	local kingdomPoint = kingdomPointDefine.getPointByIndex(regionType, index)
	kingdomPoint = kingdomPoint or cc.p(10000, 10000)
	return kingdomPoint
end
function kingdomPointDefine.getPointByIndex(regionType, index)
	if regionType == NEBULA_REGION_TYPE.HEGEMONY_REGION then
		return kingdomPointDefine.index2point2[index]
	else
		return kingdomPointDefine.index2point1[index]
	end
end
function kingdomPointDefine.getIndexByPoint(regionType, point)
	local key = point.x .. "_" .. point.y
	if regionType == NEBULA_REGION_TYPE.HEGEMONY_REGION then
		return kingdomPointDefine.point2index2[key]
	else
		return kingdomPointDefine.point2index1[key]
	end
end
function kingdomPointDefine.getIndexByKid(kid, regionId)
	if worldMapDefine.isLegendLordKingdomID(kid) then
		return kid
	end
	if not regionId then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		local __, rId = nebulaActivityCtrl:getKingdomRegionType(kid)
		regionId = rId
	end
	if kingdomPointDefine.kid2index == nil or kingdomPointDefine.kid2index[regionId] == nil then
		return 1
	end
	return kingdomPointDefine.kid2index[regionId][kid]
end
function kingdomPointDefine.getKidByIndex(index, regionId)
	return kingdomPointDefine.index2kid[regionId][index] or 0
end
function kingdomPointDefine.getKingdomIDWithPoint(point, regionId)
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local regionType = nebulaActivityCtrl:getRegionTypeByRegionId(regionId)
	local index = kingdomPointDefine.getIndexByPoint(regionType, point)
	return kingdomPointDefine.getKidByIndex(index, regionId)
end
function kingdomPointDefine.getDir(index1, index2, regionType)
	local dir = 0
	local pos1 = kingdomPointDefine.getPointByIndex(regionType, index1)
	local pos2 = kingdomPointDefine.getPointByIndex(regionType, index2)
	if pos1 and pos2 then
		if pos1.y == pos2.y then
			dir = 1
		end
		if pos1.x == pos2.x then
			dir = 3
		end
	end
	return dir
end
function kingdomPointDefine.getNeighbourKingdoms(kingdomID)
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local regionType, regionId = nebulaActivityCtrl:getKingdomRegionType(kingdomID)
	local index = kingdomPointDefine.getIndexByKid(kingdomID)
	local upIndex, downIndex, leftIndex, rightIndex = kingdomPointDefine.getNeighbourKingdomsIndex(regionType, index)
	local upID = kingdomPointDefine.getKidByIndex(upIndex, regionId)
	local downID = kingdomPointDefine.getKidByIndex(downIndex, regionId)
	local leftID = kingdomPointDefine.getKidByIndex(leftIndex, regionId)
	local rightID = kingdomPointDefine.getKidByIndex(rightIndex, regionId)
	return upID, downID, leftID, rightID
end
function kingdomPointDefine.getNeighbourKingdomsIndex(regionType, index)
	local kingdomPoint = kingdomPointDefine.getPointByIndex(regionType, index)
	return kingdomPointDefine.getNeighbourIndexByPoint(regionType, kingdomPoint)
end
function kingdomPointDefine.getNeighbourIndexByPoint(regionType, kingdomPoint)
	local neighbourUp = cc.p(kingdomPoint.x, kingdomPoint.y + 1)
	local neighbourDown = cc.p(kingdomPoint.x, kingdomPoint.y - 1)
	local neighbourLeft = cc.p(kingdomPoint.x - 1, kingdomPoint.y)
	local neighbourRight = cc.p(kingdomPoint.x + 1, kingdomPoint.y)
	local upIndex = kingdomPointDefine.getIndexByPoint(regionType, neighbourUp)
	local downIndex = kingdomPointDefine.getIndexByPoint(regionType, neighbourDown)
	local leftIndex = kingdomPointDefine.getIndexByPoint(regionType, neighbourLeft)
	local rightIndex = kingdomPointDefine.getIndexByPoint(regionType, neighbourRight)
	print("==upIndex, downIndex, leftIndex, rightIndex==", upIndex, downIndex, leftIndex, rightIndex)
	return upIndex, downIndex, leftIndex, rightIndex
end
function kingdomPointDefine.getNeighbourKingdomsByPoint(kingdomPoint, regionId)
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local regionType = nebulaActivityCtrl:getRegionTypeByRegionId(regionId)
	local upIndex, downIndex, leftIndex, rightIndex = kingdomPointDefine.getNeighbourIndexByPoint(regionType, kingdomPoint)
	local upID = kingdomPointDefine.getKidByIndex(upIndex, regionId)
	local downID = kingdomPointDefine.getKidByIndex(downIndex, regionId)
	local leftID = kingdomPointDefine.getKidByIndex(leftIndex, regionId)
	local rightID = kingdomPointDefine.getKidByIndex(rightIndex, regionId)
	return upID, downID, leftID, rightID
end
function kingdomPointDefine.initHegemonyRegionMap(...)
	kingdomPointDefine.index2kid, _ENV = nil, nil
	kingdomPointDefine.kid2index, _ENV = nil, nil
	local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
	local nebulaWarRead = include("nebulaWarRead")
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local hegemonyRegion = nebulaActivityCtrl:getHegemonyRegionData()
	for regionId, region in ipairs(hegemonyRegion) do
		local _ENV, index2kid
		local _ENV, kid2index
		local step = 24
		if nebulaWarRead.checkCampType1(regionId) then
			step = 12
		end
		for groupId, group in ipairs(region) do
			for i, kid in ipairs(group) do
				local index = (groupId - 1) * step + i
				index2kid[index] = kingdomCtrl:getIsKingdomMerged(kid) and 0 or kid
				kid2index[kid] = index
			end
		end
		kingdomPointDefine.index2kid[regionId] = index2kid
		kingdomPointDefine.kid2index[regionId] = kid2index
	end
	local _ENV, index2kid = (for generator), ipairs(hegemonyRegion)
	local _ENV, kid2index = ipairs(hegemonyRegion)
	local prepareForWarRegion = nebulaActivityCtrl:getPrepareForWarRegionData()
	local index = 1
	for _, kid in ipairs(prepareForWarRegion) do
		index2kid[index] = kingdomCtrl:getIsKingdomMerged(kid) and 0 or kid
		kid2index[kid] = index
		index = index + 1
	end
	local toBePrepareForWarRegion = nebulaActivityCtrl:getToBePrepareForWarRegionData()
	for _, kid in ipairs(toBePrepareForWarRegion) do
		index2kid[index] = kingdomCtrl:getIsKingdomMerged(kid) and 0 or kid
		kid2index[kid] = index
		index = index + 1
	end
	kingdomPointDefine.index2kid[101] = index2kid
	kingdomPointDefine.kid2index[101] = kid2index
	local _ENV, index2kid = kingdomPointDefine.kid2index, kingdomPointDefine.kid2index
	local _ENV, kid2index = ipairs(toBePrepareForWarRegion)
	local index = 1
	local kingdomlist = kingdomCtrl:getBaseKingdomList()
	for i, v in ipairs(kingdomlist) do
		local kid = v.kid
		if kid >= GAME_KINGDOM_ID_ASSIGN.GAME.START and kid <= GAME_KINGDOM_ID_ASSIGN.GAME.END then
			local regionType = nebulaActivityCtrl:getKingdomRegionType(kid)
			if regionType == NEBULA_REGION_TYPE.SEPARATIST_REGIME then
				index2kid[index] = v.ismerged and 0 or kid
				kid2index[kid] = index
				index = index + 1
			end
		end
	end
	kingdomPointDefine.index2kid[102] = index2kid
	kingdomPointDefine.kid2index[102] = kid2index
end
kingdomPointDefine.init()
return kingdomPointDefine
