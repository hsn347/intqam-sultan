local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local castleSkinRead = include("castleSkinRead")
local dressltCtrl = include("dressltCtrl")
local dressMgr = include("dressMgr")
local dressCtrl = class("dressCtrl", gameModule)
local _ENV, REQ = "dressCtrl", "dressCtrl"
local _ENV, RSP = gameModule, gameModule
function dressCtrl:initClientData(data)
	self.dressMgr:loadInitData(data)
	if not data.receviedIllustrateStage then
		gametop = data.receviedIllustrateStage
	end
	self.receviedIllustrateStage = data.receviedIllustrateStage
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.DRESS, handler(self, RSP.noitfyDataRsp))
end
function dressCtrl:getPermanentCastleDressNum()
	return self.dressMgr:getPermanentCastleDressNum()
end
function dressCtrl:isStageAwardGot(stage)
	return self.receviedIllustrateStage[tostring(stage)] and self.receviedIllustrateStage[tostring(stage)] == 1
end
function dressCtrl:getTaskList()
	local totalHaveCastleSkin = self:getPermanentCastleDressNum()
	local _ENV, retList = self, self
	for i, v in ipairs(castleSkinRead.getIllustratedConfig()) do
		if self:isStageAwardGot(v.stage) then
			v.status = gBtnTargetStatusDef.GOT
		elseif totalHaveCastleSkin >= v.skin_quantity then
			v.status = gBtnTargetStatusDef.GET
		else
			v.status = gBtnTargetStatusDef.GO
		end
		table.insert(retList, v)
	end
	table.sort(retList, function(l, r)
		if l.status ~= r.status then
			return l.status < r.status
		else
			return l.stage < r.stage
		end
	end)
	return retList
