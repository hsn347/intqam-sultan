local baseComponent = require("fgui.base.baseComponent")
local Com_ML_RecountAtt = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_RecountAtt", Com_ML_RecountAtt)
local buffDesRead = include("buffDesRead")
function Com_ML_RecountAtt:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function Com_ML_RecountAtt:onShow()
end
function Com_ML_RecountAtt:initData(buffCfg, index)
	self.controllers.c1:setSelectedIndex(0)
	self.fields.bg:setVisible(index % 2 == 1)
	local curValue = buffCfg.value
	if buffCfg.type == 1 then
		curValue = curValue / 10
	end
	self.fields.name:setString(buffDesRead.getTitleBase(buffCfg.buffType, false, true))
	self.fields.value:setString(buffDesRead.getTitleValueWithValue(buffCfg.buffType, SoraDPreciseDecimal(curValue, 2), false))
end
function Com_ML_RecountAtt:setNameAndValue(title, value, index)
	self.controllers.c1:setSelectedIndex(0)
	self.fields.bg:setVisible(index % 2 == 1)
	self.fields.name:setString(title)
	self.fields.value:setString(value)
end
function Com_ML_RecountAtt:setSubTitle(title)
	self.controllers.c1:setSelectedIndex(1)
	self.fields.title:setString(title)
end
return Com_ML_RecountAtt
