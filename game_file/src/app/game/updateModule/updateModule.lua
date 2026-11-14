local _updateModuleInstance
local updateModuleDef = requireLocal(".updateModuleDef")
local updateModuleNormal = requireLocal(".updateModuleNormal")
local updateModuleDisconnect = requireLocal(".updateModuleDisconnect")
local updateModuleLoginFail = requireLocal(".updateModuleLoginFail")
local isNeedLua = updateModuleDef.isNeedLua
local updateModule = class("updateModule")
function updateModule:getInstance()
	if _updateModuleInstance == nil then
	end
	return _updateModuleInstance
end
function updateModule:ctor()
	local lang = userSDKManager.getChannel()
	local writabelPath = cc.FileUtils:getInstance():getWritablePath()
	local oldManifestUrl = "res/version/" .. lang .. "/" .. device.platform .. "/" .. "version.manifest"
	do
		local writabelPathNormal = writabelPath .. "updatePackage/"
		local manifestUrl = writabelPathNormal .. "version.manifest"
		if ng_sys_setPath then
			ng_sys_setPath(manifestUrl, writabelPathNormal, oldManifestUrl, isNeedLua, false)
		end
	end
	do
		local writabelPathPreDownload = writabelPath .. "updatePre/"
		local manifestUrl = writabelPathPreDownload .. "version.manifest"
		if ng_sys_setPath then
			ng_sys_setPath(manifestUrl, writabelPathPreDownload, oldManifestUrl, isNeedLua, true)
		end
	end
end
function updateModule:getVersion(needBaseVersion, preDownloadVersion)
	return updateModuleDef.getVersion(needBaseVersion, preDownloadVersion)
end
function updateModule:fixUpdateData(aabUpdate)
	local gotoFix = function(backType)
		if backType == MSGBOX_CALLBACK_YES then
			_G.SoraDFixUpdateData(aabUpdate)
		elseif backType == MSGBOX_CALLBACK_NO and userSDKManager and (userSDKManager.isBeta() or userSDKManager.isGameDevelop()) then
			SoraDCreatePanel("cheatView"):show()
		end
	end
	_ENV = nil
	;(nil).align = cc.TEXT_ALIGNMENT_CENTER
	SoraDShowMsgBox(i18n("download_first_description_015"), i18n("common_text_204"), i18n("common_text_185"), gotoFix, nil)
end
function updateModule:resetData()
	if self._updateModuleNormal then
		self._updateModuleNormal:resetData()
		self._updateModuleNormal = nil
	end
	self._updateModuleNormal = updateModuleNormal.new()
	if self._updateModuleDisconnect then
		self._updateModuleDisconnect:resetData()
		self._updateModuleDisconnect = nil
	end
end
function updateModule:checkVersion()
	print("updateModule:checkVersion")
	self:resetData()
	self._updateModuleNormal:checkVersion()
end
function updateModule:disconnectedCheckVersion()
	if self._updateModuleDisconnect then
		self._updateModuleDisconnect:resetData()
		self._updateModuleDisconnect = nil
	end
	self._updateModuleDisconnect = updateModuleDisconnect.new()
	self._updateModuleDisconnect:disconnectedCheckVersion()
end
function updateModule:loginFailCheckVersion()
	if self._updateModuleLoginFailCheck then
		self._updateModuleLoginFailCheck:resetData()
		self._updateModuleLoginFailCheck = nil
	end
	self._updateModuleLoginFailCheck = updateModuleLoginFail.new()
	self._updateModuleLoginFailCheck:loginFailCheckVersion()
end
return updateModule
