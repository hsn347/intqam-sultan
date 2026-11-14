local itemDesRead = include("itemDesRead")
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local resDesRead = include("resDesRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local shopCtrl = gametop.playertop_:getModule("shopCtrl")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ShopSingleBuyPanel = class("ShopSingleBuyPanel", baseFguiPanel)
function ShopSingleBuyPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("ShopSingleBuyPanel:ctor", self.viewName)
end
function ShopSingleBuyPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ShopSingleBuy"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function ShopSingleBuyPanel:onInit()
	print("=======ShopSingleBuyPanel:onInit")
	self.view:fixChildrenPos()
	self.canBuyMax = 9999
	self.isInit = true
	self.limitData = nil
	self.tableItem = nil
	self.isShowNum = false
	self.labelDes = self.fields.Text_des
	self.labelName = self.fields.Text_name
	self.labNotice = self.fields.Text_notice
	self.labNotice:setVisible(false)
	self.btnBuy = self.fields.Button_Buy
	self.bagShopSlider = self.fields.Com_slider
	self.item = self.fields.Com_item
	self.labelResNotice = self.fields.Text_resNotice
	self.labelResNotice:setVisible(false)
	self.labelResTotal = self.fields.Text_resTotal
	self.labelResTotal:setVisible(false)
	self.needBuy = 0
	self.needResCount = nil
	self.exchangeItemID = gIDDef.GOLD
	self.btnBuy:addClickEventListener(handler(self, self.onBuy))
	SoraDAddMessage(self, "MESSAGE_ITEM_LIMITITEM_TIMEOUT_BACK", function(...)
		if self.tableItem and self.tableItem.shopItemID and shopltCtrl:isShopItemValid(self.tableItem.shopItemID) == nil then
			self:removeFromParent()
		end
	end)
end
function ShopSingleBuyPanel:onShow()
	print("=======ShopSingleBuyPanel:onShow")
	local param = self.param
	if self.param.inputFixFlag then
		self.fields.Com_slider:setInpuBoxFixPos()
	end
	if self.param.ownText then
		self:setOwnNumText()
	end
	if self.param.initData then
		self:initData(self.param.itemData, self.param.otherData)
		return
	end
	self:setIsShowNum(param.isShowNum)
	self:initExchangeData(param.targetID, param.exchangeID, param.singCount, param.curNum, param.huntCount, param.singleGet)
	self:setExchangeHandler(param.exchangeHandler)
	self:setBuyHandle(param.buyHandler)
end
function ShopSingleBuyPanel:setActionData(fromPos)
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
function ShopSingleBuyPanel:setBuyHandle(handle)
	self.buyHandle = handle
end
function ShopSingleBuyPanel:setIsShowNum(ret)
	self.isShowNum = ret
end
function ShopSingleBuyPanel:setIsHideUseTotal(ret)
	self.isHideUseTotal = ret
end
function ShopSingleBuyPanel:showUseTotal()
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
function ShopSingleBuyPanel:getCurNum(itemType)
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
function ShopSingleBuyPanel:showUseNextPercent()
	local itemType = backpackltCtrl:getItemType(self.tableItem.id)
	_UPVALUE2_ = backpackltCtrl
	backpackltCtrl[1] = gItemType.VIP_POINT
	local backpackltCtrl[2], showList = gItemType.S_VIP_POINT, backpackltCtrl
	if SoraDisInList(itemType, showList) then
		self.controllers.Ctrl_next:setSelectedIndex(1)
		local result = backpackltCtrl:getResult(self.tableItem.id)
		local singleNum = result[1].count
		local singleID = result[1].id
		local curCount = self.bagShopSlider:getSliderCurValue()
		local textCur = self.fields.Text_cur
		local textNext = self.fields.Text_next
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
	end
end
function ShopSingleBuyPanel:getUseResult(itemType, addPoint)
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
function ShopSingleBuyPanel:updateResNotice()
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
function ShopSingleBuyPanel:updateResNeed()
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
function ShopSingleBuyPanel:setNeedResCount(needResList)
	self.needResCount = needResList
	if self.needResCount then
		SoraDRemoveMessageFromTargetByName(self, "MESSAGE_RESOURCE_UPDATE")
		SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.refreshView))
		self:refreshView()
	end
