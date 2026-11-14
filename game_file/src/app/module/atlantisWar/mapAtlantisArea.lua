local mathBit = include("mathBit")
local _ENV, mapAtlantisArea = "mathBit", "mathBit"
local max_x = 400
local max_y = 400
local _ENV, map_cache
function mapAtlantisArea.cleanCache()
	map_cache = nil
end
function mapAtlantisArea.initWithArea(areaArray)
	local filePath = ""
	local atlantisWarUtil = include("atlantisWarUtil")
	if atlantisWarUtil.isNewMap() then
		filePath = "app/module/atlantisWarKOH"
	else
		filePath = "app/module/atlantisWar"
	end
	for i, area in ipairs(areaArray) do
		local file_data = map_cache[area]
		if not file_data then
			print("==create area map==", area)
			local fullName = string.format(filePath .. "/atlantiswar_area_%d.bytes", area)
			map_cache[area] = CS.LuaManager.LoadLuaFile(fullName) or ""
		end
	end
end
function mapAtlantisArea.checkInArea(posx, posy, selfArea)
	if not selfArea then
		return false
	end
	posx = posx + 1
	posy = posy + 1
	if posx <= 0 or posx > max_x or posy <= 0 or posy > max_y then
		return false
	end
	local file_data = map_cache[selfArea]
	if not file_data then
		max_y = nil
		;(nil)[1] = selfArea
		mapAtlantisArea.initWithArea(nil)
		file_data = map_cache[selfArea]
	end
	local index = posx + (posy - 1) * max_x
	local p_1 = math.ceil(index / 8)
	local p_2 = (index - 1) % 8 + 1
	local byte_str = string.byte(file_data, p_1)
	if not byte_str then
		return false
	end
	local area = mathBit.andOp(mathBit.rShiftOp(byte_str, 8 - p_2), 1)
	local isIn = area == 1
	return isIn
end
function mapAtlantisArea.isTouchTerrain(point)
	return mapAtlantisArea.checkInArea(point.x, point.y, ATLANTIS_WAR_AREA.WALL)
end
function mapAtlantisArea.getArea(posx, posy)
	posx = posx + 1
	posy = posy + 1
	if posx <= 0 or posx > max_x or posy <= 0 or posy > max_y then
		return false
	end
	local selfArea = "all"
	local file_data = map_cache[selfArea]
	if not file_data then
		local filePath = ""
		local atlantisWarUtil = include("atlantisWarUtil")
		if atlantisWarUtil.isNewMap() then
			filePath = "app/module/atlantisWarKOH"
		else
			filePath = "app/module/atlantisWar"
		end
		local fullName = string.format(filePath .. "/atlantiswar_area_all.bytes")
		map_cache[selfArea] = CS.LuaManager.LoadLuaFile(fullName) or ""
		file_data = map_cache[selfArea]
	end
	local index = posx + (posy - 1) * max_x
	local p_1 = math.ceil(index / 2)
	local p_2 = (index - 1) % 2 + 1
	local byte_str = string.byte(file_data, p_1)
	print("==byte_str, p_1, p_2==", byte_str, p_1, p_2)
	local area_1 = mathBit.rShiftOp(byte_str, 4)
	local area_2 = byte_str - mathBit.lShiftOp(area_1, 4)
	print("==area_1, area_2==", area_1, area_2)
	local result = p_2 == 1 and area_1 or area_2
	print(string.format("(%d, %d) 在区域 %d", posx, posy, result))
	return result
end
return mapAtlantisArea
