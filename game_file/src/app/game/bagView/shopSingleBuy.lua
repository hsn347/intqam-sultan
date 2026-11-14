local itemDesRead = include("itemDesRead")
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local resDesRead = include("resDesRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local shopCtrl = gametop.playertop_:getModule("shopCtrl")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local publicRead = include("publicRead")
local ShopSingleBuy = class("shopSingleBuy", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("shopSingleBuy")
	end
	return target
end)
function ShopSingleBuy:ctor()
	self.canBuyMax = 9999
	self.isInit = true
	self.limitData = nil
	self.tableItem = nil
	self.isShowNum = false
	self.labelPay = SoraDGetChildByName(self, "Text_needPay")
	self.Node_gold = SoraDGetChildByName(self, "Node_gold")
	self.icon_gold = SoraDGetChildByName(self, "Image_gold")
	self.oriIcon = SoraDGetChildByName(self, "Image_oriGold")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labNotice = SoraDGetChildByName(self, "Text_notice")
	self.labNotice:setVisible(false)
	self.btnBuy = SoraDGetChildByName(self, "Button_Buy")
	self.bagShopSlider = SoraDGetExtendChildFromCCSByName(self, "CCS_commonSlider_slider")
	self.item = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItems_item")
	self.labelResNotice = SoraDGetChildByName(self, "Text_resNotice")
	self.labelResNotice:setVisible(false)
	self.labelResTotal = SoraDGetChildByName(self, "Text_resTotal")
	self.labelResTotal:setVisible(false)
	self.node_next = SoraDGetChildByName(self, "Node_next")
	self.node_next:setVisible(false)
	self.Node_ori = SoraDGetChildByName(self, "Node_ori")
	self.Node_ori:setVisible(false)
	self.Text_curPay = SoraDGetChildByName(self.Node_ori, "Text_curPay")
	self.Text_oriPay = SoraDGetChildByName(self.Node_ori, "Text_oriPay")
	self.needBuy = 0
	self.needResCount = nil
	self.exchangeItemID = gIDDef.GOLD
	self.btnBuy:addTouchEventListener(handler(self, self.onBuy))
	SoraDAddMessage(self, "MESSAGE_ITEM_LIMITITEM_TIMEOUT_BACK", function(...)
		if self.tableItem and self.tableItem.shopItemID and shopltCtrl:isShopItemValid(self.tableItem.shopItemID) == nil then
			self:removeFromParent()
		end
	end)
end
function ShopSingleBuy:setActionData(fromPos)
	_ENV = nil
	;(nil).x = self.item:getPositionX()
	self.oldPos, (nil).y = nil, self.item:getPositionY()
	fromPos = self.item:getParent():convertToNodeSpace(fromPos)
	self.item:setPosition(fromPos)
	self.item:setScale(0.5)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.scaleTo(0.3, 1)
	;(nil)[2] = cca.moveTo(0.3, self.oldPos.x, self.oldPos.y)
	;(nil)[3] = cca.moveTo(0.3, self.oldPos.x, self.oldPos.y)
	;(nil)[4] = cca.moveTo(0.3, self.oldPos.x, self.oldPos.y)
	;(nil)[5] = cca.moveTo(0.3, self.oldPos.x, self.oldPos.y)
	self.item:runAction(cca.spawn(nil))
end
function ShopSingleBuy:setBuyHandle(handle)
	self.buyHandle = handle
end
function ShopSingleBuy:setIsShowNum(ret)
	self.isShowNum = ret
end
function ShopSingleBuy:setIsHideUseTotal(ret)
	self.isHideUseTotal = ret
end
function ShopSingleBuy:showUseTotal()
	local itemType = backpackltCtrl:getItemType(self.tableItem.id)
	_UPVALUE6_ = backpackltCtrl
	backpackltCtrl[1] = gItemType.FOOD
	backpackltCtrl[2] = gItemType.WOOD
	backpackltCtrl[3] = gItemType.IRON
	backpackltCtrl[4] = gItemType.MITHRIL
	backpackltCtrl[5] = gItemType.CRYSTAL
	local backpackltCtrl[6], showList = gItemType.POWERFUL_ESSENCE, backpackltCtrl
	if SoraDisInList(itemType, showList) and not self.needResCount and not self.isHideUseTotal then
		self.labelResTotal:setVisible(true)
		local result = backpackltCtrl:getResult(self.tableItem.id)
		local singleNum = result[1].count
		local singleID = result[1].id
		local curCount = self.bagShopSlider:getSliderCurValue() or 1
		local curNum = self:getCurNum(itemType) or 0
		local resName = resDesRead.getName(singleID)
		backpackltCtrl = nil
		;(nil).resource = resName
		;(nil).count = string.formatnumberthousands(singleNum * curCount + curNum)
		self.labelResTotal:setString(i18n("common_text_4289", nil))
	end
end
function ShopSingleBuy:getCurNum(itemType)
	local ownNum = 0
	_ENV = nil
	;(nil)[gItemType.FOOD] = gIDDef.FOOD
	;(nil)[gItemType.WOOD] = gIDDef.WOOD
	;(nil)[gItemType.IRON] = gIDDef.IRON
	;(nil)[gItemType.MITHRIL] = gIDDef.MITHRIL
	local (nil)[gItemType.CRYSTAL], tabResID = gIDDef.CRYSTAL, nil
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	ownNum = cityCtrl:getResCount(tabResID[itemType])
	if itemType == gItemType.POWERFUL_ESSENCE then
		ownNum = SoraDGetCtrl("warGemCtrl"):getEssenceCount()
	end
	return ownNum
end
function ShopSingleBuy:showUseNextPercent()
	local itemType = backpackltCtrl:getItemType(self.tableItem.id)
	_UPVALUE2_ = backpackltCtrl
	backpackltCtrl[1] = gItemType.VIP_POINT
	local backpackltCtrl[2], showList = gItemType.S_VIP_POINT, backpackltCtrl
	if SoraDisInList(itemType, showList) then
		self.node_next:setVisible(true)
		local result = backpackltCtrl:getResult(self.tableItem.id)
		local singleNum = result[1].count
		local singleID = result[1].id
		local curCount = self.bagShopSlider:getSliderCurValue()
		local textCur = SoraDGetChildByName(self.node_next, "Text_cur")
		local textNext = SoraDGetChildByName(self.node_next, "Text_next")
		local curData, nextData = self:getUseResult(itemType, curCount * singleNum)
		local vipStr = "VIP"
		local svipStr = "SVIP"
		if SoraDFIsRA() then
			vipStr = "المميز"
			svipStr = "الفاخر"
		end
		local str = vipStr
		local strNext = vipStr
		if curData.lv > MAX_NORMAL_VIP_LV then
			str = svipStr
			curData.lv = curData.lv - MAX_NORMAL_VIP_LV
		end
		if nextData.nextLv > MAX_NORMAL_VIP_LV then
			strNext = svipStr
			nextData.nextLv = nextData.nextLv - MAX_NORMAL_VIP_LV
		end
		if type(curData.percent) == "number" then
			textCur:setString(str .. curData.lv .. "(" .. math.floor(curData.percent * 100) .. "%)")
		else
			textCur:setString(str .. curData.lv .. "(" .. curData.percent .. ")")
		end
		if type(nextData.nextPercent) == "number" then
			textNext:setString(strNext .. nextData.nextLv .. "(" .. math.floor(nextData.nextPercent * 100) .. "%)")
		else
			textNext:setString(strNext .. nextData.nextLv .. "(" .. nextData.nextPercent .. ")")
		end
		SoraDToCenter(self.node_next)
	end
end
function ShopSingleBuy:getUseResult(itemType, addPoint)
	local gametop, curData
	local gametop, nextData
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	curData.lv, curData.percent = lordInfoCtrl:calcNewVipLev(itemType, 0)
	nextData.nextLv, nextData.nextPercent = lordInfoCtrl:calcNewVipLev(itemType, addPoint)
	local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
	local kingdomLev = kingdomLevelDataModuleAPI:getKingdomLevel() or 0
	local vipLocalData = include("vipLocalData")
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
function ShopSingleBuy:updateResNotice()
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
			local gametop = gModuleMgr.getObject("gametop")
			local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			local vipDetail = lordInfoCtrl:getVipDetails()
			local vipLv = vipDetail.level
			if vipLv > VIP_SVIP_LV then
				local vipLocalData = include("vipLocalData")
				_ENV = nil
				;(nil).count = self.needBuy
				;(nil).res = string.formatnumberthousands(vipLocalData.transPointVip2Svip(self.needBuy * itemData[1].count))
				;(nil).resname = i18n("common_text_3852")
				resNotice = i18n("common_text_1955", nil)
			end
		end
		self.labelResNotice:setString(resNotice)
		self:updateResNeed()
	end
	self.labelResNotice:setVisible(resNotice ~= nil)
end
function ShopSingleBuy:updateResNeed()
	if self.needResCount then
		local curCount = self.bagShopSlider:getSliderCurValue()
		local itemData = backpackltCtrl:getResult(self.tableItem.id)
		local curResCount = curCount * itemData[1].count
		local isVisible = self.needResCount[itemData[1].id] ~= nil and self.needResCount[itemData[1].id].curcount < self.needResCount[itemData[1].id].rescount
		self.labNotice:setVisible(isVisible)
		if self.labNotice:isVisible() then
			self.labNotice:setString(resDesRead.getName(itemData[1].id) .. ":" .. string.formatnumberthousands(curCount * itemData[1].count) .. "/" .. string.formatnumberthousands(self.needResCount[itemData[1].id].rescount - self.needResCount[itemData[1].id].curcount))
			if curResCount < self.needResCount[itemData[1].id].rescount - self.needResCount[itemData[1].id].curcount then
				self.labNotice:setColor(display.COLOR_RED)
			else
				self.labNotice:setColor(display.COLOR_WHITE)
			end
		end
	end
end
function ShopSingleBuy:setNeedResCount(needResList)
	self.needResCount = needResList
	if self.needResCount then
		SoraDRemoveMessageFromTargetByName(self, "MESSAGE_RESOURCE_UPDATE")
		SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.refreshView))
		self:refreshView()
	end
