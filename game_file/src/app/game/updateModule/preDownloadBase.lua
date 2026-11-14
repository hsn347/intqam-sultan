local updateModuleDef = requireLocal(".updateModuleDef")
local updateModuleDowner = requireLocal(".updateModuleDowner")
local updateModuleEvent = updateModuleDef.updateModuleEvent
local unzipErrorType = updateModuleDef.unzipErrorType
local preDownloadBase = class("preDownloadBase", updateModuleDowner)
function preDownloadBase:ctor()
	preDownloadBase.super.ctor(self)
	self:setIsPreDownload(true)
	self:setIsResumeDownload(updateModuleDef.preDownload_ResumeDownload)
end
function preDownloadBase:downFile(isBackDown, isResume)
	if preDownloadBase.super.downFile(self, isBackDown, isResume) then
		print("preDownloadBase:downFile start suc")
		return true
	end
	return false
end
local updateModuleBaseName = "updateModuleHandlerBaseEvent"
function preDownloadBase:getEventHandlerName()
	_G[updateModuleBaseName] = function(eventType, subdata1, subdata2)
		self:updateModuleHandlerEvent(eventType, subdata1, subdata2)
	end
	return updateModuleBaseName
end
local preDownloadBaseLog = function(msg, ...)
	updateModuleDef.log("preDownloadBase " .. msg, ...)
end
function preDownloadBase:updateModuleHandlerEvent(eventType, subdata1, subdata2)
	if eventType == updateModuleEvent.DownloadError then
		preDownloadBaseLog("下载错误", subdata1, subdata2)
		local showMsg = i18n("common_text_1121")
		local errorTyp = "DownloadError"
		SoraDShowLoginFailBox(errorTyp, showMsg, true, function()
			self:downFile(true)
		end)
	elseif eventType == updateModuleEvent.UnzipError then
		preDownloadBaseLog("解压错误", subdata1, subdata2)
		local subErroType = tonumber(subdata1)
		if subErroType and type(subErroType) == "number" then
			do
				local showMsg = i18n("common_text_1121")
				local errorTyp = "UnzipError"
				if subErroType == unzipErrorType.insufficientMemory then
					showMsg = i18n("common_text_1121")
					errorTyp = "UnzipiIsufficientMemory"
				end
				if subErroType == unzipErrorType.dspacth then
					showMsg = "合并失败" .. subdata2 .. "失败"
					errorTyp = "UnzipDspacthError"
					preDownloadBaseLog("error", "合并失败" .. subdata2 .. "失败")
				end
				if subErroType ~= unzipErrorType.dspacth or userSDKManager.isGameDevelop() then
					SoraDShowLoginFailBox(errorTyp, showMsg, true, function()
						if subErroType ~= unzipErrorType.dspacth then
							self:downFile()
						end
					end)
				end
			end
		end
	elseif eventType == updateModuleEvent.DownloadSuccess then
		preDownloadBaseLog("downloadSuc")
	elseif eventType == updateModuleEvent.UnzipSuccess then
		preDownloadBaseLog("UnzipSuccess")
	end
end
return preDownloadBase
