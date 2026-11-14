local baseComponent = require("fgui.base.baseComponent")
local Btn_stamina = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://autokill/Btn_stamina", Btn_stamina)
function Btn_stamina:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_stamina:onShow()
end
function Btn_stamina:initData(data, itemList)
