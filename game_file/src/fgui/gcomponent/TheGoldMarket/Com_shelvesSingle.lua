local publicRead = include("publicRead")
local goldSoukCtrl = SoraDGetCtrl("goldSoukCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_shelvesSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TheGoldMarket/Com_shelvesSingle", Com_shelvesSingle)
function Com_shelvesSingle:onInit()
	self.fields.text_ex1:setString(i18n("common_text_437"))
	self.fields.text_ex2:setString(i18n("common_text_437"))
	self.fields.btn_buy1:addClickListener(handler(self, self.onBtnClick))
	self.fields.btn_buy2:addClickListener(handler(self, self.onBtnClick))
	self:fixChildrenPos()
	self.fields.btn_buy1:fixChildrenPos()
	self.fields.btn_buy2:fixChildrenPos()
	self.fields.ex1:fix()
	self.fields.ex2:fix()
	self.fields.text_ex1:fix()
	self.fields.text_ex2:fix()
end
function Com_shelvesSingle:onShow()
end
function Com_shelvesSingle:initData(cfg)
	self.cfg = cfg
	local rightData = self.cfg[1]
	local leftData = self.cfg[2]
	self.soukCoin = goldSoukCtrl:getSoukCoin()
	if rightData then
		local boughtCount1 = goldSoukCtrl:getItemBuyCount(rightData.shopId)
		self.fields.item1:initData(rightData.Item[1], rightData.Item[2])
		goldSoukCtrl = nil
		;(nil).count = math.max(0, rightData.purchaseLimit - boughtCount1)
		self.fields.text_limit1:setString(i18n("GoldSouk_text_08", nil))
		self.fields.text_name1:setString(publicRead.getName(rightData.Item[1]))
		self.fields.btn_buy1:setTitle(rightData.price[2])
		self.fields.btn_buy1:setTitleColor(self.soukCoin >= rightData.price[2] and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40))
		self.fields.btn_buy1:setTag(rightData.shopId)
		local leftBuyCount1 = rightData.purchaseLimit - boughtCount1
		self.fields.btn_buy1:setBright(leftBuyCount1 <= 0)
		self.fields.ex1:setVisible(rightData.ExGratia == 1)
		self.fields.text_ex1:setVisible(rightData.ExGratia == 1)
		self.fields.item1:setVisible(true)
		self.fields.n19:setVisible(true)
		self.fields.btn_buy1:setVisible(true)
		self.fields.text_name1:setVisible(true)
		self.fields.text_limit1:setVisible(true)
		self.fields.n34:setVisible(true)
	else
		self.fields.item1:setVisible(false)
		self.fields.n19:setVisible(false)
		self.fields.btn_buy1:setVisible(false)
		self.fields.text_name1:setVisible(false)
		self.fields.ex1:setVisible(false)
		self.fields.text_ex1:setVisible(false)
		self.fields.text_limit1:setVisible(false)
		self.fields.n34:setVisible(false)
	end
	if leftData then
		local boughtCount2 = goldSoukCtrl:getItemBuyCount(leftData.shopId)
		self.fields.item2:initData(leftData.Item[1], leftData.Item[2])
		goldSoukCtrl = 40
		;(40).count = math.max(0, leftData.purchaseLimit - boughtCount2)
		self.fields.text_limit2:setString(i18n("GoldSouk_text_08", 40))
		self.fields.text_name2:setString(publicRead.getName(leftData.Item[1]))
		self.fields.btn_buy2:setTitle(leftData.price[2])
		self.fields.btn_buy2:setTitleColor(self.soukCoin >= leftData.price[2] and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40))
		self.fields.btn_buy2:setTag(leftData.shopId)
		local leftBuyCount2 = leftData.purchaseLimit - boughtCount2
		self.fields.btn_buy2:setBright(leftBuyCount2 <= 0)
		self.fields.ex2:setVisible(leftData.ExGratia == 1)
		self.fields.text_ex2:setVisible(leftData.ExGratia == 1)
		self.fields.item2:setVisible(true)
		self.fields.n16:setVisible(true)
		self.fields.btn_buy2:setVisible(true)
		self.fields.text_name2:setVisible(true)
		self.fields.text_limit2:setVisible(true)
		self.fields.n32:setVisible(true)
	else
		self.fields.item2:setVisible(false)
		self.fields.n16:setVisible(false)
		self.fields.btn_buy2:setVisible(false)
		self.fields.text_name2:setVisible(false)
		self.fields.ex2:setVisible(false)
		self.fields.text_ex2:setVisible(false)
		self.fields.text_limit2:setVisible(false)
		self.fields.n32:setVisible(false)
	end
end
function Com_shelvesSingle:getItemInfo(shopId)
	for k, v in ipairs(self.cfg) do
		if v.shopId == shopId then
			return v.Item[1], v.Item[2], v.price[2], v.purchaseLimit
		end
	end
end
function Com_shelvesSingle:onBtnClick(context)
	SoraDPlaySound()
	local shopId = context:getSender():getTag()
	local itemId, itemNum, price, limit = self:getItemInfo(shopId)
	local boughtCount = goldSoukCtrl:getItemBuyCount(shopId)
	if price > self.soukCoin then
		SoraDShowMsgBox(i18n("GoldSouk_text_03"), i18n("common_text_204"), i18n("common_text_185"), function(event)
			if event == MSGBOX_CALLBACK_YES then
				print("跳转到充值礼包======")
				_UPVALUE3_ = print
				print[1] = 19041
				print[2] = 19042
				local print[3], giftArray = 19043, print
				if GLOBAL_GAME_RECHARGE_MODE then
					_ENV = nil
					;(nil).rechargeIDList = giftArray
					uiManager:show("rechargeView", nil)
				else
					local panel = SoraDCreatePanel("rechargeView")
					panel:jumpToLimitNodeByList(12, giftArray)
					panel:show()
				end
			end
		end)
	else
		local maxBuyCount = math.min(limit - boughtCount, math.floor(self.soukCoin / price))
		if maxBuyCount < 1 then
			SoraDShowMsgTip(i18n("shopping_text_08"))
		else
			_ENV, _ENV, _ENV = i18n("shopping_text_08")
			i18n("shopping_text_08").targetID = itemId
			i18n("shopping_text_08").exchangeID = gIDDef.GOLD_SOUK
			i18n("shopping_text_08").singCount = price
			i18n("shopping_text_08").curNum = maxBuyCount
			i18n("shopping_text_08").exchangeData, i18n("shopping_text_08").singleGet = i18n("shopping_text_08")
			i18n("shopping_text_08").exchangeCfg, i18n("shopping_text_08").exchangeHandler = i18n("shopping_text_08")
			uiManager:show("newShopSingleBuy", i18n("shopping_text_08"))
		end
	end
end
return Com_shelvesSingle