end
function ShopSingleBuy:refreshView()
	if self.tableItem and self.tableItem.id then
		local haveGold = lordInfoCtrl:getBaseInfo().gold
		local itemCount = math.min(self.canBuyMax, math.max(1, math.floor(haveGold / self.tableItem.price)))
		local itemData = backpackltCtrl:getResult(self.tableItem.id)
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local curResCount = cityCtrl:getResCount(itemData[1].id)
		if self.needResCount[itemData[1].id] then
			self.needResCount[itemData[1].id].curcount = curResCount
		end
		local needData = self.needResCount[itemData[1].id]
		if needData and needData.rescount > needData.curcount then
			local curCount = self.bagShopSlider:getSliderCurValue() or 1
			local needValue = math.ceil((needData.rescount - needData.curcount) / itemData[1].count)
			needValue = math.min(itemCount, needValue)
			if curCount ~= needValue and not self.isInit then
				needValue = curCount
			end
			if self.tableItem.upperLimit and self.tableItem.upperLimit == 1 then
				local backpackCtrl = SoraDGetCtrl("backpackCtrl")
				local ownCount = backpackCtrl:getItemGainRecordNum(self.tableItem.id)
				itemCount = math.max(1, math.min(itemCount, self.tableItem.limitNum - ownCount))
			end
			lordInfoCtrl = math.max(1, math.min(itemCount, self.tableItem.limitNum - ownCount))
			math.max(1, math.min(itemCount, self.tableItem.limitNum - ownCount)).maxValue = itemCount
			math.max(1, math.min(itemCount, self.tableItem.limitNum - ownCount)).minValue = 1
			math.max(1, math.min(itemCount, self.tableItem.limitNum - ownCount)).curValue = needValue
			self.bagShopSlider:initData((math.max(1, math.min(itemCount, self.tableItem.limitNum - ownCount))))
			self.isInit = false
		end
		self:updateResNeed()
	end
