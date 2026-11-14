local updateModuleDef = requireLocal(".updateModuleDef")
local updateModuleCheck = requireLocal(".updateModuleCheck")
local updateModuleDowner = requireLocal(".updateModuleDowner")
local preDownloadLogin = requireLocal(".preDownloadLogin")
local updateModuleEvent = updateModuleDef.updateModuleEvent
local unzipErrorType = updateModuleDef.unzipErrorType
local formatHandler = updateModuleDef.formatHandler
local updateModuleNormal = class("updateModuleNormal", updateModuleDowner)
function updateModuleNormal:ctor()
	updateModuleNormal.super.ctor(self)
end
function updateModuleNormal:resetData()
	if self._updateModuleCheck then
		self._updateModuleCheck:setCheckAbandon()
		self._updateModuleCheck = nil
	end
	if self._preDownloadLogin then
		self._preDownloadLogin:resetData()
	end
end
function updateModuleNormal:initCheck()
	if self._updateModuleCheck then
		self._updateModuleCheck:setCheckAbandon()
		self._updateModuleCheck = nil
	end
	self._updateModuleCheck = updateModuleCheck.new()
	if self._preDownloadLogin then
		self._preDownloadLogin:resetData()
	end
end
function updateModuleNormal:checkVersion()
	self:initCheck()
	local callBack = function(requestData, url, checker)
		print("先回来", url)
		dump(requestData, "update info", 5)
		_ENV = "update info"
		userSDKManager.logEvent(_G.gSDKDef.TDonEvent.check_innerVer_success, "update info")
		local preDownLoadData = requestData[updateModuleDef.preDownload_DataKey]
		if preDownLoadData and preDownLoadData.switch == 1 then
			local data = preDownLoadData
			local downVersion = preDownLoadData.v or requestData.v
			self:startPreDownload(data, downVersion, requestData)
			return
		end
		if requestData.miniV then
			_ENV = self.startPreDownload
			userSDKManager.logEvent(_G.gSDKDef.TDonEvent.check_need_force_update, self.startPreDownload)
			SoraDUpdateDownload(true, false, requestData.content)
			return
		end
		local downData = requestData.data
		if updateModuleDef.checkUpdateByMD5(downData) then
			local data = downData
			local downVersion = requestData.v
			self:startDowner(data, downVersion, requestData)
			return
		else
			self:updateModuleHandlerEvent(updateModuleEvent.NotUpdate)
		end
		if requestData.tipsV then
			_ENV = requestData.tipsV
			function requestData.tipsV.handle_yes(target)
				device.openURL(SoraDGetDownLoadURL())
			end
			local requestData.tipsV.content, table = requestData.content, requestData.tipsV
			SoraDShowSystemMsg(2, table)
		end
	end
	self._updateModuleCheck:checkVersion(gSvrConfig.updateAddr, callBack, formatHandler, function()
		self:updateModuleHandlerEvent(updateModuleEvent.GetVersionError)
	end)
end
function updateModuleNormal:startPreDownload(data, version, info)
	if not self._preDownloadLogin then
		self._preDownloadLogin = preDownloadLogin.new()
	end
	self._preDownloadLogin:startDowner(data, version, info)
end
local updateModuleNormalName = "updateModuleHandlerEvent"
function updateModuleNormal:getEventHandlerName()
	_G[updateModuleNormalName] = function(eventType, subdata1, subdata2)
		self:updateModuleHandlerEvent(eventType, subdata1, subdata2)
	end
	return updateModuleNormalName
end
function updateModuleNormal:downFile(isBackDown)
	if updateModuleNormal.super.downFile(self, isBackDown) then
		updateModuleNormal = isBackDown
		userSDKManager.logEvent(_G.gSDKDef.TDonEvent.start_downLoad_innerVer, isBackDown)
	end
end
function updateModuleNormal:updateModuleHandlerEvent(eventType, subdata1, subdata2)
	print("更新处理", eventType, subdata1, subdata2)
	if eventType == updateModuleEvent.NotUpdate then
		_ENV = eventType
		userSDKManager.logEvent(_G.gSDKDef.TDonEvent.downLoad_innerVer_success, eventType)
		print("无更新")
		_ENV = "无更新"
		;("无更新").msg = "MESSAGE_UPDATE_SUCCESS"
		SoraDSendMessage("无更新")
	elseif eventType == updateModuleEvent.GetVersionError or eventType == updateModuleEvent.GetVersionServerError then
		print("请求版本错误，没有网络")
		local showMsg = i18n("common_text_1120")
		local errorTyp = "GetVersionError"
		if eventType == updateModuleEvent.GetVersionServerError then
			errorTyp = "GetVersionServerError"
		end
		_ENV = subdata2
		userSDKManager.logEvent(_G.gSDKDef.TDonEvent.download_innerVer_fail, subdata2)
		SoraDShowLoginFailBox(errorTyp, showMsg, true, function()
			self:checkVersion()
		end)
	elseif eventType == updateModuleEvent.DownloadError then
		print("下载错误")
		local showMsg = i18n("common_text_1121")
		local errorTyp = "DownloadError"
		_ENV = showMsg
		showMsg.key = "fail_reason"
		showMsg.value = "network_exception"
		userSDKManager.logEvent(_G.gSDKDef.TDonEvent.downLoad_fail, showMsg)
		SoraDShowLoginFailBox(errorTyp, showMsg, true, function()
			self:downFile(true)
		end)
	elseif eventType == updateModuleEvent.UnzipError then
		print("解压错误")
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
					print("error", "合并失败" .. subdata2 .. "失败")
					if userSDKManager and (userSDKManager.isBeta() or userSDKManager.isReportError() or userSDKManager.isGameDevelop()) then
						_G.sendTraceBackLog(showMsg, nil, nil, true)
					end
				end
				if subErroType ~= unzipErrorType.dspacth or userSDKManager.isGameDevelop() then
					_ENV = nil
					userSDKManager.logEvent(_G.gSDKDef.TDonEvent.update_fail_decompress, nil)
					SoraDShowLoginFailBox(errorTyp, showMsg, true, function()
						if subErroType ~= unzipErrorType.dspacth then
							self:downFile()
						end
					end)
				end
			end
		end
	elseif eventType == updateModuleEvent.DownloadSuccess then
		print("downloadSuc")
	elseif eventType == updateModuleEvent.UnzipSuccess then
		_ENV = "UnzipDspacthError"
		userSDKManager.logEvent(_G.gSDKDef.TDonEvent.downLoad_innerVer_success, "UnzipDspacthError")
	elseif eventType == updateModuleEvent.DownloadProgress then
		local total = tonumber(subdata1)
		local downloaded = tonumber(subdata2)
		if total and downloaded and type(total) == "number" and type(downloaded) == "number" then
			_ENV = downloaded
			downloaded.msg = "MESSAGE_UPDATE_DOWNLOADPROGRESS"
			downloaded.percent = downloaded / total * 100
			SoraDSendMessage(downloaded)
		end
	end
end
return updateModuleNormal
