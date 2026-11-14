local _ENV, worldMapUtil
local PAGE_SIZE = 5
local SHOW_PAGE = 1
local X_OFFSET_BIT = 10000
local toPage = function(num)
	return math.floor(num / PAGE_SIZE)
end
local toPos = function(page)
	return page * PAGE_SIZE
end
local adjustNum = function(num, max)
	if num < 0 then
		num = 0
	elseif max <= num then
		num = max - 1
	end
	return num
end
local getPageID = function(x, y)
	local pageID = x * X_OFFSET_BIT + y
	return pageID
end
function worldMapUtil.getPagePos(pos)
	local x = toPage(pos.x)
	local y = toPage(pos.y)
	return cc.p(x, y)
end
function worldMapUtil.getPageID(pos)
	return getPageID(pos.x, pos.y)
end
function worldMapUtil.getPageIDByPos(pos)
	local page = worldMapUtil.getPagePos(pos)
	return worldMapUtil.getPageID(page)
end
function worldMapUtil.getPosByPage(page, mapSize)
	local xpage = math.floor(page / X_OFFSET_BIT)
	local ypage = math.floor(page % X_OFFSET_BIT)
	local x = xpage * PAGE_SIZE
	local y = ypage * PAGE_SIZE
	local minX = adjustNum(x, mapSize.width)
	local maxX = adjustNum(x + PAGE_SIZE - 1, mapSize.width)
	local minY = adjustNum(y, mapSize.height)
	local maxY = adjustNum(y + PAGE_SIZE - 1, mapSize.height)
	return minX, maxX, minY, maxY
end
function worldMapUtil.getShowPageByRect(minX, maxX, minY, maxY)
	local toPage, pages
	if minX < maxX and minY < maxY then
		local minPageX = toPage(minX)
		local maxPageX = toPage(maxX)
		local minPageY = toPage(minY)
		local maxPageY = toPage(maxY)
		local lenX = maxPageX - minPageX
		local lenY = maxPageY - minPageY
		for i = 0, lenX do
			for j = 0, lenY do
				local pageID = getPageID(minPageX + i, minPageY + j)
				pages[pageID] = true
			end
		end
	end
	return pages
end
function worldMapUtil.getShowPage(pos, mapSize)
	local minX = toPos(toPage(pos.x) - SHOW_PAGE)
	local maxX = toPos(toPage(pos.x) + SHOW_PAGE)
	local minY = toPos(toPage(pos.y) - SHOW_PAGE)
	local maxY = toPos(toPage(pos.y) + SHOW_PAGE)
	minX = adjustNum(minX, mapSize.width)
	maxX = adjustNum(maxX, mapSize.width)
	minY = adjustNum(minY, mapSize.height)
	maxY = adjustNum(maxY, mapSize.height)
	worldMapUtil.getShowPageByRect(minX, maxX, minY, maxY)
end
local getDelayTimeByFight = function(fightTime)
	if fightTime and 0 < fightTime then
		local sysTime = serviceFunctions.systemTime()
		local delay_time = fightTime + 9 - sysTime
		if 8 < delay_time then
			return 8
		elseif 0 < delay_time and delay_time <= 8 then
			return delay_time
		end
	end
	return 0
end
worldMapUtil.getDelayTimeByFight = getDelayTimeByFight
function worldMapUtil.getDelayTime(obj)
	if obj and obj.fightTime and obj.fightTime > 0 then
		return getDelayTimeByFight(obj.fightTime)
	end
	return 0
end
local instanceFactory = include("instanceFactory")
function worldMapUtil.getDelayTimeInstance(obj)
	local isDelayTime
	if obj and obj.type then
		isDelayTime = instanceFactory.isInstanceDelayTime(obj.type)
	end
	if isDelayTime then
		return worldMapUtil.getDelayTime(obj)
	end
	return 0
end
function worldMapUtil.getWarStatusTime(data)
	local warStatusTime = data.warStatusEndTime - serviceFunctions.systemTime()
	if data.warStatus == gKingdomWarStatusType.inWar and data.currOccupyBeginTime then
		local currOccupySecs = serviceFunctions.systemTime() - data.currOccupyBeginTime
		local totalOccupySecs = (data.histOccupyTotalSecs or 0) + currOccupySecs
		warStatusTime = math.min(data.winTime - currOccupySecs, data.totalWinTime - totalOccupySecs, warStatusTime)
	end
	return warStatusTime
end
local enableWorldMapLod
function worldMapUtil.isLodOpen()
	if enableWorldMapLod == nil then
		local show3dKey = "Game:GameOptionsView:showlod~bool"
		enableWorldMapLod = nil
		;(nil).byUID = true
	end
	return enableWorldMapLod
end
function worldMapUtil.setLodOpen(open)
	open = {}
	enableWorldMapLod = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_TOGGLE_LOD"
	SoraDSendMessage(nil)
end
local enableTroopPriority
function worldMapUtil.isTroopPriority()
	if enableTroopPriority == nil then
		local show3dKey = "Game:GameOptionsView:prioritySwitch~bool"
	end
	return enableTroopPriority
