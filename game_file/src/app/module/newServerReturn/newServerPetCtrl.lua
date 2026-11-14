local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local newServerPetCtrl = class("newServerPetCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function newServerPetCtrl:ctor(properties)
	newServerPetCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.VICIOUS_PET_ACTIVITY
	self:resetData()
end
function newServerPetCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_VICIOUS_PET_MODULE, gCmd.REQ_VICIOUS_PET_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_VICIOUS_PET_MODULE, gCmd.REQ_VICIOUS_PET_ADOPT, handler(self, self.reqAdoptRsp))
	msgCtrl.register(gCmd.CMD_VICIOUS_PET_MODULE, gCmd.REQ_VICIOUS_PET_UPGRADE, handler(self, self.reqUpgradeRsp))
	msgCtrl.register(gCmd.CMD_VICIOUS_PET_MODULE, gCmd.REQ_VICIOUS_PET_PATROL, handler(self, self.reqPatrolRsp))
	msgCtrl.register(gCmd.CMD_VICIOUS_PET_MODULE, gCmd.REQ_VICIOUS_PET_RECEIVE_PATROL_REWARD, handler(self, self.reqReceivePatrolRsp))
	msgCtrl.register(gCmd.CMD_VICIOUS_PET_MODULE, gCmd.REQ_VICIOUS_PET_BUY_GIFT, handler(self, self.reqBuyGiftRsp))
	self:registerNotify()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	backpackCtrl:addItemChangeEvent(self.itemIDFeed, handler(self, self.notifyItemCount))
	backpackCtrl:addItemChangeEvent(self.itemIDWalk, handler(self, self.notifyItemCount))
	self:sendReqInit()
end
function newServerPetCtrl:Logout()
	newServerPetCtrl.super.Logout(self)
	self:resetData()
end
function newServerPetCtrl:resetData()
	_ENV = nil
	;(nil).curPetExp = 0
	;(nil).curPetLv = 1
	;(nil).isAdopt = false
	;(nil).isUnlock = false
	self.initData, (nil).patrolEndtime = nil, -1
	self.activityID = gActivityTimeActivityID.VICIOUS_PET_ACTIVITY
	self.itemIDFeed = 848001
	self.itemIDWalk = 849001
	self.itemFeedCost = 1
	self.itemWalkCost = 1
	self.itemFeedCount = 0
	self.itemWalkCount = 0
end
function newServerPetCtrl:setData(initData)
	if initData then
		self.initData = initData
	end
end
function newServerPetCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.VICIOUS_PET, handler(self, self.notifyUpdate))
end
function newServerPetCtrl:notifyUpdate(event)
	dump(event.data, "newServerPetCtrl:notifyUpdate", 10)
	for k, v in ipairs(event.data) do
		local prePatrolEndtime = self.initData.patrolEndtime
		self:setData(v.initData)
		if prePatrolEndtime ~= self.initData.patrolEndtime then
			_ENV = self
			self.msg = "MESSAGE_SERVER_HONOR_PET_REFRESH"
			self.name = "patrol"
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			self.eventID = self.activityID
			SoraDSendMessage(self)
		end
		if v.reward then
			_ENV = self
			self.msg = "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_SERVER_HONOR_PET_REFRESH"
			self.name = "unlock"
			self.reward = v.reward
			SoraDSendMessage(self)
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_NEWS_ERVER_BACK_RED_POINT"
	SoraDSendMessage(ipairs(event.data))
end
function newServerPetCtrl:notifyItemCount(...)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_HONOR_PET_ITEM"
	SoraDSendMessage(nil)
end
function newServerPetCtrl:sendReqInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_VICIOUS_PET_MODULE, gCmd.REQ_VICIOUS_PET_INIT, nil)
end
function newServerPetCtrl:sendReqAdopt()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_VICIOUS_PET_MODULE, gCmd.REQ_VICIOUS_PET_ADOPT, nil)
end
function newServerPetCtrl:sendReqUpgrade()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_VICIOUS_PET_MODULE, gCmd.REQ_VICIOUS_PET_UPGRADE, nil)
end
function newServerPetCtrl:sendReqPatrol()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_VICIOUS_PET_MODULE, gCmd.REQ_VICIOUS_PET_PATROL, nil)
end
function newServerPetCtrl:sendReqReceivePatrol()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_VICIOUS_PET_MODULE, gCmd.REQ_VICIOUS_PET_RECEIVE_PATROL_REWARD, nil)
end
function newServerPetCtrl:sendReqBuyGift(rid)
	serverproxy = nil
	local (nil).rid, data = rid, nil
	serverproxy:Request(gCmd.CMD_VICIOUS_PET_MODULE, gCmd.REQ_VICIOUS_PET_BUY_GIFT, data)
