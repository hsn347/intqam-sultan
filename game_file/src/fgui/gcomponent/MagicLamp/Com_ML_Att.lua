local baseComponent = require("fgui.base.baseComponent")
local Com_ML_Att = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_Att", Com_ML_Att)
local buffDesRead = include("buffDesRead")
function Com_ML_Att:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function Com_ML_Att:onShow()
end
function Com_ML_Att:initData(buffCfg, lv)
	local curValue = buffCfg.value + lv * buffCfg.add
	if buffCfg.type == 1 then
		curValue = curValue / 10
	end
	self.fields.name:setString(buffDesRead.getTitleBase(buffCfg.buffType, false, true))
	self.fields.value:setString(buffDesRead.getTitleValueWithValue(buffCfg.buffType, SoraDPreciseDecimal(curValue, 2), false))
end
return Com_ML_Att
