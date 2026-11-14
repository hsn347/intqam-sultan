if not imageManager then
	_ENV = imageManager
end
imageManager = imageManager
local _ENV, cacheImageList = imageManager, imageManager
local _ENV, cachePlistList
local _ENV, notUseImageList
local _ENV, notUsePlistList
function imageManager.useImage(image)
	if not cacheImageList[image] then
		cacheImageList[image], cacheImageList = cacheImageList[image], cacheImageList[image]
		cacheImageList[image].count = 0
	end
	if notUseImageList[image] then
		notUseImageList[image] = nil
	end
	cacheImageList[image].count = cacheImageList[image].count + 1
end
function imageManager.usePlist(plist)
	if not cachePlistList[plist] then
		cachePlistList[plist], cachePlistList = cachePlistList[plist], cachePlistList[plist]
		cachePlistList[plist].count = 0
	end
	if notUsePlistList[plist] then
		notUsePlistList[plist] = nil
	end
	cachePlistList[plist].count = cachePlistList[plist].count + 1
end
function imageManager.unuseImage(image, force)
	local force = force or false
	if image and cacheImageList[image] then
		cacheImageList[image].count = cacheImageList[image].count - 1
		if cacheImageList[image].count <= 0 then
			if imageManager.isLowDevice() or force then
			else
				notUseImageList[image] = true
			end
			cacheImageList[image] = nil
		end
	end
end
function imageManager.unusePlist(plist)
	if plist and cachePlistList[plist] then
		cachePlistList[plist].count = cachePlistList[plist].count - 1
		if cachePlistList[plist].count <= 0 then
			if imageManager.isLowDevice() then
			else
				notUsePlistList[plist] = true
			end
			cachePlistList[plist] = nil
		end
	end
end
function imageManager.switchScene()
	collectgarbage("collect")
end
function imageManager.freeImages()
	print("开始释放资源了")
	if TMXMapInfoCache then
		local cache = TMXMapInfoCache:getInstance()
		cache:removeAllMapInfo()
	end
	local instanceCacheMgr = include("instanceCacheMgr")
	instanceCacheMgr.clearCache()
	display.removeUnusedSpriteFrames()
end
function AppDidReceiveMemoryWarning()
	print("lua 收到内存警告-------")
	SoraDClearItemwAwards()
	local sharedTextureCache = cc.Director:getInstance():getTextureCache()
	if sharedTextureCache.getTotalTexMemory then
		local mem = sharedTextureCache:getTotalTexMemory()
		local memMb = mem / 1048576
		local luaMem = collectgarbage("count") / 1024
		_G.SoraDFabricLog(string.format("MW1 %.2f Mb [%.2f Mb] %.2fMb", memMb, luaMem, imageManager.getAvailableMemory()))
	else
		_G.SoraDFabricLog("MemoryWarning")
	end
	collectgarbage("collect")
	if TMXMapInfoCache then
		local cache = TMXMapInfoCache:getInstance()
		cache:removeAllMapInfo()
	end
	local instanceCacheMgr = include("instanceCacheMgr")
	instanceCacheMgr.clearCache()
	uiManager:clearLRUCache()
	local packageManager = require("fgui.base.packageManager")
	packageManager:clearUnusedPackage()
	display.removeUnusedSpriteFrames()
	CS.Sultan.Middleware.ActionPool.Clean()
	fgui.GTween.Clean()
	criAdxAux.freeAudio()
	if sharedTextureCache.getTotalTexMemory then
		local mem = sharedTextureCache:getTotalTexMemory()
		local memMb = mem / 1048576
		local luaMem = collectgarbage("count") / 1024
		_G.SoraDFabricLog(string.format("MW2 %.2f Mb [%.2f Mb] %.2fMb", memMb, luaMem, imageManager.getAvailableMemory()))
	end
	CS.Sultan.Middleware.CCAssetCache.getInstance():ClearAssetCache()
end
local isLow = false
if device.platform == "ios" and (device.model == "iphone 4" or device.model == "ipad") then
	isLow = true
end
function imageManager.isLowDevice()
	return isLow
end
function imageManager.isMemoryNotEnough(msg)
	if device.platform == "ios" then
		return imageManager.getAvailableMemory(msg) < 50
	else
		return imageManager.getAvailableMemory(msg) < 100
	end
end
function imageManager.getAvailableMemory(msg)
	local memSzie = 1000
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
		memSzie = CSUserSDKManager:getAvailableMemory()
	end
	if msg then
		_G.SoraDFabricLog(string.format("MW3 %.2f Mb %s", memSzie, msg))
	end
	return memSzie
end
