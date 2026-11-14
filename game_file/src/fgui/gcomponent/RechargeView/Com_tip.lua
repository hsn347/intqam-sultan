local baseComponent = require("fgui.base.baseComponent")
local Com_tip = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/Com_tip", Com_tip)
function Com_tip:onInit()
	self.fields.Btn_help:addClickListener(handler(self, self.btnClick))
	self.fields.Btn_help:fixPos()
end
function Com_tip:onShow()
end
function Com_tip:setTitle(str)
	self.fields.title:setString(str)
end
function Com_tip:setHandle(handle)
	self.handle = handle
end
function Com_tip:btnClick()
	SoraDPlaySound()
	if self.handle then
		self.handle()
	end
end
return Com_tip
