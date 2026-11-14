local gametop = gModuleMgr.getObject("gametop")
local GameModule = include("GameModule")
local spiritualGiftCtrl = class("spiritualGiftCtrl", GameModule)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function spiritualGiftCtrl:ctor(properties)
	spiritualGiftCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.SPIRITUAL_GIFT
end
function spiritualGiftCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NAFU_MODULE, gCmd.REQ_NAFU_INIT, handler(self, self.reqInitSpiritualInfoRsp))
	msgCtrl.register(gCmd.CMD_NAFU_MODULE, gCmd.REQ_NAFU_DRAW, handler(self, self.reqDrawLotteryRsp))
	msgCtrl.register(gCmd.CMD_NAFU_MODULE, gCmd.REQ_NAFU_BUY_TICKET, handler(self, self.reqBuyGiftRollRsp))
	msgCtrl.register(gCmd.CMD_NAFU_MODULE, gCmd.REQ_NAFU_GET_RECORD, handler(self, self.reqGiftRecordRsp))
	msgCtrl.register(gCmd.CMD_NAFU_MODULE, gCmd.REQ_NAFU_GET_RANK, handler(self, self.reqGiftRankRsp))
	self:resetData()
	self:registerNotify()
end
function spiritualGiftCtrl:resetData()
	self.activityData = nil
	self.drawData = nil
	self.recordData = nil
	self.selfRankData = nil
	self.allRankData = nil
	self.poolGold = 0
end
function spiritualGiftCtrl:resetDrawCount()
	if self.activityData then
		self.activityData.drawCount = 0
		_ENV = nil
		;(nil).msg = "MESSAGE_SPIRITUAL_CROSS_DAY"
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:spiritualGiftView:timeNotice~bool", false, nil)
	end
end
function spiritualGiftCtrl:Logout()
	self:resetData()
	spiritualGiftCtrl.super.Logout(self)
end
function spiritualGiftCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NOTIFY_NAFU, handler(self, self.notifyHandler))
end
function spiritualGiftCtrl:notifyHandler(event)
	dump(event.data, "spiritualGiftCtrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
		if content then
		end
	end
end
function spiritualGiftCtrl:reqInitSpiritualInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_NAFU_MODULE, gCmd.REQ_NAFU_INIT, data)
end
function spiritualGiftCtrl:reqDrawLottery(drawCount)
	serverproxy = nil
	local (nil).drawCount, data = drawCount, nil
	serverproxy:Request(gCmd.CMD_NAFU_MODULE, gCmd.REQ_NAFU_DRAW, data)
end
function spiritualGiftCtrl:reqBuyGiftRoll(buyCount)
	serverproxy = nil
	local (nil).buyCount, data = buyCount, nil
	serverproxy:Request(gCmd.CMD_NAFU_MODULE, gCmd.REQ_NAFU_BUY_TICKET, data)
end
function spiritualGiftCtrl:reqGiftRecord()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_NAFU_MODULE, gCmd.REQ_NAFU_GET_RECORD, data)
end
function spiritualGiftCtrl:reqGiftRank()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_NAFU_MODULE, gCmd.REQ_NAFU_GET_RANK, data)
end
function spiritualGiftCtrl:reqInitSpiritualInfoRsp(content)
	dump(content, "spiritualGiftCtrl:reqInitSpiritualInfoRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata
		self.poolGold = content.groupinfo.gold
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SPIRITUAL_INIT_BACK"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function spiritualGiftCtrl:reqBuyGiftRollRsp(content)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SPIRITUAL_BUY_ROLL_BACK"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function spiritualGiftCtrl:reqDrawLotteryRsp(content)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata
		self.drawData = content.drawdata
		self.poolGold = self.drawData[#self.drawData].curGold
		if self.drawData[#self.drawData].luckyNumber == 888 then
			self.poolGold = self.drawData[#self.drawData].initGold
		end
		_ENV = #self.drawData
		;(#self.drawData).msg = "MESSAGE_SPIRITUAL_DRAW_BACK"
		;(#self.drawData).drawData = self.drawData
		SoraDSendMessage(#self.drawData)
	end
end
function spiritualGiftCtrl:reqGiftRecordRsp(content)
	dump(content, "spiritualGiftCtrl:reqGiftRecordRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.recordData = nil
		self.recordData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SPIRITUAL_RECORD_BACK"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function spiritualGiftCtrl:reqGiftRankRsp(content)
	if content.err == gErrDef.Err_None then
		self.selfRankData = content.selfRank
		self.allRankData = content.ranks
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SPIRITUAL_RANK_BACK"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function spiritualGiftCtrl:getPoolPrizeType()
	local poolPrizeType = 1
	if self.activityData.topPriceTimes > 0 then
		poolPrizeType = 2
	end
	return poolPrizeType
end
function spiritualGiftCtrl:getRemainTopPrizeNum()
	return self.activityData.topPriceTimes
end
function spiritualGiftCtrl:getPoolGold()
	return self.poolGold
end
function spiritualGiftCtrl:getGiftRollNum()
	return self.activityData.ticketNum
end
function spiritualGiftCtrl:getAlreadyDrawNum()
	return self.activityData.drawCount
end
function spiritualGiftCtrl:getPlayerScore()
	return self.activityData.totalScore
end
function spiritualGiftCtrl:getOpenAreaList()
	return self.activityData.kids
end
function spiritualGiftCtrl:getPlayerRecordData()
	return self.recordData
end
function spiritualGiftCtrl:getSelfRankData()
	return self.selfRankData
end
function spiritualGiftCtrl:getAllRankData()
	return self.allRankData
end
return spiritualGiftCtrl
