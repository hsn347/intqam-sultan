local resDownloadModule = class("resDownloadModule")
function resDownloadModule:ctor()
	self.downLoadManager = nil
	self.downLoadListener = nil
	self.updateFail = 0
	self.updateFailType = gUpdateFailTypeDef.updateFailType_none
	self.updateFinish = 0
	self.tableErrImage, _ENV, self.reDownloadCount = gUpdateFailTypeDef.updateFailType_none, gUpdateFailTypeDef.updateFailType_none, 0
	self.timer = nil
	self.needRemoveSprite = false
	self.isRun = false
	self.tableZipFile = nil
	self.canLoadImage = false
	self.haveLoadImage = false
end
function resDownloadModule:starDownload()
	local filePath = ""
	local lang = userSDKManager.getChannel()
	if lang == "ar" then
		print("filePath = res/resVersion/ar/")
		filePath = "res/resVersion/ar/"
	elseif lang == "fa" then
		print("filePath = res/resVersion/ir/")
		filePath = "res/resVersion/ir/"
	else
		print("filePath = res/resVersion/en/")
		filePath = "res/resVersion/en/"
	end
	if device.platform == "android" then
		filePath = filePath .. "android"
	elseif device.platform == "ios" then
		filePath = filePath .. "ios"
	elseif device.platform == "mac" then
		filePath = filePath .. "mac"
	end
	filePath = filePath .. "/version.manifest"
	self:onRealseUpdateManager()
	self.downLoadManager = cc.AssetsManagerEx:create(filePath, cc.FileUtils:getInstance():getWritablePath() .. "hd_res/")
	self.downLoadManager:retain()
	if not self.downLoadManager:getLocalManifest():isLoaded() then
		print("本地找不到manifest文件")
	else
		self.downLoadListener = cc.EventListenerAssetsManagerEx:create(self.downLoadManager, handler(self, self.onUpdateManagerEvent))
		cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self.downLoadListener, 1)
		self.downLoadManager:update()
		local localManifest = self.downLoadManager:getLocalManifest()
		local sentLocal = localManifest:getVersion()
		GAME_RES_VERSION = sentLocal
		_ENV = handler(self, self.onUpdateManagerEvent)
		handler(self, self.onUpdateManagerEvent).version = sentLocal
		userSDKManager.logEvent(gSDKDef.TDonEvent.star_resVer, handler(self, self.onUpdateManagerEvent))
	end
