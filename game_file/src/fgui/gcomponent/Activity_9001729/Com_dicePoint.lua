local baseComponent = require("fgui.base.baseComponent")
local Com_dicePoint = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001729/Com_dicePoint", Com_dicePoint)
function Com_dicePoint:onInit()
	self.fields.title:setString(i18n("title_text"))
end
function Com_dicePoint:onShow()
end
function Com_dicePoint:initData(num)
	self.num = num
	self.fields.icon:setURL("icon_9001729_dianshu0" .. num .. ".png")
end
return Com_dicePoint
