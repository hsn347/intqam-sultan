local cityCtrl = SoraDGetCtrl("cityCtrl")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_buy = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://merchanteView/Btn_buy", Btn_buy)
function Btn_buy:onInit()
	self.fields.icon:fixPos()
	self.fields.Text_oldPrice:fixPos()
	self.fields.Text_price:fixPos()
	self.fields.n4:fixPos()
end
function Btn_buy:onShow()
end
function Btn_buy:initData(data)
	self.itemData = data
	if gIDDef.GOLD ~= self.itemData.pricetype then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_price:setString(string.formatnumberthousands(self.itemData.price))
		local haveRes = cityCtrl:getResCount(self.itemData.pricetype)
		self.fields.Text_price:setColor(haveRes >= self.itemData.price and cc.c3b(255, 251, 213) or cc.c3b(190, 40, 40))
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_nowPrice:setString(string.formatnumberthousands(self.itemData.price))
		self.fields.Text_nowPrice:setColor(SoraDEnoughGold(self.itemData.price, true) and cc.c3b(255, 251, 213) or cc.c3b(190, 40, 40))
		self.fields.Text_nowPrice:fixPos()
		if self.itemData.primeprice then
			self.fields.Text_oldPrice:setString(string.formatnumberthousands(self.itemData.primeprice))
		else
			self.controllers.c1:setSelectedIndex(2)
		end
	end
	self.fields.icon:setSpriteFrame(publicRead.getSmallIcon(self.itemData.pricetype))
end
return Btn_buy
