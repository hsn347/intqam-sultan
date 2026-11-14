local baseComponent = require("fgui.base.baseComponent")
local rechargeRead = include("rechargeRead")
local Com_9001724_Cell = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001711/Com_9001724_Cell", Com_9001724_Cell)
function Com_9001724_Cell:onInit()
	self.fields.Button_itemBuy:addClickListener(handler(self, self.onClickItemBuy))
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBuy))
	self.text_time = SoraDCreateTimerLabel(self, self.fields.text_time)
	self.text_time:setTimeLast(function(tick, timeNumber)
		_ENV = nil
		;(nil).time = tick
		return i18n("common_text_4915", nil)
	end)
	self.text_time:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_ACTIVITY_9001711_UPDATE"
		SoraDSendMessage(nil)
	end)
	self.fields.text_soldOut:setString(i18n("common_text_4376"))
	self.fields.list_rewards:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
end
function Com_9001724_Cell:onShow()
end
function Com_9001724_Cell:initData(data, tabIndex)
	self.curGift = data
	self.rid = self.curGift.rid
	self.rewards = clone(self.curGift.cfg.rewards)
	_ENV = nil
	;(nil).id = gIDDef.GOLD
	;(nil).count = self.curGift.cfg.gold
	table.insert(self.rewards, nil)
	self.fields.list_rewards:setNumItems(#self.rewards)
	_ENV = nil
	_ENV, _ENV, (nil).num = nil, self.curGift.remainNum, self.curGift.remainNum
	self.curGift.remainNum.num, (nil).color = nil, "#FFD43E"
	self.fields.text_num:setString(i18n_html("common_text_2516", nil, self.curGift.remainNum))
	self.text_time:beginTime(self.curGift.buyEndTime - serviceFunctions.systemTime())
	local giftCfg = self.curGift.cfg
	self.giftCfg = giftCfg
	self.fields.Lab_discount:setTitle(tostring(math.floor(giftCfg.discount[2] / giftCfg.discount[1])) .. "%")
	local showPrice, isGetPrice = paymentManager.judgePrice(self.rid, giftCfg.price)
	local discount = giftCfg.originalPrice / giftCfg.price
	local oriShowPrice = paymentManager.calculateDiscount(self.rid, showPrice, discount, giftCfg.originalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self:updateOutAppPurchase()
	self.controllers.c1:setSelectedIndex(self.curGift.remainNum <= 0 and 2 or tabIndex == 1 and 0 or 1)
end
function Com_9001724_Cell:updateOutAppPurchase()
	self.fields.Button_buy:initData(self.nowPrice, self.oriPrice)
	self.fields.Button_itemBuy:initData(nil, nil, self.rid)
end
function Com_9001724_Cell:onItemRenderer(index, obj)
	local data = self.rewards[index + 1]
	obj:initData(data.id, data.count)
	if index < (self.curGift.cfg.highlight or 0) then
		obj:setEffect(2)
	else
		obj:hideEffect()
	end
end
function Com_9001724_Cell:onClickBuy()
	SoraDPlaySound()
	paymentManager.normalGiftBuyClassify(self.rid)
	paymentManager.OnemtReadyBuy(self.rid, gRechargeActiveFromEnum.ROAD61)
end
function Com_9001724_Cell:onClickItemBuy(button, event)
	SoraDPlaySound()
	_ENV = nil
	;(nil).fromCenter = gRechargeActiveFromEnum.ROAD61
	SoraDShowH5PurchaseView(self.rid, nil, nil)
end
return Com_9001724_Cell
