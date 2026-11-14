local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local allianceStore = class("allianceStore", gameModule)
local _ENV, RSP = "allianceStore", "allianceStore"
function allianceStore:ctor(properties)
	allianceStore.super.ctor(self, properties)
	self:resetData()
end
function allianceStore:resetData()
	self.shopList, _UPVALUE0_, self.itemList, _UPVALUE0_ = nil, nil, nil, nil
end
function allianceStore:setItemList(itemlist)
	self.itemList = itemlist
end
function allianceStore:setShopList(shopList)
	self.shopList = shopList
end
function allianceStore:getItemList()
	local _ENV, ret
	local keys = table.keys(self.itemList)
	table.sort(keys)
	for k, v in pairs(keys) do
		local id = tonumber(v)
		local count = self.itemList[v]
		local endtime = self:isItemLimited(id)
		_ENV = self
		self.itemID = id
		self.itemCount = count
		local self.endtime, item = endtime, self
		table.insert(ret, item)
	end
	return ret
end
function allianceStore:isItemLimited(id)
	local endtime
	local shopInfo = self.shopList[tostring(id)]
	if shopInfo and shopInfo.timeinfo then
		endtime = shopInfo.timeinfo.endtime
	end
	return endtime
end
function allianceStore:getShopList()
	local _ENV, ret
	local keys = table.keys(self.shopList)
	table.sort(keys)
	for k, v in pairs(keys) do
		local id = tonumber(v)
		local count = self.shopList[v]
		local endtime
		if count.timeinfo then
			endtime = count.timeinfo.endtime
		end
		_ENV = count.timeinfo
		count.timeinfo.itemID = id
		count.timeinfo.itemCount = count
		local count.timeinfo.endtime, item = endtime, count.timeinfo
		table.insert(ret, item)
	end
	return ret
end
function allianceStore:getItemByID(itemID)
	itemID = tostring(itemID)
	local ret = self.itemList[itemID] or 0
	return ret
end
function allianceStore:getShopByID(itemID)
	itemID = tostring(itemID)
	local ret = self.shopList[itemID] or 0
	return ret
end
function allianceStore:EnterGame()
	allianceStore.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_STORE_DATA, handler(self, RSP.AllianceStoreDataRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_ITEM_SHOP_DATA, handler(self, RSP.AllianceItemShopDataRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_STORE_BUY, handler(self, RSP.AllianceStoreBuyRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_ITEMSHOP_BUY, handler(self, RSP.AllianceItemShopBuyRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_STORE_RECORD, handler(self, RSP.getStoreRecordRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_STORE_RETURN_GOODS, handler(self, RSP.returnGoodsRsp))
end
function allianceStore:Logout()
	self:resetData()
end
function allianceStore:getLimitGoodLeftBuyCount(goodid)
	local max = include("allianceltCtrl"):getMaxBuyCount(goodid)
	if max then
		local curtime = serviceFunctions.systemTime()
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local member = memberMgr:getOwnMember()
		if not member.minfo.aStoreBuyInfo then
			return true, max
		end
		local info = member.minfo.aStoreBuyInfo[tostring(goodid)]
		if info then
			local count = info.count or 0
			local time = info.time or curtime
			local issameday = serviceFunctions.isSameDay(time, curtime)
			if issameday then
				local leftcount = max - count
				if leftcount < 0 then
					leftcount = 0
				end
				return true, leftcount
			else
				member.minfo.aStoreBuyInfo[tostring(goodid)] = nil
				return true, max
			end
		else
			return true, max
		end
	else
		return false
	end
end
function allianceStore:reqAllianceStoreData(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_STORE_DATA, nil, ...)
end
function allianceStore:reqAllianceItemStoreData(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_ITEM_SHOP_DATA, nil, ...)
end
function allianceStore:reqAllianceStoreBuy(itemid, count, ...)
	count = count or 1
	serverproxy = nil
	;(nil).itemid = itemid
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_STORE_BUY, nil, ...)
end
function allianceStore:reqAllianceItemShopBuy(itemid, count, ...)
	count = count or 1
	serverproxy = nil
	;(nil).itemid = itemid
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_ITEMSHOP_BUY, nil, ...)
end
function allianceStore:reqStoreRecord(tp, ...)
	serverproxy = nil
	;(nil).tp = tp
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_STORE_RECORD, nil, ...)
end
function allianceStore:reqReturnGoods(itemid, count, ...)
	serverproxy = nil
	;(nil).itemid = itemid
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_STORE_RETURN_GOODS, nil, ...)
end
function RSP:AllianceStoreDataRsp(content)
	dump(content, "commonRsp content")
	if content.err == gErrDef.Err_None then
		local itemlist = content.data.retdata
		self:setItemList(itemlist)
	else
		print("rsp error: ", content.err)
	end
	_ENV = "rsp error: "
	;("rsp error: ").msg = "MESSAGE_ALLIACNE_GET_STORE_LIST_SUCCESS"
	SoraDSendMessage("rsp error: ")
