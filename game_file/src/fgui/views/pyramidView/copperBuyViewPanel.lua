local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local pyramidCtrl = SoraDGetCtrl("pyramidCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local copperBuyViewPanel = class("copperBuyViewPanel", baseFguiPanel)
function copperBuyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("copperBuyViewPanel:ctor", self.viewName)
end
function copperBuyViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function copperBuyViewPanel:onInit()
	print("=======copperBuyViewPanel:onInit")
	self.itemData, _ENV, self.itemList, _ENV, self.isHideCurrentSceneView = print, print, print, print, true
	self.fields.Com_title:initData(i18n("common_text_026"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function copperBuyViewPanel:onItemRenderer(index, obj)
	obj:initData(self.itemData[index + 1])
end
function copperBuyViewPanel:onShow()
	print("=======copperBuyViewPanel:onShow")
	self.itemType = gItemType.COPPER
	self.itemID = gIDDef.COPPER
	self:refreshData()
end
function copperBuyViewPanel:refreshData()
	SoraDCloseLoading(self)
	self.itemList = backpackltCtrl:getItemArray(self.itemType)
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
function copperBuyViewPanel:initView()
	self.fields.Text_own:setString(publicRead.getName(self.itemID) .. ":" .. pyramidCtrl:getCopperNum())
	self.itemData, publicRead = self.fields.Text_own.setString, self.fields.Text_own.setString
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
return copperBuyViewPanel
