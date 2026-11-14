local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_shopSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_shopSingle", Com_shopSingle)
function Com_shopSingle:onInit()
	self.activityID = gActivityTimeActivityID.HERO_CHIP_EXCHANGE_STORE
	self.fields.Button_exchange:setString(i18n("common_text_282"))
	self.fields.Button_exchange:addClickListener(handler(self, self.onClickExchange))
	self:fixChildrenPos()
	self.fields.Sprite_line:fix()
	self.fields.Sprite_arrow:fix()
end
function Com_shopSingle:onShow()
end
function Com_shopSingle:initData(cfg)
	self.cfg = cfg
	self.shopItemID = cfg.shopItemID
	self.fromItemID = cfg.exchangeitem[1]
	self.fromItemCount = cfg.exchangeitem[2]
	self.toItemID = cfg.shopitem[1]
	self.toItemCount = cfg.shopitem[2]
	self.limitNum = cfg.limitnum
	local record = activityExchangeMallCtrl:getExchangeNum(self.activityID, self.shopItemID)
	self.fields.Com_itemFrom:initData(self.fromItemID)
	self.ownCount = activityExchangeMallCtrl:getExchangeItemNum(self.fromItemID)
	self.fields.Com_itemFrom:setNum(self.ownCount, self.fromItemCount)
	self.fields.Com_itemTo:initData(self.toItemID, self.toItemCount)
	self.leftCount = math.max(0, self.limitNum - record)
	local countStr = string.format("%d/%d", self.leftCount, self.limitNum)
	activityExchangeMallCtrl = nil
	;(nil).count = countStr
	self.fields.Text_leftCount:setString(i18n("common_text_1673", nil))
	self.controllers.c1:setSelectedIndex(self.leftCount > 0 and 0 or 1)
end
function Com_shopSingle:onClickExchange()
	if self.controllers.c1:getSelectedIndex() == 1 then
		SoraDShowMsgTip(i18n("common_text_1865"))
		return
	end
	SoraDPlaySound()
	if self.ownCount < self.fromItemCount then
		_ENV = i18n("common_text_1865")
		i18n("common_text_1865").item = publicRead.getName(self.fromItemID)
		SoraDShowMsgTip(i18n("common_text_1806", i18n("common_text_1865")))
	else
		local maxNum = math.floor(self.ownCount / self.fromItemCount)
		maxNum = math.min(maxNum, self.leftCount)
		_ENV, _ENV, _ENV = i18n("common_text_1806", i18n("common_text_1865"))
		i18n("common_text_1806", i18n("common_text_1865")).targetID = self.toItemID
		i18n("common_text_1806", i18n("common_text_1865")).exchangeID = self.fromItemID
		i18n("common_text_1806", i18n("common_text_1865")).singCount = self.fromItemCount
		i18n("common_text_1806", i18n("common_text_1865")).curNum = maxNum
		i18n("common_text_1806", i18n("common_text_1865")).exchangeData, i18n("common_text_1806", i18n("common_text_1865")).singleGet = i18n("common_text_1806", i18n("common_text_1865"))
		i18n("common_text_1806", i18n("common_text_1865")).exchangeCfg, i18n("common_text_1806", i18n("common_text_1865")).exchangeHandler = i18n("common_text_1806", i18n("common_text_1865"))
		uiManager:show("newShopSingleBuy", i18n("common_text_1806", i18n("common_text_1865")))
	end
end
return Com_shopSingle
