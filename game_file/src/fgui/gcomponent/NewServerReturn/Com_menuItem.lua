local baseComponent = require("fgui.base.baseComponent")
local Com_menuItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewServerReturn/Com_menuItem", Com_menuItem)
function Com_menuItem:onInit()
	self:addClickListener(handler(self, self.onClickBtn))
end
function Com_menuItem:initData(index, data, btnHandle)
	self:setTag(data.tag or index)
	self.fields.title:setString(data.title or "event day")
	self.btnHandle = btnHandle
end
function Com_menuItem:onClickBtn()
	if self.btnHandle and self:getTag() then
		self.btnHandle(self:getTag())
	end
end
function Com_menuItem:onShow()
end
return Com_menuItem
