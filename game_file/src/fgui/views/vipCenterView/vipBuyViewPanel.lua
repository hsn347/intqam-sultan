local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local vipBuyViewPanel = class("vipBuyViewPanel", baseFguiPanel)
function vipBuyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("vipBuyViewPanel:ctor", self.viewName)
end
function vipBuyViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function vipBuyViewPanel:onInit()
	print("=======vipBuyViewPanel:onInit")
	self.itemData, _ENV, self.itemList, _ENV, self.isHideCurrentSceneView = print, print, print, print, true
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function vipBuyViewPanel:onShow()
	print("=======vipBuyViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.itemType = self.param.itemType
	self.itemType2 = self.param.itemType2
	self:initTitle()
	self:refreshData()
end
function vipBuyViewPanel:onItemRenderer(index, obj)
	obj:initData(self.itemData[index + 1])
end
function vipBuyViewPanel:refreshData(target, data)
	SoraDCloseLoading(self)
	local vipLevel = SoraDGetVipLv()
	if vipLevel >= VIP_MAX_LV - 1 and self.itemType == gItemType.VIP_POINT then
		self:close()
		return
	end
	local listData = clone(backpackltCtrl:getItemArray(self.itemType))
	if self.itemType2 then
		local listData2 = clone(backpackltCtrl:getItemArray(self.itemType2))
		for k, v in pairs(listData2) do
			table.insert(listData, v)
		end
	end
	if gItemType.WAR_GEM == self.itemType then
		local allWarGemListData = backpackltCtrl:getWarGemList()
		local _ENV, table2 = backpackltCtrl, backpackltCtrl
		for i, v in ipairs(allWarGemListData) do
			local itemCount = backpackCtrl:getItemCount(v)
			if 0 < itemCount then
				table.insert(listData, v)
			end
		end
		for key, val in pairs(listData) do
			table2[val] = true
		end
		listData, _ENV = pairs(listData)
		for k, v in pairs(table2) do
			table.insert(listData, k)
		end
	end
	self.itemList = listData
	table.sort(self.itemList, function(l, r)
		return r < l
	end)
	table.sort(self.itemList, function(a, b)
		local a1 = backpackltCtrl:getIndex(a) or 0
		local b1 = backpackltCtrl:getIndex(b) or 0
		local itemCount1 = backpackCtrl:getItemCount(a)
		local itemCount2 = backpackCtrl:getItemCount(b)
		if itemCount1 == itemCount2 then
			return a1 < b1
		else
			return itemCount1 > itemCount2
		end
	end)
	self:initView()
end
function vipBuyViewPanel:initView()
	self.itemData, backpackCtrl = nil, nil
	local createSingleInfo = function(itemID)
		local isAllowShow = true
		local backpackCtrl, _initData
		local itemCount = backpackCtrl:getItemCount(itemID)
		local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByItemID(itemID)
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
		if not include("itemLogic").checkUseCond(itemID) then
			isAllowShow = false
		end
		if _initData and itemInfo and itemInfo.isLadder == 1 then
			local count = 0
			if limitInfo then
				count = limitInfo.buyCount
			end
			_initData.gold = gModuleMgr.sharedMgr("shopltCtrl"):getLadderPrice(itemInfo.shopItemID, count + 1)
		end
		if isAllowShow then
			return _initData
		else
			print("noShow = ", itemID)
			return nil
		end
	end
	for i, v in ipairs(self.itemList) do
		local singleInfo = createSingleInfo(v)
		if singleInfo then
			table.insert(self.itemData, singleInfo)
		end
	end
	dump(self.itemData, "self.itemData======")
	self.fields.List:setNumItems(#self.itemData)
end
function vipBuyViewPanel:initTitle()
	if gItemType.VIP_TIME == self.itemType then
		self.fields.Com_title:updateTitle(i18n("common_text_447"))
	elseif gItemType.VIP_POINT == self.itemType then
		self.fields.Com_title:updateTitle(i18n("common_text_452"))
	elseif gItemType.WAR_GEM == self.itemType then
		self.fields.Com_title:updateTitle(i18n("common_text_3878"))
	end
end
return vipBuyViewPanel
