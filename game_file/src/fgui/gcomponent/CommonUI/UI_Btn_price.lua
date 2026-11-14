local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicUtil = include("publicUtil")
local baseComponent = require("fgui.base.baseComponent")
local UI_Btn_price = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Btn_price", UI_Btn_price)
fgui.register_extension("ui://CommonUI/UI_Btn_price2", UI_Btn_price)
function UI_Btn_price:onInit()
	self.fields.Label_reddot:setVisible(false)
	self.fields.Text_free:setString(i18n("common_text_049"))
	self.fields.Text_gold:fixPos()
	self.fields.Icon_gold:fixPos()
	self.fields.Text_curPay:fixPos()
	self.fields.Text_oriPay:fixPos()
	self.fields.Image_line:fixPos()
end
function UI_Btn_price:onShow()
end
function UI_Btn_price:initData(id, price, oldPrice)
	self:setPrice(price, oldPrice)
	self:setPriceIcon(id)
end
function UI_Btn_price:setPrice(price, oldPrice)
	self.controllers.Ctrl_free:setSelectedIndex(0)
	if oldPrice and oldPrice ~= price then
		self.controllers.Ctrl_style:setSelectedIndex(1)
		self.fields.Text_curPay:setString(string.formatnumberthousands(price))
		self.fields.Text_oriPay:setString(string.formatnumberthousands(oldPrice))
	else
		self.controllers.Ctrl_style:setSelectedIndex(0)
		self.fields.Text_gold:setString(string.formatnumberthousands(price))
	end
end
function UI_Btn_price:setPriceIcon(id)
	if type(id) == "number" then
		self.fields.Icon_gold:setSpriteFrame(publicRead.getIcon(id))
	elseif type(id) == "string" then
		self.fields.Icon_gold:setSpriteFrame(id)
	end
end
function UI_Btn_price:setPriceTitle(str)
	self.fields.Text_gold:setString(str)
end
function UI_Btn_price:setTitleColor(color)
	if self.controllers.Ctrl_style:getSelectedIndex() == 0 then
		self.fields.Text_gold:setColor(color)
	else
		self.fields.Text_curPay:setColor(color)
	end
end
function UI_Btn_price:setTitle(title)
	self.controllers.Ctrl_free:setSelectedIndex(1)
	self.controllers.Ctrl_status:setSelectedIndex(0)
	self.controllers.Ctrl_style:setSelectedIndex(0)
	if title then
		self.fields.Text_free:setString(title)
	end
end
function UI_Btn_price:setStatus(isEnough, isSetGray)
	self.controllers.Ctrl_status:setSelectedIndex(isEnough and 0 or 1)
	if isSetGray == nil then
		isSetGray = true
	end
	self:setGrayed(isSetGray)
	self.fields.Icon_gold:setGrayed(isSetGray)
end
function UI_Btn_price:setBtnColorIndex(index)
	self.controllers.c1:setSelectedIndex(index)
end
function UI_Btn_price:setGrayed(value)
	self.fields.btnBg:setGrayed(value)
end
return UI_Btn_price
