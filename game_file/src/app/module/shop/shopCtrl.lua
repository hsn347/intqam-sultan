local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local msgCtrl = include("msgCtrl")
local msgNotice = include("msgNotice")
local itemLogic = include("itemLogic")
local dailyLimitShopItemMgr = include("dailyLimitShopItemMgr")
local dressShopltCtrl = include("dressShopltCtrl")
local dressShoppingCart = include("dressShoppingCart")
local dressltCtrl = include("dressltCtrl")
local limitTimeDSCtrl = include("limitTimeDSCtrl")
local shopCtrl = class("shopCtrl", gameModule)
function shopCtrl:ctor(properties)
	shopCtrl.super.ctor(self, properties)
	self.dressShoppingCart = dressShoppingCart.new()
	self.limitTimeDSCtrl = limitTimeDSCtrl.new()
end
function shopCtrl:reqBuyInItemShop(shopItemID, num, use, extra)
	_UPVALUE4_ = nil
	;(nil)[1] = shopItemID
	;(nil)[2] = num
	;(nil)[3] = use
	;(nil)[4] = extra
	dump(nil, "shopItemID, num, use, extra")
	if not gModuleMgr.sharedMgr("shopltCtrl"):isShopItemValid(shopItemID) then
		local msgNotice = include("msgNotice")
		msgNotice.notice("notice_0026")
		_ENV = "notice_0026"
		;("notice_0026").msg = "MESSAGE_MALL_ERR"
		SoraDSendMessage("notice_0026")
		return gErrDef.Err_SHOPITEM_IS_INVALID
	end
	_ENV = msgNotice
	include("msgNotice").shopItemID = shopItemID
	include("msgNotice").num = num
	include("msgNotice").use = use
	local include("msgNotice").extra, data = extra, include("msgNotice")
	serverproxy:Request(gCmd.CMD_SHOP_MODULE, gCmd.REQ_ITEM_SHOP_BUY, data)
	return gErrDef.Err_None
end
function shopCtrl:getShopItemByItemID(itemID)
	local _ENV, ret
	ret = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByItemID(itemID)
	if ret then
		local itemID = ret.itemId
		if not gModuleMgr.sharedMgr("shopltCtrl"):isShopItemValid(ret.shopItemID) then
			ret = nil
		end
		if not itemLogic.checkUseCond(itemID) then
			ret = nil
		end
	end
	return ret
end
function shopCtrl:getShopItemList()
	local _ENV, ret
	local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
	local shopltlist = gModuleMgr.sharedMgr("shopltCtrl"):getClassifyShopItemList()
	if shopltlist.resource then
		ret.resource, _ENV = shopltlist.resource, shopltlist.resource
		for i, v in ipairs(shopltlist.resource) do
			local shopItemID = v.shopItemID
			if gModuleMgr.sharedMgr("shopltCtrl"):isShopItemValid(shopItemID) then
				local itemID = v.itemId
				if itemLogic.checkUseCond(itemID) then
					table.insert(ret.resource, v)
				end
			end
		end
	end
	if shopltlist.battle then
		ret.battle, _ENV = shopltlist.battle, shopltlist.battle
		for i, v in ipairs(shopltlist.battle) do
			local shopItemID = v.shopItemID
			if gModuleMgr.sharedMgr("shopltCtrl"):isShopItemValid(shopItemID) then
				local itemID = v.itemId
				if itemLogic.checkUseCond(itemID) then
					table.insert(ret.battle, v)
				end
			end
		end
	end
	if shopltlist.gain then
		ret.gain, _ENV = shopltlist.gain, shopltlist.gain
		for i, v in ipairs(shopltlist.gain) do
			local shopItemID = v.shopItemID
			if gModuleMgr.sharedMgr("shopltCtrl"):isShopItemValid(shopItemID) then
				local itemID = v.itemId
				if itemLogic.checkUseCond(itemID) then
					table.insert(ret.gain, v)
				end
			end
		end
	end
	if shopltlist.other then
		ret.other, _ENV = shopltlist.other, shopltlist.other
		for i, v in ipairs(shopltlist.other) do
			local shopItemID = v.shopItemID
			if gModuleMgr.sharedMgr("shopltCtrl"):isShopItemValid(shopItemID) then
				local itemID = v.itemId
				if itemLogic.checkUseCond(itemID) then
					if SoraDGetKingdomLv() >= 52 and itemID == 837102 then
						table.insert(ret.other, v)
					end
					if SoraDGetKingdomLv() < 52 and itemID == 837101 then
						table.insert(ret.other, v)
					end
					if itemID ~= 837101 and itemID ~= 837102 then
						table.insert(ret.other, v)
					end
				end
			end
		end
	end
	return ret
