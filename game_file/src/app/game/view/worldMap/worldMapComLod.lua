local worldMapComLod = class("worldMapComLod", include("worldMapComLodBase"))
function worldMapComLod:ctor(param)
	worldMapComLod.super.ctor(self, "worldMapComLod")
	if param then
		self.lodCfgScale = param.lodCfgScale
	end
end
function worldMapComLod:init()
	worldMapComLod.super.init(self)
	self.lod = nil
	self.lodFade = nil
	self.lodConfig = nil
	self.isNeedRefresh = false
	self.viewScrollView = self.target_.viewScrollView
end
local worldMapEvent = include("worldMapEvent")
_ENV = "worldMapEvent"
local _ENV, ("worldMapEvent").name, event_scroll = worldMapEvent.EVENT_SCROLL_ZOOM, worldMapEvent.EVENT_SCROLL_ZOOM, "worldMapEvent"
local worldMapEvent.EVENT_SCROLL_ZOOM.name, event_scroll_lod = worldMapEvent.EVENT_SCROLL_LOD_CHANGE, worldMapEvent.EVENT_SCROLL_ZOOM
function worldMapComLod:scrollViewDidScroll()
	local lodOld = self.lod
	local curScale = self.viewScrollView:getZoomScale()
	local lod = self:getLodCurrentScale(curScale)
	if lodOld ~= lod then
		event_scroll_lod.lodOld = lodOld
		event_scroll_lod.lod = lod
		self:dispatchEvent(event_scroll_lod)
	end
	local lodConfig = self.lodConfig
	local lodFade
	local percent = 0
	if lodConfig and lodConfig.fadeBegin and lodConfig.nextLod and curScale <= lodConfig.fadeBegin then
		lodFade = lodConfig.nextLod.lod
		percent = (lodConfig.fadeBegin - curScale) / (lodConfig.fadeBegin - lodConfig.nextLod.scale)
	end
	if self.lodFade ~= lodFade then
		local lodFadeOld = self.lodFade
		self.lodFade = lodFade
		if not lodFade and lodFadeOld then
			percent = lod >= lodFadeOld and 1 or 0
			lodFade = lodFadeOld
		end
	end
	event_scroll.lodFade = lodFade
	event_scroll.percent = percent
	event_scroll.lod = lod
	event_scroll.scale = curScale
	event_scroll.revertScale = 1 / curScale
	self:dispatchEvent(event_scroll)
end
function worldMapComLod:initScrollScale()
	self.target_.viewScrollView:registerScriptHandler(function()
		self.isNeedRefresh = true
	end, cc.SCROLLVIEW_SCRIPT_ZOOM)
	self:scrollViewDidScroll()
end
function worldMapComLod:onMessageListener()
	worldMapComLod.super.onMessageListener(self)
	self:addEventListener(worldMapEvent.EVENT_UPDATE_INFO, handler(self, self.updateInfo))
	self:initScrollScale()
end
function worldMapComLod:updateInfo()
	if self.isNeedRefresh then
		self.isNeedRefresh = false
		self:scrollViewDidScroll()
	end
end
local worldMapUtil = include("worldMapUtil")
function worldMapComLod:getLodCurrentScale(curScale)
	local config = worldMapUtil.getLodByScale(curScale, self.lodConfig or self.lodCfgScale[1])
	self.lodConfig = config
	self.lod = config and config.lod or 0
	return self.lod
end
function worldMapComLod:getCurLod()
	return self.lod or worldMapDefine.worldLodDef.LOD1
end
function worldMapComLod:exportMethods()
	_UPVALUE1_ = nil
	;(nil)[1] = "getCurLod"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComLod
