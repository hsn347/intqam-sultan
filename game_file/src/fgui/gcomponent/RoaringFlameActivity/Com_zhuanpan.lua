local baseComponent = require("fgui.base.baseComponent")
local Com_zhuanpan = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameActivity/Com_zhuanpan", Com_zhuanpan)
function Com_zhuanpan:onInit()
end
function Com_zhuanpan:onShow()
end
function Com_zhuanpan:playAni(rotation, handle)
	self.transitions.t0:play(1, 0, 0, -1)
	_UPVALUE2_ = 0
	;(0)[1] = ffa.exponentialInOut(ffa.rotateTo(2.7, rotation))
	;(0)[2] = ffa.delay(0.3)
	;(0)[3] = ffa.callFunc(handle)
	;(0)[4] = ffa.callFunc(handle)
	self:runAction(ffa.seq(0))
end
return Com_zhuanpan
