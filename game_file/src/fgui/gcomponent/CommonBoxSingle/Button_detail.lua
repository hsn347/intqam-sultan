local baseComponent = require("fgui.base.baseComponent")
local Button_detail = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonBoxSingle/Button_detail", Button_detail)
function Button_detail:onInit()
	self:setTitle(i18n("hero_title_02"))
end
function Button_detail:initData(title, state)
	self:setTitle(title or i18n("hero_title_02"))
	self:setState(state or 1)
end
function Button_detail:setTitle(str)
	self.fields.title:setString(str)
end
function Button_detail:setState(index)
	self.controllers.state:setSelectedIndex(index)
end
function Button_detail:onShow()
end
return Button_detail
