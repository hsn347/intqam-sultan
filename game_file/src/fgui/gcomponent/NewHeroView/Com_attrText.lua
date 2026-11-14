local baseComponent = require("fgui.base.baseComponent")
local Com_attrText = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_attrText", Com_attrText)
function Com_attrText:onInit()
end
function Com_attrText:onShow()
end
function Com_attrText:initData(val, quality)
	self.fields.title:setString(val)
	self.controllers.c2:setSelectedIndex(quality - 1)
end
function Com_attrText:isSelect(ret)
	self:setSelected(ret)
end
return Com_attrText
