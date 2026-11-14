local LayerColor = class("LayerColor", cc.Node)
function LayerColor:create(color, width, height)
	local ret = fgui.GComponent:create()
	width = width or display.width
	height = height or display.height
	ret:setBackGroundColor(color)
	ret:setOpacity(color.a)
	ret:setContentSize(width, height)
	return ret
end
function LayerColor:draw(renderer, transform, flags)
	error("LayerColor:draw", renderer, transform, flags)
end
local _setContentSize = cc.Node.setContentSize
function LayerColor:setContentSize(size)
	_setContentSize(self, size)
	if self.__background_color__ then
		self.__background_color__:setContentSize(size)
	end
end
return LayerColor