end
function dressCtrl:getLastCanGet()
	local list = castleSkinRead.getIllustratedConfig()
	local lastStage
	local num = 0
	local firstNotGetStage
	local totalHaveCastleSkin = self:getPermanentCastleDressNum()
	for i, v in ipairs(list) do
		if totalHaveCastleSkin >= v.skin_quantity and not self:isStageAwardGot(v.stage) then
			num = num + 1
			if not lastStage or lastStage and lastStage < v.stage then
				lastStage = v.stage
			end
		end
		if not self:isStageAwardGot(v.stage) and not firstNotGetStage then
			firstNotGetStage = v.stage
		end
	end
	lastStage = lastStage or firstNotGetStage or list[#list].stage
	return num, lastStage
end
function dressCtrl:getCurDressID(dressType)
	local ret, dressUnit = self.dressMgr:getDressOfSetting(dressType)
	if gErrDef.Err_None ~= ret then
		return
	end
	local dressID = dressUnit:getDressID()
	return dressID
end
function dressCtrl:getDressOfCastle()
	return self:getCurDressID(gDressType.CASTLE)
end
function dressCtrl:isDressOpened(id)
	local ret = false
	if self.dressShowInfo.opendActivitys and self.dressShowInfo.opendActivitys[tostring(id)] then
		ret = true
	end
	if self.dressShowInfo.opendGifts and self.dressShowInfo.opendGifts[tostring(id)] then
		ret = true
	end
	return ret
end
function dressCtrl:isDressKWOpened()
	return self.dressShowInfo.ifKWOpened
end
function dressCtrl:filterSpecailDress(dressID)
	if castleSkinRead.isSpecailCastel(dressID) then
		return false
	elseif dressID ~= 9002100 then
		return true
	end
	return false
end
function dressCtrl:getIllustratedCastle()
	local dressltCtrl, retList
	local dresslist = dressltCtrl.getForeverCastleDress()
	dump(dresslist, "dresslist", 10)
	for i, v in ipairs(dresslist) do
		print("getIllustratedCastle", v.dressID, self:filterSpecailDress(v.dressID))
		if self:filterSpecailDress(v.dressID) then
			v.active = self:isCurrentSetting(v.dressID)
			local ret, _ = self.dressMgr:getDress(v.dressID)
			if gErrDef.Err_None == ret then
				v.isOwn = true
			else
				v.isOwn = false
			end
			table.insert(retList, v)
		end
	end
	return retList
end
function dressCtrl:getItemListOfCastleDress()
	local _ENV, ret
	local list = gModuleMgr.sharedMgr("backpackltCtrl"):getItemListByType(gItemEffectDef.DRESS)
	local itemLogic = include("itemLogic")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
	local _ENV, subType_dressID = "shopltCtrl", "shopltCtrl"
	for i, itemID in ipairs(list) do
		local dressID = gModuleMgr.sharedMgr("backpackltCtrl"):getResult(itemID)
		if gDressType.CASTLE == dressltCtrl.getDressType(dressID) then
			local subType = dressltCtrl.getSubType(dressID)
			if not subType_dressID[subType] then
				subType_dressID[subType] = dressID
			end
			local time = dressltCtrl.getDressLifetime(dressID)
			if itemLogic.checkLordLevelCond(itemID) and itemLogic.checkCastleLevelCond(itemID) then
				local itemNum = backpackCtrl:getItemCount(itemID)
				if 0 < itemNum then
					local key = subType_dressID[subType]
					if not ret[key] then
						_ENV = ret[key]
					end
					ret[key] = ret[key]
					_ENV = nil
					;(nil).id = itemID
					;(nil).count = itemNum
					;(nil).time = time
					;(nil).dressID = dressID
					table.insert(ret[key], nil)
				else
					local shopItem = shopltCtrl:getShopItemByItemID(itemID)
					if shopItem and shopltCtrl:isShopItemValid(shopItem.shopItemID) then
						local key = subType_dressID[subType]
						if not ret[key] then
							_ENV = ret[key]
						end
						ret[key] = ret[key]
						_ENV = nil
						;(nil).id = itemID
						;(nil).gold = shopItem.price
						;(nil).time = time
						;(nil).dressID = dressID
						table.insert(ret[key], nil)
					end
				end
			end
		end
	end
	return ret
end
function dressCtrl:getCastleDressList()
	local dressltCtrl, retList
	local dresslist = dressltCtrl.getCastleDressList()
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local premiumStoreCtrl = gametop.playertop_:getModule("premiumStoreCtrl")
	local itemLogic = include("itemLogic")
	for subType, list in pairs(dresslist) do
		if not retList[subType] then
			dressltCtrl = retList[subType]
		end
		retList[subType] = retList[subType]
		for dressID, _ in pairs(list) do
			local time = dressltCtrl.getDressLifetime(dressID)
			local itemID = gModuleMgr.sharedMgr("backpackltCtrl"):getDressItemID(dressID)
			local itemNum = backpackCtrl:getItemCount(itemID)
			dressltCtrl = backpackCtrl
			backpackCtrl.time = time
			local backpackCtrl.dressID, dressInfo = dressID, backpackCtrl
			local isOwn = false
			local isCurSetting = false
			local ret, dressUnit = self.dressMgr:getDress(dressID)
			if gErrDef.Err_None == ret then
				isOwn = true
				isCurSetting = self.dressMgr:isCurSetting(dressID)
			end
			dressInfo.isOwn = isOwn
			dressInfo.isCurSetting = isCurSetting
			if itemLogic.checkLordLevelCond(itemID) and itemLogic.checkCastleLevelCond(itemID) then
				if 0 < itemNum then
					dressInfo.id = itemID
					dressInfo.count = itemNum
				else
					local shopItem = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByItemID(itemID)
					if shopItem and gModuleMgr.sharedMgr("shopltCtrl"):isShopItemValid(shopItem.shopItemID) then
						dressInfo.id = itemID
						dressInfo.gold = shopItem.price
					else
						local ok, price, shopItemID = premiumStoreCtrl:getDressInfo(itemID)
						if ok then
							dressInfo.id = itemID
							dressInfo.gold = price
							dressInfo.shopItemID = shopItemID
							dressInfo.fromPremiumStore = true
						end
					end
				end
			end
			if dressInfo.isOwn or dressInfo.id then
				table.insert(retList[subType], dressInfo)
			end
		end
		if next(retList[subType]) then
			table.sort(retList[subType], function(l, r)
				return l.dressID < r.dressID
			end)
		else
			retList[subType] = nil
		end
	end
	return retList
end
function dressCtrl:getDressWardrobeData()
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local premiumStoreCtrl = gametop.playertop_:getModule("premiumStoreCtrl")
	local itemLogic = include("itemLogic")
	local dressShopltCtrl = include("dressShopltCtrl")
	local castleSkinRead = include("castleSkinRead")
	local getItemInfo = function(dressID)
		local itemID = gModuleMgr.sharedMgr("backpackltCtrl"):getDressItemID(dressID)
		local itemNum = backpackCtrl:getItemCount(itemID)
		if 0 < itemNum and itemLogic.checkLordLevelCond(itemID) and itemLogic.checkCastleLevelCond(itemID) then
			return itemID, itemNum
		end
	end
	local getDressInfo = function(dressID)
		local ret, dressUnit = self.dressMgr:getDress(dressID)
		if gErrDef.Err_None == ret then
			local isOwn = true
			local remainTime = dressUnit:getRemainTime()
			local forever = dressltCtrl.isForever(dressID)
			return isOwn, forever, remainTime
		end
	end
	local getItemData = function(dressID)
		local itemID, itemNum = getItemInfo(dressID)
		if itemID and 0 < itemNum then
			getItemInfo = nil
			;(nil).dressID = dressID
			;(nil).itemID = itemID
			local (nil).itemNum, data = itemNum, nil
			return data
		end
	end
	local getDressData = function(dressID)
		local active = self:isCurrentSetting(dressID)
		if self:isClassic(dressID) then
			self = self:isClassic(dressID)
			self:isClassic(dressID).dressID = dressID
			self:isClassic(dressID).isOwn = true
			self:isClassic(dressID).isClassic = true
			self:isClassic(dressID).active = active
			return (self:isClassic(dressID))
		end
		local data
		local isOwn, forever, remainTime = getDressInfo(dressID)
		if isOwn then
			if not data then
				data, self = nil, nil
			end
			data.dressID = dressID
			data.isOwn = isOwn
			data.forever = forever
			data.remainTime = remainTime
			data.active = active
			return data
		end
	end
	local gametop, ret
	for _, dressType in pairs(gDressType) do
		if gDressType.CASTLE == dressType or gDressType.CASTLE_NAMEPLATE == dressType or gDressType.CHAT_TEXT_FRAME == dressType or gDressType.MARCH == dressType or gDressType.MARCH_SUIT == dressType or gDressType.CHAT_AVATAR_FRAME == dressType then
			local dresslist = dressltCtrl.getDressList(dressType)
			if dresslist then
				local gametop, retList = dressType, dressType
				for subType, list in pairs(dresslist) do
					for dressID, _ in pairs(list) do
						local data = getDressData(dressID)
						if data then
							table.insert(retList, data)
							data.subType = subType
						end
						local itemData = getItemData(dressID)
						if itemData then
							table.insert(retList, itemData)
							itemData.subType = subType
						end
					end
				end
				if next(retList) then
					ret[tonumber(dressType)] = retList
					if gDressType.MARCH == dressType then
						if ret[tonumber(gDressType.MARCH_SUIT)] then
							for i, v in ipairs(ret[tonumber(gDressType.MARCH_SUIT)]) do
								table.insert(ret[tonumber(gDressType.MARCH)], v)
							end
						end
					elseif gDressType.MARCH_SUIT == dressType then
						if ret[tonumber(gDressType.MARCH)] then
							for i, v in ipairs(retList) do
								table.insert(ret[tonumber(gDressType.MARCH)], v)
							end
						else
							ret[tonumber(gDressType.MARCH)] = retList
						end
					end
				end
				table.sort(retList, function(l, r)
					local lSortIndex = castleSkinRead.getSortIndex(l.subType)
					local rSortIndex = castleSkinRead.getSortIndex(r.subType)
					return lSortIndex < rSortIndex
				end)
			end
		end
	end
	return ret
end
function dressCtrl:getRemainTimeOfDress(dressID)
	local remainTime = -1
	dressID = dressID or self:getCurDressID(gDressType.CASTLE)
	if not dressID then
		return remainTime
	end
	local ret, dressUnit = self.dressMgr:getDress(dressID)
	if gErrDef.Err_None ~= ret then
		return remainTime
	end
	remainTime = dressUnit:getRemainTime()
	return remainTime
end
function dressCtrl:isCurrentSetting(dressID)
	local dressType = dressltCtrl.getDressType(dressID)
	if gDressType.MARCH_SUIT == dressType then
		dressType = gDressType.MARCH_ARMY
	end
	local ret, dressUnit = self.dressMgr:getDressOfSetting(dressType)
	if self:isClassic(dressID) then
		dressID = nil
	end
	local currentSetting = dressUnit and dressUnit:getDressID()
	if dressID == currentSetting then
		return true
	end
	return false
end
function dressCtrl:ownDress(dressID)
	local ret, dressUnit = self.dressMgr:getDress(dressID)
	if gErrDef.Err_None == ret then
		return true
	end
	return false
end
function dressCtrl:selectDress(dressID)
	local ret = dressltCtrl.isDress(dressID)
	if gErrDef.Err_None ~= ret then
		return ret
	end
	if self.dressMgr:isCurSetting(dressID) then
		return gErrDef.Err_DRESS_REPEAT_TO_SET
	end
	dressltCtrl = nil
	;(nil).dressID = dressID
	serverproxy:Request(gCmd.CMD_DRESS_MODULE, gCmd.REQ_DRESS_SELECT, nil)
	return gErrDef.Err_None
end
function dressCtrl:restoreDress(dressType)
	local ret = dressltCtrl.isDressType(dressType)
	if gErrDef.Err_None ~= ret then
		return ret
	end
	dressltCtrl = nil
	;(nil).dressType = dressType
	serverproxy:Request(gCmd.CMD_DRESS_MODULE, gCmd.REQ_DRESS_RESTORE, nil)
	return gErrDef.Err_None
end
function dressCtrl:illustrateReceive(stage)
	serverproxy = nil
	;(nil).stage = stage
	serverproxy:Request(gCmd.CMD_DRESS_MODULE, gCmd.REQ_RECEIVE_ILLUSTRATE_REWARD, nil)
end
function dressCtrl:reqDressShowInfo()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_DRESS_MODULE, gCmd.REQ_DRESS_SHOW_INFO, nil)
end
function dressCtrl:restoreCastleDress()
	return self:restoreDress(gDressType.CASTLE)
