local GameModule = include("GameModule")
local shoppingCartCtrl = class("shoppingCartCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function shoppingCartCtrl:ctor(properties)
	shoppingCartCtrl.super.ctor(self, properties)
	self:resetData()
end
function shoppingCartCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SHOPPING_CART_MODULE, gCmd.REQ_SHOPPING_CART_ADD_RID, handler(self, self.addShopingCartRsp))
	msgCtrl.register(gCmd.CMD_SHOPPING_CART_MODULE, gCmd.REQ_SHOPPING_CART_REMOVE_RID, handler(self, self.removeShopingCartRsp))
	msgCtrl.register(gCmd.CMD_SHOPPING_CART_MODULE, gCmd.REQ_SHOPPING_CART_QUERY_PACKAGE_INFO, handler(self, self.queryCartPacakgeRsp))
end
function shoppingCartCtrl:Logout()
	shoppingCartCtrl.super.Logout(self)
	self:resetData()
end
function shoppingCartCtrl:resetData()
	self.packageData, _UPVALUE0_, self.cartData, _UPVALUE0_ = nil, nil, nil, nil
	self.isValid = false
end
function shoppingCartCtrl:initClientData(data)
	dump(data, "shoppingCartCtrl:initClientData=====", 10)
	if data and data.cartData then
		self.cartData = data.cartData
		self.isValid = data.isValid
	end
end
function shoppingCartCtrl:isValidUse()
	return self.isValid
end
function shoppingCartCtrl:getShoppingCartInfo()
	return self.cartData
end
function shoppingCartCtrl:isInShoppingCart(rid)
	return self.cartData[tostring(rid)]
end
function shoppingCartCtrl:getPackageDataInfo()
	return self.packageData
end
function shoppingCartCtrl:getUsefulData()
	local _ENV, giftDetail
	local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
	local luckyGiftCtrl = SoraDGetCtrl("luckyGiftCtrl")
	local privilegeGiftCtrl = SoraDGetCtrl("privilegeGiftCtrl")
	local ladderGiftCtrl = SoraDGetCtrl("ladderGiftCtrl")
	local rechargeRead = include("rechargeRead")
	local privilegeGiftRead = include("privilegeGiftRead")
	local packageData = self:getPackageDataInfo()
	for k, v in pairs(packageData) do
		local _ENV, ret
		if 0 < #v then
			local showV = v[1]
			local isInvalid = true
			local localGift
			local leftBuy = 0
			for ki, vi in ipairs(v) do
				local buyType = rechargeRead.getGiftBuyType(vi.ID)
				if buyType == gBuyType.LUCKY_BAG then
					localGift = luckyGiftCtrl:getLuckyGift(vi.ID)
				else
					localGift = rechargeActivityCtrl:getRechargeActivityData(vi.ID)
				end
				if localGift then
					showV = v[ki]
					isInvalid = false
					break
				end
			end
			local giftID = tonumber(showV.ID)
			ret.id = giftID
			local pageData = rechargeRead.getPageViewData(giftID)
			ret.name = i18n(pageData.activeName)
			if showV.gift then
				if type(showV.gift) == "string" then
					ret.rewards = SoraDArrary2Table(showV.gift)
				elseif type(showV.gift) == "table" then
					_UPVALUE2_ = nil
					;(nil)[1] = "id"
					;(nil)[2] = "num"
					ret.rewards = serviceFunctions.tableFormat(showV.gift, nil)
				end
			end
			if showV.rewards then
				_UPVALUE2_ = nil
				;(nil)[1] = "id"
				;(nil)[2] = "num"
				ret.rewards = serviceFunctions.tableFormat(v.rewards, nil)
			end
			if 0 < showV.gold then
				_ENV = "id"
				;("id").id = 1001
				;("id").num = showV.gold
				table.insert(ret.rewards, 1, "id")
			end
			ret.price = showV.price
			local ladderData = ladderGiftCtrl:getLadderDataByID(giftID)
			if localGift then
				ret.leftTime = rechargeActivityCtrl:queryQueue(giftID).timerNode.timer:getRemainTime()
				leftBuy = 1
			elseif ladderData and next(ladderData) then
				ret.leftTime = ladderData.leftTime
				leftBuy = 1
			else
				ret.leftTime = (tonumber(showV.endtime) or 0) - serviceFunctions.systemTime()
				leftBuy = 0
			end
			ret.leftBuy = leftBuy
			ret.maxBuy = 1
			if 0 >= ret.leftTime then
				isInvalid = true
			end
			ret.isInvalid = isInvalid
			local giftStyle = rechargeRead.getPageViewData(giftID)
			ret.hideTime = giftStyle.hideTime
		else
			local giftID = tonumber(k)
			local leftBuy = 0
			ret.id = giftID
			local pageData = rechargeRead.getPageViewData(giftID)
			if pageData then
				ret.name = i18n(pageData.activeName)
			else
				local extraData = gModuleMgr.sharedMgr("rechargeExtraltCtrl"):saveLanguageData(v)
				ret.name = i18n(extraData.activeName)
			end
			if v.gift then
				if type(v.gift) == "string" then
					ret.rewards = SoraDArrary2Table(v.gift)
				elseif type(v.gift) == "table" then
					_UPVALUE2_ = extraData.activeName
					extraData.activeName[1] = "id"
					extraData.activeName[2] = "num"
					ret.rewards = serviceFunctions.tableFormat(v.gift, extraData.activeName)
				end
			end
			if v.rewards then
				_UPVALUE2_ = extraData.activeName
				extraData.activeName[1] = "id"
				extraData.activeName[2] = "num"
				ret.rewards = serviceFunctions.tableFormat(v.rewards, extraData.activeName)
			end
			if 0 < v.gold then
				_ENV = "id"
				;("id").id = 1001
				;("id").num = v.gold
				table.insert(ret.rewards, 1, "id")
			end
			ret.price = v.price
			local maxBuy = v.payType and v.payType == 3 and 1 or tonumber(v.extraData) or 1
			ret.maxBuy = maxBuy
			ret.leftTime = (tonumber(v.endtime) or 0) - serviceFunctions.systemTime()
			ret.isValidNow = v.isValidNow
			if v.privilegeType then
				local recordData = privilegeGiftCtrl:isBought(giftID)
				if recordData then
					ret.isInvalid = true
					leftBuy = 0
				else
					leftBuy = 1
					if paymentManager.judgeGiftExclusive(giftID) then
						ret.isInvalid = false
					else
						ret.isInvalid = true
					end
				end
				ret.leftBuy = leftBuy
			else
				local giftStyle = rechargeRead.getPageViewData(giftID)
				local localData
				if giftStyle then
					local giftType = giftStyle.activeModelType
					if gRechargeActiveModelType.NORMAL == giftType or giftType == gRechargeActiveModelType.PETRA_GIFT or giftType == gRechargeActiveModelType.LINGLANG_GIFT then
						localData = rechargeActivityCtrl:getRechargeActivityData(giftID)
						if localData then
							ret.leftTime = rechargeActivityCtrl:queryQueue(giftID).timerNode.timer:getRemainTime()
							leftBuy = localData.extraData and tonumber(localData.extraData) or -1
						else
							ret.leftTime = 0
							ret.hideTime = 1
							leftBuy = v.extraData and tonumber(v.extraData) or -1
						end
					elseif gRechargeActiveModelType.RUIRUILADDER == giftType then
						localData = ladderGiftCtrl:getLadderDataByID(giftID)
						if localData then
							ret.leftTime = localData.leftTime
							leftBuy = 1
						else
							ret.leftTime = 0
							ret.hideTime = 1
							leftBuy = v.extraData and tonumber(v.extraData) or -1
						end
					elseif gRechargeActiveModelType.LUCKYGIFT == giftType then
						localData = luckyGiftCtrl:getLuckyGift(giftID)
						if localData then
							ret.leftTime = localData.lastTime
							leftBuy = 1
						else
							ret.leftTime = 0
							ret.hideTime = 1
							leftBuy = v.extraData and tonumber(v.extraData) or -1
						end
					end
					ret.hideTime = giftStyle.hideTime
				else
					ret.hideTime = 1
					ret.leftTime = 0
					leftBuy = v.extraData and tonumber(v.extraData) or -1
				end
				ret.leftBuy = leftBuy
				if localData and ret.leftBuy and ret.leftBuy ~= 0 then
					ret.isInvalid = false
				else
					ret.isInvalid = true
				end
			end
		end
		ret.privilegeType = v.privilegeType
		ret.payType = v.payType
		if ret.leftTime and 0 >= ret.leftTime and v.payType and v.payType ~= 3 then
			ret.isInvalid = true
		end
		table.insert(giftDetail, ret)
	end
	for k, v in ipairs(giftDetail) do
		for ki, vi in ipairs(v.rewards) do
			vi.index = ki
		end
	end
	return giftDetail
