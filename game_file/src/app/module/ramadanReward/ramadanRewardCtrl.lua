local GameModule = include("GameModule")
local ramadanRewardCtrl = class("ramadanRewardCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local json = require("json")
function ramadanRewardCtrl:ctor(properties)
	ramadanRewardCtrl.super.ctor(self, properties)
end
function ramadanRewardCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RAMADAN_MODULE, gCmd.REQ_RECEIVE_CELEBRATE, handler(self, self.getReceiveResp))
	msgCtrl.register(gCmd.CMD_RAMADAN_MODULE, gCmd.REQ_RECEIVE_OPEN_NEW_SERVICE_REWARD, handler(self, self.receiveOpenRewardRsp))
	self:initData()
	self:resetData()
end
function ramadanRewardCtrl:initData()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
end
function ramadanRewardCtrl:resetData()
	self.celebrate, _UPVALUE0_, self.handle_notify = nil, nil, nil
end
function ramadanRewardCtrl:Logout()
	self:resetData()
	ramadanRewardCtrl.super.Logout(self)
end
function ramadanRewardCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.RAMADAN_REWARD, handler(self, self.notifyRamadanReward))
end
function ramadanRewardCtrl:initClientData(data)
	if not data then
		return
	end
	self:registerNotify()
	self.celebrate = data
end
function ramadanRewardCtrl:notifyRamadanReward(event)
	local content = event.data[1]
	if content then
		self.celebrate = content
		if content.openNewService then
		end
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_CELEBRATEGIFT_REFRESH"
		SoraDSendMessage(nil)
	end
end
function ramadanRewardCtrl:getReceiveResp(content)
	if gErrDef.Err_None == content.err then
		self.celebrate.isReceive = content.isReceive
		_ENV = content.isReceive
		content.isReceive.msg = "MESSAGE_MAINCITYVIEW_CELEBRATEGIFT_BACK"
		content.isReceive.err = content.err
		SoraDSendMessage(content.isReceive)
		_ENV = content.isReceive
		content.isReceive.msg = "MESSAGE_MAINCITYVIEW_CELEBRATEGIFT_REFRESH"
		SoraDSendMessage(content.isReceive)
	elseif gErrDef.Err_RANADAN_NOT_IN_TIME == content.err then
		_ENV = content.err
		content.err.msg = "MESSAGE_MAINCITYVIEW_CELEBRATEGIFT_BACK"
		content.err.err = content.err
		SoraDSendMessage(content.err)
	elseif gErrDef.Err_RANADAN_CELEBRATE_RECEIVED == content.err then
		_ENV = content.err
		content.err.msg = "MESSAGE_MAINCITYVIEW_CELEBRATEGIFT_BACK"
		content.err.err = content.err
		SoraDSendMessage(content.err)
	elseif gErrDef.Err_ITEM_COUNT_IS_LIMIT == content.err then
		SoraDShowMsgTip(i18n("notice_0119"))
	end
end
function ramadanRewardCtrl:receiveOpenRewardRsp(content)
	dump(content, "loginRewardCtrl:receiveOpenRewardRsp", 10)
	if content.err == gErrDef.Err_None then
		self.celebrate.receiveActivityRewardStatus = true
		local reward = content.rspdata and content.rspdata.reward
		if reward and next(reward) then
			SoraDMailGainItems(reward, true)
		end
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_MAINCITYVIEW_CELEBRATEGIFT_REFRESH"
	SoraDSendMessage(SoraDMailGainItems)
end
function ramadanRewardCtrl:sendReceiveCelebrate()
	serverproxy:Request(gCmd.CMD_RAMADAN_MODULE, gCmd.REQ_RECEIVE_CELEBRATE)
end
function ramadanRewardCtrl:sendReceiveNewService()
	serverproxy:Request(gCmd.CMD_RAMADAN_MODULE, gCmd.REQ_RECEIVE_OPEN_NEW_SERVICE_REWARD)
end
function ramadanRewardCtrl:getReceiveStatusAndNum()
	return false, -1
end
function ramadanRewardCtrl:getIsReceive()
	return self.celebrate.isReceive
end
function ramadanRewardCtrl:getIsOpen()
	return self.celebrate.isOpen
end
function ramadanRewardCtrl:getReward()
	return self.celebrate.award
end
function ramadanRewardCtrl:getBeginTime()
	return self.celebrate.begintime
end
function ramadanRewardCtrl:getEndTime()
	return self.celebrate.endtime
end
function ramadanRewardCtrl:getReceiveActivityRewardStatus()
	return self.celebrate.receiveActivityRewardStatus
end
function ramadanRewardCtrl:getActivityReward()
	return self.celebrate.activityReward
end
return ramadanRewardCtrl
