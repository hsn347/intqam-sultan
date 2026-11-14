local itemDesRead = include("itemDesRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local resDesRead = include("resDesRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local treasureCourtCtrl = SoraDGetCtrl("treasureCourtCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
local vipLocalData = include("vipLocalData")
local equipDesRead = include("equipDesRead")
local godArmsCtrl = SoraDGetCtrl("godArmsCtrl")
local itemLogic = include("itemLogic")
local activityExchangeMallRead = include("activityExchangeMallRead")
local dailyRemindManager = include("dailyRemindManager")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local newShopSingleBuyPanel = class("newShopSingleBuyPanel", baseFguiPanel)
function newShopSingleBuyPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("newShopSingleBuyPanel:ctor", self.viewName)
end
function newShopSingleBuyPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function newShopSingleBuyPanel:onInit()
	print("=======newShopSingleBuyPanel:onInit")
	self.canBuyMax = 9999
	self.limitData = nil
	self.isInit = true
	self.exchangeItemID = gIDDef.GOLD
	self.needBuy = 0
	self.needResCount = nil
	self.fields.Panel_bg.isIgnoreTextEffect = true
	self.fields.Text_resNotice:setVisible(false)
	self.fields.Text_resTotal:setVisible(false)
	self.fields.com_preview:setVisible(false)
	self.fields.Button_Buy:addClickListener(handler(self, self.onBuy))
	self.fields.item:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.slider:setInpuBoxFixPos()
end
function newShopSingleBuyPanel:onShow()
	print("=======newShopSingleBuyPanel:onShow")
	self.tableItem = self.param.itemData
	self.otherData = self.param.otherData
	self.useAndBuy = self.param.useAndBuy or false
	self.needResCount = self.param.needResList
	self.buyHandle = self.param.buyHandle
	self.isHideUseTotal = self.param.isHideUseTotal or false
	self.labelName = self.param.labelName
	self.exchangeCfg = self.param.exchangeCfg
	self.hideSlider = self.param.hideSlider or false
	self.fields.slider:setVisible(not self.hideSlider)
	self.quickBuyData = self.param.quickBuyData
	if self.exchangeCfg then
		self.exchangeHandler = self.exchangeCfg.exchangeHandler
		self:initExchangeData()
	elseif self.quickBuyData then
		self:initQuickBuyData()
	else
		if self.needResCount then
			self:setNeedResCount()
		end
		self:initData()
	end
end
function newShopSingleBuyPanel:isUnlockWeaponItem(id)
	if id == 240801 or id == 240501 or id == 240601 then
		return true
	end
	return false
end
function newShopSingleBuyPanel:initQuickBuyData()
	self.tableItem = self.quickBuyData
	self.canBuyMax = math.floor(backpackltCtrl:getBuyMax(self.tableItem.id) / self.tableItem.number) or 9999
	if self.otherData and self.otherData.maxCount then
		self.canBuyMax = self.otherData.maxCount
	end
	if self.otherData and self.otherData.curValue then
		self.curValue = self.otherData.curValue
	end
	self.fields.Panel_bg:setString(self.labelName or publicRead.getName(self.tableItem.id))
	self.fields.item:initData(self.tableItem.id, self.otherData and self.otherData.itemCount or nil)
	self.fields.Text_des:setString(publicRead.getDes(self.tableItem.id))
	if self.tableItem.originalPrice then
		_ENV = self.tableItem.originalPrice
		self.tableItem.originalPrice.max = self.tableItem.max
		self.limitData, self.tableItem.originalPrice.cur = self.tableItem.originalPrice, self.tableItem.cur
	else
		self.limitData = shopCtrl:getLimitDataByID(self.tableItem.shopItemID)
		if self.limitData and next(self.limitData) then
			_ENV = publicRead.getDes(self.tableItem.id)
			publicRead.getDes(self.tableItem.id).member = self.limitData.cur
			publicRead.getDes(self.tableItem.id).total = self.limitData.max
			self.fields.item:setNumText(i18n("common_text_155", publicRead.getDes(self.tableItem.id)))
		end
	end
	if self.limitData then
		self.canBuyMax = math.min(self.canBuyMax, self.limitData.cur)
	end
	local itemCount = math.min(self.canBuyMax, self:getMaxCanBuy())
	if self.curValue then
		self.curValue = math.min(self.curValue, itemCount)
	end
	if self.tableItem.upperLimit and self.tableItem.upperLimit == 1 or self:isUnlockWeaponItem(self.tableItem.id) then
		local ownCount = backpackCtrl:getItemGainRecordNum(self.tableItem.id)
		itemCount = math.max(1, math.min(self.canBuyMax, self.tableItem.limitNum - ownCount))
	end
	self.fields.slider:setSliderCallBack(handler(self, self.payGoldChange))
	_ENV = handler(self, self.payGoldChange)
	handler(self, self.payGoldChange).maxValue = itemCount
	handler(self, self.payGoldChange).minValue = 1
	handler(self, self.payGoldChange).curValue = self.curValue or 1
	self.fields.slider:initData(handler(self, self.payGoldChange))
end
function newShopSingleBuyPanel:initExchangeData()
	self.targetID = self.exchangeCfg.exchangeData.targetID
	self.exchangeID = self.exchangeCfg.exchangeData.exchangeID
	self.singCount = self.exchangeCfg.exchangeData.singCount
	self.curNum = self.exchangeCfg.exchangeData.curNum
	self.huntCount = self.exchangeCfg.exchangeData.huntCount
	self.singleGet = self.exchangeCfg.exchangeData.singleGet or 1
	self.fields.Panel_bg:setString(publicRead.getName(self.targetID))
	self.fields.Text_des:setString(publicRead.getDes(self.targetID))
	self.fields.item:initData(self.targetID, self.huntCount)
	self.fields.Button_Buy:setPrice(self.singCount * self.curNum)
	self.fields.Button_Buy:setIcon(publicRead.getIcon(self.exchangeID))
	if self.targetID == gIDDef.SIEVE or self.targetID == gIDDef.GIFT_ROLL then
		self.fields.Panel_bg:setString(resDesRead.getName(self.targetID))
		self.fields.Text_des:setString(resDesRead.getDes(self.targetID))
		self.fields.Button_Buy:setIcon(resDesRead.getIcon(self.exchangeID))
	end
	if not IsArClient and self.targetID == 851100 then
		self.fields.Panel_bg:setString(resDesRead.getName(1033))
		self.fields.Text_des:setString(resDesRead.getDes(1033))
	end
	if self.exchangeID == gIDDef.PYRAMID_REGULAR_SCORE then
		self.fields.Button_Buy:setIcon("icon_regularSeason_point.png")
	elseif self.exchangeID == gIDDef.PYRAMID_PEAK_SCORE then
		self.fields.Button_Buy:setIcon("icon_peakSeason_point.png")
	elseif self.exchangeID == gIDDef.PURPLE_AGATE then
		self.fields.Button_Buy:setIcon("1629.png")
	end
	local info = activityExchangeMallRead:getShopItemByItemID(self.targetID)
	if info and info.upperLimit == 1 or self:isUnlockWeaponItem(self.targetID) then
		local ownCount = backpackCtrl:getItemGainRecordNum(self.targetID)
		self.curNum = math.max(1, math.min(self.curNum, info.limitnum - ownCount))
	end
	self.fields.slider:setSliderCallBack(handler(self, self.exChangeUpdate))
	publicRead = handler(self, self.exChangeUpdate)
	handler(self, self.exChangeUpdate).maxValue = self.curNum
	handler(self, self.exChangeUpdate).minValue = 1
	handler(self, self.exChangeUpdate).curValue = 1
	self.fields.slider:initData(handler(self, self.exChangeUpdate))
end
function newShopSingleBuyPanel:exChangeUpdate(exChangeCount)
	if tolua.isnull(self) then
		return
	end
	self.fields.Button_Buy:setTitleGold(string.formatnumberthousands(self.singCount * math.floor(exChangeCount)))
	self.fields.item:setNumText(string.formatnumberthousands(self.singleGet * math.floor(exChangeCount)))
end
function newShopSingleBuyPanel:setNeedResCount()
	if self.needResCount then
		SoraDRemoveMessageFromTargetByName(self, "MESSAGE_RESOURCE_UPDATE")
		SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.refreshView))
		self:refreshView()
	end
