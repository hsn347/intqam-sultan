local resDesRead = include("resDesRead")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemLogic = include("itemLogic")
local buildLogic = include("buildLogic")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local resourceBuyViewPanel = class("resourceBuyViewPanel", baseFguiPanel)
function resourceBuyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("resourceBuyViewPanel:ctor", self.viewName)
end
function resourceBuyViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function resourceBuyViewPanel:onInit()
	print("=======resourceBuyViewPanel:onInit")
	self.isHideCurrentSceneView = true
	self.rid = self.param and self.param.rid or gIDDef.FOOD
	if not self.param or not self.param.needResData then
		_ENV = self.param.needResData
	end
	_ENV, _ENV, self.needResList, _ENV, self.needResData = "=======resourceBuyViewPanel:onInit", self.param.needResData, self.param.needResData, self.param.needResData, self.param.needResData
	;("=======resourceBuyViewPanel:onInit").index = 1
	;("=======resourceBuyViewPanel:onInit").resID = gIDDef.FOOD
	;("=======resourceBuyViewPanel:onInit").saveID = gIDDef.FOOD_SAFE
	_ENV, self.param.needResData[1], ("=======resourceBuyViewPanel:onInit").itemType = "=======resourceBuyViewPanel:onInit", "=======resourceBuyViewPanel:onInit", gItemType.SAFE_FOOD
	;("=======resourceBuyViewPanel:onInit").index = 2
	;("=======resourceBuyViewPanel:onInit").resID = gIDDef.WOOD
	;("=======resourceBuyViewPanel:onInit").saveID = gIDDef.WOOD_SAFE
	_ENV, self.param.needResData[2], ("=======resourceBuyViewPanel:onInit").itemType = "=======resourceBuyViewPanel:onInit", "=======resourceBuyViewPanel:onInit", gItemType.SAFE_WOOD
	;("=======resourceBuyViewPanel:onInit").index = 3
	;("=======resourceBuyViewPanel:onInit").resID = gIDDef.IRON
	;("=======resourceBuyViewPanel:onInit").saveID = gIDDef.IRON_SAFE
	_ENV, self.param.needResData[3], ("=======resourceBuyViewPanel:onInit").itemType = "=======resourceBuyViewPanel:onInit", "=======resourceBuyViewPanel:onInit", gItemType.SAFE_IRON
	;("=======resourceBuyViewPanel:onInit").index = 4
	;("=======resourceBuyViewPanel:onInit").resID = gIDDef.MITHRIL
	;("=======resourceBuyViewPanel:onInit").saveID = gIDDef.MITHRIL_SAFE
	_ENV, self.param.needResData[4], ("=======resourceBuyViewPanel:onInit").itemType = "=======resourceBuyViewPanel:onInit", "=======resourceBuyViewPanel:onInit", gItemType.SAFE_SECRET
	;("=======resourceBuyViewPanel:onInit").index = 5
	;("=======resourceBuyViewPanel:onInit").resID = gIDDef.CRYSTAL
	;("=======resourceBuyViewPanel:onInit").saveID = gIDDef.CRYSTAL_SAFE
	self.resCfg, self.param.needResData[5], ("=======resourceBuyViewPanel:onInit").itemType = self.param.needResData, "=======resourceBuyViewPanel:onInit", gItemType.SAFE_CRYSTAL
	self.fields.Com_title:initData(i18n("common_text_123"), handler(self, self.onClickClose))
	self.fields.Button_safeRes:addClickListener(handler(self, self.btnSafeResClick))
	self.fields.Button_sort:addClickListener(handler(self, self.btnSortClick))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_safeRes:fixPos()
	self.fields.resBase:fixPos()
	self.fields.Text_totalRes:fixPos()
	self.fields.Text_notProtect:fixPos()
	self.fields.Text_protect:fixPos()
	self.fields.Text_protect_warehouse:fixPos()
end
function resourceBuyViewPanel:onItemRenderer(index, obj)
	obj:initData(self.resData[index + 1], self.needResList)
