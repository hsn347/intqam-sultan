local GameModule = include("GameModule")
local luckyBlessCtrl = class("luckyBlessCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function luckyBlessCtrl:ctor(properties)
	luckyBlessCtrl.super.ctor(self, properties)
	self:resetData()
end
function luckyBlessCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_LUCKY_BLESSING_MODULE, gCmd.REQ_LUCKY_BLESSING_INIT, handler(self, self.luckyBlessInitResp))
	msgCtrl.register(gCmd.CMD_LUCKY_BLESSING_MODULE, gCmd.REQ_LUCKY_BLESSING_OPEN, handler(self, self.luckyBlessOpenResp))
	msgCtrl.register(gCmd.CMD_LUCKY_BLESSING_MODULE, gCmd.REQ_LUCKY_BLESSING_ACTIVATE, handler(self, self.luckyBlessActivateResp))
end
function luckyBlessCtrl:resetData()
	self.luckyData, _UPVALUE0_ = nil, nil
	self.luckyData.costGold = 0
	self.luckyData.curEffectEndTime = 0
	self.luckyData.curEffectType = 0
	self.luckyData.discount = 0
	self.luckyData.leftActivateCount = 0
	self.luckyData.leftOpenCount = 0
	self.luckyData.openRecord, _UPVALUE0_ = nil, nil
	self.isOpen = false
end
function luckyBlessCtrl:Logout()
	self:resetData()
	luckyBlessCtrl.super.Logout(self)
end
function luckyBlessCtrl:initClientData(data)
	if not data then
		return
	end
	self.luckyData = data
	self:registerNotify()
end
function luckyBlessCtrl:sendInitReq()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LUCKY_BLESSING_MODULE, gCmd.REQ_LUCKY_BLESSING_INIT, nil)
end
function luckyBlessCtrl:sendOpenReq()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LUCKY_BLESSING_MODULE, gCmd.REQ_LUCKY_BLESSING_OPEN, nil)
end
function luckyBlessCtrl:sendActivateReq()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LUCKY_BLESSING_MODULE, gCmd.REQ_LUCKY_BLESSING_ACTIVATE, nil)
end
function luckyBlessCtrl:getLuckyData()
	return self.luckyData
end
function luckyBlessCtrl:getLuckyBlessStatus()
	local status = 0
	if 0 < self.luckyData.curEffectEndTime and 0 < self.luckyData.curEffectType then
		status = 2
	elseif self:getCurBless() then
		status = 1
	end
	return status
end
function luckyBlessCtrl:getCurBless()
	return self.luckyData.openRecord[#self.luckyData.openRecord]
end
function luckyBlessCtrl:getReceiveStatusAndNum()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	if not activityShowCtrl:isActivityOpen(gActivityTimeActivityID.LUCKY_BLESSING_ACTIVITY) then
		return false, 0
	end
	local status = self:getLuckyBlessStatus()
	if status ~= 2 and 0 < self.luckyData.leftActivateCount then
		return true, -1
	end
	return false, 0
end
function luckyBlessCtrl:getRealTime()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local activityTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.LUCKY_BLESSING_ACTIVITY)
	local time = 0
	local actTime
	if activityTime then
		actTime = activityTime.timerNode.timer:getRemainTime()
		time = math.max(0, math.min(actTime, self.luckyData.curEffectEndTime - serviceFunctions.systemTime()))
	end
	return time, actTime or 0
end
function luckyBlessCtrl:isNeedNotice()
	return self.isOpen
end
function luckyBlessCtrl:getResult(count)
	return count * (1 - self.luckyData.discount / 1000)
end
function luckyBlessCtrl:getDiscount()
	return self.luckyData.discount
end
function luckyBlessCtrl:getLeftActivateCount(...)
	return self.luckyData.leftActivateCount
end
function luckyBlessCtrl:getCurEffectType(...)
	return self.luckyData.curEffectType
