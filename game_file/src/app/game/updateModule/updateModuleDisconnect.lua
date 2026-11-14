local updateModuleDef = requireLocal(".updateModuleDef")
local updateModuleCheck = requireLocal(".updateModuleCheck")
local updateModuleTimer = requireLocal(".updateModuleTimer")
local disconnectedCheckVersionStatus = updateModuleDef.disconnectedCheckVersionStatus
local formatHandler = updateModuleDef.formatHandler
local updateModuleDisconnect = class("updateModuleDisconnect")
function updateModuleDisconnect:ctor()
	self.disconnectedCheckVersionStatus = disconnectedCheckVersionStatus.noTask
	self._updateModuleTimer = updateModuleTimer.new()
end
function updateModuleDisconnect:resetData()
	if self._updateModuleCheck then
		self._updateModuleCheck:setCheckAbandon()
		self._updateModuleCheck = nil
	end
	self._updateModuleTimer:resetData()
	self.disconnectedCheckVersionStatus = disconnectedCheckVersionStatus.noTask
end
function updateModuleDisconnect:startUpdate()
	self:resetData()
	self.disconnectedCheckVersionStatus = disconnectedCheckVersionStatus.failed
	local myTempLoop = function()
		if self.disconnectedCheckVersionStatus == disconnectedCheckVersionStatus.failed then
			self.disconnectedCheckVersionStatus = disconnectedCheckVersionStatus.noTask
			self:disconnectedCheckVersion()
		end
	end
	self._updateModuleTimer:retry(myTempLoop, 2)
end
function updateModuleDisconnect:disconnectedCheckVersion()
	if self.disconnectedCheckVersionStatus == disconnectedCheckVersionStatus.noTask then
		self:resetData()
		self._updateModuleCheck = updateModuleCheck.new()
		self.disconnectedCheckVersionStatus = disconnectedCheckVersionStatus.tasking
		local callBack = function(requestData, checker, url)
			if self.disconnectedCheckVersionStatus == disconnectedCheckVersionStatus.tasking then
				self.disconnectedCheckVersionStatus = disconnectedCheckVersionStatus.noTask
				print("先回来", url)
				dump(requestData, "update info", 5)
				if requestData.miniV then
					SoraDUpdateDownload(true)
					return
				end
				local hasUpdate = false
				local preDownLoadData = requestData[updateModuleDef.preDownload_DataKey]
				if preDownLoadData and preDownLoadData.switch == 1 then
					hasUpdate = true
				else
					local downData = requestData.data
					if updateModuleDef.checkUpdateByMD5(downData) then
						hasUpdate = true
					end
				end
				if hasUpdate then
					SoraDCloseLoading()
					local callBackHandle = function()
						local gametop = gModuleMgr.getObject("gametop")
						if gametop then
							gametop:Logout()
						end
						SoraDShowLoginView()
					end
					local panel = SoraDShowMsgBox(i18n("common_text_3763"), i18n("common_text_204"), nil, callBackHandle)
					panel:setTag(1)
					self = panel
					panel.msg = "MESSAGE_SERVER_CLOSE_GUIDE"
					SoraDSendMessage(panel)
					return
				end
			end
		end
		self._updateModuleCheck:checkVersion(gSvrConfig.updateAddr, callBack, formatHandler, function()
			self:startUpdate()
		end)
	end
end
return updateModuleDisconnect
