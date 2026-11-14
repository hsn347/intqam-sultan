local alliancePermissionltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	alliancePermissionltCtrl:setOrderAndShowConfig()
	alliancePermissionltCtrl:defineValue("config", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.alliance_juerisdiction")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.alliance_juerisdiction", "app." .. LocalTblPath .. ".config_server.alliance_juerisdiction"
		local _ENV, showList = LocalTblPath, LocalTblPath
		for _, v in pairs(config) do
			local permission = v.permission
			local rank = v.rank
			local objectList = v.object
			local setStatus = v.set
			local show = alliancePermissionltCtrl:getShowConfig(permission)
			local object
			if objectList and next(objectList) then
				local _ENV, newObject = next(objectList), next(objectList)
				for i, v in ipairs(objectList) do
					newObject[v] = gStatus.YES
				end
				objectList = newObject
				object = gStatus.YES
			else
				objectList = gStatus.YES
				object = gStatus.NO
			end
			if not ret[permission] then
				_ENV = ret[permission]
				ret[permission].object = object
				ret[permission].set, _ENV, ret[permission].rank, _ENV, ret[permission].show = gStatus, gStatus, gStatus, gStatus, show
			end
			ret[permission] = ret[permission]
			ret[permission].rank[rank] = objectList
			ret[permission].set[rank] = setStatus
		end
		return ret
	end)
end
function alliancePermissionltCtrl:isPermission(permission)
	if not permission then
		return false
	end
	local config = self:getAllConfig()
	if config and config[permission] then
		return true
	end
end
function alliancePermissionltCtrl:getDefaultPermisionStatus(permission, rank)
	local config = self:getPermissionRankConfig(permission, rank)
	if config then
		return gStatus.YES
	end
	return gStatus.NO
end
function alliancePermissionltCtrl:getPermissionRankConfig(permission, rank)
	return self:getRankConfig(permission, rank)
end
function alliancePermissionltCtrl:isPermissionModified(permission, rank)
	local config = self:getSetConfig(permission, rank)
	if gStatus.YES == config then
		return true
	end
	return false
end
function alliancePermissionltCtrl:isPermissionShow(permission)
	local config = self:getShowConfig(permission)
	if gStatus.YES == config then
		return true
	end
	return false
end
function alliancePermissionltCtrl:hasPermissionObject(permission)
	local config = self:getObjectConfig(permission)
	if gStatus.YES == config then
		return true
	end
	return false
end
function alliancePermissionltCtrl:hasPermission(permission, rank, objectRank)
	print("alliancePermissionltCtrl:hasPermission:", permission, rank, objectRank)
	local config = self:getRankConfig(permission, rank)
	print("config = ", config)
	if not config then
		return false
	end
	local hasObject = self:hasPermissionObject(permission)
	print("hasObject = ", hasObject)
	if not hasObject then
		print("last config = ", config)
		return true
	else
		if not objectRank then
			assert(not objectRank, "this permission don't config. permission = " .. tostring(permission))
		end
		config = config[objectRank]
		print("last config = ", config)
	end
	if gStatus.YES == config then
		return true
	end
	return false
end
function alliancePermissionltCtrl:getShowList()
	local _ENV, ret
	for _, permission in pairs(gAPermission) do
		local show = self:getShowConfig(permission)
		if gStatus.YES == show then
			local _ENV, data = gStatus.YES, gStatus.YES
			for _, rank in pairs(gAllianceRank) do
				local rankConfig = self:getRankConfig(permission, rank)
				if rankConfig then
					data[rank] = self:isPermissionModified(permission, rank)
				end
			end
			_ENV = pairs(gAllianceRank)
			pairs(gAllianceRank).data = data
			pairs(gAllianceRank).key = permission
			table.insert(ret, pairs(gAllianceRank))
		end
	end
	table.sort(ret, function(l, r)
		local lPermission = l.key
		local rPermission = r.key
		local lSort = self:getOrderConfig(lPermission)
		local rSort = self:getOrderConfig(rPermission)
		return lSort > rSort
	end)
	return ret
end
function alliancePermissionltCtrl:getAllConfig()
	return self.config
end
function alliancePermissionltCtrl:getConfig(permission, key)
	local config = self:getAllConfig()
	local config = config[permission]
	if not config then
		return
	end
	return config[key]
end
function alliancePermissionltCtrl:getRankConfig(permission, rank)
	local key = "rank"
	local config = self:getConfig(permission, key)
	if not config then
		return
	end
	return config[rank]
end
function alliancePermissionltCtrl:getSetConfig(permission, rank)
	local key = "set"
	local config = self:getConfig(permission, key)
	if not config then
		return
	end
	return config[rank]
end
function alliancePermissionltCtrl:getObjectConfig(permission)
	local key = "object"
	return self:getConfig(permission, key)
end
function alliancePermissionltCtrl:setOrderAndShowConfig()
	alliancePermissionltCtrl:defineValue("orderAndShowConfig", function()
		local config = require_once("app." .. LocalTblPath .. ".config_client.alliance_juerisdiction_data")
		local _ENV, orderAndShowConfig = "app." .. LocalTblPath .. ".config_client.alliance_juerisdiction_data", "app." .. LocalTblPath .. ".config_client.alliance_juerisdiction_data"
		for i, v in ipairs(config) do
			_ENV = nil
			;(nil).show = v.show
			orderAndShowConfig[v.permission], (nil).sort = nil, i
		end
		return orderAndShowConfig
	end)
end
function alliancePermissionltCtrl:getOrderAndShowConfig()
	return self.orderAndShowConfig
end
function alliancePermissionltCtrl:getShowConfig(permission)
	local orderAndShowConfig = self:getOrderAndShowConfig()
	if orderAndShowConfig and orderAndShowConfig[permission] then
		return orderAndShowConfig[permission].show
	end
end
function alliancePermissionltCtrl:getOrderConfig(permission)
	local orderAndShowConfig = self:getOrderAndShowConfig()
	if orderAndShowConfig and orderAndShowConfig[permission] then
		return orderAndShowConfig[permission].sort
	end
end
init()
return alliancePermissionltCtrl
