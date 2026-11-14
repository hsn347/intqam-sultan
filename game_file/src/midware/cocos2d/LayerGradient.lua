local LayerGradient = class("LayerGradient", cc.Node)
function LayerGradient:create(startColor, endColor, vec)
	vec = vec or cc.p(0, -1)
	local ret = fgui.GComponent:create()
	ret:setBackGroundGradient(startColor, endColor, vec)
	ret:setContentSize(display.width, display.height)
	return ret
end
function LayerGradient:draw(renderer, transform, flags)
	error("LayerGradient:draw", renderer, transform, flags)
end
local _setContentSize = cc.Node.setContentSize
function LayerGradient:setContentSize(size)
	_setContentSize(self, size)
	if self.__background_color__ then
		self.__background_color__:setContentSize(size)
	end
end
return LayerGradient