end
function ShopSingleBuyPanel:refreshView()
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
			lordInfoCtrl = needValue
			needValue.maxValue = itemCount
			needValue.minValue = 1
			needValue.curValue = needValue
			self.bagShopSlider:initData(needValue)
			self.isInit = false
		end
		self:updateResNeed()
	end
end
function ShopSingleBuyPanel:onBuy(button, type)
	SoraDPlaySound()
	local sureBuy = function()
		if self.tableItem.originalPrice then
			include("limitTimeDiscountShopAPI"):buy(self.tableItem.shopItemID, self.needBuy)
		elseif not self.useAndBuy then
			shopCtrl:reqBuyInItemShop(self.tableItem.shopItemID, self.needBuy)
		else
			local itemLogic = include("itemLogic")
			local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
			local itemID = shopltCtrl:getResultID(self.tableItem.shopItemID)
			local isPass = itemLogic.checkResUseLowCastle(itemID, self.needBuy)
			local shopItemID = self.tableItem.shopItemID
			local needBuy = self.needBuy
			local buyItemID = self.tableItem.itemId
			if not isPass then
				self = nil
				;(nil).food = "500K"
				;(nil).wood = "500K"
				SoraDShowMsgBox(i18n("common_text_3500", nil), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
					if eventType == MSGBOX_CALLBACK_YES then
						_ENV = nil
						;(nil).needBuy = true
						if not itemLogic.checkItemSpecial(buyItemID, needBuy, nil) then
							shopCtrl:reqBuyInItemShop(shopItemID, needBuy, true)
						end
					end
				end)
			else
				self = i18n("common_text_185")
				i18n("common_text_185").needBuy = true
				if not itemLogic.checkItemSpecial(buyItemID, needBuy, (i18n("common_text_185"))) then
					shopCtrl:reqBuyInItemShop(shopItemID, needBuy, true)
				end
			end
		end
	end
	local needRemove = true
	if self.exchangeHandler then
		self.exchangeHandler(math.floor(self.bagShopSlider:getSliderCurValue()))
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
function ShopSingleBuyPanel:setUseAndBuy(bool)
	self.useAndBuy = bool
	self:updateResNotice()
end
function ShopSingleBuyPanel:initExchangeData(targetID, exchangeID, singCount, curNum, huntCount, singleGet)
	self.singCount = singCount
	self.singleGet = singleGet or 1
	self.labelName:setString(publicRead.getName(targetID))
	self.labelDes:setString(publicRead.getDes(targetID))
	self.item:initData(targetID, huntCount)
	if self.param.qualityIcon then
		self.item:setQualityIcon(self.param.qualityIcon)
	end
	self.fields.Button_Buy:setPrice(singCount * curNum)
	self.fields.Button_Buy:setItemID(exchangeID)
	print("targetID,exchangeID,singCount,curNum, huntCount,singleGet === ", targetID, exchangeID, singCount, curNum, huntCount, singleGet)
	if targetID == gIDDef.SIEVE or targetID == gIDDef.GIFT_ROLL then
		local resDesRead = include("resDesRead")
		self.labelName:setString(resDesRead.getName(targetID))
		self.labelDes:setString(resDesRead.getDes(targetID))
		self.fields.Button_Buy:setItemID(exchangeID)
	end
	if exchangeID == gIDDef.ALLIANCE_HUNTING_POINT and huntCount then
		self.item:setNum(huntCount)
	end
	self.exchangeItemID = exchangeID
	if exchangeID == gIDDef.PYRAMID_REGULAR_SCORE then
		self.fields.Button_Buy:setIcon("icon_regularSeason_point.png")
	elseif exchangeID == gIDDef.PYRAMID_PEAK_SCORE then
		self.fields.Button_Buy:setIcon("icon_peakSeason_point.png")
	elseif exchangeID == gIDDef.PURPLE_AGATE then
		self.fields.Button_Buy:setIcon("1629.png")
	end
	if self.isShowNum or singleGet then
	end
	publicRead = "1629.png"
	;("1629.png").maxValue = curNum
	;("1629.png").minValue = 1
	;("1629.png").curValue = 1
	self.bagShopSlider:initData("1629.png")
	self:exChangeUpdate(1)
	self.bagShopSlider:setSliderCallBack(handler(self, self.exChangeUpdate))
