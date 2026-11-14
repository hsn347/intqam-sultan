local baseComponent = require("fgui.base.baseComponent")
local list_term = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/list_term", list_term)
function list_term:onInit()
	self:fixChildrenPos()
	self.fields.Button_Go:setTitle(i18n("common_text_477"))
	self.fields.Button_Go:addClickListener(handler(self, self.onClickGo))
end
function list_term:onShow()
end
function list_term:initData(data)
	self.type = data.type
	self.fields.title:setString(data.title)
	self.fields.icon:setURL(data.icon)
	self.controllers.c1:setSelectedIndex(data.isLock and 0 or 1)
end
function list_term:setHandle(handle)
	self.handle = handle
end
function list_term:onClickGo()
	SoraDPlaySound()
	if self.handle then
		self.handle(self.type)
	end
end
return list_term
