local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local storesCtrl = class("storesCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function storesCtrl:ctor(properties)
	storesCtrl.super.ctor(self, properties)
	self:resetData()
end
function storesCtrl:resetData()
	self.isOpen = false
	self.refreshTimes = 0
	self.shopItemArray, _UPVALUE0_, self.refreshGold = nil, nil, 0
	self.bestShopItem = nil
	self.nextRefreshTime = nil
	self.actStatus = false
end
function storesCtrl:Logout()
	storesCtrl.super.Logout(self)
	self:resetData()
end
function storesCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_STORES_MODULE, gCmd.REQ_INIT_STORESDATA, handler(self, self.initStoresDataRsp))
	msgCtrl.register(gCmd.CMD_STORES_MODULE, gCmd.REQ_REFRESH_STORESDATA, handler(self, self.getRefreshStoresDataRsp))
	msgCtrl.register(gCmd.CMD_STORES_MODULE, gCmd.REQ_PURCHASE_GOODS, handler(self, self.buyInDiscountRsp))
end
function storesCtrl:updateDataRsp(event)
	local data = event.data
	for i, notifyData in ipairs(data) do
		local notifyType = notifyData.notifyType
		if "reset" == notifyType or "open" == notifyType then
			self.refreshGold = notifyData.refreshGold
			self.refreshTimes = notifyData.refreshTimes
			self.shopItemArray = notifyData.shopItemArray
			self.bestShopItem = notifyData.bestShopItem
			self.nextRefreshTime = notifyData.nextRefreshTime
			_ENV = nil
			;(nil).msg = "MESSAGE_STORES_ALLREFRESH"
			SoraDSendMessage(nil)
			if "open" == notifyType then
				self.actStatus = notifyData.actStatus
				_ENV = nil
				;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_MERCHANT_VIEW"
				SoraDSendMessage(nil)
			end
		elseif "close" == notifyType then
			self:resetData()
			_ENV = self
			self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_MERCHANT_VIEW"
			SoraDSendMessage(self)
		elseif "actBegin" == notifyType then
			self.actStatus = true
			_ENV = self
			self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_MERCHANT_VIEW"
			SoraDSendMessage(self)
		elseif "actEnd" == notifyType then
			self.actStatus = false
			_ENV = self
			self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_MERCHANT_VIEW"
			SoraDSendMessage(self)
		end
	end
end
function storesCtrl:buyInDiscountRsp(respone)
	dump(respone, "storesCtrl:buyInDiscountRsp")
	local data = respone.data
	local err = respone.err
	if gErrDef.Err_None == err then
		local shopItemID = data.shopItemID
		local newShopItem = data.newShopItem
		for i, item in ipairs(self.shopItemArray) do
			if item.shopItemID == shopItemID then
				self.shopItemArray[i] = newShopItem
				break
			end
		end
		_ENV = ipairs(self.shopItemArray)
		ipairs(self.shopItemArray).msg = "MESSAGE_STORES_PURCHASE"
		ipairs(self.shopItemArray).newData = newShopItem
		ipairs(self.shopItemArray).oldShopID = shopItemID
		SoraDSendMessage(ipairs(self.shopItemArray))
	else
		_ENV = data.newShopItem
		data.newShopItem.msg = "MESSAGE_STORES_PURCHASE"
		data.newShopItem.Err = err
		SoraDSendMessage(data.newShopItem)
	end
end
function storesCtrl:initStoresDataRsp(respone)
	local data = respone.data
	self.isOpen = data.isOpen
	if self.isOpen then
		self.refreshTimes = data.refreshTimes
		self.refreshGold = data.refreshGold
		self.shopItemArray = data.shopItemArray
		self.bestShopItem = data.bestShopItem
		self.nextRefreshTime = data.nextRefreshTime
	end
end
function storesCtrl:getRefreshStoresDataRsp(respone)
	local err = respone.err
	local data = respone.data
	if gErrDef.Err_None == err then
		self.refreshTimes = data.refreshTimes
		self.refreshGold = data.refreshGold
		self.shopItemArray = data.shopItemArray
		_ENV = nil
		;(nil).msg = "MESSAGE_STORES_REFRESH"
		SoraDSendMessage(nil)
	end
end
function storesCtrl:getRefreshRemainTime()
	if "number" == type(self.nextRefreshTime) then
		local curTime = serviceFunctions.systemTime()
		local remainTime = self.nextRefreshTime - curTime
		if 0 < remainTime then
			return remainTime
		end
	end
	return 0
end
function storesCtrl:getRefreshTimes()
	return self.refreshTimes
end
function storesCtrl:isStoreOpen()
	return self.isOpen
end
function storesCtrl:getShopItemArray()
	if not self.shopItemArray then
		_UPVALUE0_ = self.shopItemArray
	end
	return self.shopItemArray
end
function storesCtrl:getBestShopItem()
	return self.bestShopItem
end
function storesCtrl:updateRefreshGold()
	if "number" == type(self.refreshTimes) and self.refreshTimes >= 0 then
		return self.refreshGold
	end
end
function storesCtrl:refresh()
	serverproxy:Request(gCmd.CMD_STORES_MODULE, gCmd.REQ_REFRESH_STORESDATA)
end
function storesCtrl:purchase(shopItemID)
	serverproxy = nil
	local (nil).shopItemID, data = shopItemID, nil
	serverproxy:Request(gCmd.CMD_STORES_MODULE, gCmd.REQ_PURCHASE_GOODS, data)
end
function storesCtrl:isActOpen()
	return self.actStatus
end
function storesCtrl:initClientData(data)
	self.isOpen = data.isOpen
	if self.isOpen then
		self.refreshTimes = data.refreshTimes
		self.refreshGold = data.refreshGold
		self.shopItemArray = data.shopItemArray
		self.bestShopItem = data.bestShopItem
		self.nextRefreshTime = data.nextRefreshTime
		self.actStatus = data.actStatus
	end
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:addEventListener(gNotifyID.SHOP, handler(self, self.updateDataRsp))
end
return storesCtrl