end
function resDownloadModule:onUpdateManagerEvent(event)
	if not self.__cname then
		print("对象已经被释放")
		return
	end
	if self.isClose then
		self:onRealseUpdateManager()
		return
	end
	local eventCode = event:getEventCode()
	if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then
		print("下载文件夹中找不到project.manifest文件")
		self.updateFail = self.updateFail + 1
		if self.updateFailType == gUpdateFailTypeDef.updateFailType_none then
			self.updateFailType = gUpdateFailTypeDef.updateFailType_checkVersion
		end
	elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then
		local assetId = event:getAssetId()
		local percent = event:getPercent()
		local strInfo = ""
		if assetId == cc.AssetsManagerExStatic.VERSION_ID then
			strInfo = string.format("Version: %d%%", percent)
		elseif assetId == cc.AssetsManagerExStatic.MANIFEST_ID then
			strInfo = string.format("Manifest: %d%%", percent)
		else
			strInfo = string.format("%d%%", percent)
		end
		print(strInfo)
	elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST then
		print("发生错误:下载manifest文件失败")
		self.updateFail = self.updateFail + 1
		if self.updateFailType == gUpdateFailTypeDef.updateFailType_none then
			self.updateFailType = gUpdateFailTypeDef.updateFailType_checkVersion
		end
	elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then
		print("发生错误:解析manifest文件失败")
		self.updateFail = self.updateFail + 1
		if self.updateFailType == gUpdateFailTypeDef.updateFailType_none then
			self.updateFailType = gUpdateFailTypeDef.updateFailType_checkVersion
		end
	elseif eventCode == cc.EventAssetsManagerEx.EventCode.NEW_VERSION_FOUND then
		print("发现新版本，开始升级")
	elseif eventCode == cc.EventAssetsManagerEx.EventCode.ASSET_UPDATED then
		print("asset updated")
	elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FAILED then
		print("更新失败了")
		self.updateFail = self.updateFail + 1
		if self.updateFailType == gUpdateFailTypeDef.updateFailType_none then
			self.updateFailType = gUpdateFailTypeDef.updateFailType_freeUpdate
		end
	elseif eventCode == cc.EventAssetsManagerEx.EventCode.DOWNLOAD_NEW_PACKAGE then
	elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE then
		print("已经是最新版本了，进入游戏主界面")
		self.updateFinish = self.updateFinish + 1
	elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then
		print("更新完毕，进入游戏")
		self.updateFinish = self.updateFinish + 1
	elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then
		print("下载错误码：", event:getAssetId(), ", [", event:getMessage(), "]")
		local filePath = cc.FileUtils:getInstance():getWritablePath() .. "hd_res/" .. event:getAssetId() .. ".temp"
		cc.FileUtils:getInstance():removeFile(filePath)
		self.updateFail = self.updateFail + 1
	elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_MD5 then
		self.updateFail = self.updateFail + 1
		if self.updateFailType == gUpdateFailTypeDef.updateFailType_none then
			self.updateFailType = gUpdateFailTypeDef.updateFailType_md5
		end
	elseif eventCode == cc.EventAssetsManagerEx.EventCode.SUCCESS_DECOMPRESS then
		self:decompressAsync()
		return
	elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DECOMPRESS then
		print("成功解压 ", event:getAssetId(), ", ", event:getMessage())
		self:decompressAsync()
		return
	end
	if self.updateFail == 1 then
		print("更新失败")
		local failType = "updateFail"
		local showMsg = i18n("common_text_1121")
		if self.updateFailType == gUpdateFailTypeDef.updateFailType_checkVersion then
			print("err gUpdateFailTypeDef.updateFailType_checkVersion")
			local writabelPath = cc.FileUtils:getInstance():getWritablePath() .. "hd_res/"
			cc.FileUtils:getInstance():removeFile(writabelPath .. "version.manifest")
			cc.FileUtils:getInstance():removeFile(writabelPath .. "project.manifest")
			cc.FileUtils:getInstance():removeFile(writabelPath .. "project.manifest.temp")
			cc.FileUtils:getInstance():removeFile(writabelPath .. "project.manifest.temp.copy")
		elseif self.updateFailType == gUpdateFailTypeDef.updateFailType_freeUpdate then
			print("err gUpdateFailTypeDef.updateFailType_freeUpdate")
		elseif self.updateFailType == gUpdateFailTypeDef.updateFailType_md5 then
			print("err gUpdateFailTypeDef.updateFailType_md5")
		end
		if SoraDCurrentMainUI() then
			self.reDownloadCount = self.reDownloadCount + 1
			if self.reDownloadCount <= 5 then
				self:startByWIFI(SoraDCurrentMainUI(), 5 + self.reDownloadCount)
			end
		end
	elseif self.updateFail == 0 and self.updateFinish == 1 then
		print("更新成功")
		if eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then
			self.needRemoveSprite = true
		end
		local localManifest = self.downLoadManager:getLocalManifest()
		local sentLocal = localManifest:getVersion()
		GAME_RES_VERSION = sentLocal
		_ENV = SoraDCurrentMainUI()
		SoraDCurrentMainUI().version = sentLocal
		userSDKManager.logEvent(gSDKDef.TDonEvent.end_resVer, (SoraDCurrentMainUI()))
		self:decompressAsync()
	end
end
function resDownloadModule:decompressAsync()
	self.haveLoadImage = false
	if self.downLoadManager then
		if self.tableZipFile == nil then
			self:gatZipFile()
		end
		if #self.tableZipFile > 0 then
			if self.downLoadManager then
				self.downLoadManager:decompressAsync(table.remove(self.tableZipFile))
			else
				self.haveLoadImage = true
				print("图片自解压完成")
			end
		else
			self.haveLoadImage = true
			print("图片自解压完成")
		end
	end
	if self.canLoadImage and self.haveLoadImage then
		self:loadHDImage()
	end
