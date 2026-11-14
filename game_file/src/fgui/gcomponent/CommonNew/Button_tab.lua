local baseComponent = require("fgui.base.baseComponent")
local Button_tab = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonNew/Button_tab", Button_tab)
function Button_tab:onInit()
	self.fields.lock:fixPos()
	self.fields.title:fixPos()
end
function Button_tab:onShow()
end
function Button_tab:isShowLock(isShow)
	print("Button_tab:isShowLock======", isShow)
	self.controllers.c1:setSelectedIndex(isShow and 1 or 0)
end
return Button_tab
