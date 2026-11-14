local baseComponent = require("fgui.base.baseComponent")
local Button_buyUse = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CityInfoView/Button_buyUse", Button_buyUse)
function Button_buyUse:onInit()
	self.fields.title:setString(i18n("common_text_4436"))
	self.fields.Text_gold:fixPos()
	self.fields.Icon_gold:fixPos()
end
function Button_buyUse:onShow()
end
function Button_buyUse:setCostTitle(num)
	self.fields.Text_gold:setString(string.formatnumberthousands(num))
end
return Button_buyUse
