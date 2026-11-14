local baseComponent = require("fgui.base.baseComponent")
local Com_advance = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Chaser/Com_advance", Com_advance)
function Com_advance:onInit()
	self.controllers.c1:setSelectedIndex(SoraDFIsRA() and 0 or 1)
	self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	self.transitions.t0:setHook("endShow", function()
		self:setVisible(false)
	end)
end
function Com_advance:onShow()
end
function Com_advance:playAct()
	self:setVisible(true)
	self.transitions.t0:play(1, 0, 0, -1)
	self.fields.Usm_1:play(false)
end
return Com_advance
