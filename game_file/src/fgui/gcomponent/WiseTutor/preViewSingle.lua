local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local preViewSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WiseTutor/preViewSingle", preViewSingle)
function preViewSingle:onInit()
	self:fixChildrenPos()
end
function preViewSingle:onShow(...)
end
function preViewSingle:initData(id, num, index)
	self.controllers.c1:setSelectedIndex(index % 2)
	self.fields.Text_Num:setString("X" .. num)
	self.fields.Text_Des:setString(publicRead.getName(id))
	self.fields.Com_Item:initData(id, 0)
end
return preViewSingle