end
function newShopSingleBuyPanel:refreshView()
	if self.tableItem and self.tableItem.id then
		local haveGold = lordInfoCtrl:getBaseInfo().gold
		local itemCount = math.min(self.canBuyMax, math.max(1, math.floor(haveGold / self.tableItem.price)))
		local itemData = backpackltCtrl:getResult(self.tableItem.id)
		local curResCount = cityCtrl:getResCount(itemData[1].id)
		if self.needResCount[itemData[1].id] then
			self.needResCount[itemData[1].id].curcount = curResCount
		end
		local needData = self.needResCount[itemData[1].id]
		if needData and needData.rescount > needData.curcount then
			local curCount = self.fields.slider:getSliderCurValue() or 1
			local needValue = math.ceil((needData.rescount - needData.curcount) / itemData[1].count)
			needValue = math.min(itemCount, needValue)
			if curCount ~= needValue and not self.isInit then
				needValue = curCount
			end
			if self.tableItem.upperLimit and self.tableItem.upperLimit == 1 or self:isUnlockWeaponItem(self.tableItem.id) then
				local ownCount = backpackCtrl:getItemGainRecordNum(self.tableItem.id)
				itemCount = math.max(1, math.min(itemCount, self.tableItem.limitNum - ownCount))
			end
			lordInfoCtrl = 1
			;(1).maxValue = itemCount
			;(1).minValue = 1
			;(1).curValue = needValue
			self.fields.slider:initData(1)
			self.isInit = false
		end
		self:updateResNeed()
	end
