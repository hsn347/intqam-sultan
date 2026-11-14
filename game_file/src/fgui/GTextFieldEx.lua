local m = fgui.GTextField
function m:setString(value)
	self:setText(value)
end
function m:getTextColor()
	self:getColor()
end
function m:enableGradient(topColor, bottomColor)
	self:setUBBEnabled(true)
	local colorStr = string.format("%s,%s", SoraDRGB2HtmlColor(topColor), SoraDRGB2HtmlColor(bottomColor))
	_ENV = self
	self.color = colorStr
	self:setString(SoraDWrapHtmlTagByStyle(self:getText(), self))
end
local enableShadow_old = tolua.getcfunction(m, "enableShadow")
function m:enableShadow(shadowColor, offset)
	if shadowColor then
		local newColor = cc.c4b(shadowColor.r, shadowColor.g, shadowColor.b, 255)
		if offset then
			enableShadow_old(self, newColor, cc.p(offset.width, -offset.height))
		else
			enableShadow_old(self, newColor)
		end
	else
		enableShadow_old(self)
	end
end
local enableOutline_old = tolua.getcfunction(m, "enableOutline")
function m:enableOutline(outlineColor, outlineSize)
	local newColor = cc.c4b(outlineColor.r, outlineColor.g, outlineColor.b, 255)
	enableOutline_old(self, newColor, outlineSize)
end
function m:getTouchMetaInfo(touchPoint)
end
