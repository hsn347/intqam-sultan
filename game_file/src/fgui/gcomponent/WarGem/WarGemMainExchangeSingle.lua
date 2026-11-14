local publicRead = include("publicRead")
local publicUtil = include("publicUtil")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local activityID = gActivityTimeActivityID.GEM_EXCHANGE_MALL
local baseComponent = require("fgui.base.baseComponent")
local WarGemMainExchangeSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WarGem/WarGemMainExchangeSingle", WarGemMainExchangeSingle)
function WarGemMainExchangeSingle:onInit()
	self:fixChildrenPos()
	self.fields.Image_arrow:fix()
	self.fields.Button_exchange:addClickListener(handler(self, self.onClickExchange))
	self.fields.Text_shop:setString(i18n("gemEnchant_text_64"))
	self.fields.Button_exchange:setString(i18n("common_text_1889"))
end
function WarGemMainExchangeSingle:onClickExchange()
	SoraDPlaySound()
	if self.leftNum <= 0 then
		SoraDShowMsgTip(i18n("gemEnchant_text_63"))
		return
	end
	if self.curNum < self.cfg.exchangenum then
		SoraDShowMsgTip(i18n("gemEnchant_text_62"))
		return
	end
	local exchangeCount = math.floor(self.curNum / self.cfg.exchangenum)
	exchangeCount = math.min(exchangeCount, self.leftNum)
	_ENV, _ENV, _ENV = i18n("gemEnchant_text_62")
	i18n("gemEnchant_text_62").targetID = self.cfg.shopitem
	i18n("gemEnchant_text_62").exchangeID = self.cfg.exchangeitem
	i18n("gemEnchant_text_62").singCount = self.cfg.exchangenum
	i18n("gemEnchant_text_62").curNum = exchangeCount
	i18n("gemEnchant_text_62").exchangeData, i18n("gemEnchant_text_62").singleGet = i18n("gemEnchant_text_62")
	i18n("gemEnchant_text_62").exchangeCfg, i18n("gemEnchant_text_62").exchangeHandler = i18n("gemEnchant_text_62")
	uiManager:show("newShopSingleBuy", i18n("gemEnchant_text_62"))
end
function WarGemMainExchangeSingle:onShow()
end
function WarGemMainExchangeSingle:initData(cfg)
	self.cfg = cfg
	local exchangeitem = cfg.exchangeitem
	local exchangenum = cfg.exchangenum
	local shopitem = cfg.shopitem
	local shopitemnum = cfg.shopitemnum
	self.leftNum = 999
	self.curNum = publicUtil.getCount(exchangeitem)
	if cfg.limitType == 0 then
		self.fields.Text_leftCount:setString("")
	else
		local leftNum = cfg.limitnum - activityExchangeMallCtrl:getExchangeNum(activityID, cfg.shopItemID)
		local maxNum = cfg.limitnum
		self.leftNum = leftNum
		local strLeftNum = leftNum .. "/" .. maxNum
		if leftNum <= 0 then
			strLeftNum = fguiHelper.getColorString("#BE2828", strLeftNum)
		end
		publicUtil = nil
		;(nil).count = strLeftNum
		self.fields.Text_leftCount:setString(i18n("exchange_columntext_01", nil))
	end
	self.fields.Button_exchange:setGrayed(self.leftNum <= 0)
	self.controllers.c1:setSelectedIndex((self.leftNum <= 0 or exchangenum <= self.curNum) and 0 or 1)
	self.fields.Item_exchange:initData(exchangeitem, self.curNum, exchangenum)
	self.fields.Item_shop:initData(shopitem, shopitemnum)
end
return WarGemMainExchangeSingle
