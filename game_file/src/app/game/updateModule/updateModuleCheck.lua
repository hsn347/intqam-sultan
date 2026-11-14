local updateModuleCheck = class("updateModuleCheck")
function updateModuleCheck:ctor()
end
function updateModuleCheck:setCheckOk()
	self.checkVersionOk = true
end
function updateModuleCheck:setCheckAbandon()
	self.isCheckAbandon = true
end
function updateModuleCheck:resetData()
	self.checkVersionOk = false
	self.isCheckAbandon = false
	self.checkfailureCount = 0
end
function updateModuleCheck:checkVersion(addrs, callBackHandler, formatHandler, errorHandler)