end
function dressCtrl:restoreAchiDress(dressID)
	local dressType = dressltCtrl.getDressType(dressID)
	self:restoreDress(dressType)
	if gDressType.MARCH == dressType then
		self:restoreDress(gDressType.MARCH_ARMY)
	end
end
function dressCtrl:isClassic(dressID)
	local subType = dressltCtrl.getSubType(dressID)
	if gDressSubType.CASTLE_CLASSIC == subType or gDressSubType.CASTLE_RAMADAN_CLASSIC == subType or gDressSubType.MARCH_CLASSIC == subType or gDressSubType.CHAT_TEXT_FRAME_CLASSIC == subType or gDressSubType.CHAT_AVATAR_FRAME_CLASSIC == subType then
		return true
	end
end
function dressCtrl:isShowMenuRed()
	local ownData = self:getDressWardrobeData()
	local isRedVis = false
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	for i = 1, 5 do
		local gametop, dressIDMap
		table.sort(ownData[i], function(a, b)
			if a.isOwn and b.isOwn then
				return a.dressID < b.dressID
			elseif a.isOwn and not b.isOwn then
				return true
			elseif not a.isOwn and b.isOwn then
				return false
			else
				return a.dressID < b.dressID
			end
		end)
		for k, v in ipairs(ownData[i]) do
			local lifeType = dressltCtrl.getDressLifeType(v.dressID)
			if v.isOwn then
				dressIDMap[v.dressID] = 1
			end
			if not dressIDMap[v.dressID] and lifeType == gDressLifeType.FOREVER and backpackCtrl:getItemCount(v.itemID) > 0 then
				isRedVis = true
				break
			end
		end
	end
	return isRedVis
