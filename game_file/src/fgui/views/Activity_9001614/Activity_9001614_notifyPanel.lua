local activity_9001614_Read = include("activity_9001614_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001614_notifyPanel = class("Activity_9001614_notifyPanel", baseFguiPanel)
function Activity_9001614_notifyPanel:ctor(...)
	Activity_9001614_notifyPanel.super.ctor(self, ...)
	print("Activity_9001614_notifyPanel:ctor", self.viewName)
end
function Activity_9001614_notifyPanel:onInit()
	print("=======Activity_9001614_notifyPanel:onInit")
	self.items, _ENV = print, print
	self.fields.Text_tip:setString(i18n("recharge_return_text_03"))
	self.fields.Text_des:setString(i18n("recharge_return_text_04"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setAlignCenter(true)
	self.view:fixChildrenPos()
	self.fields.n0:fix()
end
function Activity_9001614_notifyPanel:onItemRenderer(index, obj)
	obj:initData(self.items[index + 1].id, self.items[index + 1].count)
end
function Activity_9001614_notifyPanel:onShow()
	print("=======Activity_9001614_notifyPanel:onShow")
	self.controllers.c1:setSelectedIndex(SoraDFIsRA() and 0 or 1)
	self.giftData = self.param.giftData
	local leftTime = self.giftData.time + 86400 - serviceFunctions.systemTime()
	self.fields.Text_time:beginTime(leftTime)
	self.fields.Text_time:setTimeEndListener(handler(self, self.closeSelf))
	local cfg = activity_9001614_Read.getNotifyGiftCfg(self.giftData.rechargeid)
	_UPVALUE2_ = handler(self, self.closeSelf)
	handler(self, self.closeSelf)[1] = "id"
	handler(self, self.closeSelf)[2] = "count"
	self.items = serviceFunctions.tableFormat(cfg.reward, handler(self, self.closeSelf))
	self.fields.List:setNumItems(#self.items)
	local showPrice, isGetPrice = paymentManager.judgePrice(self.giftData.rechargeid, cfg.rechargePrice)
	local discount = cfg.originalPrice / cfg.rechargePrice
	local oriShowPrice = paymentManager.calculateDiscount(self.giftData.rechargeid, showPrice, discount, cfg.originalPrice)
	if SoraDCheckOAPIsOpen(self.giftData.rechargeid) then
		self.fields.outAppPurchaseButtons:setVisible(true)
		self.fields.Button_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.giftData.rechargeid
		;(false).nowPrice = showPrice
		_ENV, (false).oriPrice = self.giftData.rechargeid, oriShowPrice
		;(false).logInfo, self.giftData.rechargeid.fromCenter = self.giftData.rechargeid, gRechargeActiveFromEnum.ROAD51
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.fields.outAppPurchaseButtons:initData(false)
	else
		self.fields.outAppPurchaseButtons:setVisible(false)
		self.fields.Button_buy:setVisible(true)
		self.fields.Button_buy:setEnabled(true)
		self.fields.Button_buy:initData(showPrice, oriShowPrice)
	end
end
function Activity_9001614_notifyPanel:btnBuyClick()
	SoraDPlaySound()
	paymentManager.normalGiftBuyClassify(self.giftData.rechargeid)
	paymentManager.OnemtReadyBuy(self.giftData.rechargeid, gRechargeActiveFromEnum.ROAD51, false)
end
function Activity_9001614_notifyPanel:closeSelf()
	self:close()
end
return Activity_9001614_notifyPanel
