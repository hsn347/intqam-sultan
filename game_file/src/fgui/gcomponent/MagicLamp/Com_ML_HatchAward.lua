local baseComponent = require("fgui.base.baseComponent")
local Com_ML_HatchAward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_HatchAward", Com_ML_HatchAward)
function Com_ML_HatchAward:onInit()
end
function Com_ML_HatchAward:onShow()
end
function Com_ML_HatchAward:initData(data, isCrit)
	self.fields.item:initData(data.id, data.count)
	self.fields.crit:setVisible(isCrit)
end
return Com_ML_HatchAward
