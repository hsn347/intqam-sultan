local m = fgui.GLabel
function m:loadTexture(...)
	local icon = self:getChild("icon")
	if icon then
		icon:loadTexture(...)
	end
end
function m:setTextHorizontalAlignment(alignment)
	local title = self:getChild("title")
	if title then
		title:setTextHorizontalAlignment(alignment)
	end
end
function m:setSpriteFrame(...)
	local icon = self:getChild("icon")
	if icon then
		icon:setSpriteFrame(...)
	end
end
function m:enableShadow(...)
	local title = self:getChild("title")
	if title then
		title:enableShadow(...)
	end
end
function m:setTouchScaleChangeEnabled(value)
	print_warn("暂不处理setTouchScaleChangeEnabled")
end
function m:setAlignment(value)
	self:setTextHorizontalAlignment(alignment)
end
function m:setTextAreaSize(...)
	self:setDimensions(...)
end
function m:setDimensions(wv, hv)
	local w, h
	if hv then
		w, h = wv, hv
	else
		w, h = wv.width, wv.height
	end
	if 0 < w and 0 < h then
		self:setAutoSize(fgui.AutoSizeType.SHRINK)
	elseif w <= 0 then
		self:setAutoSize(fgui.AutoSizeType.BOTH)
	elseif h <= 0 then
		self:setAutoSize(fgui.AutoSizeType.HEIGHT)
	end
	self:setContentSize(w, h)
end
function m:setContentSize(wv, hv)
	if hv then
		self:setLabelSize(wv, hv)
	else
		self:setLabelSize(wv.width, wv.height)
	end
end
function m:getTextAreaSize(...)
	return self.TitleObject:getTextAreaSize(...)
end
function m:getVirtualRendererSize(...)
	if self.TitleObject then
		return self.TitleObject:getVirtualRendererSize(...)
	else
		if self.IconObject then
			return self.IconObject:getVirtualRendererSize(...)
		else
		end
	end
end
function m:setSystemFontSize(...)
	return self.TitleObject:setSystemFontSize(...)
end
function m:setTile(...)
	self.IconObject:setTile(...)
end
function m:setFillType(...)
	self.IconObject:setFillType(...)
end
function m:getGLProgramState()
	if self.IconObject then
		return self.IconObject.material
	end
end
