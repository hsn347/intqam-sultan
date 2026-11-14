local updateModuleDef = requireLocal(".updateModuleDef")
local preDownloadBase = requireLocal(".preDownloadBase")
local updateModuleEvent = updateModuleDef.updateModuleEvent
local preDownloadLogin = class("preDownloadLogin", preDownloadBase)
function preDownloadLogin:ctor()
	preDownloadLogin.super.ctor(self)
end
function preDownloadLogin:resetData()
end
function preDownloadLogin:downFile(isBackDown)
	local goDownFile = function(resume)
		self:abortDownFile()
		if preDownloadLogin.super.downFile(self, isBackDown, resume) then
			print("preDownloadLogin:downFile start suc")
		end
	end
	if self:checkIsFileDownload() then
		goDownFile()
	else
		local resume = true
		local size = self:getFileDownloadSize()
		if self.downSize > 0 and size >= self.downSize then
			resume = false
			size = 0
		end
		local remainsSize = math.max(0, self.downSize - size)
		local strDownload = SoraDConvertNumberWithUnit(remainsSize)
		preDownloadLogin = nil
		;(nil).var1 = self.downVersion .. ".001"
		;(nil).var2 = strDownload
		local content = i18n("download_first_description_012", nil)
		local panel
		preDownloadLogin = nil
		;(nil).handle_yes = function(target)
			goDownFile(resume)
			if panel and not tolua.isnull(panel) then
				panel:close(nil, ccui.TouchEventType.ended)
			end
		end
		local (nil).content, info = content, nil
		panel = SoraDShowSystemMsg(4, info)
	end
end
local preDownloadLoginLog = function(msg, ...)
	updateModuleDef.log("preDownloadLogin " .. msg, ...)
end
function preDownloadLogin:updateModuleHandlerEvent(eventType, subdata1, subdata2)
	if eventType == updateModuleEvent.DownloadProgress then
		local time = os.time()
		if self.time ~= time then
			self.time = time
			local total = tonumber(subdata1)
			local downloaded = tonumber(subdata2)
			if total and downloaded and type(total) == "number" and type(downloaded) == "number" then
				updateModuleEvent = downloaded
				downloaded.msg = "MESSAGE_PRE_DOWNLOAD_LOGIN_PROGRESS"
				downloaded.total = total
				downloaded.downloaded = downloaded
				SoraDSendMessage(downloaded)
			end
		end
	elseif eventType == updateModuleEvent.UnzipProgress then
		local time = os.time()
		if self.time ~= time then
			self.time = time
			local total = tonumber(subdata1)
			local downloaded = tonumber(subdata2)
			if total and downloaded and type(total) == "number" and type(downloaded) == "number" then
				updateModuleEvent = downloaded
				downloaded.msg = "MESSAGE_PRE_DOWNLOAD_LOGIN_PROGRESS_UNZIP"
				downloaded.total = total
				downloaded.downloaded = downloaded
				SoraDSendMessage(downloaded)
			end
		end
	elseif eventType == updateModuleEvent.DownloadSuccess then
		preDownloadLoginLog("downloadSuc")
		if _G.ng_sys_unZip then
			_G.ng_sys_unZip(self._isPreDownload)
		end
	else
		preDownloadLogin.super.updateModuleHandlerEvent(self, eventType, subdata1, subdata2)
	end
end
return preDownloadLogin
