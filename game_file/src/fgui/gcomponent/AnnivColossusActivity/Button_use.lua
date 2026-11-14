local baseComponent = require("fgui.base.baseComponent")
local Button_use = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://AnnivColossusActivity/Button_use", Button_use)
function Button_use:onInit()
end
function Button_use:onShow()
end
function Button_use:setTitle(str)
	self.fields.title:setString(str)
end
function Button_use:setNum(haveNum, needNum)
	if haveNum < needNum then
		self.fields.need_num:setColor(cc.c3b(255, 1, 1))
	else
		self.fields.need_num:setColor(cc.c3b(255, 255, 1))
	end
	self.fields.need_num:setString(needNum)
end
return Button_use
