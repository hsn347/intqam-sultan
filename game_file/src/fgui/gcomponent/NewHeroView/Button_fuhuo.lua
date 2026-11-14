local baseComponent = require("fgui.base.baseComponent")
local Button_fuhuo = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Button_fuhuo", Button_fuhuo)
function Button_fuhuo:onInit()
	self.fields.Text_fuhuo:setString(i18n("common_text_2508"))
	self.fields.n3:setAllFrameName("dh_jinengyj01_%.3d.png", 0)
end
function Button_fuhuo:onShow()
end
return Button_fuhuo
