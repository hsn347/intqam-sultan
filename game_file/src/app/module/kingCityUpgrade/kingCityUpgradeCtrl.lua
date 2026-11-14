local kingCityUpgradeRead = include("kingCityUpgradeRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local kingCityUpgradeCtrl = class("kingCityUpgradeCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function kingCityUpgradeCtrl:ctor(properties)
	kingCityUpgradeCtrl.super.ctor(self, properties)
	self:resetData()
end
function kingCityUpgradeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_UPGRADE_CASLTE_LV_MODULE, gCmd.REQ_UPGRADE_CASLTE_LV_REWARD, handler(self, self.reqUpgradeCaslteLvRewardRsp))
	msgCtrl.register(gCmd.CMD_UPGRADE_CASLTE_LV_MODULE, gCmd.REQ_UPGRADE_CASLTE_LV_INIT_DATA, handler(self, self.reqUpgradeCaslteLvInitRsp))
	self:registerNotify()
	self:reqUpgradeCaslteLvInit()
end
function kingCityUpgradeCtrl:Logout()
	kingCityUpgradeCtrl.super.Logout(self)
	self:resetData()
end
function kingCityUpgradeCtrl:resetData()
	self.upgradeCastleLvCtrl, _UPVALUE0_ = nil, nil
end
function kingCityUpgradeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.UPGRADE_CASTLE_LV, handler(self, self.notifyHandler))
end
function kingCityUpgradeCtrl:notifyHandler(event)
	dump(event.data, "kingCityUpgradeCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.upgradeCastleLvCtrl.isShowIcon = v.isShowIcon
		_ENV = v.isShowIcon
		v.isShowIcon.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(v.isShowIcon)
	end
end
function kingCityUpgradeCtrl:reqUpgradeCaslteLvReward(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_UPGRADE_CASLTE_LV_MODULE, gCmd.REQ_UPGRADE_CASLTE_LV_REWARD, nil)
end
function kingCityUpgradeCtrl:reqUpgradeCaslteLvInit()
	serverproxy:Request(gCmd.CMD_UPGRADE_CASLTE_LV_MODULE, gCmd.REQ_UPGRADE_CASLTE_LV_INIT_DATA)
end
function kingCityUpgradeCtrl:reqUpgradeCaslteLvRewardRsp(content)
	dump(content, "kingCityUpgradeCtrl:reqUpgradeCaslteLvRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata.reward then
			local _ENV, reward = content.rspdata.reward, content.rspdata.reward
		end
		SoraDMailGainItems(reward, true)
		self:setRewardIsGet(content.data.index)
		_ENV = self
		self.msg = "MESSAGE_KINGCITY_UPGRADE_REFRESH"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY
		SoraDSendMessage(self)
	end
end
function kingCityUpgradeCtrl:reqUpgradeCaslteLvInitRsp(content)
	dump(content, "kingCityUpgradeCtrl:reqUpgradeCaslteLvInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.upgradeCastleLvCtrl = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_KINGCITY_UPGRADE_REFRESH"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.Err_None.eventID = gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function kingCityUpgradeCtrl:getRewardIsGet(index)
	if self.upgradeCastleLvCtrl.receives and self.upgradeCastleLvCtrl.receives[tostring(index)] == 1 then
		return true
	else
		return false
	end
end
function kingCityUpgradeCtrl:setRewardIsGet(index)
	if self.upgradeCastleLvCtrl and self.upgradeCastleLvCtrl.receives then
		self.upgradeCastleLvCtrl.receives[tostring(index)] = 1
	end
end
function kingCityUpgradeCtrl:getReceiveStatusAndNum()
	local retNum = 0
	if not self.upgradeCastleLvCtrl.receives then
		local _ENV, receives = self.upgradeCastleLvCtrl.receives, self.upgradeCastleLvCtrl.receives
	end
	local nowLv = SoraDGetCastleLv()
	for i, v in ipairs(kingCityUpgradeRead.getAwardConfig()) do
		if nowLv >= v.castlelv and (not receives[tostring(v.Index)] or receives[tostring(v.Index)] == 0) then
			retNum = retNum + 1
		end
	end
	print("kingCityUpgradeCtrl:getReceiveStatusAndNum", retNum)
	return 0 < retNum, retNum
end
return kingCityUpgradeCtrl
