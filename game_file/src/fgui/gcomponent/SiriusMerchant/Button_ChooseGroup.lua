local baseComponent = require("fgui.base.baseComponent")
local Button_ChooseGroup = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SiriusMerchant/Button_ChooseGroup", Button_ChooseGroup)
function Button_ChooseGroup:onInit()
end
function Button_ChooseGroup:onShow()
end
function Button_ChooseGroup:initData(id, count)
	if id then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Com_Item:initData(id, count)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
return Button_ChooseGroup
