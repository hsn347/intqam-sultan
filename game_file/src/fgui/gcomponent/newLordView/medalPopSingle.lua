local baseComponent = require("fgui.base.baseComponent")
local medalPopSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/medalPopSingle", medalPopSingle)
function medalPopSingle:onInit()
end
function medalPopSingle:onShow()
end
function medalPopSingle:initData(data, section)
	self.fields.title:setString(data.des)
	self.controllers.c1:setSelectedIndex(section == data.section and 1 or 0)
end
return medalPopSingle
