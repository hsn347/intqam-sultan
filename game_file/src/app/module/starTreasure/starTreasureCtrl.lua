local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local starTreasureCtrl = class("starTreasureCtrl", GameModule)
function starTreasureCtrl:ctor(properties)
	starTreasureCtrl.super.ctor(self, properties)
	self:resetData()
end
function starTreasureCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_STAR_TREASURE_EXPLORE, gCmd.REQ_STAR_TREASURE_EXPLORE_INIT, handler(self, self.sendReqInfoRsp))
	msgCtrl.register(gCmd.CMD_STAR_TREASURE_EXPLORE, gCmd.REQ_STAR_TREASURE_EXPLORE_MERGE, handler(self, self.sendReqMergeRsp))
	msgCtrl.register(gCmd.CMD_STAR_TREASURE_EXPLORE, gCmd.REQ_STAR_TREASURE_EXPLORE_USE, handler(self, self.sendReqUseRsp))
	self:registerNotify()
end
function starTreasureCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.STAR_TREASURE_EXPLORE, handler(self, self.notifyHandler))
end
function starTreasureCtrl:notifyHandler(event)
	dump(event.data, "starTreasureCtrl:notifyHandler", 10)
	for _, content in ipairs(event.data) do
		self.troopsOn = false
		self:setData(content)
		_ENV = self
		self.msg = "MESSAGE_STAR_TREASURE_REFRESH"
		self.subMsg = "reset"
		SoraDSendMessage(self)
	end
end
function starTreasureCtrl:initClientData(data)
end
function starTreasureCtrl:Logout()
	self:resetData()
	starTreasureCtrl.super.Logout(self)
end
function starTreasureCtrl:resetData()
	self.x = 0
	self.y = 0
end
function starTreasureCtrl:setData(data)
	self.x = data.x
	self.y = data.y
	self.opencount = data.opencount
end
function starTreasureCtrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_STAR_TREASURE_EXPLORE, gCmd.REQ_STAR_TREASURE_EXPLORE_INIT)
end
function starTreasureCtrl:sendMergeMsg()
	serverproxy:Request(gCmd.CMD_STAR_TREASURE_EXPLORE, gCmd.REQ_STAR_TREASURE_EXPLORE_MERGE)
end
function starTreasureCtrl:sendUseMsg()
	serverproxy:Request(gCmd.CMD_STAR_TREASURE_EXPLORE, gCmd.REQ_STAR_TREASURE_EXPLORE_USE)
end
function starTreasureCtrl:sendReqInfoRsp(content)
	dump(content, "starTreasureCtrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata.initData
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_STAR_TREASURE_REFRESH"
		self.subMsg = "init"
		SoraDSendMessage(self)
		return
	end
end
function starTreasureCtrl:sendReqMergeRsp(content)
	dump(content, "starTreasureCtrl:sendReqMergeRsp=", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata.initData
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_STAR_TREASURE_REFRESH"
		self.subMsg = "merge"
		self.reward = content.rspdata.reward
		SoraDSendMessage(self)
		return
	end
	if content.err == gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_OPEN then
		_ENV = gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_OPEN
		gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_OPEN.msg = "MESSAGE_STAR_TREASURE_REFRESH"
		gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_OPEN.subMsg = "notOpen"
		SoraDSendMessage(gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_OPEN)
		return
	end
	if content.err == gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_ENOUGH_ITEM then
		_ENV = gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_ENOUGH_ITEM
		gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_ENOUGH_ITEM.msg = "MESSAGE_STAR_TREASURE_REFRESH"
		gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_ENOUGH_ITEM.subMsg = "notEnoughItem"
		SoraDSendMessage(gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_ENOUGH_ITEM)
		return
	end
end
function starTreasureCtrl:sendReqUseRsp(content)
	dump(content, "starTreasureCtrl:sendReqUseRsp", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self.x = data.x
		self.y = data.y
		_ENV = "starTreasureCtrl:sendReqUseRsp"
		;("starTreasureCtrl:sendReqUseRsp").msg = "MESSAGE_STAR_TREASURE_REFRESH"
		;("starTreasureCtrl:sendReqUseRsp").subMsg = "use"
		SoraDSendMessage("starTreasureCtrl:sendReqUseRsp")
		return
	end
	if content.err == gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_OPEN then
		_ENV = gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_OPEN
		gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_OPEN.msg = "MESSAGE_STAR_TREASURE_REFRESH"
		gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_OPEN.subMsg = "notOpen"
		SoraDSendMessage(gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_OPEN)
		return
	end
	if content.err == gErrDef.Err_STAR_TREASURE_EXPLORE_USE_FAIL then
		_ENV = gErrDef.Err_STAR_TREASURE_EXPLORE_USE_FAIL
		gErrDef.Err_STAR_TREASURE_EXPLORE_USE_FAIL.msg = "MESSAGE_STAR_TREASURE_REFRESH"
		gErrDef.Err_STAR_TREASURE_EXPLORE_USE_FAIL.subMsg = "useFail"
		SoraDSendMessage(gErrDef.Err_STAR_TREASURE_EXPLORE_USE_FAIL)
		return
	end
	if content.err == gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_IN_SELF_KINGDOM then
		_ENV = gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_IN_SELF_KINGDOM
		gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_IN_SELF_KINGDOM.msg = "MESSAGE_STAR_TREASURE_REFRESH"
		gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_IN_SELF_KINGDOM.subMsg = "notSelfKingdom"
		SoraDSendMessage(gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_IN_SELF_KINGDOM)
		return
	end
end
function starTreasureCtrl:getReceiveStatusAndNum()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local num = backpackCtrl:getItemCount(844901)
	if 0 < num then
		return true, -1
	end
	return false
end
function starTreasureCtrl:isTroopOn()
	if self.x > 0 and 0 < self.y then
		return true
	end
	return false
end
function starTreasureCtrl:setTroopOn(flag)
	self.troopsOn = flag
end
function starTreasureCtrl:isOnUsing()
	if self.x and self.y and (self.x ~= 0 or self.y ~= 0) then
		return true
	end
	return false
end
function starTreasureCtrl:getPosX()
	return self.x - 1
end
function starTreasureCtrl:getPosY()
	return self.y - 1
end
return starTreasureCtrl
