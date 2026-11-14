local baseComponent = require("fgui.base.baseComponent")
local Com_MGC_Top = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainCityGuide/Com_MGC_Top", Com_MGC_Top)
function Com_MGC_Top:onInit()
end
function Com_MGC_Top:onShow()
	self.fields.name1:setString(i18n("new_palyer_npcname_001"))
	self.fields.name2:setString(i18n("hero_name_10"))
	self.fields.p1:setMax(100)
	self.fields.p2:setMax(100)
	self:showProgressAction1()
end
function Com_MGC_Top:showProgressAction1()
	self.fields.p1:tweenValue(50, 6)
	self.fields.p2:tweenValue(70, 6)
end
function Com_MGC_Top:showProgressAction2()
	self.fields.p1:tweenValue(0, 6)
	self.fields.p2:tweenValue(50, 6)
end
return Com_MGC_Top
