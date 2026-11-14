local baseComponent = require("fgui.base.baseComponent")
local Btn_refresh = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://merchanteView/Btn_refresh", Btn_refresh)
function Btn_refresh:onInit()
	self.fields.n2:fixPos()
	self.fields.Text_price:fixPos()
end
function Btn_refresh:onShow()
end
function Btn_refresh:initData(price)
	if price == 0 then
		self.controllers.c1:setSelectedIndex(0)
		_ENV = nil
		;(nil).gold = i18n("common_text_049")
		self.fields.title:setString(i18n("common_text_434", nil))
	else
		self.controllers.c1:setSelectedIndex(1)
		_ENV = i18n("common_text_434", nil)
		i18n("common_text_434", nil).gold = price
		self.fields.Text_price:setString(i18n("common_text_434", i18n("common_text_434", nil)))
		self.fields.Text_price:setColor(SoraDEnoughGold(price, true) and cc.c3b(255, 251, 213) or cc.c3b(190, 40, 40))
	end
end
return Btn_refresh
