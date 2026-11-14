local GameModule = include("GameModule")
local crazyShoppingCtrl = class("crazyShoppingCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function crazyShoppingCtrl:ctor(properties)
	crazyShoppingCtrl.super.ctor(self, properties)
end
function crazyShoppingCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CRAZY_SHOPPING_MODULE, gCmd.REQ_CRAZY_SHOPPING_INIT, handler(self, self.sendReqInfoInitRsp))
	msgCtrl.register(gCmd.CMD_CRAZY_SHOPPING_MODULE, gCmd.REQ_CRAZY_SHOPPING_BUY, handler(self, self.sendReqBuyRsp))
	self:resetData()
end
function crazyShoppingCtrl:resetData()
	self.buyInfo, _UPVALUE0_ = nil, nil
	self.curDay = 1
end
function crazyShoppingCtrl:Logout()
	self:resetData()
	crazyShoppingCtrl.super.Logout(self)
end
function crazyShoppingCtrl:initClientData(data)
	if not data then
		return
	end
	self.buyInfo = data.buyInfo
	self.curDay = data.curDay
end
function crazyShoppingCtrl:sendReqBuyInfo()
	serverproxy:Request(gCmd.CMD_CRAZY_SHOPPING_MODULE, gCmd.REQ_CRAZY_SHOPPING_INIT)
end
function crazyShoppingCtrl:sendReqBuy(data)
	serverproxy:Request(gCmd.CMD_CRAZY_SHOPPING_MODULE, gCmd.REQ_CRAZY_SHOPPING_BUY, data)
end
function crazyShoppingCtrl:getBuyInfo(...)
	return self.buyInfo
end
function crazyShoppingCtrl:getCurDay(...)
	return self.curDay
end
function crazyShoppingCtrl:getCrazyBoxNum(...)
	if table.nums(self.buyInfo) == 0 then
		return 0
	else
		return math.pow(2, table.nums(self.buyInfo))
	end
end
function crazyShoppingCtrl:checkHasInvest(day)
	for i, v in pairs(self.buyInfo) do
		if tonumber(i) == tonumber(day) then
			return true
		end
	end
	return false
end
function crazyShoppingCtrl:getInvestLeftTime(...)
	return 86400 - (serviceFunctions.systemTime() - serviceFunctions.getTodayZeroHourUTC())
end
function crazyShoppingCtrl:isShowFundPage()
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
	if isInConquestWar then
		return false
	end
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local status = activityShowCtrl:getStateByID(gActivityTimeActivityID.CRAZY_SHOPPING_ACTIVITY)
	if status == gActivityState.CLOSE then
		return false
	end
	local worldMapDefine = include("worldMapDefine")
	local isInPyramidWar = worldMapDefine.isInWar()
	if isInPyramidWar then
		return false
	end
	return true
end
function crazyShoppingCtrl:sendReqInfoInitRsp(content)
	dump(content, "crazyShoppingCtrl:sendReqInfoInitRsp", 10)
	if gErrDef.Err_None == content.err then
		self.buyInfo = content.rspdata.crazyShoppingData.buyInfo
	end
end
function crazyShoppingCtrl:sendReqBuyRsp(content)
	dump(content, "crazyShoppingCtrl:sendReqBuyRsp", 10)
	if gErrDef.Err_None == content.err then
		self.buyInfo = content.rspdata.crazyShoppingData.buyInfo
		self.curDay = content.rspdata.crazyShoppingData.curDay
		_ENV = content.err
		content.err.msg = "MESSAGE_CRAZYSHOPPING_REFRESH"
		SoraDSendMessage(content.err)
		_ENV = content.err
		content.err.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(content.err)
	end
end
return crazyShoppingCtrl