end
function shoppingCartCtrl:reqAddShoppingCart(rid)
	serverproxy = nil
	;(nil).rid = rid
	serverproxy:Request(gCmd.CMD_SHOPPING_CART_MODULE, gCmd.REQ_SHOPPING_CART_ADD_RID, nil)
end
function shoppingCartCtrl:reqRemoveShoppingCart(ridList)
	for k, v in pairs(self.packageData) do
		if 0 < #v then
			for i, val in ipairs(v) do
				for j, rid in ipairs(ridList) do
					if rid == tonumber(val.ID) then
						ridList[j] = tonumber(k)
					end
				end
			end
		end
	end
	_ENV = nil
	;(nil).ridList = ridList
	serverproxy:Request(gCmd.CMD_SHOPPING_CART_MODULE, gCmd.REQ_SHOPPING_CART_REMOVE_RID, nil)
end
function shoppingCartCtrl:reqShoppingCartInfo(ridList)
	serverproxy = nil
	;(nil).ridList = ridList
	serverproxy:Request(gCmd.CMD_SHOPPING_CART_MODULE, gCmd.REQ_SHOPPING_CART_QUERY_PACKAGE_INFO, nil)
end
function shoppingCartCtrl:addShopingCartRsp(content)
	if content.err == gErrDef.Err_None then
		self.cartData = content.rspdata.cartData
		SoraDShowMsgTip(i18n("shopping_text_01"))
	end
	_ENV = i18n("shopping_text_01")
	i18n("shopping_text_01").msg = "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART"
	SoraDSendMessage(i18n("shopping_text_01"))
end
function shoppingCartCtrl:removeShopingCartRsp(content)
	if content.err == gErrDef.Err_None then
		self.cartData = content.rspdata.cartData
		SoraDShowMsgTip(i18n("shopping_text_11"))
		local ridList = content.data.ridList
		for k, v in pairs(self.packageData) do
			for ki, vi in ipairs(ridList) do
				if tonumber(k) == vi then
					self.packageData[k] = nil
				end
			end
		end
	end
	_ENV = pairs(self.packageData)
	pairs(self.packageData).msg = "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART"
	pairs(self.packageData).isRemove = true
	SoraDSendMessage(pairs(self.packageData))
end
function shoppingCartCtrl:queryCartPacakgeRsp(content)
	if content.err == gErrDef.Err_None then
		self.packageData = content.rspdata.packageInfo
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART_DATA"
	SoraDSendMessage(gErrDef.Err_None)
end
return shoppingCartCtrl