end
function ShopSingleBuyPanel:exChangeUpdate(exChangeCount)
	print("slkdjfslkdjfklsdjf", math.floor(exChangeCount))
	self.fields.Button_Buy:setPrice(self.singCount * math.floor(exChangeCount))
	self.item:setNum(self.singleGet * math.floor(exChangeCount))
	self:checkEnoughGold2(self.singCount, exChangeCount)
end
function ShopSingleBuyPanel:checkEnoughGold2(singCount, curNum)
	if not SoraDEnoughGold(singCount * curNum, true) then
		self.fields.Button_Buy:getController("Ctrl_status"):setSelectedIndex(1)
	else
		self.fields.Button_Buy:getController("Ctrl_status"):setSelectedIndex(0)
	end
	if self.exchangeItemID == gIDDef.MILITARY_EXPLOIT then
		local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
		if lordInfoCtrl:getLordInfo().militaryRankInfo.exploit >= singCount * curNum then
			self.btnBuy:setEnabled(true)
		else
			self.btnBuy:setEnabled(false)
		end
	end
end
function ShopSingleBuyPanel:checkEnoughGold(singCount, curNum)
	if not SoraDEnoughGold(singCount * curNum, true) then
		self.fields.Button_Buy:setTitleColor(display.COLOR_RED)
	else
		self.fields.Button_Buy:setTitleColor(display.COLOR_WHITE)
	end
end
function ShopSingleBuyPanel:setExchangeHandler(handle)
	self.exchangeHandler = handle
end
function ShopSingleBuyPanel:initData(itemData, otherData)
	self.tableItem = itemData
	self.canBuyMax = backpackltCtrl:getBuyMax(self.tableItem.id) or 9999
	local haveGold = lordInfoCtrl:getBaseInfo().gold
	if otherData and otherData.maxCount then
		self.canBuyMax = otherData.maxCount
	end
	if otherData and otherData.exchangeID then
		self.exchangeItemID = otherData.exchangeID
		self.fields.Button_Buy:setItemID(otherData.exchangeID)
	end
	if otherData and otherData.curValue then
		self.curValue = otherData.curValue
	end
	self.item:initData(self.tableItem.id, otherData and otherData.itemCount)
	if self.tableItem.originalPrice then
		backpackltCtrl = self.tableItem.originalPrice
		self.tableItem.originalPrice.max = self.tableItem.max
		self.limitData, self.tableItem.originalPrice.cur = self.tableItem.originalPrice, self.tableItem.cur
		self.fields.Button_Buy:setStyle(1)
	else
		print("sjdflksjdfkljsdlfk", self.tableItem.shopItemID)
		self.limitData = shopCtrl:getLimitDataByID(self.tableItem.shopItemID)
		dump(self.limitData, "slkjdflsdjflksd")
		self.fields.Button_Buy:setStyle(0)
		if self.limitData and next(self.limitData) then
			error("暂不处理")
		end
	end
	if self.limitData then
		self.canBuyMax = math.min(self.canBuyMax, self.limitData.cur)
	end
	local itemCount = self.canBuyMax
	if self.exchangeItemID == gIDDef.GOLD then
		itemCount = math.min(self.canBuyMax, self:getMaxCanBuy())
	elseif self.exchangeItemID == gIDDef.JADE_STONE then
		self.fields.Button_Buy:setIcon(self.exchangeItemID .. ".png")
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
function ShopSingleBuyPanel:initQuickBuyData(itemData, otherData)
	self.tableItem = itemData
	self.canBuyMax = math.floor(backpackltCtrl:getBuyMax(self.tableItem.id) / self.tableItem.number) or 9999
	local haveGold = lordInfoCtrl:getBaseInfo().gold
	if otherData and otherData.maxCount then
		self.canBuyMax = otherData.maxCount
	end
	if otherData and otherData.curValue then
		self.curValue = otherData.curValue
	end
	self.item:initData(self.tableItem.id)
	if self.tableItem.originalPrice then
		_ENV = self.tableItem.originalPrice
		self.tableItem.originalPrice.max = self.tableItem.max
		self.limitData, self.tableItem.originalPrice.cur = self.tableItem.originalPrice, self.tableItem.cur
		self.fields.Button_Buy:setStyle(1)
	else
		self.limitData = shopCtrl:getLimitDataByID(self.tableItem.shopItemID)
		self.fields.Button_Buy:setStyle(0)
		if self.limitData and next(self.limitData) then
			error("暂不处理")
		end
	end
	if self.limitData then
		self.canBuyMax = math.min(self.canBuyMax, self.limitData.cur)
	end
	local itemCount = math.min(self.canBuyMax, self:getMaxCanBuy())
	if self.curValue then
		self.curValue = math.min(self.curValue, itemCount)
	end
	_ENV = itemCount
	itemCount.maxValue = itemCount
	itemCount.minValue = 1
	itemCount.curValue = self.curValue or 1
	self.bagShopSlider:initData(itemCount)
	self:payGoldChange(self.curValue or 1)
	self.bagShopSlider:setSliderCallBack(handler(self, self.payGoldChange))
	self.labelName:setString(itemDesRead.getName(self.tableItem.id))
	self.labelDes:setString(itemDesRead.getDes(self.tableItem.id))
