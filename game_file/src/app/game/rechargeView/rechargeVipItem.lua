local RechargeVipItem = class("rechargeVipItem", function(target)
	return target
end)
function RechargeVipItem:ctor()
	self.isCanBuy = 0
	self.itemContent = ""
	self.mainData, _ENV, self.itemName = nil, nil, ""
	self.txtLimit = SoraDGetChildByName(self, "Text_limit")
	self.txtRecommend = SoraDGetChildByName(self, "Text_recommend")
	self.imgBg = SoraDGetChildByName(self, "Image_itemBg")
	self.imgItem = SoraDGetChildByName(self, "Image_item")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.btnBuy = SoraDGetChildByName(self, "Button_buy")
	self.nPrice = SoraDGetChildByName(self, "Text_nowPrice")
	self.oPrice = SoraDGetChildByName(self, "Text_oriPrice")
	self.itemCount = SoraDGetChildByName(self, "Text_itemCount")
	self.Panel_copy_true = SoraDGetChildByName(self, "Panel_copy_true")
	self.Panel_copy_false = SoraDGetChildByName(self, "Panel_copy_false")
	self.nodeRecommend = SoraDGetChildByName(self, "Image_Node_recommend")
	self.nodeItemPanel = SoraDGetChildByName(self, "Image_Node_itemPanel")
	self.panelBought = SoraDGetChildByName(self, "Panel_already")
	self.txtNotOpen = SoraDGetChildByName(self, "Text_notOpen")
	self.txtRecommend:setString(i18n("common_text_2871"))
	self.btnBuy:addTouchEventListener(handler(self, self.btnBuyClick))
	self.imgItem:setTouchEnabled(true)
	self.imgItem:addTouchEventListener(handler(self, self.itemClick))
end
function RechargeVipItem:initData(singleData)
	self.mainData = singleData
	self:initView()
end
function RechargeVipItem:setFarther(panel)
	self.parentPanel = panel
end
function RechargeVipItem:initView(...)
	if self.mainData.unlock then
		self.txtNotOpen:setVisible(true)
		_ENV = true
		_ENV = nil
		;(nil).n = paymentManager.returnCurrencyByChannel()
		;(nil).c = paymentManager.exchangeByChannel(self.mainData.totalUnlock)
		;(true).num = i18n("common_text_2358", nil)
		local des = i18n("common_text_1975", true)
		if 2 == self.mainData.unlockClass then
			des = des .. "\n" .. i18n("common_text_1400")
		end
		self.txtNotOpen:setString(des)
		self.nodeItemPanel:setVisible(false)
		self.txtLimit:setVisible(false)
		self.panelBought:setVisible(false)
		self.txtRecommend:setVisible(true)
		self.isCanBuy = 3
		return
	else
		self.txtLimit:setVisible(true)
		self.txtNotOpen:setVisible(false)
		self.nodeItemPanel:setVisible(true)
		self.txtRecommend:setVisible(false)
	end
	print("self.mainData.type", self.mainData.itemType)
	print("self.mainData.id", self.mainData.id)
	self.imgItem:setTag(self.mainData.id)
	if gRechargeVipDef.normalItem == self.mainData.itemType then
		local itemDesRead = include("itemDesRead")
		self.imgItem:loadTexture(itemDesRead.getIcon(self.mainData.id), ccui.TextureResType.plistType)
		self.imgBg:loadTexture(itemDesRead.getBg(self.mainData.id), ccui.TextureResType.plistType)
		self.itemContent = itemDesRead.getDes(self.mainData.id)
		self.itemName = itemDesRead.getName(self.mainData.id)
		self.txtName:setString(self.itemName)
	elseif gRechargeVipDef.resource == self.mainData.itemType then
		local resDesRead = include("resDesRead")
		self.imgItem:loadTexture(resDesRead.getIcon(self.mainData.id), ccui.TextureResType.plistType)
		self.itemContent = resDesRead.getName(self.mainData.id)
		self.itemName = resDesRead.getName(self.mainData.id)
		self.txtName:setString(self.itemName)
	elseif gRechargeVipDef.equipment == self.mainData.itemType then
		local equipDesRead = include("equipDesRead")
		local equipmentltCtrl = include("equipmentltCtrl")
		local limitLv = self.mainData.llv
		local qBg = self.mainData.quality
		self.itemName = equipDesRead.getName(self.mainData.id)
		local baseProperty, mayVal = equipmentltCtrl.getEquipmentBaseProperty(self.mainData.id, self.mainData.quality, 0)
		local baseString = equipDesRead.getAttrName(baseProperty, mayVal)
		_ENV = nil
		;(nil).lv = limitLv
		self.itemContent = baseString .. "\n" .. i18n("common_text_2003", nil)
		self.imgItem:loadTexture(equipDesRead.getIcon(self.mainData.id), ccui.TextureResType.plistType)
		self.imgBg:loadTexture(equipDesRead.getBg(qBg), ccui.TextureResType.plistType)
		self.txtName:setString(self.itemName)
	elseif gRechargeVipDef.war_stone == self.mainData.itemType then
		local wargemResRead = include("wargemResRead")
		self.imgItem:loadTexture(wargemResRead.getIcon(self.mainData.id), ccui.TextureResType.plistType)
		self.imgBg:loadTexture(wargemResRead.getBgRound(self.mainData.id), ccui.TextureResType.plistType)
		self.itemContent = wargemResRead.getAttrByID(self.mainData.id)
		local stoneName = wargemResRead.getDes(self.mainData.id)
		local stoneLv = wargemResRead.getLevel(self.mainData.id)
		_ENV = equipmentltCtrl.getEquipmentBaseProperty(self.mainData.id, self.mainData.quality, 0)
		equipmentltCtrl.getEquipmentBaseProperty(self.mainData.id, self.mainData.quality, 0).lv = stoneLv
		equipmentltCtrl.getEquipmentBaseProperty(self.mainData.id, self.mainData.quality, 0).name = stoneName
		self.itemName = i18n("common_text_134", equipmentltCtrl.getEquipmentBaseProperty(self.mainData.id, self.mainData.quality, 0))
		self.txtName:setString(self.itemName)
	end
	self.itemCount:setString("x" .. self.mainData.num)
	self.oPrice:setString(self.mainData.oriPrice)
	self.btnBuy:setBright(not self.mainData.isBought)
	local limitClass = include("commonLimitBox")
	local isOk, reTbl = limitClass:judgeData(self.mainData.limitData)
	if isOk then
		self.txtLimit:setVisible(true)
		self.txtLimit:setString(self.mainData.limitData[reTbl[1]].content)
		self.panelBought:setVisible(true)
	else
		self.txtLimit:setVisible(false)
		self.panelBought:setVisible(false)
	end
	if self.mainData.recommend then
		self.nPrice:setString("1")
		self.mainData.nowPrice = 1
		self.isCanBuy = 3
		self:setMode(true)
	else
		self.nPrice:setString(self.mainData.nowPrice)
		self:setMode(false)
	end
