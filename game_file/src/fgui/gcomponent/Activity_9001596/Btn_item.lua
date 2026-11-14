local baseComponent = require("fgui.base.baseComponent")
local Btn_item = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001596/Btn_item", Btn_item)
function Btn_item:onInit()
end
function Btn_item:onShow()
end
function Btn_item:initData(id, count)
	self.fields.item:setVisible(0 < count)
	if 0 < count then
		self.fields.item:initData(id, count)
	end
	self:setTouchEnabled(0 < count)
end
return Btn_item
