local baseComponent = require("fgui.base.baseComponent")
local Com_show = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WarGem/Com_show", Com_show)
function Com_show:onInit()
end
function Com_show:onShow()
end
function Com_show:initData(lv, attr, val)
	_ENV = nil
	;(nil).lv = lv
	self.fields.Text_lv:setString(i18n("common_text_101", nil))
	self.fields.Text_attr:setString(attr)
	self.fields.Text_val:setString(val)
end
return Com_show
