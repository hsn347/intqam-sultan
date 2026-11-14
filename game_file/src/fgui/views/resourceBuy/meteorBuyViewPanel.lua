local resDesRead = include("resDesRead")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemLogic = include("itemLogic")
local buildLogic = include("buildLogic")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local legendKingRead = include("legendKingRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local meteorBuyViewPanel = class("meteorBuyViewPanel", baseFguiPanel)
function meteorBuyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("meteorBuyViewPanel:ctor", self.viewName)
end
function meteorBuyViewPanel:onInit()
	print("=======meteorBuyViewPanel:onInit")
	self.isHideCurrentSceneView = true
	self.rid = self.param and self.param.rid or gIDDef.METEOR_CRYSTAL
	if not self.param or not self.param.needResData then
		_ENV = self.param.needResData
	end
	_ENV, _ENV, self.needResList, _ENV, self.needResData = "=======meteorBuyViewPanel:onInit", self.param.needResData, self.param.needResData, self.param.needResData, self.param.needResData
	;("=======meteorBuyViewPanel:onInit").index = 1
	;("=======meteorBuyViewPanel:onInit").resID = gIDDef.METEOR_CRYSTAL
	;("=======meteorBuyViewPanel:onInit").saveID = gIDDef.METEOR_CRYSTAL_SAFE
	_ENV, self.param.needResData[1], ("=======meteorBuyViewPanel:onInit").itemType = "=======meteorBuyViewPanel:onInit", "=======meteorBuyViewPanel:onInit", gItemType.SAFE_METEOR_CRYSTAL
	;("=======meteorBuyViewPanel:onInit").index = 2
	_ENV, self.param.needResData[2], ("=======meteorBuyViewPanel:onInit").resID = "=======meteorBuyViewPanel:onInit", "=======meteorBuyViewPanel:onInit", gIDDef.GILDED_CRYSTAL
	;("=======meteorBuyViewPanel:onInit").index = 3
	_ENV, self.resCfg, self.param.needResData[3], ("=======meteorBuyViewPanel:onInit").resID = self.param.needResData, self.param.needResData, "=======meteorBuyViewPanel:onInit", gIDDef.GILDED_CURE_ESSENCE
	_ENV = gIDDef.GILDED_CURE_ESSENCE
	gIDDef.GILDED_CURE_ESSENCE.title = i18n("Soldiers_armor_text_43")
	self.param.needResData[gIDDef.METEOR_CRYSTAL], gIDDef.GILDED_CURE_ESSENCE.index = gIDDef.GILDED_CURE_ESSENCE, 1
	_ENV = gIDDef.GILDED_CURE_ESSENCE
	gIDDef.GILDED_CURE_ESSENCE.title = i18n("item_name_1707")
	self.param.needResData[gIDDef.GILDED_CRYSTAL], gIDDef.GILDED_CURE_ESSENCE.index = gIDDef.GILDED_CURE_ESSENCE, 2
	_ENV = gIDDef.GILDED_CURE_ESSENCE
	gIDDef.GILDED_CURE_ESSENCE.title = i18n("item_name_1723")
	self.ridTitleCfg, self.param.needResData[gIDDef.GILDED_CURE_ESSENCE], gIDDef.GILDED_CURE_ESSENCE.index = self.param.needResData, gIDDef.GILDED_CURE_ESSENCE, 3
	self.default = self.ridTitleCfg[self.rid].index or 1
	self.fields.Com_title:initData(self.ridTitleCfg[self.rid].title, handler(self, self.onClickClose))
	self.fields.Button_sort:addClickListener(handler(self, self.btnSortClick))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.resBase:fixPos()
	self.fields.Text_totalRes:fixPos()
	self.fields.Text_notProtect:fixPos()
	self.fields.Text_protect:fixPos()
end
function meteorBuyViewPanel:onItemRenderer(index, obj)
	obj:initData(self.resData[index + 1], self.needResList)
end
function meteorBuyViewPanel:onShow()
	print("=======meteorBuyViewPanel:onShow")
	if self.needResData and next(self.needResData) then
		for k, v in pairs(self.needResData) do
			self.needResList[v.resid] = v
		end
	end
	self:initCfg()
	self:initData()
end
function meteorBuyViewPanel:initCfg()
	self.resTab, _ENV = nil, nil
	for k, v in ipairs(self.resCfg) do
		if k == 1 then
			table.insert(self.resTab, v)
		elseif SoraDIsGildedArmorOpen() then
			table.insert(self.resTab, v)
		end
	end
	_ENV = (for generator)
	ipairs(self.resCfg).defaultClick = self.default
	local ipairs(self.resCfg).tabsetArray, param = self.resTab, ipairs(self.resCfg)
	self.fields.tab:initView(param)
	self.controllers.c2:setSelectedIndex(#self.resTab == 1 and 1 or 0)
	self.fields.Button_sort:setPositionX(0)
end
function meteorBuyViewPanel:refreshRes()
	self.fields.tab:updateRes(self.needResList)
	local resCount = math.floor(cityCtrl:getResCount(self.rid) or 0)
	local safeNum = math.floor(cityCtrl:getSafeRes(self.rid) or 0)
	local wareHouseNum = math.floor(cityCtrl:getResCapacityByResID(self.rid))
	local ret = buildLogic.getWarehouseProtectCount()
	local wareHouseBuff = ret[tostring(self.rid)] and ret[tostring(self.rid)].add or 0
	_ENV = cityCtrl:getResCapacityByResID(self.rid)
	cityCtrl:getResCapacityByResID(self.rid).num = SoraDConvertNumberWithUnit(resCount)
	self.fields.Text_totalRes:setString(i18n("common_text_4313", cityCtrl:getResCapacityByResID(self.rid)))
	local notProtectNum = math.max(0, math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff))
	_ENV = math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)
	math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff).num = SoraDConvertNumberWithUnit(notProtectNum)
	self.fields.Text_notProtect:setString(i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)))
	_ENV = i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff))
	i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)).num = SoraDConvertNumberWithUnit(safeNum)
	self.fields.Text_protect:setString(i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff))))
	self.controllers.c1:setSelectedIndex(self.rid == gIDDef.METEOR_CRYSTAL and 0 or 1)
	local totalToolNum = 0
	for k, v in pairs(self.resList) do
		local ownNum = backpackCtrl:getItemCount(v)
		local result = backpackltCtrl:getResult(v)
		local singleNum = result[1].count
		totalToolNum = totalToolNum + singleNum * ownNum
	end
	_ENV = i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)))
	i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff))).resource = resDesRead.getName(self.rid)
	i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff))).num = SoraDConvertNumberWithUnit(totalToolNum)
	self.fields.Button_sort:setCurStr(i18n("common_text_4326", i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)))))
	self.fields.Button_sort:updateSort()