end
function ShopSingleBuy:onBuy(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local checkWeapon = function(isUse)
			local equipDesRead = include("equipDesRead")
			local godArmsCtrl = gametop.playertop_:getModule("godArmsCtrl")
			local weaponID = equipDesRead.Item2UnlockEquipID(self.tableItem.id)
			local shopItemID = self.tableItem.shopItemID
			local needBuy = self.needBuy
			if weaponID and godArmsCtrl:isWeaponUnlock(weaponID) then
				SoraDShowMsgBox(i18n("artifact_text_42"), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
					if eventType == MSGBOX_CALLBACK_YES then
						_ENV = nil
						;(nil).source = gShopBuySource.BUY_AND_USE_IN_BAG
						shopCtrl:reqBuyInItemShop(shopItemID, needBuy, isUse, nil)
					end
				end)
			else
				_ENV = nil
				;(nil).source = gShopBuySource.BUY_AND_USE_IN_BAG
				shopCtrl:reqBuyInItemShop(shopItemID, needBuy, isUse, nil)
			end
		end
		local sureBuy = function()
			if self.tableItem.originalPrice then
				include("limitTimeDiscountShopAPI"):buy(self.tableItem.shopItemID, self.needBuy)
			elseif not self.useAndBuy then
				if self.tableItem.upperLimit and self.tableItem.upperLimit == 1 then
					local backpackCtrl = SoraDGetCtrl("backpackCtrl")
					local ownCount = backpackCtrl:getItemGainRecordNum(self.tableItem.id)
					if ownCount >= self.tableItem.limitNum then
						SoraDShowMsgTip(i18n("common_text_4445"))
					else
						checkWeapon(false)
					end
				else
					self = i18n("common_text_4445")
					i18n("common_text_4445").source = gShopBuySource.BUY_AND_USE_IN_BAG
					shopCtrl:reqBuyInItemShop(self.tableItem.shopItemID, self.needBuy, false, i18n("common_text_4445"))
				end
			else
				local itemLogic = include("itemLogic")
				local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
				local itemID = shopltCtrl:getResultID(self.tableItem.shopItemID)
				local isPass = itemLogic.checkResUseLowCastle(itemID, self.needBuy)
				local shopItemID = self.tableItem.shopItemID
				local needBuy = self.needBuy
				local buyItemID = self.tableItem.itemId
				if not isPass then
					self = i18n("common_text_4445")
					i18n("common_text_4445").food = "500K"
					i18n("common_text_4445").wood = "500K"
					SoraDShowMsgBox(i18n("common_text_3500", i18n("common_text_4445")), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
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
			local activityExchangeMallRead = include("activityExchangeMallRead")
			local info = activityExchangeMallRead:getShopItemByItemID(self.targetID)
			local sliderVal = math.floor(self.bagShopSlider:getSliderCurValue())
			local exchangeHandler = self.exchangeHandler
			if info and info.upperLimit == 1 then
				local backpackCtrl = SoraDGetCtrl("backpackCtrl")
				local ownCount = backpackCtrl:getItemGainRecordNum(self.targetID)
				if ownCount >= info.limitnum then
					SoraDShowMsgTip(i18n("common_text_4445"))
				else
					local equipDesRead = include("equipDesRead")
					local godArmsCtrl = gametop.playertop_:getModule("godArmsCtrl")
					local weaponID = equipDesRead.Item2UnlockEquipID(self.targetID)
					if weaponID and godArmsCtrl:isWeaponUnlock(weaponID) then
						SoraDShowMsgBox(i18n("artifact_text_42"), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
							if eventType == MSGBOX_CALLBACK_YES then
								exchangeHandler(sliderVal)
							end
						end)
					else
						exchangeHandler(sliderVal)
					end
				end
			else
				exchangeHandler(sliderVal)
			end
		elseif self.buyHandle then
			self.buyHandle(self.bagShopSlider:getSliderCurValue())
		elseif SoraDEnoughGold(self:getTotalPrice(self.needBuy)) then
			local itemType = backpackltCtrl:getItemType(self.tableItem.id)
			_UPVALUE5_ = backpackltCtrl
			backpackltCtrl[1] = gItemType.FOOD
			backpackltCtrl[2] = gItemType.WOOD
			backpackltCtrl[3] = gItemType.IRON
			backpackltCtrl[4] = gItemType.MITHRIL
			local backpackltCtrl[5], resourceList = gItemType.CRYSTAL, backpackltCtrl
			if SoraDisInList(itemType, resourceList) then
				local dailyRemindManager = include("dailyRemindManager")
				local ctype = dailyRemindManager.REMIND_TYPE.resourceBuyView
				if dailyRemindManager.checkNeedRemind(ctype) then
					needRemove = false
					SoraDShowMsgBox(i18n("circus_text_26"), i18n("common_text_204"), nil, function(eventType)
						if eventType == MSGBOX_CALLBACK_YES then
							dailyRemindManager.addRemindToManager(ctype)
							sureBuy()
							self:removeFromParent()
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
			self:removeFromParent()
		end
	end
end
function ShopSingleBuy:setUseAndBuy(bool)
	self.useAndBuy = bool
	self:updateResNotice()
end
function ShopSingleBuy:initExchangeData(targetID, exchangeID, singCount, curNum, huntCount, singleGet)
	self.targetID = targetID
	self.singCount = singCount
	self.singleGet = singleGet or 1
	self.labelName:setString(publicRead.getName(targetID))
	self.labelDes:setString(publicRead.getDes(targetID))
	publicRead = publicRead.getDes(targetID)
	publicRead.getDes(targetID).itemID = targetID
	publicRead.getDes(targetID).itemCount = huntCount
	self.item:initData(publicRead.getDes(targetID))
	self.labelPay:setString(string.formatnumberthousands(singCount * curNum))
	SoraDToCenter(self.Node_gold)
	self.icon_gold:loadTexture(publicRead.getIcon(exchangeID), ccui.TextureResType.plistType)
	print("targetID,exchangeID,singCount,curNum, huntCount,singleGet === ", targetID, exchangeID, singCount, curNum, huntCount, singleGet)
	if targetID == gIDDef.SIEVE or targetID == gIDDef.GIFT_ROLL then
		local resDesRead = include("resDesRead")
		self.labelName:setString(resDesRead.getName(targetID))
		self.labelDes:setString(resDesRead.getDes(targetID))
		self.icon_gold:loadTexture(resDesRead.getIcon(exchangeID), ccui.TextureResType.plistType)
	end
	if not IsArClient and targetID == 851100 then
		local resDesRead = include("resDesRead")
		self.labelName:setString(resDesRead.getName(1033))
		self.labelDes:setString(resDesRead.getDes(1033))
	end
	if exchangeID == gIDDef.ALLIANCE_HUNTING_POINT and huntCount then
		self.item.num:setString(huntCount)
		self.item:hiddleNum(false)
	end
	if exchangeID == gIDDef.PYRAMID_REGULAR_SCORE then
		self.icon_gold:loadTexture("icon_regularSeason_point.png", ccui.TextureResType.plistType)
	elseif exchangeID == gIDDef.PYRAMID_PEAK_SCORE then
		self.icon_gold:loadTexture("icon_peakSeason_point.png", ccui.TextureResType.plistType)
	elseif exchangeID == gIDDef.PURPLE_AGATE then
		self.icon_gold:loadTexture("1629.png", ccui.TextureResType.plistType)
	end
	if self.isShowNum or singleGet then
		self.item:hiddleNum(false)
	end
	local activityExchangeMallRead = include("activityExchangeMallRead")
	local info = activityExchangeMallRead:getShopItemByItemID(self.targetID)
	if info and info.upperLimit == 1 then
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local ownCount = backpackCtrl:getItemGainRecordNum(self.targetID)
		curNum = math.max(1, math.min(curNum, info.limitnum - ownCount))
	end
	publicRead = math.max(1, math.min(curNum, info.limitnum - ownCount))
	math.max(1, math.min(curNum, info.limitnum - ownCount)).maxValue = curNum
	math.max(1, math.min(curNum, info.limitnum - ownCount)).minValue = 1
	math.max(1, math.min(curNum, info.limitnum - ownCount)).curValue = 1
	self.bagShopSlider:initData((math.max(1, math.min(curNum, info.limitnum - ownCount))))
	self:exChangeUpdate(1)
	self.bagShopSlider:setSliderCallBack(handler(self, self.exChangeUpdate))
end
function ShopSingleBuy:exChangeUpdate(exChangeCount)
	self.labelPay:setString(string.formatnumberthousands(self.singCount * math.floor(exChangeCount)))
	self.item.num:setString(string.formatnumberthousands(self.singleGet * math.floor(exChangeCount)))
	SoraDToCenter(self.Node_gold)
end
function ShopSingleBuy:checkEnoughGold(singCount, curNum)
	if not SoraDEnoughGold(singCount * curNum, true) then
		self.labelPay:setColor(display.COLOR_RED)
	else
		self.labelPay:setColor(display.COLOR_WHITE)
	end
end
function ShopSingleBuy:setExchangeHandler(handle)
	self.exchangeHandler = handle
end
function ShopSingleBuy:initData(itemData, otherData)
	self.tableItem = itemData
	self.canBuyMax = backpackltCtrl:getBuyMax(self.tableItem.id) or 9999
	local haveGold = lordInfoCtrl:getBaseInfo().gold
	if otherData and otherData.maxCount then
		self.canBuyMax = otherData.maxCount
	end
	if otherData and otherData.exchangeID then
		self.exchangeItemID = otherData.exchangeID
	end
	if otherData and otherData.curValue then
		self.curValue = otherData.curValue
	end
	backpackltCtrl = nil
	;(nil).itemID = self.tableItem.id
	;(nil).itemCount = otherData and otherData.itemCount
	self.item:initData(nil)
	if self.tableItem.originalPrice then
		backpackltCtrl = self.tableItem.originalPrice
		self.tableItem.originalPrice.max = self.tableItem.max
		self.limitData, self.tableItem.originalPrice.cur = self.tableItem.originalPrice, self.tableItem.cur
		self.Node_ori:setVisible(true)
		self.Node_gold:setVisible(false)
	else
		self.limitData = shopCtrl:getLimitDataByID(self.tableItem.shopItemID)
		self.Node_ori:setVisible(false)
		self.Node_gold:setVisible(true)
		if self.limitData and next(self.limitData) then
			local imageItemHead = self.item:getChildByName("Image_item")
			local imgCanBuy = ccui.ImageView:create("frame_recharge__sheer_time.png", ccui.TextureResType.plistType)
			imgCanBuy:setName("Image_canBuy")
			imgCanBuy:ignoreContentAdaptWithSize(false)
			imgCanBuy:setContentSize(cc.size(135, 26))
			imgCanBuy:setPosition(cc.p(imageItemHead:getContentSize().width / 2, 10))
			imgCanBuy:addTo(imageItemHead)
			backpackltCtrl = cc.p(imageItemHead:getContentSize().width / 2, 10)
			cc.p(imageItemHead:getContentSize().width / 2, 10).member = self.limitData.cur
			cc.p(imageItemHead:getContentSize().width / 2, 10).total = self.limitData.max
			local labelCanBuy = ccui.Text:create(i18n("common_text_155", cc.p(imageItemHead:getContentSize().width / 2, 10)), "", 20)
			labelCanBuy:setName("Text_canBuy")
			labelCanBuy:setPosition(cc.p(imgCanBuy:getContentSize().width / 2, imgCanBuy:getContentSize().height / 2 + 3))
			labelCanBuy:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
			labelCanBuy:addTo(imgCanBuy)
		end
	end
	if self.limitData then
		self.canBuyMax = math.min(self.canBuyMax, self.limitData.cur)
	end
	local itemCount = self.canBuyMax
	if self.exchangeItemID == gIDDef.GOLD then
		itemCount = math.min(self.canBuyMax, self:getMaxCanBuy())
	elseif self.exchangeItemID == gIDDef.JADE_STONE then
		self.oriIcon:loadTexture(self.exchangeItemID .. ".png", ccui.TextureResType.plistType)
	end
	if self.tableItem.upperLimit and self.tableItem.upperLimit == 1 then
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local ownCount = backpackCtrl:getItemGainRecordNum(self.tableItem.id)
		itemCount = math.max(1, math.min(self.canBuyMax, self.tableItem.limitNum - ownCount))
	end
	if self.curValue then
		self.curValue = math.min(self.curValue, itemCount)
	end
	backpackltCtrl = itemCount
	itemCount.maxValue = itemCount
	itemCount.minValue = 1
	itemCount.curValue = self.curValue or 1
	self.bagShopSlider:initData(itemCount)
	self:payGoldChange(self.curValue or 1)
	self.bagShopSlider:setSliderCallBack(handler(self, self.payGoldChange))
	self.labelName:setString(publicRead.getName(self.tableItem.id))
	self.labelDes:setString(publicRead.getDes(self.tableItem.id))
end
function ShopSingleBuy:initQuickBuyData(itemData, otherData)
	self.tableItem = itemData
	self.canBuyMax = math.floor(backpackltCtrl:getBuyMax(self.tableItem.id) / self.tableItem.number) or 9999
	local haveGold = lordInfoCtrl:getBaseInfo().gold
	if otherData and otherData.maxCount then
		self.canBuyMax = otherData.maxCount
	end
	if otherData and otherData.curValue then
		self.curValue = otherData.curValue
	end
	_ENV = self.tableItem.id
	self.tableItem.id.itemID = self.tableItem.id
	self.item:initData(self.tableItem.id)
	if self.tableItem.originalPrice then
		_ENV = self.tableItem.originalPrice
		self.tableItem.originalPrice.max = self.tableItem.max
		self.limitData, self.tableItem.originalPrice.cur = self.tableItem.originalPrice, self.tableItem.cur
		self.Node_ori:setVisible(true)
		self.Node_gold:setVisible(false)
	else
		self.limitData = shopCtrl:getLimitDataByID(self.tableItem.shopItemID)
		self.Node_ori:setVisible(false)
		self.Node_gold:setVisible(true)
		if self.limitData and next(self.limitData) then
			local imageItemHead = self.item:getChildByName("Image_item")
			local imgCanBuy = ccui.ImageView:create("frame_recharge__sheer_time.png", ccui.TextureResType.plistType)
			imgCanBuy:setName("Image_canBuy")
			imgCanBuy:ignoreContentAdaptWithSize(false)
			imgCanBuy:setContentSize(cc.size(135, 26))
			imgCanBuy:setPosition(cc.p(imageItemHead:getContentSize().width / 2, 10))
			imgCanBuy:addTo(imageItemHead)
			_ENV = cc.p(imageItemHead:getContentSize().width / 2, 10)
			cc.p(imageItemHead:getContentSize().width / 2, 10).member = self.limitData.cur
			cc.p(imageItemHead:getContentSize().width / 2, 10).total = self.limitData.max
			local labelCanBuy = ccui.Text:create(i18n("common_text_155", cc.p(imageItemHead:getContentSize().width / 2, 10)), "", 20)
			labelCanBuy:setName("Text_canBuy")
			labelCanBuy:setPosition(cc.p(imgCanBuy:getContentSize().width / 2, imgCanBuy:getContentSize().height / 2 + 3))
			labelCanBuy:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
			labelCanBuy:addTo(imgCanBuy)
		end
	end
	if self.limitData then
		self.canBuyMax = math.min(self.canBuyMax, self.limitData.cur)
	end
	local itemCount = math.min(self.canBuyMax, self:getMaxCanBuy())
	if self.curValue then
		self.curValue = math.min(self.curValue, itemCount)
	end
	if self.tableItem.upperLimit and self.tableItem.upperLimit == 1 then
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local ownCount = backpackCtrl:getItemGainRecordNum(self.tableItem.id)
		itemCount = math.max(1, math.min(self.canBuyMax, self.tableItem.limitNum - ownCount))
	end
	_ENV = math.max(1, math.min(self.canBuyMax, self.tableItem.limitNum - ownCount))
	math.max(1, math.min(self.canBuyMax, self.tableItem.limitNum - ownCount)).maxValue = itemCount
	math.max(1, math.min(self.canBuyMax, self.tableItem.limitNum - ownCount)).minValue = 1
	math.max(1, math.min(self.canBuyMax, self.tableItem.limitNum - ownCount)).curValue = self.curValue or 1
	self.bagShopSlider:initData((math.max(1, math.min(self.canBuyMax, self.tableItem.limitNum - ownCount))))
	self:payGoldChange(self.curValue or 1)
	self.bagShopSlider:setSliderCallBack(handler(self, self.payGoldChange))
	self.labelName:setString(itemDesRead.getName(self.tableItem.id))
	self.labelDes:setString(itemDesRead.getDes(self.tableItem.id))
end
function ShopSingleBuy:payGoldChange(needBuy)
	self.needBuy = needBuy
	local price = self.tableItem.price
	local totalPrice = self:getTotalPrice(needBuy)
	self.labelPay:setString(string.formatnumberthousands(totalPrice))
	SoraDToCenter(self.Node_gold)
	if self.tableItem.originalPrice and self.Node_ori:isVisible() then
		self.Text_curPay:setString(string.formatnumberthousands(self.needBuy * self.tableItem.price))
		self.Text_oriPay:setString(string.formatnumberthousands(self.needBuy * self.tableItem.originalPrice))
	end
	if self.exchangeItemID == gIDDef.GOLD then
		if SoraDEnoughGold(totalPrice, true) then
			self.labelPay:setColor(display.COLOR_WHITE)
			self.Text_curPay:setColor(display.COLOR_WHITE)
		else
			self.labelPay:setColor(display.COLOR_RED)
			self.Text_curPay:setColor(display.COLOR_RED)
		end
	elseif self.exchangeItemID == gIDDef.JADE_STONE then
		local treasureCourtCtrl = SoraDGetCtrl("treasureCourtCtrl")
		if treasureCourtCtrl:isEnoughStone(totalPrice, true) then
			self.labelPay:setColor(display.COLOR_WHITE)
			self.Text_curPay:setColor(display.COLOR_WHITE)
			self.btnBuy:setBright(true)
			self.btnBuy:setTouchEnabled(true)
		else
			self.labelPay:setColor(display.COLOR_RED)
			self.Text_curPay:setColor(display.COLOR_RED)
			self.btnBuy:setBright(false)
			self.btnBuy:setTouchEnabled(false)
		end
	end
	self:updateResNotice()
	self:showUseTotal()
	if self.useAndBuy then
		self:showUseNextPercent()
	end
end
function ShopSingleBuy:getTotalPrice(needBuy)
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
function ShopSingleBuy:getMaxCanBuy()
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
function ShopSingleBuy:endShow()
	if self.limitData and self.limitData.cur <= 0 then
		SoraDShowMsgTip(i18n("shop_text_17"), itemDesRead.getIcon(self.tableItem.id, true))
		self:removeFromParent()
	end
end
function ShopSingleBuy:setLimitShopText(str)
	self.labelResTotal:setString(str)
	self.labelResTotal:setVisible(true)
	if self.tableItem and self.tableItem.id == 833001 then
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local ticketCount = backpackCtrl:getItemCount(833001)
		self.labelResTotal = SoraDChangeTextToHtml(self.labelResTotal)
		local numColor = 0 < ticketCount and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0)
		_ENV = nil
		_ENV, _ENV, (nil).count = nil, nil, ticketCount
		;(nil).count, (nil).color = nil, numColor
		self.labelResTotal:setString(i18n_html("common_text_1377", nil, nil))
	end
end
function ShopSingleBuy:setBtnAndLabelPos()
	self.btnBuy:setPositionY(self.btnBuy:getPositionY() - 15)
	self.labelResTotal:setPositionY(self.labelResTotal:getPositionY() - 15)
end
function ShopSingleBuy:setLabelName(name)
	self.labelName:setString(name)
end
function ShopSingleBuy:hideBagShopSlider(...)
	self.bagShopSlider:setVisible(false)
end
return ShopSingleBuy
