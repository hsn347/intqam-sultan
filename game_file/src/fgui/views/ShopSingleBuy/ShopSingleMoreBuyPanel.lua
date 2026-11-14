local publicRead = include("publicRead")
local publicUtil = include("publicUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ShopSingleMoreBuyPanel = class("ShopSingleMoreBuyPanel", baseFguiPanel)
function ShopSingleMoreBuyPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ShopSingleMoreBuyPanel:ctor", self.viewName)
end
function ShopSingleMoreBuyPanel:onInit()
	self.curExchangeNum = 1
	self.fields.Panel_bg:setString(i18n("ramadan_text_22"))
	self.fields.Button_Buy:setString(i18n("common_text_1889"))
	self.fields.Button_Buy:addClickListener(handler(self, self.onBuy))
	self.fields.List_from:setItemRenderer(handler(self, self.onItemFromRenderer))
	self.fields.List_to:setItemRenderer(handler(self, self.onItemToRenderer))
	self.fields.Com_slider:setSliderCallBack(handler(self, self.exChangeUpdate))
	self.fields.Com_slider:setInpuBoxFixPos()
	self.fields.arrow:setRotation(SoraDFIsRA() and -90 or 90)
	self.fields.List_from:fixPos()
	self.fields.List_to:fixPos()
end
function ShopSingleMoreBuyPanel:onShow()
	print("=======ShopSingleMoreBuyPanel:onShow")
	self.shopItemList = self.param.shopItemList
	self.exchangeItemList = self.param.exchangeItemList
	self.leftCount = self.param.leftCount
	self.exchangeHandler = self.param.exchangeHandler
	local maxNum = self.leftCount
	for i, v in ipairs(self.exchangeItemList) do
		if self.leftCount and self.leftCount > 0 then
			maxNum = math.min(math.floor(publicUtil.getCount(v.id) / v.count), maxNum)
		end
	end
	_ENV = ipairs(self.exchangeItemList)
	ipairs(self.exchangeItemList).maxValue = maxNum
	ipairs(self.exchangeItemList).minValue = 1
	ipairs(self.exchangeItemList).curValue = self.curExchangeNum
	self.fields.Com_slider:initData(ipairs(self.exchangeItemList))
end
function ShopSingleMoreBuyPanel:onItemFromRenderer(index, obj)
	obj:initData(self.exchangeItemList[index + 1].id, self.exchangeItemList[index + 1].count * self.curExchangeNum)
end
function ShopSingleMoreBuyPanel:onItemToRenderer(index, obj)
	obj:initData(self.shopItemList[index + 1].id, self.shopItemList[index + 1].count * self.curExchangeNum)
end
function ShopSingleMoreBuyPanel:exChangeUpdate(exChangeCount)
	self.curExchangeNum = exChangeCount
	self.fields.List_from:setNumItems(#self.exchangeItemList)
	self.fields.List_to:setNumItems(#self.shopItemList)
end
function ShopSingleMoreBuyPanel:onBuy(button, type)
	SoraDPlaySound()
	if self.exchangeHandler then
		self.exchangeHandler(math.floor(self.curExchangeNum))
		self:close()
	end
end
return ShopSingleMoreBuyPanel
