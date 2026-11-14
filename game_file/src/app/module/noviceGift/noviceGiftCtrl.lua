local GameModule = include("GameModule")
local noviceGiftCtrl = class("noviceGiftCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function noviceGiftCtrl:ctor(properties)
	noviceGiftCtrl.super.ctor(self, properties)
end
function noviceGiftCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_NOVICE_GIFT_MODULE, gCmd.REQ_NOVICE_GIFT_INIT, handler(self, self.initResp))
	msgCtrl.register(gCmd.CMD_NOVICE_GIFT_MODULE, gCmd.REQ_NOVICE_GIFT_RECEIVE, handler(self, self.receiveResp))
	self:resetData()
end
function noviceGiftCtrl:resetData()
	self.noviceGiftData, _UPVALUE0_, self.handle_notify = nil, nil, nil
end
function noviceGiftCtrl:Logout()
	self:resetData()
	noviceGiftCtrl.super.Logout(self)
end
function noviceGiftCtrl:initClientData(data)
	if not data then
		return
	end
	dump(data, "noviceGiftCtrl:initClientData", 10)
	self.noviceGiftData = data
	self:registerNotify()
end
function noviceGiftCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NOVICE_GIFT, handler(self, self.notifyHandler))
end
function noviceGiftCtrl:notifyHandler(event)
	if event and event.data and type(event.data) == "table" then
		for _, content in ipairs(event.data) do
			if content.noviceGiftData then
				self.noviceGiftData = content.noviceGiftData
			end
		end
		_ENV = ipairs(event.data)
		ipairs(event.data).msg = "MESSAGE_SERVER_EVENTCENTER_NOVICE_GIFT_REFRESH"
		SoraDSendMessage(ipairs(event.data))
		_ENV = ipairs(event.data)
		ipairs(event.data).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		ipairs(event.data).eventID = gActivityTimeActivityID.RECRUITMENT_MATERIALS
		SoraDSendMessage(ipairs(event.data))
	end
end
function noviceGiftCtrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_NOVICE_GIFT_MODULE, gCmd.REQ_NOVICE_GIFT_INIT)
end
function noviceGiftCtrl:sendReceiveMsg()
	serverproxy:Request(gCmd.CMD_NOVICE_GIFT_MODULE, gCmd.REQ_NOVICE_GIFT_RECEIVE)
end
function noviceGiftCtrl:initResp(ret)
	if ret and ret.rspData and ret.rspData.noviceGiftData then
		self.noviceGiftData = ret.rspData.noviceGiftData
	end
end
function noviceGiftCtrl:receiveResp(ret)
	dump(ret, "noviceGiftCtrl:receiveResp", 10)
	if not ret or ret.err == gErrDef.Err_NOVICE_GIFT_TODAY_IS_GET then
	elseif ret.err == gErrDef.Err_None then
		self.noviceGiftData = ret.rspData.noviceGiftData
		SoraDMailGainItems(ret.rspData.reward, true)
		_ENV = ret.rspData.reward
		ret.rspData.reward.msg = "MESSAGE_SERVER_EVENTCENTER_NOVICE_GIFT_REFRESH"
		SoraDSendMessage(ret.rspData.reward)
		_ENV = ret.rspData.reward
		ret.rspData.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		ret.rspData.reward.eventID = gActivityTimeActivityID.RECRUITMENT_MATERIALS
		SoraDSendMessage(ret.rspData.reward)
	end
end
function noviceGiftCtrl:getReceiveCount()
	if self.noviceGiftData and type(self.noviceGiftData.receiveRecord) == "table" then
		return #self.noviceGiftData.receiveRecord
	end
	return 0
end
function noviceGiftCtrl:getIsEnd()
	return self.noviceGiftData and self.noviceGiftData.hasEnter
end
function noviceGiftCtrl:isCurrentCanReceive()
	return self.noviceGiftData and self.noviceGiftData.canReceive
end
function noviceGiftCtrl:getReceiveStatusAndNum()
	local canReceive = self:isCurrentCanReceive()
	return canReceive, canReceive and 1 or 0
end
function noviceGiftCtrl:getCanReceiveByDay(day)
	if self:isCurrentCanReceive() and day == self:getCurrentDay() then
		return true
	end
	return false
end
function noviceGiftCtrl:getCurrentDay()
	return self.noviceGiftData and self.noviceGiftData.curDay
end
function noviceGiftCtrl:isAlreadyReceiveByDay(day)
	local isAlreadyReceive = false
	if self.noviceGiftData.receiveRecord[day] then
		isAlreadyReceive = true
	end
	return isAlreadyReceive
end
function noviceGiftCtrl:isReceiveAllAward()
	print(" self:getReceiveCount()", self:getReceiveCount(), include("recruitmentRead").getMaxDay())
	return self:getReceiveCount() >= include("recruitmentRead").getMaxDay()
end
return noviceGiftCtrl