end
function shopCtrl:reqInitData()
	serverproxy:Request(gCmd.CMD_SHOP_MODULE, gCmd.REQ_SHOP_INIT_DATA)
end
function shopCtrl:getLimitDataByID(shopItemID)
	if not gModuleMgr.sharedMgr("shopltCtrl"):isLimitShopItem(shopItemID) then
		return nil
	end
	local limit = gModuleMgr.sharedMgr("shopltCtrl"):getLimitNum(shopItemID)
	local buyCount = dailyLimitShopItemMgr:getBuyCount(shopItemID)
	local remainCount = limit - buyCount
	if remainCount < 0 then
		remainCount = 0
	end
	_ENV = shopItemID
	shopItemID.max = limit
	shopItemID.cur = remainCount
	shopItemID.buyCount = buyCount
	return shopItemID
end
function shopCtrl:initLimitBuyData(data)
	dailyLimitShopItemMgr:initialize(data)
end
function shopCtrl:initDressShop(data)
	local dressShopltCtrl, initData = nil, data or nil
	local configData = initData.configData
	dressShopltCtrl:initializeCustomConfig(configData)
	local cartData = initData.cartData
	self.dressShoppingCart:initialize(cartData)
end
function shopCtrl:initItemShop(data)
	local _ENV, initData = nil, data or nil
	local configData = initData.configData
	gModuleMgr.sharedMgr("shopltCtrl"):initializeCustomConfig(configData)
end
function shopCtrl:transferShopItemListFormat(shopItemList)
	local _ENV, ret
	for shopItemID, count in pairs(shopItemList) do
		_ENV = shopItemID
		ret[tostring(shopItemID)], shopItemID.count = shopItemID, count
	end
	return ret
