local gametop = gModuleMgr.getObject("gametop")
local premiumStoreCtrl = gametop.playertop_:getModule("premiumStoreCtrl")
local vipLocalData = include("vipLocalData")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local rechargeVipSpecialItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/rechargeVipSpecialItem", rechargeVipSpecialItem)
function rechargeVipSpecialItem:onInit()
	self.fields.Text_link:setString(i18n("common_text_1720"))
	self.fields.Text_link:setTouchEnabled(true)
	self.fields.Text_link:addClickListener(handler(self, self.btnLinkClick))
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyClick))
	self:fixChildrenPos()
	self.fields.arrow:setRotation(SoraDFIsRA() and 90 or -90)
end
function rechargeVipSpecialItem:onShow()
end
function rechargeVipSpecialItem:initData(data)
	self.mainData = data
	if self.mainData.unlock then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Button_buy:setEnabled(true)
		self.fields.Button_buy:setBright(self.mainData.buyCount < self.mainData.limit)
		self.fields.Button_buy:initData(self.mainData.price, self.mainData.primeprice)
		self.fields.Text_content:setString(publicRead.getDes(self.mainData.commodityID))
		self.fields.Text_name:setString(publicRead.getName(self.mainData.commodityID))
		self.fields.item:initData(self.mainData.commodityID, self.mainData.num)
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Button_buy:initUnData()
		self.fields.Button_buy:setEnabled(false)
		publicRead = false
		publicRead = publicRead.getName(self.mainData.commodityID)
		publicRead.getName(self.mainData.commodityID).n = paymentManager.returnCurrencyByChannel()
		publicRead.getName(self.mainData.commodityID).c = paymentManager.exchangeByChannel(self.mainData.total)
		;(false).price = i18n("common_text_2358", publicRead.getName(self.mainData.commodityID))
		local des = i18n("common_text_1977", false)
		local num, isVip = vipLocalData:getVipNum(self.mainData.viplv)
		if isVip then
			des = des .. " " .. i18n("recharge_label_014") .. num
		else
			publicRead = self.mainData.total
			self.mainData.total.lv = num
			des = des .. " " .. i18n("common_text_3974", self.mainData.total)
		end
		self.fields.Text_notOpen:setString(des)
		self.fields.Text_name:setString(i18n("enjoyable_store_04"))
		self.fields.Text_unlock:setString(i18n("enjoyable_store_01"))
		self.fields.item:setIcon("icon_item_common.png")
		self.fields.item:setQuality()
		self.fields.item:setNumText(self.mainData.num)
		self.fields.item:setSpecialNum()
	end
end
function rechargeVipSpecialItem:btnBuyClick()
	SoraDPlaySound()
	if self.mainData.buyCount < self.mainData.limit then
		_ENV = nil
		;(nil).num = self.mainData.price
		;(nil).item = publicRead.getName(self.mainData.commodityID) .. "x" .. self.mainData.num
		SoraDShowMsgBox(i18n("common_text_2009", nil), i18n("common_text_204"), nil, function(arg)
			if MSGBOX_CALLBACK_YES == arg and self.mainData and SoraDEnoughGold(self.mainData.price) then
				premiumStoreCtrl:sendBuy(self.mainData.shopId, 1)
				SoraDShowLoading()
			end
		end)
	else
		SoraDShowMsgTip(i18n("common_text_2070"), publicRead.getIcon(self.mainData.commodityID))
	end
end
function rechargeVipSpecialItem:btnLinkClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).index = self.mainData.isoverflow
	uiManager:show("rechargeVipSpecialList", nil)
end
return rechargeVipSpecialItem
