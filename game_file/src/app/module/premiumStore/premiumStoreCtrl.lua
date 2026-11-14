local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local premiumStoreCtrl = class("premiumStoreCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function premiumStoreCtrl:ctor(properties)
	premiumStoreCtrl.super.ctor(self, properties)
	self.dataTable, premiumStoreCtrl = premiumStoreCtrl.super.ctor, premiumStoreCtrl.super.ctor
	self.showPwd = false
	self.canSetPwd = false
	self.dollor = 0
	self:initBaseInfo()
end
function premiumStoreCtrl:initBaseInfo()
	self.cfgInfo, _ENV = nil, nil
	local data = require("app." .. LocalTblPath .. ".config_server.extreme_shop_new")
	for k, v in pairs(data) do
		self.cfgInfo[v.shopId] = v
	end
end
function premiumStoreCtrl:getSuperInfoByIsoverflow(isoverflow)
	local _ENV, ret
	for k, v in pairs(self.cfgInfo) do
		if v.isoverflow == isoverflow then
			table.insert(ret, v)
		end
	end
	table.sort(ret, function(l, r)
		return l.index < r.index
	end)
	return ret
end
function premiumStoreCtrl:updateData(data)
	_UPVALUE2_, self.dataTable, _ENV = nil, nil, nil
	;(nil)[1] = "normalRecord"
	local (nil)[2], dataKey = "superInfo", nil
	for _, key in ipairs(dataKey) do
		if data[key] then
			self.dataTable[key], _ENV = nil, nil
			for k, v in pairs(data[key]) do
				local info = self.cfgInfo[tonumber(k)]
				if info then
					info.buyCount = v.buyCount
					table.insert(self.dataTable[key], info)
				end
			end
		end
		table.sort(self.dataTable[key], function(l, r)
			return l.index < r.index
		end)
	end
	self:updateUnlockData()
end
function premiumStoreCtrl:updateUnlockData()
	local viplv = SoraDGetVipLv()
	for k, data in pairs(self.dataTable) do
		for i, v in ipairs(data) do
			if v.unlocktype == gPremiumUnlockType.meetGold then
				v.unlock = v.total <= self.dollor
			elseif v.unlocktype == gPremiumUnlockType.meetVip then
				v.unlock = viplv >= v.viplv
			elseif v.unlocktype == gPremiumUnlockType.meetGoldOrVip then
				v.unlock = viplv >= v.viplv or v.total <= self.dollor
			elseif v.unlocktype == gPremiumUnlockType.both then
				v.unlock = viplv >= v.viplv and v.total <= self.dollor
			end
		end
	end
end
function premiumStoreCtrl:getData()
	return self.dataTable
end
function premiumStoreCtrl:getBuyIndexsData()
	return self.dataTable.buyIndexs
end
function premiumStoreCtrl:getCfgInfo()
	return self.cfgInfo
end
function premiumStoreCtrl:setCfgInfo(mCfg, mCfgKeys)
	for k, v in pairs(mCfg) do
		local _ENV, tmpItem
		for iValue, vValue in ipairs(v) do
			tmpItem[mCfgKeys[iValue]] = vValue
		end
		self.cfgInfo[tonumber(k)] = tmpItem
	end
end
function premiumStoreCtrl:getDressInfo(mDressID)
	local isForSale = false
	local price = 0
	local isExist = false
	local cfgID = 0
	for i = 1, 4 do
		local tmpKey = tostring(i)
		if self.dataTable[tmpKey] then
			local tmpItems = clone(self.dataTable[tmpKey])
			for k, v in pairs(tmpItems) do
				local tmpID = tonumber(v)
				if tmpID and tmpID ~= 0 then
					local tmpGoodItem = self.cfgInfo[tmpID]
					if tmpGoodItem and tmpGoodItem then
						local tmpGoodID = tmpGoodItem.commodityID
						local tmpGoodNum = tmpGoodItem.num
						local tmpGoodQuality = tmpGoodItem.quality
						local tmpPriceNeed = math.floor(tmpGoodItem.total * 1000)
						local tmpCurRecharge = math.floor(self.dataTable.recharged * 1000)
						if tonumber(mDressID) == tonumber(tmpGoodID) and tmpPriceNeed <= tmpCurRecharge then
							isExist = true
							isForSale = true
							price = tmpGoodItem.price
							cfgID = tmpID
							break
						end
					end
				end
			end
		end
		if isExist then
			break
		end
	end
	return isForSale, price, cfgID
end
function premiumStoreCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_LUXURY_MALL_MODULE, gCmd.REQ_LUXURY_MALL_INIT, handler(self, self.getOpenPageRsp))
	msgCtrl.register(gCmd.CMD_LUXURY_MALL_MODULE, gCmd.REQ_LUXURY_MALL_BUY, handler(self, self.getBuyRsp))
	msgCtrl.register(gCmd.CMD_LUXURY_MALL_MODULE, gCmd.REQ_LUXURY_MALL_SET_PWD, handler(self, self.getSetPwdRsp))
	msgCtrl.register(gCmd.CMD_LUXURY_MALL_MODULE, gCmd.REQ_LUXURY_MALL_SWITCH, handler(self, self.getSwitchRsp))
	msgCtrl.register(gCmd.CMD_LUXURY_MALL_MODULE, gCmd.REQ_LUXURY_MALL_RESET_PWD, handler(self, self.getResetPwdRsp))
