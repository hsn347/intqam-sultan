local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_discountGood = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RamadanMarket/Com_discountGood", Com_discountGood)
function Com_discountGood:onInit()
	self:fixChildrenPos()
	self.fields.n9:fix(false)
	self.fields.Button_price:addClickListener(handler(self, self.onClickBuy))
end
function Com_discountGood:initData(index, data, btnHandle)
	self.data = data
	self.btnHandle = btnHandle
	self.fields.Text_name:setString(publicRead.getName(data.itemID))
	if not self.first then
		self.fields.Button_price:setItemID(1001)
		self.first = true
	end
	self.fields.Button_price:setPrice(data.discount, data.price)
	self.fields.Button_price:setStatus(data.haveGold, data.discount)
	self.fields.Button_price:setTitleTextColor(cc.c3b(255, 255, 0, 1), cc.c3b(255, 200, 0, 1))
	self.fields.Com_item:initData(data.itemID, data.limitNum - data.alreadyBuyCount, data.limitNum)
	if data.curActive < data.activeNum then
		self.fields.Button_price:setNotEnoughStyle(true)
		self.fields.Com_item:setGrayed(true)
	else
		self.fields.Button_price:setNotEnoughStyle(false)
		self.fields.Com_item:setGrayed(false)
	end
	if data.haveGold < data.discount then
		self.fields.Button_price:setTitleTextColor(cc.c3b(255, 0, 0, 1), cc.c3b(255, 200, 0, 1))
	else
		self.fields.Button_price:setTitleTextColor(cc.c3b(255, 255, 0, 1), cc.c3b(255, 200, 0, 1))
	end
	if data.limitNum <= data.alreadyBuyCount then
		self.fields.Button_price:setNotEnoughStyle(true)
		self.fields.Com_item:setNumColor2(data.limitNum - data.alreadyBuyCount, data.limitNum, "#FF0008")
	else
		self.fields.Com_item:setNumColor2(data.limitNum - data.alreadyBuyCount, data.limitNum, "#FFFFFF")
	end
end
function Com_discountGood:onClickBuy()
	self.btnHandle(self.data)
end
function Com_discountGood:onShow()
end
return Com_discountGood
