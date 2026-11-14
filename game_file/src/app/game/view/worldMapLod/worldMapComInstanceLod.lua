local worldMapComInstanceLod = class("worldMapComInstanceLod", include("worldMapComInstance"))
local instanceBuilderLod = include("instanceBuilderLod")
local devicePerformanceUtil = require("app.devicePerformanceUtil")
function worldMapComInstanceLod:ctor(param)
	worldMapComInstanceLod.super.ctor(self, "worldMapComInstanceLod")
	local worldMapComInstanceLod, empty = worldMapComInstanceLod.super.ctor, worldMapComInstanceLod.super.ctor
	if param then
		if devicePerformanceUtil.getCurQualityLevel() >= 2 then
			self.preLod = param.pre or empty
		else
			self.preLod = empty
		end
		self.focusLod = param.focus or empty
		self.keepLod = param.keep or empty
		if param.maxInstanceDel then
			self.maxInstanceDel = param.maxInstanceDel
		end
		if param.maxInstanceShow then
			self.maxInstanceShow = param.maxInstanceShow
		end
	else
		self.preLod = empty
		self.focusLod = empty
		self.keepLod = empty
	end
	self.builder = instanceBuilderLod.new(self, param)
	self.revertScale = 1
	self.scale = 1
	self._isCheckVisible = param.checkVisible or false
end
function worldMapComInstanceLod:init()
	worldMapComInstanceLod.super.init(self)
end
function worldMapComInstanceLod:onMessageListener()
	worldMapComInstanceLod.super.onMessageListener(self)
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_SCROLL_ZOOM, handler(self, self.updateScaleZoom))
end
function worldMapComInstanceLod:serverMessage_AddMapInstace(data)
	local tilesDataArray = data.data
	local _ENV, tilesShowArray
	for _, v in pairs(tilesDataArray) do
		if self.builder:checkInstanceShow(v) then
			table.insert(tilesShowArray, v)
		end
	end
	self:addShowTilesData(tilesShowArray)
	self:checkAdddMapInstace(data)
end
function worldMapComInstanceLod:checkLodPreview(lod)
	return self.preLod[lod]
end
function worldMapComInstanceLod:checkLodFocus(lod)
	return self.focusLod[lod]
end
function worldMapComInstanceLod:checkLodKeep(lod)
	return self.keepLod[lod]
end
function worldMapComInstanceLod:isCheckVisible(lod)
	return self._isCheckVisible
end
function worldMapComInstanceLod:updateScaleZoom(event)
	local lod = event.lod
	if self:checkLodFocus(lod) then
		local revertScale = event.revertScale
		local scale = event.scale
		self.revertScale = revertScale
		self.scale = scale
		for _, tileInstance in pairs(self.instanceMap) do
			if tileInstance and tileInstance.__cname then
				tileInstance:updateScaleChange(revertScale, scale)
			end
		end
	end
end
function worldMapComInstanceLod:onAddInstance(tileInstance)
	tileInstance:updateScaleChange(self.revertScale, self.scale)
end
function worldMapComInstanceLod:getClosestInstanceFromManager_lod(instanceType, params)
	local buildId = params.buildId
	for _, tileInstance in pairs(self.instanceMap) do
		if tileInstance and tileInstance.instanceType == instanceType and tileInstance:getBuildId() == buildId then
			return tileInstance
		end
	end
end
return worldMapComInstanceLod
