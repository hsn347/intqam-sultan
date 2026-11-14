local cocosContext = require("app.common.tabMachine.cocosContext")
local resMgr = class("resMgr", cocosContext)
local decG = 1000000000
local G = 1073741824
local M = 1048576
local sharedDirector = cc.Director:getInstance()
local sharedTextureCache = sharedDirector:getTextureCache()
function resMgr:s1()
	self:call(self:tabMain(), "main")
	self._main = self:getSub("main")
end
function resMgr:tabMain()
	_ENV = nil
	;(nil).s1 = function(c)
	end
	;(nil).event = function(c, event)
		if type(event) ~= "table" then
			return
		end
		if event.name == "resMgr.monitorMem" then
			if not c:hasSub("monitorMem") then
				c:call(self:tabMonitorMem(), "monitorMem")
			end
			return true
		elseif event.name == "resMgr.stopMonitorMem" then
			c:stop("monitorMem")
		end
	end
	return nil
end
function resMgr:monitorMem()
	_UPVALUE0_ = nil
	;(nil).name = "resMgr.monitorMem"
	self._main:notify(nil, 1)
end
function resMgr:stopMonitorMem()
	_UPVALUE0_ = nil
	;(nil).name = "resMgr.stopMonitorMem"
	self._main:notify(nil, 1)
end
function resMgr:tabMonitorMem()
	_ENV = nil
	;(nil).s1 = function(c)
		self:initMemMonitorEnv()
		c:registerMsg("MESSAGE_GAME_FLOW_MEM_WARNING", function()
			c:_onMemWarning()
		end)
	end
	;(nil).t1 = g_t.empty_fun
	;(nil).t1_update = function(c, dt)
		self:checkMem()
	end
	;(nil).t1_updateInterval = 1.0
	;(nil)._onMemWarning = function(c)
		print("lua 收到内存警告-------")
		self:releaseMem()
	end
	;(nil).event = function(c, event)
		if type(event) ~= "table" then
			return
		end
	end
	return nil
end
function resMgr:checkMem()
	local memInfo = self:getMemInfo()
	if self:isLowInFreeeMem(memInfo) then
		self:releaseMem()
	end
end
function resMgr:isMonitoringMem()
	local sub = self._main:getSub("monitorMem")
	return sub ~= nil
end
function resMgr:initMemMonitorEnv()
	if device.platform == "ios" or device.platform == "android" then
		self._totalMem = CSUserSDKManager:getTotalMemory()
	elseif device.platform == "mac" then
		self:getMemInfo()
	end
	self._hasAccurateInterfaceForFreeMem = false
	self._hasAccurateInterfaceForMemUsage = self._totalMem ~= nil
	if device.platform == "ios" then
		local iOSVersion = userSDKManager.getDeviceOSVersion()
		iOSVersion = string.match(iOSVersion, "%d+%.%d+")
		iOSVersion = tonumber(iOSVersion)
		if 13 <= iOSVersion then
			self._hasAccurateInterfaceForFreeMem = true
		end
	elseif device.platform == "android" then
		self._hasAccurateInterfaceForFreeMem = true
	end
	self._highInUseMemPercent = 0.7
	self._lowInUseMemPercent = 0.3
	self._lowFreeMem = 314572800
	self._mildFreeMem = 734003200
	self:getMemInfo()
	if self._totalMem then
		self._lowFreeMem = math.max(self._totalMem * 0.2, self._lowFreeMem)
		self._mildFreeMem = math.max(self._totalMem * 0.6, self._mildFreeMem)
	end
	if not self._hasAccurateInterfaceForFreeMem then
		self._highInUseMemPercent = 0.575
		self._lowInUseMemPercent = 0.25
	end
end
function resMgr:releaseMem(luaGc)
	if luaGc then
		collectgarbage()
	end
	self:releaseTextureMem()