end
function shopCtrl:getDressShopList()
	local castleSkinRead = include("castleSkinRead")
	_ENV = "castleSkinRead"
	;("castleSkinRead")[tonumber(gDressType.CASTLE)], _ENV = gDressType.CASTLE, gDressType.CASTLE
	;("castleSkinRead")[tonumber(gDressType.CASTLE_NAMEPLATE)], _ENV = gDressType.CASTLE_NAMEPLATE, gDressType.CASTLE_NAMEPLATE
	;("castleSkinRead")[tonumber(gDressType.MARCH)], _ENV = gDressType.MARCH, gDressType.MARCH
	;("castleSkinRead")[tonumber(gDressType.CHAT_TEXT_FRAME)], _ENV = gDressType.CHAT_TEXT_FRAME, gDressType.CHAT_TEXT_FRAME
	;("castleSkinRead")[tonumber(gDressType.CHAT_AVATAR_FRAME)], _ENV = gDressType.CHAT_AVATAR_FRAME, gDressType.CHAT_AVATAR_FRAME
	local ret = "castleSkinRead"
	local shopItemIDList = dressShopltCtrl:getShopItemIDList()
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local dressCtrl = gametop.playertop_:getModule("dressCtrl")
	local _ENV, saleSubMapTypeMap = gametop.playertop_, gametop.playertop_
	for i, shopItemID in ipairs(shopItemIDList) do
		if dressShopltCtrl:inSale(shopItemID) then
			local originalPrice = dressShopltCtrl:getOriginalPrice(shopItemID)
			local itemList = dressShopltCtrl:getResult(shopItemID)
			local itemID = itemList[1].id
			local dressID = gModuleMgr.sharedMgr("backpackltCtrl"):getResult(itemID)
			local dressType = dressltCtrl.getDressType(dressID)
			local topOrder = dressShopltCtrl:getShopItemTopOrder(shopItemID)
			local topOrderTime = dressShopltCtrl:getShopItemTopOrderTime(shopItemID)
			local hot = dressShopltCtrl:getShopItemHotMark(shopItemID)
			local isOwn = false
			local itemNum = backpackCtrl:getItemCount(itemID)
			if 0 < itemNum then
				isOwn = true
			else
				isOwn = dressCtrl:ownDress(dressID)
			end
			if dressType == gDressType.MARCH_SUIT then
				dressType = gDressType.MARCH
			end
			local dressTypeNum = tonumber(dressType)
			if not ret[dressTypeNum] then
				_ENV = ret[dressTypeNum]
			end
			ret[dressTypeNum] = ret[dressTypeNum]
			if not saleSubMapTypeMap[dressTypeNum] then
				_ENV = saleSubMapTypeMap[dressTypeNum]
			end
			saleSubMapTypeMap[dressTypeNum] = saleSubMapTypeMap[dressTypeNum]
			local inCart = self.dressShoppingCart:hasShopItem(shopItemID, 1)
			local subType = castleSkinRead.getSubType(dressID)
			_ENV = dressID
			dressID.shopItemID = shopItemID
			dressID.dressID = dressID
			dressID.gold = originalPrice
			dressID.itemID = itemID
			dressID.inSale = true
			dressID.inCart = inCart
			dressID.saleGold = nil
			dressID.saleTime = nil
			dressID.inDiscount = false
			dressID.isOwn = isOwn
			dressID.toTopOrder = topOrder
			dressID.topOrderTime = topOrderTime
			dressID.hot = hot
			dressID.inShop = true
			dressID.subType = subType
			local dressID.sortIndex, data = castleSkinRead.getSortIndex(subType), dressID
			if dressShopltCtrl:inDiscount(shopItemID) then
				data.saleGold = dressShopltCtrl:getDiscountPrice(shopItemID)
				local discountBeginTime = dressShopltCtrl:getDiscountBeginTime(shopItemID)
				local discountEndTime = dressShopltCtrl:getDiscountEndTime(shopItemID)
				local currentTime = serviceFunctions.systemTime()
				data.saleTime = discountEndTime - currentTime
				data.inDiscount = true
				local isOwn = false
				local itemNum = backpackCtrl:getItemCount(itemID)
				if 0 < itemNum then
					isOwn = true
				else
					isOwn = dressCtrl:ownDress(dressID)
				end
				data.isOwn = isOwn
			end
			local update = function()
				if dressShopltCtrl:inSale(shopItemID) then
					if dressShopltCtrl:inDiscount(shopItemID) then
						data.saleGold = dressShopltCtrl:getDiscountPrice(shopItemID)
						local discountBeginTime = dressShopltCtrl:getDiscountBeginTime(shopItemID)
						local discountEndTime = dressShopltCtrl:getDiscountEndTime(shopItemID)
						local currentTime = serviceFunctions.systemTime()
						data.saleTime = discountEndTime - currentTime
						data.inDiscount = true
					else
						data.saleGold = nil
						data.saleTime = nil
						data.inDiscount = false
					end
				else
					data.inSale = false
				end
			end
			data.update = update
			table.insert(ret[dressTypeNum], data)
			saleSubMapTypeMap[dressTypeNum][subType] = true
		end
	end
	if castleSkinRead then
		for subType, v in pairs(castleSkinRead.desData) do
			local dType = tonumber(v.dType)
			if saleSubMapTypeMap[dType] and not saleSubMapTypeMap[dType][subType] and v.isAvailable == 1 then
				if not ret[dType] then
					ret[dType], _ENV = ret[dType], ret[dType]
				end
				_ENV = ret[dType]
				ret[dType].subType = subType
				ret[dType].inShop = false
				local ret[dType].dressID, data = dressltCtrl.getFirstDressIDBySubType(subType), ret[dType]
				data.sortIndex = castleSkinRead.getSortIndex(subType)
				table.insert(ret[dType], data)
			end
		end
	end
	if next(ret) then
		local sortFun = function(l, r)
			return l.sortIndex < r.sortIndex
		end
		for _, v in pairs(ret) do
			table.sort(v, sortFun)
		end
	end
	return ret
