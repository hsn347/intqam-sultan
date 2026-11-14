local activity_9001678_Read = include("activity_9001678_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001678_GiftPanel = class("Activity_9001678_GiftPanel", baseFguiPanel)
function Activity_9001678_GiftPanel:ctor(...)
	self.isLRU = true
	Activity_9001678_GiftPanel.super.ctor(self, ...)
	print("Activity_9001678_GiftPanel:ctor", self.viewName)
end
function Activity_9001678_GiftPanel:onInit()
	print("=======Activity_9001678_GiftPanel:onInit")
	self.tab, _ENV, self.rechargeCfg, _ENV = print, print, print, print
	if commonCheck.OUTAPPPURCHASE then
		_ENV = commonCheck.OUTAPPPURCHASE
		commonCheck.OUTAPPPURCHASE[1] = i18n("common_text_4617")
		_ENV = nil
		;(nil).item = include("publicRead").getName(TOKEN_ITEM)
		self.tab, commonCheck.OUTAPPPURCHASE[2] = commonCheck.OUTAPPPURCHASE, i18n("common_text_4618", nil)
	end
	self.fields.List_tab:setItemRenderer(handler(self, self.onTabRender))
	self.fields.List_tab:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onTabClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
end
function Activity_9001678_GiftPanel:onItemRender(index, obj)
	obj:initData(self.rechargeCfg[index + 1], self.tag)
end
function Activity_9001678_GiftPanel:onTabRender(index, obj)
	obj:setTitle(self.tab[index + 1])
end
function Activity_9001678_GiftPanel:onTabClick()
	SoraDPlaySound()
	self.tag = self.fields.List_tab:getSelectedIndex() + 1
	if self.preTag ~= self.tag then
		self.fields.List:setNumItems(#self.rechargeCfg)
		self.preTag = self.tag
	end
end
function Activity_9001678_GiftPanel:endShow()
	print("=======Activity_9001678_GiftPanel:endShow")
	self.tag = 1
	self.preTag = self.tag
	self.rechargeCfg = activity_9001678_Read.getFrostyRechargeCfg()
	self.fields.title:setString(i18n("Frosty_Market_text_31"))
	self.controllers.c1:setSelectedIndex(#self.tab == 0 and 0 or 1)
	self.fields.List_tab:setNumItems(#self.tab)
	self.fields.List_tab:setSelectedIndex(self.tag - 1)
	self:initView()
end
function Activity_9001678_GiftPanel:initView()
	self.fields.List:setNumItems(#self.rechargeCfg)
end
return Activity_9001678_GiftPanel
