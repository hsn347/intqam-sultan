local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local mermaidGiftCtrl = class("mermaidGiftCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local constantRead = include("constantRead")
function mermaidGiftCtrl:ctor(properties)
	mermaidGiftCtrl.super.ctor(self, properties)
	self.giftFlipNum = constantRead.getConstValue("MERMAID_GIFT_FILPNUM", 10)
	self.giftCharNum = constantRead.getConstValue("MERMAID_GIFT_CHARMNUM", 2500)
	self.giftNum = constantRead.getConstValue("MERMAID_GIFT_NUM", 5)
	self:resetData()
end
function mermaidGiftCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MERMAID_GIFT_SWAP, handler(self, self.reqMermaidGiftSwapRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MERMAID_GIFT_HISTORY, handler(self, self.reqMermaidGiftHistoryRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MERMAID_GIFT_LUCK_RANK, handler(self, self.reqMermaidGiftLuckyRankRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MERMAID_GIFT_SCORE_RANK, handler(self, self.reqMermaidGiftScoreRankRsp))
	self:registerNotify()
end
function mermaidGiftCtrl:getReceiveStatusAndNum()
	return false, 0
end
function mermaidGiftCtrl:initClientData(data)
	dump(data, "==mermaidGiftCtrl:initClientData==", 10)
	if not data then
		return
	end
	self.score = data.score
	self.presentVal = data.presentVal
	self.maxLuckNum = data.maxLuckNum
end
function mermaidGiftCtrl:Logout()
	mermaidGiftCtrl.super.Logout(self)
	self:resetData()
end
function mermaidGiftCtrl:resetData()
	self.score = 0
	self.presentVal = 0
	self.maxLuckNum = 0
end
function mermaidGiftCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.MERMAID_GIFT_ACTIVITY, handler(self, self.notifyHandler))
end
function mermaidGiftCtrl:notifyHandler(event)
	dump(event.data, "mermaidGiftCtrl:notifyHandler", 10)
	for _, content in pairs(event.data) do
		if content then
			self:initClientData(content)
			_ENV = self
			self.msg = "MESSAGE_MERMAID_GIFT_REFRESH_SUCCESS"
			SoraDSendMessage(self)
		end
	end
end
function mermaidGiftCtrl:reqMermaidGiftInit()
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	activityTaskComponentCtrl:sendReqInit()
end
function mermaidGiftCtrl:reqMermaidGiftSwap(isTen)
	serverproxy = nil
	;(nil).isTen = isTen
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MERMAID_GIFT_SWAP, nil)
end
function mermaidGiftCtrl:reqMermaidGiftHistory()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MERMAID_GIFT_HISTORY, nil)
end
function mermaidGiftCtrl:reqMermaidGiftLuckyRank()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MERMAID_GIFT_LUCK_RANK, nil)
end
function mermaidGiftCtrl:reqMermaidGiftScoreRank()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MERMAID_GIFT_SCORE_RANK, nil)
end
function mermaidGiftCtrl:reqMermaidGiftSwapRsp(content)
	dump(content, "mermaidGiftCtrl:reqMermaidGiftSwap(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_MERMAID_GIFT_SWAP"
		self.result = content.rspdata.result
		SoraDSendMessage(self)
	end
end
function mermaidGiftCtrl:reqMermaidGiftHistoryRsp(content)
	dump(content, "mermaidGiftCtrl:reqMermaidGiftHistoryRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_MERMAID_GIFT_HISTORY"
		gErrDef.Err_None.record = content.rspdata.history
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function mermaidGiftCtrl:reqMermaidGiftLuckyRankRsp(content)
	dump(content, "mermaidGiftCtrl:reqMermaidGiftLuckyRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_MERMAID_GIFT_LUCK_RANK"
		gErrDef.Err_None.rankData = content.rspdata.data
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function mermaidGiftCtrl:reqMermaidGiftScoreRankRsp(content)
	dump(content, "mermaidGiftCtrl:reqMermaidGiftScoreRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_MERMAID_GIFT_SCORE_RANK"
		gErrDef.Err_None.rankData = content.rspdata.data
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function mermaidGiftCtrl:getGiftMinRank()
	return self.giftNum
end
function mermaidGiftCtrl:getFlipNum()
	return self.giftFlipNum
end
function mermaidGiftCtrl:getGiftCharNum()
	return self.giftCharNum
end
function mermaidGiftCtrl:getPresentVal()
	return self.presentVal or 0
end
function mermaidGiftCtrl:getLuckyNum()
	return self.maxLuckNum or 0
end
function mermaidGiftCtrl:getScore()
	return self.score or 0
end
function mermaidGiftCtrl:isScoreEnough(scoreHave, times)
	local flipNum = self.giftFlipNum
	return scoreHave >= tonumber(times) * flipNum
end
return mermaidGiftCtrl
