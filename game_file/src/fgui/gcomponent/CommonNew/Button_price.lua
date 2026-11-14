local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local publicUtil = include("publicUtil")
local baseComponent = require("fgui.base.baseComponent")
local Button_price = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonNew/Button_price", Button_price)
fgui.register_extension("ui://CommonNew/Button_price2", Button_price)
function Button_price:onInit()
	if self.fields.Label_reddot then
		self.fields.Label_reddot:setVisible(false)
	end
	self:fixChildrenPos()
end
function Button_price:onShow()
	self.style = self.controllers.Ctrl_style:getSelectedIndex()
end
function Button_price:initData(id, price, oldPrice)
	self:setPrice(price, oldPrice)
	self:setItemID(id)
end
function Button_price:setItemID(id)
	self.id = id
	self:setIcon(publicRead.getIcon(id))
end
function Button_price:setPrice(price, oldPrice)
	local style = self.controllers.Ctrl_style:getSelectedIndex()
	if oldPrice and oldPrice ~= price then
		self.controllers.Ctrl_style:setSelectedIndex(1)
		self.fields.Text_curPay:setString(string.formatnumberthousands(price))
		self.fields.Text_oriPay:setString(string.formatnumberthousands(oldPrice))
	else
		self.controllers.Ctrl_free:setSelectedIndex(0)
		self.controllers.Ctrl_style:setSelectedIndex(0)
		self.fields.Text_gold:setString(string.formatnumberthousands(price))
	end
	if self.icon and style ~= self.controllers.Ctrl_style:getSelectedIndex() then
		self:setIcon(self.icon)
	end
end
function Button_price:setIcon(icon)
	self.icon = icon
	if self.controllers.Ctrl_style:getSelectedIndex() == 0 then
		self.fields.Icon_gold:setIcon(icon)
	else
		self.fields.Icon_ori:setIcon(icon)
	end
end
function Button_price:setTitle(title)
	self.controllers.Ctrl_free:setSelectedIndex(1)
	self.controllers.Ctrl_style:setSelectedIndex(0)
	self.fields.Text_free:setString(title)
end
function Button_price:setTitleGold(str)
	self.fields.Text_gold:setString(str)
end
function Button_price:setTitleColor(color)
	if self.controllers.Ctrl_style:getSelectedIndex() == 0 then
		self.fields.Text_gold:setColor(color)
	else
		self.fields.Text_gold:setColor(color)
	end
end
function Button_price:setTitleTextColor(color1, color2)
	if self.controllers.Ctrl_style:getSelectedIndex() == 0 then
		self.fields.Icon_gold:setColor(color1)
	else
		self.fields.Text_curPay:setColor(color1 or cc.c3b(255, 255, 0, 1))
		self.fields.Text_oriPay:setColor(color2)
	end
end
function Button_price:setNotEnoughStyle(grayFlag)
	if self.controllers.Ctrl_style:getSelectedIndex() == 0 then
		self.fields.btnBg:setGrayed(grayFlag)
	else
		self.fields.btnBg:setGrayed(grayFlag)
		self.fields.Icon_ori:setGrayed(grayFlag)
	end
end
function Button_price:setStyle(style)
	self.controllers.Ctrl_style:setSelectedIndex(style)
end
function Button_price:getStyle()
	return self.controllers.Ctrl_style:getSelectedIndex()
end
function Button_price:setStatus(haveGold, needGold, isSetGray)
	if needGold <= haveGold then
		self.controllers.Ctrl_status:setSelectedIndex(0)
		if isSetGray then
			self:setNotEnoughStyle(false)
		end
	else
		self.controllers.Ctrl_status:setSelectedIndex(1)
		if isSetGray then
			self:setNotEnoughStyle(true)
		end
	end
end
function Button_price:setGrayed(value)
	self.fields.btnBg:setGrayed(value)
end
function Button_price:setReddot(visible, num)
	if self.fields.Label_reddot then
		self.fields.Label_reddot:initData(visible, num)
	end
end
return Button_price
