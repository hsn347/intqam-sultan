local activity_9001717_Read = include("activity_9001717_Read")
local activity_9001717_Ctrl = SoraDGetCtrl("activity_9001717_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001717_BuyGiftPanel = class("Activity_9001717_BuyGiftPanel", baseFguiPanel)
function Activity_9001717_BuyGiftPanel:ctor(...)
	self.isLRU = true
	Activity_9001717_BuyGiftPanel.super.ctor(self, ...)
	print("Activity_9001717_BuyGiftPanel:ctor", self.viewName)
	self.rechargeCfg = activity_9001717_Read.getRechargeCfg(1)
end
function Activity_9001717_BuyGiftPanel:onInit()
	print("=======Activity_9001717_BuyGiftPanel:onInit")
	self.fields.Text_talk:setString(i18n("Bubble_island_rebuild_text_41"))
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List_item:fixPos()
end
function Activity_9001717_BuyGiftPanel:endShow()
	print("=======Activity_9001717_BuyGiftPanel:endShow")
	self.controllers.c1:setSelectedIndex(SoraDCheckOAPIsOpen() and 1 or 0)
	self.controllers.c2:setSelectedIndex(SoraDFIsRA() and 0 or 1)
	self.payType = 1
	_ENV = SoraDFIsRA() and 0 or 1
	_ENV, _ENV, (SoraDFIsRA() and 0 or 1).defaultClick = nil, self.payType, self.payType
	_ENV, self.payType[1], (nil).title = nil, nil, i18n("common_text_4617")
	_ENV = nil
	;(nil).item = include("publicRead").getName(TOKEN_ITEM)
	;(SoraDFIsRA() and 0 or 1).tabsetArray, self.payType[2], (nil).title = self.payType, nil, i18n("common_text_4618", nil)
	;(SoraDFIsRA() and 0 or 1).callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(SoraDFIsRA() and 0 or 1)
end
function Activity_9001717_BuyGiftPanel:onClickTab(tag)
	self.payType = tag
	self:updateScroll()
end
function Activity_9001717_BuyGiftPanel:updateScroll()
	self.fields.List_item:setNumItems(#self.rechargeCfg)
end
function Activity_9001717_BuyGiftPanel:onItemRederer(index, obj)
	local cfg = self.rechargeCfg[index + 1]
	obj:initData(cfg, self.payType)
end
return Activity_9001717_BuyGiftPanel