end
function RSP:selectDressRsp(content)
	dump(content, "dressCtrl.selectDressRsp", 5)
	if content.err ~= gErrDef.Err_None then
		return
	end
	local dressID = content.data.dressID
	local ret = self.dressMgr:setDress(dressID)
	if gErrDef.Err_None ~= ret then
		print("self.dressMgr:setDress ret = ", ret)
	else
		_ENV = "self.dressMgr:setDress ret = "
		;("self.dressMgr:setDress ret = ").msg = "MESSAGE_CASTLE_SKIN_CHANGE"
		;("self.dressMgr:setDress ret = ").skinID = dressID
		SoraDSendMessage("self.dressMgr:setDress ret = ")
		_ENV = "self.dressMgr:setDress ret = "
		;("self.dressMgr:setDress ret = ").msg = "MESSAGE_CASTLE_SKIN_CHANGE_NEW"
		;("self.dressMgr:setDress ret = ").skinID = dressID
		;("self.dressMgr:setDress ret = ").toDressID = dressID
		SoraDSendMessage("self.dressMgr:setDress ret = ")
	end
	_ENV = "self.dressMgr:setDress ret = "
	;("self.dressMgr:setDress ret = ").msg = "MESSAGE_ITEM_CASTLE_DRESS_CHANGE"
	SoraDSendMessage("self.dressMgr:setDress ret = ")
