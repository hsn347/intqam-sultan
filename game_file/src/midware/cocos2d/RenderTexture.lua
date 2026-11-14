local m = class("RenderTexture", cc.Node)
_gBeginingRenderTexture = nil
function m:create(w, h, format, depthStencilFormat)
	local node = m.new()
	if node then
		node:autoRelease()
		node:setAnchorPoint(0.5, 0.5)
		node:setContentSize(w, h)
		node:setPosition(0, 0)
		node:setAutoDraw(true)
		node:setFormat(format)
		node:setIsUseDepth(depthStencilFormat)
	end
	return node
end
function m:setFormat(value)
	self.format = value
end
function m:setIsUseDepth(value)
	self.depthStencilFormat = value ~= nil
end
function m:setSprite(sprite)
end
function m:getSprite()
	return self
end
function m:isAutoDraw()
	return self:isCacheAsBitmap()
end
function m:setAutoDraw(isAutoDraw)
	self:setCacheAsBitmap(isAutoDraw)
end
function m:hideSelf()
	self:setLayer(_G.fgui.CaptureCamera.hiddenLayer)
end
function m:getClearDepth()
end
function m:setClearDepth(clearDepth)
end
function m:getClearFlags()
end
function m:setClearFlags(clearFlags)
end
function m:getClearStencil()
end
function m:setClearStencil(clearStencil)
end
function m:clearStencil(stencilValue)
end
function m:getClearColor()
end
function m:setClearColor(clearColor)
end
function m:setVirtualViewport(rtBegin, fullRect, fullViewport)
	self._rtBegin = rtBegin
	self._fullRect = fullRect
	self._fullViewport = fullViewport
	self:setAnchorPoint(0, 0)
	self:setContentSize(cc.size(fullRect.width, fullRect.height))
	self:setPosition(cc.p(rtBegin.x * fullViewport.width / fullRect.width, rtBegin.y * fullViewport.height / fullRect.height))
end
function m:setSaveScale(scale)
	self._fScale = scale
end
function m:begin()
end
function m:setKeepMatrix(keepMatrix)
end
function m:saveToFile(filename, format, isRGBA, callback)
	self:saveTextureToFile(filename, self._fScale and self._fScale or 1.0)
end
function m:endToLua()
	local isNeedRemove = false
	if self:getParent() == nil then
		isNeedRemove = true
		if not self._rtBegin then
			self:setPosition(display.width / 2, display.height / 2)
		end
		self:addTo(display:getRunningScene())
	end
	self:endVisit()
	if isNeedRemove then
		_UPVALUE1_ = display:getRunningScene()
		display:getRunningScene()[1] = cca.delay(0.1)
		display:getRunningScene()[2] = cca.callFunc(function()
			self:removeFromParent()
		end)
		display:getRunningScene()[3] = cca.callFunc(function()
			self:removeFromParent()
		end)
		self:runAction(cca.seq(display:getRunningScene()))
	end
	CS.FairyGUI.UIConfig.depthSupportForPaintingMode = self._depthSupportForPaintingMode
	_gBeginingRenderTexture = nil
end
function m:beginWithClear(r, g, b, a, depthValue, stencilValue)
	self._depthSupportForPaintingMode = CS.FairyGUI.UIConfig.depthSupportForPaintingMode
	CS.FairyGUI.UIConfig.depthSupportForPaintingMode = self.depthStencilFormat
	self:beginVisit()
	_gBeginingRenderTexture = self
end
function m:clearDepth(depthValue)
end
function m:clear(r, g, b, a)
end
function m:newImage()
end
function m:initWithWidthAndHeight(w, h, format, depthStencilFormat)
end
function m:draw(renderer, transform, flags)
end
function m:visit(renderer, parentTransform, parentFlags)
end
function m:setProjection()
end
return m
