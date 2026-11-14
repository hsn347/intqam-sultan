local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local merchantOfSericaCtrl = class("merchantOfSericaCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local merchantOfSericaRead = include("merchantOfSericaRead")
function merchantOfSericaCtrl:ctor(properties)
	merchantOfSericaCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.MERCHANT_OF_SERICA
	self:resetData()
end
function merchantOfSericaCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SERRIS_SHOP_MODULE, gCmd.REQ_SERRIS_SHOP_INIT, handler(self, self.getInitData))
	msgCtrl.register(gCmd.CMD_SERRIS_SHOP_MODULE, gCmd.REQ_SERRIS_SHOP_ORDER, handler(self, self.getOrder))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.newDay))
end
function merchantOfSericaCtrl:newDay()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		self:reqSericaInit()
	end
end
function merchantOfSericaCtrl:initClientData(data)
	dump(data, "merchantOfSericaCtrl:initClientData")
	if clientEventMgr.judgeIsOpen(self.activityID) then
		self:registerNotify()
	end
end
function merchantOfSericaCtrl:Logout()
	merchantOfSericaCtrl.super.Logout(self)
	self:resetData()
end
function merchantOfSericaCtrl:resetData()
	self.serverGroup = 1
	self.commodityList, _UPVALUE0_, self.selectList, _UPVALUE0_, self.flag = nil, nil, nil, nil, false
end
function merchantOfSericaCtrl:getReceiveStatusAndNum(activityID)
	return false
end
function merchantOfSericaCtrl:getCommodityIDList()
	for k, v in ipairs(self.selectList) do
	end
end
function merchantOfSericaCtrl:reqSericaInit()
	serverproxy:Request(gCmd.CMD_SERRIS_SHOP_MODULE, gCmd.REQ_SERRIS_SHOP_INIT)
end
function merchantOfSericaCtrl:reqSericaOrder()
	_ENV = nil
	local (nil).items, data = self.commodityList, nil
	dump(self.commodityList, "reqSericaOrder")
	serverproxy:Request(gCmd.CMD_SERRIS_SHOP_MODULE, gCmd.REQ_SERRIS_SHOP_ORDER, data)
end
function merchantOfSericaCtrl:registerNotify()
	print("商人registerNotify")
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SERRIS_SHOP, handler(self, self.notifyHandler))
end
function merchantOfSericaCtrl:notifyHandler(notifyData)
	dump(notifyData, "商人数据变化")
	local data = notifyData.data[1]
	dump(data.reward, "商人数据变化")
	local rid = data.rid
	local reward = data.reward
	if data.type == "result" then
		if data.success then
			self.flag = true
			_ENV = nil
			;(nil).msg = "MESSAGE_SERICA_INIT"
			SoraDSendMessage(nil)
			_ENV = nil
			;(nil).msg = "MESSAGE_SERICA_SHOP"
			;(nil).reward = reward
			SoraDSendMessage(nil)
			_ENV = nil
			_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
			;(nil).result = true
			;(nil).rid = rid
			;(nil).data, (nil).itemList = nil, reward
			SoraDSendMessage(nil)
		else
			SoraDCloseLoading()
			local err = data.code
			local msgNotice = include("msgNotice")
			local errStr = msgNotice.getTipCode(err)
			if not errStr then
				errStr = tostring(err)
			else
				errStr = i18n(errStr)
			end
			SoraDShowMsgTip(errStr)
		end
	end
end
function merchantOfSericaCtrl:getInitData(content)
	dump(content, "getInitData")
	if content.err == gErrDef.Err_None then
		self.flag = content.rspdata.flag
		self.serverGroup = content.rspdata.group
		self.items = content.rspdata.items
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERICA_INIT"
		SoraDSendMessage(gErrDef.Err_None)
	else
	end
end
function merchantOfSericaCtrl:getOrder(content)
	dump(content, "getOrder")
	if content.err == gErrDef.Err_None and content.rspdata.orderID then
		self.items = content.data.items
		local rechargeID = merchantOfSericaRead.getPackageInfo().giftBagId
		print(rechargeID, content.rspdata.orderID)
		paymentManager.purchase(rechargeID, content.rspdata.orderID)
		_ENV = rechargeID
		rechargeID.msg = "MESSAGE_SERICA_ORDER"
		SoraDSendMessage(rechargeID)
	elseif content.err == gErrDef.Err_NEW_RECHARGE_NOT_OPEN then
		_ENV = gErrDef.Err_NEW_RECHARGE_NOT_OPEN
		gErrDef.Err_NEW_RECHARGE_NOT_OPEN.msg = "MESSAGE_SERICA_ERR"
		SoraDSendMessage(gErrDef.Err_NEW_RECHARGE_NOT_OPEN)
	else
		local msgNotice = include("msgNotice")
		local errStr = msgNotice.getTipCode(content.err)
		if not errStr then
			errStr = tostring(content.err)
		else
			errStr = i18n(errStr)
		end
		SoraDShowMsgTip(errStr)
	end
end
function merchantOfSericaCtrl:getServerGroup()
	return self.serverGroup
end
function merchantOfSericaCtrl:getServerFlag()
	return self.flag
end
function merchantOfSericaCtrl:setSelectList(id, commodityID)
	if #self.selectList < 4 and 4 > #self.commodityList then
		table.insert(self.selectList, id)
		table.insert(self.commodityList, commodityID)
		_ENV = self.commodityList
		self.commodityList.msg = "MESSAGE_SERICA_SELECT"
		self.commodityList.commodityID = commodityID
		self.commodityList.id = id
		SoraDSendMessage(self.commodityList)
	end
end
function merchantOfSericaCtrl:delSelectByid(id)
	table.remove(self.selectList, id)
	table.remove(self.commodityList, id)
	_ENV = self.commodityList
	self.commodityList.msg = "MESSAGE_SERICA_DELETE"
	SoraDSendMessage(self.commodityList)
end
function merchantOfSericaCtrl:getSelectList()
	return self.selectList
end
function merchantOfSericaCtrl:getCommodityList()
	return self.commodityList
end
function merchantOfSericaCtrl:getSelectById(id)
	return self.selectList[id]
end
function merchantOfSericaCtrl:getItemList(index)
	return self.items[index]
end
function merchantOfSericaCtrl:getGetListById(index)
	local item
	local cmmId = self.items[index]
	if cmmId then
		item = merchantOfSericaRead.getConfigByCommodityID(cmmId, self.serverGroup)
	end
	return item
end
function merchantOfSericaCtrl:getTotalSelect(id)
	local num = 0
	for k, v in ipairs(self.selectList) do
		if v == id then
			num = num + 1
		end
	end
	return num
end
function merchantOfSericaCtrl:getTotalGet(commodityID)
	local num = 0
	for k, v in ipairs(self.items) do
		if v == commodityID then
			num = num + 1
		end
	end
	return num
end
return merchantOfSericaCtrl
