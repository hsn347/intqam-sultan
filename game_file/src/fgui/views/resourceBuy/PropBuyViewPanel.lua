local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local itemLogic = include("itemLogic")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local PropBuyViewPanel = class("PropBuyViewPanel", baseFguiPanel)
function PropBuyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("PropBuyViewPanel:ctor", self.viewName)
end
function PropBuyViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function PropBuyViewPanel:onInit()
	print("=======PropBuyViewPanel:onInit")
	self.isBuyOnly = true
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	self.itemList, _ENV, self.troopData = self.proxy.param.troopData, self.proxy.param.troopData, self.proxy.param.troopData
	self.itemType = self.proxy.param.itemType
	self.fields.list:setItemRenderer(handler(self, self.onItemRederer))
end
function PropBuyViewPanel:onShow()
	print("=======PropBuyViewPanel:onShow")
	self:refreshData()
end
function PropBuyViewPanel:refreshData()
	SoraDCloseLoading(self)
	self.itemList, _ENV = SoraDCloseLoading, SoraDCloseLoading
	if self.itemType == gItemType.ORANGE_EQUIP_MATERIAL_BOX then
		self.isBuyOnly = false
		_UPVALUE5_ = gItemType.ORANGE_EQUIP_MATERIAL_BOX
		gItemType.ORANGE_EQUIP_MATERIAL_BOX[1] = 299100
		gItemType.ORANGE_EQUIP_MATERIAL_BOX[2] = 299101
		gItemType.ORANGE_EQUIP_MATERIAL_BOX[3] = 299102
		gItemType.ORANGE_EQUIP_MATERIAL_BOX[4] = 299103
		gItemType.ORANGE_EQUIP_MATERIAL_BOX[5] = 299104
		for i, v in ipairs(gItemType.ORANGE_EQUIP_MATERIAL_BOX) do
			table.insert(self.itemList, self:createSingleInfo(v))
		end
	elseif self.troopData and self.troopData.itemList then
		local itemList = self.troopData.itemList
		table.sort(itemList, function(a, b)
			return a.shopItemID < b.shopItemID
		end)
		for i, v in ipairs(itemList) do
			table.insert(self.itemList, self:createSingleInfoByShopID(v))
		end
	else
		local itemList = shopltCtrl:getQuickShopItemArrayByItemID(self.troopData.itemID)
		table.sort(itemList, function(a, b)
			return a.shopItemID < b.shopItemID
		end)
		for i, v in ipairs(itemList) do
			table.insert(self.itemList, self:createSingleInfoByShopID(v))
		end
	end
	self:initView()
	dump(self.itemList, "PropBuyViewPanel:listData")
