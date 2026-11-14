local _ENV, _ENV, updateModuleDef
;(nil).DownloadProgress = 0
;(nil).DownloadSuccess = 1
;(nil).DownloadError = 2
;(nil).UnzipProgress = 3
;(nil).UnzipSuccess = 4
;(nil).UnzipError = 5
;(nil).DownloadAbort = 6
;(nil).NotUpdate = 100
;(nil).GetVersionError = 101
_ENV, updateModuleDef.updateModuleEvent, (nil).GetVersionServerError = nil, nil, 102
;(nil).ordinary = 0
;(nil).insufficientMemory = 1
_ENV, updateModuleDef.unzipErrorType, (nil).dspacth = nil, nil, 2
;(nil).noTask = 0
;(nil).tasking = 1
updateModuleDef.disconnectedCheckVersionStatus, (nil).failed = nil, 2
updateModuleDef.isNeedLua = true
updateModuleDef.preDownload_DataKey = "predata"
updateModuleDef.preDownload_RetryTime_Version = 10
updateModuleDef.preDownload_RetryTime_Down = 10
updateModuleDef.preDownload_ResumeDownload = true
updateModuleDef.preDownload_SpeedLimit = 1024
function updateModuleDef.getVersion(needBaseVersion, preDownloadVersion)
	if ng_sys_getVersion then
		return _G.ng_sys_getVersion(needBaseVersion, preDownloadVersion)
	end
	return ""
end
function updateModuleDef.log(msg, ...)
	print("updateModule ", msg)
	_ENV = print
	print[1] = ...
	print[2] = ...
	print[3] = ...
	print[4] = ...
	print[5] = ...
	local print[6], argsTable = ...
	dump(argsTable, "updateModule", 10)
	_G.sendTraceBackLog(msg, nil, table.concat(argsTable, ", "))
end
local formatHandler = function(urlAddr)
	local language = SoraDGetDefaultLanguage()
	local v = _G.ng_sys_getVersion and _G.ng_sys_getVersion() or ""
	local ov = v
	local target = userSDKManager.getTargetProject() .. "_unity"
	local url = string.format(urlAddr, device.platform, v, ov, target, language)
	print(url, "url")
	return url
end
local getDownType = function(isWhite)
	if userSDKManager.isBeta() then
		if isWhite then
			return "updateWhite_TEST"
		else
			return "updatePackage_TEST"
		end
	elseif isWhite then
		return "updateWhite"
	else
		return "updatePackage"
	end
	return "updatePackage_TEST"
end
local format_version = function(version)
	return version:gsub("^(%d+)%.(%d+)%.(%d+)$", function(major, minor, patch)
		return string.format("%s.%s", major, minor)
	end)
end
local formatHandlerDown = function(urlAddr, isWhite)
	local v = _G.ng_sys_getVersion and _G.ng_sys_getVersion() or ""
	local dt = getDownType(isWhite)
	local fv = format_version(v)
	local url = string.format(urlAddr, dt, device.platform, fv)
	print(url, "url")
	return url
end
updateModuleDef.formatHandler = formatHandler
updateModuleDef.formatHandlerDown = formatHandlerDown
local checkUpdateByMD5 = function(downData)
	if downData and next(downData) then
		if _G.ng_sys_checkbymd5 then
			local downMd5 = downData.md5
			if downMd5 and string.len(downMd5) > 0 then
				return _G.ng_sys_checkbymd5(downMd5)
			end
		end
		return true
	end
	return false
end
updateModuleDef.checkUpdateByMD5 = checkUpdateByMD5
local getFileNameByUrl = function(urlAddr)
	local fileName = string.match(urlAddr, "([^/]+)$")
	if fileName and string.len(fileName) > 0 then
		return fileName
	end
	return "updateFile.zip"
end
updateModuleDef.getFileNameByUrl = getFileNameByUrl
return updateModuleDef
