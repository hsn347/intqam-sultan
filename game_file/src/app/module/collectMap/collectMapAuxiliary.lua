local collectMapAuxiliary = class("collectMapAuxiliary")
function collectMapAuxiliary:ctor()
end
function collectMapAuxiliary:validateData(data)
	local err = gErrDef.Err_None
	if data and next(data) ~= nil then
		local name = data.name
		if string.utf8len(name) == 0 then
			err = gErrDef.Err_COLLECT_MAP_NAME_EMPTY
		elseif string.utf8len(name) > (data.maxLength or MAP_COLLECTNAME_MAX) then
			err = gErrDef.Err_COLLECT_MAP_NAME_MAX_SIZE
		end
	else
		err = gErrDef.Err_COLLECT_MAP_DATA_EMPTY
	end
	return err
end
function collectMapAuxiliary:isCollect(collectMapData, kid, x, y)
	local flag = false
	if collectMapData and next(collectMapData) ~= nil then
		for _, var in pairs(collectMapData) do
			local position = var.position
			if position[1] == x and position[2] == y and tonumber(kid) == tonumber(var.mapID) then
				flag = true
			end
		end
	end
	return flag
end
function collectMapAuxiliary:isAllianceMark(allianceMarkData, kid, x, y)
	local flag = false
	if allianceMarkData and next(allianceMarkData) ~= nil then
		for _, var in pairs(allianceMarkData) do
			local position = var.position
			if position[1] == x and position[2] == y and tonumber(kid) == tonumber(var.mapID) then
				flag = var.markType
			end
		end
	end
	return flag
end
return collectMapAuxiliary
