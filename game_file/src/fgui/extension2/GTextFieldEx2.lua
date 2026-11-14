local m = fgui.GTextField
function m:getDescription()
	return "GTextField"
end
function m:getMaxLength()
	print_warn("暂不处理GTextField:getMaxLength")
	return 0
end
function m:getPlaceHolder()
	print_warn("暂不处理GTextField:getPlaceHolder")
	return ""
end
function m:getString()
	return self:getText()
end
function m:getTextColor()
	return self:getColor()
end
function m:getTextHorizontalAlignment()
	return self.align
end
function m:getTextVerticalAlignment()
	return self.verticalAlign
end
function m:hitTest(pt, camera, p)
	print_warn("暂不处理GTextField:hitTest")
end
function m:init()
end
function m:setDetachWithIME(detach)
	print_warn("暂不处理GTextField:setDetachWithIME")
end
function m:setFontName(name)
	self.textFormat.font = name
	self:applyTextFormat()
end
function m:setMaxLength(length)
	print_warn("暂不处理GTextField:setMaxLength")
end
function m:setMaxLengthEnabled(enable)
	print_warn("暂不处理GTextField:setMaxLengthEnabled")
end
function m:setPasswordEnabled(enable)
	print_warn("暂不处理GTextField:setMaxLengthEnabled")
end
function m:setPlaceHolder(value)
	print_warn("暂不处理GTextField:setMaxLengthEnabled")
end
function m:setPlaceHolderColor(color)
	print_warn("暂不处理GTextField:setPlaceHolderColor")
end
function m:setString(text)
	self:setText(text)
end
function m:setTextAreaSize(...)
	self:setContentSize(...)
end
function m:setTextColor(textColor)
	if textColor.a then
		self:setColor4b(textColor)
	else
		self:setColor(textColor)
	end
end
function m:setTextHorizontalAlignment(alignment)
	self.align = alignment
end
function m:setAlignment(alignment)
	self.align = alignment
end
function m:setHorizontalAlignment(alignment)
	self.align = alignment
end
function m:setTextVerticalAlignment(alignment)
	self.verticalAlign = alignment
end
function m:setVerticalAlignment(alignment)
	self.verticalAlign = alignment
end
function m:setVerticalAlign(alignment)
	self.verticalAlign = alignment
end
function m:setTouchSize(size)
	print_warn("暂不处理GTextField:setTouchSize")
end
function m:update(dt)
end
function m:setTouchScaleChangeEnabled(value)
	print_warn("暂不处理GTextField:setTouchScaleChangeEnabled")
end
function m:setOverflow(overflow)
	if overflow == ccui.TextOverflowType.SHRINK then
		self:setAutoSize(fgui.AutoSizeType.Shrink)
	elseif overflow == ccui.TextOverflowType.RESIZE_HEIGHT then
		self:setAutoSize(fgui.AutoSizeType.Height)
	else
		self:setAutoSize(overflow)
	end
end
function m:getTextAreaSize()
	return self:getVirtualRendererSize()
end
function m:getTextAreaWidth()
	return self:getVirtualRendererSize().width
end
function m:getVirtualRendererSize()
	return cc.size(self.textWidth, self.textHeight)
end
function m:setSystemFontSize(fontSize)
	self:setFontSize(fontSize)
end
local _setTouchEnabled = m.setTouchEnabled
function m:setTouchEnabled(value)
	_setTouchEnabled(self, value)
	self:setTouchDisabled(not value)
end
