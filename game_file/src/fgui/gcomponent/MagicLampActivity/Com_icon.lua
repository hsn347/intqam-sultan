local baseComponent = require("fgui.base.baseComponent")
local Com_icon = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampActivity/Com_icon", Com_icon)
function Com_icon:onInit()
	self.fields.Movie_Effect:setAllFrameName("dh_shendengyd_%.2d.png", 1)
	self.fields.Movie_Effect1:setAllFrameName("dh_sdyddj_%.2d.png", 1)
end
function Com_icon:onShow()
end
function Com_icon:initData(index, isEffectVisible)
	self.fields.icon:setIcon(string.format("jinn_skill_image_%d.png", index))
	self.fields.Movie_Effect:setVisible(isEffectVisible or false)
	self.fields.Movie_Effect1:setVisible(false)
end
function Com_icon:setEffectScale(isEffectVisible)
	self:setScale(isEffectVisible and 1.15 or 1)
	self.transitions.t0:play(1, 0, 0, 0)
end
function Com_icon:resetEffect()
	self.transitions.t0:play(1, 0, 0, 0)
	self:setScale(1)
	self.fields.Movie_Effect1:setVisible(false)
	self:stopAllActions()
	self.fields.Movie_Effect:setVisible(false)
end
function Com_icon:playEffect()
	self.fields.Movie_Effect1:setPlaySettings(0, -1, 1, -1)
	self.transitions.t0:play(1, 0)
	_UPVALUE1_ = 0
	;(0)[1] = ffa.delay(0.5)
	;(0)[2] = ffa.callFunc(function()
		self.fields.Movie_Effect:setVisible(true)
	end)
	;(0)[3] = ffa.callFunc(function()
		self.fields.Movie_Effect:setVisible(true)
	end)
	self:runAction(ffa.seq(0))
	self.fields.Movie_Effect1:setVisible(true)
end
return Com_icon
