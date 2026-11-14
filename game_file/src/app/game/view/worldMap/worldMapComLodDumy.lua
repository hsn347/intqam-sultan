local worldMapComLodDumy = class("worldMapComLodDumy", include("worldMapComLodBase"))
function worldMapComLodDumy:ctor()
	worldMapComLodDumy.super.ctor(self, "worldMapComLodDumy")
end
function worldMapComLodDumy:init()
	worldMapComLodDumy.super.init(self)
	self.lod = worldMapDefine.worldLodDef.LOD1
	self.viewScrollView = self.target_.viewScrollView
end
function worldMapComLodDumy:getCurLod()
	return self.lod or worldMapDefine.worldLodDef.LOD1
end
function worldMapComLodDumy:onMessageListener()
	worldMapComLodDumy.super.onMessageListener(self)
	local worldMapEvent = include("worldMapEvent")
	worldMapComLodDumy = "worldMapEvent"
	local worldMapComLodDumy, ("worldMapEvent").name, event_scroll = worldMapEvent.EVENT_SCROLL_ZOOM, worldMapEvent.EVENT_SCROLL_ZOOM, "worldMapEvent"
	local worldMapEvent.EVENT_SCROLL_ZOOM.name, event_scroll_lod = worldMapEvent.EVENT_SCROLL_LOD_CHANGE, worldMapEvent.EVENT_SCROLL_ZOOM
	local lod = self.lod
	event_scroll_lod.lodOld = lod
	event_scroll_lod.lod = lod
	self:dispatchEvent(event_scroll_lod)
	local scrollViewDidScroll = function()
		local lod = self.lod
		local curScale = self.viewScrollView:getZoomScale()
		event_scroll.lod = lod
		event_scroll.scale = curScale
		event_scroll.revertScale = 1 / curScale
		self:dispatchEvent(event_scroll)
	end
	self.target_.viewScrollView:registerScriptHandler(scrollViewDidScroll, cc.SCROLLVIEW_SCRIPT_ZOOM)
	scrollViewDidScroll()
end
function worldMapComLodDumy:exportMethods()
	_UPVALUE1_ = nil
	;(nil)[1] = "getCurLod"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComLodDumy
