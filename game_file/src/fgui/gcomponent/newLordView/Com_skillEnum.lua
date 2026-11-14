local baseComponent = require("fgui.base.baseComponent")
local Com_skillEnum = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_skillEnum", Com_skillEnum)
function Com_skillEnum:onInit()
	self.fields.bg:fix()
	self.fields.cur:fix()
	self.fields.Text_title:fixPos()
	self.fields.Text_value:fixPos()
end
function Com_skillEnum:onShow()
end
function Com_skillEnum:initData(tag, points, isCur)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.tag == 1 then
		self.fields.Text_title:setString(i18n("common_text_370"))
	elseif self.tag == 2 then
		self.fields.Text_title:setString(i18n("common_text_371"))
	elseif self.tag == 3 then
		self.fields.Text_title:setString(i18n("common_text_372"))
	end
	self.fields.Text_value:setString(points)
	self.controllers.c2:setSelectedIndex(isCur and 1 or 0)
	self.fields.icon:fixPos()
end
return Com_skillEnum