end
function premiumStoreCtrl:sendOpenPage()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LUXURY_MALL_MODULE
	local (nil).subcmd, msg = gCmd.REQ_LUXURY_MALL_INIT, nil
	serverproxy:SendMsg(msg)
end
function premiumStoreCtrl:sendBuy(mID, mCount)
	if 0 ~= mID then
		_ENV = nil
		;(nil).cmd = gCmd.CMD_LUXURY_MALL_MODULE
		_ENV, (nil).subcmd = gCmd.REQ_LUXURY_MALL_BUY, gCmd.REQ_LUXURY_MALL_BUY
		gCmd.REQ_LUXURY_MALL_BUY.shopID = mID
		;(nil).data, gCmd.REQ_LUXURY_MALL_BUY.count = gCmd.REQ_LUXURY_MALL_BUY, mCount
		local msg
		serverproxy:SendMsg(msg)
	end
end
function premiumStoreCtrl:sendSetPwd(mPwd)
	if nil ~= mPwd then
		_ENV = nil
		;(nil).cmd = gCmd.CMD_LUXURY_MALL_MODULE
		_ENV, (nil).subcmd = gCmd.REQ_LUXURY_MALL_SET_PWD, gCmd.REQ_LUXURY_MALL_SET_PWD
		;(nil).data, gCmd.REQ_LUXURY_MALL_SET_PWD.pwd = gCmd.REQ_LUXURY_MALL_SET_PWD, mPwd
		local msg
		serverproxy:SendMsg(msg)
	end
end
function premiumStoreCtrl:sendBuyNUse(mIndex)
	if nil ~= mIndex then
		_ENV = nil
		;(nil).cmd = gCmd.CMD_PREMIUM_STORE_MODULE
		_ENV, (nil).subcmd = gCmd.REQ_BUY_N_USE_DRESS, gCmd.REQ_BUY_N_USE_DRESS
		;(nil).data, gCmd.REQ_BUY_N_USE_DRESS.index = gCmd.REQ_BUY_N_USE_DRESS, mIndex
		local msg
		serverproxy:SendMsg(msg)
	end
end
function premiumStoreCtrl:sendSwitch(mShow, mPwd)
	local msg
	if 0 == mShow then
		_ENV = nil
		;(nil).cmd = gCmd.CMD_LUXURY_MALL_MODULE
		_ENV, (nil).subcmd = gCmd.REQ_LUXURY_MALL_SWITCH, gCmd.REQ_LUXURY_MALL_SWITCH
		msg, (nil).data, gCmd.REQ_LUXURY_MALL_SWITCH.show = nil, gCmd.REQ_LUXURY_MALL_SWITCH, mShow
	elseif 1 == mShow then
		_ENV = nil
		;(nil).cmd = gCmd.CMD_LUXURY_MALL_MODULE
		_ENV, (nil).subcmd = gCmd.REQ_LUXURY_MALL_SWITCH, gCmd.REQ_LUXURY_MALL_SWITCH
		gCmd.REQ_LUXURY_MALL_SWITCH.show = mShow
		msg, (nil).data, gCmd.REQ_LUXURY_MALL_SWITCH.pwd = nil, gCmd.REQ_LUXURY_MALL_SWITCH, mPwd
	end
	if msg then
		serverproxy:SendMsg(msg)
	end
end
function premiumStoreCtrl:sendResetPwd()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LUXURY_MALL_MODULE
	local (nil).subcmd, msg = gCmd.REQ_LUXURY_MALL_RESET_PWD, nil
	serverproxy:SendMsg(msg)
end
function premiumStoreCtrl:resetData()
	self.dataTable, _UPVALUE0_ = nil, nil
	self.showEnter = nil
	self.dollor = nil
end
function premiumStoreCtrl:getPassword()
	return self.canSetPwd
end
function premiumStoreCtrl:getIsShow()
	return self.showPwd
end
function premiumStoreCtrl:Logout()
	premiumStoreCtrl.super.Logout(self)
	self:resetData()
end
function premiumStoreCtrl:getOpenPageRsp(content)
	if gErrDef.Err_None == content.err and content.rspdata.luxuryMallData then
		if content.rspdata.luxuryMallData.canSetPwd ~= nil then
			self.canSetPwd = content.rspdata.luxuryMallData.canSetPwd
		end
		if content.rspdata.luxuryMallData.isShowDollor ~= nil then
			self.showPwd = content.rspdata.luxuryMallData.isShowDollor
		end
		if content.rspdata.luxuryMallData.dollor then
			self.dollor = content.rspdata.luxuryMallData.dollor
		end
		self:updateData(content.rspdata.luxuryMallData)
		_ENV = self
		self.msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIP_REFRESH"
		self.redata = self.dataTable
		SoraDSendMessage(self)
	else
		_ENV = self
		self.msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIP_REFRESH"
		self.err = content.err
		SoraDSendMessage(self)
	end
