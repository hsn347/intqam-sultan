local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local resDesRead = include("resDesRead")
local buildLogic = include("buildLogic")
local ResourceBuyView = class("resourceBuyView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("resourceBuyView")
	end
	return target
end)
function ResourceBuyView:ctor()
	self.resBtns, _ENV, self.isHideCurrentSceneView = nil, nil, true
	self.curBtn = nil
	self.needResCount = nil
	self.itemScroll = include("itemBuyScroll").new()
	self.spriteRes = SoraDGetChildByName(self, "Sprite_res")
	self.Text_totalRes = SoraDGetChildByName(self, "Text_totalRes")
	self.Text_notProtect = SoraDGetChildByName(self, "Text_notProtect")
	self.Text_protect = SoraDGetChildByName(self, "Text_protect")
	self.Text_protect_warehouse = SoraDGetChildByName(self, "Text_protect_warehouse")
	self.btnSafeRes = SoraDGetChildByName(self, "Button_safeRes")
	self.btnRes = SoraDGetChildByName(self, "Button_res")
	self.nodeTop = SoraDGetChildByName(self, "Top_Node")
	self.goldTop = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_resBuy")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_List")
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_resourceBuyView")
	self.Button_sort = SoraDGetChildByName(self, "Button_sort")
	self.Button_sort:setPressedActionEnabled(false)
	self.Text_curTotal = SoraDGetChildByName(self, "Text_curTotal")
	self.frame_arrow = SoraDGetChildByName(self, "frame_arrow")
	self.Text_sort = SoraDGetChildByName(self, "Text_sort")
	self.frame_arrow:setFlippedY(gIsResourceBuySort)
	if gIsResourceBuySort then
		self.Text_sort:setString(i18n("common_btn_03"))
	else
		self.Text_sort:setString(i18n("common_btn_04"))
	end
	self.windowTitle:setTitle(i18n("common_text_123"))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.btnSafeRes:addTouchEventListener(handler(self, self.btnSafeResClick))
	self.btnRes:addTouchEventListener(handler(self, self.btnResClick))
	self.Button_sort:addTouchEventListener(handler(self, self.btnSortClick))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.refreshRes))
	SoraDAddMessage(self, "MESSAGE_ITEM_UES_FROM_BAG_BACK", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.update))
end
function ResourceBuyView:initData(curIndex, needResList)
	curIndex = self:judgeLocked(curIndex)
	if needResList and next(needResList) then
		self.needResCount, _ENV = next(needResList), next(needResList)
		for k, v in pairs(needResList) do
			self.needResCount[v.resid] = v
		end
	end
	_UPVALUE5_ = (for generator)
	pairs(needResList)[1] = gIDDef.CRYSTAL
	pairs(needResList)[2] = gIDDef.MITHRIL
	pairs(needResList)[3] = gIDDef.IRON
	pairs(needResList)[4] = gIDDef.WOOD
	local pairs(needResList)[5], resIDList = gIDDef.FOOD, pairs(needResList)
	local _ENV, tableResNameList = gIDDef.CRYSTAL, gIDDef.CRYSTAL
	for _, v in pairs(resIDList) do
		if SoraDResIsLock(v) then
			table.insert(tableResNameList, v)
		end
	end
	local btnCount = #tableResNameList
	for i, v in pairs(tableResNameList) do
		local btn = self.btnRes:clone()
		btn:setPositionX(SoraDFSign(display.width / (btnCount * 2) * (1 + (i - 1) * 2)))
		local _width = (display.width + (btnCount - 1) * 6) / btnCount
		local _height = btn:getContentSize().height
		btn:setContentSize(cc.size(_width, _height))
		local text_des = btn:getChildByName("Text_res")
		text_des:setPositionX(btn:getContentSize().width / 2 - 20)
		if 4 < btnCount then
			text_des:setFontSize(16)
			text_des:setPositionX(btn:getContentSize().width / 2 - 24)
		else
			text_des:setPositionX(btn:getContentSize().width / 2 - 20)
		end
		local resImg = resDesRead.getIcon(v)
		local spRes = cc.Sprite:createWithSpriteFrameName(resImg)
		spRes:setPosition(display.width / btnCount - 35, btn:getContentSize().height / 2)
		spRes:addTo(btn)
		spRes:setScale(0.9)
		spRes:setName("Img_res")
		btn:addTo(self.nodeTop, -1)
		btn:setTag(v)
		table.insert(self.resBtns, btn)
	end
	self:refreshRes()
	self.btnRes:setVisible(false)
	for i, v in ipairs(tableResNameList) do
		if v == tonumber(curIndex) then
			self:btnResClick(self.resBtns[i], ccui.TouchEventType.ended, true)
		end
	end
end
function ResourceBuyView:judgeLocked(resid)
	if not SoraDResIsLock(resid) then
		return gIDDef.WOOD
	else
		return resid
	end