end
function RechargeVipItem:setMode(bool)
	self.nodeRecommend:setVisible(bool)
	if bool then
		self.Panel_copy_true:setVisible(true)
		self.Panel_copy_false:setVisible(false)
	else
		self.Panel_copy_true:setVisible(false)
		self.Panel_copy_false:setVisible(true)
	end
end
function RechargeVipItem:itemClick(button, eventType)
	if eventType == ccui.TouchEventType.began then
		local pFloor = SoraDGetChildByName(self.parentPanel, "item_pop_box")
		if pFloor then
			pFloor:removeFromParent()
			pFloor = nil
		end
		if not pFloor then
			local pos = self.parentPanel:convertToNodeSpace(button:getTouchBeganPosition())
			self:openItem(pos)
		end
	elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
		local pFloor = SoraDGetChildByName(self.parentPanel, "item_pop_box")
		if pFloor then
			pFloor:removeFromParent()
			pFloor = nil
		end
	end
end
function RechargeVipItem:openItem(pos)
	local popBox = SoraDCreatePanel("commonItemTips")
	popBox:setName("item_pop_box")
	popBox:setTouchClose(true)
	popBox:customData(self.itemName, self.itemContent)
	if SoraDFIsRA() then
		if pos.x < -280 then
			popBox:setPosition(pos.x + 280, pos.y)
		else
			popBox:setPosition(pos.x, pos.y)
		end
	elseif pos.x > 360 then
		popBox:setPosition(pos.x - 280, pos.y)
	else
		popBox:setPosition(pos.x, pos.y)
	end
	popBox:addTo(self.parentPanel, 100)
end
function RechargeVipItem:btnBuyClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.mainData.isBought then
			SoraDShowMsgTip(i18n("common_text_2070"))
			return
		end
		local mID = self.mainData.mID
		local panel = SoraDCreatePanel("commonLimitBox")
		if panel:judgeData(self.mainData.limitData) then
			panel:initData(self.mainData.limitData)
			panel:setTitle(i18n("common_text_1976"))
			panel:show()
			dump(self.mainData, "self.mainData")
		else
			_ENV = i18n("common_text_1976")
			i18n("common_text_1976").num = self.mainData.nowPrice
			i18n("common_text_1976").item = self.itemName .. "x" .. self.mainData.num
			SoraDShowMsgBox(i18n("common_text_2009", i18n("common_text_1976")), i18n("common_text_204"), nil, function(arg)
				if MSGBOX_CALLBACK_YES == arg then
					if SoraDEnoughGold(self.mainData.nowPrice, true) then
						local gametop = gModuleMgr.getObject("gametop")
						local premiumStoreCtrl = gametop.playertop_:getModule("premiumStoreCtrl")
						local mPlace = self.mainData.recommend and 0 or self.mainData.index
						premiumStoreCtrl:sendBuy(mID, mPlace)
						SoraDShowLoading()
						print("购买成功！")
					else
						SoraDShowMsgBox(i18n("common_text_423"), i18n("common_text_424"), nil, function(type)
							if type == MSGBOX_CALLBACK_YES then
								_ENV = nil
								;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_NORMALBTNCLICK"
								SoraDSendMessage(nil)
							end
						end)
					end
				end
			end)
		end
	end
end
return RechargeVipItem
