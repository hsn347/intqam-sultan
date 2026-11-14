local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local helpIcon = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ManorCity/helpIcon", helpIcon)
function helpIcon:onInit()
end
function helpIcon:onShow()
end
function helpIcon:initData(title, num)
	self.fields.title:setString(title)
	self.fields.txtNum:setString(num)
end
function helpIcon:onMsgItemChange(...)
end
return helpIcon