end
function luckyBlessCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.LUCKYBLESS_ACTIVITY, handler(self, self.notifyHandler))
end
function luckyBlessCtrl:notifyHandler(event)
	local content = event.data[1]
	dump(content, "luckyBlessCtrl:notifyHandler")
	if content then
		if self.luckyData.curEffectType > 0 and 0 < self.luckyData.discount then
			_ENV = self.luckyData.discount
			self.luckyData.discount[gLuckyBlessActivityEffectType.BUILD_UPGRADE] = i18n("daily_reward_name_05")
			self.luckyData.discount[gLuckyBlessActivityEffectType.TECHNOLOGY_RESEARCH] = i18n("common_text_2275")
			self.luckyData.discount[gLuckyBlessActivityEffectType.TRAIN_SOLDIERS] = i18n("epicbattle_btn_02")
			self.luckyData.discount[gLuckyBlessActivityEffectType.BUILD_STRENGTH] = i18n("daily_reward_name_20")
			local self.luckyData.discount[gLuckyBlessActivityEffectType.MAKE_A_WISH], desDef = i18n("cat_common_05"), self.luckyData.discount
			if self.luckyData.curEffectType == gLuckyBlessActivityEffectType.MAKE_A_WISH then
				_ENV = nil
				;(nil).name = desDef[self.luckyData.curEffectType]
				;(nil).num = string.format("%d%%", self.luckyData.discount / 10)
				SoraDShowMsgTip(i18n("lucky_text_29", nil))
			else
				_ENV = i18n("lucky_text_29", nil)
				i18n("lucky_text_29", nil).name = desDef[self.luckyData.curEffectType]
				i18n("lucky_text_29", nil).num = string.format("%d%%", self.luckyData.discount / 10)
				SoraDShowMsgTip(i18n("lucky_text_17", i18n("lucky_text_29", nil)))
			end
		end
		self.luckyData = content
		local rTime, aTime = self:getRealTime()
		self.isOpen = aTime and true or false
		_ENV = i18n("lucky_text_17", i18n("lucky_text_29", nil))
		i18n("lucky_text_17", i18n("lucky_text_29", nil)).msg = "MESSAGE_SERVER_LUCKYBLESS_UPDATE"
		SoraDSendMessage(i18n("lucky_text_17", i18n("lucky_text_29", nil)))
	end
end
function luckyBlessCtrl:luckyBlessInitResp(ret)
	dump(ret, "luckyBlessCtrl:luckyBlessInitResp", 10)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata then
		self.luckyData = ret.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_LUCKYBLESS_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function luckyBlessCtrl:luckyBlessOpenResp(ret)
	dump(ret, "luckyBlessCtrl:luckyBlessOpenResp", 10)
	local oriEtype
	if ret and ret.err == gErrDef.Err_None and ret.rspdata then
		local preData = self:getCurBless()
		oriEtype = preData and preData.type or self.luckyData.curEffectType
		self.luckyData = ret.rspdata
	elseif ret.err == gErrDef.Err_LUCKY_BLESSING_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif ret.err == gErrDef.Err_LUCKY_BLESSING_NOT_ENOUGH_OPEN_COUNT then
		SoraDShowMsgTip(i18n("lucky_text_07"))
	elseif ret.err == gErrDef.Err_LUCKY_BLESSING_HAVE_EFFECT then
		SoraDShowMsgTip(i18n("lucky_text_08"))
	end
	_ENV = i18n("lucky_text_08")
	i18n("lucky_text_08").msg = "MESSAGE_SERVER_LUCKYBLESS_UPDATE"
	i18n("lucky_text_08").isFlash = true
	i18n("lucky_text_08").oriEtype = oriEtype
	SoraDSendMessage(i18n("lucky_text_08"))
end
function luckyBlessCtrl:luckyBlessActivateResp(ret)
	dump(ret, "luckyBlessCtrl:luckyBlessActivateResp", 10)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata then
		self.luckyData = ret.rspdata
		SoraDShowMsgTip(i18n("lucky_text_14"))
	elseif ret.err == gErrDef.Err_LUCKY_BLESSING_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif ret.err == gErrDef.Err_LUCKY_BLESSING_NOT_ENOUGH_OPEN_COUNT then
		SoraDShowMsgTip(i18n("lucky_text_07"))
	elseif ret.err == gErrDef.Err_LUCKY_BLESSING_HAVE_EFFECT then
		SoraDShowMsgTip(i18n("lucky_text_12"))
	elseif ret.err == gErrDef.Err_LUCKY_BLESSING_NOT_OPEN then
		SoraDShowMsgTip(i18n("lucky_text_13"))
	end
	_ENV = i18n("lucky_text_13")
	i18n("lucky_text_13").msg = "MESSAGE_SERVER_LUCKYBLESS_UPDATE"
	SoraDSendMessage(i18n("lucky_text_13"))
end
return luckyBlessCtrl
