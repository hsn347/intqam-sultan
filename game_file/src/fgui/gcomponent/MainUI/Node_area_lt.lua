local baseComponent = require("fgui.base.baseComponent")
local Node_area_lt = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Node_area_lt", Node_area_lt)
function Node_area_lt:onInit()
	self.fields.builderIcon_iron:fixPos()
	self.fields.builderIcon_gold:fixPos()
	self.fields.builderIcon_qh_free:fixPos()
	self.fields.builderIcon_qh_gold:fixPos()
	self.fields.troop:fixPos()
end
function Node_area_lt:onShow()
end
function Node_area_lt:setExplainShowModel(index)
	self.controllers.c2:setSelectedIndex(index)
	self.fields.btn_gameExplain:fixPos()
end
function Node_area_lt:setShowModel(index)
	self.controllers.c1:setSelectedIndex(index)
	if index == 0 then
		_UPVALUE4_ = self.controllers.c1
		self.controllers.c1[1] = self.fields.builderIcon_iron
		self.controllers.c1[2] = self.fields.builderIcon_gold
		self.controllers.c1[3] = self.fields.builderIcon_qh_free
		self.controllers.c1[4] = self.fields.builderIcon_qh_gold
		for i, v in ipairs(self.controllers.c1) do
			v:updateView()
		end
	end
end
function Node_area_lt:getTarget(name)
	return self.fields[name]
end
return Node_area_lt
