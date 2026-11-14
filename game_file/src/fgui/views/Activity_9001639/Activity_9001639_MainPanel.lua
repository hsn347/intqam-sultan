local activity_9001639_Ctrl = SoraDGetCtrl("activity_9001639_Ctrl")
local activity_9001639_Read = include("activity_9001639_Read")
local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001639_MainPanel = class("Activity_9001639_MainPanel", baseFguiPanel)
function Activity_9001639_MainPanel:ctor(...)
	Activity_9001639_MainPanel.super.ctor(self, ...)
	print("Activity_9001639_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CORBAN_MARKET_ACTIVITY
	self.exchangeID = gActivityTimeActivityID.CORBAN_MARKEY_EXCHANGE
	self.classType = SoraDGetActivityClassType(self.exchangeID)
end
function Activity_9001639_MainPanel:onInit()
	print("=======Activity_9001639_MainPanel:onInit")
	self.controllers.c2:setSelectedIndex(1)
	self.shopList, _ENV, self.tag = self.controllers.c2.setSelectedIndex, self.controllers.c2.setSelectedIndex, 1
	self.giftList = activity_9001639_Read.getGiftCfg()
	self.fields.Com_title:setTitleWidthHeight(480, 40)
	self.fields.Com_title:initData(i18n("activity_name_9001639"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List_gift:setItemRenderer(handler(self, self.onGiftRenderer))
	self.fields.List_shop:setVirtual()
	self.fields.List_shop:setItemRenderer(handler(self, self.onShopRenderer))
end
function Activity_9001639_MainPanel:onGiftRenderer(index, obj)
	obj:initData(self.giftList[index + 1])
end
function Activity_9001639_MainPanel:onShopRenderer(index, obj)
	obj:initData(self.shopList[index + 1])
end
function Activity_9001639_MainPanel:onShow()
	print("=======Activity_9001639_MainPanel:onShow")
	self.fields.Label_time:initSpecialActivityTimeNew(self.activityID)
	_ENV = self.activityID
	_ENV, _ENV, self.activityID.defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("treasureEscort_text48")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("common_text_1889")
	self.activityID.tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	self.activityID.callback = handler(self, self.onTabClick)
	self.fields.Com_tab:initView(self.activityID)
end
function Activity_9001639_MainPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:updateView()
end
function Activity_9001639_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("eidal_market_text10")
	uiManager:show("RuleView", nil)
end
function Activity_9001639_MainPanel:updateView()
	if self.tag == 1 then
		self.fields.Com_tip:initData()
		self.fields.Com_cumu:initData()
		self.fields.List_gift:setNumItems(#self.giftList)
	else
		self.shopList = newExchangeMallCtrl:getConfigByActivityID(self.exchangeID, self.classType)
		self.fields.List_shop:setNumItems(#self.shopList)
	end
	local ret, num = activity_9001639_Ctrl:getReceiveStatusAndNum()
	self.fields.Com_tab:setBtnRedDot(2, ret, num)
end
return Activity_9001639_MainPanel
