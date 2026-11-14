local attrltCtrl = include("attrltCtrl")
local propParser = include("propParser")
local baseComponent = require("fgui.base.baseComponent")
local Com_attrSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CastleChange/Com_attrSingle", Com_attrSingle)
function Com_attrSingle:onInit()
	self:fixChildrenPos()
end
function Com_attrSingle:onShow()
end
function Com_attrSingle:initData(data, index)
	self.fields.bg:setVisible(index % 2 == 1)
	self.fields.Text_name:setString(attrltCtrl.getAttrDes(data.attrID))
	self.fields.Text_value:setString(propParser.getFormatByAttrIDAndValue(data.attrID, data.attrValue))
end
return Com_attrSingle
