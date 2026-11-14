local baseComponent = require("fgui.base.baseComponent")
local Com_accuPointSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RamadanAccuRecharge/Com_accuPointSingle", Com_accuPointSingle)
fgui.register_extension("ui://StarryNightJourney/Com_pointSingle", Com_accuPointSingle)
function Com_accuPointSingle:onInit()
	self:fixChildrenPos()
end
function Com_accuPointSingle:initData(index, point, cost)
	if bit.band(index, 1) == 0 then
		self.fields.bg_white:setVisible(false)
	else
		self.fields.bg_white:setVisible(true)
	end
	self.fields.Text_point:setString(point)
	self.fields.Text_cost:setString(cost)
end
function Com_accuPointSingle:onShow()
end
return Com_accuPointSingle
