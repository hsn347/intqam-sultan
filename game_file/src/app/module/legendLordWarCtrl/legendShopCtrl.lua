local GameModule = include("GameModule")
local legendShopCtrl = class("legendShopCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function legendShopCtrl:ctor(properties)
	legendShopCtrl.super.ctor(self, properties)
end
function legendShopCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_WORLD_WAR_SHOP_MODULE, gCmd.REQ_WORLD_WAR_SHOP_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_WORLD_WAR_SHOP_MODULE, gCmd.REQ_WORLD_WAR_SHOP_BUY, handler(self, self.reqBuyRsp))
	self:resetData()
end
function legendShopCtrl:resetData()
	self.buyInfo, _UPVALUE0_ = nil, nil
end
function legendShopCtrl:Logout()
	self:resetData()
	legendShopCtrl.super.Logout(self)
end
function legendShopCtrl:sendInitShop()
	serverproxy:Request(gCmd.CMD_WORLD_WAR_SHOP_MODULE, gCmd.REQ_WORLD_WAR_SHOP_INIT)
end
function legendShopCtrl:sendBuy(shopItemID, buyCount)
	serverproxy = nil
	;(nil).shopItemID = shopItemID
	;(nil).buyCount = buyCount
	serverproxy:Request(gCmd.CMD_WORLD_WAR_SHOP_MODULE, gCmd.REQ_WORLD_WAR_SHOP_BUY, nil)
end
function legendShopCtrl:reqInitRsp(ret)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata then
		self.buyInfo = ret.rspdata.buyInfo
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_SERVER_LEGENDLORD_SHOP_REFRESH"
	SoraDSendMessage(gErrDef.Err_None)
end
function legendShopCtrl:reqBuyRsp(ret)
	SoraDCloseLoading()
	if ret and ret.err == gErrDef.Err_None and ret.rspdata and ret.data then
		self.buyInfo = ret.rspdata.buyInfo
		local shopItemID = ret.data.shopItemID
		local legendKingRead = include("legendKingRead")
		local itemID = legendKingRead.getItemIDByShopItemID(shopItemID)
		local buyCount = ret.data.buyCount
		local resDesRead = include("resDesRead")
		if resDesRead.checkResID(itemID) then
			local publicRead = include("publicRead")
			local count = legendKingRead.getItemNumByShopItemID(shopItemID)
			_ENV = nil
			;(nil).itemID = publicRead.getName(itemID)
			;(nil).count = SoraDConvertNumberWithUnit(count * buyCount)
			local languageString = i18n("notice_0117", nil)
			SoraDShowMsgTip(languageString, publicRead.getIcon(itemID))
		else
			SoraDPopGainItem(itemID, buyCount)
		end
	end
	_ENV = include("legendKingRead")
	include("legendKingRead").msg = "MESSAGE_SERVER_LEGENDLORD_SHOP_REFRESH"
	SoraDSendMessage((include("legendKingRead")))
end
function legendShopCtrl:getLeftBuyCount(shopItemID)
	return self.buyInfo[tostring(shopItemID)] or 0
end
return legendShopCtrl
