local publicRead = include("publicRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local constantRead = include("constantRead")
local flyingStarWishCtrl = SoraDGetCtrl("flyingStarWishCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FlyingStarWishGiftListPanel = class("FlyingStarWishGiftListPanel", baseFguiPanel)
function FlyingStarWishGiftListPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("FlyingStarWishGiftListPanel:ctor", self.viewName)
end
function FlyingStarWishGiftListPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function FlyingStarWishGiftListPanel:onInit()
	print("=======FlyingStarWishGiftListPanel:onInit")
	self.fields.Text_num:fixPos()
	self.fields.Icon_gold:fixPos()
	self.fields.Text_value:fixPos()
	self.fields.Panel_bg:setString(i18n("giftgiving_text_19"))
	self.fields.Text_tip:setString(i18n("giftgiving_text_20"))
	self.fields.Text_none:setString(i18n("giftgiving_text_18"))
	self.fields.Button_buy:setTitleText(i18n("common_text_282"))
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBuy))
	self.fields.List_gift:setItemRenderer(handler(self, self.onItemRendererGift))
	self.maxGivingCount = constantRead.getConstValue("GIFTGIVING_GIVING_MAX")
	self.maxCostGold = constantRead.getConstValue("GIFTGIVING_GOLD_MAX")
end
function FlyingStarWishGiftListPanel:initData(data)
	dump(data, "fdkfldkfldkfl")
	local value = 0
	self.giftItem, _ENV = data, data
	self.giftItem = data
	self.leftGold = flyingStarWishCtrl:getLeftGold()
	if next(self.giftItem) then
		self.fields.List_gift:setNumItems(table.nums(self.giftItem))
		for i, v in ipairs(self.giftItem) do
			value = value + v.price * v.count
		end
	end
	self.total = value
	self:curCostRefresh()
end
function FlyingStarWishGiftListPanel:curCostRefresh()
	if self.total > self.leftGold then
		self.fields.Text_value:setString(i18n("giftgiving_text_12"))
		self.fields.Text_num:setString(fguiHelper.getColorString("#FF0000", self.total) .. "/" .. fguiHelper.getColorString("#FF0000", self.leftGold))
	elseif self.total > lordInfoCtrl:getBaseInfo().gold then
		self.fields.Text_value:setString(i18n("giftgiving_text_12"))
		self.fields.Text_num:setString(fguiHelper.getColorString("#FF0000", self.total) .. "/" .. fguiHelper.getColorString("#FFFFFF", self.leftGold))
	else
		self.fields.Text_value:setString(i18n("giftgiving_text_12"))
		self.fields.Text_num:setString(fguiHelper.getColorString("#FFFFFF", self.total) .. "/" .. fguiHelper.getColorString("#FFFFFF", self.leftGold))
	end
	if SoraDGetDefaultLanguage() ~= "ar" then
		self.fields.Text_num:setPositionX(self.fields.Icon_gold:getPositionX() + 32)
	end
	self.fields.Button_buy:setCostNum(self.total, lordInfoCtrl:getBaseInfo().gold, true)
end
function FlyingStarWishGiftListPanel:onItemRendererGift(index, object)
	object:initData(index + 1, self.giftItem[index + 1], handler(self, self.onGiftDelete), handler(self, self.changeCallBack))
end
function FlyingStarWishGiftListPanel:onGiftDelete(index)
	if index == nil or self.view == nil or self.giftItem == nil then
		SoraDShowMsgTip("输入框穿透导致接收弹窗点击消息错误")
		return
	end
	self.total = self.total - self.giftItem[index].price * self.giftItem[index].count
	self:curCostRefresh()
	table.remove(self.giftItem, index)
	if not next(self.giftItem) then
		self:close()
		return
	end
	self.fields.List_gift:setNumItems(table.nums(self.giftItem))
	_ENV = self.fields.List_gift
	self.fields.List_gift.msg = "MESSAGE_FLYING_STAR_WISH"
	self.fields.List_gift.subMsg = "buyListUpdate"
	SoraDSendMessage(self.fields.List_gift)
end
function FlyingStarWishGiftListPanel:changeCallBack(index, count)
	local offset = count - self.giftItem[index].count
	self.total = self.total + offset * self.giftItem[index].price
	self:curCostRefresh()
	self.giftItem[index].count = count
	_ENV = self
	self.msg = "MESSAGE_FLYING_STAR_WISH"
	self.subMsg = "buyListUpdate"
	SoraDSendMessage(self)
end
function FlyingStarWishGiftListPanel:onClickBuy(eventContext)
	SoraDPlaySound()
	local time = serviceFunctions.systemTime() or os.time()
	local h = tonumber(os.date("!%H", time))
	if 0 <= h and h < 20 then
		if flyingStarWishCtrl:getDayBuyCount() >= self.maxGivingCount then
			SoraDShowMsgTip(i18n("giftgiving_text_5"))
		elseif self.total > flyingStarWishCtrl:getLeftGold() then
			SoraDShowMsgTip(i18n("giftgiving_text_14"))
		elseif SoraDEnoughGold(self.total) then
			_ENV = i18n("giftgiving_text_14")
			i18n("giftgiving_text_14").num1 = table.nums(self.giftItem)
			i18n("giftgiving_text_14").num2 = self.total
			SoraDShowMsgBox(i18n("giftgiving_text_30", i18n("giftgiving_text_14")), i18n("common_text_204"), nil, function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					local _ENV, list = MSGBOX_CALLBACK_YES, MSGBOX_CALLBACK_YES
					for i, v in ipairs(self.giftItem) do
						list[tostring(v.index)] = v.count
					end
					self.giftItem, _ENV = ipairs(self.giftItem)
					flyingStarWishCtrl:sendGiftBuyMsg(list)
					self:close()
					return
				end
			end)
		end
	else
		SoraDShowMsgTip(i18n("giftgiving_text_6"))
	end
end
function FlyingStarWishGiftListPanel:onShow()
	print("=======FlyingStarWishGiftListPanel:onShow")
	self.closeParentView = self.proxy.param.closeParentView
	self:initData(self.proxy.param.gift)
	if SoraDGetDefaultLanguage() ~= "ar" then
		self.fields.Text_num:setPositionX(self.fields.Icon_gold:getPositionX() + 32)
		self.fields.Text_value:setPositionX(self.fields.Icon_gold:getPositionX() - self.fields.Text_value:getWidth())
	end
end
function FlyingStarWishGiftListPanel:onHide()
	_ENV = nil
	;(nil).msg = "MESSAGE_FLYING_STAR_WISH"
	;(nil).subMsg = "buyListUpdate"
	SoraDSendMessage(nil)
end
return FlyingStarWishGiftListPanel
