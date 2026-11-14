local CCScrollView = fgui.extension_class("CCScrollView", fgui.GComponent)
fgui.register_extension("ui://Base/CCScrollView", CCScrollView)
function CCScrollView:create(size)
	local scrollView = fgui.UIPackage.CreateObject1("Base", "CCScrollView")
	scrollView.isCocos = true
	scrollView.isCCScrollView = true
	scrollView:setZoomEnable(true)
	scrollView:setPosition(0, 0)
	scrollView:setBubbleTouchesDisable(true)
	scrollView:getScrollPane().isCustomInnerContainerSize = false
	if size then
		scrollView:setViewSize(size)
	end
	return scrollView
end
function CCScrollView:getViewSize()
	return self:getSize()
end
function CCScrollView:setViewSize(size)
	self:setSize(size)
end
function CCScrollView:getContentSize()
	return self:getScrollPane():getContentSize()
end
function CCScrollView:setContentSize(size)
	self:getScrollPane():setContentSize(size.width, size.height)
end
function CCScrollView:registerScriptHandler(callback, type)
	if type == cc.SCROLLVIEW_SCRIPT_SCROLL then
		self:getScrollPane().onScroll:Add(function()
			callback(self, type)
		end)
	elseif type == cc.SCROLLVIEW_SCRIPT_ZOOM then
		self:getScrollPane():AddEventListener1(fgui.UIEventType.onScrollViewDidZoom, callback)
	else
		error("CCScrollView:registerScriptHandler, undefined type" .. type)
	end
end
function CCScrollView:setIgnoreOverLapSize(value)
	self:getScrollPane():setIgnoreOverLapSize(value)
end
function CCScrollView:setDecelerationRate(value)
	self:getScrollPane():setDecelerationRate(value)
end
function CCScrollView:setFixMaxPos(value)
	local scrollPane = self:getScrollPane()
	if scrollPane and scrollPane.setFixMaxPos then
		scrollPane:setFixMaxPos(value)
	end
end
return CCScrollView
