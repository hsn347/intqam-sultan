local publicRead = include("publicRead")
local constantRead = include("constantRead")
local activity_9001678_Read = include("activity_9001678_Read")
local activity_9001678_Ctrl = SoraDGetCtrl("activity_9001678_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_marketItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001678/Com_marketItem", Com_marketItem)
function Com_marketItem:onInit()
	self.fields.Text_dis:setString(i18n("Frosty_Market_text_28"))
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyClick))
end
function Com_marketItem:onShow()
end
function Com_marketItem:initData(data)
	local goodsID = data.id
	local goodsType = data.goodsType
	self.data = activity_9001678_Read.getFrostyMarketCfg(goodsID)
	self.fields.Com_item:initData(self.data.goodCfg.id, self.data.goodCfg.count)
	self.fields.Text_name:setString(publicRead.getName(self.data.goodCfg.id))
	local dayBuyCount = activity_9001678_Ctrl:getDayBuyCount(self.data.goodsID)
	self.isCellOut = self.data.limit - dayBuyCount <= 0
	activity_9001678_Read = publicRead.getName(self.data.goodCfg.id)
	publicRead.getName(self.data.goodCfg.id).num = self.data.limit - dayBuyCount
	self.fields.Text_dailyLimit:setString(i18n("Frosty_Market_text_03", publicRead.getName(self.data.goodCfg.id)))
	local discount, count = activity_9001678_Ctrl:getDayDiscount(self.data.goodsID)
	local isMaxDiscount = count >= constantRead.getConstValue("FORSTY_DISCOUNT_NUM", 3)
	self.controllers.c1:setSelectedIndex(isMaxDiscount and 1 or 0)
	self.fields.Text_dis:setString(goodsType == 0 and i18n("common_text_049") or i18n("Frosty_Market_text_28"))
	if self.isCellOut then
		self.fields.Button_buy:initTitle(i18n("common_text_4376"))
	else
		self.fields.Button_buy:initData(self.data.oriPrice.id, i18n("Frosty_Market_text_04"), math.max(0, self.data.oriPrice.count - discount), self.data.oriPrice.count)
	end
end
function Com_marketItem:btnBuyClick()
	SoraDPlaySound()
	if self.isCellOut then
		SoraDShowMsgTip(i18n("Stellar_Odyssey_text_07"))
	else
		_ENV = i18n("Stellar_Odyssey_text_07")
		i18n("Stellar_Odyssey_text_07").data = self.data
		uiManager:show("Activity_9001678_Help", i18n("Stellar_Odyssey_text_07"))
	end
end
return Com_marketItem
