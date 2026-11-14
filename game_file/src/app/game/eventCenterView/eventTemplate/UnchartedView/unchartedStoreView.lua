local gametop = gModuleMgr.getObject("gametop")
local unchartedCtrl = gametop.playertop_:getModule("unchartedCtrl")
local unchartedAdventureRead = include("unchartedAdventureRead")
local publicRead = include("publicRead")
local unchartedStoreView = class("unchartedStoreView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("unchartedStoreView")
	end
	return target
end)
local PANEL_HEIGHT = 62
local CORLOR_RED = cc.c3b(190, 40, 40)
local CORLOR_YELLOW = cc.c3b(255, 200, 100)
local CORLOR_NORMAL = cc.c3b(240, 230, 210)
local CORLOR_GREY = cc.c3b(120, 120, 120)
function unchartedStoreView:ctor()
	self:initControls()
end
function unchartedStoreView:initControls()
	self.txtCoin = SoraDGetChildByName(self, "Text_title")
	self.panel = SoraDGetChildByName(self, "panel_cell")
	self.btnLeft = SoraDGetChildByName(self, "btn_left")
	self.btnRight = SoraDGetChildByName(self, "btn_right")
	self.spriteBg = SoraDGetChildByName(self, "Sprite_title_bg")
	self.btnExtent = SoraDGetChildByName(self, "btn_extent")
	self.btnQuest = SoraDGetChildByName(self, "btn_quest")
	self.panelSingle = SoraDGetChildByName(self, "panel_single")
	self.scroll = SoraDGetChildByName(self, "scrollview_content")
	self.iconCell = SoraDGetChildByName(self, "icon_cell")
	self.downScroll = SoraDGetChildByName(self, "Top_Size_scroll_win_rewards")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_eventCenter")
	self.nodeTitle:setTitle(i18n("Secret_explore_text_02"))
	self.btnLeft:addTouchEventListener(handler(self, self.leftClickCallBack))
	self.btnRight:addTouchEventListener(handler(self, self.rightClickCallBack))
	self.iconCell:addTouchEventListener(handler(self, self.jumpToRightPos))
	self.btnExtent:addTouchEventListener(handler(self, self.expandClickCallBack))
	self.btnQuest:addTouchEventListener(handler(self, self.questClickCallBack))
	self.itemList = unchartedAdventureRead.getSaleItemsList()
	self.allItemList = unchartedAdventureRead.getAllStoreItemList()
	self.unchartedInfo = unchartedCtrl:getUnchartedInfo()
	self.txtCoin:setString(self.unchartedInfo.coin)
	self.percent = 0
	self.scroll:setSwallowTouches(true)
	unchartedCtrl:sendStoreBuyRecordMsg()
	SoraDShowLoading(self)
	self.panelList, _ENV = SoraDShowLoading, SoraDShowLoading
end
function unchartedStoreView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_UNCHARTED_STORE_INIT_INFO", function(target, data)
		SoraDCloseLoading(self)
		self.storeInfo = unchartedCtrl:getStoreBuyRecordInfo()
		for i, v in ipairs(self.allItemList) do
			local isOutStock = true
			for j, w in ipairs(v) do
				local tempCount = self.storeInfo[tostring(w.Index)] or 0
				tempCount = w.Times - tempCount
				if 0 < tempCount then
					isOutStock = false
					break
				end
			end
			v.needClose = isOutStock
		end
		self:initScroll()
		self:initDownScroll()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_UNCHARTED_SHOP_BUY_BACK", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_UNCHARTED_HELP_BUY_BACK", handler(self, self.refreshData))
