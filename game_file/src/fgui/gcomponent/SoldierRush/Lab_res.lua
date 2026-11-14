local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Lab_res = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://SoldierRush/Lab_res", Lab_res)
function Lab_res:onInit()
end
function Lab_res:onShow()
end
function Lab_res:initData(data, cIndex)
	self.controllers.c1:setSelectedIndex(cIndex or 0)
	self.fields.icon:setSpriteFrame(publicRead.getSmallIcon(data.id))
	self.fields.title:setString(SoraDConvertNumberWithUnit(data.count))
end
return Lab_res
