local baseComponent = require("fgui.base.baseComponent")
local Com_sultansBack = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Com_sultansBack", Com_sultansBack)
function Com_sultansBack:onInit()
	self.fields.Text_Time:setString(i18n("activity_name_9001289"))
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.Label_reddot:fixPos()
end
function Com_sultansBack:onShow()
end
function Com_sultansBack:setRed(num)
	self.fields.Label_reddot:initData(0 < num, num)
end
function Com_sultansBack:onBtnClick()
	SoraDPlaySound()
	SoraDCreatePanel("sultansBackView"):show()
end
return Com_sultansBack
