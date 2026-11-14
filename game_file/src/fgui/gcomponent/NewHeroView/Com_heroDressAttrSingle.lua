local buffDesRead = include("buffDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_heroDressAttrSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_heroDressAttrSingle", Com_heroDressAttrSingle)
function Com_heroDressAttrSingle:onInit()
	self:fixChildrenPos()
end
function Com_heroDressAttrSingle:onShow()
end
function Com_heroDressAttrSingle:initData(data, index)
	self.fields.bg:setVisible(index % 2 == 0)
	self.fields.Text_des:setString(buffDesRead.getTitleBase(data.id))
	self.fields.Text_val:setString(buffDesRead.getTitleValueWithValue(data.id, data.value))
end
return Com_heroDressAttrSingle