end
function shopCtrl:getDressShoppingCartList()
	local data = self.dressShoppingCart:getShopItemData()
	local dressCount = 0
	local _ENV, ret
	for k, v in pairs(gDressType) do
		local t = tonumber(v)
		ret[t], _ENV = v, v
	end
	for shopItemIDStr, count in pairs(data) do
		local shopItemID = tonumber(shopItemIDStr)
		if dressShopltCtrl:inSale(shopItemID) then
			local showType = dressShopltCtrl:getShowType(shopItemID)
			if not ret[showType] then
				_ENV = ret[showType]
			end
			ret[showType] = ret[showType]
			local itemList = dressShopltCtrl:getResult(shopItemID)
			local itemID = itemList[1].id
			local dressID = gModuleMgr.sharedMgr("backpackltCtrl"):getResult(itemID)
			local price = dressShopltCtrl:getCurrentPrice(shopItemID)
			_ENV = dressShopltCtrl
			dressShopltCtrl.shopItemID = shopItemID
			dressShopltCtrl.dressID = dressID
			dressShopltCtrl.itemID = itemID
			local dressShopltCtrl.gold, data = price, dressShopltCtrl
			table.insert(ret[showType], data)
			dressCount = dressCount + 1
		end
	end
	return ret, dressCount
end
function shopCtrl:buyInDressShop(shopItemID, count, use, active)
	serverproxy = nil
	;(nil)[shopItemID] = count
	local list = self:transferShopItemListFormat(nil)
	serverproxy = self
	self.shopItemList = list
	self.use = use
	self.cart = false
	local self.active, data = active, self
	serverproxy:Request(gCmd.CMD_SHOP_MODULE, gCmd.REQ_DRESS_SHOP_BUY, data)
	return gErrDef.Err_None
end
function shopCtrl:buyInDressShoppingCart(shopItemList)
	local list = self:transferShopItemListFormat(shopItemList)
	serverproxy = self
	self.shopItemList = list
	self.use = false
	local self.cart, data = true, self
	serverproxy:Request(gCmd.CMD_SHOP_MODULE, gCmd.REQ_DRESS_SHOP_BUY, data)
	return gErrDef.Err_None
end
function shopCtrl:addToShoppingCart(shopItemID)
	if self.dressShoppingCart:hasShopItem(shopItemID) then
		return
	end
	self.dressShoppingCart:addShopItem(shopItemID)
	serverproxy = self.dressShoppingCart.addShopItem
	self.dressShoppingCart.addShopItem.shopItemID = shopItemID
	local self.dressShoppingCart.addShopItem.count, data = 1, self.dressShoppingCart.addShopItem
	serverproxy:Request(gCmd.CMD_SHOP_MODULE, gCmd.REQ_ADD_DRESS_SHOP_CART, data)
	return gErrDef.Err_None
end
function shopCtrl:hasSameSubTypeInCart(dressID)
	local castleSkinRead = include("castleSkinRead")
	local subType = castleSkinRead.getSubType(dressID)
	local cartData = self.dressShoppingCart:getShopItemData()
	for strItemID, count in pairs(cartData) do
		local itemList = dressShopltCtrl:getResult(tonumber(strItemID))
		local itemID = itemList[1].id
		local dressID2 = gModuleMgr.sharedMgr("backpackltCtrl"):getResult(itemID)
		local subType2 = castleSkinRead.getSubType(dressID2)
		if subType == subType2 then
			return true, tonumber(strItemID), count
		end
	end
	return false
