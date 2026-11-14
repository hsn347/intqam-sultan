local baseComponent = require("fgui.base.baseComponent")
local Com_rewardBox = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonNew/Com_rewardBox", Com_rewardBox)
_ENV = fgui.register_extension
fgui.register_extension[1] = cc.p(90, 100)
fgui.register_extension[2] = cc.p(90, 98)
fgui.register_extension[3] = cc.p(90, 92)
fgui.register_extension[4] = cc.p(90, 90)
fgui.register_extension[5] = cc.p(90, 90)
fgui.register_extension[6] = cc.p(90, 68)
fgui.register_extension[7] = cc.p(90, 68)
local fgui.register_extension[8], boxETPos = cc.p(90, 86), fgui.register_extension
function Com_rewardBox:onInit()
	self.style = 1
	self.status = gBtnTargetStatusDef.GO
end
function Com_rewardBox:onShow()
end
function Com_rewardBox:initStyle(style)
	self.style = math.min(8, style)
end
function Com_rewardBox:setStatus(status)
	self.status = status
	local boxStr = "closed"
	if self.status == gBtnTargetStatusDef.GET then
		boxStr = "open"
	elseif self.status == gBtnTargetStatusDef.GOT then
		boxStr = "FullyOpen"
	end
	self.fields.Effect_et:setEffectPath(self.style == 8 and "Node_boxGet_8" or "Node_boxGet_5")
	self.controllers.c1:setSelectedIndex(self.status)
	self.fields.Effect_et:setVisible(self.status == gBtnTargetStatusDef.GET)
	self.fields.icon:setSpriteFrame(string.format("icon_lshs_common_%.2d_%s.png", self.style, boxStr))
	self.fields.Effect_et:setPosition(boxETPos[self.style])
end
return Com_rewardBox
