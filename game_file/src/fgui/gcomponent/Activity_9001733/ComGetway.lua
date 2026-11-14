local baseComponent = require("fgui.base.baseComponent")
local ComGetway = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001733/ComGetway", ComGetway)
function ComGetway:onInit()
	self.fields.btnGo:setString(i18n("common_text_477"))
	self.fields.btnGo:addClickListener(handler(self, self.onClick_btnGo))
	self.fields.txtName:fixPos()
	self.fields.icon:fixPos()
	self.fields.btnGo:fixPos()
end
function ComGetway:onShow()
end
function ComGetway:initData(data, clickCallback)
