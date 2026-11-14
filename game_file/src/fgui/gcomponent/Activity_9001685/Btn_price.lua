local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_price = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001685/Btn_price", Btn_price)
function Btn_price:onInit()
	self.fields.icon:fixPos()
	self.fields.Text_gold:fixPos()
	self.fields.Text_curPay:fixPos()
	self.fields.Text_oriPay:fixPos()
	self.fields.Image_line:fixPos()
end
function Btn_price:onShow()
end
function Btn_price:initData(id, price, oldPrice, reduceID)
	local myCount = backpackCtrl:getItemCount(id)
	self.fields.icon:setSpriteFrame(publicRead.getIcon(id))
	if oldPrice and oldPrice ~= price then
		self.controllers.Ctrl_style:setSelectedIndex(1)
		self.fields.Text_curPay:setString(string.formatnumberthousands(price))
		self.fields.Text_curPay:setColor(price <= myCount and cc.c3b(255, 251, 213) or cc.c3b(190, 40, 40))
		self.fields.Text_oriPay:setString(string.formatnumberthousands(oldPrice))
		self.fields.Lab_discount:setIcon(publicRead.getIcon(reduceID))
		backpackCtrl = publicRead.getIcon(reduceID)
		publicRead.getIcon(reduceID).num = oldPrice - price
		self.fields.Lab_discount:setTitle(i18n("common_text_4871", publicRead.getIcon(reduceID)))
	else
		self.controllers.Ctrl_style:setSelectedIndex(0)
		self.fields.Text_gold:setString(string.formatnumberthousands(price))
		self.fields.Text_gold:setColor(price <= myCount and cc.c3b(255, 251, 213) or cc.c3b(190, 40, 40))
	end
end
return Btn_price