end
function resMgr:releaseTextureMem(releaseSize)
	local memInfo = self:getMemInfo()
	local isMild, memDiff = self:isMildInFreeMem(memInfo)
	if isMild then
		return
	end
	local textures = self:getTextures()
	self:sortTexturesByReleasePriority(textures)
	local mainLoopIndex = sharedDirector:getMainLoopIndex() - 1
	local measureReleaseMemBySystem = self:canGetMemFrequentyly()
	local limit = #textures / 10
	local releaseCount = 0
	local memReleased = 0
	for _, texture in ipairs(textures) do
		if mainLoopIndex > texture:getLruMainLoopIndex() and 0 < texture:getNameWithoutLoad() and not texture:isVirtualTexture() then
			texture:releaseGLTexture()
			if releaseSize ~= nil then
				local memSize = texture:getMemSize()
				releaseSize = releaseSize - memSize
				if releaseSize <= 0 then
					return
				end
			end
			releaseCount = releaseCount + 1
			if measureReleaseMemBySystem or limit < releaseCount then
				memInfo = self:getMemInfo()
				isMild, memDiff = self:isMildInFreeMem(memInfo)
				if isMild then
					return
				end
				memReleased = 0
				releaseCount = 0
			else
				local memSize = texture:getMemSize()
				memReleased = memReleased + memSize
				if memDiff <= memReleased then
					return
				end
			end
		end
	end
end
function resMgr:getTextures()
	local curCacheVersion = sharedTextureCache:getCacheVersion()
	if self._savedVersion ~= curCacheVersion then
		self._textures = sharedTextureCache:getTextures()
		self._savedVersion = curCacheVersion
	end
	return self._textures
end
function resMgr:isLowInFreeeMem(memInfo)
	if memInfo.isSysMemLow then
		return true
	end
	if self._hasAccurateInterfaceForFreeMem and memInfo.freeMem < self._lowFreeMem then
		return true
	end
	if self._hasAccurateInterfaceForMemUsage and memInfo.memPercent > self._highInUseMemPercent then
		return true
	end
	return false
end
function resMgr:isMildInFreeMem(memInfo)
	if memInfo.isSysMemLow then
		return false, 209715200
	end
	if self._hasAccurateInterfaceForFreeMem and memInfo.freeMem < self._mildFreeMem then
		return false, self._mildFreeMem - memInfo.freeMem
	end
	if self._hasAccurateInterfaceForMemUsage and memInfo.memPercent > self._lowInUseMemPercent then
		return false, (memInfo.memPercent - self._lowInUseMemPercent) * self._totalMem
	end
	return true
end
function resMgr:getMemInfo()
	local _ENV, memInfo
	if device.platform == "ios" then
		memInfo.inUseMem = CSUserSDKManager:getUsedMemory()
		memInfo.freeMem = CSUserSDKManager:getAvailableMemory()
		memInfo.engineUsedLargeMem = self:getEngineUsedLargeMem()
		if memInfo.inUseMem < memInfo.engineUsedLargeMem then
			memInfo.inUseMem = memInfo.engineUsedLargeMem
		end
		if self._totalMem then
			memInfo.memPercent = memInfo.inUseMem / self._totalMem
		end
	elseif UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android then
		memInfo.inUseMem = CSUserSDKManager:getUsedMemory()
		memInfo.freeMem = CSUserSDKManager:getAvailableMemory()
		if not self._totalMem then
			self._totalMem = memInfo.freeMem + self:getEngineUsedLargeMem()
		end
		memInfo.engineUsedLargeMem = self:getEngineUsedLargeMem()
		memInfo.inUseMem = memInfo.engineUsedLargeMem
		memInfo.memPercent = memInfo.inUseMem / self._totalMem
	else
		memInfo.engineUsedLargeMem = self:getEngineUsedLargeMem()
		memInfo.inUseMem = memInfo.engineUsedLargeMem
		if self._totalMem then
			memInfo.memPercent = memInfo.inUseMem / self._totalMem
		end
		memInfo.freeMem = 1073741824
		local texTotalSize = cc.Texture2D:getTotalTextureSize()
		memInfo.isSysMemLow = 314572800 < texTotalSize
	end
	return memInfo