end
function newShopSingleBuyPanel:initData()
	self.canBuyMax = backpackltCtrl:getBuyMax(self.tableItem.id) or 9999
	if self.otherData and self.otherData.maxCount then
		self.canBuyMax = self.otherData.maxCount
	end
	if self.otherData and self.otherData.exchangeID then
		self.exchangeItemID = self.otherData.exchangeID
	end
	if self.otherData and self.otherData.curValue then
		self.curValue = self.otherData.curValue
	end
	dump(self.labelName or publicRead.getName(self.tableItem.id), "self.labelName or publicRead.getName(self.tableItem.id)")
	self.fields.Panel_bg:setString(self.labelName or publicRead.getName(self.tableItem.id))
	self.fields.item:initData(self.tableItem.id, self.otherData and self.otherData.itemCount or nil)
	self.fields.Text_des:setString(publicRead.getDes(self.tableItem.id))
	if self.tableItem.originalPrice then
		backpackltCtrl = self.tableItem.originalPrice
		self.tableItem.originalPrice.max = self.tableItem.max
		self.limitData, self.tableItem.originalPrice.cur = self.tableItem.originalPrice, self.tableItem.cur
	else
		if self.tableItem.shopItemID then
			self.limitData = shopCtrl:getLimitDataByID(self.tableItem.shopItemID)
		end
		if self.limitData and next(self.limitData) then
			backpackltCtrl = publicRead.getDes(self.tableItem.id)
			publicRead.getDes(self.tableItem.id).member = self.limitData.cur
			publicRead.getDes(self.tableItem.id).total = self.limitData.max
			self.fields.item:setNumText(i18n("common_text_155", publicRead.getDes(self.tableItem.id)))
		end
	end
	if self.limitData then
		self.canBuyMax = math.min(self.canBuyMax, self.limitData.cur)
	end
	local itemCount = self.canBuyMax
	if self.exchangeItemID == gIDDef.GOLD then
		itemCount = math.min(self.canBuyMax, self:getMaxCanBuy())
	end
	if self.tableItem.upperLimit and self.tableItem.upperLimit == 1 or self:isUnlockWeaponItem(self.tableItem.id) then
		local ownCount = backpackCtrl:getItemGainRecordNum(self.tableItem.id)
		itemCount = math.max(1, math.min(self.canBuyMax, self.tableItem.limitNum - ownCount))
	end
	if self.curValue then
		self.curValue = math.min(self.curValue, itemCount)
	end
	self.fields.slider:setSliderCallBack(handler(self, self.payGoldChange))
	backpackltCtrl = handler(self, self.payGoldChange)
	handler(self, self.payGoldChange).maxValue = itemCount
	handler(self, self.payGoldChange).minValue = 1
	handler(self, self.payGoldChange).curValue = self.curValue or 1
	self.fields.slider:initData(handler(self, self.payGoldChange))
