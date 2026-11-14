local activity_9001731_Read = include("activity_9001731_Read")
local activity_9001731_Ctrl = SoraDGetCtrl("activity_9001731_Ctrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001731_ItemGetPanel = class("Activity_9001731_ItemGetPanel", baseFguiPanel)
function Activity_9001731_ItemGetPanel:ctor(...)
	self.isLRU = true
	Activity_9001731_ItemGetPanel.super.ctor(self, ...)
	print("Activity_9001731_ItemGetPanel:ctor", self.viewName)
end
function Activity_9001731_ItemGetPanel:onInit()
	print("=======Activity_9001731_ItemGetPanel:onInit")
	self.rechargeCfg = activity_9001731_Read.getRechargeCfg(2)
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.List_reward:setItemRenderer(handler(self, self.itemRenderer_List_reward))
	self.fields.Panel_bg:setString(i18n("common_text_4342"))
	self.fields.Text_name:setString(i18n(self.rechargeCfg.rechargeName))
	_ENV = i18n(self.rechargeCfg.rechargeName)
	i18n(self.rechargeCfg.rechargeName).num = 1
	self.fields.Text_tip:setString(i18n("common_text_4599", i18n(self.rechargeCfg.rechargeName)))
end
function Activity_9001731_ItemGetPanel:endShow()
	print("=======Activity_9001731_ItemGetPanel:endShow")
	_ENV, _ENV = "=======Activity_9001731_ItemGetPanel:endShow", print
	;("=======Activity_9001731_ItemGetPanel:endShow").icon = "icon_activity_9001731.png"
	;("=======Activity_9001731_ItemGetPanel:endShow").title = i18n("Ludo_test_032")
	;("=======Activity_9001731_ItemGetPanel:endShow").des = i18n("snow_competition_text_10")
	self.getWayList, print[1], ("=======Activity_9001731_ItemGetPanel:endShow").handler = print, "=======Activity_9001731_ItemGetPanel:endShow", handler(self, self.onClick_go)
	self.fields.List:setNumItems(#self.getWayList)
	self:initGift()
	self:updateView()
end
function Activity_9001731_ItemGetPanel:initGift()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.giftReward = serviceFunctions.tableFormat(self.rechargeCfg.reward, nil)
	self.fields.List_reward:setNumItems(#self.giftReward)
	self.fields.Lab_discount:setTitle(tostring(math.floor(self.rechargeCfg.discount[2] / self.rechargeCfg.discount[1])) .. "%")
	local showPrice, isGetPrice = paymentManager.judgePrice(self.rechargeCfg.rechargeID, self.rechargeCfg.rechargePrice)
	local discount = self.rechargeCfg.originalPrice / self.rechargeCfg.rechargePrice
	local oriShowPrice = paymentManager.calculateDiscount(self.rechargeCfg.rechargeID, showPrice, discount, self.rechargeCfg.originalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self:updateOutAppPurchase()
end
function Activity_9001731_ItemGetPanel:updateOutAppPurchase()
	_ENV = nil
	;(nil).rid = self.rechargeCfg.rechargeID
	;(nil).nowPrice = self.nowPrice
	_ENV, (nil).oriPrice = self.oriPrice, self.oriPrice
	;(nil).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD65
	;(nil).handleBuyClick = handler(self, self.btnBuyClick)
	;(nil).handleItemBuyClick = handler(self, self.onClickItemBuyGift)
	self.fields.Com_OutAppPurchaseButtons:initData(nil)
end
function Activity_9001731_ItemGetPanel:updateView()
	local rechargeData = rechargeActivityCtrl:getRechargeActivityData(self.rechargeCfg.rechargeID)
	local limitCount = rechargeData and tonumber(rechargeData.extraData) or 0
	self.controllers.c1:setSelectedIndex(0 < limitCount and 1 or 0)
end
function Activity_9001731_ItemGetPanel:itemRenderer_List(index, obj)
	local data = self.getWayList[index + 1]
	obj:initData(data)
end
function Activity_9001731_ItemGetPanel:itemRenderer_List_reward(index, obj)
	local data = self.giftReward[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001731_ItemGetPanel:onClick_go()
	_ENV = nil
	;(nil).tag = 2
	uiManager:show("Activity_9001731_Main", nil)
	self:close()
end
function Activity_9001731_ItemGetPanel:btnBuyClick()
	SoraDPlaySound()
	paymentManager.normalGiftBuyClassify(self.rechargeCfg.rechargeID)
	paymentManager.OnemtReadyBuy(self.rechargeCfg.rechargeID, gRechargeActiveFromEnum.ROAD65)
end
function Activity_9001731_ItemGetPanel:onClickItemBuyGift()
	SoraDPlaySound()
	return true
end
return Activity_9001731_ItemGetPanel
