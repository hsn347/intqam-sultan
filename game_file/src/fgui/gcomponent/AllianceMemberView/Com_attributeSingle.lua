local baseComponent = require("fgui.base.baseComponent")
local Com_attributeSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceMemberView/Com_attributeSingle", Com_attributeSingle)
function Com_attributeSingle:onInit()
	self:fixChildrenPos()
end
function Com_attributeSingle:onShow()
end
function Com_attributeSingle:initData(data)
	self.fields.Text_des:setString(data.des)
	self.fields.Text_des_value:setString(data.addValue)
end
return Com_attributeSingle
