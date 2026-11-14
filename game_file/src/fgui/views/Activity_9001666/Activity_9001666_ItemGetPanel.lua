local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001666_ItemGetPanel = class("Activity_9001666_ItemGetPanel", baseFguiPanel)
local activity_9001666_Ctrl = SoraDGetCtrl("activity_9001666_Ctrl")
local constantRead = include("constantRead")
local activity_9001666_Read = include("activity_9001666_Read")
function Activity_9001666_ItemGetPanel:ctor(...)
	Activity_9001666_ItemGetPanel.super.ctor(self, ...)
	print("Activity_9001666_ItemGetPanel:ctor", self.viewName)
end
function Activity_9001666_ItemGetPanel:onInit()
	print("=======Activity_9001666_ItemGetPanel:onInit")
	self.view:fixChildrenPos()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001666_ItemGetPanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1].id, self.itemList[index + 1].count)
end
function Activity_9001666_ItemGetPanel:onShow()
	print("=======Activity_9001666_ItemGetPanel:onShow")
	self:updateView()
end
function Activity_9001666_ItemGetPanel:updateView()
	self.panelType = self.param.type
	if self.panelType == "GetItem" then
		self.fields.Panel_bg:setTitle(i18n("snow_competition_text_09"))
		_ENV = i18n("snow_competition_text_09")
		i18n("snow_competition_text_09").showType = 0
		i18n("snow_competition_text_09").title = i18n("snow_competition_text_01")
		i18n("snow_competition_text_09").desc = i18n("snow_competition_text_10")
		i18n("snow_competition_text_09").icon = "icon_activity_9001666.png"
		i18n("snow_competition_text_09").index = 1
		i18n("snow_competition_text_09").callback = handler(self, self.onGetItem)
		self.fields.Com_9001666_itemGet1:initData(i18n("snow_competition_text_09"))
		_ENV = i18n("snow_competition_text_09")
		i18n("snow_competition_text_09").showType = 0
		i18n("snow_competition_text_09").title = i18n("snow_competition_text_11")
		i18n("snow_competition_text_09").desc = i18n("snow_competition_text_12")
		i18n("snow_competition_text_09").icon = "icon_activity_9001666.png"
		i18n("snow_competition_text_09").index = 2
		i18n("snow_competition_text_09").callback = handler(self, self.onGetItem)
		self.fields.Com_9001666_itemGet2:initData(i18n("snow_competition_text_09"))
	else
		self.fields.Panel_bg:setTitle(i18n("kindofwar_btn_01"))
		_ENV = i18n("kindofwar_btn_01")
		i18n("kindofwar_btn_01").showType = 1
		i18n("kindofwar_btn_01").desc = i18n("snow_competition_text_12")
		i18n("kindofwar_btn_01").icon = "icon_activity_9001666.png"
		i18n("kindofwar_btn_01").index = 1
		i18n("kindofwar_btn_01").callback = handler(self, self.onGetItem)
		self.fields.Com_9001666_itemGet1:initData(i18n("kindofwar_btn_01"))
		self.fields.Com_9001666_itemGet2:setVisible(false)
	end
	self.isCanBuyDailyGift = activity_9001666_Ctrl:getIsCanBuyDailyGift()
	self.controllers.c1:setSelectedIndex(self.isCanBuyDailyGift and 1 or 0)
	if self.isCanBuyDailyGift then
		self:updateGift()
	end
end
function Activity_9001666_ItemGetPanel:updateGift()
	local rid = constantRead.getConstValue("SNOW_COMPETITION_DAILY_RECHARGE", 19735)
	local giftCfg = activity_9001666_Read.getRechargeCfg(rid)
	dump(giftCfg, "giftCfg")
	self.giftCfg = giftCfg
	self.fields.Text_name:setString(i18n(giftCfg.rechargeName))
	_ENV = i18n(giftCfg.rechargeName)
	i18n(giftCfg.rechargeName)[1] = "id"
	i18n(giftCfg.rechargeName)[2] = "count"
	self.itemList = serviceFunctions.tableFormat(giftCfg.reward, i18n(giftCfg.rechargeName))
	constantRead = i18n(giftCfg.rechargeName)
	i18n(giftCfg.rechargeName).id = 1001
	i18n(giftCfg.rechargeName).count = giftCfg.gold
	table.insert(self.itemList, i18n(giftCfg.rechargeName))
	self.fields.List:setNumItems(#self.itemList)
	self.fields.Lab_discount:setTitle(tostring(math.floor(giftCfg.discount[2] / giftCfg.discount[1])) .. "%")
	local showPrice, isGetPrice = paymentManager.judgePrice(giftCfg.id, giftCfg.rechargePrice)
	local discount = giftCfg.originalPrice / giftCfg.rechargePrice
	local oriShowPrice = paymentManager.calculateDiscount(giftCfg.id, showPrice, discount, giftCfg.originalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self:updateOutAppPurchase()
end
function Activity_9001666_ItemGetPanel:updateOutAppPurchase()
	self.fields.Com_OutAppPurchaseButtons:setVisible(true)
	_ENV = true
	;(true).rid = self.giftCfg.rechargeID
	;(true).nowPrice = self.nowPrice
	_ENV, (true).oriPrice = self.oriPrice, self.oriPrice
	;(true).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD53
	;(true).handleBuyClick = handler(self, self.btnBuyClick)
	;(true).handleItemBuyClick = handler(self, self.onClickItemBuyGift)
	self.fields.Com_OutAppPurchaseButtons:initData(true)
end
function Activity_9001666_ItemGetPanel:onClickItemBuyGift()
	SoraDPlaySound()
	return true
end
function Activity_9001666_ItemGetPanel:btnBuyClick()
	SoraDPlaySound()
	paymentManager.normalGiftBuyClassify(self.giftCfg.rechargeID)
	paymentManager.OnemtReadyBuy(self.giftCfg.rechargeID, gRechargeActiveFromEnum.ROAD53)
end
function Activity_9001666_ItemGetPanel:onGetItem(data)
	if data.showType == 0 then
		if data.index == 1 then
			local view = uiManager:getProxy("Activity_9001666_Main").view
			if view then
				view:switchTab(2)
			end
			self:close()
		elseif data.index == 2 then
			_ENV = 2
			;(2).type = "Free"
			uiManager:show("Activity_9001666_ItemGet", 2)
		end
	else
		activity_9001666_Ctrl:reqSnowCompetitionFreeTicket()
	end
end
return Activity_9001666_ItemGetPanel