end
function newShopSingleBuyPanel:payGoldChange(needBuy)
	self.needBuy = needBuy
	local price = self.tableItem.price
	local totalPrice = self:getTotalPrice(needBuy)
	self.fields.Button_Buy:initData(self.exchangeItemID, totalPrice)
	if self.tableItem.originalPrice then
		self.fields.Button_Buy:setPrice(self.needBuy * self.tableItem.price, self.needBuy * self.tableItem.originalPrice)
	end
	if self.exchangeItemID == gIDDef.GOLD then
		if SoraDEnoughGold(totalPrice, true) then
			self.fields.Button_Buy:setTitleColor(cc.c3b(255, 251, 213))
			self.fields.Button_Buy:setTitleTextColor(cc.c3b(255, 251, 213), cc.c3b(255, 251, 213))
		else
			self.fields.Button_Buy:setTitleColor(cc.c3b(190, 40, 40))
			self.fields.Button_Buy:setTitleTextColor(cc.c3b(190, 40, 40), cc.c3b(190, 40, 40))
		end
	elseif self.exchangeItemID == gIDDef.JADE_STONE then
		if treasureCourtCtrl:isEnoughStone(totalPrice, true) then
			self.fields.Button_Buy:setTitleColor(cc.c3b(255, 251, 213))
			self.fields.Button_Buy:setTitleTextColor(cc.c3b(255, 251, 213), cc.c3b(255, 251, 213))
			self.fields.Button_Buy:setEnabled(true)
		else
			self.fields.Button_Buy:setTitleColor(cc.c3b(190, 40, 40))
			self.fields.Button_Buy:setTitleTextColor(cc.c3b(190, 40, 40), cc.c3b(190, 40, 40))
			self.fields.Button_Buy:setEnabled(false)
		end
	end
	self:updateResNotice()
	self:showUseTotal()
	if self.useAndBuy then
		self:showUseNextPercent()
	end
end
function newShopSingleBuyPanel:showUseNextPercent()
	local itemType = backpackltCtrl:getItemType(self.tableItem.id)
	_UPVALUE2_ = backpackltCtrl
	backpackltCtrl[1] = gItemType.VIP_POINT
	local backpackltCtrl[2], showList = gItemType.S_VIP_POINT, backpackltCtrl
	if SoraDisInList(itemType, showList) then
		self.fields.com_preview:setVisible(true)
		local result = backpackltCtrl:getResult(self.tableItem.id)
		local singleNum = result[1].count
		local singleID = result[1].id
		local curCount = self.fields.slider:getSliderCurValue()
		local curData, nextData = self:getUseResult(itemType, curCount * singleNum)
		if curData == nil then
			self.fields.com_preview:setVisible(false)
		else
			self.fields.com_preview:initData(curData, nextData)
		end
	end
end
function newShopSingleBuyPanel:getUseResult(itemType, addPoint)
	local lordInfoCtrl, curData
	local lordInfoCtrl, nextData
	curData.lv, curData.percent = lordInfoCtrl:calcNewVipLev(itemType, 0)
	if not curData then
		return
	end
	nextData.nextLv, nextData.nextPercent = lordInfoCtrl:calcNewVipLev(itemType, addPoint)
	local kingdomLev = kingdomLevelDataModuleAPI:getKingdomLevel() or 0
	local maxVipLevel = vipLocalData.getMaxVipLev(kingdomLev)
	if maxVipLevel <= curData.lv and curData.percent >= 1 then
		curData.lv = maxVipLevel
		curData.percent = "MAX"
	end
	if maxVipLevel <= nextData.nextLv and nextData.nextPercent >= 1 then
		nextData.nextLv = maxVipLevel
		nextData.nextPercent = "MAX"
	end
	return curData, nextData
