local baseComponent = require("fgui.base.baseComponent")
local Button_lasheng = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://FootballSpirit/Button_lasheng", Button_lasheng)
function Button_lasheng:onInit()
	self.fields.title:setString(i18n("common_text_061"))
end
function Button_lasheng:onShow()
end
function Button_lasheng:initData(num)
	self.fields.num:setString("x" .. string.formatnumberthousands(num))
	self.fields.num:setColor(0 < num and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
end
return Button_lasheng
