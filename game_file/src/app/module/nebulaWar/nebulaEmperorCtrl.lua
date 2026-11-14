local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local nebulaEmperorCtrl = class("nebulaEmperorCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local nebulaEmperorRead = include("nebulaEmperorRead")
function nebulaEmperorCtrl:ctor(properties)
	nebulaEmperorCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY
end
function nebulaEmperorCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEBULA_MPEROR_MODULE, gCmd.REQ_NEBULA_MPEROR_ENTER_BATTLEFIELD, handler(self, self.reqEnterBattlefieldRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_MPEROR_MODULE, gCmd.REQ_NEBULA_MPEROR_QUIT_BATTLEFIELD, handler(self, self.reqQuitBattlefieldRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_MPEROR_MODULE, gCmd.REQ_NEBULA_MPEROR_DONATE_GOLD, handler(self, self.reqDonateGoldRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_MPEROR_MODULE, gCmd.REQ_NEBULA_MPEROR_DONATE_REWARD, handler(self, self.reqDonateRewardRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_MPEROR_MODULE, gCmd.REQ_NEBULA_MPEROR_GET_INIT_DATA, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_MPEROR_MODULE, gCmd.REQ_NEBULA_MPEROR_SUMMON_DEAD_ARMY, handler(self, self.reqSummonArmyRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_MPEROR_MODULE, gCmd.REQ_NEBULA_MPEROR_APPOINT_LORD_TITLE, handler(self, self.reqAppointLordTitleRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_MPEROR_MODULE, gCmd.REQ_NEBULA_MPEROR_CANCEL_LORD_TITLE, handler(self, self.reqCancelLordTitleRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_MPEROR_MODULE, gCmd.REQ_NEBULA_MPEROR_APPOINT_REGION_TITLE, handler(self, self.reqAppointRegionTitleRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_MPEROR_MODULE, gCmd.REQ_NEBULA_MPEROR_AWARD_GIFT, handler(self, self.reqAwardGiftRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_MPEROR_MODULE, gCmd.REQ_NEBULA_MPEROR_SELF_TITLE_INFO, handler(self, self.reqSelfTitleInfoRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_MPEROR_MODULE, gCmd.REQ_NEBULA_MPEROR_ALL_TITLE_INFO, handler(self, self.reqAllTitleInfoRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_MPEROR_MODULE, gCmd.REQ_NEBULA_MPEROR_GIFT_AWARD_INFO, handler(self, self.reqGiftInfoRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_MPEROR_MODULE, gCmd.REQ_NEBULA_MPEROR_GIFT_AWARD_RECORD, handler(self, self.reqGiftRecordRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_MPEROR_MODULE, gCmd.REQ_NEBULA_MPEROR_BUY_GIFT, handler(self, self.reqBuyGiftRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_EMPEROR_WAR_MODULE, gCmd.REQ_NEBULA_EMPEROR_WAR_DATA, handler(self, self.reqWarDataRsp))
	_UPVALUE4_ = msgCtrl.register
	self.rankCmdList, msgCtrl.register[1] = msgCtrl.register, gCmd.REQ_NEBULA_EMPEROR_WAR_CAMP_OCCUPY_RANK
	self.rankCmdList, msgCtrl.register[2] = msgCtrl.register, gCmd.REQ_NEBULA_EMPEROR_WAR_PLAYER_OCCUPY_RANK
	self.rankCmdList, msgCtrl.register[3] = msgCtrl.register, gCmd.REQ_NEBULA_EMPEROR_WAR_PLAYER_KILL_FC_RANK
	self.rankCmdList, msgCtrl.register[4] = msgCtrl.register, gCmd.REQ_NEBULA_EMPEROR_WAR_CAMP_PLAYER_CONTRIBUTE_RANK
	for __, cmd in ipairs(self.rankCmdList) do
		msgCtrl.register(gCmd.CMD_NEBULA_EMPEROR_WAR_MODULE, cmd, handler(self, self.reqRankDataRsp))
	end
	msgCtrl.register(gCmd.CMD_NEBULA_EMPEROR_WAR_MODULE, gCmd.REQ_NEBULA_EMPEROR_WAR_ENERGY_EXCHANGE_BUFF, handler(self, self.reqExchangeBuffRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_EMPEROR_WAR_MODULE, gCmd.REQ_NEBULA_EMPEROR_WAR_ENERGY_DATA, handler(self, self.reqEnergyDataRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_EMPEROR_WAR_MODULE, gCmd.REQ_NEBULA_EMPEROR_WAR_BIOGRAPHY, handler(self, self.reqBiographyRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_EMPEROR_WAR_MODULE, gCmd.REQ_NEBULA_EMPEROR_WAR_BIOGRAPHY_PLAYER_OCCUPY_RANK, handler(self, self.reqBiographyRankRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_EMPEROR_WAR_MODULE, gCmd.REQ_NEBULA_EMPEROR_WAR_MODIFY_BIOGRAPHY_EDICT, handler(self, self.reqBiographyEdictRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_EMPEROR_WAR_MODULE, gCmd.REQ_NEBULA_EMPEROR_WAR_IN_WAR_CAMP_PLAYER_COUNT, handler(self, self.reqInWarPlayerCountRsp))
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	backpackCtrl:addItemChangeEvent(gBadgeItemID.TIME_LIMIT_NEBULA_POWER, handler(self, self.toolCountChangeNotify))
	backpackCtrl:addItemChangeEvent(gBadgeItemID.NEBULA_POWER, handler(self, self.toolCountChangeNotify))
	self:resetData()
	self:registerNotify()
	self:reqSelfTitleInfo()
end
function nebulaEmperorCtrl:Logout()
	nebulaEmperorCtrl.super.Logout(self)
	self:resetData()
end
function nebulaEmperorCtrl:resetData()
	self.titleInfo, _ENV, self.campData, _ENV, self.energyData, _ENV, self.warData, _ENV, self.initData, _ENV = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	local teamCtrl = SoraDGetCtrl("teamCtrl")
	self.myTeamInfo = teamCtrl:getTeamNebulaEmperor()
end
function nebulaEmperorCtrl:initClientData(data1, data2)
