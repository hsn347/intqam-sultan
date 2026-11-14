local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001612_Ctrl = class("activity_9001612_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001612_Ctrl:ctor(properties)
	activity_9001612_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HONOR_BACK_STORE
	self:resetData()
end
function activity_9001612_Ctrl:EnterGame()
	print("==activity_9001612_Ctrl:EnterGame==")
	msgCtrl.register(gCmd.CMD_HONOR_BACK_STORE_MODULE, gCmd.REQ_HONOR_BACK_STORE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_HONOR_BACK_STORE_MODULE, gCmd.REQ_HONOR_BACK_STORE_EXCHANGE, handler(self, self.reqExchangeRsp))
end
function activity_9001612_Ctrl:Logout()
	activity_9001612_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001612_Ctrl:resetData()
	self.exchangeInfo, _UPVALUE0_ = nil, nil
end
function activity_9001612_Ctrl:sendReqInitDataMsg()
	serverproxy:Request(gCmd.CMD_HONOR_BACK_STORE_MODULE, gCmd.REQ_HONOR_BACK_STORE_INIT)
end
function activity_9001612_Ctrl:sendExchangeMsg(shopItemId, count)
	serverproxy = nil
	;(nil).shopItemId = shopItemId
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_HONOR_BACK_STORE_MODULE, gCmd.REQ_HONOR_BACK_STORE_EXCHANGE, nil)
end
function activity_9001612_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001612_Ctrl:reqInitRsp")
	if content.err == gErrDef.Err_None then
		self.exchangeInfo = content.rspdata.exchangeInfo
	end
end
function activity_9001612_Ctrl:reqExchangeRsp(content)
	dump(content, "activity_9001612_Ctrl:reqExchangeRsp", 5)
	if content.err == gErrDef.Err_None then
		self.exchangeInfo = content.rspdata.initData.exchangeInfo
		if content.rspdata.rewards then
			SoraDMailGainItems(content.rspdata.rewards, true)
		end
	end
	_ENV = content.rspdata.rewards
	content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001612_UPDATE"
	SoraDSendMessage(content.rspdata.rewards)
	_ENV = content.rspdata.rewards
	content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001608_UPDATE_RED"
	content.rspdata.rewards.activityID = self.activityID
	SoraDSendMessage(content.rspdata.rewards)
end
function activity_9001612_Ctrl:getReceiveStatusAndNum()
	local retNum = 0
	local activity_9001612_Read = include("activity_9001612_Read")
	local constantRead = include("constantRead")
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local backStarLv = lordInfoCtrl:getBackStarLv()
	local coinID = constantRead.getConstValue("PLAYER_GLORY_RETURN_STORE_ITEM")
	for page = 1, 4 do
		local cfgList = activity_9001612_Read.getShopList(page, backStarLv)
		for k, v in ipairs(cfgList) do
			local exchangeTimes = self:getExchangeTimes(v.shopItemID)
			if exchangeTimes < v.limitnum and backpackCtrl:getItemCount(coinID) >= v.exchangeitem then
				retNum = retNum + 1
			end
		end
	end
	return 0 < retNum, retNum
end
function activity_9001612_Ctrl:getExchangeTimes(shopItemID)
	return self.exchangeInfo[tostring(shopItemID)] or 0
end
function activity_9001612_Ctrl:getGroup()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(self.activityID)
	local _classtype = param.classtype and param.classtype or 1
	return _classtype
end
return activity_9001612_Ctrl
