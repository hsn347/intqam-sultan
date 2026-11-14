local baseComponent = require("fgui.base.baseComponent")
local Com_ML_notice = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_notice", Com_ML_notice)
function Com_ML_notice:onInit()
	self:fixChildrenPos()
end
function Com_ML_notice:onShow()
end
function Com_ML_notice:initData(title, isEnough)
	self.fields.title:setString(title)
	self.fields.icon:setURL(isEnough and "bg_main_task05.png" or "icon_no.png")
end
return Com_ML_notice
