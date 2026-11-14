local equipDesRead = include("equipDesRead")
local propParser = include("propParser")
local attrltCtrl = include("attrltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_ringLaceBuff = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_ringLaceBuff", Com_ringLaceBuff)
function Com_ringLaceBuff:onInit()
	self:fixChildrenPos()
end
function Com_ringLaceBuff:onShow()
end
function Com_ringLaceBuff:initData(data, isNormal)
	self.data = data
	self.isNormal = isNormal or false
	local titleStr, valueStr = self:getTitleAndValueStr()
	self.fields.Text_Title:setString(titleStr)
	self.fields.Text_Value:setString(valueStr)
end
function Com_ringLaceBuff:getTitleAndValueStr(v)
	if self.isNormal then
		return equipDesRead.getAttrName(self.data.propertyType), string.format("+%s", equipDesRead.getSuitpropertyDes(self.data.propertyType, self.data.propertyValue, self.data.dataType))
	else
		local titleStr = attrltCtrl.getAttrDes(self.data.attrID)
		local attrType = attrltCtrl.getAttrType(self.data.attrID)
		local valueStr = propParser.getFormatByAttrTypeAndValue(attrType, self.data.attrValue, attrltCtrl.getShowValueType(attrType))
		return titleStr, valueStr
	end
end
return Com_ringLaceBuff
