local baseComponent = require("fgui.base.baseComponent")
local Com_stage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Chaser/Com_stage", Com_stage)
function Com_stage:onInit()
	self.fields.Text_stage:setString(i18n("Weapon_Rune_tips_005"))
	self:fixChildrenPos()
end
function Com_stage:onShow()
end
function Com_stage:initData(class)
	self.fields.Text_slv:setString(class)
end
return Com_stage
