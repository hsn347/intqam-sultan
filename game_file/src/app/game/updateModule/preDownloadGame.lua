local updateModuleDef = requireLocal(".updateModuleDef")
local updateModuleCheck = requireLocal(".updateModuleCheck")
local preDownloadBase = requireLocal(".preDownloadBase")
local updateModuleTimer = requireLocal(".updateModuleTimer")
local updateModuleEvent = updateModuleDef.updateModuleEvent
local formatHandler = updateModuleDef.formatHandler
local preDownloadGame = class("preDownloadGame", preDownloadBase)
function preDownloadGame:ctor()
	preDownloadGame.super.ctor(self)
	self._downloaded = false
	self._filedownloading = false
	self._fileSizedownloading = 0
end
function preDownloadGame:resetData()
	if self._updateModuleTimerVersion then
		self._updateModuleTimerVersion:resetData()
	end
	if self._updateModuleTimerDowner then
		self._updateModuleTimerDowner:resetData()
	end
	self._downloaded = false
	self._filedownloading = false
end
local updateModuleGameName = "updateModuleHandlerGameEvent"
function preDownloadGame:getEventHandlerName()
	_G[updateModuleGameName] = function(eventType, subdata1, subdata2)
		self:updateModuleHandlerEvent(eventType, subdata1, subdata2)
	end
	return updateModuleGameName
end
function preDownloadGame:getSizeDownloading()
	if self._downloaded then
		return self:getSizeTotal()
	end
	return self._fileSizedownloading or 0
end
function preDownloadGame:getSizeTotal()
	return self.downSize or 0
end
function preDownloadGame:isFileDownloaded()
	return self._downloaded
end
function preDownloadGame:isFileDownloading()
	return self._filedownloading
end
function preDownloadGame:initCheck()
	if self._updateModuleCheck then
		self._updateModuleCheck:setCheckAbandon()
		self._updateModuleCheck = nil
	end
	self._updateModuleCheck = updateModuleCheck.new()
end
function preDownloadGame:retryStartPreDownload()
	if not self._updateModuleTimerVersion then
		self._updateModuleTimerVersion = updateModuleTimer.new()
	end
	local myTempLoop = function()
		print("retryStartPreDownload", self._filedownloading)
		if self._filedownloading then
			self:startPreDownload()
		end
	end
	self._updateModuleTimerVersion:retry(myTempLoop, updateModuleDef.preDownload_RetryTime_Version)
end
function preDownloadGame:retryDownload()
	if not self._updateModuleTimerDowner then
		self._updateModuleTimerDowner = updateModuleTimer.new()
	end
	local myTempLoop = function()
		print("retryDownload", self._filedownloading)
		local gotoDownload = function(backType)
			if self._filedownloading then
				self:downFile(true)
			end
		end
		local isWAN = network.getInternetConnectionStatus() == gCCNetworkStatusReachableViaWWAN
		if isWAN then
			local callBackHandle = function(backType)
				if backType == MSGBOX_CALLBACK_YES then
					gotoDownload()
				else
					self._filedownloading = false
					_ENV = nil
					;(nil).msg = "MESSAGE_PRE_DOWNLOAD_REFRESH"
					SoraDSendMessage(nil)
				end
			end
			_ENV = nil
			;(nil).align = cc.TEXT_ALIGNMENT_CENTER
			SoraDShowMsgBox(i18n("download_first_description_018"), i18n("common_text_204"), i18n("download_first_description_020"), callBackHandle, nil)
			_ENV = i18n("download_first_description_018")
			i18n("download_first_description_018").msg = "MESSAGE_SERVER_CLOSE_GUIDE"
			SoraDSendMessage((i18n("download_first_description_018")))
		else
			gotoDownload()
		end
	end
	self._updateModuleTimerDowner:retry(myTempLoop, updateModuleDef.preDownload_RetryTime_Down)
end
function preDownloadGame:stopPreDownload()
	self:abortDownFile()
	self:resetData()
end
function preDownloadGame:downFile(isBackDown)
	local resume = true
	if not self:checkIsFileDownload() then
		local size = self:getFileDownloadSize()
		if self.downSize > 0 and size >= self.downSize then
			resume = false
		end
	end
	if preDownloadGame.super.downFile(self, isBackDown, resume) then
		local size = self:getFileDownloadSize()
		self:updateeProgress(self.downSize, size)
	end