end
function shopCtrl:removeFromShoppingCart(shopItemID)
	local ret = self.dressShoppingCart:removeShopItem(shopItemID)
	if gErrDef.Err_None ~= ret then
		return ret
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.shopItemID = shopItemID
	local gErrDef.Err_None.count, data = 1, gErrDef.Err_None
	serverproxy:Request(gCmd.CMD_SHOP_MODULE, gCmd.REQ_REMOVE_DRESS_SHOP_CART, data)
	return gErrDef.Err_None
end
function shopCtrl:getLimitTimeDSCtrl()
	return self.limitTimeDSCtrl
end
local _ENV, RSP = function(self)
	return self.limitTimeDSCtrl
end, function(self)
	return self.limitTimeDSCtrl
end
function RSP:initDataRsp(content)
	if content.err ~= gErrDef.Err_None then
	end
end
function RSP:buyInItemShopRsp(content)
	dump(content, "buyInItemShopRsp error", 5)
	if content.err ~= gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_MALL_ERR"
		SoraDSendMessage(gErrDef.Err_None)
		if content.err == gErrDef.Err_SHOP_LIMIT_BUY then
			SoraDShowMsgTip(i18n("common_text_4445"))
		end
	else
		local data = content.data
		local shopItemID = data.shopItemID
		local num = data.num
		if gModuleMgr.sharedMgr("shopltCtrl"):isLimitShopItem(shopItemID) then
			dailyLimitShopItemMgr:addShopItemBuyCount(shopItemID, num)
		end
		if data.use then
			local itemID = gModuleMgr.sharedMgr("shopltCtrl"):getResultID(shopItemID)
			local resultType = backpackltCtrl:getResultType(itemID)
			local iconType = gNoticeIconTypeDef.ICON_ITEM
			local itemNum = gModuleMgr.sharedMgr("shopltCtrl"):getResultNum(shopItemID)
			local itemType = backpackltCtrl:getItemType(itemID)
			if itemID == 299100 or itemID == 299101 or itemID == 299102 or itemID == 299103 or itemID == 299104 or itemID == 103001 or itemID == 103002 or itemID == 103003 then
				local itemList = content.rspdata.addItemInfo
				_ENV = i18n("common_text_4445")
				i18n("common_text_4445").isArray = true
				SoraDOpenGiftView(itemList, i18n("common_text_4445"))
				return
			end
			if itemType == gItemType.WAR_GEM then
				return
			end
			if resultType == gItemEffectDef.EMOJI_STAMP then
				local emojiIndex = content.data.extra.emojiIndex
				_ENV = i18n("common_text_4445")
				i18n("common_text_4445").byUID = true
				if not SoraDConfigGet("Game:worldMapEmojiSeal:emoji~table", i18n("common_text_4445")) then
					local _ENV, list = SoraDConfigGet("Game:worldMapEmojiSeal:emoji~table", i18n("common_text_4445")), SoraDConfigGet("Game:worldMapEmojiSeal:emoji~table", i18n("common_text_4445"))
				end
				local isExist = false
				for k, v in ipairs(list) do
					if v.emojiID == emojiIndex then
						isExist = true
						list[k].time = os.time()
						list[k].count = list[k].count + 1
						break
					end
				end
				if not isExist then
					_ENV = ipairs(list)
					ipairs(list).emojiID = emojiIndex
					ipairs(list).time = os.time()
					ipairs(list).count = 1
					table.insert(list, ipairs(list))
				end
				_ENV = os.time()
				os.time().byUID = true
				SoraDConfigSet("Game:worldMapEmojiSeal:emoji~table", list, (os.time()))
			end
			if backpackltCtrl:checkBuffStackingItem(itemID) then
				local result = backpackltCtrl:getResult(itemID)
				local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
				local second = buffltCtrl:getTime(result)
				local constantRead = include("constantRead")
				local buffStackingTime = constantRead.getConstValue("BUFF_STACKING_TIME", 86400)
				_ENV = i18n("common_text_4445")
				i18n("common_text_4445").itemID = itemID
				i18n("common_text_4445").time1 = SoraDConvertSecondToString(second)
				i18n("common_text_4445").time2 = SoraDConvertSecondToStringHour(buffStackingTime)
				msgNotice.notice("common_text_4911", i18n("common_text_4445"))
			else
				_ENV = buffltCtrl:getTime(result)
				buffltCtrl:getTime(result).itemID = itemID
				buffltCtrl:getTime(result).count = num * itemNum
				msgNotice.notice("notice_0116", buffltCtrl:getTime(result), iconType, itemID)
			end
			_ENV = "notice_0116"
			;("notice_0116").msg = "MESSAGE_MALL_SUCCESS"
			SoraDSendMessage("notice_0116")
		else
			local itemID = gModuleMgr.sharedMgr("shopltCtrl"):getResultID(shopItemID)
			local num = data.num
			local iconType = gNoticeIconTypeDef.ICON_ITEM
			local itemNum = gModuleMgr.sharedMgr("shopltCtrl"):getResultNum(shopItemID)
			if data.shopItemID == 1000261 then
				_ENV = "treasureChest_text_23"
				;("treasureChest_text_23").itemID = itemID
				;("treasureChest_text_23").count = num * itemNum
				msgNotice.notice(i18n("treasureChest_text_23"), "treasureChest_text_23", iconType, itemID)
			else
				_ENV = "treasureChest_text_23"
				;("treasureChest_text_23").itemID = itemID
				;("treasureChest_text_23").count = num * itemNum
				msgNotice.notice("notice_0116", "treasureChest_text_23", iconType, itemID)
			end
			local panel = SoraDCreatePanel("animationGainItem")
			_ENV = iconType
			iconType.itemID = itemID
			iconType.itemCount = num * itemNum
			panel:initData(iconType)
			panel:show()
			_ENV = panel
			panel.msg = "MESSAGE_MALL_BUY_SUCCESS"
			panel.shopItemID = shopItemID
			SoraDSendMessage(panel)
		end
	end
