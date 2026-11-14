local baseComponent = require("fgui.base.baseComponent")
local Lab_status = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://RoaringFlame/Lab_status", Lab_status)
function Lab_status:onInit()
	_ENV = nil
	;(nil)[0] = i18n("flames_dunes_text4")
	;(nil)[1] = i18n("flames_dunes_text5")
	;(nil)[2] = i18n("flames_dunes_text7")
	;(nil)[3] = i18n("flames_dunes_text6")
	self.cfg, (nil)[4] = nil, i18n("flames_dunes_text309")
end
function Lab_status:onShow()
end
function Lab_status:initData(status)
	self.controllers.c_status:setSelectedIndex(status)
	self:fixChildrenPos()
	self.fields.title:setString(self.cfg[status])
end
return Lab_status
