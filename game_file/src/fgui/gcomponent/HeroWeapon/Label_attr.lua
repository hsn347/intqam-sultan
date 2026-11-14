local buffDesRead = include("buffDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Label_attr = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://HeroWeapon/Label_attr", Label_attr)
fgui.register_extension("ui://HeroWeapon/Label_attrsp", Label_attr)
function Label_attr:onInit()
	self:fixChildrenPos()
end
function Label_attr:onShow()
end
function Label_attr:initData(data)
	self.fields.Text_name:setString(buffDesRead.getTitleBase(data.id))
	if data.type == 1 then
		self.fields.Text_val:setString("+" .. data.result / 100 .. "%")
	else
		self.fields.Text_val:setString("+" .. data.result)
	end
end
return Label_attr