end
function meteorBuyViewPanel:updateTab(rid)
	self.rid = rid
	self.fields.Com_title:updateTitle(self.ridTitleCfg[self.rid].title)
	self:initData()
	self.fields.list:jumpToTop()
	self.fields.list:getScrollPane():updatePositionImmediately()
end
function meteorBuyViewPanel:initData()
	self.resList = resDesRead.getItemList(self.rid, true)
	self:sortData()
	self:refreshRes()
	self.fields.resBase:setIcon(resDesRead.getTreasureIcon(self.rid))
end
function meteorBuyViewPanel:sortData()
	self.resData, _ENV = nil, nil
	for k, v in ipairs(self.resList) do
		local data = self:createSingleInfo(v)
		if data then
			local own = backpackCtrl:getItemCount(data.iid)
			data.isOwn = 0 < own and 1 or 0
			local isSafe = self:isSafeRes(data.iid)
			data.isSafe = isSafe and 1 or 0
			local result = backpackltCtrl:getResult(data.iid)
			local value = result[1].count
			data.value = value
			table.insert(self.resData, data)
		end
	end
	if gIsResourceBuySort then
		table.sort(self.resData, function(a, b)
			local ret
			if a.isOwn == b.isOwn then
				if a.isSafe == b.isSafe then
					ret = a.value < b.value
				else
					ret = a.isSafe < b.isSafe
				end
			else
				ret = a.isOwn > b.isOwn
			end
			return ret
		end)
	else
		table.sort(self.resData, function(a, b)
			local ret
			if a.isOwn == b.isOwn then
				if a.isSafe == b.isSafe then
					ret = a.value > b.value
				else
					ret = a.isSafe < b.isSafe
				end
			else
				ret = a.isOwn > b.isOwn
			end
			return ret
		end)
	end
	self.fields.list:setNumItems(#self.resData)
end
function meteorBuyViewPanel:isSafeRes(rid)
	local goodType = backpackltCtrl:getItemType(rid)
	local isSafe = false
	for k, v in ipairs(self.resCfg) do
		if v.itemType and v.itemType == goodType then
			isSafe = true
			break
		end
	end
	return isSafe
end
function meteorBuyViewPanel:createSingleInfo(itemID)
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
			_initData, shopCtrl.count = shopCtrl, itemCount
		else
			backpackCtrl = shopCtrl
			shopCtrl.iid = itemID
			_initData, shopCtrl.count = shopCtrl, itemCount
		end
	elseif itemInfo then
		backpackCtrl = shopCtrl
		shopCtrl.iid = itemID
		shopCtrl.gold = itemInfo.price
		shopCtrl.limitData = limitInfo
		shopCtrl.shopID = itemInfo.shopItemID
		_initData, shopCtrl.count = shopCtrl, 0
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
		_initData.gold = gModuleMgr.sharedMgr("shopltCtrl"):getLadderPrice(itemInfo.shopItemID, count + 1)
	end
	if isAllowShow then
		return _initData
	else
		print("noShow = ", itemID)
		return nil
	end
end
function meteorBuyViewPanel:btnSortClick()
	SoraDPlaySound()
	gIsResourceBuySort = not gIsResourceBuySort
	self.fields.Button_sort:updateSort()
	self:sortData()
end
return meteorBuyViewPanel