end
function RSP:restoreDressRsp(content)
	if content.err ~= gErrDef.Err_None then
		return
	end
	local dressType = content.data.dressType
	local ret = self.dressMgr:restoreSetting(dressType)
	if gErrDef.Err_None ~= ret then
		print("self.dressMgr:restoreDressRsp ret = ", ret)
	end
	_ENV = "self.dressMgr:restoreDressRsp ret = "
	;("self.dressMgr:restoreDressRsp ret = ").msg = "MESSAGE_CASTLE_SKIN_CHANGE"
	SoraDSendMessage("self.dressMgr:restoreDressRsp ret = ")
	_ENV = "self.dressMgr:restoreDressRsp ret = "
	;("self.dressMgr:restoreDressRsp ret = ").msg = "MESSAGE_ITEM_CASTLE_DRESS_CHANGE"
	SoraDSendMessage("self.dressMgr:restoreDressRsp ret = ")
	_ENV = "self.dressMgr:restoreDressRsp ret = "
	;("self.dressMgr:restoreDressRsp ret = ").msg = "MESSAGE_CASTLE_SKIN_CHANGE_NEW"
	SoraDSendMessage("self.dressMgr:restoreDressRsp ret = ")
end
function RSP:illustrateReceiveRsp(content)
	dump(content, "dressCtrl.illustrateReceiveRsp", 5)
	if content.rspdata == nil then
		return
	end
	if not content.rspdata.receviedIllustrateStage then
		_ENV = content.rspdata.receviedIllustrateStage
	end
	self.receviedIllustrateStage = content.rspdata.receviedIllustrateStage
	_ENV = content
	content.msg = "MESSAGE_CASTLE_DRESS_STAGE_CHANGE"
	content.reward = content.rspdata.reward
	SoraDSendMessage(content)
	if Err_DRESS_ILLUSTATE_REWARD_RECEIVED then
		SoraDShowMsgTip(i18n("common_text_1892"))
	end
