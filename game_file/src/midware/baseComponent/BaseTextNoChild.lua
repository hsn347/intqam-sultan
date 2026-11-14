local m = fgui.GTextField
local BaseTextNoChild = class("BaseTextNoChild", function(target)
	return target or fgui.GTextField.CreateLabel()
end)
function cloneBaseText(target)
	BaseTextNoChild.new(target)
end
function BaseTextNoChild:ctor()
end
function BaseTextNoChild:create(str, fontName, fontSize)
	local ret = BaseTextNoChild.new()
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
function BaseTextNoChild:createWithSystemFont(text, font, size, dimensions, textAlign, textValign)
	local baseText = BaseTextNoChild:create()
	baseText:setFontName(font)
	baseText.align = textAlign
	baseText.verticalAlign = textValign
	baseText:setFontSize(size)
	baseText:setDimensions(dimensions)
	baseText:setString(text)
	return baseText
end
function BaseTextNoChild:createWithTTF(text, font, size, dimensions, textAlign, textValign)
	return BaseTextNoChild:createWithSystemFont(text, font, size, dimensions, textAlign, textValign)
end
function BaseTextNoChild:createWithBMFont(font, text, textAlign, maxLineW, pos)
	local baseText = BaseTextNoChild:create()
	baseText:setFontSize(0)
	baseText:setFontName(font)
	baseText.align = textAlign
	if maxLineW and 0 < maxLineW then
		baseText:setWidth(maxLineW)
		baseText.autoSize = fgui.AutoSizeType.Height
	end
	if text then
		baseText:setString(text)
	end
	if pos then
		baseText:setPosition(pos)
	end
	return baseText
end
function BaseTextNoChild:createWithCharMap(pngFile, itemWidth, itemHeight, startCharMap)
	local baseText = BaseTextNoChild:create()
	local fontName = string.gsub(pngFile, ".png", ".fnt")
	baseText:setFontName(fontName)
	baseText:setContentSize(cc.size(itemWidth, itemHeight))
	baseText:setFontSize(50)
	return baseText
end
function BaseTextNoChild:setOverflow(overflow)
	if overflow == ccui.TextOverflowType.SHRINK then
		self:setAutoSize(fgui.AutoSizeType.Shrink)
	elseif overflow == ccui.TextOverflowType.RESIZE_HEIGHT then
		self:setAutoSize(fgui.AutoSizeType.Height)
	else
		error("undefined overflow type" .. overflow)
	end
end
function BaseTextNoChild:updateSkewPosition()
	local skewX = self:getSkewX()
	local skewY = self:getSkewY()
	local anchorPoint = self:getAnchorPoint()
	if skewY ~= 0 and anchorPoint.y == 0.5 then
		local size = self:getContentSize()
		self:setPositionY(size.width * 0.2)
	end
end
function BaseTextNoChild:setIsDebugEnable()
end
function BaseTextNoChild:enableCache()
end
function BaseTextNoChild:isEnableCache()
end
function BaseTextNoChild:setIsGenerateMetaInfo()
end
function BaseTextNoChild:getSystemFontSize()
	return 12
end
function BaseTextNoChild:getVirtualRendererMetaInfos()
	return nil
end
function BaseTextNoChild:getHorizontalAlignment(alignment)
	return self:getTextHorizontalAlignment(alignment)
end
function BaseTextNoChild:getVerticalAlignment(alignment)
	return self:getTextVerticalAlignment(alignment)
end
local _clone = m.clone
function BaseTextNoChild:clone()
	local ret = _clone(self)
	return BaseTextNoChild.new(ret)
end
return BaseTextNoChild