end
function resMgr:canGetMemFrequentyly()
	if device.platform == "android" then
		return false
	end
	return true
end
function resMgr:getEngineUsedLargeMem()
	local size = 104857600
	local texTotalSize = cc.Texture2D:getTotalTextureSize()
	size = size + texTotalSize
	return size
end
function resMgr:getIosDeviceTotalMem()
	decG = nil
	;(nil)["iPhone11,8"] = 3 * decG
	;(nil)["iPhone12,8"] = 3 * decG
	;(nil)["iPhone13,1"] = 4 * decG
	;(nil)["iPhone13,2"] = 4 * decG
	;(nil)["iPhone13,3"] = 6 * decG
	;(nil)["iPhone13,4"] = 6 * decG
	;(nil)["iPhone8,1"] = 2 * G
	;(nil)["iPhone8,2"] = 2 * G
	;(nil)["iPhone8,4"] = 2 * G
	;(nil)["iPhone9,1"] = 2 * G
	;(nil)["iPhone9,3"] = 2 * G
	;(nil)["iPhone9,2"] = 3 * decG
	;(nil)["iPhone9,4"] = 3 * decG
	;(nil)["iPhone10,1"] = 2 * G
	;(nil)["iPhone10,4"] = 2 * G
	;(nil)["iPhone10,2"] = 3 * decG
	;(nil)["iPhone10,5"] = 3 * decG
	;(nil)["iPhone10,3"] = 3 * decG
	;(nil)["iPhone10,6"] = 3 * decG
	;(nil)["iPhone11,2"] = 4 * decG
	;(nil)["iPhone11,4"] = 4 * decG
	;(nil)["iPhone11,6"] = 4 * decG
	;(nil)["iPhone12,3"] = 4 * decG
	;(nil)["iPhone12,5"] = 4 * decG
	;(nil)["iPhone1,1"] = 128 * M
	;(nil)["iPhone1,2"] = 128 * M
	;(nil)["iPhone2,1"] = 256 * M
	;(nil)["iPhone3,1"] = 512 * M
	;(nil)["iPhone3,2"] = 512 * M
	;(nil)["iPhone3,3"] = 512 * M
	;(nil)["iPhone4,1"] = 512 * M
	;(nil)["iPhone5,1"] = 1 * G
	;(nil)["iPhone5,2"] = 1 * G
	;(nil)["iPhone5,3"] = 1 * G
	;(nil)["iPhone5,4"] = 1 * G
	;(nil)["iPhone6,1"] = 1 * G
	;(nil)["iPhone6,2"] = 1 * G
	;(nil)["iPhone7,2"] = 1 * G
	;(nil)["iPhone7,1"] = 1 * G
	;(nil)["iPad6,11"] = 2 * G
	;(nil)["iPad6,12"] = 2 * G
	;(nil)["iPad7,5"] = 2 * G
	;(nil)["iPad7,6"] = 2 * G
	;(nil)["iPad7,11"] = 3 * decG
	;(nil)["iPad7,12"] = 3 * decG
	;(nil)["iPad11,6"] = 3 * decG
	;(nil)["iPad1,1"] = 256 * M
	;(nil)["iPad2,1"] = 512 * M
	;(nil)["iPad2,2"] = 512 * M
	;(nil)["iPad2,3"] = 512 * M
	;(nil)["iPad2,4"] = 512 * M
	;(nil)["iPad3,1"] = 1 * G
	;(nil)["iPad3,2"] = 1 * G
	;(nil)["iPad3,3"] = 1 * G
	;(nil)["iPad3,4"] = 1 * G
	;(nil)["iPad3,5"] = 1 * G
	;(nil)["iPad3,6"] = 1 * G
	;(nil)["iPod1,1"] = 128 * M
	;(nil)["iPod2,1"] = 128 * M
	;(nil)["iPod3,1"] = 256 * M
	;(nil)["iPod4,1"] = 256 * M
	;(nil)["iPod5,1"] = 512 * M
	;(nil)["iPod7,1"] = 1 * G * 0.7
	self._mapIosDeviceRamSize, (nil)["iPod9,1"] = nil, 2 * G
	local model = SoraDGetDeviceModel()
	return self._mapIosDeviceRamSize[model]
