local baseComponent = require("fgui.base.baseComponent")
local effect_float = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SanctuaryDivine/effect_float", effect_float)
function effect_float:onInit()
end
function effect_float:onShow()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(1.2 + math.random(0, 8) / 10)
	;(nil)[2] = ffa.callFunc(function()
		self:moveAct()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self:moveAct()
	end)
	;(nil)[4] = ffa.callFunc(function()
		self:moveAct()
	end)
	self:runAction(ffa.seq(nil))
end
function effect_float:moveAct()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.moveTo(1, 83, 74)
	;(nil)[2] = ffa.moveTo(1, 83, 70)
	;(nil)[3] = ffa.moveTo(1, 83, 70)
	;(nil)[4] = ffa.moveTo(1, 83, 70)
	;(nil)[5] = ffa.moveTo(1, 83, 70)
	self.fields.icon:runAction(ffa.repeatForever(ffa.seq(nil)))
end
return effect_float
