local baseComponent = require("fgui.base.baseComponent")
local ProgressBarIrrigate = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://MagicHerb/ProgressBarIrrigate", ProgressBarIrrigate)
function ProgressBarIrrigate:onInit()
end
function ProgressBarIrrigate:onShow()
end
function ProgressBarIrrigate:setValue(value)
	fgui.GProgressBar.setValue(self, value)
	self.fields.n3:setPositionX(SoraDFPosX((1 - self:getValue() / self:getMax()) * self.fields.bar:getWidth() + 7, self:getWidth()))
end
return ProgressBarIrrigate