end
function newShopSingleBuyPanel:showUseTotal()
	local itemType = backpackltCtrl:getItemType(self.tableItem.id)
	_UPVALUE6_ = backpackltCtrl
	backpackltCtrl[1] = gItemType.FOOD
	backpackltCtrl[2] = gItemType.WOOD
	backpackltCtrl[3] = gItemType.IRON
	backpackltCtrl[4] = gItemType.MITHRIL
	backpackltCtrl[5] = gItemType.CRYSTAL
	local backpackltCtrl[6], showList = gItemType.POWERFUL_ESSENCE, backpackltCtrl
	if SoraDisInList(itemType, showList) and not self.needResCount and not self.isHideUseTotal then
		self.fields.Text_resTotal:setVisible(true)
		local result = backpackltCtrl:getResult(self.tableItem.id)
		local singleNum = result[1].count
		local singleID = result[1].id
		local curCount = self.fields.slider:getSliderCurValue() or 1
		local curNum = self:getCurNum(itemType) or 0
		local resName = resDesRead.getName(singleID)
		backpackltCtrl = nil
		;(nil).resource = resName
		;(nil).count = string.formatnumberthousands(singleNum * curCount + curNum)
		self.fields.Text_resTotal:setString(i18n("common_text_4289", nil))
	end
end
function newShopSingleBuyPanel:getCurNum(itemType)
	_ENV = nil
	;(nil)[gItemType.FOOD] = gIDDef.FOOD
	;(nil)[gItemType.WOOD] = gIDDef.WOOD
	;(nil)[gItemType.IRON] = gIDDef.IRON
	;(nil)[gItemType.MITHRIL] = gIDDef.MITHRIL
	local (nil)[gItemType.CRYSTAL], tabResID = gIDDef.CRYSTAL, nil
	local ownNum = cityCtrl:getResCount(tabResID[itemType])
	if itemType == gItemType.POWERFUL_ESSENCE then
		ownNum = SoraDGetCtrl("warGemCtrl"):getEssenceCount()
	end
	return ownNum
end
function newShopSingleBuyPanel:updateResNotice()
	local resNotice
	_ENV = nil
	;(nil)[gIDDef.GOLD] = true
	;(nil)[gIDDef.FOOD] = true
	;(nil)[gIDDef.WOOD] = true
	;(nil)[gIDDef.IRON] = true
	;(nil)[gIDDef.MITHRIL] = true
	;(nil)[gIDDef.STEEL] = true
	;(nil)[gIDDef.STAMINA] = true
	;(nil)[gIDDef.VIP_POINT] = true
	;(nil)[gIDDef.S_VIP_POINT] = true
	;(nil)[gIDDef.CRYSTAL] = true
	local (nil)[gIDDef.STRONG_ESSENCE], tableResId = true, nil
	local itemData = backpackltCtrl:getResult(self.tableItem.id)
	if self.useAndBuy and type(itemData) == "table" and #itemData == 1 and tableResId[itemData[1].id] then
		_ENV = nil
		;(nil).count = self.needBuy
		;(nil).res = string.formatnumberthousands(self.needBuy * itemData[1].count)
		;(nil).resname = resDesRead.getName(itemData[1].id)
		resNotice = i18n("common_text_1955", nil)
		if itemData[1].id == gIDDef.VIP_POINT then
			local vipLevel, isActive = SoraDGetVipLv()
			if vipLevel > VIP_SVIP_LV then
				_ENV = itemData[1].id
				itemData[1].id.count = self.needBuy
				itemData[1].id.res = string.formatnumberthousands(vipLocalData.transPointVip2Svip(self.needBuy * itemData[1].count))
				itemData[1].id.resname = i18n("common_text_3852")
				resNotice = i18n("common_text_1955", itemData[1].id)
			end
		end
		self.fields.Text_resNotice:setString(resNotice)
		self:updateResNeed()
	end
	self.fields.Text_resNotice:setVisible(resNotice ~= nil)
