local buffDesRead = include("buffDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_Mail_RecountAtt = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://mailView/Com_Mail_RecountAtt", Com_Mail_RecountAtt)
function Com_Mail_RecountAtt:onInit()
	self.fields.value:fixPos()
	self.fields.attname:fixPos()
end
function Com_Mail_RecountAtt:initData(buffCfg, index)
	self.controllers.c1:setSelectedIndex(0)
	self.fields.bg:setVisible(index % 2 == 1)
	local curValue = buffCfg.value
	if buffCfg.type == 1 then
		curValue = curValue / 10
	end
	self.fields.name:setString(buffDesRead.getTitleWithValue(buffCfg.buffType, SoraDPreciseDecimal(curValue, 2)))
end
function Com_Mail_RecountAtt:setNameAndValue(title, value, index)
	self.controllers.c1:setSelectedIndex(2)
	self.fields.bg:setVisible(index % 2 == 0)
	self.fields.attname:setString(title)
	self.fields.value:setString(value)
end
function Com_Mail_RecountAtt:setSubTitle(title)
	self.controllers.c1:setSelectedIndex(1)
	self.fields.title:setString(title)
end
function Com_Mail_RecountAtt:setDesc(desc, index)
	self.controllers.c1:setSelectedIndex(0)
	self.fields.name:setString(desc)
	self.fields.bg:setVisible(index % 2 == 1)
end
return Com_Mail_RecountAtt
