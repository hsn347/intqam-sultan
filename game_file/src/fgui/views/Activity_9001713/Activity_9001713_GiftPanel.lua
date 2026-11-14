local activity_9001713_Read = include("activity_9001713_Read")
local commonBuyGiftCtrl = SoraDGetCtrl("commonBuyGiftCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001713_GiftPanel = class("Activity_9001713_GiftPanel", baseFguiPanel)
function Activity_9001713_GiftPanel:ctor(...)
	self.isLRU = true
	Activity_9001713_GiftPanel.super.ctor(self, ...)
	print("Activity_9001713_GiftPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_SHOP_2025
end
function Activity_9001713_GiftPanel:onInit()
	print("=======Activity_9001713_GiftPanel:onInit")
	self.tab, _ENV = print, print
	if commonCheck.OUTAPPPURCHASE then
		_ENV = commonCheck.OUTAPPPURCHASE
		commonCheck.OUTAPPPURCHASE[1] = i18n("common_text_4617")
		_ENV = nil
		;(nil).item = include("publicRead").getName(TOKEN_ITEM)
		self.tab, commonCheck.OUTAPPPURCHASE[2] = commonCheck.OUTAPPPURCHASE, i18n("common_text_4618", nil)
	end
	self.fields.List_tab:setItemRenderer(handler(self, self.itemRenderer_List_tab))
	self.fields.List_tab:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onTabClick))
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.title:setString(i18n("Frosty_Market_text_31"))
	self.fields.List:fixPos()
end
function Activity_9001713_GiftPanel:endShow()
	print("=======Activity_9001713_GiftPanel:endShow")
	self.tag = 1
	self.preTag = self.tag
	self.ListData = activity_9001713_Read.getRechargeCfg()
	self.controllers.c1:setSelectedIndex(#self.tab == 0 and 0 or 1)
	self.fields.List_tab:setNumItems(#self.tab)
	self.fields.List_tab:setSelectedIndex(self.tag - 1)
	self:initView()
end
function Activity_9001713_GiftPanel:initView()
	self.fields.List:setNumItems(#self.ListData)
end
function Activity_9001713_GiftPanel:itemRenderer_List_tab(index, obj)
	obj:setTitle(self.tab[index + 1])
end
function Activity_9001713_GiftPanel:itemRenderer_List(index, obj)
	obj:initData(self.ListData[index + 1], self.tag)
end
function Activity_9001713_GiftPanel:onTabClick()
	SoraDPlaySound()
	self.tag = self.fields.List_tab:getSelectedIndex() + 1
	if self.preTag ~= self.tag then
		self:initView()
		self.preTag = self.tag
	end
end
return Activity_9001713_GiftPanel