end
function newShopSingleBuyPanel:updateResNeed()
	if self.needResCount then
		local curCount = self.fields.slider:getSliderCurValue()
		local itemData = backpackltCtrl:getResult(self.tableItem.id)
		local curResCount = curCount * itemData[1].count
		local isVisible = self.needResCount[itemData[1].id] ~= nil and self.needResCount[itemData[1].id].curcount < self.needResCount[itemData[1].id].rescount
		self.controllers.c1:setSelectedIndex(isVisible and 1 or 0)
		if isVisible then
			self.fields.Text_notice:setString(resDesRead.getName(itemData[1].id) .. ":" .. string.formatnumberthousands(curCount * itemData[1].count) .. "/" .. string.formatnumberthousands(self.needResCount[itemData[1].id].rescount - self.needResCount[itemData[1].id].curcount))
			if curResCount < self.needResCount[itemData[1].id].rescount - self.needResCount[itemData[1].id].curcount then
				self.fields.Text_notice:setColor(cc.c3b(190, 40, 40))
			else
				self.fields.Text_notice:setColor(cc.c3b(180, 170, 135))
			end
		end
	end
end
function newShopSingleBuyPanel:getTotalPrice(needBuy)
	local price = self.tableItem.price
	local totalPrice = price
	if self.tableItem.isLadder == 1 and self.tableItem.ladderPrice then
		local from = self.limitData.buyCount
		local ladderPrice = self.tableItem.ladderPrice
		local beginIndex = 1
		totalPrice = 0
		for i = 1 + from, needBuy + from do
			for j = beginIndex, #ladderPrice, 2 do
				if i < ladderPrice[j] then
					beginIndex = j
					break
				end
				price = ladderPrice[j + 1]
			end
			totalPrice = totalPrice + price
		end
		print("getTotalPrice", totalPrice)
	else
		totalPrice = price * needBuy
	end
	return totalPrice
end
function newShopSingleBuyPanel:getMaxCanBuy()
	local haveGold = lordInfoCtrl:getBaseInfo().gold
	local price = self.tableItem.price
	local buyNum = math.floor(haveGold / self.tableItem.price)
	if self.canBuyMax and self.tableItem.isLadder == 1 and self.tableItem.ladderPrice then
		local ladderNum = 0
		local ladderPrice = self.tableItem.ladderPrice
		local from = self.limitData.buyCount
		local beginIndex = 1
		for i = from, self.canBuyMax + from do
			for j = beginIndex, #ladderPrice, 2 do
				if i < ladderPrice[j] then
					beginIndex = j
					break
				end
				price = ladderPrice[j + 1]
			end
			haveGold = haveGold - price
			if haveGold < 0 then
				break
			end
			ladderNum = ladderNum + 1
		end
		buyNum = ladderNum
	end
	return math.max(1, buyNum)
end
function newShopSingleBuyPanel:checkLimitItem(target, data)
	if self.tableItem and self.tableItem.shopItemID and shopltCtrl:isShopItemValid(self.tableItem.shopItemID) == nil then
		self:close()
	end
