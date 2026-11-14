local GameModule = include("GameModule")
local loudlyDressedCtrl = class("loudlyDressedCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function loudlyDressedCtrl:ctor(properties)
	loudlyDressedCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.LOUDLY_DRESSED_ACTIVITY
end
function loudlyDressedCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_LOUDLY_DRESSED_MODULE, gCmd.CMD_LOUDLY_DRESSED_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_LOUDLY_DRESSED_MODULE, gCmd.CMD_LOUDLY_DRESSED_CLAIM, handler(self, self.reqClaimRsp))
	self:resetData()
	self:registerNotify()
end
function loudlyDressedCtrl:resetData()
	self.gotGift, _UPVALUE0_, self.rechargeRecord, _UPVALUE0_ = nil, nil, nil, nil
	self.curDay = 1
end
function loudlyDressedCtrl:Logout()
	self:resetData()
	loudlyDressedCtrl.super.Logout(self)
end
function loudlyDressedCtrl:initClientData(data)
	dump(data, "loudlyDressedCtrl:initClientData====")
	if data then
		if not data.rechargeRecord then
			_ENV = data.rechargeRecord
		end
		self.rechargeRecord = data.rechargeRecord
		if not data.gotGift then
			_ENV = data.gotGift
		end
		self.gotGift = data.gotGift
		self.curDay = data.curDay or 1
	end
end
function loudlyDressedCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.LOUDLY_DRESSED, handler(self, self.notifyHandler))
end
function loudlyDressedCtrl:notifyHandler(content)
	dump(content, "loudlyDressedCtrl:notifyHandler=====", 10)
	local notifydata = content.data
	for _, notifyMsg in ipairs(notifydata) do
		self.curDay = notifyMsg.data.curDay
		self.rechargeRecord = notifyMsg.data.rechargeRecord
	end
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_LOUDLYDRESS_UPDATE"
	SoraDSendMessage(ipairs(notifydata))
end
function loudlyDressedCtrl:sendInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LOUDLY_DRESSED_MODULE, gCmd.CMD_LOUDLY_DRESSED_INIT, nil)
end
function loudlyDressedCtrl:sendClaim(index)
	serverproxy = nil
	;(nil).index = index or 1
	serverproxy:Request(gCmd.CMD_LOUDLY_DRESSED_MODULE, gCmd.CMD_LOUDLY_DRESSED_CLAIM, nil)
end
function loudlyDressedCtrl:reqInitRsp(content)
	dump(content, "==loudlyDressedCtrl:reqInitRsp==", 20)
	if content.err == gErrDef.Err_None then
		if not content.rspdata.rechargeRecord then
			_ENV = content.rspdata.rechargeRecord
		end
		self.rechargeRecord = content.rspdata.rechargeRecord
		if not content.rspdata.gotGift then
			_ENV = content.rspdata.gotGift
		end
		self.gotGift = content.rspdata.gotGift
		self.curDay = content.rspdata.curDay or 1
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_LOUDLYDRESS_UPDATE"
	SoraDSendMessage(gErrDef.Err_None)
end
function loudlyDressedCtrl:reqClaimRsp(content)
	dump(content, "==loudlyDressedCtrl:reqClaimRsp==", 20)
	if content.err == gErrDef.Err_None then
		if not content.rspdata.gotGift then
			_ENV = content.rspdata.gotGift
		end
		self.gotGift = content.rspdata.gotGift
		SoraDMailGainItems(content.rspdata.reward, true)
	end
	_ENV = content.rspdata.reward
	content.rspdata.reward.msg = "MESSAGE_LOUDLYDRESS_UPDATE"
	SoraDSendMessage(content.rspdata.reward)
end
function loudlyDressedCtrl:getReceiveStatusAndNum()
	local num = 0
	local rechargeCount = self:getRechargeRecordCount()
	local cumuDay = include("loudlyDressRead").getCfgNum()
	local isCumuReward = self:isCumuRewarded(cumuDay)
	if rechargeCount >= cumuDay and not isCumuReward then
		num = 1
	end
	return 0 < num, num
end
function loudlyDressedCtrl:getCurDay()
	return self.curDay
end
function loudlyDressedCtrl:getRechargeRecordCount()
	return table.nums(self.rechargeRecord)
end
function loudlyDressedCtrl:isRewarded(day)
	return self.rechargeRecord[tostring(day)] and true or false
end
function loudlyDressedCtrl:isCumuRewarded(day)
	return self.gotGift[tostring(day)] and true or false
end
return loudlyDressedCtrl
