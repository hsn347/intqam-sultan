local baseComponent = require("fgui.base.baseComponent")
local Com_itemGet = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001731/Com_itemGet", Com_itemGet)
function Com_itemGet:onInit()
	self.fields.Button_go:setTitle(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onClick_Button_go))
	self:fixChildrenPos()
end
function Com_itemGet:onShow()
end
function Com_itemGet:initData(data)
	self.handler = data.handler
	self.fields.Text_title:setString(data.title)
	self.fields.Text_des:setString(data.des)
	self.fields.icon:setURL(data.icon)
end
function Com_itemGet:onClick_Button_go(context)
	SoraDPlaySound()
	if self.handler then
		self.handler()
	end
end
return Com_itemGet
