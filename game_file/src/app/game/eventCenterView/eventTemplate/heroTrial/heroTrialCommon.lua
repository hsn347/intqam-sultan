local htBattleMgr = include("htBattleMgr")
local _ENV, heroTrialCommon = "htBattleMgr", "htBattleMgr"
function heroTrialCommon.convertLevelToNum(levelId)
	return (tonumber(string.sub(levelId, 1, 3)) - 401) * 10 + tonumber(string.sub(levelId, -2))
end
function heroTrialCommon.isTrialStarted(mapId)
	if htBattleMgr.trialStatus and htBattleMgr.curTrialMap and htBattleMgr.curTrialMap:getMapID() == mapId then
		return true
	end
	return false
end
function heroTrialCommon:getLastMapId()
	local config = require("app." .. LocalTblPath .. ".config_server.hero_trial_stage_config")
	return config[#config].map
end
function heroTrialCommon.isSameDay(time1, time2)
	local date1 = os.date("*t", time1)
	local date2 = os.date("*t", time2)
	_UPVALUE3_ = "*t"
	;("*t")[1] = "day"
	;("*t")[2] = "month"
	local ("*t")[3], keys = "year", "*t"
	local isSame = true
	for i, key in ipairs(keys) do
		if date1[key] ~= date2[key] then
			isSame = false
			break
		end
	end
	return isSame
end
function heroTrialCommon.nodeToTileCoord(map, pos)
	local halfMapWidth = map:getMapSize().width * 0.5
	local halfMapHeight = map:getMapSize().height * 0.5
	local mapWidth = map:getMapSize().width
	local mapHeight = map:getMapSize().height
	local tileWidth = map:getTileSize().width
	local tileHeight = map:getTileSize().height
	local tilePosDiv = cc.p(pos.x / tileWidth, pos.y / tileHeight)
	local inverseTileX = mapWidth - tilePosDiv.x
	local inverseTileY = mapHeight - tilePosDiv.y
	local posX = math.floor(inverseTileY + tilePosDiv.x - halfMapWidth)
	local posY = math.floor(inverseTileY - tilePosDiv.x + halfMapWidth)
	local ret = cc.p(posX, posY)
	if posX < 0 or posX > mapWidth - 1 or posY < 0 or posY > mapHeight - 1 then
		ret = cc.p(-1, -1)
		return ret
	end
	return ret
end
return heroTrialCommon