end
function unchartedStoreView:initScroll()
	self.scroll:removeAllChildren()
	local scrollH = math.max(#self.itemList * 160, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(scrollH, self.scroll:getContentSize().height))
	for i = 1, #self.itemList do
		local cell = self.panel:clone()
		cell:setPosition(cc.p(160 * (i - 1), self.scroll:getContentSize().height / 2))
		cell:addTo(self.scroll)
		local cellTitle = SoraDGetChildByName(cell, "text_level")
		local cellIcon = SoraDGetChildByName(cell, "icon_cell")
		local cellPoint = SoraDGetChildByName(cell, "Text_gold")
		local cellNum = SoraDGetChildByName(cell, "Text_refreshPrice")
		local cellFinsh = SoraDGetChildByName(cell, "icon_finish")
		local cellIconGold = SoraDGetChildByName(cell, "icon_gold")
		cellIcon:setTag(self.itemList[i].NeedRound)
		cellIcon:loadTexture(publicRead.getIcon(self.itemList[i].Item[1]), ccui.TextureResType.plistType)
		_ENV = cc.p(160 * (i - 1), self.scroll:getContentSize().height / 2)
		cc.p(160 * (i - 1), self.scroll:getContentSize().height / 2).level = self.itemList[i].NeedRound
		cellTitle:setString(i18n("common_text_1721", cc.p(160 * (i - 1), self.scroll:getContentSize().height / 2)))
		cellNum:setString(self.itemList[i].Item[2])
		cellPoint:setString(self.itemList[i].NeedPoint)
		cellTitle:setColor(self.itemList[i].NeedRound >= self.unchartedInfo.curLayer and CORLOR_GREY or CORLOR_NORMAL)
		cellNum:setColor(self.itemList[i].NeedRound >= self.unchartedInfo.curLayer and CORLOR_GREY or CORLOR_NORMAL)
		cellPoint:setColor(self.itemList[i].NeedRound >= self.unchartedInfo.curLayer and CORLOR_GREY or CORLOR_YELLOW)
		cellIcon:getVirtualRenderer():setState(self.itemList[i].NeedRound >= self.unchartedInfo.curLayer and 1 or 0)
		if self.itemList[i].NeedRound >= self.unchartedInfo.curLayer then
			SoraDCreateGraySprite(cellIconGold)
		end
		local remainCount = 0
		local totalCount = self.itemList[i].Times
		for k, v in pairs(self.storeInfo) do
			if k == self.itemList[i].Index then
				remainCount = v
				break
			end
		end
		remainCount = totalCount - remainCount
		cellIconGold:setVisible(0 < remainCount)
		cellPoint:setVisible(0 < remainCount)
		cellFinsh:setVisible(remainCount <= 0)
	end
end
function unchartedStoreView:refreshDownScrollHeight(...)
	self.everyHeightTable, _ENV, self.totalHeight = nil, nil, 0
	for i = 1, #self.allItemList do
		table.insert(self.everyHeightTable, self.totalHeight)
		self.totalHeight = self.totalHeight + PANEL_HEIGHT
		if not self.allItemList[i].needClose then
			self.totalHeight = self.totalHeight + math.ceil(#self.allItemList[i] / 2) * 200
		end
	end
	local scrollH = math.max(self.totalHeight, self.downScroll:getContentSize().height)
	self.downScroll:setInnerContainerSize(cc.size(display.width, scrollH))
end
function unchartedStoreView:initDownScroll()
	self.downScroll:removeAllChildren()
	self:refreshDownScrollHeight()
	local helpData = unchartedCtrl:getUnchartedHelpInfo()
	local scrollH = self.downScroll:getInnerContainerSize().height
	for i = 1, #self.allItemList do
		local panel = self.spriteBg:clone()
		panel:setPosition(cc.p(self.downScroll:getContentSize().width / 2, scrollH - self.everyHeightTable[i]))
		panel:addTo(self.downScroll)
		self.panelList[i] = panel
		local cellExpand = SoraDGetChildByName(panel, "btn_extent")
		local cellTitle = SoraDGetChildByName(panel, "Text_winTitle")
		if self.allItemList[i][1].NeedRound == 0 then
			cellTitle:setString(i18n("Secret_explore_text_51"))
		else
			local str = string.format("%s%s %d", i18n("Secret_explore_text_53"), i18n("Secret_explore_text_54"), self.allItemList[i][1].NeedRound)
			cellTitle:setString(str)
		end
		cellExpand:setTag(self.allItemList[i][1].NeedRound)
		cellExpand.index = i
		if self.allItemList[i].needClose then
			cellExpand:setRotation(90)
		else
			cellExpand:setRotation(0)
		end
		cellTitle:setColor(i <= self.unchartedInfo.curLayer and CORLOR_NORMAL or CORLOR_RED)
		panel.singleItemList, unchartedCtrl = cellTitle.setColor, cellTitle.setColor
		for j = 1, #self.allItemList[i] do
			local itemKey = self.allItemList[i][j].Item[1]
			local itemCount = self.allItemList[i][j].Item[2]
			local singleItem = self.panelSingle:clone()
			panel.singleItemList[j] = singleItem
			local cellbtn = SoraDGetChildByName(singleItem, "btn_buy")
			local cellLimit = SoraDGetChildByName(singleItem, "text_limit")
			local cellDes = SoraDGetChildByName(singleItem, "text_des")
			local cellGold = SoraDGetChildByName(singleItem, "text_gold")
			local cellDiscountGold = SoraDGetChildByName(singleItem, "text_discountGold")
			local cellDownShadow = SoraDGetChildByName(singleItem, "panel_downShadow")
			local spriteLine = SoraDGetChildByName(singleItem, "frame_merchant_08_94")
			local tempCount = self.storeInfo[self.allItemList[i][j].Index] or 0
			tempCount = self.allItemList[i][j].Times - tempCount
			local str1 = string.format("%s%d/%d", i18n("Secret_explore_text_52"), tempCount, self.allItemList[i][j].Times)
			cellLimit:setString(str1)
			cellLimit:setColor(0 < tempCount and CORLOR_YELLOW or CORLOR_RED)
			cellDownShadow:setVisible(tempCount <= 0 or self.allItemList[i][1].NeedRound >= self.unchartedInfo.curLayer)
			cellbtn:setEnabled(not cellDownShadow:isVisible())
			cellDownShadow:setLocalZOrder(10)
			cellDes:setString(publicRead.getName(itemKey))
			cellGold:setString(self.allItemList[i][j].NeedPoint)
			local cell = SoraDCreatePanel("eventGeocentricCell")
			cell:initData(itemKey, itemCount)
			cell:addTo(singleItem)
			cell:setPosition(17, 127)
			cell:setClickDelegate(handler(self, self.singleCellClick))
			cell:sendParentToButton(self)
			cellbtn:addTouchEventListener(handler(self, self.buyButtonClickCallBack))
			cellbtn:setTag(self.allItemList[i][j].Index * 100 + self.allItemList[i][j].NeedRound)
			if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.UNCHARTED_HELP) then
				for m = 1, #helpData do
					if tonumber(helpData[m].id) == self.allItemList[i][j].Index and helpData[m].price ~= "" and helpData[m].price ~= self.allItemList[i][j].NeedPoint then
						cell.frameDiscount:setVisible(true)
						cell.txtDiscount:setString(string.format("%d%%", helpData[m].rate / 10))
						cellDiscountGold:setString(helpData[m].price)
						spriteLine:setVisible(true)
						cellGold:setPositionY(20)
						cellDiscountGold:setPositionY(45)
					end
					if tonumber(helpData[m].id) == self.allItemList[i][j].Index and (helpData[m].price == "" or helpData[m].price == self.allItemList[i][j].NeedPoint) then
						cell.frameDiscount:setVisible(true)
						cell.txtDiscount:setString(string.format("%d%%", helpData[m].rate / 10))
					end
				end
			end
			if self.allItemList[i][j].Sale == 1 then
				local shopEffectNode = SoraDCreatAnimation("shopEffect", nil, true)
				shopEffectNode:setPosition(cc.p(130, 200))
				singleItem:addChild(shopEffectNode, 100)
			end
			if 1 < math.ceil(j / 2) then
				singleItem:setPosition(cc.p(160 + 317 * (math.floor(j / 2) - 1), -130 * math.ceil(j / 2) + 60))
			else
				singleItem:setPosition(cc.p(160 + 317 * (j - 1), -60 * math.ceil(j / 2) + 60))
			end
			singleItem:addTo(panel)
		end
		if self.allItemList[i].needClose then
			for k, v in pairs(panel.singleItemList) do
				v:setVisible(false)
			end
		end
	end
end
function unchartedStoreView:singleCellClick(pItem)
end
function unchartedStoreView:refreshData(target, data)
	SoraDCloseLoading(self)
	self.unchartedInfo = unchartedCtrl:getUnchartedInfo()
	self.storeInfo = unchartedCtrl:getStoreBuyRecordInfo()
	self.txtCoin:setString(self.unchartedInfo.coin)
	self:initScroll()
	self:initDownScroll()
end
function unchartedStoreView:buyButtonClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.downScroll) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		SoraDRemoveAllAfterPanelFromManager(self, true)
		local helpData = unchartedCtrl:getUnchartedHelpInfo()
		local layer = button:getTag() % 100
		if layer >= self.unchartedInfo.curLayer then
			_ENV = nil
			;(nil).Round = layer
			SoraDShowMsgTip(i18n("Secret_explore_notice_12", nil))
		else
			local remainCount = 0
			local totalCount = 0
			local coinCost = 0
			local itemID = 0
			for i = 1, #self.allItemList do
				for j = 1, #self.allItemList[i] do
					if math.floor(button:getTag() / 100) == self.allItemList[i][j].Index then
						totalCount = self.allItemList[i][j].Times
						coinCost = self.allItemList[i][j].NeedPoint
						itemID = self.allItemList[i][j].Item[1]
						if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.UNCHARTED_HELP) and next(helpData) then
							for m = 1, #helpData do
								if math.floor(button:getTag() / 100) == tonumber(helpData[m].id) and helpData[m].price ~= "" then
									coinCost = tonumber(helpData[m].price)
								end
							end
						end
						break
					end
				end
			end
			if self.storeInfo[math.floor(button:getTag() / 100)] then
				remainCount = totalCount - self.storeInfo[math.floor(button:getTag() / 100)]
			else
				remainCount = totalCount
			end
			if remainCount <= 0 then
				SoraDShowMsgTip(i18n("Secret_explore_notice_13"))
				return
			end
			if coinCost > self.unchartedInfo.coin then
				SoraDShowMsgTip(i18n("Secret_explore_notice_14"))
				return
			end
			local itemIndex = math.floor(button:getTag() / 100)
			local canBuy = math.floor(self.unchartedInfo.coin / coinCost)
			if remainCount < canBuy then
				canBuy = remainCount
			end
			if 1 < remainCount then
				_ENV, _ENV = i18n("Secret_explore_notice_14")
				i18n("Secret_explore_notice_14").id = itemID
				_ENV, i18n("Secret_explore_notice_14").itemData, i18n("Secret_explore_notice_14").price = i18n("Secret_explore_notice_14")
				i18n("Secret_explore_notice_14").maxCount = canBuy
				i18n("Secret_explore_notice_14").curValue = canBuy
				i18n("Secret_explore_notice_14").isUncharted = true
				i18n("Secret_explore_notice_14").otherData, i18n("Secret_explore_notice_14").unchartedCoin = i18n("Secret_explore_notice_14")
				i18n("Secret_explore_notice_14").buyHandle = function(num)
					SoraDShowLoading(self)
					unchartedCtrl:sendShopBuyMsg(itemIndex, num)
				end
				uiManager:show("newShopSingleBuy", i18n("Secret_explore_notice_14"))
			else
				unchartedCtrl:sendShopBuyMsg(itemIndex, 1)
			end
		end
	end
