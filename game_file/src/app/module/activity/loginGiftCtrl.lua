local GameModule = include("GameModule")
local loginGiftCtrl = class("loginGiftCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function loginGiftCtrl:ctor(properties)
	loginGiftCtrl.super.ctor(self, properties)
end
function loginGiftCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_LOGIN_GIFT_MODULE, gCmd.REQ_LOGIN_GIFT_CLAIM, handler(self, self.reqClaimGiftRsp))
	self:resetData()
end
function loginGiftCtrl:resetData()
	self.loginData, _UPVALUE0_, self.claimedGifts, _UPVALUE0_ = nil, nil, nil, nil
	self.loginData.loginDays = 1
end
function loginGiftCtrl:Logout()
	self:resetData()
	loginGiftCtrl.super.Logout(self)
end
function loginGiftCtrl:initClientData(retdata)
	if retdata then
		self.claimedGifts = retdata.claimedGifts
		self.loginData = retdata.loginData
	end
end
function loginGiftCtrl:resetLoginDays()
	self.loginData.loginDays = (self.loginData.loginDays or 0) + 1
	_ENV = (self.loginData.loginDays or 0) + 1
	;(self.loginData.loginDays or 0) + 1.msg = "MESSAGE_SERVER_LOGINGIFT_UPDATE"
	SoraDSendMessage((self.loginData.loginDays or 0) + 1)
	_ENV = (self.loginData.loginDays or 0) + 1
	;(self.loginData.loginDays or 0) + 1.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	;(self.loginData.loginDays or 0) + 1.eventID = gActivityTimeActivityID.LOGIN_GIFT
	SoraDSendMessage((self.loginData.loginDays or 0) + 1)
end
function loginGiftCtrl:getLoginDays()
	return self.loginData.loginDays or 1
end
function loginGiftCtrl:isReceived(taskIndex)
	return self.claimedGifts[tostring(taskIndex)] or false
end
function loginGiftCtrl:isCanReceive()
	local ret = false
	local num = 0
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.LOGIN_GIFT) then
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		if not activityShowCtrl:getParamByID(gActivityTimeActivityID.LOGIN_GIFT) then
			local _ENV, giftList = activityShowCtrl:getParamByID(gActivityTimeActivityID.LOGIN_GIFT), activityShowCtrl:getParamByID(gActivityTimeActivityID.LOGIN_GIFT)
		end
		for k, v in pairs(giftList) do
			if not self:isReceived(k) and self:getLoginDays() >= v.loginDays then
				ret = true
				num = num + 1
			end
		end
	end
	return ret, num
end
function loginGiftCtrl:getReceiveStatusAndNum()
	return self:isCanReceive()
end
function loginGiftCtrl:sendReqClaimGiftMsg(giftID)
	serverproxy = nil
	;(nil).giftID = tostring(giftID)
	serverproxy:Request(gCmd.CMD_LOGIN_GIFT_MODULE, gCmd.REQ_LOGIN_GIFT_CLAIM, nil)
end
function loginGiftCtrl:reqClaimGiftRsp(ret)
	dump(ret, "loginGiftCtrl:reqClaimGiftRsp", 10)
	if ret and ret.err == gErrDef.Err_None and ret.rspData then
		self.claimedGifts[ret.rspData.giftID] = 1
		SoraDMailGainItems(ret.rspData.reward, true)
		_ENV = ret.rspData.reward
		ret.rspData.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		ret.rspData.reward.eventID = gActivityTimeActivityID.LOGIN_GIFT
		SoraDSendMessage(ret.rspData.reward)
	end
	_ENV = ret.rspData.reward
	ret.rspData.reward.msg = "MESSAGE_SERVER_LOGINGIFT_UPDATE"
	SoraDSendMessage(ret.rspData.reward)
end
return loginGiftCtrl