end
function RSP:buyInDressShopRsp(content)
	dump(content, "RSP.buyInDressShopRsp", 5)
	if content.err ~= gErrDef.Err_None then
	else
		local data = content.data
		local shopItemList = data.shopItemList
		local use = data.use
		local cart = data.cart
		local active = data.active
		if use then
			for k, v in pairs(shopItemList) do
				local itemData = dressShopltCtrl:getResult(tonumber(k))
				_ENV = tonumber(k)
				tonumber(k).itemID = itemData[1].id
				msgNotice.notice("notice_0053", tonumber(k))
			end
		else
			local _ENV, showItems = pairs(shopItemList)
			for k, v in pairs(shopItemList) do
				local itemData = dressShopltCtrl:getResult(tonumber(k))
				for i, itemSingle in ipairs(itemData) do
					showItems[itemSingle.id] = itemSingle.count
				end
			end
			SoraDMailGainItems(showItems)
		end
		if cart then
			for shopItemIDStr, v in pairs(shopItemList) do
				local shopItemID = tonumber(shopItemIDStr)
				self.dressShoppingCart:removeShopItem(shopItemID)
			end
		end
		if active then
		end
	end
	_ENV = data.shopItemList
	data.shopItemList.msg = "MESSAGE_ITEM_CASTLE_CART_CHANGE"
	SoraDSendMessage(data.shopItemList)
	_ENV = data.shopItemList
	data.shopItemList.msg = "MESSAGE_CASTLE_SKIN_CHANGE_NEW"
	SoraDSendMessage(data.shopItemList)
end
function RSP:addToDressShopCartBuyRsp(content)
	if content.err ~= gErrDef.Err_None then
	else
		local data = content.data
		local shopItemID = data.shopItemID
		local count = data.count
	end
	_ENV = data.shopItemID
	data.shopItemID.msg = "MESSAGE_ITEM_CASTLE_CART_CHANGE"
	data.shopItemID.shopItemID = shopItemID
	SoraDSendMessage(data.shopItemID)
