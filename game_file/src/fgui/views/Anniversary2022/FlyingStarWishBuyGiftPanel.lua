local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local constantRead = include("constantRead")
local flyingStarWishRead = include("flyingStarWishRead")
local flyingStarWishCtrl = SoraDGetCtrl("flyingStarWishCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FlyingStarWishBuyGiftPanel = class("FlyingStarWishBuyGiftPanel", baseFguiPanel)
function FlyingStarWishBuyGiftPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("FlyingStarWishBuyGiftPanel:ctor", self.viewName)
end
function FlyingStarWishBuyGiftPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "RamadanSurprise"
	end
	return self._packageList
end
function FlyingStarWishBuyGiftPanel:onInit()
	print("=======FlyingStarWishBuyGiftPanel:onInit")
	self.fields.Button_giftList:fixPos()
	self.fields.Button_buy:fixPos()
	self.fields.Text_num:fixPos()
	self.fields.Icon_gold:fixPos()
	self.fields.Text_value:fixPos()
	self.buyList, _ENV = self.fields.Text_value.fixPos, self.fields.Text_value.fixPos
	self.buyList = flyingStarWishCtrl:getHadBuyList()
	dump(self.buyList, "self.buyList onInit")
	self.fields.Com_title:initData(i18n("giftgiving_text_4"), handler(self, self.onClickClose))
	self.fields.Text_selectTip:setString(i18n("giftgiving_text_11"))
	self.fields.Button_buy:setTitleText(i18n("common_text_282"))
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBuy))
	self.fields.Button_giftList:setTitleText(i18n("giftgiving_text_19"))
	self.fields.Button_giftList:addClickListener(handler(self, self.onClickGiftList))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRedererReward))
	self.giftItem = flyingStarWishRead.getGiftItemConfig()
	table.sort(self.giftItem, function(a, b)
		return a.rank < b.rank
	end)
	self.maxGivingCount = constantRead.getConstValue("GIFTGIVING_GIVING_MAX")
	self.controllers.c1:setSelectedIndex(1)
	self.haveBuy = 0
	self:initData()
end
function FlyingStarWishBuyGiftPanel:initData()
	dump(self.giftItem, "fjkdfjdkjfk")
	self.leftGold = flyingStarWishCtrl:getLeftGold()
	self.curCost = self:getCurGiftTotalCost()
	self:curCostRefresh()
	_ENV = nil
	;(nil).num = flyingStarWishCtrl:getDayBuyGold()
	self.fields.Text_alreadyCost:setString(i18n("giftgiving_text_16", nil))
	if next(self.giftItem) then
		self.fields.List_reward:setNumItems(table.nums(self.giftItem))
	end
	self:updateBtnState()
end
function FlyingStarWishBuyGiftPanel:getCurGiftTotalCost()
	local value = 0
	if next(self.buyList) then
		for i, v in ipairs(self.buyList) do
			value = value + v.price * v.count
		end
	end
	return value
end
function FlyingStarWishBuyGiftPanel:onItemRedererReward(index, object)
	local hadBuy = 0
	if next(self.buyList) then
		for i, v in ipairs(self.buyList) do
			if index + 1 == v.index then
				hadBuy = v.count
			end
		end
	end
	_ENV = nil
	;(nil).id = self.giftItem[index + 1].item[1]
	;(nil).count = self.giftItem[index + 1].item[2]
	;(nil).price = self.giftItem[index + 1].buy
	;(nil).maxCount = math.floor(math.max(self.leftGold / self.giftItem[index + 1].buy, 1))
	;(nil).minCount = 0
	;(nil).curCount = math.max(hadBuy, 1)
	;(nil).isSelect = 0 < hadBuy
	object:initData(index + 1, nil, handler(self, self.onSelectHandle))
end
function FlyingStarWishBuyGiftPanel:onSelectHandle(index, data, buyCount)
	dump(data, "Fdfkldkfl")
	if next(self.buyList) then
		for i, v in ipairs(self.buyList) do
			if index == v.index then
				local offset = buyCount - v.count
				self.curCost = self.curCost + offset * data.price
				self:curCostRefresh()
				v.count = buyCount
				if buyCount == 0 then
					table.remove(self.buyList, i)
					self:updateBtnState()
					self.fields.List_reward:getChildAt(index - 1):getController("c1"):setSelectedIndex(0)
				end
				return
			end
		end
	end
	if 0 < buyCount then
		self.curCost = self.curCost + buyCount * data.price
		self:curCostRefresh()
		_ENV = ipairs(self.buyList)
		ipairs(self.buyList).index = index
		ipairs(self.buyList).id = data.id
		ipairs(self.buyList).singleCount = data.count
		ipairs(self.buyList).count = buyCount
		ipairs(self.buyList).price = data.price
		ipairs(self.buyList).maxCount = data.maxCount
		ipairs(self.buyList).minCount = data.minCount
		table.insert(self.buyList, ipairs(self.buyList))
		self:updateBtnState()
		self.fields.List_reward:getChildAt(index - 1):getController("c1"):setSelectedIndex(1)
	end
