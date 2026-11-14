local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_shopSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://HeroWeapon/Com_shopSingle", Com_shopSingle)
function Com_shopSingle:onInit()
	self.activityID = gActivityTimeActivityID.HERO_WEAPON_EXCHANGE_STORE
	self.fields.Button_buy:setString(i18n("common_text_282"))
	self.fields.Button_buy:addClickListener(handler(self, self.onBtnBuyClick))
	self:fixChildrenPos()
	self.fields.Sprite_line:fix()
	self.fields.Sprite_arrow:fix()
end
function Com_shopSingle:onShow()
end
function Com_shopSingle:initData(cfg)
	self.cfg = cfg
	self.shopItemID = cfg.shopItemID
	self.fromItemID = cfg.exchangeitem
	self.fromItemCount = cfg.exchangenum
	self.toItemID = cfg.shopitem
	self.toItemCount = cfg.shopitemnum
	self.limitNum = cfg.limitnum
	self.ownCount = backpackCtrl:getItemCount(self.fromItemID)
	self.fields.Com_itemFrom:initData(self.fromItemID)
	self.fields.Com_itemFrom:setNum(self.ownCount, self.fromItemCount)
	self.fields.Com_itemTo:initData(self.toItemID, self.toItemCount)
	local exchangedCount = activityExchangeMallCtrl:getExchangeNum(self.activityID, self.shopItemID)
	self.leftCount = math.max(0, self.limitNum - exchangedCount)
	local countStr = string.format("%d/%d", self.leftCount, self.limitNum)
	backpackCtrl = nil
	;(nil).count = countStr
	self.fields.Text_leftCount:setString(i18n("common_text_1673", nil))
	self.controllers.c1:setSelectedIndex(self.leftCount > 0 and 0 or 1)
	self.fields.Button_buy:setEnabled(self.leftCount > 0 and self.ownCount >= self.fromItemCount)
end
function Com_shopSingle:onBtnBuyClick()
	SoraDPlaySound()
	_ENV, _ENV, _ENV = nil, nil, nil
	;(nil).targetID = self.toItemID
	;(nil).exchangeID = self.fromItemID
	;(nil).singCount = self.fromItemCount
	;(nil).curNum = math.min(self.leftCount, math.floor(self.ownCount / self.fromItemCount))
	;(nil).exchangeData, (nil).singleGet = nil, self.toItemCount
	;(nil).exchangeCfg, (nil).exchangeHandler = nil, function(exchangeNum)
		activityExchangeMallCtrl:reqActivityExchange(self.shopItemID, exchangeNum)
	end
	uiManager:show("newShopSingleBuy", nil)
end
return Com_shopSingle
