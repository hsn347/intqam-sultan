local c = cc
local criSprite = c.criSprite
_ENV = nil
;(nil).HEIGHT = 1
;(nil).LOW = 2
cc.CRIWARE_QUALITY_TYPE, (nil).HALF = nil, 3
local CIRWARE_QUALITY_DEFAULT = cc.CRIWARE_QUALITY_TYPE.HEIGHT
local qualPath
if _G.UnityEngine.Application.platform == _G.UnityEngine.RuntimePlatform.IPhonePlayer then
	qualPath = "Criware/iOS/"
else
	qualPath = "Criware/Android/"
end
if _G.G_IS_Editor then
	local persistent_path = _G.CS.UnityEngine.Application.dataPath .. "/Res/" .. qualPath
	if not _G.CS.System.IO.Directory.Exists(persistent_path) then
		qualPath = "Criware/"
	elseif _G.CS.Sultan.GameSetting.ResourceFactoryType == _G.CS.Sultan.ResourceFactoryEnum.Addressable then
		local CSUserSDKManager = _G.CS.Sultan.Manager.UserSDKManager.GetInstance()
		if CSUserSDKManager:getIsIOSRuntime() then
			qualPath = "Criware/iOS/"
		end
	end
end
function criSprite.createCriSprite(fileName, isAutoRemove, isLoop, prepare)
	if isLoop == nil then
	end
	local criSp = cc.criSprite:createWithPlayer()
	if criSp == nil then
		print_error(criSp, "构建criSprite失败，已达同时播放上限")
		criSp = criSprite.createEmptyNode()
	else
		criSp:initCriSprite()
	end
	criSp:loop(isLoop)
	if xpcall(function()
		criSp:setVideoFile(fileName)
	end, function()
		print(debug.traceback())
	end) then
	else
		print_error(criSp, "构建criSprite失败，路径不存在", fileName)
		criSp = criSprite.createEmptyNode()
	end
	criSp:setAnchorPoint(cc.p(0.5, 0.5))
	criSp:setName("CriSprite")
	if not isLoop and not isAutoRemove then
		criSp:setPlayCompletePause(true)
	elseif isAutoRemove then
		criSp:setCompleteCallback(function(...)
			if tolua.isnull(criSp) then
				return
			end
			criSp:removeFromParent()
		end)
	end
	if prepare then
		criSp:prepare()
		if type(prepare) == "function" then
			criSp:setPrepareCallback(function()
				prepare(criSp)
			end)
		end
	else
		criSp:start()
	end
	return criSp
end
function criSprite:setVideoFile(fileName, quality)
	if type(fileName) == "string" then
		local tmpFileName = SoraDStringSplit(fileName, ",")
		if 1 < #tmpFileName then
			fileName = tmpFileName
		end
	end
	local quality = quality or CIRWARE_QUALITY_DEFAULT
	local t = self:getQualityPath(fileName, quality)
	if type(fileName) == "table" then
		print(t[1], "criSprite:setVideoFile")
		local check = CS.Sultan.Core.ResManager.IsExist(t[1])
		if check then
			self:setFileQueue(t)
			return true
		end
	else
		print(t, "criSprite:setVideoFile")
		local check = CS.Sultan.Core.ResManager.IsExist(t)
		if check then
			self:setFile(t)
			return true
		end
	end
	return false
end
function criSprite:replaceVideoFile(fileName, isloop, quality)
	local isNeedReplace = self.lastFileName == fileName
	self.lastFileName = fileName
	if not isloop then
		self:setPlayCompletePause(true)
	end
	if type(fileName) == "string" then
		fileName = SoraDStringSplit(fileName, ",")
	end
	self:loop(isloop)
	if isNeedReplace then
		self:setVideoFile(fileName, quality)
	else
		self:stop()
	end
	self:start()
end
function criSprite:getQualityPath(pathList, quality)
	if type(pathList) == "table" then
		local _ENV, t = type(pathList), type(pathList)
		for k, v in ipairs(pathList) do
			t[k] = qualPath .. v
		end
		return t
	else
		return qualPath .. pathList
	end
