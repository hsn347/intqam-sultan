local publicRead = include("publicRead")
local constantRead = include("constantRead")
local activity_9001612_Ctrl = SoraDGetCtrl("activity_9001612_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_shopItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001612/Com_shopItem", Com_shopItem)
function Com_shopItem:onInit()
	self.coinID = constantRead.getConstValue("PLAYER_GLORY_RETURN_STORE_ITEM")
	self.fields.Button_buy:addClickListener(handler(self, self.btnClickBuy))
	self:fixChildrenPos()
end
function Com_shopItem:onShow()
end
function Com_shopItem:initData(data)
	self.data = data
	self.fields.com_item:initData(self.data.shopitem[1], self.data.shopitem[2])
	self.fields.Text_Name:setString(publicRead.getName(self.data.shopitem[1]))
	self.fields.Lab_discount:setString(string.format("%d%%", math.ceil(self.data.baseprice / self.data.exchangeitem) * 100))
	local exchangeTimes = activity_9001612_Ctrl:getExchangeTimes(self.data.shopItemID)
	self.leftTimes = math.max(0, self.data.limitnum - exchangeTimes)
	publicRead = string.format("%d%%", math.ceil(self.data.baseprice / self.data.exchangeitem) * 100)
	string.format("%d%%", math.ceil(self.data.baseprice / self.data.exchangeitem) * 100).var1 = fguiHelper.getColorString(self.leftTimes > 0 and "#D7C39B" or "#FF0000", self.leftTimes)
	string.format("%d%%", math.ceil(self.data.baseprice / self.data.exchangeitem) * 100).var2 = self.data.limitnum
	self.fields.Text_Limit:setString(i18n("%{var1}/%{var2}", string.format("%d%%", math.ceil(self.data.baseprice / self.data.exchangeitem) * 100)))
	self.fields.Button_buy:initData(self.coinID, self.data.exchangeitem, self.data.baseprice)
end
function Com_shopItem:btnClickBuy()
	SoraDPlaySound()
	if self.leftTimes <= 0 then
		SoraDShowMsgTip(i18n("Player_Return_test02"))
		return
	end
	local coinCount = backpackCtrl:getItemCount(self.coinID)
	if coinCount < self.data.exchangeitem then
		SoraDShowMsgTip(i18n("Player_Return_test01"))
		return
	end
	_ENV, _ENV, _ENV = i18n("Player_Return_test01")
	i18n("Player_Return_test01").targetID = self.data.shopitem[1]
	i18n("Player_Return_test01").singleGet = self.data.shopitem[2]
	i18n("Player_Return_test01").exchangeID = self.coinID
	i18n("Player_Return_test01").singCount = self.data.exchangeitem
	i18n("Player_Return_test01").exchangeData, i18n("Player_Return_test01").curNum = i18n("Player_Return_test01")
	i18n("Player_Return_test01").exchangeCfg, i18n("Player_Return_test01").exchangeHandler = i18n("Player_Return_test01")
	uiManager:show("newShopSingleBuy", i18n("Player_Return_test01"))
end
return Com_shopItem
