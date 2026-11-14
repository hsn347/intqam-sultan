local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local publicRead = include("publicRead")
local PropBuyView = class("propBuyView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("normalStyleBuyView")
	end
	return target
end)
function PropBuyView:ctor()
	self.itemList, _ENV, self.troopData, _ENV, self.isHideCurrentSceneView = nil, nil, nil, nil, true
	self.itemType = nil
	self.itemScroll = include("itemBuyScroll").new()
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_normalBuyView")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_normalBuyView")
	self.goldTop = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonGoldTop_normalBuyView")
	self.nodeLoadingBar = SoraDGetChildByName(self, "Node_loadingBar")
	self.loadingBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.txtTime = SoraDGetChildByName(self, "Text_BarTime")
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.txtTitle:setColor(cc.c3b(214, 221, 182))
	self.txtTitle:setFontSize(26)
	self.loadingBar:setScale9Enabled(true)
	self.loadingBar:setCapInsets(cc.rect(4, 0, 4, 21))
	self.nodeLoadingBar:setVisible(false)
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_ITEM_LIMITITEM_TIMEOUT_BACK", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_MALL_BUY_SUCCESS", handler(self, self.refreshData))
end
function PropBuyView:initData(itemType, troopData)
	self.troopData = troopData
	self.itemType = itemType
	self:refreshData()
end
function PropBuyView:refreshData()
	SoraDCloseLoading(self)
	if self.itemType == gItemType.ORANGE_EQUIP_MATERIAL_BOX then
		self.windowTitle:setTitle(i18n("common_text_742"))
		self.itemList, _ENV = self.windowTitle.setTitle, self.windowTitle.setTitle
		_UPVALUE5_ = self.windowTitle
		self.windowTitle[1] = 299100
		self.windowTitle[2] = 299101
		self.windowTitle[3] = 299102
		self.windowTitle[4] = 299103
		self.windowTitle[5] = 299104
		for i, v in ipairs(self.windowTitle) do
			table.insert(self.itemList, v)
		end
		self:initOrangeEquipView()
	elseif self.troopData and self.troopData.itemList then
		self.itemList = self.troopData.itemList
		table.sort(self.itemList, function(a, b)
			return a.shopItemID < b.shopItemID
		end)
		self:initView()
	else
		self.itemList = shopltCtrl:getQuickShopItemArrayByItemID(self.troopData.itemID)
		table.sort(self.itemList, function(a, b)
			return a.shopItemID < b.shopItemID
		end)
		self:initView()
	end
	dump(self.itemList, "PropBuyView:listData")
end
function PropBuyView:initOrangeEquipView()
	_ENV = nil
	;(nil).itemList = self.itemList
	;(nil).itemCallBack = handler(self, self.buyOrUseCallBack)
	;(nil).itemStyle = "commonItemUseBar_01"
	;(nil).itemSize = cc.size(620, 170)
	local (nil).posY, transTbl = 80, nil
	self.itemScroll:setScroll(self.scroll)
	self.itemScroll:init(transTbl)
