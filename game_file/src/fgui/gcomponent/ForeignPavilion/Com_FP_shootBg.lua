local baseComponent = require("fgui.base.baseComponent")
local Com_FP_shootBg = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ForeignPavilion/Com_FP_shootBg", Com_FP_shootBg)
function Com_FP_shootBg:onInit()
	self.orginPos = self.fields.target:getPosition()
end
function Com_FP_shootBg:onShow()
	self.fields.target:stopAllActions()
	_UPVALUE1_ = self.fields.target
	self.fields.target[1] = ffa.moveBy(4, cc.p(250, 0))
	self.fields.target[2] = ffa.moveBy(4, cc.p(-250, 0))
	self.fields.target[3] = ffa.moveBy(4, cc.p(-250, 0))
	self.fields.target[4] = ffa.moveBy(4, cc.p(-250, 0))
	self.fields.target[5] = ffa.moveBy(4, cc.p(-250, 0))
	self.fields.target[6] = ffa.moveBy(4, cc.p(-250, 0))
	local seq = ffa.seq(self.fields.target)
	self.fields.target:setPositionX(self.orginPos.x - 100)
	self.fields.target:runAction(ffa.repeatForever(ffa.seq(seq)))
end
function Com_FP_shootBg:getTargetPos()
	local pos = cc.p(120, 115)
	pos = self.fields.target:convertToWorldSpace(pos)
	pos.y = pos.y + 18.5
	return pos
end
function Com_FP_shootBg:gameStart()
end
return Com_FP_shootBg