end
function RSP:removeFromDressShopCartRsp(content)
	if content.err ~= gErrDef.Err_None then
	else
		local data = content.data
		local shopItemID = data.shopItemID
		local count = data.count
	end
	_ENV = data.shopItemID
	data.shopItemID.msg = "MESSAGE_ITEM_CASTLE_CART_CHANGE"
	data.shopItemID.isDelete = true
	data.shopItemID.shopItemID = shopItemID
	SoraDSendMessage(data.shopItemID)
end
function shopCtrl:updateDataRsp(event)
	local data = event.data
	for i, notifyMsg in ipairs(data) do
		local notifyType = notifyMsg.notifyType
		if "newDay" == notifyType then
			dailyLimitShopItemMgr:clean()
			_ENV = dailyLimitShopItemMgr
			dailyLimitShopItemMgr.msg = "MESSAGE_ITEM_DISCOUNT_BUY_BACK"
			SoraDSendMessage(dailyLimitShopItemMgr)
		elseif "updateDressConfig" == notifyType then
			local config = notifyMsg.config
			if config then
				local shopItemID = config.shopItemID
				dressShopltCtrl:setCustomShopItem(shopItemID, config)
			end
			_ENV = dressShopltCtrl.setCustomShopItem
			dressShopltCtrl.setCustomShopItem.msg = "MESSAGE_ITEM_CASTLE_DRESS_CHANGE"
			SoraDSendMessage(dressShopltCtrl.setCustomShopItem)
			_ENV = dressShopltCtrl.setCustomShopItem
			dressShopltCtrl.setCustomShopItem.msg = "MESSAGE_CASTLE_SKIN_CHANGE_NEW"
			SoraDSendMessage(dressShopltCtrl.setCustomShopItem)
		elseif "updateItemShopConfig" == notifyType then
			local shopItemID = notifyMsg.shopItemID
			local config = notifyMsg.config
			gModuleMgr.sharedMgr("shopltCtrl"):updateCustomConfig(shopItemID, config)
			_ENV = gModuleMgr.sharedMgr("shopltCtrl")
			gModuleMgr.sharedMgr("shopltCtrl").msg = "MESSAGE_ITEM_LIMITITEM_TIMEOUT_BACK"
			SoraDSendMessage((gModuleMgr.sharedMgr("shopltCtrl")))
		elseif "LTDS" == notifyType and notifyMsg.notifyData.config then
			self:getLimitTimeDSCtrl():updateConfig(notifyMsg.notifyData.config)
		end
	end
end
function shopCtrl:EnterGame()
	shopCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_SHOP_MODULE, gCmd.REQ_SHOP_INIT_DATA, handler(self, RSP.initDataRsp))
	msgCtrl.register(gCmd.CMD_SHOP_MODULE, gCmd.REQ_ITEM_SHOP_BUY, handler(self, RSP.buyInItemShopRsp))
	msgCtrl.register(gCmd.CMD_SHOP_MODULE, gCmd.REQ_DRESS_SHOP_BUY, handler(self, RSP.buyInDressShopRsp))
	msgCtrl.register(gCmd.CMD_SHOP_MODULE, gCmd.REQ_ADD_DRESS_SHOP_CART, handler(self, RSP.addToDressShopCartBuyRsp))
	msgCtrl.register(gCmd.CMD_SHOP_MODULE, gCmd.REQ_REMOVE_DRESS_SHOP_CART, handler(self, RSP.removeFromDressShopCartRsp))
	self:getLimitTimeDSCtrl():registerMsg()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.SHOP, handler(self, self.updateDataRsp))
	gModuleMgr.sharedMgr("shopltCtrl"):init()
end
function shopCtrl:resetData()
	dailyLimitShopItemMgr:destroy()
	self.dressShoppingCart:clean()
	dressShopltCtrl:destroy()
	gModuleMgr.sharedMgr("shopltCtrl"):release()
	self:getLimitTimeDSCtrl():destroy()
end
function shopCtrl:Logout()
	shopCtrl.super.Logout(self)
	self:resetData()
end
return shopCtrl
