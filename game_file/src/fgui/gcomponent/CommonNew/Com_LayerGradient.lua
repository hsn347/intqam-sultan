local baseComponent = require("fgui.base.baseComponent")
local Com_LayerGradient = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonNew/Com_LayerGradient", Com_LayerGradient)
function Com_LayerGradient:onInit()
	self.fields.title:setVisible(false)
	local clrLayer = cc.LayerGradient:create(cc.c3b(29, 23, 21), cc.c3b(33, 29, 29))
	clrLayer:addTo(self:displayObject())
	self.clrLayer = clrLayer
end
function Com_LayerGradient:onShow()
	self.clrLayer:setContentSize(self:getSize())
end
function Com_LayerGradient:setGradientColor(startColor, endColor)
	self:setStartColor(startColor)
	self:setEndColor(endColor)
end
function Com_LayerGradient:setStartColor(startColor)
	if startColor then
		if type(startColor) == "string" then
			startColor = SoraDHtmlColor2RGB(startColor)
		end
		self.clrLayer:setStartColor(startColor)
	end
end
function Com_LayerGradient:setEndColor(endColor)
	if endColor then
		if type(endColor) == "string" then
			endColor = SoraDHtmlColor2RGB(endColor)
		end
		self.clrLayer:setEndColor(endColor)
	end
end
return Com_LayerGradient