end
function newServerPetCtrl:reqInitRsp(content)
	dump(content, "newServerPetCtrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
		newStartMainCtrl:setActInitFlag(self.activityID)
		self:setData(content.rspdata.initData)
		_ENV = self
		self.msg = "MESSAGE_SERVER_HONOR_PET_INIT"
		SoraDSendMessage(self)
	end
end
function newServerPetCtrl:reqAdoptRsp(content)
	dump(content, "newServerPetCtrl:reqAdoptRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self:setData(content.rspdata.initData)
		_ENV = self
		self.msg = "MESSAGE_SERVER_HONOR_PET_INIT"
		SoraDSendMessage(self)
		if rspdata.reward then
			SoraDMailGainItems(rspdata.reward, true)
		end
	end
end
function newServerPetCtrl:reqUpgradeRsp(content)
	dump(content, "newServerPetCtrl:reqUpgradeRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		local preLv = self.initData.curPetLv
		self:setData(content.rspdata.initData)
		if preLv < self.initData.curPetLv then
			_ENV = self
			self.msg = "MESSAGE_SERVER_HONOR_PET_REFRESH"
			self.name = "upgrade"
			self.reward = rspdata.reward
			SoraDSendMessage(self)
		else
			_ENV = self
			self.msg = "MESSAGE_SERVER_HONOR_PET_REFRESH"
			self.name = "exp"
			SoraDSendMessage(self)
		end
	end
end
function newServerPetCtrl:reqPatrolRsp(content)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.initData)
		_ENV = self
		self.msg = "MESSAGE_SERVER_HONOR_PET_REFRESH"
		self.name = "patrol"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_NEWS_ERVER_BACK_RED_POINT"
		SoraDSendMessage(self)
	end
end
function newServerPetCtrl:reqReceivePatrolRsp(content)
	dump(content, "newServerPetCtrl:reqReceivePatrolRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self:setData(content.rspdata.initData)
		if rspdata.reward then
			SoraDMailGainItems(rspdata.reward, true)
		end
		_ENV = rspdata.reward
		rspdata.reward.msg = "MESSAGE_SERVER_HONOR_PET_REFRESH"
		rspdata.reward.name = "patrol"
		SoraDSendMessage(rspdata.reward)
		_ENV = rspdata.reward
		rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		rspdata.reward.eventID = self.activityID
		SoraDSendMessage(rspdata.reward)
	end
end
function newServerPetCtrl:reqBuyGiftRsp(content)
	dump(content, "newServerPetCtrl:reqBuyGiftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local giftid = content.data.rid
		local orderID = content.rspdata.orderID
		paymentManager.purchase(giftid, orderID)
	end
end
function newServerPetCtrl:getInitData(...)
	return self.initData
end
function newServerPetCtrl:getReceiveStatusAndNum()
	if self:showPetNeedRedP() then
		return true, 1
	end
	return false, 0
end
function newServerPetCtrl:showPetNeedRedP(...)
	return self:showFeedRedP() or self:showWalkRedP()
end
function newServerPetCtrl:showFeedRedP(...)
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	self.itemFeedCount = backpackCtrl:getItemCount(self.itemIDFeed)
	if self.itemFeedCount >= self.itemFeedCost then
		return true
	end
	return false
end
function newServerPetCtrl:showWalkRedP(...)
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	self.itemWalkCount = backpackCtrl:getItemCount(self.itemIDWalk)
	local patrolEndtime = self.initData.patrolEndtime
	if 0 < patrolEndtime then
		return false
	elseif patrolEndtime == 0 then
		return true
	elseif self.itemWalkCount >= self.itemWalkCost then
		return true
	end
	return false
end
function newServerPetCtrl:getItemFeedCost(...)
	return self.itemFeedCost
end
return newServerPetCtrl