end
function preDownloadGame:startPreDownload()
	self._filedownloading = true
	self:initCheck()
	local callBack = function(requestData, url, checker)
		print("先回来", url)
		dump(requestData, "update info", 5)
		local preDownLoadData = requestData[updateModuleDef.preDownload_DataKey]
		if preDownLoadData then
			local gotoDownload = function(backType)
				local data = preDownLoadData
				local downVersion = requestData.v
				self:startDowner(data, downVersion, requestData)
			end
			local isWAN = network.getInternetConnectionStatus() == gCCNetworkStatusReachableViaWWAN
			if isWAN then
				local callBackHandle = function(backType)
					if backType == MSGBOX_CALLBACK_YES then
						gotoDownload()
					else
						self._filedownloading = false
						_ENV = nil
						;(nil).msg = "MESSAGE_PRE_DOWNLOAD_REFRESH"
						SoraDSendMessage(nil)
					end
				end
				local downVersion = requestData.v
				self:setUpdateInfo(preDownLoadData, downVersion)
				local size = self:getFileDownloadSize()
				local remainsSize = math.max(0, self.downSize - size)
				local strDownload = SoraDConvertNumberWithUnit(remainsSize)
				_ENV = nil
				;(nil).var = strDownload
				_ENV = nil
				;(nil).align = cc.TEXT_ALIGNMENT_CENTER
				SoraDShowMsgBox(i18n("download_first_description_017", nil), i18n("common_text_204"), i18n("download_first_description_020"), callBackHandle, nil)
				_ENV = i18n("download_first_description_017", nil)
				i18n("download_first_description_017", nil).msg = "MESSAGE_SERVER_CLOSE_GUIDE"
				SoraDSendMessage((i18n("download_first_description_017", nil)))
			else
				gotoDownload()
			end
			return
		else
			self:updateModuleHandlerEvent(updateModuleEvent.NotUpdate)
		end
	end
	self._updateModuleCheck:checkVersion(gSvrConfig.updateAddr, callBack, formatHandler, function()
		self:updateModuleHandlerEvent(updateModuleEvent.GetVersionError)
	end)
end
local preDownloadGameLog = function(msg, ...)
	updateModuleDef.log("preDownloadGame " .. msg, ...)
end
function preDownloadGame:updateeProgress(total, downloaded)
	self._fileSizedownloading = downloaded
	_ENV = nil
	;(nil).msg = "MESSAGE_PRE_DOWNLOAD_GAME_PROGRESS"
	;(nil).total = total
	;(nil).downloaded = downloaded
	SoraDSendMessage(nil)
end
function preDownloadGame:updateModuleHandlerEvent(eventType, subdata1, subdata2)
	if eventType == updateModuleEvent.DownloadProgress then
		local time = os.time()
		if self.time ~= time then
			self.time = time
			local total = tonumber(subdata1)
			local downloaded = tonumber(subdata2)
			if total and downloaded and type(total) == "number" and type(downloaded) == "number" then
				self:updateeProgress(total, downloaded)
			end
		end
	elseif eventType == updateModuleEvent.NotUpdate then
		preDownloadGameLog("无更新")
	elseif eventType == updateModuleEvent.DownloadError then
		preDownloadGameLog("下载错误", subdata1, subdata2)
		if self._filedownloading then
			self:retryDownload()
		end
	elseif eventType == updateModuleEvent.GetVersionError or eventType == updateModuleEvent.GetVersionServerError then
		preDownloadGameLog("请求版本错误，没有网络")
		if self._filedownloading then
			self:retryStartPreDownload()
		end
	elseif eventType == updateModuleEvent.GetVersionError then
		if self._filedownloading then
			self._filedownloading = false
			preDownloadGameLog("被取消下载")
		end
	elseif eventType == updateModuleEvent.DownloadSuccess then
		preDownloadGameLog("downloadSuc")
		self._downloaded = true
		self._filedownloading = false
		self:updateeProgress(self.downSize, self.downSize)
		updateModuleEvent = self
		self.msg = "MESSAGE_PRE_DOWNLOAD_GAME_DOWNSUC"
		SoraDSendMessage(self)
	else
		preDownloadGame.super.updateModuleHandlerEvent(self, eventType, subdata1, subdata2)
	end
end
return preDownloadGame