end
function PropBuyViewPanel:initView(...)
	if self.troopData then
		local itemName = publicRead.getName(self.troopData.itemID)
		local itemCount = backpackCtrl:getItemCount(self.troopData.itemID)
		self.fields.Com_title:updateTitle(itemName)
		self.fields.Label_ItemNum:setIcon(publicRead.getIcon(self.troopData.itemID))
		if gItemType.WAR_BUGLE == self.itemType then
			self.fields.Com_title:updateTitle(i18n("common_text_742"))
		elseif gItemType.GOLDEN_ARROW == self.itemType then
			self.fields.Com_title:updateTitle(i18n("common_text_742"))
		elseif gItemType.ASSAULT_HORN == self.itemType then
			self.fields.Com_title:updateTitle(i18n("common_text_3286"))
		end
		if self.troopData.needCount then
			publicRead = i18n("common_text_3286")
			i18n("common_text_3286").item = itemName
			i18n("common_text_3286").have = itemCount
			i18n("common_text_3286").need = self.troopData.needCount
			self.fields.Label_ItemNum:setString(i18n("common_text_1243", i18n("common_text_3286")))
			if itemCount < self.troopData.needCount then
				self.fields.Label_ItemNum:getChild("title"):setColor(cc.c3b(255, 0, 0))
			else
				self.fields.Label_ItemNum:getChild("title"):setColor(cc.c3b(255, 251, 213))
			end
		else
			publicRead = cc.c3b(255, 251, 213)
			cc.c3b(255, 251, 213).name = itemName
			cc.c3b(255, 251, 213).num = itemCount
			self.fields.Label_ItemNum:setString(i18n("disassemble_fast_9", cc.c3b(255, 251, 213)))
		end
	else
		self.fields.Com_title:updateTitle(i18n("common_text_742"))
		self.controllers.c1:setSelectedIndex(1)
	end
	if self.troopData and self.troopData.itemList then
		self.fields.Com_title:updateTitle(i18n("common_text_742"))
	end
	if self.troopData and self.troopData.hideTxtTitle then
		self.controllers.c1:setSelectedIndex(1)
	end
	self.fields.list:setNumItems(#self.itemList)
end
function PropBuyViewPanel:onItemRederer(index, target)
	target:initData(self.itemList[index + 1], self.itemType)
end
function PropBuyViewPanel:createSingleInfo(itemID)
	local isAllowShow = true
	local backpackCtrl, _initData
	local itemCount = backpackCtrl:getItemCount(itemID)
	local itemInfo = shopltCtrl:getShopItemByItemID(itemID)
	local limitInfo = itemInfo and shopCtrl:getLimitDataByID(itemInfo.shopItemID)
	if 0 < itemCount then
		if itemInfo then
			backpackCtrl = shopCtrl
			shopCtrl.iid = itemID
			shopCtrl.gold = itemInfo.price
			shopCtrl.limitData = limitInfo
			shopCtrl.count = itemCount
			_initData, shopCtrl.isBuyOnly = shopCtrl, self.isBuyOnly
		else
			backpackCtrl = shopCtrl
			shopCtrl.iid = itemID
			shopCtrl.count = itemCount
			_initData, shopCtrl.isBuyOnly = shopCtrl, self.isBuyOnly
		end
	elseif itemInfo then
		backpackCtrl = shopCtrl
		shopCtrl.iid = itemID
		shopCtrl.gold = itemInfo.price
		shopCtrl.limitData = limitInfo
		shopCtrl.isBuyOnly = self.isBuyOnly
		_initData, shopCtrl.shopID = shopCtrl, itemInfo.shopItemID
	else
		isAllowShow = false
	end
	if not itemLogic.checkUseCond(itemID) then
		isAllowShow = false
	end
	if _initData and itemInfo and itemInfo.isLadder == 1 then
		local count = 0
		if limitInfo then
			count = limitInfo.buyCount
		end
		_initData.gold = shopltCtrl:getLadderPrice(itemInfo.shopItemID, count + 1)
	end
	if isAllowShow then
		return _initData
	else
		print("noShow = ", itemID)
		return nil
	end
end
function PropBuyViewPanel:createSingleInfoByShopID(shopInfo)
	local isAllowShow = true
	local shopCtrl, _initData
	local limitInfo = shopInfo and shopCtrl:getLimitDataByID(shopInfo.shopItemID)
	if shopInfo then
		shopCtrl = shopCtrl
		shopCtrl.iid = shopInfo.itemId
		shopCtrl.gold = shopInfo.price
		shopCtrl.limitData = limitInfo
		shopCtrl.isBuyOnly = self.isBuyOnly
		shopCtrl.buyCount = shopInfo.number
		shopCtrl.shopID = shopInfo.shopItemID
		_initData, shopCtrl.oriInfo = shopCtrl, shopInfo
	else
		isAllowShow = false
	end
	if not itemLogic.checkUseCond(shopInfo.itemId) then
		isAllowShow = false
	end
	if isAllowShow then
		return _initData
	else
		print("noShow = ", shopInfo.itemId)
		return nil
	end
end
return PropBuyViewPanel
