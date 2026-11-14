local baseComponent = require("fgui.base.baseComponent")
local FruitCultivateProgress = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://ManorFarm/FruitCultivateProgress", FruitCultivateProgress)
function FruitCultivateProgress:onInit()
end
function FruitCultivateProgress:onShow()
	self.fields.prefabEx_bg:setEffectPath("fx_farm_gspy_dan.prefab")
	self.fields.prefabEx_pb:setEffectPath("fx_farm_gspy_dan_01.prefab")
	self.fields.prefabEx:setEffectPath("fx_farm_gspy_liudong.prefab")
end
function FruitCultivateProgress:UpdateValue(value)
	self:setValue(value)
	local max = self:getMax()
	local percent = value / max
	local height = self:getHeight() * (1 - percent)
	self.fields.prefabEx:setPositionY(height)
	self.fields.prefabEx_pb:setPb(percent)
end
function FruitCultivateProgress:initData(value, min, max)
	self:setMin(min)
	self:setMax(max)
	self:UpdateValue(value)
end
return FruitCultivateProgress