end
local _start = criSprite.start
function criSprite:start()
	if self:isPaused() then
		self:pause(false)
	end
	_start(self)
end
function criSprite:getIsError()
	return false
end
function criSprite:setPreviewImage(fileName, size, isAutoRemove, isFadeOut)
	isAutoRemove = isAutoRemove == nil and true or isAutoRemove
	self:setContentSize(size)
	local image = display.newSprite(fileName)
	local imageSize = image:getContentSize()
	image:setScaleX(size.width / imageSize.width)
	image:setScaleY(size.height / imageSize.height)
	image:setPosition(cc.p(size.width / 2, size.height / 2))
	image:addTo(self)
	if isAutoRemove then
		self:setPrepareCallback(function()
			if not tolua.isnull(image) then
				image = nil
				;(nil)[1] = cca.delay(0)
				;(nil)[2] = cca.callFunc(function()
					image:removeFromParent()
				end)
				;(nil)[3] = cca.callFunc(function()
					image:removeFromParent()
				end)
				image:runAction(cca.seq(nil))
			end
			self:start()
		end)
	end
end
function criSprite.createEmptyNode()
	local node = display.newNode()
	function node.setVideoFile()
	end
	function node.getQualityPath()
	end
	function node.createWithPlayer()
		return node
	end
	function node.setQuadVertices()
	end
	function node.setFile()
	end
	function node.replaceFile()
	end
	function node.setFileQueue()
	end
	function node.replaceVideoFile()
	end
	function node.setMaxChunkSize()
	end
	function node:start()
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.1)
		;(nil)[2] = cca.callFunc(function()
			if self.completeCallback then
				self.completeCallback()
			end
		end)
		;(nil)[3] = cca.callFunc(function()
			if self.completeCallback then
				self.completeCallback()
			end
		end)
		self:runAction(cca.seq(nil))
	end
	function node.playToTime()
	end
	function node.playToFrame()
	end
	function node.setPlayCompletePause()
	end
	function node.loop()
		return false
	end
	function node.prepare()
		return true
	end
	function node:setPrepareCallback(callback)
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.1)
		;(nil)[2] = cca.callFunc(function()
			callback()
		end)
		;(nil)[3] = cca.callFunc(function()
			callback()
		end)
		self:runAction(cca.seq(nil))
	end
	function node:setCompleteCallback(callback)
		self.completeCallback = callback
	end
	function node:setTimeEventCallback(callback)
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.1)
		;(nil)[2] = cca.callFunc(function()
			callback()
		end)
		;(nil)[3] = cca.callFunc(function()
			callback()
		end)
		self:runAction(cca.seq(nil))
	end
	function node:setFrameEventCallback(callback)
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.1)
		;(nil)[2] = cca.callFunc(function()
			callback()
		end)
		;(nil)[3] = cca.callFunc(function()
			callback()
		end)
		self:runAction(cca.seq(nil))
	end
	function node.addFrameEventData()
	end
	function node.setDestroyCallback()
	end
	function node.pause()
	end
	function node.isPaused()
	end
	function node.stop()
	end
	function node.stopAndWaitCompletion()
	end
	function node.isValidPlayer()
	end
	function node.setAdditive()
	end
	function node.setBlendFunc()
	end
	function node.setAutoUpdateSizeEnabled()
	end
	function node.getAutoUpdateSizeEnabled()
	end
	function node.getStatus()
	end
	function node.isPlaying()
	end
	function node.getCurPlayFrame()
	end
	function node.getTotalFrame()
	end
	function node.setSeekPosition()
	end
	function node.setSpeed()
	end
	function node.setIsCheckVisibleInScreen()
	end
	function node:setPreviewImage(fileName, size, isAutoRemove)
		self:setContentSize(size)
		local image = display.newSprite(fileName)
		local imageSize = image:getContentSize()
		image:setScaleX(size.width / imageSize.width)
		image:setScaleY(size.height / imageSize.height)
		image:setPosition(cc.p(size.width / 2, size.height / 2))
		image:addTo(self)
	end
	function node.getIsError()
		return true
	end
	return node
end
