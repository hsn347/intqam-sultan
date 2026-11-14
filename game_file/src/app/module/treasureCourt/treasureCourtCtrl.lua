local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local treasureCourtCtrl = class("treasureCourtCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function treasureCourtCtrl:ctor(properties)
	treasureCourtCtrl.super.ctor(self, properties)
	self:resetData()
end
function treasureCourtCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_JADE_STONE_MODULE, gCmd.REQ_JADE_STONE_INIT, handler(self, self.reqJadeStoneInitRsp))
	msgCtrl.register(gCmd.CMD_JADE_STONE_MODULE, gCmd.REQ_JADE_STONE_BUY, handler(self, self.reqJadeStoneBuyRsp))
	self.activityID = gActivityTimeActivityID.JADE_STONE_MALL_ACTIVITY
	self:registerNotify()
	self:reqJadeStoneInit()
end
function treasureCourtCtrl:Logout()
	treasureCourtCtrl.super.Logout(self)
	self:resetData()
end
function treasureCourtCtrl:resetData()
	self.buyInfo, _UPVALUE0_ = nil, nil
	self.jadeStoneCount = 0
end
function treasureCourtCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.JADE_STONE_MALL, handler(self, self.notifyHandler))
end
function treasureCourtCtrl:notifyHandler(event)
	dump(event.data, "treasureCourtCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if not v.jadeStoneMallData then
			local _ENV, jadeStoneMallData = v.jadeStoneMallData, v.jadeStoneMallData
		end
		if not jadeStoneMallData.buyInfo then
			_ENV = jadeStoneMallData.buyInfo
		end
		self.buyInfo = jadeStoneMallData.buyInfo
		self.jadeStoneCount = jadeStoneMallData.jadeStoneCount or 0
		_ENV = nil
		;(nil).msg = "MESSAGE_TREASURECOURT_REFRESH"
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;(nil).eventID = self.activityID
		SoraDSendMessage(nil)
	end
end
function treasureCourtCtrl:reqJadeStoneInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_JADE_STONE_MODULE, gCmd.REQ_JADE_STONE_INIT, nil)
end
function treasureCourtCtrl:reqJadeStoneBuy(data)
	serverproxy:Request(gCmd.CMD_JADE_STONE_MODULE, gCmd.REQ_JADE_STONE_BUY, data)
end
function treasureCourtCtrl:reqJadeStoneInitRsp(content)
	dump(content, "treasureCourtCtrl:reqJadeStoneInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata.jadeStoneMallData then
			local _ENV, jadeStoneMallData = content.rspdata.jadeStoneMallData, content.rspdata.jadeStoneMallData
		end
		if not jadeStoneMallData.buyInfo then
			_ENV = jadeStoneMallData.buyInfo
		end
		self.buyInfo = jadeStoneMallData.buyInfo
		self.jadeStoneCount = jadeStoneMallData.jadeStoneCount or 0
		_ENV = "treasureCourtCtrl:reqJadeStoneInitRsp(content)"
		;("treasureCourtCtrl:reqJadeStoneInitRsp(content)").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;("treasureCourtCtrl:reqJadeStoneInitRsp(content)").eventID = self.activityID
		SoraDSendMessage("treasureCourtCtrl:reqJadeStoneInitRsp(content)")
	end
end
function treasureCourtCtrl:reqJadeStoneBuyRsp(content)
	dump(content, "treasureCourtCtrl:reqJadeStoneBuyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.reward, true)
		if not content.rspdata.jadeStoneMallData then
			local _ENV, jadeStoneMallData = content.rspdata.jadeStoneMallData, content.rspdata.jadeStoneMallData
		end
		if not jadeStoneMallData.buyInfo then
			_ENV = jadeStoneMallData.buyInfo
		end
		self.buyInfo = jadeStoneMallData.buyInfo
		self.jadeStoneCount = jadeStoneMallData.jadeStoneCount or 0
		_ENV = true
		;(true).msg = "MESSAGE_TREASURECOURT_REFRESH"
		SoraDSendMessage(true)
		_ENV = true
		;(true).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;(true).eventID = self.activityID
		SoraDSendMessage(true)
	elseif content.err == gErrDef.Err_JADE_STONE_CASTLE_LV_NOT_ENOUGH then
		_ENV = self.activityID
		self.activityID.level = CASTLE_LV15_LIMITED
		SoraDShowMsgTip(i18n("common_text_3587", self.activityID))
	end
end
function treasureCourtCtrl:isEnoughStone(needNum)
	if self.jadeStoneCount ~= nil and needNum ~= nil and needNum <= self.jadeStoneCount then
		return true
	else
		return false
	end
end
function treasureCourtCtrl:getStoneNum()
	return self.jadeStoneCount or 0
end
function treasureCourtCtrl:getShopItemHaveBuy(shopItemID)
	local num = self.buyInfo[tostring(shopItemID)] or 0
	return num
end
function treasureCourtCtrl:getReceiveStatusAndNum()
	print("self.activityID", self.activityID)
	local isNew = SoraDGetCtrl("activityCenterUICtrl"):isHaveNewFlag(self.activityID)
	if isNew then
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:treasureCourtView:redShow~bool", true, nil)
	end
	_ENV = true
	;(true).byUID = true
	if SoraDConfigGet("Game:treasureCourtView:redShow~bool", true) then
		local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
		local superBuyInfo = shopltCtrl:getTreasureCourtSuper()
		if self:isEnoughStone(superBuyInfo.price) and self:getShopItemHaveBuy(superBuyInfo.shopItemID) then
			return true, -1
		end
		for i, v in ipairs(shopltCtrl:getTreasureCourtNormalList()) do
			if self:isEnoughStone(v.price) and self:getShopItemHaveBuy(v.shopItemID) then
				return true, -1
			end
		end
	end
	return false, -1
end
return treasureCourtCtrl
