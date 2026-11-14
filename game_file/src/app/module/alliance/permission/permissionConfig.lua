local permissionConfigS = include("permissionConfigS")
local permissionConfig = class("permissionConfig")
_ENV = nil
;(nil).__index = permissionConfigS
setmetatable(permissionConfig, nil)
function permissionConfig:ctor(aid)
	permissionConfigS.ctor(self, aid)
end
function permissionConfig:destroy()
	permissionConfigS.destroy(self)
end
function permissionConfig:initializeConfig(config)
	permissionConfigS.initializeConfig(self, config)
end
function permissionConfig:setPermissionValid(permission, rank)
	return permissionConfigS.setPermissionValid(self, permission, rank)
end
function permissionConfig:setPermissionInvalid(permission, rank)
	return permissionConfigS.setPermissionInvalid(self, permission, rank)
end
function permissionConfig:hasPermission(permission, rank, objectRank)
	return permissionConfigS.hasPermission(self, permission, rank, objectRank)
end
function permissionConfig:getPermissionShowList()
	return permissionConfigS.getPermissionShowList(self)
end
return permissionConfig
