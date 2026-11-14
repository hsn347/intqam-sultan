local baseComponent = require("fgui.base.baseComponent")
local Com_scrollpane_zoom = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_scrollpane_zoom", Com_scrollpane_zoom)
function Com_scrollpane_zoom:onInit()
end
function Com_scrollpane_zoom:onShow()
	self.isShow = true
	self:initScroll()
end
function Com_scrollpane_zoom:initScroll()
	if not self.isShow or not self.data then
		return
	end
	self:setScroll(self.data.scroll)
	self.innerSize = self.data.innerSize or cc.size(self.scroll:getSize().width, self.scroll:getSize().height)
	if self.data.minScale then
		self.scroll:setMinScale(self.data.minScale)
	end
	if self.data.maxScale then
		self.scroll:setMaxScale(self.data.maxScale)
	end
	if self.data.zoomScale then
		self:setZoomScale(self.data.zoomScale)
	end
	if self.data.afterInitScroll then
		self.data.afterInitScroll()
	end
end
function Com_scrollpane_zoom:initData(data)
	self.data = data
	self.zoomScale = data.zoomScale or 1.0
	self:initScroll()
end
function Com_scrollpane_zoom:setScroll(scroll)
	self.scroll = scroll
	self.scroll:setZoomEnable(true)
	self.scroll:registerScriptHandler(handler(self, self.scrollViewDidZoom), cc.SCROLLVIEW_SCRIPT_ZOOM)
end
function Com_scrollpane_zoom:setCallback(handler)
	self.callback = handler
end
function Com_scrollpane_zoom:setZoomScale(zoomScale)
	self.zoomScale = zoomScale
	self.scroll:setZoomScale(zoomScale)
end
function Com_scrollpane_zoom:getZoomScale()
	return self.zoomScale
end
function Com_scrollpane_zoom:scrollViewDidZoom()
	local zoomScale = self.scroll:getZoomScale()
	print("Com_scrollpane_zoom:scrollViewDidZoom", zoomScale)
	self.zoomScale = zoomScale
	local scrollPane = self.scroll:getScrollPane()
	if self.callback then
		self.callback(zoomScale)
	end
end
return Com_scrollpane_zoom
