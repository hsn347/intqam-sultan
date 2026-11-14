local alliancePermissionltCtrl = include("alliancePermissionltCtrl")
local _ENV, permissionConfigS = "alliancePermissionltCtrl", "alliancePermissionltCtrl"
function permissionConfigS:ctor(aid)
	_UPVALUE0_ = nil
	self.property, (nil).aid = nil, aid
	self:initializeConfig()
end
function permissionConfigS:destroy()
	self.property.config, _UPVALUE0_ = nil, nil
end
function permissionConfigS:setPermissionValid(permission, rank)
	return self:setPermissionStatus(permission, rank, gStatus.YES)
end
function permissionConfigS:setPermissionInvalid(permission, rank)
	return self:setPermissionStatus(permission, rank, gStatus.NO)
end
function permissionConfigS:hasPermission(permission, rank, objectRank)
	local status = self:getPermissionStatus(permission, rank)
	if gStatus.NONE == status then
		return alliancePermissionltCtrl:hasPermission(permission, rank, objectRank)
	elseif gStatus.YES == status then
		return true
	elseif gStatus.NO == status then
		return false
	end
	return false
end
function permissionConfigS:getPermissionShowList()
	local showltlist = alliancePermissionltCtrl:getShowList()
	local alliancePermissionltCtrl, ret = alliancePermissionltCtrl, alliancePermissionltCtrl
	for i, v in ipairs(showltlist) do
		local alliancePermissionltCtrl, element
		local permission = v.key
		element.data, alliancePermissionltCtrl, element.key = nil, nil, permission
		for rank, setStatus in pairs(v.data) do
			local status = self:getPermissionStatus(permission, rank)
			if gStatus.NONE == status or gStatus.YES == status then
				status = true
			else
				status = false
			end
			alliancePermissionltCtrl = permission
			permission.set = setStatus
			element.data[rank], permission.status = permission, status
		end
		table.insert(ret, element)
	end
	return ret
end
function permissionConfigS:setPermissionStatus(permission, rank, status)
	local defaultStatus = alliancePermissionltCtrl:getDefaultPermisionStatus(permission, rank)
	if defaultStatus == status then
		local ret = self:removePermissionStatus(permission, rank)
		if ret then
			return gErrDef.Err_None
		else
			return gErrDef.Err_ALLIANCE_REPEAT_TO_MODIFY_PERMISSION
		end
	else
		local ret = self:addPermissionStatus(permission, rank, status)
		if ret then
			return gErrDef.Err_None
		else
			return gErrDef.Err_ALLIANCE_REPEAT_TO_MODIFY_PERMISSION
		end
	end
end
function permissionConfigS:addPermissionStatus(permission, rank, status)
	local config = self.property.config[tostring(permission)]
	if config and config[tostring(rank)] then
		return false
	end
	if not self.property.config[tostring(permission)] then
		_ENV = self.property.config[tostring(permission)]
	end
	self.property.config[tostring(permission)] = self.property.config[tostring(permission)]
	self.property.config[tostring(permission)][tostring(rank)] = status
	return true
end
function permissionConfigS:removePermissionStatus(permission, rank)
	local config = self.property.config[tostring(permission)]
	if not config or not config[tostring(rank)] then
		return false
	end
	self.property.config[tostring(permission)][tostring(rank)] = nil
	if not next(self.property.config[tostring(permission)]) then
		self.property.config[tostring(permission)] = nil
	end
	return true
end
function permissionConfigS:getPermissionStatus(permission, rank)
	local config = self.property.config[tostring(permission)]
	if not config or not config[tostring(rank)] then
		return gStatus.NONE
	end
	return config[tostring(rank)]
end
function permissionConfigS:getAID()
	return self.property.aid
end
function permissionConfigS:initializeConfig(config)
