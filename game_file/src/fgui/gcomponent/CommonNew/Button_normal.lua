local baseComponent = require("fgui.base.baseComponent")
local Button_normal = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonNew/Button_normal", Button_normal)
function Button_normal:onInit()
	if self.fields.Label_reddot then
		self.fields.Label_reddot:fixPos()
	end
end
function Button_normal:setBtnColorIndex(index)
	self.controllers.c1:setSelectedIndex(index)
end
function Button_normal:setRedDot(data)
	self.fields.Label_reddot:initData(data.visible, data.num)
end
function Button_normal:setReddot(value, num)
	self.fields.Label_reddot:initData(value, num)
end
function Button_normal:setTitleColor(color)
	self.fields.title:setColor(color)
end
function Button_normal:onShow()
end
function Button_normal:setGrayed(value)
	self.fields.Img_bg:setGrayed(value)
end
return Button_normal
