local GameModule = include("GameModule")
local growupFundCtrl = class("growupFundCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function growupFundCtrl:ctor(properties)
	growupFundCtrl.super.ctor(self, properties)
end
function growupFundCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_GROWUP_FUND_MODULE, gCmd.REQ_BUY_GROWUP_FUND, handler(self, self.buyGrowUpFundResp))
	msgCtrl.register(gCmd.CMD_GROWUP_FUND_MODULE, gCmd.REQ_RECEIVE_GROWUP_FUND, handler(self, self.receiveGrowUpFundResp))
	msgCtrl.register(gCmd.CMD_GROWUP_FUND_MODULE, gCmd.REQ_CHECK_SHOW_TIME, handler(self, self.checkShowTimeResp))
	self:resetData()
end
function growupFundCtrl:resetData()
	self.growupFundData, _UPVALUE0_, self.reward, _UPVALUE0_, self.cost, _UPVALUE0_ = nil, nil, nil, nil, nil, nil
end
function growupFundCtrl:Logout()
	self:resetData()
	growupFundCtrl.super.Logout(self)
end
function growupFundCtrl:initClientData(data)
	if not data then
		return
	end
	self.buyCostArray = data.cost
	self.rewardArray = data.reward
	self.growupFundData = data.growupFundData
	self.needPopWindow = data.needPopWindow
end
function growupFundCtrl:dump()
	print("self.needPopWindow=", self.needPopWindow)
	print("self:isCanReceive()", self:isCanReceive())
end
function growupFundCtrl:getBuyCostArray()
	return self.buyCostArray[1]
end
function growupFundCtrl:getRewardByLv(lv)
	local _ENV, ret
	if self.rewardArray[tostring(lv)] and self.rewardArray[tostring(lv)][1] then
		ret = self.rewardArray[tostring(lv)][1]
	end
	return ret
end
function growupFundCtrl:getRewardLvArray()
	local _ENV, ret
	for lv, _ in pairs(self.rewardArray) do
		table.insert(ret, tonumber(lv))
	end
	table.sort(ret, function(a, b)
		return a < b
	end)
	return ret
end
function growupFundCtrl:getNeedPopWindow()
	return self.needPopWindow
end
function growupFundCtrl:isCanReceive()
	local ret = false
	local retNum = 0
	if self:isAlreadyBuy() then
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local castleLv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		local lvArray = self:getRewardLvArray()
		for k, lv in pairs(lvArray) do
			if lv <= castleLv and false == self:isReceive(lv) then
				ret = true
				retNum = retNum + 1
			end
		end
	end
	return ret, retNum
end
function growupFundCtrl:getReceiveStatusAndNum()
	return self:isCanReceive()
end
function growupFundCtrl:isAlreadyBuy()
	return self.growupFundData.isBuy == 1
end
function growupFundCtrl:getBuyLeftTime()
	local ret = 0
	if self.growupFundData.endTime then
		ret = self.growupFundData.endTime - serviceFunctions.systemTime()
	end
	return ret
end
function growupFundCtrl:isReceive(lv)
	local ret = false
	if self.growupFundData.receive and self.growupFundData.receive[tostring(lv)] then
		ret = true
	end
	return ret
end
function growupFundCtrl:getAllReceive()
	local ret = true
	local lvArray = self:getRewardLvArray()
	for k, lv in pairs(lvArray) do
		if false == self:isReceive(lv) then
			ret = false
			break
		end
	end
	return ret
end
function growupFundCtrl:sendBuyGrowUpFund()
	serverproxy:Request(gCmd.CMD_GROWUP_FUND_MODULE, gCmd.REQ_BUY_GROWUP_FUND)
end
function growupFundCtrl:sendReceive(level)
	local serverproxy, data
	data.level = level
	serverproxy:Request(gCmd.CMD_GROWUP_FUND_MODULE, gCmd.REQ_RECEIVE_GROWUP_FUND, data)
end
function growupFundCtrl:buyGrowUpFundResp(content)
	if content.err == gErrDef.Err_None then
		self.growupFundData.isBuy = 1
		SoraDShowMsgTip(i18n("common_text_2604"))
	elseif content.err == gErrDef.Err_GROWUP_FUND_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif content.err == gErrDef.Err_GROWUP_FUND_NOT_VALID then
		SoraDShowMsgTip(i18n("common_text_2566"))
	elseif content.err == gErrDef.Err_GROWUP_FUND_ALREADY_BUY then
		SoraDShowMsgTip(i18n("common_text_776"))
	elseif content.err == gErrDef.Err_GROWUP_FUND_NOT_ENOUGH then
		SoraDShowMsgBox(i18n("common_text_423"), i18n("common_text_424"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				if GLOBAL_GAME_RECHARGE_MODE then
					uiManager:show("rechargeView")
				else
					SoraDCreatePanel("rechargeView"):show()
				end
			end
		end)
	end
	_ENV = i18n("common_text_423")
	i18n("common_text_423").msg = "MESSAGE_SERVER_EVENTCENTER_GROWUPFUND_BUY_BACK"
	i18n("common_text_423").err = content.err
	SoraDSendMessage((i18n("common_text_423")))
	_ENV = i18n("common_text_423")
	i18n("common_text_423").msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
	SoraDSendMessage((i18n("common_text_423")))
end
function growupFundCtrl:receiveGrowUpFundResp(content)
	if content.err == gErrDef.Err_None then
		local level = content.data.level
		self.growupFundData.receive[tostring(level)] = level
		_ENV = nil
		;(nil).name = ""
		SoraDShowMsgTip(i18n("common_text_2096", nil))
		local lvReward = self:getRewardByLv(level)
		SoraDPopGainItem(lvReward.rewardid, lvReward.rewardnum)
		_ENV = lvReward.rewardid
		lvReward.rewardid.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		lvReward.rewardid.eventID = gActivityTimeActivityID.GROWUPFUND
		SoraDSendMessage(lvReward.rewardid)
	elseif content.err == gErrDef.Err_GROWUP_FUND_NOT_BUY then
	elseif content.err == gErrDef.Err_GROWUP_FUND_ALREADY_RECEIVE then
	elseif content.err == gErrDef.Err_GROWUP_FUND_NO_REWARD then
	elseif content.err == gErrDef.Err_GROWUP_FUND_LV_NOT_ENOUGH then
	end
	_ENV = gErrDef.Err_GROWUP_FUND_LV_NOT_ENOUGH
	gErrDef.Err_GROWUP_FUND_LV_NOT_ENOUGH.msg = "MESSAGE_SERVER_EVENTCENTER_GROWUPFUND_RECEIVE_BACK"
	gErrDef.Err_GROWUP_FUND_LV_NOT_ENOUGH.err = content.err
	SoraDSendMessage(gErrDef.Err_GROWUP_FUND_LV_NOT_ENOUGH)
	_ENV = gErrDef.Err_GROWUP_FUND_LV_NOT_ENOUGH
	gErrDef.Err_GROWUP_FUND_LV_NOT_ENOUGH.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
	SoraDSendMessage(gErrDef.Err_GROWUP_FUND_LV_NOT_ENOUGH)
end
function growupFundCtrl:checkShowTimeResp(content)
end
return growupFundCtrl
