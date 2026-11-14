local devilValleyltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	local createData = function(name)
		devilValleyltCtrl.posRefWarBuilding, devilValleyltCtrl, devilValleyltCtrl.devilValleyWarBuilding, devilValleyltCtrl = nil, nil, nil, nil
		local devilValleyWarBuilding = require_once("app." .. _G.LocalTblPath .. ".config_server.devilvalley_map_config")
		for id, v in pairs(devilValleyWarBuilding) do
			local build = clone(v)
			build.x = build.x - gPointClientPointPlus
			build.y = build.y - gPointClientPointPlus
			devilValleyltCtrl.devilValleyWarBuilding[id] = build
		end
		for id, v in pairs(devilValleyWarBuilding) do
			v.id = id
			v.objId = id
			local x, y = v.x - 1, v.y - 1
			v.x = v.x - 1
			v.y = v.y - 1
			if not devilValleyltCtrl.posRefWarBuilding[x] then
				devilValleyltCtrl.posRefWarBuilding[x], devilValleyltCtrl = nil, nil
			end
			devilValleyltCtrl.posRefWarBuilding[x][y] = v
		end
		if name == "posRefWarBuilding" then
			return devilValleyltCtrl.posRefWarBuilding
		elseif name == "devilValleyWarBuilding" then
			return devilValleyltCtrl.devilValleyWarBuilding
		end
	end
	devilValleyltCtrl:defineValue("posRefWarBuilding", createData)
	devilValleyltCtrl:defineValue("devilValleyWarBuilding", createData)
	devilValleyltCtrl:defineValue("devilValleyWarPlayer", function()
		devilValleyltCtrl.devilValleyWarPlayer, devilValleyltCtrl = nil, nil
		local devilValleyWarPlayer = require_once("app." .. _G.LocalTblPath .. ".config_server.devilvalley_map_player")
		for id, v in pairs(devilValleyWarPlayer) do
			local build = clone(v)
			build.x = build.x - gPointClientPointPlus
			build.y = build.y - gPointClientPointPlus
			devilValleyltCtrl.devilValleyWarPlayer[id] = build
		end
		return devilValleyltCtrl.devilValleyWarPlayer
	end)
end
init()
function devilValleyltCtrl.getWarBuilding()
	return devilValleyltCtrl.devilValleyWarBuilding
end
function devilValleyltCtrl.getWarPlayer()
	return devilValleyltCtrl.devilValleyWarPlayer
end
function devilValleyltCtrl.getWarBuildingById(id)
	return devilValleyltCtrl.devilValleyWarBuilding[id]
end
function devilValleyltCtrl.getWarBuildingByPos(x, y)
	if devilValleyltCtrl.posRefWarBuilding[x] then
		return devilValleyltCtrl.posRefWarBuilding[x][y]
	end
end
return devilValleyltCtrl
