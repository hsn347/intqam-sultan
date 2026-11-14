local baseComponent = require("fgui.base.baseComponent")
local Com_factorSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001684/Com_factorSingle", Com_factorSingle)
function Com_factorSingle:onInit()
	self:fixChildrenPos()
end
function Com_factorSingle:onShow()
end
function Com_factorSingle:initData(cfg, index)
	self.fields.bg:setVisible(index % 2 == 1)
	self.fields.Text_factor:setString(cfg.damageFactor)
	self.fields.Text_range:setString(cfg.interval)
end
return Com_factorSingle
