local baseComponent = require("fgui.base.baseComponent")
local Com_9001729_itemInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001729/Com_9001729_itemInfo", Com_9001729_itemInfo)
function Com_9001729_itemInfo:onInit()
	self.fields.Text_tip2:setString(i18n("text_key"))
	self.fields.Text_item1:setString(i18n("text_key"))
	self.fields.Text_item2:setString(i18n("text_key"))
end
function Com_9001729_itemInfo:onShow()
end
return Com_9001729_itemInfo
