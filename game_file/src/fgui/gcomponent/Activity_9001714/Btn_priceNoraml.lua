local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_priceNoraml = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001714/Btn_priceNoraml", Btn_priceNoraml)
fgui.register_extension("ui://Activity_9001714/Btn_priceMiddle", Btn_priceNoraml)
function Btn_priceNoraml:onInit()
	self.fields.Label_reddot:setVisible(false)
	self.fields.Text_gold:fixPos()
	self.fields.Icon:fixPos()
	self.fields.Icon_gold:fixPos()
	self.fields.Text_cur:fixPos()
	self.fields.Text_ori:fixPos()
	self.fields.line:fixPos()
end
function Btn_priceNoraml:onShow()
end
function Btn_priceNoraml:initData(id, title, price, oriPrice)
	self.fields.title:setString(title)
	if oriPrice ~= price then
		self.controllers.c2:setSelectedIndex(1)
		self.fields.Icon_gold:setSpriteFrame(publicRead.getIcon(id))
		self.fields.Text_cur:setString(price)
		self.fields.Text_ori:setString(oriPrice)
	else
		self.controllers.c2:setSelectedIndex(0)
		self.fields.Icon:setSpriteFrame(publicRead.getIcon(id))
		self.fields.Text_gold:setString(price)
	end
end
function Btn_priceNoraml:initTitle(title)
	self.controllers.c2:setSelectedIndex(2)
	self.fields.title:setString(title)
end
return Btn_priceNoraml
