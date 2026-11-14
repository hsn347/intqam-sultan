local GameModule = include("GameModule")
local amazingFortuneCtrl = class("amazingFortuneCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function amazingFortuneCtrl:ctor(properties)
	amazingFortuneCtrl.super.ctor(self, properties)
end
function amazingFortuneCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_AMAZING_FORTUNE, gCmd.REQ_AMAZING_FORTUNE_DRAW, handler(self, self.reqDrawRsp))
	msgCtrl.register(gCmd.CMD_AMAZING_FORTUNE, gCmd.REQ_AMAZING_FORTUNE_BUY_GIFT, handler(self, self.reqBuyGiftRsp))
	msgCtrl.register(gCmd.CMD_AMAZING_FORTUNE, gCmd.REQ_AMAZING_FORTUNE_REWARD_LIST, handler(self, self.reqRewardListRsp))
	msgCtrl.register(gCmd.CMD_AMAZING_FORTUNE, gCmd.REQ_AMAZING_INIT_DATA, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_AMAZING_FORTUNE, gCmd.REQ_AMAZING_BUY_LIST, handler(self, self.reqBuyListRsp))
	self:resetData()
	self:registerNotify()
end
function amazingFortuneCtrl:resetData()
	;(nil).buyGiftList, _ENV, _ENV, self.rewardData, _ENV = nil, nil, nil, nil, nil
	;(nil).drawTimes = 0
	self.listInfo, _ENV, self.initData, (nil).opencount = nil, nil, nil, 0
	self.rewardInfo, _ENV, self.hasMore = nil, nil, false
	self.rechargeID = IsArClient and 13370 or 13372
end
function amazingFortuneCtrl:Logout()
	self:resetData()
	amazingFortuneCtrl.super.Logout(self)
end
function amazingFortuneCtrl:initClientData(data)
	if not data then
		return
	end
end
function amazingFortuneCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.AMAZING_FORTUNE, handler(self, self.notifyHandler))
end
function amazingFortuneCtrl:notifyHandler(event)
	for _, content in pairs(event.data) do
		if content then
			local info = content.data
			local giftType = content.type
			if "buyGift" == giftType then
				self.initData.buyGiftList = info.buyGiftList
				if info.success == true then
					paymentManager.loopForFinishTransaction()
					local reward = info.reward
					local mailid = info.mailid
					local rid = info.rid
					_ENV = nil
					_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
					;(nil).result = true
					;(nil).rid = rid
					;(nil).itemList = reward
					;(nil).data, (nil).mailID = nil, mailid
					SoraDSendMessage(nil)
				end
				_ENV = info.mailid
				info.mailid.msg = "MESSAGE_AMAZINGFORTUNE_REFRESH"
				info.mailid.eventName = "reqInitBack"
				SoraDSendMessage(info.mailid)
			elseif "refreshData" == giftType then
				self.initData = content.data
				_ENV = info.mailid
				info.mailid.msg = "MESSAGE_AMAZINGFORTUNE_REFRESH"
				info.mailid.eventName = "reqInitBack"
				SoraDSendMessage(info.mailid)
			end
		end
	end
end
function amazingFortuneCtrl:setAmazingFortuneData(data)
	if data.rewardData then
		for i, v in ipairs(data.rewardData) do
			table.insert(self.rewardData, v)
		end
	end
	if data.initData then
		self.initData = data.initData
	end
	if data.listInfo then
		for i, v in ipairs(data.listInfo) do
			table.insert(self.listInfo, v)
		end
	end
	if data.rewardInfo then
		self.rewardInfo = data.rewardInfo
	end
end
function amazingFortuneCtrl:sendReqDrawMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_AMAZING_FORTUNE, gCmd.REQ_AMAZING_FORTUNE_DRAW, nil)
end
function amazingFortuneCtrl:sendReqBuyGiftMsg(rechargeID)
	serverproxy = nil
	;(nil).rechargeID = rechargeID
	serverproxy:Request(gCmd.CMD_AMAZING_FORTUNE, gCmd.REQ_AMAZING_FORTUNE_BUY_GIFT, nil)
end
function amazingFortuneCtrl:sendReqRewardListMsg(beginIndex, count)
	serverproxy = nil
	;(nil).beginIndex = beginIndex
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_AMAZING_FORTUNE, gCmd.REQ_AMAZING_FORTUNE_REWARD_LIST, nil)
end
function amazingFortuneCtrl:sendReqInitMsg()
	serverproxy:Request(gCmd.CMD_AMAZING_FORTUNE, gCmd.REQ_AMAZING_INIT_DATA)