end
function ResourceBuyView:refreshRes()
	if not self.resBtns then
		return
	end
	for i, v in ipairs(self.resBtns) do
		local resID = v:getTag()
		local resCount = math.floor(cityCtrl:getResCount(resID))
		local resStr = SoraDConvertNumberWithUnit(math.floor(cityCtrl:getResCount(resID)))
		local textRes = v:getChildByName("Text_res")
		textRes:setString(resStr)
		if self.needResCount and self.needResCount[resID] and resCount < self.needResCount[resID].rescount then
			textRes:setColor(cc.c3b(255, 0, 0))
		elseif v == self.curBtn then
			textRes:setColor(cc.c3b(255, 255, 255))
		else
			textRes:setColor(cc.c3b(148, 148, 152))
		end
	end
end
function ResourceBuyView:update()
	SoraDCloseLoading(self)
	if self.curBtn then
		self:btnResClick(self.curBtn, ccui.TouchEventType.ended, true, true)
	end
end
function ResourceBuyView:sortResSingle(isUp)
	local singleArray = self.itemScroll:getSingleToShow()
	_ENV = self.itemScroll
	self.itemScroll[gItemType.SAFE_WOOD] = gIDDef.WOOD_SAFE
	self.itemScroll[gItemType.SAFE_FOOD] = gIDDef.FOOD_SAFE
	self.itemScroll[gItemType.SAFE_IRON] = gIDDef.IRON_SAFE
	self.itemScroll[gItemType.SAFE_SECRET] = gIDDef.MITHRIL_SAFE
	self.itemScroll[gItemType.SAFE_CRYSTAL] = gIDDef.CRYSTAL_SAFE
	local self.itemScroll[gItemType.SAFE_METEOR_CRYSTAL], safeList = gIDDef.METEOR_CRYSTAL_SAFE, self.itemScroll
	for i, v in ipairs(singleArray) do
		local own = backpackCtrl:getItemCount(v.info.iid)
		v.info.isOwn = 0 < own and 1 or 0
		local goodType = backpackltCtrl:getItemType(v.info.iid)
		local isSafe = false
		if safeList[goodType] then
			isSafe = true
		end
		v.info.isSafe = isSafe and 1 or 0
		local result = backpackltCtrl:getResult(v.info.iid)
		local value = result[1].count
		v.info.value = value
	end
	if isUp then
		table.sort(singleArray, function(a, b)
			local ret
			if a.info.isOwn == b.info.isOwn then
				if a.info.isSafe == b.info.isSafe then
					ret = a.info.value < b.info.value
				else
					ret = a.info.isSafe < b.info.isSafe
				end
			else
				ret = a.info.isOwn > b.info.isOwn
			end
			return ret
		end)
	else
		table.sort(singleArray, function(a, b)
			local ret
			if a.info.isOwn == b.info.isOwn then
				if a.info.isSafe == b.info.isSafe then
					ret = a.info.value > b.info.value
				else
					ret = a.info.isSafe < b.info.isSafe
				end
			else
				ret = a.info.isOwn > b.info.isOwn
			end
			return ret
		end)
	end
	self.itemScroll:setSingleToShow(singleArray)
	self.itemScroll:setPos()
end
function ResourceBuyView:btnSortClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		gIsResourceBuySort = not gIsResourceBuySort
		self.frame_arrow:setFlippedY(gIsResourceBuySort)
		if gIsResourceBuySort then
			self.Text_sort:setString(i18n("common_btn_03"))
		else
			self.Text_sort:setString(i18n("common_btn_04"))
		end
		self:sortResSingle(gIsResourceBuySort)
	end
end
function ResourceBuyView:btnResClick(button, type, notSound, notJump)
	if type == ccui.TouchEventType.ended then
		if not notSound then
			SoraDPlaySound()
		end
		for i, v in ipairs(self.resBtns) do
			if v ~= button then
				v:setBright(false)
				v:setTouchEnabled(true)
				v:getChildByName("Text_res"):setColor(cc.c3b(148, 148, 152))
				v:getChildByName("Img_res"):setColor(cc.c3b(148, 148, 152))
			else
				v:setBright(true)
				v:setTouchEnabled(false)
				v:getChildByName("Text_res"):setColor(cc.c3b(255, 255, 255))
				v:getChildByName("Img_res"):setColor(cc.c3b(255, 255, 255))
				local curResID = button:getTag()
				local resList = resDesRead.getItemList(curResID, true)
				_ENV = curResID
				curResID.itemList = resList
				curResID.itemCallBack = handler(self, self.buyOrUseCallBack)
				curResID.itemStyle = "commonItemUseBar_02"
				local curResID.itemSize, transTbl = cc.size(630, 170), curResID
				self.itemScroll:setScroll(self.scroll)
				self.itemScroll:init(transTbl)
				self:sortResSingle(gIsResourceBuySort)
			end
			if self.needResCount and self.needResCount[v:getTag()] then
				local resCount = math.floor(cityCtrl:getResCount(v:getTag()))
				if resCount < self.needResCount[v:getTag()].rescount then
					v:getChildByName("Text_res"):setColor(cc.c3b(255, 0, 0))
				else
					v:getChildByName("Text_res"):setColor(cc.c3b(255, 255, 255))
				end
			end
		end
		self.curBtn = button
		self:updateResInfo(self.curBtn:getTag())
		if not notJump then
			self.scroll:jumpToTop()
		end
	end
