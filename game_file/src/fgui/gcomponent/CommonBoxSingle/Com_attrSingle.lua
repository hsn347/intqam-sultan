local attrltCtrl = include("attrltCtrl")
local propParser = include("propParser")
local baseComponent = require("fgui.base.baseComponent")
local Com_attrSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonBoxSingle/Com_attrSingle", Com_attrSingle)
function Com_attrSingle:onInit()
	self:fixChildrenPos()
end
function Com_attrSingle:onShow()
end
function Com_attrSingle:initData(data, index)
	if data.custom then
		self.fields.bg:setVisible(index % 2 == 0)
		self.fields.Text_custom:setVisible(true)
		self.fields.Text_name:setVisible(false)
		self.fields.Text_value:setVisible(false)
		self.fields.Text_custom:setString(data.custom)
		if data.isSingleH then
			self.fields.Text_custom:setTextAreaSize(cc.size(520, 150))
		else
			self.fields.Text_custom:setTextAreaSize(cc.size(520, 29))
		end
	else
		self.fields.bg:setVisible(index % 2 == 1)
		self.fields.Text_custom:setString("")
		self.fields.Text_custom:setVisible(false)
		self.fields.Text_name:setVisible(true)
		self.fields.Text_value:setVisible(true)
		self.fields.Text_name:setString(attrltCtrl.getAttrDes(data.attrID))
		self.fields.Text_value:setString(propParser.getFormatByAttrIDAndValue(data.attrID, data.attrValue))
	end
end
return Com_attrSingle
