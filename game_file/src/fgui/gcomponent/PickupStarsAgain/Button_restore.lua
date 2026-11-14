local baseComponent = require("fgui.base.baseComponent")
local Button_restore = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://PickupStarsAgain/Button_restore", Button_restore)
function Button_restore:onInit()
end
function Button_restore:onShow()
end
function Button_restore:setNum(haveNum, needNum)
	if haveNum < needNum then
		self.fields.need_num:setColor(cc.c3b(255, 1, 1))
	else
		self.fields.need_num:setColor(cc.c3b(255, 255, 1))
	end
	self.fields.need_num:setString(needNum)
end
return Button_restore
