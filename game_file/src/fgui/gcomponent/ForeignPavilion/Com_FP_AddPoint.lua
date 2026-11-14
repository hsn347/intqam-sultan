local baseComponent = require("fgui.base.baseComponent")
local Com_FP_AddPoint = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ForeignPavilion/Com_FP_AddPoint", Com_FP_AddPoint)
function Com_FP_AddPoint:onInit()
end
function Com_FP_AddPoint:onShow()
end
function Com_FP_AddPoint:addPoint(point)
	self:setVisible(true)
	self:stopAllActions()
	self.controllers.c1:setSelectedIndex(0 < point and 1 or 0)
	if 0 < point then
		self.fields.text_point:setString("*" .. point)
		self:setAlpha(1)
		self.fields.bg:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.fields.bg:setVisible(true)
		self.transitions.point:play(function()
			self.fields.bg:setVisible(false)
			self:setVisible(false)
		end)
	else
		self:setAlpha(1)
		self.fields.bg:setVisible(false)
		self.transitions.miss:play(function()
			self:setVisible(false)
		end)
	end
end
return Com_FP_AddPoint
