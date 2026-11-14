local baseComponent = require("fgui.base.baseComponent")
local Com_cityUnlockItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildViewCommon/Com_cityUnlockItem", Com_cityUnlockItem)
function Com_cityUnlockItem:onInit()
	self:fixChildrenPos()
end
function Com_cityUnlockItem:onShow()
end
function Com_cityUnlockItem:initData(data, isLock)
	self.fields.Text_name:setString(i18n(data.title))
	self.fields.Image_icon:setIcon(data.icon)
	if isLock then
		self.fields.Text_name:setColor(display.COLOR_RED)
		self.fields.Text_des:setColor(display.COLOR_RED)
		_ENV = i18n(data.title)
		i18n(data.title).level = data.level
		self.fields.Text_des:setString(i18n("common_text_427", i18n(data.title)))
	else
		self.fields.Text_des:setString(i18n(data.describe))
	end
end
return Com_cityUnlockItem
