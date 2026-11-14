local updateModuleDowner = class("updateModuleDowner")
local updateModuleDef = requireLocal(".updateModuleDef")
function updateModuleDowner:ctor()
	self.downUrl = nil
	self.downVersion = nil
	self.downSize = nil
	self.downMd5 = nil
	self.backDownUrl = nil
	self._isPreDownload = false
	self._isResumeDownload = false
end
function updateModuleDowner:setIsPreDownload(isPreDownload)
	self._isPreDownload = isPreDownload
end
function updateModuleDowner:setIsResumeDownload(resumeDownload)
	self._isResumeDownload = resumeDownload
end
function updateModuleDowner:setUpdateInfo(data, version, info)
	local wl = info.wl or false
	self.downUrl = data.url or updateModuleDef.formatHandlerDown(gSvrConfig.updateDownAddr.url, wl)
	self.downSize = tonumber(data.size) or 0
	self.downMd5 = data.md5
	self.backDownUrl = data.burl or updateModuleDef.formatHandlerDown(gSvrConfig.updateDownAddr.url, wl)
	self.downVersion = version
end
function updateModuleDowner:startDowner(data, version, info)
	self:setUpdateInfo(data, version, info)
	self:downFile()
end
function updateModuleDowner:getEventHandlerName()
end
function updateModuleDowner:isCanDown()
	if self.downUrl and self.downMd5 and self.backDownUrl then
		return true
	end
	return false
end
function updateModuleDowner:abortDownFile()
	if _G.ng_sys_abort then
		_G.ng_sys_abort(self._isPreDownload)
	end
end
function updateModuleDowner:checkIsFileDownload(isBackDown)
	if self:isCanDown() and _G.ng_checkFileSuccess then
		local downUrl = self.downUrl
		if isBackDown and not userSDKManager.isBeta() then
			downUrl = self.backDownUrl
		end
		local fileName = updateModuleDef.getFileNameByUrl(downUrl)
		return _G.ng_checkFileSuccess(fileName, self.downMd5, self.downSize, self._isPreDownload)
	end
	return false
end
function updateModuleDowner:getFileDownloadSize(isBackDown)
	if self:isCanDown() and _G.ng_getFileSize then
		local downUrl = self.downUrl
		if isBackDown and not userSDKManager.isBeta() then
			downUrl = self.backDownUrl
		end
		local fileName = updateModuleDef.getFileNameByUrl(downUrl)
		return _G.ng_getFileSize(fileName, self.downMd5, self._isPreDownload)
	end
	return 0
end
function updateModuleDowner:downFile(isBackDown, isResume)
	if self:isCanDown() then
		local handlerName = self:getEventHandlerName()
		assert(handlerName and _G[handlerName] and type(_G[handlerName]) == "function", "handler name is not function")
		local downUrl = self.downUrl
		if isBackDown and not userSDKManager.isBeta() then
			downUrl = self.backDownUrl
		end
		if _G.ng_sys_setSpeedLimit then
			local speedLimit = 0
			if self._isPreDownload then
				speedLimit = updateModuleDef.preDownload_SpeedLimit or 0
			end
			if 0 < speedLimit then
				_G.ng_sys_setSpeedLimit(speedLimit, self._isPreDownload)
			end
		end
		local isResumeDownload = self._isResumeDownload
		if nil ~= isResume then
			isResumeDownload = isResume
		end
		local fileName = updateModuleDef.getFileNameByUrl(downUrl)
		_G.ng_sys_OneFile(downUrl, self.downVersion, self.downSize, self.downMd5, handlerName, self._isPreDownload, fileName, isResumeDownload)
		return true
	end
	return false
end
return updateModuleDowner