end
function resourceBuyViewPanel:onShow()
	print("=======resourceBuyViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	if self.needResData and next(self.needResData) then
		for k, v in pairs(self.needResData) do
			self.needResList[v.resid] = v
		end
	end
	self:initCfg()
	self:initData()
end
function resourceBuyViewPanel:initCfg()
	self.resTab, _ENV = nil, nil
	local default = 1
	for k, v in ipairs(self.resCfg) do
		if SoraDResIsLock(v.resID) then
			table.insert(self.resTab, v)
			if v.resID == self.rid then
				default = v.index
			end
		end
	end
	_ENV = (for generator)
	ipairs(self.resCfg).defaultClick = default
	local ipairs(self.resCfg).tabsetArray, param = self.resTab, ipairs(self.resCfg)
	self.fields.tab:initView(param)
end
function resourceBuyViewPanel:refreshRes()
	self.fields.tab:updateRes(self.needResList)
end
function resourceBuyViewPanel:initData()
	self.resList = resDesRead.getItemList(self.rid, true)
	self:sortData()
	self:refreshRes()
	self.fields.resBase:setIcon(resDesRead.getTreasureIcon(self.rid))
	local resCount = math.floor(cityCtrl:getResCount(self.rid) or 0)
	local safeNum = math.floor(cityCtrl:getSafeRes(self.rid) or 0)
	local wareHouseNum = math.floor(cityCtrl:getResCapacityByResID(self.rid))
	local ret = buildLogic.getWarehouseProtectCount()
	local wareHouseBuff = ret[tostring(self.rid)] and ret[tostring(self.rid)].add or 0
	resDesRead = cityCtrl:getResCapacityByResID(self.rid)
	cityCtrl:getResCapacityByResID(self.rid).num = SoraDConvertNumberWithUnit(resCount)
	self.fields.Text_totalRes:setString(i18n("common_text_4313", cityCtrl:getResCapacityByResID(self.rid)))
	local notProtectNum = math.max(0, math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff))
	resDesRead = math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)
	math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff).num = SoraDConvertNumberWithUnit(notProtectNum)
	self.fields.Text_notProtect:setString(i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)))
	resDesRead = i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff))
	i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)).num = SoraDConvertNumberWithUnit(safeNum)
	self.fields.Text_protect:setString(i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff))))
	resDesRead = i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)))
	i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff))).num = SoraDConvertNumberWithUnit(math.min(wareHouseNum + wareHouseBuff, resCount - safeNum))
	self.fields.Text_protect_warehouse:setString(i18n("common_text_4315", i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)))))
	local totalToolNum = 0
	for k, v in pairs(self.resList) do
		local ownNum = backpackCtrl:getItemCount(v)
		local result = backpackltCtrl:getResult(v)
		local singleNum = result[1].count
		totalToolNum = totalToolNum + singleNum * ownNum
	end
	resDesRead = i18n("common_text_4315", i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff))))
	i18n("common_text_4315", i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)))).resource = resDesRead.getName(self.rid)
	i18n("common_text_4315", i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)))).num = SoraDConvertNumberWithUnit(totalToolNum)
	self.fields.Button_sort:setCurStr(i18n("common_text_4326", i18n("common_text_4315", i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff))))))
	self.fields.Button_sort:updateSort()
end
function resourceBuyViewPanel:sortData()
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
function resourceBuyViewPanel:updateTab(rid)
	self.rid = rid
	self:initData()
	self.fields.list:jumpToTop()
	self.fields.list:getScrollPane():updatePositionImmediately()
end
function resourceBuyViewPanel:isSafeRes(rid)
	local goodType = backpackltCtrl:getItemType(rid)
	local isSafe = false
	for k, v in ipairs(self.resCfg) do
		if v.itemType == goodType then
			isSafe = true
			break
		end
	end
	return isSafe
end
function resourceBuyViewPanel:createSingleInfo(itemID)
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
		print("没卖=====", itemID)
		isAllowShow = false
	end
	if not itemLogic.checkUseCond(itemID) then
		print("未达使用条件=====", itemID)
		isAllowShow = false
	end
	if next(_initData) and itemInfo and itemInfo.isLadder == 1 then
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
function resourceBuyViewPanel:btnSafeResClick()
	SoraDPlaySound()
	_ENV = "common_text_4317"
	;("common_text_4317").align = SoraDFLabelR()
	SoraDShowHelpMsgTip(i18n("common_text_4317"), "common_text_4317")
end
function resourceBuyViewPanel:btnSortClick()
	SoraDPlaySound()
	gIsResourceBuySort = not gIsResourceBuySort
	self.fields.Button_sort:updateSort()
	self:sortData()
end
return resourceBuyViewPanel
