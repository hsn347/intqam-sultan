local WorldMapRemainsMap = include("aAReadClass").new()
local remainsMapData, remainsMapFlagData
local isInited = false
local init = function()
	if isInited then
		return
	end
	WorldMapRemainsMap = nil
	;(nil)[1] = "remainsMapData"
	WorldMapRemainsMap:defineValue("remainsMapData", nil)
	WorldMapRemainsMap = nil
	;(nil)[1] = "remainsMapFlagData"
	WorldMapRemainsMap:defineValue("remainsMapFlagData", nil)
end
function WorldMapRemainsMap.getDefauleMap(rectWidth, rectHeight)
	WorldMapRemainsMap.defaultPos, WorldMapRemainsMap = nil, nil
	local vertical = 12
	local horizontal = 6
	for index = 1, vertical do
		WorldMapRemainsMap.defaultPos[index], WorldMapRemainsMap = nil, nil
		for i = 1, horizontal do
			if index % 2 == 1 then
				WorldMapRemainsMap = nil
				;(nil).x = (i * 2 - 1) * rectWidth / 2
				;(nil).y = index * rectHeight / 2
				table.insert(WorldMapRemainsMap.defaultPos[index], nil)
			else
				WorldMapRemainsMap = nil
				;(nil).x = i * 2 * rectWidth / 2
				;(nil).y = index * rectHeight / 2
				table.insert(WorldMapRemainsMap.defaultPos[index], nil)
			end
		end
	end
	return WorldMapRemainsMap.defaultPos
end
function WorldMapRemainsMap.getMapData(index)
	return WorldMapRemainsMap.remainsMapData[index]
end
function WorldMapRemainsMap.getMapFlagData(mapID, index)
	return WorldMapRemainsMap.remainsMapFlagData[mapID][index]
end
init()
return WorldMapRemainsMap