end
function PropBuyView:initView(...)
	local itemName = publicRead.getName(self.troopData.itemID)
	local itemCount = backpackCtrl:getItemCount(self.troopData.itemID)
	if gItemType.WAR_BUGLE == self.itemType then
		self.windowTitle:setTitle(i18n("common_text_742"))
		publicRead = i18n("common_text_742")
		i18n("common_text_742").item = itemName
		i18n("common_text_742").have = itemCount
		i18n("common_text_742").need = self.troopData.needCount
		self.txtTitle:setString(i18n("common_text_1243", i18n("common_text_742")))
	elseif gItemType.GOLDEN_ARROW == self.itemType then
		self.windowTitle:setTitle(i18n("common_text_742"))
		publicRead = i18n("common_text_742")
		i18n("common_text_742").item = itemName
		i18n("common_text_742").have = itemCount
		i18n("common_text_742").need = self.troopData.needCount
		self.txtTitle:setString(i18n("common_text_1243", i18n("common_text_742")))
	elseif gItemType.STRENGTHEN_MATERIAL == self.itemType then
		self.windowTitle:setTitle(i18n("common_text_742"))
		self.txtTitle:setString(itemName .. ":" .. itemCount)
	elseif gItemType.CAT_EYE_GEM == self.itemType then
		self.windowTitle:setTitle(i18n("common_text_742"))
		self.txtTitle:setString(itemName .. ":" .. itemCount)
	elseif gItemType.ASSAULT_HORN == self.itemType then
		self.windowTitle:setTitle(i18n("common_text_3286"))
		if self.troopData.warnTxt then
			publicRead = i18n("common_text_3286")
			i18n("common_text_3286").num = itemCount
			self.txtTitle:setString(self.troopData.warnTxt .. "\n" .. i18n("hero_text_26", i18n("common_text_3286")))
		else
			publicRead = i18n("hero_text_26", i18n("common_text_3286"))
			i18n("hero_text_26", i18n("common_text_3286")).num = itemCount
			self.txtTitle:setString(i18n("hero_text_26", (i18n("hero_text_26", i18n("common_text_3286")))))
		end
		table.sort(self.itemList, function(a, b)
			return a.number < b.number
		end)
	elseif gItemType.WORLDCUP_SPEAKER == self.itemType then
		self.windowTitle:setTitle(i18n("item_name_808701"))
		self.txtTitle:setString(itemName .. ":" .. itemCount)
	elseif gItemType.WORLDCUP_COIN == self.itemType then
		self.windowTitle:setTitle(i18n("item_name_808801"))
		self.txtTitle:setString(itemName .. ":" .. itemCount)
	elseif gItemType.IRON_HANDCUFFS == self.itemType then
		self.windowTitle:setTitle(i18n("item_name_310201"))
		local totalCount = self.troopData.needCount
		self.txtTitle:setString(itemName .. ":" .. itemCount .. "/" .. totalCount)
		if itemCount < totalCount then
			self.txtTitle:setColor(cc.c3b(255, 0, 0))
		else
			self.txtTitle:setColor(cc.c3b(214, 221, 182))
		end
		local imageIcon = SoraDGetChildByName(self.txtTitle:getParent(), "Image_ItemIcon")
		if imageIcon == nil then
			imageIcon = ccui.ImageView:create(publicRead.getIcon(self.troopData.itemID), ccui.TextureResType.plistType)
			imageIcon:ignoreContentAdaptWithSize(false)
			imageIcon:setContentSize(48, 48)
			imageIcon:setAnchorPoint(SoraDFIsRA() and 0 or 1, 0.5)
			imageIcon:setPosition(self.txtTitle:getPositionX() + (SoraDFIsRA() and 1 or -1) * self.txtTitle:getContentSize().width / 2, self.txtTitle:getPositionY())
			imageIcon:addTo(self.txtTitle:getParent())
			imageIcon:setName("Image_ItemIcon")
		end
	elseif gItemType.GOLD_SANDS == self.itemType then
		self.windowTitle:setTitle(i18n("item_name_310301"))
		self.txtTitle:setString(itemName .. ":" .. itemCount)
	else
		self.windowTitle:setTitle(itemName)
		publicRead = itemCount
		itemCount.num = itemCount
		self.txtTitle:setString(i18n("hero_text_26", itemCount))
	end
	if self.troopData and self.troopData.itemList then
		self.windowTitle:setTitle(i18n("common_text_742"))
	end
	publicRead = self.windowTitle.setTitle
	self.windowTitle.setTitle.itemList = self.itemList
	self.windowTitle.setTitle.itemCallBack = handler(self, self.buyOrUseCallBack)
	self.windowTitle.setTitle.itemStyle = "commonItemUseBar_01"
	self.windowTitle.setTitle.itemSize = cc.size(620, 170)
	local self.windowTitle.setTitle.isBuyOnly, transTbl = true, self.windowTitle.setTitle
	if self.troopData and self.troopData.hideTxtTitle then
		self.txtTitle:setVisible(false)
		transTbl.posY = 80
	end
	self.itemScroll:setScroll(self.scroll)
	self.itemScroll:init(transTbl)
end
function PropBuyView:buyOrUseCallBack(controlTbl)
	local buyItem = function(shopID)
		local itemInfo = shopltCtrl:getShopItemByShopItem(shopID)
		dump(itemInfo, "itemInfo")
		if itemInfo then
			shopltCtrl = nil
			;(nil).quickBuyData = itemInfo
			;(nil).useAndBuy = self.itemType == gItemType.ORANGE_EQUIP_MATERIAL_BOX
			uiManager:show("newShopSingleBuy", nil)
		else
			SoraDShowMsgTip(i18n("notice_0170"))
		end
	end
	if controlTbl.buy then
		if SoraDEnoughGold(controlTbl.needGold) then
			buyItem(controlTbl.shopID)
		end
	elseif controlTbl.use then
		include("itemLogic").useItemsLine(controlTbl.itemID, controlTbl.itemCount)
	end
end
return PropBuyView
