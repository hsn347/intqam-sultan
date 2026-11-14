local baseComponent = require("fgui.base.baseComponent")
local Button_class = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Button_class", Button_class)
function Button_class:onInit()
	self.fields.Text_all:setString(i18n("common_text_635"))
end
function Button_class:onShow()
end
function Button_class:initData(index, curIndex)
	self.index = index
	self.controllers.c1:setSelectedIndex(index)
end
return Button_class
