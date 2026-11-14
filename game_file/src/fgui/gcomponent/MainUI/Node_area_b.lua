local baseComponent = require("fgui.base.baseComponent")
local Node_area_b = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Node_area_b", Node_area_b)
function Node_area_b:onInit()
	self.fields.Button_alliance:fixPos()
	self.fields.Button_mail:fixPos()
	self.fields.Button_items:fixPos()
	self.fields.Button_hero:fixPos()
end
function Node_area_b:onShow()
end
function Node_area_b:getTarget(name)
	return self.fields[name]
end
function Node_area_b:initStyle()
end
function Node_area_b:setGuideContorller(index)
	self.controllers.guide:setSelectedIndex(index)
end
return Node_area_b
