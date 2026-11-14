local BaseText = class("BaseText", function(target)
	return target or fgui.GLabel.CreateLabel()
end)
function cloneBaseText(target)
	BaseText.new(target)
end
function BaseText:ctor()
	self.__title = self:getChild("title")
end
function BaseText:create(str, fontName, fontSize)
	local ret = BaseText.new()
	if fontName and string.len(fontName) > 0 then
		ret:setFontName(fontName)
	end
	if fontSize then
		ret:setFontSize(fontSize)
	end
	if str then
		ret:setString(str)
	end
	return ret
end
function BaseText:createWithSystemFont(text, font, size, dimensions, textAlign, textValign)
	local baseText = BaseText:create()
	baseText:setFontName(font)
	baseText.__title.align = textAlign
	baseText.__title.verticalAlign = textValign
	baseText:setFontSize(size)
	baseText:setDimensions(dimensions)
	baseText:setString(text)
	return baseText
end
function BaseText:createWithTTF(text, font, size, dimensions, textAlign, textValign)
	return BaseText:createWithSystemFont(text, font, size, dimensions, textAlign, textValign)
end
function BaseText:createWithBMFont(font, text, textAlign, maxLineW, pos)
	local baseText = BaseText:create()
	baseText:setFontSize(0)
	baseText:setFontName(font)
	baseText.__title.align = textAlign
	if maxLineW and 0 < maxLineW then
		baseText:setWidth(maxLineW)
		baseText.__title.autoSize = fgui.AutoSizeType.Height
	end
	if text then
		baseText:setString(text)
	end
	if pos then
		baseText:setPosition(pos)
	end
	return baseText
end
function BaseText:createWithCharMap(pngFile, itemWidth, itemHeight, startCharMap)
	local baseText = BaseText:create()
	local fontName = string.gsub(pngFile, ".png", ".fnt")
	baseText:setFontName("res/" .. fontName)
	baseText:setContentSize(cc.size(itemWidth, itemHeight))
	baseText:setFontSize(50)
	return baseText
end
function BaseText:setIsHtml(...)
	self.__title:setIsHtml(...)
end
function BaseText:setOverflow(overflow)
	if overflow == ccui.TextOverflowType.SHRINK then
		self:setAutoSize(fgui.AutoSizeType.Shrink)
	elseif overflow == ccui.TextOverflowType.RESIZE_HEIGHT then
		self:setAutoSize(fgui.AutoSizeType.Height)
	else
		error("undefined overflow type" .. overflow)
	end
end
function BaseText:getDescription()
	return self.__title:getDescription()
end
function BaseText:getMaxLength()
	return self.__title:getMaxLength()
end
function BaseText:getPlaceHolder()
	return self.__title:getPlaceHolder()
end
function BaseText:getString()
	return self.__title:getString()
end
function BaseText:getTextColor()
	return self.__title:getTextColor()
end
function BaseText:getTextHorizontalAlignment()
	return self.__title:getTextHorizontalAlignment()
end
function BaseText:getTextVerticalAlignment()
	return self.__title:getTextVerticalAlignment()
end
function BaseText:getVirtualRenderer()
	return self.__title
end
function BaseText:getVirtualRendererSize()
	return self.__title:getVirtualRendererSize()
end
function BaseText:hitTest(pt, camera, p)
	return self.__title:hitTest(pt, camera, p)
end
function BaseText:init()
	return self.__title:init()
end
function BaseText:setDetachWithIME(detach)
	return self.__title:setDetachWithIME(detach)
end
function BaseText:setFontName(name)
	return self.__title:setFontName(name)
end
function BaseText:setFontSize(name)
	return self.__title:setFontSize(name)
end
function BaseText:setMaxLength(length)
	return self.__title:setMaxLength(length)
end
function BaseText:setMaxLengthEnabled(enable)
	return self.__title:setMaxLengthEnabled(enable)
end
function BaseText:setPasswordEnabled(enable)
	return self.__title:setPasswordEnabled(enable)
end
function BaseText:setPlaceHolder(value)
	return self.__title:setPlaceHolder(value)
end
function BaseText:setPlaceHolderColor(color)
	return self.__title:setPlaceHolderColor(color)
end
function BaseText:setString(text)
	self.__title:setString(text)
end
function BaseText:setSkewX(value)
	self.__title:setSkewX(value)
end
function BaseText:getSkewX(value)
	return self.__title:getSkewX(value)
end
function BaseText:getSkewY(value)
	return self.__title:getSkewY(value)
end
function BaseText:setSkewY(value)
	self.__title:setSkewY(value)
end
function BaseText:getParsedText()
	return self.__title:getParsedText()
end
function BaseText:setTextColor(textColor)
	return self.__title:setTextColor(textColor)
end
function BaseText:setColor(textColor)
	return self.__title:setColor(textColor)
end
function BaseText:setTextHorizontalAlignment(alignment)
	return self.__title:setTextHorizontalAlignment(alignment)
end
function BaseText:setTextVerticalAlignment(alignment)
	return self.__title:setTextVerticalAlignment(alignment)
end
function BaseText:setAlignment(alignment)
	return self.__title:setAlignment(alignment)
end
function BaseText:setHorizontalAlignment(alignment)
	return self.__title:setHorizontalAlignment(alignment)
end
function BaseText:setVerticalAlignment(alignment)
	return self.__title:setVerticalAlignment(alignment)
end
function BaseText:setTouchSize(size)
	return self.__title:setTouchSize(size)
end
function BaseText:update(dt)
	return self.__title:update(dt)
end
function BaseText:setIsDebugEnable()
end
function BaseText:enableCache()
end
function BaseText:isEnableCache()
end
function BaseText:setIsGenerateMetaInfo()
end
function BaseText:getSystemFontSize()
	return 12
end
function BaseText:getVirtualRendererMetaInfos()
	return nil
end
function BaseText:getHorizontalAlignment(alignment)
	return self.__title:getTextHorizontalAlignment(alignment)
end
function BaseText:getVerticalAlignment(alignment)
	return self.__title:getTextVerticalAlignment(alignment)
end
function BaseText:enableOutline(color, lineValue)
	self.__title.strokeColor = color
	self.__title.stroke = lineValue
end
local _clone = fgui.GLabel.clone
function BaseText:clone()
	local ret = _clone(self)
	return BaseText.new(ret)
end
return BaseText
