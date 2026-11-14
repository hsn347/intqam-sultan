local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local friendPetCtrl = class("friendPetCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function friendPetCtrl:ctor(properties)
	friendPetCtrl.super.ctor(self, properties)
	self:resetData()
end
function friendPetCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FRIEND_PET_MODULE, gCmd.REQ_FRIEND_PET_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_FRIEND_PET_MODULE, gCmd.REQ_FRIEND_PET_ADOPT, handler(self, self.reqAdoptRsp))
	msgCtrl.register(gCmd.CMD_FRIEND_PET_MODULE, gCmd.REQ_FRIEND_PET_UPGRADE, handler(self, self.reqUpgradeRsp))
	msgCtrl.register(gCmd.CMD_FRIEND_PET_MODULE, gCmd.REQ_FRIEND_PET_PATROL, handler(self, self.reqPatrolRsp))
	msgCtrl.register(gCmd.CMD_FRIEND_PET_MODULE, gCmd.REQ_FRIEND_PET_RECEIVE_PATROL_REWARD, handler(self, self.reqReceivePatrolRsp))
	msgCtrl.register(gCmd.CMD_FRIEND_PET_MODULE, gCmd.REQ_FRIEND_PET_BUY_GIFT, handler(self, self.reqBuyGiftRsp))
	self:registerNotify()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	backpackCtrl:addItemChangeEvent(self.itemIDFeed, handler(self, self.notifyItemCount))
	backpackCtrl:addItemChangeEvent(self.itemIDWalk, handler(self, self.notifyItemCount))
	self:sendReqInit()
end
function friendPetCtrl:Logout()
	friendPetCtrl.super.Logout(self)
	self:resetData()
end
function friendPetCtrl:resetData()
	_UPVALUE0_ = nil
	;(nil).curPetExp = 0
	;(nil).curPetLv = 1
	;(nil).isAdopt = false
	;(nil).isUnlock = false
	self.initData, (nil).patrolEndtime = nil, -1
	self.itemIDFeed = 820701
	self.itemIDWalk = 820801
	self.itemFeedCost = 5
	self.itemWalkCost = 1
	self.itemFeedCount = 0
	self.itemWalkCount = 0
end
function friendPetCtrl:setData(initData)
	if initData then
		self.initData = initData
	end
end
function friendPetCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.FRIEND_PET, handler(self, self.notifyUpdate))
end
function friendPetCtrl:notifyUpdate(event)
	dump(event.data, "friendPetCtrl:notifyUpdate", 10)
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
end
function friendPetCtrl:notifyItemCount(...)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_HONOR_PET_ITEM"
	SoraDSendMessage(nil)
end
function friendPetCtrl:sendReqInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FRIEND_PET_MODULE, gCmd.REQ_FRIEND_PET_INIT, nil)
end
function friendPetCtrl:sendReqAdopt()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FRIEND_PET_MODULE, gCmd.REQ_FRIEND_PET_ADOPT, nil)
end
function friendPetCtrl:sendReqUpgrade()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FRIEND_PET_MODULE, gCmd.REQ_FRIEND_PET_UPGRADE, nil)
end
function friendPetCtrl:sendReqPatrol()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FRIEND_PET_MODULE, gCmd.REQ_FRIEND_PET_PATROL, nil)
end
function friendPetCtrl:sendReqReceivePatrol()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FRIEND_PET_MODULE, gCmd.REQ_FRIEND_PET_RECEIVE_PATROL_REWARD, nil)
end
function friendPetCtrl:sendReqBuyGift(rid)
	serverproxy = nil
	local (nil).rid, data = rid, nil
	serverproxy:Request(gCmd.CMD_FRIEND_PET_MODULE, gCmd.REQ_FRIEND_PET_BUY_GIFT, data)
end
function friendPetCtrl:reqInitRsp(content)
	dump(content, "friendPetCtrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.initData)
		_ENV = self
		self.msg = "MESSAGE_SERVER_HONOR_PET_INIT"
		SoraDSendMessage(self)
	end
end
function friendPetCtrl:reqAdoptRsp(content)
	dump(content, "friendPetCtrl:reqAdoptRsp(content)", 10)
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
function friendPetCtrl:reqUpgradeRsp(content)
	dump(content, "friendPetCtrl:reqUpgradeRsp(content)", 10)
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
function friendPetCtrl:reqPatrolRsp(content)
	dump(content, "friendPetCtrl:reqPatrolRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.initData)
		_ENV = self
		self.msg = "MESSAGE_SERVER_HONOR_PET_REFRESH"
		self.name = "patrol"
		SoraDSendMessage(self)
	end
end
function friendPetCtrl:reqReceivePatrolRsp(content)
	dump(content, "friendPetCtrl:reqReceivePatrolRsp(content)", 10)
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
		SoraDSendMessage(rspdata.reward)
	end
end
function friendPetCtrl:reqBuyGiftRsp(content)
	dump(content, "friendPetCtrl:reqBuyGiftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local giftid = content.data.rid
		local orderID = content.rspdata.orderID
		paymentManager.purchase(giftid, orderID)
	end
end
function friendPetCtrl:getInitData(...)
	return self.initData
end
function friendPetCtrl:showPetNeedRedP(...)
	return self:showFeedRedP() or self:showWalkRedP()
end
function friendPetCtrl:showFeedRedP(...)
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	self.itemFeedCount = backpackCtrl:getItemCount(self.itemIDFeed)
	if self.itemFeedCount >= self.itemFeedCost then
		return true
	end
	return false
end
function friendPetCtrl:showWalkRedP(...)
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
function friendPetCtrl:getItemFeedCost(...)
	return self.itemFeedCost
end
return friendPetCtrl
