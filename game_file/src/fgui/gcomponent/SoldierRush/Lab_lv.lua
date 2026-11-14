local baseComponent = require("fgui.base.baseComponent")
local Lab_lv = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://SoldierRush/Lab_lv", Lab_lv)
function Lab_lv:onInit()
end
function Lab_lv:onShow()
end
function Lab_lv:setNum(num, max)
	self.fields.title:setString(num)
	if max <= 0 then
		self.fields.pro:setContentSize(cc.size(40, 40))
	else
		self.fields.pro:setContentSize(cc.size(40, math.min(40, num * 40 / max)))
	end
end
return Lab_lv
