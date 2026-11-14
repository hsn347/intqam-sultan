local GameModule = include("GameModule")
local goldSoukCtrl = class("goldSoukCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function goldSoukCtrl:ctor(properties)
	goldSoukCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.GOLD_SOUK_ACTIVITY
end
function goldSoukCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_GOLD_SOUK_MODULE, gCmd.CMD_GOLD_SOUK_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_GOLD_SOUK_MODULE, gCmd.CMD_GOLD_SOUK_BUY, handler(self, self.reqBuyRsp))
	msgCtrl.register(gCmd.CMD_GOLD_SOUK_MODULE, gCmd.CMD_GOLD_SOUK_CLAIM, handler(self, self.reqClaimRsp))
	self:resetData()
	self:registerNotify()
end
function goldSoukCtrl:resetData()
	self.boughtRecord, _UPVALUE0_ = nil, nil
	self.gotGift, _UPVALUE0_, self.curRange, _UPVALUE0_, self.score = nil, nil, nil, nil, 0
	self.nextRefreshTime = 0
	self.goldSoukCoin = 0
	self.refreshLv = 1
end
function goldSoukCtrl:Logout()
	self:resetData()
	goldSoukCtrl.super.Logout(self)
end
function goldSoukCtrl:initClientData(data)
	dump(data, "goldSoukCtrl:initClientData====")
	if data then
		if not data.boughtRecord then
			_ENV = data.boughtRecord
		end
		self.boughtRecord = data.boughtRecord
		self.score = data.score or 0
		if not data.curRange then
			_ENV = data.curRange
		end
		self.curRange = data.curRange
		if not data.gotGift then
			_ENV = data.gotGift
		end
		self.gotGift = data.gotGift
		self.nextRefreshTime = data.nextRefreshTime or 0
		self.goldSoukCoin = data.goldSoukCoin or 0
		self.refreshLv = data.refreshLv or 1
	end
end
function goldSoukCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.GOLD_SOUK, handler(self, self.notifyHandler))
end
function goldSoukCtrl:notifyHandler(content)
	dump(content, "goldSoukCtrl:notifyHandler=====", 10)
	local notifydata = content.data
	for _, notifyMsg in ipairs(notifydata) do
		if not notifyMsg.data.boughtRecord then
			_ENV = notifyMsg.data.boughtRecord
		end
		self.boughtRecord = notifyMsg.data.boughtRecord
		if not notifyMsg.data.curRange then
			_ENV = notifyMsg.data.curRange
		end
		self.curRange = notifyMsg.data.curRange
		self.goldSoukCoin = notifyMsg.data.goldSoukCoin or 0
		self.nextRefreshTime = notifyMsg.data.nextRefreshTime or 0
		self.refreshLv = notifyMsg.data.refreshLv or 1
	end
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_GOLDSOUK_UPDATE"
	SoraDSendMessage(ipairs(notifydata))
end
function goldSoukCtrl:sendInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_GOLD_SOUK_MODULE, gCmd.CMD_GOLD_SOUK_INIT, nil)
end
function goldSoukCtrl:sendBuy(index, num)
	serverproxy = nil
	;(nil).index = index
	;(nil).num = num or 1
	serverproxy:Request(gCmd.CMD_GOLD_SOUK_MODULE, gCmd.CMD_GOLD_SOUK_BUY, nil)
end
function goldSoukCtrl:sendClaim(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_GOLD_SOUK_MODULE, gCmd.CMD_GOLD_SOUK_CLAIM, nil)
end
function goldSoukCtrl:reqInitRsp(content)
	dump(content, "==goldSoukCtrl:reqInitRsp==", 20)
	if content.err == gErrDef.Err_None then
		if not content.rspdata.boughtRecord then
			_ENV = content.rspdata.boughtRecord
		end
		self.boughtRecord = content.rspdata.boughtRecord
		self.score = content.rspdata.score or 0
		if not content.rspdata.curRange then
			_ENV = content.rspdata.curRange
		end
		self.curRange = content.rspdata.curRange
		if not content.rspdata.gotGift then
			_ENV = content.rspdata.gotGift
		end
		self.gotGift = content.rspdata.gotGift
		self.nextRefreshTime = content.rspdata.nextRefreshTime or 0
		self.goldSoukCoin = content.rspdata.goldSoukCoin or 0
		self.refreshLv = content.rspdata.refreshLv or 1
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_GOLDSOUK_UPDATE"
	SoraDSendMessage(gErrDef.Err_None)
end
function goldSoukCtrl:reqBuyRsp(content)
	dump(content, "==goldSoukCtrl:reqBuyRsp==", 20)
	if content.err == gErrDef.Err_None then
		if not content.rspdata.boughtRecord then
			_ENV = content.rspdata.boughtRecord
		end
		self.boughtRecord = content.rspdata.boughtRecord
		self.score = content.rspdata.score
		self.goldSoukCoin = content.rspdata.goldSoukCoin
		SoraDMailGainItems(content.rspdata.goods, true)
	end
	_ENV = content.rspdata.goods
	content.rspdata.goods.msg = "MESSAGE_GOLDSOUK_UPDATE"
	SoraDSendMessage(content.rspdata.goods)
end
function goldSoukCtrl:reqClaimRsp(content)
	dump(content, "==goldSoukCtrl:reqClaimRsp==", 20)
	if content.err == gErrDef.Err_None then
		if not content.rspdata.gotGift then
			_ENV = content.rspdata.gotGift
		end
		self.gotGift = content.rspdata.gotGift
		SoraDMailGainItems(content.rspdata.reward, true)
	end
	_ENV = content.rspdata.reward
	content.rspdata.reward.msg = "MESSAGE_GOLDSOUK_UPDATE"
	SoraDSendMessage(content.rspdata.reward)
end
function goldSoukCtrl:getReceiveStatusAndNum()
	local goldSoukRead = include("goldSoukRead")
	local boxCfg = goldSoukRead.getRewardCfg()
	local num = 0
	for k, v in ipairs(boxCfg) do
		if self.score >= v.integral and not self:isBoxGot(v.Id) then
			num = num + 1
		end
	end
	return 0 < num, num
end
function goldSoukCtrl:getScore()
	return self.score
end
function goldSoukCtrl:getRefreshLv()
	return self.refreshLv
end
function goldSoukCtrl:getSoukCoin()
	return self.goldSoukCoin
end
function goldSoukCtrl:getItemBuyCount(index)
	return self.boughtRecord[tostring(index)] or 0
end
function goldSoukCtrl:isBoxGot(index)
	return self.gotGift[tostring(index)] and true or false
end
return goldSoukCtrl