end
function newShopSingleBuyPanel:onBuy()
	SoraDPlaySound()
	local sureBuy = function()
		if self.tableItem.originalPrice then
			include("limitTimeDiscountShopAPI"):buy(self.tableItem.shopItemID, self.needBuy)
		elseif not self.useAndBuy then
			if self.tableItem.upperLimit and self.tableItem.upperLimit == 1 or self:isUnlockWeaponItem(self.tableItem.id) then
				local weaponID = equipDesRead.Item2UnlockEquipID(self.tableItem.id)
				if weaponID and godArmsCtrl:isWeaponUnlock(weaponID) then
					SoraDShowMsgTip(i18n("already_unlocked_beasts"))
				else
					local ownCount = backpackCtrl:getItemGainRecordNum(self.tableItem.id)
					if ownCount >= self.tableItem.limitNum then
						SoraDShowMsgTip(i18n("common_text_4445"))
					else
						self = i18n("common_text_4445")
						i18n("common_text_4445").source = gShopBuySource.BUY_AND_USE_IN_BAG
						shopCtrl:reqBuyInItemShop(self.tableItem.shopItemID, self.needBuy, false, i18n("common_text_4445"))
					end
				end
			else
				self = self.needBuy
				self.needBuy.source = gShopBuySource.BUY_AND_USE_IN_BAG
				shopCtrl:reqBuyInItemShop(self.tableItem.shopItemID, self.needBuy, false, self.needBuy)
			end
		else
			local itemID = shopltCtrl:getResultID(self.tableItem.shopItemID)
			local isPass = itemLogic.checkResUseLowCastle(itemID, self.needBuy)
			local shopItemID = self.tableItem.shopItemID
			local needBuy = self.needBuy
			local buyItemID = self.tableItem.itemId
			if not isPass then
				self = gShopBuySource.BUY_AND_USE_IN_BAG
				gShopBuySource.BUY_AND_USE_IN_BAG.food = "500K"
				gShopBuySource.BUY_AND_USE_IN_BAG.wood = "500K"
				SoraDShowMsgBox(i18n("common_text_3500", gShopBuySource.BUY_AND_USE_IN_BAG), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
					if eventType == MSGBOX_CALLBACK_YES then
						_ENV = nil
						;(nil).needBuy = true
						if not itemLogic.checkItemSpecial(buyItemID, needBuy, nil) then
							_ENV = nil
							;(nil).source = gShopBuySource.BUY_AND_USE_IN_BAG
							shopCtrl:reqBuyInItemShop(shopItemID, needBuy, true, nil)
						end
					end
				end)
			else
				self = i18n("common_text_185")
				i18n("common_text_185").needBuy = true
				if not itemLogic.checkItemSpecial(buyItemID, needBuy, (i18n("common_text_185"))) then
					self = i18n("common_text_4445")
					i18n("common_text_4445").source = gShopBuySource.BUY_AND_USE_IN_BAG
					shopCtrl:reqBuyInItemShop(shopItemID, needBuy, true, i18n("common_text_4445"))
				end
			end
		end
	end
	local needRemove = true
	if self.exchangeHandler then
		local info = activityExchangeMallRead:getShopItemByItemID(self.targetID)
		local sliderVal = math.floor(self.fields.slider:getSliderCurValue())
		local exchangeHandler = self.exchangeHandler
		if info and info.upperLimit == 1 or self:isUnlockWeaponItem(self.targetID) then
			local weaponID = equipDesRead.Item2UnlockEquipID(self.targetID)
			if weaponID and godArmsCtrl:isWeaponUnlock(weaponID) then
				SoraDShowMsgTip(i18n("already_unlocked_beasts"))
			else
				local ownCount = backpackCtrl:getItemGainRecordNum(self.targetID)
				if ownCount >= info.limitnum then
					SoraDShowMsgTip(i18n("common_text_4445"))
				else
					exchangeHandler(sliderVal)
				end
			end
		else
			exchangeHandler(sliderVal)
		end
	elseif self.buyHandle then
		self.buyHandle(self.fields.slider:getSliderCurValue())
	elseif SoraDEnoughGold(self:getTotalPrice(self.needBuy)) then
		local itemType = backpackltCtrl:getItemType(self.tableItem.id)
		shopltCtrl = backpackltCtrl
		backpackltCtrl[1] = gItemType.FOOD
		backpackltCtrl[2] = gItemType.WOOD
		backpackltCtrl[3] = gItemType.IRON
		backpackltCtrl[4] = gItemType.MITHRIL
		local backpackltCtrl[5], resourceList = gItemType.CRYSTAL, backpackltCtrl
		if SoraDisInList(itemType, resourceList) then
			local ctype = dailyRemindManager.REMIND_TYPE.resourceBuyView
			if dailyRemindManager.checkNeedRemind(ctype) then
				needRemove = false
				SoraDShowMsgBox(i18n("circus_text_26"), i18n("common_text_204"), nil, function(eventType)
					if eventType == MSGBOX_CALLBACK_YES then
						dailyRemindManager.addRemindToManager(ctype)
						sureBuy()
						self:close()
					end
				end)
			else
				sureBuy()
			end
		else
			sureBuy()
		end
	end
	if needRemove then
		self:close()
	end
end
function newShopSingleBuyPanel:onHide()
	if self.limitData and self.limitData.cur <= 0 then
		SoraDShowMsgTip(i18n("shop_text_17"), itemDesRead.getIcon(self.tableItem.id, true))
	end
end
return newShopSingleBuyPanel
