local baseComponent = require("fgui.base.baseComponent")
local RunePandectAttrSingle = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Chaser/RunePandectAttrSingle", RunePandectAttrSingle)
function RunePandectAttrSingle:onInit()
end
function RunePandectAttrSingle:onShow()
end
function RunePandectAttrSingle:initData(str, index)
	if type(str) == "string" then
		self.fields.title:setString(str)
		self.controllers.c1:setSelectedIndex(0)
		self.fields.bg:setVisible(index % 2 == 1)
	elseif type(str) == "table" then
		self.fields.title:setString(str.title)
		self.controllers.c1:setSelectedIndex(str.index == 0 and 1 or 0)
		self.fields.bg:setVisible(false)
		self.fields.bg:setVisible(str.index % 2 == 1)
	end
end
return RunePandectAttrSingle