end
function ResourceBuyView:updateResInfo(resID)
	local resCount = math.floor(cityCtrl:getResCount(resID))
	local safeNum = math.floor(cityCtrl:getSafeRes(resID))
	local wareHouseNum = math.floor(cityCtrl:getResCapacityByResID(resID))
	local ret = buildLogic.getWarehouseProtectCount()
	local wareHouseBuff = ret[tostring(resID)] and ret[tostring(resID)].add or 0
	self.spriteRes:setSpriteFrame(resDesRead.getTreasureIcon(resID))
	self.spriteRes:stopAllActions()
	self.spriteRes:setPositionY(-195)
	cityCtrl = self.spriteRes
	self.spriteRes[1] = cca.moveBy(0.6666666666666666, 0, 5)
	self.spriteRes[2] = cca.moveBy(0.9166666666666666, 0, -5)
	self.spriteRes[3] = cca.moveBy(0.9166666666666666, 0, -5)
	self.spriteRes[4] = cca.moveBy(0.9166666666666666, 0, -5)
	self.spriteRes[5] = cca.moveBy(0.9166666666666666, 0, -5)
	self.spriteRes[6] = cca.moveBy(0.9166666666666666, 0, -5)
	self.spriteRes[7] = cca.moveBy(0.9166666666666666, 0, -5)
	self.spriteRes[8] = cca.moveBy(0.9166666666666666, 0, -5)
	self.spriteRes[9] = cca.moveBy(0.9166666666666666, 0, -5)
	self.spriteRes[10] = cca.moveBy(0.9166666666666666, 0, -5)
	self.spriteRes[11] = cca.moveBy(0.9166666666666666, 0, -5)
	self.spriteRes[12] = cca.moveBy(0.9166666666666666, 0, -5)
	local seq = cca.seq(self.spriteRes)
	self.spriteRes:runAction(cc.RepeatForever:create(seq))
	_ENV = cc.RepeatForever:create(seq)
	cc.RepeatForever:create(seq).num = SoraDConvertNumberWithUnit(resCount)
	self.Text_totalRes:setString(i18n("common_text_4313", cc.RepeatForever:create(seq)))
	local notProtectNum = math.max(0, math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff))
	_ENV = math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)
	math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff).num = SoraDConvertNumberWithUnit(notProtectNum)
	self.Text_notProtect:setString(i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)))
	_ENV = i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff))
	i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)).num = SoraDConvertNumberWithUnit(safeNum)
	self.Text_protect:setString(i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff))))
	local realWarehouseNum = math.min(wareHouseNum + wareHouseBuff, resCount - safeNum)
	_ENV = i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)))
	i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff))).num = SoraDConvertNumberWithUnit(realWarehouseNum)
	self.Text_protect_warehouse:setString(i18n("common_text_4315", i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)))))
	local resList = resDesRead.getItemList(resID, true)
	local totalToolNum = 0
	for k, v in pairs(resList) do
		local ownNum = backpackCtrl:getItemCount(v)
		local result = backpackltCtrl:getResult(v)
		local singleNum = result[1].count
		totalToolNum = totalToolNum + singleNum * ownNum
	end
	_ENV = i18n("common_text_4315", i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff))))
	i18n("common_text_4315", i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)))).resource = resDesRead.getName(resID)
	i18n("common_text_4315", i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff)))).num = SoraDConvertNumberWithUnit(totalToolNum)
	self.Text_curTotal:setString(i18n("common_text_4326", i18n("common_text_4315", i18n("common_text_2214", i18n("common_text_4316", math.floor(resCount - safeNum - wareHouseNum - wareHouseBuff))))))
end
function ResourceBuyView:buyOrUseCallBack(controlTbl)
	local buyItem = function(itemID)
		local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByItemID(itemID)
		if itemInfo then
			_ENV = nil
			;(nil).itemData = itemInfo
			;(nil).useAndBuy = true
			;(nil).needResList = self.needResCount
			uiManager:show("newShopSingleBuy", nil)
		else
			SoraDShowMsgTip(i18n("notice_0170"))
		end
	end
	if controlTbl.buy then
		if SoraDEnoughGold(controlTbl.needGold) then
			buyItem(controlTbl.itemID)
		end
	elseif controlTbl.use then
		_ENV = nil
		;(nil).needResList = self.needResCount
		include("itemLogic").useItemsLine(controlTbl.itemID, controlTbl.itemCount, nil)
	end
end
function ResourceBuyView:btnSafeResClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("common_text_4317"))
	end
end
return ResourceBuyView
