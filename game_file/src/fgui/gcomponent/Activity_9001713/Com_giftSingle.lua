local commonBuyGiftCtrl = SoraDGetCtrl("commonBuyGiftCtrl")
local activity_9001713_Ctrl = SoraDGetCtrl("activity_9001713_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_giftSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001713/Com_giftSingle", Com_giftSingle)
function Com_giftSingle:onInit()
	self.fields.Text_done:setString(i18n("common_text_4376"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBuy))
	self.fields.CCS_OAPButton:addClickListener(handler(self, self.onClickBuy))
	self:fixChildrenPos()
	self.fields.Lab_discount:setRotation(SoraDFIsRA() and 17 or -17)
end
function Com_giftSingle:onItemRender(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_giftSingle:onShow()
end
function Com_giftSingle:initData(data, payType)
	self.giftData = data
	self.payType = payType or 1
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.reward = serviceFunctions.tableFormat(self.giftData.reward, nil)
	self.fields.List:setNumItems(#self.reward)
	self.fields.List:setScrollEnable(#self.reward > 4)
	local buyCount = self.giftData.limit - activity_9001713_Ctrl:getGiftBuyCountDay(self.giftData.rechargeID)
	_ENV = nil
	;(nil).num = buyCount
	self.fields.Text_limit:setString(i18n("Frosty_Market_text_25", nil))
	self.fields.Lab_discount:setString(tostring(math.floor(self.giftData.originalPrice / self.giftData.rechargePrice * 100)) .. "%")
	self.fields.Button_buy:setVisible(self.payType == 1)
	self.fields.CCS_OAPButton:setVisible(self.payType == 2)
	local priceForDollar = paymentManager.judgePrice(self.giftData.rechargeID, self.giftData.rechargePrice)
	if self.payType == 1 then
		self.fields.Button_buy:setString(priceForDollar)
	else
		self.fields.CCS_OAPButton:initData(priceForDollar, nil, self.giftData.rechargeID)
	end
	self.fields.Button_buy:setEnabled(0 < buyCount)
	self.fields.CCS_OAPButton:setEnabled(0 < buyCount)
	self.controllers.c1:setSelectedIndex(0 < buyCount and 0 or 1)
end
function Com_giftSingle:onClickBuy()
	SoraDPlaySound()
	if SoraDCheckOAPIsOpen(self.giftData.rechargeID) and self.payType == 2 then
		SoraDShowH5PurchaseView(self.giftData.rechargeID)
	else
		commonBuyGiftCtrl:reqBuyGift(gBuyType.ANNIVERSARY_2025_SHOP, self.giftData.rechargeID)
	end
end
return Com_giftSingle
