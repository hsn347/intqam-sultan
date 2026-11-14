local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local luckyGiftCtrl = SoraDGetCtrl("luckyGiftCtrl")
local privilegeGiftCtrl = SoraDGetCtrl("privilegeGiftCtrl")
local shoppingCartCtrl = SoraDGetCtrl("shoppingCartCtrl")
local ladderGiftCtrl = SoraDGetCtrl("ladderGiftCtrl")
local rechargeRead = include("rechargeRead")
local privilegeGiftRead = include("privilegeGiftRead")
local rechargeGiftShopCarView = class("rechargeGiftShopCarView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargeGiftShopCarView")
	end
	return target
end)
function rechargeGiftShopCarView:ctor()
	self.selectIDList, _ENV, self.giftDetail, _ENV, self.giftList, _ENV = nil, nil, nil, nil, nil, nil
	self.isDeleteModel = false
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.ccs_title:setTitle(i18n("shopping_title_01"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("rechargeGiftShopCarSingle")
	self.scroll:setVisbileShowScale(1.0, 1.5)
	self.Center_Node_none = SoraDGetChildByName(self, "Center_Node_none")
	self.Center_Node_none:setVisible(false)
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("shopping_text_02"))
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	self.Node_delete = SoraDGetChildByName(self, "Node_delete")
	self.Button_remove = SoraDGetChildByName(self, "Button_remove")
	self.Button_remove:setTitleText(i18n("common_text_3889"))
	self.Button_remove:addTouchEventListener(handler(self, self.onRemoveBack))
	self.Button_cancel = SoraDGetChildByName(self, "Button_cancel")
	self.Button_cancel:setTitleText(i18n("common_text_185"))
	self.Button_cancel:addTouchEventListener(handler(self, self.onCancelBack))
	self.Button_delete = SoraDGetChildByName(self, "Button_delete")
	self.Button_delete:addTouchEventListener(handler(self, self.onDeleteBack))
	self:initData()
end
function rechargeGiftShopCarView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART_DATA", handler(self, self.suitData))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART_UI_SEL", handler(self, self.delSelect))
end
function rechargeGiftShopCarView:delSelect(target, data)
	self.selectIDList[data.rid] = data.isDel
end
function rechargeGiftShopCarView:getGiftInfo(id)
	local _ENV, info
	for k, v in ipairs(self.giftDetail) do
		if v.id == id then
			info = v
			break
		end
	end
	return info
end
function rechargeGiftShopCarView:suitData(target, data)
	self.giftDetail = shoppingCartCtrl:getUsefulData()
	self:initView()
end
function rechargeGiftShopCarView:initData(target, data)
	if data and data.isRemove then
		self.selectIDList, shoppingCartCtrl = data.isRemove, data.isRemove
	end
	self.giftList = shoppingCartCtrl:getShoppingCartInfo()
	local shoppingCartCtrl, ridList = shoppingCartCtrl:getShoppingCartInfo(), shoppingCartCtrl:getShoppingCartInfo()
	for k, v in pairs(self.giftList) do
		table.insert(ridList, tonumber(k))
	end
	if 0 < #ridList then
		shoppingCartCtrl:reqShoppingCartInfo(ridList)
	else
		self.giftDetail, shoppingCartCtrl = shoppingCartCtrl.reqShoppingCartInfo, shoppingCartCtrl.reqShoppingCartInfo
		self:initView()
	end
end
function rechargeGiftShopCarView:initView()
	self.Button_delete:setVisible(not self.isDeleteModel)
	local _ENV, ridDataList = self.Button_delete.setVisible, self.Button_delete.setVisible
	local _ENV, vList = self.Button_delete, self.Button_delete
	local _ENV, iList = not self.isDeleteModel, not self.isDeleteModel
	table.sort(self.giftDetail, function(a, b)
		return a.id < b.id
	end)
	for k, v in ipairs(self.giftDetail) do
		if v.isInvalid then
			table.insert(vList, v)
		else
			table.insert(iList, v)
		end
	end
	for k, v in ipairs(iList) do
		table.insert(ridDataList, v)
	end
	for k, v in ipairs(vList) do
		table.insert(ridDataList, v)
	end
	self.Center_Node_none:setVisible(#self.giftDetail == 0)
	self.scroll:setVisible(#self.giftDetail > 0)
	self.Node_delete:setVisible(self.isDeleteModel)
	local offsetHeight = self.isDeleteModel and 0 or 76
	self.scroll:setContentSize(cc.size(640, display.height - 145 + offsetHeight))
	_ENV = cc.size(640, display.height - 145 + offsetHeight)
	cc.size(640, display.height - 145 + offsetHeight).scroll = self.scroll
	cc.size(640, display.height - 145 + offsetHeight).view = self
	cc.size(640, display.height - 145 + offsetHeight).isDelete = self.isDeleteModel
	cc.size(640, display.height - 145 + offsetHeight).selectIDList = self.selectIDList
	self.scroll:updateScrollView(cc.size(640, 283), ridDataList, 1, cc.size(640, display.height - 145 + offsetHeight))
end
function rechargeGiftShopCarView:onCleanBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("清空失效礼包===========")
		SoraDShowMsgBox(i18n("shopping_text_06"), i18n("common_text_204"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				local invalidList = self:getInvalidGift()
				local _ENV, ridList = self, self
				for k, v in ipairs(invalidList) do
					table.insert(ridList, v.id)
				end
				shoppingCartCtrl:reqRemoveShoppingCart(ridList)
			end
		end)
	end
end
function rechargeGiftShopCarView:onRemoveBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isDeleteModel = false
		local _ENV, selectIDList = SoraDPlaySound, SoraDPlaySound
		for k, v in pairs(self.selectIDList) do
			if v then
				table.insert(selectIDList, k)
			end
		end
		shoppingCartCtrl:reqRemoveShoppingCart(selectIDList)
	end
end
function rechargeGiftShopCarView:onCancelBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.selectIDList, _ENV, self.isDeleteModel = SoraDPlaySound, SoraDPlaySound, false
		self:initView()
	end
end
function rechargeGiftShopCarView:onDeleteBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("撤销模式===========")
		if self.isDeleteModel then
			return
		end
		self.isDeleteModel = true
		self:initView()
	end
end
return rechargeGiftShopCarView
