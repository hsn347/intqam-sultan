local updateModuleDef = requireLocal(".updateModuleDef")
local updateModuleCheck = requireLocal(".updateModuleCheck")
local disconnectedCheckVersionStatus = updateModuleDef.disconnectedCheckVersionStatus
local formatHandler = updateModuleDef.formatHandler
local updateModuleLoginFail = class("updateModuleLoginFail")
function updateModuleLoginFail:ctor()
	self.disconnectedCheckVersionStatus = disconnectedCheckVersionStatus.noTask
end
function updateModuleLoginFail:resetData()
	if self._updateModuleCheck then
		self._updateModuleCheck:setCheckAbandon()
		self._updateModuleCheck = nil
	end
	self.disconnectedCheckVersionStatus = disconnectedCheckVersionStatus.noTask
end
function updateModuleLoginFail:loginFailCheckVersion()
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
					local panel
					self = nil
					;(nil).handle_yes = function(target)
						callBackHandle()
						if panel and not tolua.isnull(panel) then
							panel:close(nil, ccui.TouchEventType.ended)
						end
					end
					local (nil).content, info = i18n("common_text_3763"), nil
					panel = SoraDShowSystemMsg(4, info)
					self = 4
					;(4).msg = "MESSAGE_SERVER_CLOSE_GUIDE"
					SoraDSendMessage(4)
					return
				end
			end
		end
		self._updateModuleCheck:checkVersion(gSvrConfig.updateAddr, callBack, formatHandler, function()
		end)
	end
end
return updateModuleLoginFail
