local baseComponent = require("fgui.base.baseComponent")
local Button_tabW = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonNew/Button_tabW", Button_tabW)
function Button_tabW:onInit()
	self.fields.yes:fixPos()
	self.fields.title2:fixPos()
end
function Button_tabW:onShow()
end
function Button_tabW:showYes(isShow)
	if isShow then
		self.fields.title2:setString(self.fields.title:getText())
	end
	self.controllers.style:setSelectedIndex(isShow and 1 or 0)
end
return Button_tabW
