local baseComponent = require("fgui.base.baseComponent")
local Com_9001630_icon = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001630_Read = include("activity_9001630_Read")
fgui.register_extension("ui://Activity_9001630/Com_9001630_icon", Com_9001630_icon)
function Com_9001630_icon:onInit()
end
function Com_9001630_icon:onShow()
end
function Com_9001630_icon:initData(index, isEffectVisible)
	local cfg = activity_9001630_Read.getCardCfg(index)
	self.index = index
	self.shwoIcon = cfg.iocn
end
function Com_9001630_icon:setEffectScale(isEffectVisible)
	self:setScale(isEffectVisible and 1.15 or 1)
	self.transitions.t0:play(1, 0, 0, 0)
end
function Com_9001630_icon:resetEffect(index)
	self:setAlpha(1)
	self.fields.icon:setScale(1)
	self.fields.icon:stopAllActions()
	self.fields.icon:setIcon(self.shwoIcon)
	self.fields.icon:setAlpha(0)
	local scale = self:getScale()
	local _ENV, seq = self, self
	table.insert(seq, ffa.delay(0.4 + index * 0.1))
	table.insert(seq, ffa.callFunc(function()
		self.controllers.c1:setSelectedIndex(self.index - 1)
		self.fields.ani_fire:setVisible(true)
		self.fields.ani_fire:setAlpha(1)
		self.fields.ani_fire:setAllFrameName("9001630_trail_%02d.png", 1)
		self.fields.ani_fire:setPlaySettings(0, -1, 1, -1)
		self.fields.ani_fire:runAction(ffa.seq(ffa.delay(0.7), ffa.fadeOut(0.1)))
	end))
	table.insert(seq, ffa.delay(0.7))
	table.insert(seq, ffa.spawn(ffa.seq(ffa.scaleTo(0, 0.14 * scale), ffa.scaleTo(0.1, 1.14 * scale), ffa.scaleTo(0.13333333333333333, 1.0 * scale)), ffa.fadeIn(0.23333333333333334)))
	table.insert(seq, ffa.fadeOut(5))
	self.fields.icon:runAction(ffa.seq(seq))
end
return Com_9001630_icon