end
function RSP:dressShowInfoRsp(content)
	dump(content, "dressCtrl.dressShowInfoRsp", 5)
	if content.err == gErrDef.Err_None then
		self.dressShowInfo = content.rspdata
	end
end
function RSP:noitfyDataRsp(content)
	dump(content.data, "dressCtrl.noitfyDataRsp", 5)
	local dressID
	for i, notifyData in ipairs(content.data) do
		local notifyType = notifyData.notifyType
		dressID = notifyData.dressID
		if gErrDef.Err_None == dressltCtrl.isDress(dressID) then
			if "NEW" == notifyType then
				local property = notifyData.property
				local ret = self.dressMgr:addDress(dressID, property)
				if gErrDef.Err_None ~= ret then
					print("dress noitfyDataRsp: NEW error")
				end
			elseif "RM" == notifyType then
				local ret = self.dressMgr:removeDress(dressID)
				if gErrDef.Err_None ~= ret then
					print("dress noitfyDataRsp: RM error")
				end
			elseif "NANDS" == notifyType then
				local property = notifyData.property
				local ret = self.dressMgr:addDress(dressID, property)
				if gErrDef.Err_None ~= ret then
					print("dress noitfyDataRsp.addDress: NANDS error")
					return
				end
				ret = self.dressMgr:setDress(dressID)
				if gErrDef.Err_None ~= ret then
					print("dress noitfyDataRsp.setDress: NANDS error")
				end
			elseif "RS" == notifyType then
				local dressType = dressltCtrl.getDressType(dressID)
				local ret = self.dressMgr:restoreSetting(dressType)
				if gErrDef.Err_None ~= ret then
					print("dress noitfyDataRsp.setDress: RS error", ret)
				end
			end
		end
	end
	_ENV = ipairs(content.data)
	ipairs(content.data).msg = "MESSAGE_MAINCITYVIEW_ADD_CASTLE_GIFT_TOP_TIP"
	SoraDSendMessage(ipairs(content.data))
	_ENV = ipairs(content.data)
	ipairs(content.data).msg = "MESSAGE_ITEM_CASTLE_DRESS_CHANGE"
	SoraDSendMessage(ipairs(content.data))
	_ENV = ipairs(content.data)
	ipairs(content.data).msg = "MESSAGE_CASTLE_SKIN_CHANGE_NEW"
	ipairs(content.data).toDressID = dressID
	SoraDSendMessage(ipairs(content.data))
end
function dressCtrl:ctor(properties)
	dressCtrl.super.ctor(self, properties)
	self.dressMgr = dressMgr.new()
end
function dressCtrl:EnterGame()
	dressCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_DRESS_MODULE, gCmd.REQ_DRESS_SELECT, handler(self, RSP.selectDressRsp))
	msgCtrl.register(gCmd.CMD_DRESS_MODULE, gCmd.REQ_DRESS_RESTORE, handler(self, RSP.restoreDressRsp))
	msgCtrl.register(gCmd.CMD_DRESS_MODULE, gCmd.REQ_RECEIVE_ILLUSTRATE_REWARD, handler(self, RSP.illustrateReceiveRsp))
	msgCtrl.register(gCmd.CMD_DRESS_MODULE, gCmd.REQ_DRESS_SHOW_INFO, handler(self, RSP.dressShowInfoRsp))
	self:reqDressShowInfo()
end
function dressCtrl:resetData()
	self.dressShowInfo, dressMgr, self.receviedIllustrateStage, dressMgr, self.dressMgr = dressMgr.new(), dressMgr.new(), dressMgr.new(), dressMgr.new(), dressMgr.new()
end
function dressCtrl:Logout()
	dressCtrl.super.Logout(self)
	self:resetData()
end
return dressCtrl
