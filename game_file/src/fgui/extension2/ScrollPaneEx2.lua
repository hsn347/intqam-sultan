local m = fgui.ScrollPane
function m:getContentSize()
	return cc.size(self.contentWidth, self.contentHeight)
end
function m:getViewSize()
	return cc.size(self.viewWidth, self.viewHeight)
end
function m:getPosition()
	return cc.p(self:getPositionX(), self:getPositionY())
end
function m:removeAllChildren(...)
	self.owner:removeAllChildren(...)
end
function m:addChild(...)
	self.owner:addChild(...)
end
function m:setZoomScale(scale)
	self.owner:setZoomScale(scale)
end
function m:scrollToView(obj, ani, setFirst)
	if type(obj) == "table" then
		self:scrollToViewRect(obj, ani, setFirst)
	else
		self:scrollToViewObj(obj, ani, setFirst)
	end
end
