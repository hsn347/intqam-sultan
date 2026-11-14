local baseComponent = require("fgui.base.baseComponent")
local Com_showItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BeachHunt/Com_showItem", Com_showItem)
function Com_showItem:onInit()
end
function Com_showItem:onShow()
end
function Com_showItem:initData(data)
	self.fields.item:initData(data.reward[1])
	self.fields.Text_num:setString(data.reward[2])
	self.fields.item:setEffectShow(data.grandPrizes == 1)
end
return Com_showItem
