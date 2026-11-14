local baseComponent = require("fgui.base.baseComponent")
local list_text = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NewHeroView/list_text", list_text)
function list_text:onInit()
	self:fixChildrenPos()
end
function list_text:onShow()
end
function list_text:initData(data)
	self.fields.title:setString(data.des)
	self.fields.new:setVisible(data.isNew)
end
return list_text
