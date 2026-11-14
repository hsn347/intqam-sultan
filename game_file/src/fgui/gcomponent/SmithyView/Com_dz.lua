local baseComponent = require("fgui.base.baseComponent")
local Com_dz = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/Com_dz", Com_dz)
function Com_dz:onInit()
	self.fields.n1:setAllFrameName("dh_zhaiyueqd7_%.3d.png", 0)
	self.fields.n1:setVisible(false)
	self.fields.n0:setAlpha(0)
end
function Com_dz:onShow()
end
function Com_dz:playAct()
	self.fields.n0:stopAllActions()
	self.fields.n0:setAlpha(0)
	self.fields.n1:setVisible(false)
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.fadeIn(0.16666666666666666)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.n1:setVisible(true)
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.n1:setVisible(true)
	end)
	self.fields.n0:runAction(ffa.seq(nil))
end
return Com_dz