end
function premiumStoreCtrl:getBuyRsp(content)
	dump(content, "getBuyRsp", 5)
	if gErrDef.Err_None == content.err and content.rspdata.luxuryMallData then
		self:updateData(content.rspdata.luxuryMallData)
		if content.rspdata.reward then
			SoraDPopGainItem(content.rspdata.reward[1].id, content.rspdata.reward[1].count)
		end
		_ENV = content.rspdata.reward[1].id
		content.rspdata.reward[1].id.msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIP_BUYONE"
		content.rspdata.reward[1].id.redata = self.dataTable
		SoraDSendMessage(content.rspdata.reward[1].id)
	else
		_ENV = content.rspdata.reward[1].id
		content.rspdata.reward[1].id.msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIP_BUYONE"
		content.rspdata.reward[1].id.err = content.err
		SoraDSendMessage(content.rspdata.reward[1].id)
	end
end
function premiumStoreCtrl:getSetPwdRsp(content)
	dump(content, "getSetPwdRsp", 5)
	if content.err and gErrDef.Err_None == content.err then
		self.canSetPwd = content.rspdata.canSetPwd
		SoraDShowMsgTip(i18n("common_text_2059"))
		_ENV = i18n("common_text_2059")
		i18n("common_text_2059").msg = "MESSAGE_EXCLUSIVE_VIP_PHONE_CHECK_BACK"
		SoraDSendMessage(i18n("common_text_2059"))
	else
		SoraDShowMsgTip("set error")
	end
end
function premiumStoreCtrl:getSwitchRsp(content)
	if content.err and gErrDef.Err_None == content.err then
		self.showPwd = content.rspdata.isShowDollor
		_ENV = content.err
		content.err.msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIP_SHOWPWD"
		content.err.err = content.err
		SoraDSendMessage(content.err)
		_ENV = content.err
		content.err.msg = "MESSAGE_EXCLUSIVE_VIP_PHONE_CHECK_BACK"
		SoraDSendMessage(content.err)
	else
		_ENV = content.err
		content.err.msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIP_SHOWPWD"
		content.err.err = content.err
		SoraDSendMessage(content.err)
	end
end
function premiumStoreCtrl:getResetPwdRsp(content)
	dump(content, "getResetPwdRsp", 5)
	if content.err == nil or content.err and gErrDef.Err_None == content.err then
		SoraDShowMsgTip(i18n("Safety_lock_text_30"))
		self.canSetPwd = true
		_ENV = i18n("Safety_lock_text_30")
		i18n("Safety_lock_text_30").msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIP_SHOWPWD"
		i18n("Safety_lock_text_30").err = content.err
		SoraDSendMessage(i18n("Safety_lock_text_30"))
	end
end
function premiumStoreCtrl:dealData(content)
	if content and content.result then
		for i = 1, 4 do
			local tmpKey = tostring(i)
			local tmpItems = clone(content.result[tmpKey])
			local maxPlace = 0
			for k, v in pairs(tmpItems) do
				if k ~= "premium" and maxPlace < tonumber(k) then
					maxPlace = tonumber(k)
				end
			end
			if 0 < maxPlace then
				content.result[tmpKey], _ENV = pairs(tmpItems)
				content.result[tmpKey].premium = tmpItems.premium
			end
			for index = 1, maxPlace do
				if tmpItems[tostring(index)] then
					table.insert(content.result[tmpKey], tmpItems[tostring(index)])
				end
			end
		end
		if content.result.cfgKeys and content.result.cfg then
			self:setCfgInfo(content.result.cfg, content.result.cfgKeys)
		end
		if content.result.pwd then
			self.password = content.result.pwd
		end
		if content.result.show then
			self.showPwd = content.result.show
		end
	end
	return content
end
function premiumStoreCtrl:notifyHandler(event)
	dump(event.data, "premiumStoreCtrl:notifyHandler", 10)
	if event and event.data then
		for _, content in ipairs(event.data) do
			if content.luxuryMallData.canSetPwd ~= nil then
				self.canSetPwd = content.luxuryMallData.canSetPwd
			end
			if content.luxuryMallData.isShowDollor ~= nil then
				self.showPwd = content.luxuryMallData.isShowDollor
			end
			if content.luxuryMallData.dollor then
				self.dollor = content.luxuryMallData.dollor
			end
			self:updateData(content.luxuryMallData)
		end
		_ENV = ipairs(event.data)
		ipairs(event.data).msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIP_REFRESH"
		ipairs(event.data).redata = self.dataTable
		SoraDSendMessage(ipairs(event.data))
	end
end
function premiumStoreCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.LUXURY_MALL, handler(self, self.notifyHandler))
end
function premiumStoreCtrl:initClientData(data)
	if not data then
		return
	end
	self:registerNotify()
	self.showEnter = data.showEnter
	self.dollor = data.dollor
end
function premiumStoreCtrl:getShowEnter()
	return self.showEnter
end
function premiumStoreCtrl:getDollor()
	return self.dollor or 0
end
return premiumStoreCtrl
