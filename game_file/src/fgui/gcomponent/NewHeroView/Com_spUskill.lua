local baseComponent = require("fgui.base.baseComponent")
local Com_spUskill = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_spUskill", Com_spUskill)
function Com_spUskill:onInit()
	self.fields.bar:setScaleX(SoraDFIsRA() and 1 or -1)
end
function Com_spUskill:onShow()
end
function Com_spUskill:initData(isUnlock, herIcon, percent)
	self.controllers.c1:setSelectedIndex(isUnlock and 1 or 0)
	self.fields.icon:setSpriteFrame(herIcon)
	self.fields.icon:setGrayed(not isUnlock)
	self.fields.farm:setGrayed(not isUnlock)
	if isUnlock then
		self.fields.bar:setPercent(percent / 100)
	end
end
return Com_spUskill