end
function FlyingStarWishBuyGiftPanel:updateBtnState()
	local num = table.nums(self.buyList)
	self.fields.Button_giftList:getChild("Label_reddot"):initData(0 < num, -1)
	self.fields.Button_giftList:setGrayed(table.nums(self.buyList) == 0 and true or false)
	self.fields.Button_buy:setGrayed(table.nums(self.buyList) == 0 and true or false)
end
function FlyingStarWishBuyGiftPanel:curCostRefresh()
	if self.curCost > self.leftGold then
		self.fields.Text_value:setString(i18n("giftgiving_text_12"))
		self.fields.Text_num:setString(fguiHelper.getColorString("#FF0000", self.curCost) .. "/" .. fguiHelper.getColorString("#FF0000", self.leftGold))
	elseif self.curCost > lordInfoCtrl:getBaseInfo().gold then
		self.fields.Text_value:setString(i18n("giftgiving_text_12"))
		self.fields.Text_num:setString(fguiHelper.getColorString("#FF0000", self.curCost) .. "/" .. fguiHelper.getColorString("#FFFFFF", self.leftGold))
	else
		self.fields.Text_value:setString(i18n("giftgiving_text_12"))
		self.fields.Text_num:setString(fguiHelper.getColorString("#FFFFFF", self.curCost) .. "/" .. fguiHelper.getColorString("#FFFFFF", self.leftGold))
	end
	if SoraDGetDefaultLanguage() ~= "ar" then
		self.fields.Text_num:setPositionX(self.fields.Icon_gold:getPositionX() + 32)
	end
	self.fields.Button_buy:setCostNum(self.curCost, lordInfoCtrl:getBaseInfo().gold, true)
end
function FlyingStarWishBuyGiftPanel:onClickBuy(eventContext)
	SoraDPlaySound()
	local time = serviceFunctions.systemTime() or os.time()
	local h = tonumber(os.date("!%H", time))
	if 0 <= h and h < 20 then
		if not next(self.buyList) then
			SoraDShowMsgTip(i18n("giftgiving_text_18"))
			return
		end
		if flyingStarWishCtrl:getDayBuyCount() >= self.maxGivingCount then
			SoraDShowMsgTip(i18n("giftgiving_text_5"))
		elseif self.curCost > flyingStarWishCtrl:getLeftGold() then
			SoraDShowMsgTip(i18n("giftgiving_text_14"))
		elseif SoraDEnoughGold(self.curCost) then
			_ENV = i18n("giftgiving_text_14")
			i18n("giftgiving_text_14").num1 = table.nums(self.buyList)
			i18n("giftgiving_text_14").num2 = self.curCost
			SoraDShowMsgBox(i18n("giftgiving_text_30", i18n("giftgiving_text_14")), i18n("common_text_204"), nil, function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					local _ENV, buyList = MSGBOX_CALLBACK_YES, MSGBOX_CALLBACK_YES
					for i, v in ipairs(self.buyList) do
						buyList[tostring(v.index)] = v.count
					end
					self.buyList, _ENV = ipairs(self.buyList)
					flyingStarWishCtrl:sendGiftBuyMsg(buyList)
					self:close()
				end
			end)
		end
	else
		SoraDShowMsgTip(i18n("giftgiving_text_6"))
	end
end
function FlyingStarWishBuyGiftPanel:onClickGiftList()
	SoraDPlaySound()
	if next(self.buyList) then
		_ENV = nil
		;(nil).gift = self.buyList
		uiManager:show("FlyingStarWishGiftList", nil):setOwnerKey(self)
	else
		SoraDShowMsgTip(i18n("giftgiving_text_18"))
	end
end
function FlyingStarWishBuyGiftPanel:onShow()
	print("=======FlyingStarWishBuyGiftPanel:onShow")
	self:resizeBanner()
	if SoraDGetDefaultLanguage() ~= "ar" then
		self.fields.Text_num:setPositionX(self.fields.Icon_gold:getPositionX() + 32)
		self.fields.Text_value:setPositionX(self.fields.Icon_gold:getPositionX() - self.fields.Text_value:getWidth())
	end
end
function FlyingStarWishBuyGiftPanel:onHide()
	print("=======FlyingStarWishBuyGiftPanel:onShow")
	if self.buyList and next(self.buyList) then
		flyingStarWishCtrl:saveBuyList(self.buyList)
	else
		flyingStarWishCtrl:clearBuyList()
	end
end
function FlyingStarWishBuyGiftPanel:clearBuyList()
	self.buyList, _UPVALUE0_ = nil, nil
end
function FlyingStarWishBuyGiftPanel:resizeBanner()
	if not self.originSize then
		self.originSize = self.fields.Icon_banner:getSize()
	end
	local scale = self.view:getWidth() / self.originSize.width
	self.fields.Icon_banner:setSize(self.view:getWidth(), self.originSize.height * scale)
end
return FlyingStarWishBuyGiftPanel
