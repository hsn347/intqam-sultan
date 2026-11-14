local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local flowerSysCtrl = class("flowerSysCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function flowerSysCtrl:ctor(properties)
	flowerSysCtrl.super.ctor(self, properties)
	self.handle_notify = nil
	self:resetData()
end
function flowerSysCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FLOWER_SYS_MODULE, gCmd.REQ_FLOWER_SYS_GIFT, handler(self, self.getGiftRsp))
	msgCtrl.register(gCmd.CMD_FLOWER_SYS_MODULE, gCmd.REQ_FLOWER_SYS_BUY, handler(self, self.getBuyRsp))
	msgCtrl.register(gCmd.CMD_FLOWER_SYS_MODULE, gCmd.REQ_FLOWER_HISTORY, handler(self, self.getHistoryRsp))
	msgCtrl.register(gCmd.CMD_FLOWER_SYS_MODULE, gCmd.REQ_FLOWER_OPEN_PAGE, handler(self, self.getOpenPageRsp))
	self:updateDataChangeInfo()
end
function flowerSysCtrl:sendGift(mGiftUserID, mFlowerID, mFlowerNum)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_FLOWER_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_FLOWER_SYS_GIFT, gCmd.REQ_FLOWER_SYS_GIFT
	gCmd.REQ_FLOWER_SYS_GIFT.giftUserID = mGiftUserID
	gCmd.REQ_FLOWER_SYS_GIFT.flowerID = mFlowerID
	;(nil).data, gCmd.REQ_FLOWER_SYS_GIFT.flowerNum = gCmd.REQ_FLOWER_SYS_GIFT, mFlowerNum
	local msg
	serverproxy:SendMsg(msg)
end
function flowerSysCtrl:sendBuy(mGiftUserID, mFlowerID, mFlowerNum)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_FLOWER_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_FLOWER_SYS_BUY, gCmd.REQ_FLOWER_SYS_BUY
	gCmd.REQ_FLOWER_SYS_BUY.giftUserID = mGiftUserID
	gCmd.REQ_FLOWER_SYS_BUY.flowerID = mFlowerID
	;(nil).data, gCmd.REQ_FLOWER_SYS_BUY.flowerNum = gCmd.REQ_FLOWER_SYS_BUY, mFlowerNum
	local msg
	serverproxy:SendMsg(msg)
end
function flowerSysCtrl:sendHistory(historyType)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_FLOWER_SYS_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_FLOWER_HISTORY, gCmd.REQ_FLOWER_HISTORY
	;(nil).data, gCmd.REQ_FLOWER_HISTORY.historyType = gCmd.REQ_FLOWER_HISTORY, historyType
	local msg
	serverproxy:SendMsg(msg)
end
function flowerSysCtrl:sendOpenPage()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_FLOWER_SYS_MODULE
	local (nil).subcmd, msg = gCmd.REQ_FLOWER_OPEN_PAGE, nil
	serverproxy:SendMsg(msg)
end
function flowerSysCtrl:resetData()
	self.historyTable, _UPVALUE0_, self.dataTable, _UPVALUE0_ = nil, nil, nil, nil
end
function flowerSysCtrl:getData()
	return self.dataTable
end
function flowerSysCtrl:getHistoryData()
	return self.historyTable
end
function flowerSysCtrl:initClientData(data)
end
function flowerSysCtrl:Logout()
	flowerSysCtrl.super.Logout(self)
	self:resetData()
end
function flowerSysCtrl:getGiftRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
		_ENV = content.err
		content.err.msg = "MESSAGE_LORDINFO_FLOWER_NUM"
		content.err.id = content.data.flowerID
		content.err.num = content.data.flowerNum
		SoraDSendMessage(content.err)
	elseif content.err == gErrDef.Err_FLOWER_SYS_MAX_LIMIT then
		SoraDShowMsgTip(i18n("common_text_2427"))
	elseif content.err == gErrDef.Err_NOT_IN_THIS_KINGDOM then
		SoraDShowMsgTip(i18n("common_text_2413"))
	end
end
function flowerSysCtrl:updateDataChangeInfo()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.FLOWER_SYS_DATA_CHANGE, handler(self, self.notifyDataChange))
end
function flowerSysCtrl:getBuyRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
		_ENV = content.err
		content.err.msg = "MESSAGE_LORDINFO_FLOWER_NUM"
		content.err.id = content.data.flowerID
		content.err.num = content.data.flowerNum
		SoraDSendMessage(content.err)
	elseif content.err == gErrDef.Err_FLOWER_SYS_MAX_LIMIT then
		SoraDShowMsgTip(i18n("common_text_2427"))
	elseif content.err == gErrDef.Err_NOT_IN_THIS_KINGDOM then
		SoraDShowMsgTip(i18n("common_text_2413"))
	end
end
function flowerSysCtrl:getHistoryRsp(content)
	if gErrDef.Err_None == content.err and content.rspdata then
		if not content.rspdata.history then
			_ENV = content.rspdata.history
		end
		self.historyTable = content.rspdata.history
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_LORDINFO_FLOWER_HISTORY"
	SoraDSendMessage(content.err)
end
function flowerSysCtrl:getOpenPageRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		if lordInfoCtrl then
			lordInfoCtrl:updateFlowerInfo(self.dataTable.giftednums, self.dataTable.curRank, self.dataTable.preRank)
		end
		_ENV = lordInfoCtrl
		lordInfoCtrl.msg = "MESSAGE_LORDINFO_FLOWER_INFO"
		SoraDSendMessage(lordInfoCtrl)
	end
end
function flowerSysCtrl:notifyDataChange(respone)
	local tmpData = respone.data[1]
	if tmpData then
		self.dataTable = tmpData
		if tmpData.timeup then
			print("-- 鲜花排行榜刷新")
			local gametop = gModuleMgr.getObject("gametop")
			local rankingsCtrl = gametop.playertop_:getModule("rankingsCtrl")
			rankingsCtrl:getRankings(lordRankingsDef.flowerNum)
		end
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		if lordInfoCtrl then
			lordInfoCtrl:updateFlowerInfo(self.dataTable.giftednums, self.dataTable.curRank, self.dataTable.preRank)
		end
		_ENV = lordInfoCtrl
		lordInfoCtrl.msg = "MESSAGE_LORDINFO_FLOWER_INFO"
		SoraDSendMessage(lordInfoCtrl)
	end
end
return flowerSysCtrl