end
function amazingFortuneCtrl:sendReqBuyListMsg(beginIndex, count)
	serverproxy = nil
	;(nil).beginIndex = beginIndex
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_AMAZING_FORTUNE, gCmd.REQ_AMAZING_BUY_LIST, nil)
end
function amazingFortuneCtrl:reqDrawRsp(content)
	if content.err == gErrDef.Err_None then
		self:setAmazingFortuneData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_AMAZINGFORTUNE_REFRESH"
		self.eventName = "ResultPopView"
		SoraDSendMessage(self)
	end
end
function amazingFortuneCtrl:reqBuyGiftRsp(content)
	if content.err == gErrDef.Err_None then
		local giftid = content.data.rechargeID
		local orderID = content.rspdata.orderID
		paymentManager.purchase(giftid, orderID)
	end
end
function amazingFortuneCtrl:reqRewardListRsp(content)
	dump(content, "amazingFortuneCtrl:reqRewardListRsp===", 10)
	if content.err == gErrDef.Err_None then
		self:setAmazingFortuneData(content.rspdata)
		self.hasMore = content.rspdata.hasMore
		_ENV = self
		self.msg = "MESSAGE_AMAZINGFORTUNE_REFRESH"
		self.eventName = "RecordPopView"
		SoraDSendMessage(self)
	end
end
function amazingFortuneCtrl:reqInitRsp(content)
	dump(content, "amazingFortuneCtrl:reqInitRsp===", 10)
	if content.err == gErrDef.Err_None then
		self:setAmazingFortuneData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_AMAZINGFORTUNE_REFRESH"
		self.eventName = "reqInitBack"
		SoraDSendMessage(self)
	end
end
function amazingFortuneCtrl:reqBuyListRsp(content)
	dump(content, "amazingFortuneCtrl:reqBuyListRsp===", 10)
	if content.err == gErrDef.Err_None then
		self:setAmazingFortuneData(content.rspdata)
		self.hasMore = content.rspdata.hasMore
		_ENV = self
		self.msg = "MESSAGE_AMAZINGFORTUNE_REFRESH"
		self.eventName = "BuyListPopView"
		SoraDSendMessage(self)
	end
end
function amazingFortuneCtrl:getBuyListHasMore(...)
	return self.hasMore
end
function amazingFortuneCtrl:initRewardsConfig(...)
	if not self.rewardsConfig then
		self.finalRewardsConfig, _ENV, self.rewardsConfig, _ENV = self.rewardsConfig, self.rewardsConfig, self.rewardsConfig, self.rewardsConfig
		local config = require_data("recharge_onecoin_rewards", true)
		for i, v in ipairs(config.data) do
			if 1 == v.type then
				_ENV = v.type
				v.type.id = v.rewards[1]
				v.type.count = v.rewards[2]
				local v.type.isActive, reward = v.isActive == 1, v.type
				table.insert(self.rewardsConfig, reward)
			elseif 2 == v.type then
				_UPVALUE2_ = self.rewardsConfig
				self.rewardsConfig[1] = "id"
				self.rewardsConfig[2] = "count"
				self.finalRewardsConfig = serviceFunctions.tableFormat(v.rewards, self.rewardsConfig)
			end
		end
	end
end
function amazingFortuneCtrl:getRewardsList()
	self:initRewardsConfig()
	return self.rewardsConfig
end
function amazingFortuneCtrl:getFinalRewardsList()
	self:initRewardsConfig()
	return self.finalRewardsConfig
end
function amazingFortuneCtrl:getRewardRecordData(...)
	return self.rewardData
end
function amazingFortuneCtrl:resetRewardRecordData(...)
	self.rewardData, _UPVALUE0_ = nil, nil
end
function amazingFortuneCtrl:getRewardInfo(...)
	return self.rewardInfo
end
function amazingFortuneCtrl:getInitData(...)
	self.initData.drawTimes = self.initData.drawTimes or 0
	return self.initData
end
function amazingFortuneCtrl:getListInfo(...)
	return self.listInfo
end
function amazingFortuneCtrl:resetListInfo(...)
	self.listInfo, _UPVALUE0_ = nil, nil
end
function amazingFortuneCtrl:getRechargeID(...)
	return self.rechargeID
end
return amazingFortuneCtrl