end
function RSP:AllianceItemShopDataRsp(content)
	dump(content, "AllianceItemShopDataRsp commonRsp content", 10)
	if content.err == gErrDef.Err_None then
		local inselllist = content.data.retdata.inselllist
		self:setShopList(inselllist)
		local itemlist = content.data.retdata.itemlist
		self:setItemList(itemlist)
	else
		print("rsp error: ", content.err)
	end
	_ENV = "rsp error: "
	;("rsp error: ").msg = "MESSAGE_ALLIACNE_GET_STORE_LIST_SUCCESS"
	SoraDSendMessage("rsp error: ")
end
function RSP:AllianceStoreBuyRsp(content)
	if content.err == gErrDef.Err_None then
		local itemid = content.data.itemid
		local msgNotice = include("msgNotice")
		_ENV = nil
		;(nil).itemID = itemid
		msgNotice.notice("notice_0086", nil)
	elseif content.err == gErrDef.Err_ALLIANCE_STORE_ITEM_NUM_CHANGED then
		SoraDShowMsgTip(i18n("alliance_store_returns_description_3"))
	else
		include("msgNotice").notice("notice_0170")
		print("rsp error: ", content.err)
	end
	_ENV = "rsp error: "
	;("rsp error: ").msg = "MESSAGE_ALLIACNE_GET_STORE_LIST_SUCCESS"
	SoraDSendMessage("rsp error: ")
end
function RSP:AllianceItemShopBuyRsp(content)
	if content.err == gErrDef.Err_None then
		local itemid = content.data.itemid
		local msgNotice = include("msgNotice")
		_ENV = nil
		;(nil).itemID = itemid
		msgNotice.notice("notice_0088", nil)
	else
		print("rsp error: ", content.err)
	end
	_ENV = "rsp error: "
	;("rsp error: ").msg = "MESSAGE_ALLIACNE_GET_STORE_LIST_SUCCESS"
	SoraDSendMessage("rsp error: ")
end
function RSP:getStoreRecordRsp(content)
	dump(content, "RSP.getStoreRecordRsp", 10)
	if content.err == gErrDef.Err_None then
		local storerecord = content.data.retdata
		_ENV = "RSP.getStoreRecordRsp"
		;("RSP.getStoreRecordRsp").msg = "MESSAGE_ALLIACNE_SHOP_LOG_BACK"
		;("RSP.getStoreRecordRsp").log = storerecord
		SoraDSendMessage("RSP.getStoreRecordRsp")
	else
		print("rsp error: ", content.err)
		_ENV = "rsp error: "
		;("rsp error: ").log, _ENV, ("rsp error: ").msg = content.err, content.err, "MESSAGE_ALLIACNE_SHOP_LOG_BACK"
		SoraDSendMessage("rsp error: ")
	end
end
function RSP:returnGoodsRsp(content)
	dump(content, "RSP.returnGoodsRsp", 10)
	if content.err == gErrDef.Err_None then
		local itemid = content.data.itemid
		local count = content.data.count
		local publicRead = include("publicRead")
		local allianceltCtrl = include("allianceltCtrl")
		local pay = allianceltCtrl.getPrice(itemid, gIDDef.ALLIANCE_HONOR)
		_ENV = nil
		;(nil).var1 = publicRead.getName(itemid)
		;(nil).var2 = string.formatnumberthousands(count * pay)
		;(nil).var3 = i18n("common_text_032")
		SoraDShowMsgTip(i18n("alliance_store_returns_description_2", nil))
	elseif content.err == gErrDef.Err_ALLIANCE_STORE_ITEM_NUM_CHANGED then
		SoraDShowMsgTip(i18n("alliance_store_returns_description_3"))
	elseif content.err == gErrDef.Err_ALLIANCE_STORE_RETURN_IN_CD then
		local constantRead = include("constantRead")
		local cdValue = constantRead.getConstValue("ALLIANCE_RETURN_CD")
		local gametop = gModuleMgr.getObject("gametop")
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local ownmember = memberMgr:getOwnMember()
		local lastTime = ownmember:getProperty("lastReturnGoodsTime") or 0
		local leftTime = lastTime + cdValue - serviceFunctions.systemTime()
		if 0 < leftTime then
			_ENV = i18n("alliance_store_returns_description_3")
			i18n("alliance_store_returns_description_3").var = math.ceil(leftTime / 60)
			SoraDShowMsgTip(i18n("alliance_store_returns_description_6", i18n("alliance_store_returns_description_3")))
		end
	elseif content.err == gErrDef.Err_ALLIANCE_NO_PERMISSION then
		SoraDShowMsgTip(i18n("alliance_store_returns_description_5"))
	end
	_ENV = i18n("alliance_store_returns_description_5")
	i18n("alliance_store_returns_description_5").msg = "MESSAGE_ALLIACNE_GET_STORE_LIST_SUCCESS"
	SoraDSendMessage(i18n("alliance_store_returns_description_5"))
end
return allianceStore
