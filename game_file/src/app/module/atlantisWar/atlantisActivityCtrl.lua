local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local atlantisActivityCtrl = class("atlantisActivityCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function atlantisActivityCtrl:ctor(properties)
	atlantisActivityCtrl.super.ctor(self, properties)
	self:resetData()
end
function atlantisActivityCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_STATE_DATA, handler(self, self.reqStateDataRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_MATCH_RESULT, handler(self, self.reqMatchResultRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_ENTER_BATTLEFIELD, handler(self, self.reqEnterBattlefieldRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_QUIT_BATTLEFIELD, handler(self, self.reqQuitBattlefieldRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_GET_MANAGER_INFO, handler(self, self.reqGetManagerInfoRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_MODIFY_FLAG, handler(self, self.reqModifyFlagRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_MODIFY_MANAGER, handler(self, self.reqModifyManagerRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_BUY_SKILL_GIFT, handler(self, self.reqBuySkillGiftRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_SKILL_LOTTERY, handler(self, self.reqSkillLotteryRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_SKILL_REPLACE, handler(self, self.reqSkillReplaceRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_SKILL_USE, handler(self, self.reqSkillUseRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_KINGDOM_RANKING, handler(self, self.reqKindomRankRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_PERSONAL_RANKING, handler(self, self.reqRankRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_TITEL_RANKING, handler(self, self.reqRankRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_HISTORY_REC, handler(self, self.reqHistoryRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_ADD_LV0_USER, handler(self, self.reqAddLv0UserRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_REMOVE_LV0_USER, handler(self, self.reqRemoveLv0UserRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_GET_LV0_LIST, handler(self, self.reqGetLv0ListRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_GET_TREASURE_INFO, handler(self, self.reqGetTreasureInfoRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_SEND_TREASURE, handler(self, self.reqSendTreasureRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_LEGION_BRIEF, handler(self, self.reqLegionBriefRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_SELECT_SKILL, handler(self, self.reqSelectSkillRsp))
	self:reqStateData()
	self:registerNotify()
end
function atlantisActivityCtrl:Logout()
	atlantisActivityCtrl.super.Logout(self)
	self:resetData()
end
function atlantisActivityCtrl:resetData()
	self.treasureInfo, _UPVALUE0_, self.lv0List, _UPVALUE0_, self.matchResult, _UPVALUE0_, self.managerInfo, _UPVALUE0_, self.stateData, _UPVALUE0_, self.data, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
end
function atlantisActivityCtrl:initClientData(data)
	dump(data, "atlantisActivityCtrl:initClientData", 10)
	if not data then
		return
	end
	self.data = data
	if worldMapDefine.isInAtlantis() then
		self:reqMatchResult()
	end
end
function atlantisActivityCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ATLANTIS_WAR, handler(self, self.notifyHandler))
end
function atlantisActivityCtrl:notifyHandler(event)
	dump(event.data, "atlantisActivityCtrl:notifyHandler", 10)
	_ENV = dump
	dump.updateAtlantisWarStateData = true
	dump.buyGift = true
	dump.refreshData = true
	dump.winAtlantisSeason = true
	local dump.top1KingdomInfo, notifyTypeList = true, dump
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		if notifyTypeList[notifyType] then
			self:notifyActivity(notifyType, notifyData)
		end
	end
end
function atlantisActivityCtrl:notifyActivity(notifyType, notifyData)
	if notifyType == "updateAtlantisWarStateData" then
		self.stateData = notifyData
		_ENV = nil
		;(nil).msg = "MESSAGE_ATLANTISWAR_REFRESH"
		;(nil).key = "reqStateDataRsp"
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(nil)
	elseif notifyType == "buyGift" then
		if notifyData.success then
			_ENV = nil
			;(nil).var = self:getDataSeason()
			SoraDShowMsgTip(i18n("atlantiswar_text_0230", nil))
			self.data.isPrivilegeLock = true
			_ENV = i18n("atlantiswar_text_0230", nil)
			i18n("atlantiswar_text_0230", nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			i18n("atlantiswar_text_0230", nil).eventID = gActivityTimeActivityID.ATLANTIS_WAR_ACTIVITY
			SoraDSendMessage(i18n("atlantiswar_text_0230", nil))
			paymentManager.loopForFinishTransaction()
			local reward = notifyData.reward
			local mailID = notifyData.mailID
			local rid = notifyData.rid
			_ENV = i18n("atlantiswar_text_0230", nil)
			_ENV, i18n("atlantiswar_text_0230", nil).msg = i18n("atlantiswar_text_0230", nil)
			i18n("atlantiswar_text_0230", nil).result = true
			i18n("atlantiswar_text_0230", nil).rid = rid
			i18n("atlantiswar_text_0230", nil).itemList = reward
			i18n("atlantiswar_text_0230", nil).data, i18n("atlantiswar_text_0230", nil).mailID = i18n("atlantiswar_text_0230", nil)
			SoraDSendMessage(i18n("atlantiswar_text_0230", nil))
			_ENV = i18n("atlantiswar_text_0230", nil)
			i18n("atlantiswar_text_0230", nil).msg = "MESSAGE_ATLANTISWAR_BUYGIFT_SUCCESS"
			SoraDSendMessage(i18n("atlantiswar_text_0230", nil))
		end
	elseif notifyType == "refreshData" then
		self.data = notifyData
		_ENV = notifyData.mailID
		notifyData.mailID.msg = "MESSAGE_ATLANTISWAR_SKILL_NOTIFY"
		SoraDSendMessage(notifyData.mailID)
	elseif notifyType == "winAtlantisSeason" then
		local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
		lordInfoCtrl:setWinAtlantisSeasonTime(notifyData.winAtlantisSeasonTime)
	elseif notifyType == "top1KingdomInfo" then
		self.seaonEndData = notifyData
		if not worldMapDefine.isInAtlantis() then
			self:showSeasonEnd()
		end
	end
end
function atlantisActivityCtrl:getSeasonEndData(...)
	return self.seaonEndData
end
function atlantisActivityCtrl:showSeasonEnd()
	if self.seaonEndData then
		uiManager:show("AtlantisSeaonEnd", self.seaonEndData)
		self.seaonEndData = nil
	end
end
function atlantisActivityCtrl:reqStateData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_STATE_DATA, nil)
end
function atlantisActivityCtrl:reqMatchResult()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_MATCH_RESULT, nil)
end
function atlantisActivityCtrl:reqEnterBattlefield()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_ENTER_BATTLEFIELD, nil)
end
function atlantisActivityCtrl:reqQuitBattlefield()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_QUIT_BATTLEFIELD, nil)
end
function atlantisActivityCtrl:reqGetManagerInfo()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_GET_MANAGER_INFO, nil)
end
function atlantisActivityCtrl:reqModifyFlag(flag)
	serverproxy = nil
	;(nil).flag = flag
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_MODIFY_FLAG, nil)
end
function atlantisActivityCtrl:reqModifyManager(idx, uid)
	serverproxy = nil
	;(nil).idx = idx
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_MODIFY_MANAGER, nil)
end
function atlantisActivityCtrl:reqBuySkillGift(rechargeID)
	serverproxy = nil
	;(nil).rechargeID = rechargeID
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_BUY_SKILL_GIFT, nil)
end
function atlantisActivityCtrl:reqSkillLottery(idx)
	serverproxy = nil
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_SKILL_LOTTERY, nil)
end
function atlantisActivityCtrl:reqSkillReplace(idx)
	serverproxy = nil
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_SKILL_REPLACE, nil)
end
function atlantisActivityCtrl:reqSkillUse(idx)
	serverproxy = nil
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_SKILL_USE, nil)
end
function atlantisActivityCtrl:reqKindomRank(idx)
	serverproxy = nil
	;(nil).idx = idx
	;(nil).count = 20
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_KINGDOM_RANKING, nil)
end
function atlantisActivityCtrl:reqPersonRank(idx, rankingType)
	serverproxy = nil
	;(nil).idx = idx
	;(nil).rankingType = rankingType
	;(nil).count = 20
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_PERSONAL_RANKING, nil)
end
function atlantisActivityCtrl:reqTitleRank(idx, rankingType, title)
	serverproxy = nil
	;(nil).idx = idx
	;(nil).rankingType = rankingType
	;(nil).count = 20
	;(nil).title = title
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_TITEL_RANKING, nil)
end
function atlantisActivityCtrl:reqHistory()
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_HISTORY_REC)
end
function atlantisActivityCtrl:reqAddLv0User(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_ADD_LV0_USER, nil)
end
function atlantisActivityCtrl:reqAddLv0UserRsp(content)
	dump(content, "atlantisActivityCtrl:reqAddLv0UserRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_4131"))
		self.lv0List = content.rspdata
	elseif content.err == gErrDef.Err_ATLANTIS_WAR_NOT_ADMIN then
		SoraDShowMsgTip(i18n("atlantiswar_text_0347"))
	elseif content.err == gErrDef.Err_ATLANTIS_WAR_STATE_ERR then
		local atlantisWarUtil = include("atlantisWarUtil")
		if atlantisWarUtil.isNewMap() then
			SoraDShowHelpMsgTip(i18n("atlantiswar_text_0020_KOH"))
		else
			SoraDShowHelpMsgTip(i18n("atlantiswar_text_0020"))
		end
	elseif content.err == gErrDef.Err_ATLANTIS_WAR_NOT_SAME_KINGDOM then
		SoraDShowMsgTip(i18n("atlantiswar_text_0351"))
	elseif content.err == gErrDef.Err_ATLANTIS_WAR_IS_MANAGER then
		SoraDShowMsgTip(i18n("atlantiswar_text_0352"))
	elseif content.err == gErrDef.Err_ATLANTIS_WAR_LV0_USER_NUM_LIMIT then
		local constantRead = include("constantRead")
		local num = constantRead.getConstValue("ATLANTISWAR_TEAM_MEMBER_R0", 50)
		_ENV = i18n("atlantiswar_text_0352")
		i18n("atlantiswar_text_0352").num = num
		SoraDShowMsgTip(i18n("atlantiswar_text_0353", i18n("atlantiswar_text_0352")))
	elseif content.err == gErrDef.Err_ATLANTIS_WAR_IS_LV0_USER then
		SoraDShowMsgTip(i18n("atlantiswar_text_0354"))
		self.lv0List = content.rspdata
	end
	_ENV = i18n("atlantiswar_text_0354")
	i18n("atlantiswar_text_0354").msg = "MESSAGE_ATLANTISWAR_LV0_REFRESH"
	i18n("atlantiswar_text_0354").err = content.err
	SoraDSendMessage(i18n("atlantiswar_text_0354"))
end
function atlantisActivityCtrl:reqRemoveLv0User(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_REMOVE_LV0_USER, nil)
end
function atlantisActivityCtrl:reqRemoveLv0UserRsp(content)
	dump(content, "atlantisActivityCtrl:reqRemoveLv0UserRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("atlantiswar_text_0348"))
		if not content.rspdata then
			_ENV = content.rspdata
		end
		self.lv0List = content.rspdata
	elseif content.err == gErrDef.Err_ATLANTIS_WAR_NOT_ADMIN then
		SoraDShowMsgTip(i18n("atlantiswar_text_0347"))
	elseif content.err == gErrDef.Err_ATLANTIS_WAR_STATE_ERR then
		local atlantisWarUtil = include("atlantisWarUtil")
		if atlantisWarUtil.isNewMap() then
			SoraDShowHelpMsgTip(i18n("atlantiswar_text_0020_KOH"))
		else
			SoraDShowHelpMsgTip(i18n("atlantiswar_text_0020"))
		end
	elseif content.err == gErrDef.Err_ATLANTIS_WAR_NOT_LV0_USER then
		SoraDShowMsgTip(i18n("common_text_2870"))
		self.lv0List = content.rspdata
	end
	_ENV = i18n("common_text_2870")
	i18n("common_text_2870").msg = "MESSAGE_ATLANTISWAR_LV0_REFRESH"
	i18n("common_text_2870").err = content.err
	SoraDSendMessage(i18n("common_text_2870"))
end
function atlantisActivityCtrl:reqGetLv0List()
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_GET_LV0_LIST)
end
function atlantisActivityCtrl:reqGetLv0ListRsp(content)
	dump(content, "atlantisActivityCtrl:reqGetLv0ListRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			_ENV = content.rspdata
		end
		self.lv0List = content.rspdata
	elseif content.err == gErrDef.Err_ATLANTIS_WAR_NOT_ADMIN then
		SoraDShowMsgTip(i18n("atlantiswar_text_0347"))
	end
	_ENV = i18n("atlantiswar_text_0347")
	i18n("atlantiswar_text_0347").msg = "MESSAGE_ATLANTISWAR_LV0_REFRESH"
	i18n("atlantiswar_text_0347").err = content.err
	SoraDSendMessage(i18n("atlantiswar_text_0347"))
end
function atlantisActivityCtrl:getLv0List(...)
	return self.lv0List
end
function atlantisActivityCtrl:reqStateDataRsp(content)
	dump(content, "atlantisActivityCtrl:reqStateDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.stateData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ATLANTISWAR_REFRESH"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function atlantisActivityCtrl:reqMatchResultRsp(content)
	dump(content, "atlantisActivityCtrl:reqMatchResultRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.matchResult = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ATLANTISWAR_REFRESH"
		gErrDef.Err_None.key = "reqMatchResultRsp"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function atlantisActivityCtrl:reqEnterBattlefieldRsp(content)
	dump(content, "atlantisActivityCtrl:reqEnterBattlefieldRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	else
		if content.err == gErrDef.Err_ATLANTIS_WAR_REACH_PLAYER_LIMIT then
			SoraDShowMsgBox(i18n("atlantiswar_text_0013"), i18n("common_text_204"), nil, function(eventType)
			end)
		elseif content.err == gErrDef.Err_ATLANTIS_WAR_LV0_USER_CAN_MOVE_IN then
			SoraDShowMsgTip(i18n("atlantiswar_text_0356"))
		end
		_ENV = i18n("atlantiswar_text_0356")
		i18n("atlantiswar_text_0356").msg = "MESSAGE_ATLANTISWAR_REFRESH"
		i18n("atlantiswar_text_0356").key = "errResetAnimation"
		SoraDSendMessage(i18n("atlantiswar_text_0356"))
	end
end
function atlantisActivityCtrl:reqQuitBattlefieldRsp(content)
	dump(content, "atlantisActivityCtrl:reqQuitBattlefieldRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
end
function atlantisActivityCtrl:reqGetManagerInfoRsp(content)
	dump(content, "atlantisActivityCtrl:reqGetManagerInfoRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.managerInfo = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ATLANTISWAR_REFRESH"
		gErrDef.Err_None.key = "reqGetManagerInfoRsp"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function atlantisActivityCtrl:reqModifyFlagRsp(content)
	dump(content, "atlantisActivityCtrl:reqModifyFlagRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.managerInfo.flag = content.data.flag
		_ENV = content.data.flag
		content.data.flag.msg = "MESSAGE_ATLANTISWAR_REFRESH"
		content.data.flag.key = "reqGetManagerInfoRsp"
		content.data.flag.rspdata = self.managerInfo
		SoraDSendMessage(content.data.flag)
	else
		_ENV = content.data.flag
		content.data.flag.msg = "MESSAGE_ATLANTISWAR_REFRESH"
		content.data.flag.key = "reqGetManagerInfoRsp"
		SoraDSendMessage(content.data.flag)
	end
end
function atlantisActivityCtrl:reqModifyManagerRsp(content)
	dump(content, "atlantisActivityCtrl:reqModifyManagerRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.managerInfo = content.rspdata
		SoraDShowMsgTip(i18n("atlantiswar_text_0032"))
		_ENV = i18n("atlantiswar_text_0032")
		i18n("atlantiswar_text_0032").msg = "MESSAGE_ATLANTISWAR_REFRESH"
		i18n("atlantiswar_text_0032").key = "reqGetManagerInfoRsp"
		i18n("atlantiswar_text_0032").rspdata = content.rspdata
		SoraDSendMessage(i18n("atlantiswar_text_0032"))
	else
		SoraDShowMsgTip(i18n("privilege_text_153"))
	end
end
function atlantisActivityCtrl:reqBuySkillGiftRsp(content)
	dump(content, "atlantisActivityCtrl:reqBuySkillGiftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local giftid = content.data.rechargeID
		local orderID = content.rspdata.orderID
		paymentManager.purchase(giftid, orderID)
	end
end
function atlantisActivityCtrl:reqSkillLotteryRsp(content)
	dump(content, "atlantisActivityCtrl:reqSkillLotteryRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.data.lotteryTimes = rspdata.lotteryTimes
		self.data.candidateSkill = rspdata.candidateSkill
		self.data.skillSlot = rspdata.skillSlot
		self.data.floorSelectTimes = rspdata.floorSelectTimes
		_ENV = rspdata.floorSelectTimes
		rspdata.floorSelectTimes.msg = "MESSAGE_ATLANTISWAR_SKILL_LOTTERY"
		rspdata.floorSelectTimes.index = rspdata.idx
		SoraDSendMessage(rspdata.floorSelectTimes)
		if not self.data.candidateSkill[tostring(rspdata.idx)] then
			_ENV = tostring(rspdata.idx)
			tostring(rspdata.idx).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			tostring(rspdata.idx).eventID = gActivityTimeActivityID.ATLANTIS_WAR_ACTIVITY
			SoraDSendMessage((tostring(rspdata.idx)))
		end
	end
end
function atlantisActivityCtrl:reqSkillReplaceRsp(content)
	dump(content, "atlantisActivityCtrl:reqSkillReplaceRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.data.candidateSkill = rspdata.candidateSkill
		self.data.skillSlot = rspdata.skillSlot
		_ENV = rspdata.skillSlot
		rspdata.skillSlot.msg = "MESSAGE_ATLANTISWAR_SKILL_REPLACE"
		rspdata.skillSlot.index = rspdata.idx
		SoraDSendMessage(rspdata.skillSlot)
	end
end
function atlantisActivityCtrl:reqSkillUseRsp(content)
	dump(content, "atlantisActivityCtrl:reqSkillUseRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.data.candidateSkill = rspdata.candidateSkill
		self.data.skillSlot = rspdata.skillSlot
		self.data.usedSkills = rspdata.usedSkills
		_ENV = rspdata.usedSkills
		rspdata.usedSkills.msg = "MESSAGE_ATLANTISWAR_SKILL_USE"
		rspdata.usedSkills.index = rspdata.idx
		SoraDSendMessage(rspdata.usedSkills)
		local skillSlot = self.data.skillSlot[tostring(rspdata.idx)]
		local ASD = require_data("atlantiswar_skill_display").data
		local config = ASD[skillSlot.skillId]
		_ENV = nil
		;(nil).var = i18n(config.name)
		local msgStr = i18n("atlantiswar_skill_text_037", nil) .. "\n" .. i18n(config.describe)
		local iconSprite = atlantisActivityCtrl:getSkillIconSprite(config.img, config.quality)
		local sOrder_enum = include("commonPromptTip").sOrder_enum
		_ENV = nil
		;(nil).offset = cc.p(0, 2)
		;(nil).sOrder = sOrder_enum.mapBuff
		SoraDShowMsgTip(msgStr, iconSprite, nil, nil)
	else
		SoraDShowMsgTip(i18n("endless_treasures_text_13"))
	end
end
function atlantisActivityCtrl:reqRankRsp(content)
	dump(content, "atlantisActivityCtrl:reqRankRsp(content)", 10)
	_ENV = content
	content.msg = "MESSAGE_ATLANTISWAR_REFRESH"
	content.key = "reqRankRsp"
	content.rspdata = content.rspdata
	content.err = content.err
	SoraDSendMessage(content)
end
function atlantisActivityCtrl:reqKindomRankRsp(content)
	dump(content, "atlantisActivityCtrl:reqKindomRankRsp(content)", 10)
	if content.rspdata and content.rspdata.selfKingdomInfo then
		self.kindomRank = content.rspdata.selfKingdomInfo.rank
	end
	_ENV = content
	content.msg = "MESSAGE_ATLANTISWAR_REFRESH"
	content.key = "reqRankRsp"
	content.isKindomRank = true
	content.rspdata = content.rspdata
	content.err = content.err
	SoraDSendMessage(content)
end
function atlantisActivityCtrl:reqHistoryRsp(content)
	dump(content, "atlantisActivityCtrl:reqHistoryRsp(content)", 10)
	_ENV = content
	content.msg = "MESSAGE_ATLANTISWAR_REFRESH"
	content.key = "reqHistoryRsp"
	content.rspdata = content.rspdata
	content.err = content.err
	SoraDSendMessage(content)
end
function atlantisActivityCtrl:reqGetTreasureInfo()
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_GET_TREASURE_INFO)
end
function atlantisActivityCtrl:reqGetTreasureInfoRsp(content)
	dump(content, "atlantisActivityCtrl:reqGetTreasureInfoRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			_ENV = content.rspdata
		end
		self.treasureInfo = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ATLANTISWAR_TREASUREINFO_REFRESH"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function atlantisActivityCtrl:reqSendTreasure(kid, treasureType)
	serverproxy = nil
	;(nil).kid = kid
	;(nil).treasureType = treasureType
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_SEND_TREASURE, nil)
end
function atlantisActivityCtrl:reqSendTreasureRsp(content)
	dump(content, "atlantisActivityCtrl:reqSendTreasureRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("atlantiswar_text_0388"))
		self.treasureInfo.atlantisWarTreasureData = content.rspdata
		_ENV = content.rspdata
		content.rspdata.msg = "MESSAGE_ATLANTISWAR_SENDTREASURE_REFRESH"
		SoraDSendMessage(content.rspdata)
	elseif content.err == gErrDef.Err_ATLANTIS_WAR_TREASURE_TIME_END then
		SoraDShowMsgTip(i18n("atlantiswar_text_0383"))
	end
end
function atlantisActivityCtrl:getTreasureInfo(...)
	return self.treasureInfo
end
function atlantisActivityCtrl:getTreasureName(treasureType)
	_UPVALUE3_ = nil
	;(nil)[1] = "atlantiswar_text_0369"
	;(nil)[2] = "atlantiswar_text_0370"
	local (nil)[3], config = "atlantiswar_text_0371", nil
	return i18n(treasureType and config[treasureType] or "undefined")
end
function atlantisActivityCtrl:getTreasureRemainTime(...)
	local endTime = self:getRoundEndTime()
	local curTime = serviceFunctions.systemTime()
	local constantRead = include("constantRead")
	local treasureTime = constantRead.getConstValue("ATLANTIS_WAR_TREASURE_TIME", 0)
	local remainTime = endTime + treasureTime - curTime
	return math.max(0, remainTime)
end
function atlantisActivityCtrl:checkIsTreasureSender(...)
	local data = self:getTreasureInfo()
	if data and data.top1Uid then
		local selfPlayerID = gametop.playertop_:getPlayerID() or 0
		return data.top1Uid == selfPlayerID
	end
	return false
end
function atlantisActivityCtrl:reqLegionBrief(season, brief)
	serverproxy = nil
	;(nil).season = season
	;(nil).brief = brief
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_LEGION_BRIEF, nil)
end
function atlantisActivityCtrl:reqLegionBriefRsp(content)
	dump(content, "atlantisActivityCtrl:reqLegionBriefRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("pyramid_text_89"))
		_ENV = i18n("pyramid_text_89")
		i18n("pyramid_text_89").msg = "MESSAGE_ATLANTISWAR_BRIEF_REFRESH"
		i18n("pyramid_text_89").rspdata = content.data
		SoraDSendMessage(i18n("pyramid_text_89"))
	elseif content.err == gErrDef.Err_ATLANTIS_WAR_SHIELDED_WORD then
		SoraDShowMsgTip(i18n("atlantiswar_text_0409"))
	elseif content.err == gErrDef.Err_ATLANTIS_WAR_NOT_KING then
		SoraDShowMsgTip(i18n("atlantiswar_text_0406"))
	end
end
function atlantisActivityCtrl:reqSelectSkill(idx, skillId)
	serverproxy = nil
	;(nil).idx = idx
	;(nil).skillId = skillId
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MGR_MODULE, gCmd.REQ_ATLANTIS_WAR_MGR_SELECT_SKILL, nil)
end
function atlantisActivityCtrl:reqSelectSkillRsp(content)
	dump(content, "atlantisActivityCtrl:reqSelectSkillRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.data.skillSlot = rspdata.skillSlot
		self.data.floorSelectTimes = rspdata.floorSelectTimes
		_ENV = rspdata.floorSelectTimes
		rspdata.floorSelectTimes.msg = "MESSAGE_ATLANTISWAR_SKILL_SELECT"
		rspdata.floorSelectTimes.index = rspdata.idx
		SoraDSendMessage(rspdata.floorSelectTimes)
	end
end
function atlantisActivityCtrl:getSelfArea(...)
	local kingdomId = gametop.playertop_:getKingdomID()
	for i, v in ipairs(self.matchResult) do
		if v.kid == kingdomId then
			return i
		end
	end
	return 0
end
function atlantisActivityCtrl:getStageEndTime()
	if self.stateData.timeConfig then
		if self.stateData.curState == ATLANTIS_WAR_STATE.BATTLE then
			return self.stateData.timeConfig.endTime or 0
		elseif self.stateData.curState == ATLANTIS_WAR_STATE.FINISH then
			return self.stateData.finishTime or 0
		else
			return self.stateData.timeConfig.battleTime or 0
		end
	else
		return 0
	end
end
function atlantisActivityCtrl:getActivityBeginTime()
	return self.stateData.activeTime
end
function atlantisActivityCtrl:getActivityCurState()
	return self.stateData.curState or 0
end
function atlantisActivityCtrl:getActivityEndTime()
	return self.stateData.finishTime or 0
end
function atlantisActivityCtrl:getRoundEndTime()
	return self.stateData.timeConfig and self.stateData.timeConfig.endTime or 0
end
function atlantisActivityCtrl:getNowRound()
	return self.stateData.round
end
function atlantisActivityCtrl:getKindomRank()
	return self.kindomRank or 0
end
function atlantisActivityCtrl:getSeason()
	local season = self.stateData.season or 1
	return self:handleSeason(season)
end
function atlantisActivityCtrl:getDataSeason()
	local season = self.data.season or 1
	return self:handleSeason(season)
end
function atlantisActivityCtrl:handleSeason(season)
	if IsArClient and 5 < season then
		return season - 1 - 1
	end
	return season
end
function atlantisActivityCtrl:getKingdomsList(...)
	return self.stateData.kingdoms
end
function atlantisActivityCtrl:getLastManualQuitTime()
	if self.stateData.myInfo and self.stateData.myInfo.lastManualQuitTime then
		return self.stateData.myInfo.lastManualQuitTime
	else
		return 0
	end
end
function atlantisActivityCtrl:getIsTest(...)
	return self.stateData.isTest == true
end
function atlantisActivityCtrl:getMatchKindomInfoByKid(kingdomId)
	for i, v in ipairs(self.matchResult) do
		if v.kid == kingdomId then
			return v
		end
	end
end
function atlantisActivityCtrl:getKingdomFlag()
	return self.managerInfo.flag
end
function atlantisActivityCtrl:getManagerInfo()
	return self.managerInfo
end
function atlantisActivityCtrl:havaManager()
	if self.managerInfo and self.managerInfo.adminInfo then
		return true
	else
		return false
	end
end
function atlantisActivityCtrl:isManager()
	if self.managerInfo then
		return self.managerInfo.adminInfo and self.managerInfo.adminInfo.uid == SoraDGetCtrl("lordInfoCtrl"):getLordInfo().base.uid
	else
		return false
	end
end
function atlantisActivityCtrl:getReceiveStatusAndNum(activityID)
	local showRed, num = self:getExchangeShopRedNum(activityID)
	local ret = self:getSkillRedStatus()
	if ret then
		showRed, num = true, num + 1
	end
	local atlantisPrivilegeCtrl = SoraDGetCtrl("atlantisPrivilegeCtrl")
	local _isRed = atlantisPrivilegeCtrl:getReceiveStatusAndNum()
	if _isRed then
		showRed, num = true, num + 1
	end
	return showRed, num
end
function atlantisActivityCtrl:getExchangeShopRedNum(activityID)
	local atlantisWarUtil = include("atlantisWarUtil")
	if atlantisWarUtil.isNewMap() then
		local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
		local shopNum = roaringFlameWarCtrl:getExchangeShopRedNum()
		return 0 < shopNum, shopNum
	else
		local showRed, num = SoraDGetCtrl("activityExchangeMallCtrl"):getReceiveStatusAndNum(activityID)
		return showRed, num
	end
end
function atlantisActivityCtrl:getSkillRedStatus()
	if SoraDGetCastleLv() < ATLANTIS_WAR_CASTLE_LEVEL then
		return false
	end
	if self:getActivityCurState() == ATLANTIS_WAR_STATE.FINISH then
		return false
	end
	local skillSlot = self:getSkillData("skillSlot")
	local isPrivilegeLock = self:getSkillData("isPrivilegeLock")
	local nums = table.nums(skillSlot)
	if isPrivilegeLock and nums < 5 or nums < 3 then
		return true
	end
	return false
end
function atlantisActivityCtrl:getSkillData(dataName)
	if dataName then
		return self.data[dataName]
	end
	_UPVALUE0_ = self.data[dataName]
	self.data[dataName].skillSlot = self.data.skillSlot
	self.data[dataName].candidateSkill = self.data.candidateSkill
	self.data[dataName].isPrivilegeLock = self.data.isPrivilegeLock
	self.data[dataName].lotteryTimes = self.data.lotteryTimes
	self.data[dataName].usedSkills = self.data.usedSkills
	self.data[dataName].floorSelectTimes = self.data.floorSelectTimes
	return self.data[dataName]
end
function atlantisActivityCtrl:getUsedSkillTimes()
	return self.data.floorSelectTimes or 0
end
function atlantisActivityCtrl:getSkillSlot(...)
	return self.data.skillSlot
end
function atlantisActivityCtrl:getCandidateSkill(...)
	return self.data.candidateSkill
end
function atlantisActivityCtrl:isUsedSkillTimesEnough()
	local atlantisActivityRead = include("atlantisActivityRead")
	local maxNum = atlantisActivityRead.getConstValue("ATLANTISWAR_SKILL_TIME", 60)
	return maxNum <= self:getUsedSkillTimes()
end
function atlantisActivityCtrl:checkSkillSlotAndCandidateSkill(skillId)
	local skillSlot = self:getSkillSlot()
	for k, v in pairs(skillSlot) do
		if v.skillId == skillId then
			return true
		end
	end
	local candidateSkill = self:getCandidateSkill()
	for k, v in pairs(candidateSkill) do
		if v == skillId then
			return true
		end
	end
	return false
end
function atlantisActivityCtrl:getSkillSlotSkillId(index)
	local skillSlot = self:getSkillSlot()
	return skillSlot[tostring(index)].skillId
end
function atlantisActivityCtrl:getSkillConfig(skillId)
	local ASC = require_data("atlantiswar_skill_config", true).data
	if not self.skillConfigMap then
		self.skillConfigMap, _ENV = self.skillConfigMap, self.skillConfigMap
		for k, v in pairs(ASC) do
			self.skillConfigMap[v.skillID] = k
		end
	end
	local index = self.skillConfigMap[skillId]
	return ASC[index]
end
function atlantisActivityCtrl:getSkillIdByTypeAndValue(type, value)
	local ASC = require_data("atlantiswar_skill_config", true).data
	if not self.skillTypeMap then
		self.skillTypeMap, _ENV = self.skillTypeMap, self.skillTypeMap
		for i, v in ipairs(ASC) do
			if v.type ~= ATLANTIS_WAR_SKILL_TYPE.BUFF then
				if not self.skillTypeMap[v.type] then
					_ENV = self.skillTypeMap[v.type]
				end
				self.skillTypeMap[v.type] = self.skillTypeMap[v.type]
				table.insert(self.skillTypeMap[v.type], i)
			end
		end
	end
	for _, index in ipairs(self.skillTypeMap[type]) do
		if ASC[index].value == value then
			return ASC[index].skillID
		end
	end
end
function atlantisActivityCtrl:skillTypeToAttr(type)
	_ENV = nil
	;(nil)[ATLANTIS_WAR_SKILL_TYPE.AREA_TROOP_ATTACK_BOOST] = gAttributeEnum.BATTLE_ATTACK_RATE_RANGE
	;(nil)[ATLANTIS_WAR_SKILL_TYPE.AREA_TROOP_DEFENSE_BOOST] = gAttributeEnum.BATTLE_DEFEND_RATE_RANGE
	;(nil)[ATLANTIS_WAR_SKILL_TYPE.AREA_TROOP_HP_BOOST] = gAttributeEnum.BATTLE_HP_RATE_RANGE
	;(nil)[ATLANTIS_WAR_SKILL_TYPE.AREA_TROOP_DAMAGE_BOOST] = gAttributeEnum.BATTLE_DAMAGE_RATE_RANGE
	;(nil)[ATLANTIS_WAR_SKILL_TYPE.AREA_MARCH_SPEED_BOOST] = gAttributeEnum.MARCH_SPEED_BOOST_RAGNE
	;(nil)[ATLANTIS_WAR_SKILL_TYPE.AREA_CURE_SOLDIER_SPEED_BOOST] = gAttributeEnum.CURE_SOLDIER_SPEED_BOOST_RANGE
	local (nil)[ATLANTIS_WAR_SKILL_TYPE.AREA_HALLOFWAR_ARMY_UP], skillTypeToAttr = gAttributeEnum.HALLOFWAR_ARMY_UP_RANGE, nil
	return skillTypeToAttr[type]
end
function atlantisActivityCtrl:attrToSkillType(attr)
	_ENV = nil
	;(nil)[gAttributeEnum.BATTLE_ATTACK_RATE_RANGE] = ATLANTIS_WAR_SKILL_TYPE.AREA_TROOP_ATTACK_BOOST
	;(nil)[gAttributeEnum.BATTLE_DEFEND_RATE_RANGE] = ATLANTIS_WAR_SKILL_TYPE.AREA_TROOP_DEFENSE_BOOST
	;(nil)[gAttributeEnum.BATTLE_HP_RATE_RANGE] = ATLANTIS_WAR_SKILL_TYPE.AREA_TROOP_HP_BOOST
	;(nil)[gAttributeEnum.BATTLE_DAMAGE_RATE_RANGE] = ATLANTIS_WAR_SKILL_TYPE.AREA_TROOP_DAMAGE_BOOST
	;(nil)[gAttributeEnum.MARCH_SPEED_BOOST_RAGNE] = ATLANTIS_WAR_SKILL_TYPE.AREA_MARCH_SPEED_BOOST
	;(nil)[gAttributeEnum.CURE_SOLDIER_SPEED_BOOST_RANGE] = ATLANTIS_WAR_SKILL_TYPE.AREA_CURE_SOLDIER_SPEED_BOOST
	local (nil)[gAttributeEnum.HALLOFWAR_ARMY_UP_RANGE], attrToSkillType = ATLANTIS_WAR_SKILL_TYPE.AREA_HALLOFWAR_ARMY_UP, nil
	return attrToSkillType[attr]
end
function atlantisActivityCtrl:getBuffConfig(effect, src)
	local AMBC = require_data("atlantiswar_master_buff_config").data
	if not self.buffConfigMap then
		self.buffConfigMap, _ENV = self.buffConfigMap, self.buffConfigMap
		for k, v in pairs(AMBC) do
			for _, id in ipairs(v.Buff) do
				if not self.buffConfigMap[id] then
					_ENV = self.buffConfigMap[id]
				end
				self.buffConfigMap[id] = self.buffConfigMap[id]
				self.buffConfigMap[id][v.type] = k
			end
		end
	end
	local index
	if not src then
		for _, v in pairs(self.buffConfigMap[effect]) do
			index = v
			break
		end
	else
		_ENV = pairs(self.buffConfigMap[effect])
		pairs(self.buffConfigMap[effect])[902] = 2
		pairs(self.buffConfigMap[effect])[903] = 2
		local pairs(self.buffConfigMap[effect])[904], src2type = 2, pairs(self.buffConfigMap[effect])
		local buffType = src and src2type[src] or 1
		index = self.buffConfigMap[effect][buffType]
	end
	return AMBC[index]
end
function atlantisActivityCtrl:getMapBufValueType(buffId)
	local ASD = require_data("atlantiswar_scopeskill_des").data
	return ASD[buffId].type
end
function atlantisActivityCtrl:getMapBuffDescribe(buffId, value)
	local ASD = require_data("atlantiswar_scopeskill_des").data
	local config = ASD[buffId]
	if config == nil then
		return nil
	end
	if config.type == 1 then
		_ENV = nil
		;(nil).var = value / 100
		return i18n(config.describe, nil)
	else
		_ENV = nil
		;(nil).var = string.formatnumberthousands(value)
		return i18n(config.describe, nil)
	end
end
function atlantisActivityCtrl:getSkillIconSprite(icon, quality)
	local iconSprite = display.newSprite("#" .. icon)
	local qImage = gAtlantisQualityConfig[quality].qImage
	local qSprite = display.newSprite("#" .. qImage)
	qSprite:addTo(iconSprite)
	local sSize = iconSprite:getContentSize()
	qSprite:setPosition(sSize.width / 2, sSize.height / 2)
	return iconSprite
end
function atlantisActivityCtrl:getBuffEffect(effectType)
	if not worldMapDefine.isInAtlantis() then
		return 0
	end
	local getInWarValue = function()
		local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
		local personVal = atlantisWarCtrl:getPlayerBuffValue(effectType)
		local teamVal = atlantisWarCtrl:getTeamBuffValue(effectType)
		return personVal + teamVal
	end
	local getOutWarValue = function()
		local usedSkills = self:getSkillData("usedSkills")
		if not usedSkills or not next(usedSkills) then
			return 0
		end
		if not self.effectTypeMap then
			self.effectTypeMap, self = self.effectTypeMap, self.effectTypeMap
			local ASC = require_data("atlantiswar_skill_config", true).data
			for k, v in pairs(ASC) do
				local effect = v.buff[1]
				if effect then
					if not self.effectTypeMap[effect] then
						self = self.effectTypeMap[effect]
					end
					self.effectTypeMap[effect] = self.effectTypeMap[effect]
					table.insert(self.effectTypeMap[effect], v.skillID)
				end
			end
		end
		if not self.effectTypeMap[effectType] then
			local self, list = self.effectTypeMap[effectType], self.effectTypeMap[effectType]
		end
		if not next(list) then
			return 0
		end
		local value = 0
		local sysTime = serviceFunctions.systemTime()
		for i, skillID in ipairs(list) do
			if usedSkills[tostring(skillID)] then
				local skill = self:getSkillConfig(skillID)
				local add = skill.buff[2] or 0
				value = value + add
			end
		end
		return value
	end
	print("==atlantisActivityCtrl:getBuffEffect==", effectType, getInWarValue(), getOutWarValue())
	return getInWarValue() + getOutWarValue()
end
function atlantisActivityCtrl:getPalaceRemainTime(...)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local winAtlantisSeasonTime = lordInfoCtrl:getWinAtlantisSeasonTime()
	if not winAtlantisSeasonTime or winAtlantisSeasonTime <= 0 then
		return 0
	end
	local constantRead = include("constantRead")
	local lastTime = constantRead.getConstValue("ATLANTIS_SIGNATURE_TIME", 0)
	local remainTime = winAtlantisSeasonTime + lastTime - serviceFunctions.systemTime()
	remainTime = math.max(0, remainTime)
	return remainTime
end
function atlantisActivityCtrl:getPalaceBuffEffect(effectType)
	local winWarLeftTime = self:getPalaceRemainTime()
	if not winWarLeftTime or winWarLeftTime <= 0 then
		return 0
	end
	local plus = 0
	local palaceInfoRead = include("palaceInfoRead")
	local kingdomPalaceCfg = palaceInfoRead.getAtlantisKingdomPalace()
	if kingdomPalaceCfg then
		if not kingdomPalaceCfg.buff then
			_ENV = kingdomPalaceCfg.buff
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "value"
		local buffList = serviceFunctions.tableFormat(kingdomPalaceCfg.buff, nil)
		for _, buff in ipairs(buffList) do
			if buff.type == effectType then
				plus = plus + buff.value
			end
		end
	end
	return plus
end
function atlantisActivityCtrl:checkShowRecordView()
	local season = self:getSeason()
	local curState = self:getActivityCurState()
	if 1 < season or season <= 1 and curState == ATLANTIS_WAR_STATE.FINISH then
		return true
	end
	SoraDShowMsgTip(i18n("atlantiswar_text_0034"))
	return false
end
function atlantisActivityCtrl:checkShowBtnPoint(...)
	local round = self:getNowRound() or 0
	local curState = self:getActivityCurState()
	if round <= 1 and (curState < ATLANTIS_WAR_STATE.BATTLE or curState == ATLANTIS_WAR_STATE.RESULT) then
		return false
	end
	return true
end
return atlantisActivityCtrl
