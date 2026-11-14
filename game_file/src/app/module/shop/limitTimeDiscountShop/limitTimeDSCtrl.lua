local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local limitTimeDSConfig = include("limitTimeDSConfig")
local dailyLimitShopItemMgr = include("dailyLimitShopItemMgr")
local limitTimeDSCtrl = class("limitTimeDSCtrl")
local _ENV, REQ = "limitTimeDSCtrl", "limitTimeDSCtrl"
local _ENV, RSP
function limitTimeDSCtrl:ctor()
	self.data, _UPVALUE0_ = nil, nil
end
function limitTimeDSCtrl:initialize(data)
	if not data then
		data, limitTimeDSConfig = nil, nil
	end
	if not data.configData then
		local limitTimeDSConfig, configData = data.configData, data.configData
	end
	limitTimeDSConfig:initialize(configData)
end
function limitTimeDSCtrl:updateConfig(config)
	limitTimeDSConfig:update(config)
end
function limitTimeDSCtrl:destroy()
	self.data, limitTimeDSConfig = nil, nil
	limitTimeDSConfig:destroy()
end
function limitTimeDSCtrl:getShopItemList()
	local config = limitTimeDSConfig:getConfig()
	local limitTimeDSConfig, list = limitTimeDSConfig, limitTimeDSConfig
	local activityShowCtrl = gModuleMgr.getObject("gametop").playertop_:getModule("activityShowCtrl")
	local activityID = gActivityTimeActivityID.LIMITED_DISCOUNT_ACTIVITY
	if activityShowCtrl:isActivityOpen(activityID) then
		for k, v in pairs(config) do
			local shopItemID = v.shopItemID
			local limit = 0
			local remainCount = 0
			if limitTimeDSConfig:limitBuy(shopItemID) then
				limit = v.limitNum
				local buyCount = dailyLimitShopItemMgr:getBuyCount(shopItemID)
				remainCount = limit - buyCount
			end
			limitTimeDSConfig = buyCount
			dailyLimitShopItemMgr:getBuyCount(shopItemID).shopItemID = v.shopItemID
			dailyLimitShopItemMgr:getBuyCount(shopItemID).id = v.result[1].id
			dailyLimitShopItemMgr:getBuyCount(shopItemID).count = v.result[1].count
			dailyLimitShopItemMgr:getBuyCount(shopItemID).price = v.price
			dailyLimitShopItemMgr:getBuyCount(shopItemID).originalPrice = v.originalPrice
			dailyLimitShopItemMgr:getBuyCount(shopItemID).max = limit
			dailyLimitShopItemMgr:getBuyCount(shopItemID).cur = remainCount
			dailyLimitShopItemMgr:getBuyCount(shopItemID).contain = v.contain
			local dailyLimitShopItemMgr:getBuyCount(shopItemID).order, data = v.order, dailyLimitShopItemMgr:getBuyCount(shopItemID)
			table.insert(list, data)
		end
	end
	table.sort(list, function(l, r)
		if l.order and r.order then
			return l.order < r.order
		else
			return l.shopItemID < r.shopItemID
		end
	end)
	return list
end
function limitTimeDSCtrl:buy(shopItemID, count)
	REQ.buy(shopItemID, count)
end
function REQ.buy(shopItemID, count)
	serverproxy = nil
	;(nil).shopItemID = shopItemID
	local (nil).count, data = count, nil
	serverproxy:Request(gCmd.CMD_SHOP_MODULE, gCmd.REQ_LIMIT_TIME_DS_SHOP_BUY, data)
end
function RSP:buyRsp(content)
	if gErrDef.Err_None == content.err then
		local rspData = content.data
		local shopItemID = rspData.shopItemID
		local count = rspData.count
		if limitTimeDSConfig:limitBuy(shopItemID) then
			dailyLimitShopItemMgr:addShopItemBuyCount(shopItemID, count)
		end
		local result = limitTimeDSConfig:getResult(shopItemID)
		local itemID = result[1].id
		local num = result[1].count
		local iconType = gNoticeIconTypeDef.ICON_ITEM
		_ENV = nil
		;(nil).itemID = itemID
		;(nil).count = num * count
		include("msgNotice").notice("notice_0116", nil, iconType, itemID)
		local panel = SoraDCreatePanel("animationGainItem")
		_ENV = iconType
		iconType.itemID = itemID
		iconType.itemCount = num * count
		panel:initData(iconType)
		panel:show()
	end
	_ENV = rspData.shopItemID
	rspData.shopItemID.msg = "MESSAGE_ITEM_DISCOUNT_BUY_BACK"
	SoraDSendMessage(rspData.shopItemID)
end
function limitTimeDSCtrl:registerMsg()
	msgCtrl.register(gCmd.CMD_SHOP_MODULE, gCmd.REQ_LIMIT_TIME_DS_SHOP_BUY, handler(self, RSP.buyRsp))
end
return limitTimeDSCtrl
