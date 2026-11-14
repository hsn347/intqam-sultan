local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local starTreasuryCtrl = class("starTreasuryCtrl", GameModule)
local starTreasuryRead = include("starTreasuryRead")
function starTreasuryCtrl:ctor(properties)
	starTreasuryCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.STAR_TREASURY_ACTIVITY
end
function starTreasuryCtrl:EnterGame()
	print("starTreasuryCtrl:EnterGame")
	msgCtrl.register(gCmd.CMD_STAR_TREASURY_MODULE, gCmd.REQ_STAR_TREASURY_INIT, handler(self, self.sendInitRsp))
	msgCtrl.register(gCmd.CMD_STAR_TREASURY_MODULE, gCmd.REQ_STAR_TREASURY_BUY, handler(self, self.sendBuyRsp))
	msgCtrl.register(gCmd.CMD_STAR_TREASURY_MODULE, gCmd.REQ_STAR_TREASURY_RECEIVE, handler(self, self.sendReceiveRsp))
	self:resetData()
	self:registerNotify()
end
function starTreasuryCtrl:Logout()
	starTreasuryCtrl.super.Logout(self)
	self:resetData()
end
function starTreasuryCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.STAR_TREASURY, handler(self, self.notifyHandler))
end
function starTreasuryCtrl:notifyHandler(event)
	dump(event.data, "starTreasuryCtrl:notifyHandler", 10)
	for _, content in ipairs(event.data) do
		self:initClientData(content)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_STAR_TREASURY"
		self.subMsg = "reward"
		self.reward = content.reward
		self.rid = content.rid
		SoraDSendMessage(self)
	end
end
function starTreasuryCtrl:initClientData(data)
	self:setData(data)
end
function starTreasuryCtrl:resetData()
	self.msgData = nil
end
function starTreasuryCtrl:setData(data)
	self.msgData = data and data.initData or nil
end
function starTreasuryCtrl:sendReqInitDataMsg()
	serverproxy:Request(gCmd.CMD_STAR_TREASURY_MODULE, gCmd.REQ_STAR_TREASURY_INIT)
end
function starTreasuryCtrl:sendBuy(rid)
	serverproxy = nil
	;(nil).rid = rid
	serverproxy:Request(gCmd.CMD_STAR_TREASURY_MODULE, gCmd.REQ_STAR_TREASURY_BUY, nil)
end
function starTreasuryCtrl:sendReceive(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_STAR_TREASURY_MODULE, gCmd.REQ_STAR_TREASURY_RECEIVE, nil)
end
function starTreasuryCtrl:sendInitRsp(content)
	dump(content, "starTreasuryCtrl:sendInitRsp==", 20)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_STAR_TREASURY"
		self.subMsg = "init"
		SoraDSendMessage(self)
		return
	end
end
function starTreasuryCtrl:sendBuyRsp(content)
	dump(content, "==sendBuyRsp==", 20)
	if content.err == gErrDef.Err_None then
		local rechargeID = content.data.rid
		local orderID = content.rspdata.orderID
		paymentManager.purchase(rechargeID, orderID)
		return
	end
end
function starTreasuryCtrl:sendReceiveRsp(content)
	dump(content, "==sendBuyRsp==", 20)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_STAR_TREASURY"
		self.subMsg = "reward"
		self.reward = content.rspdata.reward
		SoraDSendMessage(self)
		return
	end
end
function starTreasuryCtrl:getReceiveStatusAndNum(...)
	local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
	local sType = self:getSType()
	if not starTreasuryRead.getQuestList(sType) then
		local _ENV, questList = starTreasuryRead.getQuestList(sType), starTreasuryRead.getQuestList(sType)
	end
	local num = 0
	for i, v in ipairs(questList) do
		local taskStatus = self:getTaskStatus(v.index)
		if taskStatus ~= gStarTreasuryStatus.ALREADY_RECEIVE then
			local qType = v.lv[1]
			local lv = 0
			if qType == 1 then
				lv = SoraDGetBuildStarLv(v.lv[2])
			elseif qType == 2 then
				lv = magicLampCtrl:getJinnLv(v.lv[2])
			end
			if lv >= v.lv[3] then
				num = num + 1
			end
		end
	end
	return 0 < num, num
end
function starTreasuryCtrl:getIsBoxRecord(key)
	if not self.msgData then
		return false
	end
	if not self.msgData.buyRecord then
		return false
	end
	local value = self.msgData.buyRecord[tostring(key)] or 0
	return 0 < value
end
function starTreasuryCtrl:getTaskStatus(key)
	if not self.msgData then
		return gStarTreasuryStatus.CAN_NOT_RECEIVE
	end
	if not self.msgData.taskRewardRecord then
		return gStarTreasuryStatus.CAN_NOT_RECEIVE
	end
	local value = self.msgData.taskRewardRecord[tostring(key)] or gStarTreasuryStatus.CAN_NOT_RECEIVE
	return value
end
function starTreasuryCtrl:getSType()
	return self.msgData and self.msgData.classtype or 1
end
return starTreasuryCtrl