end
function ShopSingleBuyPanel:payGoldChange(needBuy)
	self.needBuy = needBuy
	local price = self.tableItem.price
	local totalPrice = self:getTotalPrice(needBuy)
	self.fields.Button_Buy:setPrice(totalPrice)
	if self.fields.Button_Buy:getStyle() == 1 then
		self.fields.Button_Buy:setPrice(self.needBuy * self.tableItem.price, self.needBuy * self.tableItem.originalPrice)
	end
	if self.exchangeItemID == gIDDef.GOLD then
		if SoraDEnoughGold(totalPrice, true) then
			self.fields.Button_Buy:setTitleColor(display.COLOR_WHITE)
		else
			self.fields.Button_Buy:setTitleColor(display.COLOR_RED)
		end
	elseif self.exchangeItemID == gIDDef.JADE_STONE then
		local treasureCourtCtrl = SoraDGetCtrl("treasureCourtCtrl")
		if treasureCourtCtrl:isEnoughStone(totalPrice, true) then
			self.fields.Button_Buy:setTitleColor(display.COLOR_WHITE)
			self.btnBuy:setBright(true)
			self.btnBuy:setTouchEnabled(true)
		else
			self.fields.Button_Buy:setTitleColor(display.COLOR_RED)
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
function ShopSingleBuyPanel:getTotalPrice(needBuy)
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
function ShopSingleBuyPanel:getMaxCanBuy()
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
function ShopSingleBuyPanel:endShow()
	if self.limitData and self.limitData.cur <= 0 then
		SoraDShowMsgTip(i18n("shop_text_17"), itemDesRead.getIcon(self.tableItem.id, true))
		self:removeFromParent()
	end
end
function ShopSingleBuyPanel:setLimitShopText(str)
	self.labelResTotal:setString(str)
	self.labelResTotal:setVisible(true)
	if self.tableItem and self.tableItem.id == 833001 then
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local ticketCount = backpackCtrl:getItemCount(833001)
		self.labelResTotal:setUBBEnabled(true)
		local numColor = 0 < ticketCount and "#FFFFFF" or "#FF0000"
		_ENV = nil
		;(nil).count = fguiHelper.getColorString(numColor, ticketCount)
		self.labelResTotal:setString(i18n("common_text_1377", nil))
	end
end
function ShopSingleBuyPanel:setOwnNumText()
	self.labelResTotal:setVisible(true)
	self.labelResTotal:setColor(cc.c3b(255, 255, 255))
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local ticketCount = backpackCtrl:getItemCount(self.param.targetID) or 10000
	self.labelResTotal:setUBBEnabled(true)
	local numColor = 0 < ticketCount and "#FFFFFF" or "#FF0000"
	_ENV = cc.c3b(255, 255, 255)
	cc.c3b(255, 255, 255).count = fguiHelper.getColorString(numColor, ticketCount)
	self.labelResTotal:setString(i18n("common_text_1377", cc.c3b(255, 255, 255)))
end
function ShopSingleBuyPanel:setBtnAndLabelPos()
	self.btnBuy:setPositionY(self.btnBuy:getPositionY() - 15)
	self.labelResTotal:setPositionY(self.labelResTotal:getPositionY() - 15)
end
function ShopSingleBuyPanel:onHide()
	print("=======ShopSingleBuyPanel:onHide")
end
function ShopSingleBuyPanel:onDispose()
	print("=======ShopSingleBuyPanel:onDispose")
	SoraDRemoveMessageByTarget(self)
	SoraDManagerRemoveTimerByTarget(self)
end
return ShopSingleBuyPanel
