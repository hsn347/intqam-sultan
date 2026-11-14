local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local sericaShopCtrl = SoraDGetCtrl("sericaShopCtrl")
local merchantOfSericaRead = include("merchantOfSericaRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SiriusMerchantPanel = class("SiriusMerchantPanel", baseFguiPanel)
local Max_Num = 4
function SiriusMerchantPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SiriusMerchantPanel:ctor", self.viewName)
end
function SiriusMerchantPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SiriusMerchantPanel:onInit()
	print("=======SiriusMerchantPanel:onInit")
	self.selectionList, _ENV = print, print
	self.tabIndex = 1
	self.buyCount = 0
	self.activityID = gActivityTimeActivityID.SERICA_SHOP_ACTIVITY
	self.dataShop = merchantOfSericaRead.getSericaShop(activityShowCtrl:getParamClassType(self.activityID))
	self.fields.Com_title:initData(i18n("serica_title"), handler(self, self.onClickClose))
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.fields.List_ButtonChoose:setItemRenderer(handler(self, self.onGroupItemRenerer))
	self.fields.Text_Tip1:setString(i18n("serica_text_15"))
	self.fields.Text_Finish:setString(i18n("common_text_4445"))
	local _ENV, tabsetArray = self.fields.Text_Finish.setString, self.fields.Text_Finish.setString
	for index, value in ipairs(self.dataShop) do
		self.fields[string.format("List%d", index)]:fixPos()
		self.fields[string.format("List%d", index)]:setItemRenderer(handlerEx(self, self.onItemRenerer, index))
		self.fields[string.format("List%d", index)]:addEventListener(fgui.UIEventType.ClickItem, handlerEx(self, self.onClickItem, index))
		_ENV = fgui.UIEventType.ClickItem
		fgui.UIEventType.ClickItem.title = paymentManager.getRealPrice(value.RechargeID, value.Price)
		fgui.UIEventType.ClickItem.tag = index
		table.insert(tabsetArray, fgui.UIEventType.ClickItem)
	end
	_ENV = ipairs(self.dataShop)
	ipairs(self.dataShop).defaultClick = self.tabIndex
	ipairs(self.dataShop).tabsetArray = tabsetArray
	ipairs(self.dataShop).callback = handler(self, self.onClickTag)
	self.fields.com_Tab:initView(ipairs(self.dataShop))
end
function SiriusMerchantPanel:onShow()
	print("=======SiriusMerchantPanel:onShow")
	sericaShopCtrl:reqSericaShopInit()
end
function SiriusMerchantPanel:updateView()
	self.selectionList[self.tabIndex] = sericaShopCtrl:getSelectRecordByID(self.rechargeID)
	self.buyCount = sericaShopCtrl:getBuyCountByID(self.rechargeID)
	for i = 1, Max_Num do
		local chooseIndex = self:getAwardIndex(i)
		self.fields[string.format("List%d", i)]:clearSelection()
		if chooseIndex and 0 < chooseIndex then
			self.fields[string.format("List%d", i)]:setSelectedIndex(chooseIndex - 1)
		end
		self.fields[string.format("List%d", i)]:setNumItems(table.nums(self.giftInfo[string.format("item%d", i)]) / 2)
	end
	self.fields.List_ButtonChoose:setNumItems(Max_Num)
	self:updateButton()
end
function SiriusMerchantPanel:updateButton()
	self.controllers.c1:setSelectedIndex(self.buyCount >= self.giftInfo.ExtraData and 1 or 0)
	local nowPrice = paymentManager.judgePrice(self.giftInfo.RechargeID, self.giftInfo.Price)
	local discount = self.giftInfo.OriginalPrice / self.giftInfo.Price
	local oriPrice = paymentManager.calculateDiscount(self.giftInfo.RechargeID, nowPrice, discount, self.giftInfo.OriginalPrice)
	_ENV = discount
	discount.rid = self.giftInfo.RechargeID
	discount.nowPrice = nowPrice
	discount.oriPrice = oriPrice
	discount.handleBuyClick = handler(self, self.onGuyGift)
	discount.handleItemBuyClick = handler(self, self.onGuyGiftByItem)
	self.fields.Com_OutAppPurchaseButtons:initData(discount)
	print(discount)
	_ENV = self
	self.cur = self.buyCount
	_ENV, _ENV, self.total = nil, self.giftInfo.ExtraData, self.giftInfo.ExtraData
	_ENV, self.giftInfo.ExtraData.cur, (nil).color = nil, nil, "#fcdc00"
	_ENV, self.giftInfo.ExtraData.total, (nil).color = nil, nil, "#fcdc00"
	self.giftInfo.ExtraData.__default, (nil).color = nil, "#ffffff"
	self.fields.Text_Limit:setString(i18n_html("common_text_4417", self, self.giftInfo.ExtraData))
end
function SiriusMerchantPanel:onItemRenerer(groupIndex, index, obj)
	local data = self.giftInfo[string.format("item%d", groupIndex)]
	obj:initData(data[index * 2 + 1], data[index * 2 + 2])
end
function SiriusMerchantPanel:onGroupItemRenerer(index, obj)
	if not self.selectionList[self.tabIndex] then
		local _ENV, chooseData = self.selectionList[self.tabIndex], self.selectionList[self.tabIndex]
	end
	local awardIndex = chooseData[tostring(index + 1)]
	local awardList = self.giftInfo[string.format("item%d", index + 1)]
	local id, count
	if awardIndex and 0 < awardIndex then
		id = awardList[(awardIndex - 1) * 2 + 1]
		count = awardList[(awardIndex - 1) * 2 + 2]
	end
	obj:initData(id, count)
end
function SiriusMerchantPanel:onClickTag(tag)
	sericaShopCtrl:reqSericaShopSelect(self.rechargeID, self.selectionList[self.tabIndex])
	self.tabIndex = tag
	self.giftInfo = self.dataShop[self.tabIndex]
	self.rechargeID = self.giftInfo.RechargeID
	self:updateView()
end
function SiriusMerchantPanel:onClickItem(groupIndex, EventContext)
	local obj = EventContext:getGObjectData()
	local objList = EventContext:getSender()
	local childIndex = objList:getChildIndex(obj)
	if not self.selectionList[self.tabIndex] then
		self.selectionList[self.tabIndex], _ENV = nil, nil
	end
	if childIndex + 1 ~= self:getAwardIndex(groupIndex) then
		self.selectionList[self.tabIndex][tostring(groupIndex)] = childIndex + 1
		self.fields.List_ButtonChoose:setNumItems(Max_Num)
		if table.nums(self.selectionList[self.tabIndex]) == Max_Num then
			sericaShopCtrl:reqSericaShopSelect(self.rechargeID, self.selectionList[self.tabIndex])
		end
	end
	dump(self.selectionList, "self.selectionList")
	print("onClickItem", childIndex, obj)
end
function SiriusMerchantPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("magic_flip_1")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function SiriusMerchantPanel:onGuyGift()
	SoraDPlaySound()
	if self.buyCount >= self.giftInfo.ExtraData then
		SoraDShowMsgTip(i18n("common_text_4570"))
		return
	end
	if table.nums(self.selectionList[self.tabIndex]) < Max_Num then
		SoraDShowMsgTip(i18n("serica_text_03"))
		return
	end
	paymentManager.normalGiftBuyClassify(self.rechargeID)
	paymentManager.OnemtReadyBuy(self.rechargeID, gRechargeActiveFromEnum.ROAD44)
end
function SiriusMerchantPanel:onGuyGiftByItem()
	SoraDPlaySound()
	if self.buyCount >= self.giftInfo.ExtraData then
		SoraDShowMsgTip(i18n("common_text_4570"))
		return false
	end
	if table.nums(self.selectionList[self.tabIndex]) < Max_Num then
		SoraDShowMsgTip(i18n("serica_text_03"))
		return false
	end
	return true
end
function SiriusMerchantPanel:onHide()
	sericaShopCtrl:reqSericaShopSelect(self.rechargeID, self.selectionList[self.tabIndex])
end
function SiriusMerchantPanel:getAwardIndex(groupIndex)
	if self.selectionList[self.tabIndex] then
		return self.selectionList[self.tabIndex][tostring(groupIndex)]
	end
end
return SiriusMerchantPanel
