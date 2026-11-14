local baseComponent = require("fgui.base.baseComponent")
local Com_ML_BreakAtt = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_BreakAtt", Com_ML_BreakAtt)
local buffDesRead = include("buffDesRead")
function Com_ML_BreakAtt:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function Com_ML_BreakAtt:onShow()
end
function Com_ML_BreakAtt:initData(oldBuffCfg, buffCfg, lv, index)
	self.fields.bg:setVisible(index % 2 == 1)
	local curValue = buffCfg.value + lv * buffCfg.add
	local oldValue = oldBuffCfg.value + lv * oldBuffCfg.add
	if buffCfg.type == 1 then
		curValue = curValue / 10
		oldValue = oldValue / 10
	end
	self.fields.name:setString(buffDesRead.getTitleBase(buffCfg.buffType, false, true))
	self.fields.value:setString(buffDesRead.getTitleValueWithValue(buffCfg.buffType, SoraDPreciseDecimal(oldValue, 2), false))
	self.fields.value_new:setString(buffDesRead.getTitleValueWithValue(buffCfg.buffType, SoraDPreciseDecimal(curValue, 2), false))
end
return Com_ML_BreakAtt