end
function resMgr:sortTexturesByReleasePriority(textures)
	table.sort(textures, function(texture1, texture2)
		local pathIsVirtual1 = texture1:isVirtualTexture() and 1 or 0
		local pathIsVirtual2 = texture2:isVirtualTexture() and 1 or 0
		if pathIsVirtual1 ~= pathIsVirtual2 then
			return pathIsVirtual1 < pathIsVirtual2
		end
		local name1 = texture1:getNameWithoutLoad() == 0 and 1 or 0
		local name2 = texture2:getNameWithoutLoad() == 0 and 1 or 0
		if name1 ~= name2 then
			return name1 < name2
		end
		local refValue1 = self:getTextureNonCacheRef(texture1)
		local refValue2 = self:getTextureNonCacheRef(texture2)
		local refValueBool1 = 1 <= refValue1 and 1 or 0
		local refValueBool2 = 1 <= refValue2 and 1 or 0
		if refValueBool1 ~= refValueBool2 then
			return refValueBool1 < refValueBool2
		end
		local lruIndex1 = texture1:getLruMainLoopIndex()
		local lruIndex2 = texture2:getLruMainLoopIndex()
		if lruIndex1 ~= lruIndex2 then
			return lruIndex1 < lruIndex2
		end
		if refValue1 ~= refValue2 then
			return refValue1 < refValue2
		end
		local mem1 = texture1:getMemSize()
		local mem2 = texture2:getMemSize()
		if mem1 ~= mem2 then
			return mem1 < mem2
		end
		return tostring(texture1) < tostring(texture2)
	end)
end
function resMgr:getTextureNonCacheRef(texture)
	local refValue = texture:getReferenceCount() - 1
	local frameRef = texture:getFrameRefCount()
	refValue = refValue - frameRef
	return refValue
end
function resMgr:dumpTextures(textures)
	textures = textures or self:getTextures()
	self:sortTexturesByReleasePriority(textures)
	for _, texture in ipairs(textures) do
		print(string.format("id:%8d lru:%8d rcn:%8d rc:%8d mz:%8d vt:%s %s", texture:getNameWithoutLoad(), texture:getLruMainLoopIndex(), self:getTextureNonCacheRef(texture), texture:getReferenceCount(), texture:getMemSize(), tostring(texture:isVirtualTexture()), texture:getTexturePath()))
	end
end
function resMgr:dumpMemInfo()
	local memInfo = self:getMemInfo()
	dump(memInfo, "MemInfo")
end
function resMgr:releaseAllGLTexture()
	local textures = self:getTextures()
	for _, texture in ipairs(textures) do
		texture:releaseGLTexture()
	end
end
function resMgr:dumpTextureInfo()
	local socket = require("socket")
	local traceback = string.split(sharedTextureCache:getCachedTextureInfo(), "\n")
	for k, v in ipairs(traceback) do
		print(k, v)
		socket.sleep(1.0E-4)
	end
	local mem = sharedTextureCache:getTotalTexMemory()
	local memMb = mem / 1048576
	local luaMem = collectgarbage("count") / 1024
	_G.SoraDFabricLog(string.format("MW1 %.2f Mb [%.2f Mb]", memMb, luaMem))
end
resMgr.event = g_t.empty_event
return resMgr
