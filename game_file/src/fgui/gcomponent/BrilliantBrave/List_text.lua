local baseComponent = require("fgui.base.baseComponent")
local List_text = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BrilliantBrave/List_text", List_text)
function List_text:onInit()
	self:fixChildrenPos()
end
function List_text:onShow()
end
function List_text:initData(data)
	self.fields.Text_title:setString(i18n(data.title))
	if data.addValue then
		self.fields.Text_Addvalue:setString(i18n(data.addValue))
	end
	if data.value then
		self.fields.Text_value:setString(data.value)
	end
end
return List_text
