local baseComponent = require("fgui.base.baseComponent")
local Button_price = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RechargeView/Button_price", Button_price)
function Button_price:onInit()
end
function Button_price:onShow()
end
function Button_price:initData(cur, ori)
	self.fields.Text_cur:setString(string.formatnumberthousands(cur))
	self.fields.Text_cur:setColor(SoraDEnoughGold(cur, true) and cc.c3b(255, 251, 213) or cc.c3b(190, 40, 40))
	self.fields.Text_ori:setString(string.formatnumberthousands(ori))
	self:fixChildrenPos()
end
function Button_price:initUnData()
	self.fields.Text_cur:setString("???")
	self.fields.Text_cur:setColor(cc.c3b(255, 251, 213))
	self.fields.Text_ori:setString("???")
	self:fixChildrenPos()
end
return Button_price
