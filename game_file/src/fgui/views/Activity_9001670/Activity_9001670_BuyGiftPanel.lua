local activity_9001670_Read = include("activity_9001670_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001670_BuyGiftPanel = class("Activity_9001670_BuyGiftPanel", baseFguiPanel)
function Activity_9001670_BuyGiftPanel:ctor(...)
	Activity_9001670_BuyGiftPanel.super.ctor(self, ...)
	print("Activity_9001670_BuyGiftPanel:ctor", self.viewName)
	self.debug = true
	self.rechargeCfg = activity_9001670_Read.getRechargeCfg(1)
end
function Activity_9001670_BuyGiftPanel:onInit()
	print("=======Activity_9001670_BuyGiftPanel:onInit")
	self.fields.text_saohua:setString(i18n("anniversary_dice_text_15"))
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRederer))
	_ENV = handler(self, self.onItemRederer)
	_ENV, _ENV, handler(self, self.onItemRederer).defaultClick = handler(self, self.onItemRederer)
	_ENV, handler(self, self.onItemRederer)[1], handler(self, self.onItemRederer).title = handler(self, self.onItemRederer)
	_ENV = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).item = include("publicRead").getName(TOKEN_ITEM)
	handler(self, self.onItemRederer).tabsetArray, handler(self, self.onItemRederer)[2], handler(self, self.onItemRederer).title = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(handler(self, self.onItemRederer))
end
function Activity_9001670_BuyGiftPanel:onShow()
	print("=======Activity_9001670_BuyGiftPanel:onShow")
	self.controllers.c1:setSelectedIndex(SoraDCheckOAPIsOpen() and 1 or 0)
end
function Activity_9001670_BuyGiftPanel:onClickTab(tag)
	self.payType = tag
	self:updateScroll()
end
function Activity_9001670_BuyGiftPanel:updateScroll()
	self.fields.List_item:setNumItems(#self.rechargeCfg)
end
function Activity_9001670_BuyGiftPanel:onItemRederer(index, obj)
	local cfg = self.rechargeCfg[index + 1]
	obj:initData(cfg, self.payType)
end
return Activity_9001670_BuyGiftPanel
