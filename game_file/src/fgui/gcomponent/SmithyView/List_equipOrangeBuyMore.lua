local baseComponent = require("fgui.base.baseComponent")
local List_equipOrangeBuyMore = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/List_equipOrangeBuyMore", List_equipOrangeBuyMore)
function List_equipOrangeBuyMore:onInit()
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function List_equipOrangeBuyMore:onShow()
end
function List_equipOrangeBuyMore:initData(data)
	self.data = data
	self.fields.Text_des:setString(self.data.title)
end
function List_equipOrangeBuyMore:btnClick()
	if self.data.handle then
		self.data.handle()
	end
end
return List_equipOrangeBuyMore
