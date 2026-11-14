local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local luckyFlopCtrl = class("luckyFlopCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function luckyFlopCtrl:ctor(properties)
	luckyFlopCtrl.super.ctor(self, properties)
	self:resetData()
end
function luckyFlopCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_LUCKY_FLIP_MODULE, gCmd.REQ_LUCKY_FLIP_INIT, handler(self, self.reqLuckyFlipInitRsp))
	msgCtrl.register(gCmd.CMD_LUCKY_FLIP_MODULE, gCmd.REQ_LUCKY_FLIP_LOTTERY, handler(self, self.reqLuckyFlipLotteryRsp))
	msgCtrl.register(gCmd.CMD_LUCKY_FLIP_MODULE, gCmd.REQ_LUCKY_FLIP_RECORD, handler(self, self.reqLuckyFlipRecordRsp))
	msgCtrl.register(gCmd.CMD_LUCKY_FLIP_MODULE, gCmd.REQ_LUCKY_FLIP_LUCKY_NUM_RANK, handler(self, self.reqLuckyFlipLuckyRankRsp))
	msgCtrl.register(gCmd.CMD_LUCKY_FLIP_MODULE, gCmd.REQ_LUCKY_FLIP_LOVE_NUM_RANK, handler(self, self.reqLuckyFlipLoveRankRsp))
	self:registerNotify()
end
function luckyFlopCtrl:Logout()
	luckyFlopCtrl.super.Logout(self)
	self:resetData()
end
function luckyFlopCtrl:resetData()
	self.loveNum = 0
	self.lottoryScore = 0
end
function luckyFlopCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CKY_FLIP, handler(self, self.notifyHandler))
end
function luckyFlopCtrl:notifyHandler(event)
	dump(event.data, "luckyFlopCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.type == "refreshData" then
			print("luckyFlopCtrl:notifyHandler-refreshData")
			self.lottoryScore = v.data and v.data.lottoryScore or 0
			self.loveNum = v.data and v.data.loveNum or 0
			_ENV = "luckyFlopCtrl:notifyHandler-refreshData"
			;("luckyFlopCtrl:notifyHandler-refreshData").msg = "MESSAGE_LUCKY_FLOP_REFRESH_SUCCESS"
			;("luckyFlopCtrl:notifyHandler-refreshData").subMsg = "notify"
			SoraDSendMessage("luckyFlopCtrl:notifyHandler-refreshData")
		end
	end
end
function luckyFlopCtrl:reqLuckyFlipInit()
	serverproxy:Request(gCmd.CMD_LUCKY_FLIP_MODULE, gCmd.REQ_LUCKY_FLIP_INIT)
end
function luckyFlopCtrl:reqLuckyFlipLottery(data)
	serverproxy:Request(gCmd.CMD_LUCKY_FLIP_MODULE, gCmd.REQ_LUCKY_FLIP_LOTTERY, data)
end
function luckyFlopCtrl:reqLuckyFlipRecord()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LUCKY_FLIP_MODULE, gCmd.REQ_LUCKY_FLIP_RECORD, nil)
end
function luckyFlopCtrl:reqLuckyFlipLuckyRank()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LUCKY_FLIP_MODULE, gCmd.REQ_LUCKY_FLIP_LUCKY_NUM_RANK, nil)
end
function luckyFlopCtrl:reqLuckyFlipLoveRank()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LUCKY_FLIP_MODULE, gCmd.REQ_LUCKY_FLIP_LOVE_NUM_RANK, nil)
end
function luckyFlopCtrl:reqLuckyFlipInitRsp(content)
	dump(content, "luckyFlopCtrl:reqLuckyFlipInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.lottoryScore = content.rspdata and content.rspdata.lottoryScore or 0
		self.loveNum = content.rspdata and content.rspdata.loveNum or 0
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_LUCKY_FLOP_REFRESH_SUCCESS"
		gErrDef.Err_None.subMsg = "init"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function luckyFlopCtrl:reqLuckyFlipLotteryRsp(content)
	dump(content, "luckyFlopCtrl:reqLuckyFlipLotteryRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_LUCKY_FLOP_REFRESH_SUCCESS"
		gErrDef.Err_None.subMsg = "lottery"
		gErrDef.Err_None.luckyNumbers = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function luckyFlopCtrl:reqLuckyFlipRecordRsp(content)
	dump(content, "luckyFlopCtrl:reqLuckyFlipRecordRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_LUCKY_FLOP_REFRESH_SUCCESS"
		gErrDef.Err_None.subMsg = "record"
		gErrDef.Err_None.record = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function luckyFlopCtrl:reqLuckyFlipLuckyRankRsp(content)
	dump(content, "luckyFlopCtrl:reqLuckyFlipLuckyRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_LUCKY_FLOP_REFRESH_SUCCESS"
		gErrDef.Err_None.subMsg = "rank"
		gErrDef.Err_None.infoData = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function luckyFlopCtrl:reqLuckyFlipLoveRankRsp(content)
	dump(content, "luckyFlopCtrl:reqLuckyFlipLoveRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_LUCKY_FLOP_REFRESH_SUCCESS"
		gErrDef.Err_None.subMsg = "rank"
		gErrDef.Err_None.infoData = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function luckyFlopCtrl:getLoveNum()
	return self.loveNum or 0
end
function luckyFlopCtrl:getLottoryScore()
	return self.lottoryScore or 0
end
return luckyFlopCtrl