end
function worldMapUtil.setTroopPriority(open)
	open = {}
	enableTroopPriority = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_TOGGLE_TROOP_PRIORITY"
	SoraDSendMessage(nil)
end
function worldMapUtil.resetConfig()
end
function worldMapUtil.linkConfig(config)
	for i, v in ipairs(config) do
		if 1 < i then
			v.preLod = config[i - 1]
		end
		if i < #config then
			v.nextLod = config[i + 1]
		end
	end
end
_ENV, _ENV, worldMapUtil.getLodByScale = nil, function(scale, config)
	local curLodConfig = config
	while curLodConfig do
		if scale <= curLodConfig.scale then
			local nextLod = curLodConfig.nextLod
			if not nextLod or scale > nextLod.scale then
				break
			end
			curLodConfig = nextLod
		else
			if not curLodConfig.preLod then
				break
			end
			curLodConfig = curLodConfig.preLod
		end
	end
	return curLodConfig
end, function(scale, config)
	local curLodConfig = config
	while curLodConfig do
		if scale <= curLodConfig.scale then
			local nextLod = curLodConfig.nextLod
			if not nextLod or scale > nextLod.scale then
				break
			end
			curLodConfig = nextLod
		else
			if not curLodConfig.preLod then
				break
			end
			curLodConfig = curLodConfig.preLod
		end
	end
	return curLodConfig
end
_ENV, (function(scale, config)
	local curLodConfig = config
	while curLodConfig do
		if scale <= curLodConfig.scale then
			local nextLod = curLodConfig.nextLod
			if not nextLod or scale > nextLod.scale then
				break
			end
			curLodConfig = nextLod
		else
			if not curLodConfig.preLod then
				break
			end
			curLodConfig = curLodConfig.preLod
		end
	end
	return curLodConfig
end)[8], (nil).offsetx = nil, nil, -140
_ENV, (function(scale, config)
	local curLodConfig = config
	while curLodConfig do
		if scale <= curLodConfig.scale then
			local nextLod = curLodConfig.nextLod
			if not nextLod or scale > nextLod.scale then
				break
			end
			curLodConfig = nextLod
		else
			if not curLodConfig.preLod then
				break
			end
			curLodConfig = curLodConfig.preLod
		end
	end
	return curLodConfig
end)[9], (nil).offsetx = nil, nil, -140
_ENV, (function(scale, config)
	local curLodConfig = config
	while curLodConfig do
		if scale <= curLodConfig.scale then
			local nextLod = curLodConfig.nextLod
			if not nextLod or scale > nextLod.scale then
				break
			end
			curLodConfig = nextLod
		else
			if not curLodConfig.preLod then
				break
			end
			curLodConfig = curLodConfig.preLod
		end
	end
	return curLodConfig
end)[10], (nil).offsetx = nil, nil, -140
_ENV, (function(scale, config)
	local curLodConfig = config
	while curLodConfig do
		if scale <= curLodConfig.scale then
			local nextLod = curLodConfig.nextLod
			if not nextLod or scale > nextLod.scale then
				break
			end
			curLodConfig = nextLod
		else
			if not curLodConfig.preLod then
				break
			end
			curLodConfig = curLodConfig.preLod
		end
	end
	return curLodConfig
end)[11], (nil).offsetx = nil, nil, -140
_ENV, (function(scale, config)
	local curLodConfig = config
	while curLodConfig do
		if scale <= curLodConfig.scale then
			local nextLod = curLodConfig.nextLod
			if not nextLod or scale > nextLod.scale then
				break
			end
			curLodConfig = nextLod
		else
			if not curLodConfig.preLod then
				break
			end
			curLodConfig = curLodConfig.preLod
		end
	end
	return curLodConfig
end)[12], (nil).offsetx = nil, nil, -140
;(function(scale, config)
	local curLodConfig = config
	while curLodConfig do
		if scale <= curLodConfig.scale then
			local nextLod = curLodConfig.nextLod
			if not nextLod or scale > nextLod.scale then
				break
			end
			curLodConfig = nextLod
		else
			if not curLodConfig.preLod then
				break
			end
			curLodConfig = curLodConfig.preLod
		end
	end
	return curLodConfig
end)[13], (nil).offsetx = nil, -70
local function castleModelCfg(scale, config)
	local curLodConfig = config
	while curLodConfig do
		if scale <= curLodConfig.scale then
			local nextLod = curLodConfig.nextLod
			if not nextLod or scale > nextLod.scale then
				break
			end
			curLodConfig = nextLod
		else
			if not curLodConfig.preLod then
				break
			end
			curLodConfig = curLodConfig.preLod
		end
	end
	return curLodConfig
end
worldMapUtil.castleModelCfg = castleModelCfg
local getTileMapTmxForPlatform = function(tmxName)
	return tmxName .. ".tmx"
end
worldMapUtil.getTileMapTmxForPlatform = getTileMapTmxForPlatform
return worldMapUtil
