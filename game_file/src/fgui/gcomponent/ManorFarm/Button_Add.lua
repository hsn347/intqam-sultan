local baseComponent = require("fgui.base.baseComponent")
local Button_Add = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ManorFarm/Button_Add", Button_Add)
function Button_Add:onInit()
end
function Button_Add:onShow()
end
function Button_Add:initData(id)
	self.id = id
	self.controllers.ctrlAdd:setSelectedIndex(id and 1 or 0)
	self.fields.comItem:initData(id)
end
function Button_Add:setStatus(index)
	self.controllers.ctrlAdd:setSelectedIndex(index)
end
function Button_Add:setReduce(index)
	self.controllers.ctrlReduce:setSelectedIndex(index)
end
function Button_Add:setBtnSelected(isSelected)
	self.controllers.c_select:setSelectedIndex(isSelected and 1 or 0)
end
return Button_Add
