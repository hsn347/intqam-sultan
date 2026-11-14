local baseComponent = require("fgui.base.baseComponent")
local Com_proBar = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_proBar", Com_proBar)
function Com_proBar:onInit()
	self.fields.Bar:setTitleType(fgui.ProgressTitleType.VALUE_MAX)
	self.fields.Button_add:addClickListener(handler(self, self.btnClick))
end
function Com_proBar:onShow()
end
function Com_proBar:initData(lv, exp, max)
	self.fields.Lab_lv:setString(lv)
	self.fields.Bar:setMax(max)
	self.fields.Bar:setValue(exp)
end
function Com_proBar:btnClick()
	SoraDPlaySound()
	uiManager:show("RoaringFlame_DecreeGain")
end
return Com_proBar