end
function unchartedStoreView:leftClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.percent > 0 then
			self.percent = self.percent - 30
			self.scroll:scrollToPercentHorizontal(self.percent, 0.2, true)
		end
	end
end
function unchartedStoreView:rightClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.percent < 100 then
			self.percent = self.percent + 30
			self.scroll:scrollToPercentHorizontal(self.percent, 0.2, true)
		end
	end
end
function unchartedStoreView:jumpToRightPos(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local pos = 0
		for i, v in ipairs(self.everyHeightTable) do
			if button:getTag() == i then
				pos = v
				break
			end
		end
		local scrollPercent = 100 * (pos / (self.totalHeight - 1200))
		scrollPercent = math.min(100, math.max(0, scrollPercent))
		local scrollH = self.downScroll:getContentSize().height
		if math.abs(pos + self.downScroll:getInnerContainer():getPositionY()) < 0.5 * scrollH then
			self.downScroll:scrollToPercentVertical(scrollPercent, 0.2, true)
		else
			_UPVALUE2_ = 0.2
			;(0.2)[1] = cca.callFunc(function(...)
				self.downScroll:scrollToPercentVertical(scrollPercent + 0.5, 0.2, false)
			end)
			;(0.2)[2] = cca.delay(0.3)
			;(0.2)[3] = cca.callFunc(function(...)
				self.downScroll:scrollToPercentVertical(scrollPercent, 0.1, true)
			end)
			;(0.2)[4] = cca.callFunc(function(...)
				self.downScroll:scrollToPercentVertical(scrollPercent, 0.1, true)
			end)
			self:runAction(cca.seq(0.2))
		end
	end
end
function unchartedStoreView:expandClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local index = button.index
		local needClose = self.allItemList[index].needClose
		if needClose then
			needClose = false
			button:setRotation(0)
		else
			needClose = true
			button:setRotation(90)
		end
		self.allItemList[index].needClose = needClose
		self:refreshDownScrollHeight()
		local scrollH = self.downScroll:getInnerContainerSize().height
		for i = 1, index do
			local panel = self.panelList[i]
			panel:setPosition(cc.p(self.downScroll:getContentSize().width / 2, scrollH - self.everyHeightTable[i]))
		end
		local panel = self.panelList[index]
		for k, v in pairs(panel.singleItemList) do
			v:setVisible(not needClose)
		end
	end
end
function unchartedStoreView:questClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.UNCHARTED_STORE)
	end
end
return unchartedStoreView