end
function resDownloadModule:gatZipFile()
	self.tableZipFile, _ENV = nil, nil
	local writabelPath = cc.FileUtils:getInstance():getWritablePath() .. "hd_res/"
	local lfs = require("lfs")
	for file in lfs.dir(writabelPath) do
		if file ~= "." and file ~= ".." and string.sub(file, -4) == ".zip" then
			table.insert(self.tableZipFile, writabelPath .. file)
		end
	end
end
function resDownloadModule:pressDownload()
end
function resDownloadModule:stopDownload()
	self.isClose = true
end
function resDownloadModule:loadHDImage()
	print("开始加载图片")
	local schedulerTime = require(cc.PACKAGE_NAME .. ".scheduler")
	if self.timer then
		schedulerTime.unscheduleGlobal(self.timer)
		self.timer = nil
	end
	self.timer = schedulerTime.performWithDelayGlobal(function(...)
		if table.nums(self.tableErrImage) > 0 then
			local writabelPath = cc.FileUtils:getInstance():getWritablePath() .. "hd_res/"
			cc.FileUtils:getInstance():removeFile(writabelPath .. "version.manifest")
			cc.FileUtils:getInstance():removeFile(writabelPath .. "project.manifest")
			cc.FileUtils:getInstance():removeFile(writabelPath .. "project.manifest.temp")
			cc.FileUtils:getInstance():removeFile(writabelPath .. "project.manifest.temp.copy")
			if SoraDCurrentMainUI() then
				self:startByWIFI(SoraDCurrentMainUI(), 5)
			end
		end
		self.timer = nil
	end, 60)
	local loadImageIndex = 0
	local _ENV, arrayImagesIOSPath = function(...)
		if table.nums(self.tableErrImage) > 0 then
			local writabelPath = cc.FileUtils:getInstance():getWritablePath() .. "hd_res/"
			cc.FileUtils:getInstance():removeFile(writabelPath .. "version.manifest")
			cc.FileUtils:getInstance():removeFile(writabelPath .. "project.manifest")
			cc.FileUtils:getInstance():removeFile(writabelPath .. "project.manifest.temp")
			cc.FileUtils:getInstance():removeFile(writabelPath .. "project.manifest.temp.copy")
			if SoraDCurrentMainUI() then
				self:startByWIFI(SoraDCurrentMainUI(), 5)
			end
		end
		self.timer = nil
	end, function(...)
		if table.nums(self.tableErrImage) > 0 then
			local writabelPath = cc.FileUtils:getInstance():getWritablePath() .. "hd_res/"
			cc.FileUtils:getInstance():removeFile(writabelPath .. "version.manifest")
			cc.FileUtils:getInstance():removeFile(writabelPath .. "project.manifest")
			cc.FileUtils:getInstance():removeFile(writabelPath .. "project.manifest.temp")
			cc.FileUtils:getInstance():removeFile(writabelPath .. "project.manifest.temp.copy")
			if SoraDCurrentMainUI() then
				self:startByWIFI(SoraDCurrentMainUI(), 5)
			end
		end
		self.timer = nil
	end
	local arrayImagesPath = commonArrayImagesPath_download
	local alreadyList = SoraDConfigGet("Game:resDownloadModule:saveData~table")
	local _ENV, newImgList = "Game:resDownloadModule:saveData~table", "Game:resDownloadModule:saveData~table"
	local lang = userSDKManager.getChannel()
	if lang ~= "ar" then
		for k, v in pairs(commonArrayImagesPath_download_en) do
			arrayImagesPath[#arrayImagesPath + 1] = v
		end
	end
	if device.platform ~= "ios" then
		for k, v in pairs(commonArrayImagesPath_ios_only) do
			arrayImagesIOSPath[v.name] = true
		end
	end
	for k, v in pairs(arrayImagesPath) do
		self.tableErrImage[v.name .. ".zip"] = true
		local plistName = v.name .. ".plist"
		local imageName = getImageFileNameByPlatform(v.name)
		local fullFileName = cc.FileUtils:getInstance():fullPathForFilename(plistName)
		local fullImageName = cc.FileUtils:getInstance():fullPathForFilename(imageName)
		if arrayImagesIOSPath[v.name] then
			print("不需要下载的图片 " .. v.name)
			loadImageIndex = loadImageIndex + 1
			self.tableErrImage[v.name .. ".zip"] = nil
		elseif not cc.FileUtils:getInstance():isFileExist(fullFileName) or not cc.FileUtils:getInstance():isFileExist(fullImageName) then
			print("在【" .. fullFileName .. "】不存在 ：" .. plistName)
			loadImageIndex = loadImageIndex + 1
		else
			if alreadyList[v.name] then
				print("已下载过" .. v.name)
				self.tableErrImage[v.name .. ".zip"] = nil
				newImgList[v.name] = true
				loadImageIndex = loadImageIndex + 1
				SoraDConfigSet("Game:resDownloadModule:saveData~table", newImgList)
			else
				SoraDRemoveSpriteFramesWithFile(plistName, imageName)
				display.addSpriteFrames(plistName, imageName, function(plist, image)
					self.tableErrImage[v.name .. ".zip"] = nil
					newImgList[v.name] = true
					SoraDConfigSet("Game:resDownloadModule:saveData~table", newImgList)
					if loadImageIndex >= #arrayImagesPath then
						print("清空图片管理缓存")
						SoraDCleanHDResManager()
						self:onRealseUpdateManager()
					end
				end)
			end
			if loadImageIndex >= #arrayImagesPath then
				if self.needRemoveSprite then
					print("清空图片管理缓存")
					SoraDCleanHDResManager()
				end
				self:onRealseUpdateManager()
			end
		end
	end
end
function resDownloadModule:onRealseUpdateManager()
	if self.timer then
		local schedulerTime = require(cc.PACKAGE_NAME .. ".scheduler")
		schedulerTime.unscheduleGlobal(self.timer)
		self.timer = nil
	end
	self.tableErrImage, _ENV = require(cc.PACKAGE_NAME .. ".scheduler"), schedulerTime
	self.tableZipFile = nil
	self.needRemoveSprite = false
	self.updateFail = 0
	self.updateFailType = gUpdateFailTypeDef.updateFailType_none
	self.updateFinish = 0
	if self.downLoadManager then
		print("更新模块释放")
		self.downLoadManager:release()
		self.downLoadManager = nil
		cc.Director:getInstance():getEventDispatcher():removeEventListener(self.downLoadListener)
		self.downLoadListener = nil
	end
end
function resDownloadModule:isRunning()
	return self.isRun
end
function resDownloadModule:setLoadImageState(canLoad)
	self.canLoadImage = canLoad
	print("图片资源下载自主加载状态为 ：", self.canLoadImage)
	if self.canLoadImage and self.haveLoadImage then
		self:loadHDImage()
	end
end
function resDownloadModule:startByWIFI(target, delay)
	self.isRun = true
	delay = delay == nil and 5 or delay
	resDownloadModule = nil
	;(nil)[1] = cca.delay(delay)
	;(nil)[2] = cca.callFunc(function(target)
		print("启动资源下载")
		if network.getInternetConnectionStatus() == gCCNetworkStatusReachableViaWiFi then
			self:starDownload()
		else
			print("网络环境出错")
			resDownloadModule:startByWIFI(target, delay)
		end
	end)
	;(nil)[3] = cca.callFunc(function(target)
		print("启动资源下载")
		if network.getInternetConnectionStatus() == gCCNetworkStatusReachableViaWiFi then
			self:starDownload()
		else
			print("网络环境出错")
			resDownloadModule:startByWIFI(target, delay)
		end
	end)
	local downloadAction = cca.seq(nil)
	target:runAction(downloadAction)
end
return resDownloadModule
