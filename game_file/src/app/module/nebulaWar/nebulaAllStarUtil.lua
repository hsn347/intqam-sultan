local gametop = gModuleMgr.getObject("gametop")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaAllStarRead = include("nebulaAllStarRead")
local NEBULA_ALL_STAR_STATE = nebulaAllStarRead.NEBULA_ALL_STAR_STATE
local _ENV, nebulaAllStarUtil
function nebulaAllStarUtil.getIsDebug(...)
	return device.platform == "mac" or userSDKManager.isBeta() or userSDKManager.isGameDevelop()
end
function nebulaAllStarUtil.initCheatBtn(obj)
	if nebulaAllStarUtil.getIsDebug() then
		obj:setString("切换状态")
		obj:addClickListener(function()
			local cheatCtrl = SoraDGetCtrl("cheatCtrl")
			_ENV = nil
			;(nil).command = "qhxyqmxzt"
			cheatCtrl:reqCheat(nil, nil)
		end)
	else
		obj:setVisible(false)
	end
end
function nebulaAllStarUtil.getTeamRemainNum()
	local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
	local num = myTeamInfo:getTeamMemberNum()
	local merberMax = nebulaAllStarRead.getTeamNumMax()
	return math.max(0, merberMax - num)
end
function nebulaAllStarUtil.getAreaNameAndIcon(...)
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local nebulaWarRead = include("nebulaWarRead")
	local __, regionId = nebulaActivityCtrl:getKingdomRegionType()
	local areaName = nebulaWarRead.getAreaName(regionId)
	local areaIcon = nebulaWarRead.getAreaIcon(regionId)
	return areaName, areaIcon
end
function nebulaAllStarUtil.getAreaNameAndBigIcon(...)
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local nebulaWarRead = include("nebulaWarRead")
	local __, regionId = nebulaActivityCtrl:getKingdomRegionType()
	local areaName = nebulaWarRead.getAreaName(regionId)
	local areaIcon = nebulaWarRead.getAreaBigIcon(regionId)
	return areaName, areaIcon
end
function nebulaAllStarUtil.checkEnterBattleField(enterCallback)
	local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
	if not myTeamInfo:isHasTeam() then
		SoraDShowMsgBox(i18n("nebulaemperor_text_8"), i18n("common_text_477"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
			end
		end)
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("atlantiswar_text_0009"))
		return
	end
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	if kingdomMapCtrl:isHasQueue() ~= 0 then
		SoraDShowMsgTip(i18n("atlantiswar_text_0010"))
		return
	end
	enterCallback()
	return true
end
function nebulaAllStarUtil.checkJoinTeam(...)
	if not nebulaAllStarUtil.checkBuildStarLv() then
		SoraDShowMsgTip(i18n("NebulaAllstar_64"))
		return
	end
	return true
end
function nebulaAllStarUtil.checkBuildStarLv(...)
	local starLv = nebulaAllStarRead.getNeedLv()
	return starLv <= SoraDGetBuildStarLv()
end
function nebulaAllStarUtil.checkQuitTeamState(...)
	local curState = nebulaAllStarCtrl:getActivityCurState()
	return curState < NEBULA_ALL_STAR_STATE.ALL_STAR_TEAM
end
function nebulaAllStarUtil.checkActivityState(state)
	local curState = nebulaAllStarCtrl:getActivityCurState()
	return curState == state
end
function nebulaAllStarUtil.checkSettleState(...)
	return nebulaAllStarUtil.checkActivityState(NEBULA_ALL_STAR_STATE.SETTLE)
end
function nebulaAllStarUtil.checkBattleState(...)
	return nebulaAllStarUtil.checkActivityState(NEBULA_ALL_STAR_STATE.BATTLE)
end
function nebulaAllStarUtil.checkActivityOpen()
	local curState = nebulaAllStarCtrl:getActivityCurState()
	if curState ~= NEBULA_ALL_STAR_STATE.NONE and curState ~= NEBULA_ALL_STAR_STATE.FINISH then
		return true
	else
		return false
	end
end
function nebulaAllStarUtil.checkShowInviteState(...)
	if not nebulaAllStarCtrl:isActivityOpen() then
		return false
	end
	if nebulaAllStarUtil.checkQuitTeamState() then
		return true
	else
		return false
	end
end
function nebulaAllStarUtil.checkShowEnterBtn(...)
	local curState = nebulaAllStarCtrl:getActivityCurState()
	if curState == NEBULA_ALL_STAR_STATE.ENTER_ROOM or curState == NEBULA_ALL_STAR_STATE.BATTLE then
		local showEnter = not worldMapDefine.isInNebulaAllStar(true)
		return showEnter
	end
	return false
end
function nebulaAllStarUtil.openTeamView()
	_ENV = nil
	;(nil).isSuperTeam = true
	uiManager:show("NebulaAllStarTeam", nil)
end
function nebulaAllStarUtil.openBackupTeamView()
	if nebulaAllStarUtil.checkSignBackupTeamState() then
		uiManager:show("NebulaAllStarTeamBackup")
	else
		nebulaAllStarUtil = nil
		;(nil).isSuperTeam = false
		uiManager:show("NebulaAllStarTeam", nil)
	end
end
function nebulaAllStarUtil.openGuessView()
	if nebulaAllStarUtil.checkGuessState() then
		uiManager:show("NebulaAllStarGuessView")
	else
		SoraDShowMsgTip(i18n("NebulaAllstar_341"))
	end
end
function nebulaAllStarUtil.openRankView(...)
	local curState = nebulaAllStarCtrl:getActivityCurState()
	if curState < NEBULA_ALL_STAR_STATE.ENTER_ROOM then
		SoraDShowMsgTip(i18n("NebulaAllstar_14"))
		return
	end
	uiManager:show("NebulaAllStarRank")
end
function nebulaAllStarUtil.openGiftView(...)
	if nebulaAllStarUtil.isWarTest() then
		SoraDShowMsgTip(i18n("NebulaAllstar_285"))
		return
	end
	nebulaAllStarUtil = i18n("NebulaAllstar_285")
	i18n("NebulaAllstar_285").activityID = gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY
	uiManager:show("NebulaEmperorGift", i18n("NebulaAllstar_285"))
end
function nebulaAllStarUtil.checkGuessState(...)
	local curState = nebulaAllStarCtrl:getActivityCurState()
	return curState == NEBULA_ALL_STAR_STATE.BATTLE or curState == NEBULA_ALL_STAR_STATE.SETTLE
end
function nebulaAllStarUtil.checkSignBackupTeamState(...)
	local curState = nebulaAllStarCtrl:getActivityCurState()
	return curState < NEBULA_ALL_STAR_STATE.BACKUP_GROUP_TEAM
end
function nebulaAllStarUtil.getStateName(curState)
	NEBULA_ALL_STAR_STATE = nil
	;(nil)[NEBULA_ALL_STAR_STATE.BEGIN] = "NebulaAllstar_15"
	;(nil)[NEBULA_ALL_STAR_STATE.ALL_STAR_TEAM] = "NebulaAllstar_15"
	;(nil)[NEBULA_ALL_STAR_STATE.BACKUP_GROUP_TEAM] = "NebulaAllstar_15"
	;(nil)[NEBULA_ALL_STAR_STATE.ENTER_ROOM] = "NebulaAllstar_24"
	local (nil)[NEBULA_ALL_STAR_STATE.BATTLE], state2name = "NebulaAllstar_30", nil
	return i18n(state2name[curState]) or ""
end
function nebulaAllStarUtil.getStateEndTime(curState)
	NEBULA_ALL_STAR_STATE = nil
	;(nil)[NEBULA_ALL_STAR_STATE.BEGIN] = NEBULA_ALL_STAR_STATE.ENTER_ROOM
	;(nil)[NEBULA_ALL_STAR_STATE.ALL_STAR_TEAM] = NEBULA_ALL_STAR_STATE.ENTER_ROOM
	;(nil)[NEBULA_ALL_STAR_STATE.BACKUP_GROUP_TEAM] = NEBULA_ALL_STAR_STATE.ENTER_ROOM
	;(nil)[NEBULA_ALL_STAR_STATE.ENTER_ROOM] = NEBULA_ALL_STAR_STATE.BATTLE
	local (nil)[NEBULA_ALL_STAR_STATE.BATTLE], config = NEBULA_ALL_STAR_STATE.SETTLE, nil
	local nextState = config[curState] or curState + 1
	return nebulaAllStarCtrl:getStateBeginTime(nextState)
end
function nebulaAllStarUtil.getStateRemainTime(curState)
	curState = curState or nebulaAllStarCtrl:getActivityCurState()
	local endTime = nebulaAllStarUtil.getStateEndTime(curState)
	local remainTime = endTime - serviceFunctions.systemTime()
	return remainTime
end
function nebulaAllStarUtil.getSignUpCDRemainTime(...)
	local lastSignUpTime = nebulaAllStarCtrl:getLastSignUpTime()
	if 0 < lastSignUpTime then
		local signCD = nebulaAllStarRead.getSupportEnrollCD()
		return math.max(0, lastSignUpTime + signCD - serviceFunctions.systemTime())
	end
	return 0
end
function nebulaAllStarUtil.getPalaceOwner(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local buildIDList = nebulaAllStarRead.getBuildIDListByType(gWorldTypeServerDef.subTypeNebulaAllStarWarPalace)
	return kingdomMapCtrl:getWarBuildingOwner(worldMapDefine.currentMapKindomID, buildIDList[1])
end
function nebulaAllStarUtil.getPalaceOwnerCamp(...)
	local owner = nebulaAllStarUtil.getPalaceOwner()
	if owner then
		return owner.camp
	end
end
function nebulaAllStarUtil.getRankFirstCampInfo(...)
	local campInfo = nebulaAllStarUtil.getOccupyPalaceSecsCampInfo()
	_UPVALUE2_, _UPVALUE3_ = nil, nil
	_UPVALUE2_, (nil)[1] = "occupyPalaceSecs", "occupyPalaceSecs"
	_UPVALUE2_, (nil)[2] = "occupyPalaceSecs", ">"
	_UPVALUE2_, ("occupyPalaceSecs")[1] = "occupyPalaceEndTime", "occupyPalaceEndTime"
	_UPVALUE2_, ("occupyPalaceSecs")[2] = "occupyPalaceEndTime", "<"
	;("occupyPalaceEndTime")[1] = "camp"
	;("occupyPalaceEndTime")[2] = "<"
	;(nil)[1] = nil
	;(nil)[2] = "occupyPalaceSecs"
	;(nil)[3] = "occupyPalaceEndTime"
	local ret, camp = serviceFunctions.tableMax(campInfo, nil)
	return ret, camp
end
function nebulaAllStarUtil.getOccupyPalaceSecsCampInfo(...)
	local campInfo = nebulaAllStarCtrl:getCampInfo()
	local owner = nebulaAllStarUtil.getPalaceOwner()
	local nebulaAllStarCtrl, ret
	for camp, v in ipairs(campInfo) do
		local occupyPalaceSecs = v.occupyPalaceSecs or 0
		if owner and owner.camp == camp then
			local time = serviceFunctions.systemTime() - owner.beginOccupyTime
			occupyPalaceSecs = occupyPalaceSecs + math.max(0, time)
		end
		nebulaAllStarCtrl = 0
		;(0).occupyPalaceSecs = occupyPalaceSecs
		;(0).occupyPalaceEndTime = v.occupyPalaceEndTime or 0
		;(0).camp = camp
		table.insert(ret, 0)
	end
	return ret
end
function nebulaAllStarUtil.checkDonateState(...)
	local curState = nebulaAllStarCtrl:getActivityCurState()
	return curState < NEBULA_ALL_STAR_STATE.ENTER_ROOM
end
function nebulaAllStarUtil.agreeOrRejectTeamInvite(handle)
	SoraDShowMsgBox(i18n("NebulaAllstar_86"), i18n("common_text_140"), i18n("common_text_091"), function(callBack)
		if callBack ~= MSGBOX_CALLBACK_YES and callBack ~= MSGBOX_CALLBACK_NO then
			return
		end
		local teamCtrl = SoraDGetCtrl("teamCtrl")
		local teamAreaEnum = include("teamDef").teamAreaEnum
		local myTeamInfo = teamCtrl:getTeamData(teamAreaEnum.NEBULA_ALL_STAR)
		if myTeamInfo:isHasTeam() then
			SoraDShowMsgTip(i18n("NebulaAllstar_88"))
			return
		end
		local inviteList = myTeamInfo:getInvitedInfo()
		if not next(inviteList) then
			SoraDShowMsgTip(i18n("NebulaAllstar_277"))
			return
		end
		local tid = inviteList[1].tid
		if callBack == MSGBOX_CALLBACK_YES then
			myTeamInfo:reqTeamAgreeInvite(tid)
		elseif callBack == MSGBOX_CALLBACK_NO then
			myTeamInfo:reqTeamRejectInvite(tid)
		end
		if handle then
			handle()
		end
	end)
end
function nebulaAllStarUtil.getTeamAbbr(regionId, teamId)
	local teamAbbr = ""
	if nebulaAllStarCtrl:checkIsAllStarTeam(teamId) then
		teamAbbr = nebulaAllStarRead.getAllStarTeamAbbr(regionId)
	else
		teamAbbr = nebulaAllStarRead.getSupportTeamAbbr(regionId)
	end
	return teamAbbr
end
function nebulaAllStarUtil.getEventFuncConfig(cfg)
	if nebulaAllStarUtil.isWarTest() then
		cfg.eventName = i18n("NebulaAllstar_283")
	end
	if not nebulaAllStarUtil.checkActivityOpen() then
		if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY) then
			return cfg
		else
			return
		end
	end
	local curState = nebulaAllStarCtrl:getActivityCurState()
	local timerLast
	if curState <= NEBULA_ALL_STAR_STATE.BACKUP_GROUP_TEAM then
		timerLast = "NebulaAllstar_10"
	elseif curState == NEBULA_ALL_STAR_STATE.ENTER_ROOM then
		timerLast = "NebulaAllstar_11"
	elseif curState == NEBULA_ALL_STAR_STATE.BATTLE then
		timerLast = "NebulaAllstar_12"
	else
		timerLast = "NebulaAllstar_13"
	end
	if not cfg.eventLeftTime then
		local nebulaAllStarUtil, eventLeftTime = cfg.eventLeftTime, cfg.eventLeftTime
	end
	eventLeftTime.timerLast = timerLast
	local remainTime = nebulaAllStarUtil.getStateRemainTime(curState)
	clientEventMgr.addEventTimer(gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY, remainTime)
	return cfg
end
function nebulaAllStarUtil.gotoViewerWorldMap(...)
	local kid = nebulaAllStarUtil.getKindomIDStart()
	local pos = nebulaAllStarUtil.getCampBuildingPos()
	SoraDGotoWorldMapPoint(pos, false, kid, nil, nil, true)
	SoraDRemoveAllPanelFromManager()
end
function nebulaAllStarUtil.getKindomIDStart(...)
	return GAME_KINGDOM_ID_ASSIGN.NEBULA_ALLSTAR.START
end
function nebulaAllStarUtil.getCampBuildingPos()
	local regionId = nebulaAllStarCtrl:getSelfCamp()
	local buildID = 90000 + regionId
	local pos = nebulaAllStarRead.getBuildPos(buildID)
	return pos
end
function nebulaAllStarUtil.checkTeamHasApproval(...)
	if not nebulaAllStarUtil.checkQuitTeamState() then
		return false
	end
	local notRemind = nebulaAllStarUtil.getApprovalNotRemind()
	if notRemind then
		return false
	end
	local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
	return myTeamInfo:isTeamHasApproval()
end
function nebulaAllStarUtil.getApprovalNotRemind(...)
	_ENV = nil
	;(nil).byUID = true
	return SoraDConfigGet("Game:nebulaAllStar:approvalNotRemind~bool", nil)
end
function nebulaAllStarUtil.setApprovalNotRemind(value)
	_ENV = nil
	;(nil).byUID = true
	return SoraDConfigSet("Game:nebulaAllStar:approvalNotRemind~bool", value, nil)
end
function nebulaAllStarUtil.getBarrageSetting(...)
	_UPVALUE3_ = nil
	;(nil)[1] = 2
	;(nil)[2] = 2
	local (nil)[3], defSetting = true, nil
	return SoraDConfigGet("Game:nebulaAllStar:barrageSetting~table") or defSetting
end
function nebulaAllStarUtil.setBarrageSetting(value)
	return SoraDConfigSet("Game:nebulaAllStar:barrageSetting~table", value)
end
function nebulaAllStarUtil.getGiftBandageStr(...)
	local maxBandage = nebulaAllStarRead.getConstValue("MaxBandage", 0)
	local giftBandage = nebulaAllStarCtrl:getGiftBandageCount()
	nebulaAllStarRead = nil
	;(nil).member = string.formatnumberthousands(giftBandage)
	;(nil).total = string.formatnumberthousands(maxBandage)
	local countStr = i18n("common_text_155", nil)
	if maxBandage <= giftBandage then
		nebulaAllStarRead = string.formatnumberthousands(maxBandage)
		string.formatnumberthousands(maxBandage).color = "#E02B2B"
		countStr = SoraDWrapHtmlTagByStyle(countStr, (string.formatnumberthousands(maxBandage)))
	end
	return countStr
end
function nebulaAllStarUtil.getRankStr(rank)
	local rankStr = ""
	if 0 < rank and rank < 999999 then
		rankStr = tostring(rank)
	else
		rankStr = i18n("herobattle_text_05")
	end
	return rankStr
end
function nebulaAllStarUtil.getRankDataMyInfo(myInfo)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local dressCtrl = SoraDGetCtrl("dressCtrl")
	local lordInfo = lordInfoCtrl:getLordInfo()
	myInfo.nickName = myInfo.nickName or lordInfo.base.nickName
	myInfo.headid = myInfo.headid or lordInfo.base.imageId
	myInfo.avatar = myInfo.avatar or lordInfo.base.avatar
	myInfo.avatarFrameId = myInfo.avatarFrameId or dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_FRAME)
	myInfo.camp = myInfo.camp or nebulaAllStarCtrl:getSelfCamp()
	myInfo.uid = myInfo.uid or gametop.playertop_:getPlayerID() or 0
	return myInfo
end
function nebulaAllStarUtil.parseChatContentText(content)
	local chatDesRead = include("chatDesRead")
	local nebulaWarRead = include("nebulaWarRead")
	local result = i18n("common_text_4425")
	local kingdomMsgType = content.kingdomMsgType
	local cfg = chatDesRead.getChatNoticeCfg(kingdomMsgType)
	if not cfg then
		return result
	end
	if kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_occupy_palace then
		local areaAbbr = nebulaWarRead.getAreaAbbr(content.values.area)
		_ENV = nil
		;(nil).abbr = areaAbbr
		;(nil).name = content.values.name
		local name = i18n("common_text_186", nil)
		_ENV = content.values.name
		content.values.name.name = name
		result = i18n(cfg.des, content.values.name)
	elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_winner then
		local areaName = nebulaWarRead.getAreaName(content.values.camp)
		_ENV = cfg.des
		cfg.des.name = areaName
		result = i18n(cfg.des, cfg.des)
	elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_rob_star_value or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_rob_support_value or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_star_value or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_support_value then
		local areaAbbr = nebulaWarRead.getAreaAbbr(content.values.area)
		_ENV = cfg.des
		cfg.des.abbr = areaAbbr
		cfg.des.name = content.values.name
		local name = i18n("common_text_186", cfg.des)
		_ENV = content.values.name
		content.values.name.name = name
		content.values.name.num = content.values.value
		result = i18n(cfg.des, content.values.name)
	elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_viewer_gift then
		_ENV = i18n("common_text_186", cfg.des)
		i18n("common_text_186", cfg.des).nebulaChatMsgType = gNebulaChatMsgType.viewer_gift
		i18n("common_text_186", cfg.des).values = content.values
		return nebulaAllStarUtil.parseChatSysText((i18n("common_text_186", cfg.des)))
	end
	return result
end
function nebulaAllStarUtil.parseChatSysText(content)
	dump(content, "==nebulaAllStarUtil.parseChatSysText==")
	local nebulaWarRead = include("nebulaWarRead")
	local values = content.values
	local msgType = content.nebulaChatMsgType
	if msgType == gNebulaChatMsgType.viewer_gift then
		local nebulaWarRead = include("nebulaWarRead")
		local abbr1 = nebulaWarRead.getAreaAbbr(values.senderCamp)
		local name1 = textParser.formatPlayerName(abbr1, values.senderName)
		local abbr2 = nebulaWarRead.getAreaAbbr(values.receiverCamp)
		local name2 = textParser.formatPlayerName(abbr2, values.receiverName)
		local itemDesRead = include("itemDesRead")
		local itemName = itemDesRead.getName(values.itemId)
		_ENV = nil
		;(nil).NAME1 = name1
		;(nil).NAME2 = name2
		;(nil).num = values.num
		;(nil).NAME3 = itemName
		return i18n("NebulaAllstar_366", nil)
	elseif msgType == gNebulaChatMsgType.quiz_refresh then
		return i18n("NebulaAllstar_365")
	elseif msgType == gNebulaChatMsgType.war_will_end then
		_ENV = textParser.formatPlayerName(abbr1, values.senderName)
		textParser.formatPlayerName(abbr1, values.senderName).time = values.time
		return i18n("NebulaAllstar_347", (textParser.formatPlayerName(abbr1, values.senderName)))
	elseif msgType == gNebulaChatMsgType.nebula_allstar_war_palace_begin then
		return i18n("NebulaAllstar_345")
	elseif msgType == gNebulaChatMsgType.nebula_allstar_war_occupy_palace then
		local name = textParser.formatPlayerName(nil, values.name, values.kid)
		_ENV = values.kid
		values.kid.NAME = name
		return i18n("NebulaAllstar_363", values.kid)
	elseif msgType == gNebulaChatMsgType.nebula_allstar_war_lose_palace then
		return i18n("NebulaAllstar_364")
	elseif msgType == gNebulaChatMsgType.nebula_allstar_war_rob_star_value or msgType == gNebulaChatMsgType.nebula_allstar_war_rob_support_value then
		_ENV = gNebulaChatMsgType.nebula_allstar_war_rob_support_value
		gNebulaChatMsgType.nebula_allstar_war_rob_support_value[gNebulaChatMsgType.nebula_allstar_war_rob_star_value] = "NebulaAllstar_368"
		local gNebulaChatMsgType.nebula_allstar_war_rob_support_value[gNebulaChatMsgType.nebula_allstar_war_rob_support_value], config = "NebulaAllstar_369", gNebulaChatMsgType.nebula_allstar_war_rob_support_value
		local abbr1 = nebulaWarRead.getAreaAbbr(values.camp1)
		local name1 = textParser.formatPlayerName(abbr1, values.name1)
		local abbr2 = nebulaWarRead.getAreaAbbr(values.camp2)
		local name2 = textParser.formatPlayerName(abbr2, values.name2)
		_ENV = i18n
		i18n.name1 = name2
		i18n.name2 = name1
		i18n.num = values.robValue
		return i18n(config[msgType], i18n)
	end
	return i18n("common_text_4425")
end
function nebulaAllStarUtil.sendViewerBarrage(chatChannel, singleData)
	dump(singleData, "==nebulaAllStarUtil.sendViewerBarrage==")
	local contentType = singleData.contentType
	if contentType == gChatTypeDef.chat_content_expression then
		return
	end
	if not singleData.content then
		local _ENV, content = singleData.content, singleData.content
	end
	if nebulaAllStarUtil.sendGiftBarrage(singleData) then
		return
	end
	if chatChannel == gChatChannel.VIEWER then
		local text = content.text
		if text and text ~= "" then
			_ENV = singleData
			singleData.barrageType = 2
			local singleData.content, ret = text, singleData
			_ENV = nil
			;(nil).msg = "MESSAGE_NEBULA_ALLSTAR_SHOW_BARRAGE"
			;(nil).data = ret
			SoraDSendMessage(nil)
		end
	end
end
function nebulaAllStarUtil.sendGiftBarrage(singleData)
	if not singleData.content then
		local _ENV, content = singleData.content, singleData.content
	end
	local chatSysMsgType = content.chatSysMsgType
	if chatSysMsgType then
		if chatSysMsgType == gChatSysMsgType.nebula_allstar_system then
			local msgType = content.nebulaChatMsgType
			if msgType == gNebulaChatMsgType.viewer_gift then
				local text = nebulaAllStarUtil.parseChatSysText(content)
				local values = content.values
				_ENV = nil
				;(nil).barrageType = 1
				;(nil).content = text
				;(nil).itemID = values.itemId
				local (nil).itemCount, ret = values.num, nil
				_ENV = nil
				;(nil).msg = "MESSAGE_NEBULA_ALLSTAR_SHOW_BARRAGE"
				;(nil).data = ret
				SoraDSendMessage(nil)
			end
		end
		return true
	end
end
function nebulaAllStarUtil.sendTestBarrage(param)
	if not param then
		param, _ENV = nil, nil
	end
	local count = param.count or 1
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local itemList = backpackltCtrl:getItemListByType(gItemEffectDef.NEBULA_ALLSTAR_GIFT)
	local _ENV, randomList = backpackltCtrl, backpackltCtrl
	for k, v in ipairs(itemList) do
		local result = backpackltCtrl:getResult(v)
		if result[2] == 1 or result[2] == 2 then
			table.insert(randomList, v)
		end
	end
	for i = 1, count do
		local len = math.random(1, 100)
		local str = ""
		for i = 1, len do
			str = str .. string.char(math.random(65, 122))
		end
		local _ENV, barrageType = 1, param.barrageType or math.random(1, 2)
		;(1).content = str
		local (1).barrageType, data = barrageType, 1
		if barrageType == 1 then
			data.itemID = randomList[math.random(1, #randomList)]
			data.itemCount = math.random(1, 5)
		end
		_ENV = 1
		;(1).msg = "MESSAGE_NEBULA_ALLSTAR_SHOW_BARRAGE"
		;(1).data = data
		SoraDSendMessage(1)
	end
end
function nebulaAllStarUtil.sendTestSpoil(param)
	if not param then
		param, _ENV = nil, nil
	end
	local posx = param.x or 149
	local _ENV, _ENV, _ENV, posy = nil, nil, nil, param.y or 149
	_ENV, (nil).notifyType = nil, "setSpoil"
	;(nil).id = "6-1"
	;(nil).t = serviceFunctions.systemTime()
	;(nil).x = posx
	;(nil).data, (nil)[1], (nil).notifyData, (nil).y = nil, nil, nil, posy
	local event
	nebulaAllStarCtrl:notifyHandlerWar(event)
	SoraDGotoWorldMapPoint(cc.p(posx, posy))
end
function nebulaAllStarUtil.sendTestSpoilQueue(...)
	local c = cc.p(17, 222)
	_UPVALUE7_ = 17
	;(17)[1] = cc.p(0, 10)
	;(17)[2] = cc.p(0, -10)
	;(17)[3] = cc.p(10, 0)
	;(17)[4] = cc.p(-10, 0)
	;(17)[5] = cc.p(5, 5)
	;(17)[6] = cc.p(5, -5)
	;(17)[7] = cc.p(-5, -5)
	;(17)[8] = cc.p(-5, 5)
	;(17)[9] = cc.p(-5, 5)
	local (17)[10], config = cc.p(-5, 5)
	for i, o in ipairs(config) do
		_ENV = cc.p(5, -5)
		cc.p(5, -5).id = tonumber(i)
		cc.p(5, -5).collectTime = serviceFunctions.systemTime() - 20
		cc.p(5, -5).x = c.x + o.x
		local cc.p(5, -5).y, d = c.y + o.y, cc.p(5, -5)
		nebulaAllStarCtrl:addSpoilQueueData(d.id, d)
	end
	_ENV = ipairs(config)
	ipairs(config).msg = "MESSAGE_NEBULA_ALLSTAR_SPOIL_COLLECTING"
	SoraDSendMessage(ipairs(config))
	SoraDGotoWorldMapPoint(c, nil, nebulaAllStarUtil.getKindomIDStart())
end
function nebulaAllStarUtil.getHandler_onClickHelp(FAQType)
	return function()
		SoraDPlaySound()
		nebulaAllStarUtil.showSingleFAQ(FAQType)
	end
end
function nebulaAllStarUtil.showSingleFAQ(FAQType)
	if FAQType == "NebulaAllStarMain" or FAQType == "nebulaAllStarUIBottom" then
		uiManager:show("NebulaAllStarFAQ")
		return
	elseif FAQType == "NebulaAllStarBuild" then
		_ENV = nil
		;(nil).defaultClick = 2
		uiManager:show("NebulaAllStarFAQ", nil)
		return
	elseif FAQType == "allStarTeam" or FAQType == "backupTeam" then
		_ENV = nil
		;(nil).FAQType = FAQType
		uiManager:show("NebulaAllStarFAQ", nil)
		return
	end
	local msgTip
	if FAQType == "teamCommander" then
		msgTip = i18n("NebulaAllstar_rule_msg5")
	elseif FAQType == "dispatchArmy" then
		local num = nebulaAllStarRead.getFreeSoldierNum()
		_ENV = nil
		;(nil).num = string.formatnumberthousands(num)
		msgTip = i18n("NebulaAllstar_rule_msg10", nil)
	elseif FAQType == "viewerGift" then
		msgTip = i18n("NebulaAllstar_rule_msg11")
	elseif FAQType == "allStarTeamValue" then
		local ratios = nebulaAllStarRead.getConstValue("StarValueLootRatios", 0)
		_ENV = nil
		;(nil).num = ratios / 10 .. "%"
		msgTip = i18n("NebulaAllstar_rule_msg12", nil)
	elseif FAQType == "backupTeamValue" then
		local ratios = nebulaAllStarRead.getConstValue("SupportValueLootRatios", 0)
		_ENV = nil
		;(nil).num = ratios / 10 .. "%"
		msgTip = i18n("NebulaAllstar_rule_msg12", nil)
	elseif FAQType == "energyBuff" then
		msgTip = i18n("NebulaAllstar_rule_msg81")
	elseif FAQType == "donate" then
		msgTip = i18n("NebulaAllstar_rule_msg82")
	end
	_ENV = "NebulaAllstar_rule_msg12"
	;("NebulaAllstar_rule_msg12").title = i18n("common_text_001")
	;("NebulaAllstar_rule_msg12").align = SoraDFLabelR()
	SoraDShowHelpMsgTip(msgTip, "NebulaAllstar_rule_msg12")
end
function nebulaAllStarUtil.isWarTest()
	local flag = nebulaAllStarRead.getConstValue("NebulaAllstarTest", 0)
	return 0 < flag
end
function nebulaAllStarUtil.getAttackRemainTime(teamID)
	local isSuperTeam = nebulaAllStarCtrl:checkIsAllStarTeam(teamID)
	local startTime = nebulaAllStarCtrl:getWarStartTime()
	local protectTime = 0
	if isSuperTeam then
		protectTime = nebulaAllStarRead.getConstValue("StarProtectionTime", 3600)
	else
		protectTime = nebulaAllStarRead.getConstValue("SupportProtectionTime", 3600)
	end
	local remainTime = startTime + protectTime - serviceFunctions.systemTime()
	return remainTime
end
function nebulaAllStarUtil.getBuildSpriteEffect(data)
	local spriteEffect
	local subType = data.subType
	if subType == gWorldTypeServerDef.subTypeNebulaAllStarWarPalace then
		local effectPath = "G_qmx_nengliangzhao.usm"
		local criSprite = cc.criSprite.createCriSprite(effectPath, false, true)
		criSprite:setBlendFunc(gl.ONE, gl.ONE)
		spriteEffect = criSprite
	elseif subType == gWorldTypeServerDef.subTypeNebulaAllStarWarTower then
		local Sprite_effect = display.newSprite("#G_qmx_xjpt_01.png")
		Sprite_effect:setBlendFunc(gl.ONE, gl.ONE)
		local frames = display.newFrames("G_qmx_xjpt_%02d.png", 1, 30)
		local animation = display.newAnimation(frames, 0.06666666666666667)
		Sprite_effect:playAnimationForever(animation)
		spriteEffect = Sprite_effect
	else
		_ENV = display.newSprite("#G_qmx_xjpt_01.png")
		_ENV = display.newAnimation(frames, 0.06666666666666667)
		display.newSprite("#G_qmx_xjpt_01.png")[gWorldTypeServerDef.subTypeNebulaAllStarWarBigSpring], display.newAnimation(frames, 0.06666666666666667).frameKey = display.newAnimation(frames, 0.06666666666666667), "qmx_fsqs_%02d.png"
		_ENV = display.newAnimation(frames, 0.06666666666666667)
		display.newSprite("#G_qmx_xjpt_01.png")[gWorldTypeServerDef.subTypeNebulaAllStarWarSmallSpring], display.newAnimation(frames, 0.06666666666666667).frameKey = display.newAnimation(frames, 0.06666666666666667), "qmx_fsqss_%02d.png"
		_ENV = display.newAnimation(frames, 0.06666666666666667)
		display.newSprite("#G_qmx_xjpt_01.png")[gWorldTypeServerDef.subTypeNebulaAllStarWarObservation], display.newAnimation(frames, 0.06666666666666667).frameKey = display.newAnimation(frames, 0.06666666666666667), "qmx_gxt_%02d.png"
		_ENV = display.newAnimation(frames, 0.06666666666666667)
		display.newSprite("#G_qmx_xjpt_01.png")[gWorldTypeServerDef.subTypeNebulaAllStarWarEngine], display.newAnimation(frames, 0.06666666666666667).frameKey = display.newAnimation(frames, 0.06666666666666667), "qmx_jcjz_q_%02d.png"
		_ENV = display.newAnimation(frames, 0.06666666666666667)
		display.newSprite("#G_qmx_xjpt_01.png")[gWorldTypeServerDef.subTypeNebulaAllStarWarCrossbow], display.newAnimation(frames, 0.06666666666666667).frameKey = display.newAnimation(frames, 0.06666666666666667), "qmx_jcjz_g_%02d.png"
		_ENV = display.newAnimation(frames, 0.06666666666666667)
		display.newSprite("#G_qmx_xjpt_01.png")[gWorldTypeServerDef.subTypeNebulaAllStarWarWorkshop], display.newAnimation(frames, 0.06666666666666667).frameKey = display.newAnimation(frames, 0.06666666666666667), "qmx_jcjz_b_%02d.png"
		_ENV = display.newAnimation(frames, 0.06666666666666667)
		display.newSprite("#G_qmx_xjpt_01.png")[gWorldTypeServerDef.subTypeNebulaAllStarWarCamp], display.newAnimation(frames, 0.06666666666666667).frameKey = display.newAnimation(frames, 0.06666666666666667), "qmx_xjg_%02d.png"
		_ENV = display.newAnimation(frames, 0.06666666666666667)
		display.newSprite("#G_qmx_xjpt_01.png")[gWorldTypeServerDef.subTypeNebulaAllStarViewerSpoil], display.newAnimation(frames, 0.06666666666666667).frameKey = display.newAnimation(frames, 0.06666666666666667), "qmx_zlp_%02d.png"
		local config = display.newSprite("#G_qmx_xjpt_01.png")
		local cfg = config[subType]
		local mapType = data.mapType
		if mapType == gMapObjTypeDef.mapObjTypePlayer then
			_ENV = gMapObjTypeDef.mapObjTypePlayer
			cfg, gMapObjTypeDef.mapObjTypePlayer.frameKey = gMapObjTypeDef.mapObjTypePlayer, "qmx_zxj_%02d.png"
		end
		if not cfg then
			return
		end
		local frameKey = cfg.frameKey
		local Sprite_effect = display.newSprite("#" .. string.format(frameKey, 1))
		local frameNum = cfg.frameNum or 15
		local frames = display.newFrames(frameKey, 1, frameNum)
		local frameTime = cfg.frameTime or 1 / frameNum
		local animation = display.newAnimation(frames, frameTime)
		Sprite_effect:playAnimationForever(animation)
		spriteEffect = Sprite_effect
		if data.Sprite_build then
			data.Sprite_build:setVisible(false)
		end
	end
	if not spriteEffect then
		return
	end
	local parent = data.parent
	if parent then
		spriteEffect:addTo(parent)
	end
	local pos = data.pos
	if pos then
		spriteEffect:setPosition(pos)
	end
	local scale = data.scale
	if scale then
		spriteEffect:setScale(scale)
	end
	if data.groupID then
		spriteEffect:setGroupID(data.groupID)
	end
	return spriteEffect
end
_ENV, nebulaAllStarUtil.getHoldInstaceByType = function(buildId, buildType)
	if buildType == gWorldTypeServerDef.subTypeNebulaAllStarViewerSpoil then
		return 1
	end
	if buildId then
		return nebulaAllStarRead.getBuildSize(buildId)
	elseif buildType then
		local buildIDList = nebulaAllStarRead.getBuildIDListByType(buildType)
		return nebulaAllStarUtil.getHoldInstaceByType(buildIDList[1])
	end
	return 1
end, function(buildId, buildType)
	if buildType == gWorldTypeServerDef.subTypeNebulaAllStarViewerSpoil then
		return 1
	end
	if buildId then
		return nebulaAllStarRead.getBuildSize(buildId)
	elseif buildType then
		local buildIDList = nebulaAllStarRead.getBuildIDListByType(buildType)
		return nebulaAllStarUtil.getHoldInstaceByType(buildIDList[1])
	end
	return 1
end
;(function(buildId, buildType)
	if buildType == gWorldTypeServerDef.subTypeNebulaAllStarViewerSpoil then
		return 1
	end
	if buildId then
		return nebulaAllStarRead.getBuildSize(buildId)
	elseif buildType then
		local buildIDList = nebulaAllStarRead.getBuildIDListByType(buildType)
		return nebulaAllStarUtil.getHoldInstaceByType(buildIDList[1])
	end
	return 1
end).AllStarArea = 1
;(function(buildId, buildType)
	if buildType == gWorldTypeServerDef.subTypeNebulaAllStarViewerSpoil then
		return 1
	end
	if buildId then
		return nebulaAllStarRead.getBuildSize(buildId)
	elseif buildType then
		local buildIDList = nebulaAllStarRead.getBuildIDListByType(buildType)
		return nebulaAllStarUtil.getHoldInstaceByType(buildIDList[1])
	end
	return 1
end).SupportArea = 2
;(function(buildId, buildType)
	if buildType == gWorldTypeServerDef.subTypeNebulaAllStarViewerSpoil then
		return 1
	end
	if buildId then
		return nebulaAllStarRead.getBuildSize(buildId)
	elseif buildType then
		local buildIDList = nebulaAllStarRead.getBuildIDListByType(buildType)
		return nebulaAllStarUtil.getHoldInstaceByType(buildIDList[1])
	end
	return 1
end).BornArea = 3
local (function(buildId, buildType)
	if buildType == gWorldTypeServerDef.subTypeNebulaAllStarViewerSpoil then
		return 1
	end
	if buildId then
		return nebulaAllStarRead.getBuildSize(buildId)
	elseif buildType then
		local buildIDList = nebulaAllStarRead.getBuildIDListByType(buildType)
		return nebulaAllStarUtil.getHoldInstaceByType(buildIDList[1])
	end
	return 1
end).ForbidArea, Area_Type = 10, function(buildId, buildType)
	if buildType == gWorldTypeServerDef.subTypeNebulaAllStarViewerSpoil then
		return 1
	end
	if buildId then
		return nebulaAllStarRead.getBuildSize(buildId)
	elseif buildType then
		local buildIDList = nebulaAllStarRead.getBuildIDListByType(buildType)
		return nebulaAllStarUtil.getHoldInstaceByType(buildIDList[1])
	end
	return 1
end
function nebulaAllStarUtil.checkIsInForbidArea(targetRect)
	local forbidRects = nebulaAllStarUtil.getBuildForbidArea(gWorldTypeServerDef.subTypeNebulaAllStarWarPalace)
	for __, forbidRect in ipairs(forbidRects) do
		if cc.rectIntersectsRect(targetRect, forbidRect) then
			return true
		end
	end
	local forbidRects = nebulaAllStarUtil.getBuildForbidArea(gWorldTypeServerDef.subTypeNebulaAllStarWarTower)
	for __, forbidRect in ipairs(forbidRects) do
		if cc.rectIntersectsRect(targetRect, forbidRect) then
			return true
		end
	end
	return false
end
function nebulaAllStarUtil.getBuildForbidArea(subType)
	if not nebulaAllStarUtil.buildForbidArea then
		local nebulaAllStarUtil, buildForbidArea = nebulaAllStarUtil.buildForbidArea, nebulaAllStarUtil.buildForbidArea
	end
	if not buildForbidArea[subType] then
		local nebulaAllStarUtil, ret = buildForbidArea[subType], buildForbidArea[subType]
		local radius = 0
		if subType == gWorldTypeServerDef.subTypeNebulaAllStarWarPalace then
			radius = nebulaAllStarRead.getConstValue("NebulaCupRestrictedArea", 10)
		elseif subType == gWorldTypeServerDef.subTypeNebulaAllStarWarTower then
			radius = nebulaAllStarRead.getConstValue("NebulaTowerRestrictedArea", 5)
		end
		local list = nebulaAllStarRead.getBuildIDListByType(subType)
		for __, buildID in ipairs(list) do
			local pos = nebulaAllStarRead.getBuildPos(buildID)
			local size = nebulaAllStarRead.getBuildSize(buildID)
			local width = size + radius * 2 - 1
			local forbidRect = cc.rect(pos.x - radius, pos.y - radius, width, width)
			table.insert(ret, forbidRect)
		end
		buildForbidArea[subType] = ret
	end
	nebulaAllStarUtil.buildForbidArea = buildForbidArea
	return buildForbidArea[subType]
end
function nebulaAllStarUtil.getDrawNodeAreaConfig(...)
	local nebulaAllStarRead, ret
	local cfgs = nebulaAllStarRead.getMapAreaConfig(Area_Type.AllStarArea)
	for __, cfg in ipairs(cfgs) do
		_UPVALUE4_ = nil
		;(nil)[1] = "beginX"
		;(nil)[2] = "beginY"
		;(nil)[3] = "endX"
		;(nil)[4] = "endY"
		local rects = serviceFunctions.tableFormat(cfg, nil)
		for __, rect in ipairs(rects) do
			local beginX, beginY, endX, endY = rect.beginX - 1.5, rect.beginY - 1.5, rect.endX + 1.5, rect.endY + 1.5
			nebulaAllStarUtil = nil
			;(nil)[1] = cc.p(beginX, beginY)
			;(nil)[2] = cc.p(beginX, endY)
			;(nil)[3] = cc.p(endX, endY)
			;(nil)[4] = cc.p(endX, beginY)
			;(nil)[5] = cc.p(endX, beginY)
			;(nil)[6] = cc.p(endX, beginY)
			;(nil)[7] = cc.p(endX, beginY)
			;(nil)[8] = cc.p(endX, beginY)
			;(nil)[9] = cc.p(endX, beginY)
			;(nil)[10] = cc.p(endX, beginY)
			;(nil)[11] = cc.p(endX, beginY)
			;(nil)[12] = cc.p(endX, beginY)
			local (nil)[13], area = cc.p(endX, beginY)
			table.insert(ret, area)
		end
	end
	nebulaAllStarRead = (for generator)
	ipairs(cfgs).beginX = 37
	ipairs(cfgs).beginY = 37
	ipairs(cfgs).endX = 262
	local ipairs(cfgs).endY, rect = 262, ipairs(cfgs)
	local beginX, beginY, endX, endY = rect.beginX - 1.5, rect.beginY - 1.5, rect.endX + 1.5, rect.endY + 1.5
	nebulaAllStarUtil = serviceFunctions.tableFormat(cfg, nil)
	serviceFunctions.tableFormat(cfg, nil)[1] = cc.p(beginX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[2] = cc.p(beginX, endY)
	serviceFunctions.tableFormat(cfg, nil)[3] = cc.p(endX, endY)
	serviceFunctions.tableFormat(cfg, nil)[4] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[5] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[6] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[7] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[8] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[9] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[10] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[11] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[12] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[13] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[14] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[15] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[16] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[17] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[18] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[19] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[20] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[21] = cc.p(endX, beginY)
	serviceFunctions.tableFormat(cfg, nil)[22] = cc.p(endX, beginY)
	local serviceFunctions.tableFormat(cfg, nil)[23], area = cc.p(endX, beginY)
	table.insert(ret, area)
	_ENV = table.insert
	table.insert[1] = gWorldTypeServerDef.subTypeNebulaAllStarWarPalace
	local table.insert[2], config = gWorldTypeServerDef.subTypeNebulaAllStarWarTower, table.insert
	for __, subType in ipairs(config) do
		local forbidRects = nebulaAllStarUtil.getBuildForbidArea(subType)
		for __, rect in ipairs(forbidRects) do
			local beginX, beginY, endX, endY = rect.x - 0.5, rect.y - 0.5, rect.x + rect.width + 0.5, rect.y + rect.height + 0.5
			nebulaAllStarUtil = rect.height
			rect.height[1] = cc.p(beginX, beginY)
			rect.height[2] = cc.p(beginX, endY)
			rect.height[3] = cc.p(endX, endY)
			rect.height[4] = cc.p(endX, beginY)
			rect.height[5] = cc.p(endX, beginY)
			local rect.height[6], area = cc.p(endX, beginY)
			table.insert(ret, area)
		end
	end
	return ret
end
function nebulaAllStarUtil.checkIsInArea(targetRect, areaType, camp)
	if areaType == Area_Type.ForbidArea then
		return nebulaAllStarUtil.checkIsInForbidArea(targetRect)
	end
	local cfgs = nebulaAllStarRead.getMapAreaConfig(areaType, camp)
	if not next(cfgs) then
		return false
	end
	for __, cfg in ipairs(cfgs) do
		_UPVALUE4_ = nil
		;(nil)[1] = "beginX"
		;(nil)[2] = "beginY"
		;(nil)[3] = "endX"
		;(nil)[4] = "endY"
		local rects = serviceFunctions.tableFormat(cfg, nil)
		for __, rect in ipairs(rects) do
			local clientPos = cc.p(rect.beginX, rect.beginY)
			local width = rect.endX - rect.beginX + 1
			local height = rect.endY - rect.beginY + 1
			local forbidRect = cc.rect(clientPos.x, clientPos.y, width - 1, height - 1)
			if cc.rectIntersectsRect(targetRect, forbidRect) then
				return true
			end
		end
	end
	return false
end
function nebulaAllStarUtil.checkIsCanTransfer(_targetRect)
	local targetRect = _targetRect
	if not _targetRect.width then
		targetRect = cc.rect(_targetRect.x, _targetRect.y, 0, 0)
	end
	local isSuperTeam = nebulaAllStarCtrl:getMyTeamInfo():getIsSuperTeam()
	if isSuperTeam then
		if not nebulaAllStarUtil.checkIsInArea(targetRect, Area_Type.AllStarArea) then
			return false, worldMapLayInstanceTypeErrorDef.nebulaAllStar_allStar
		end
	elseif not nebulaAllStarUtil.checkIsInArea(targetRect, Area_Type.SupportArea) then
		return false, worldMapLayInstanceTypeErrorDef.nebulaAllStar_support
	end
	if nebulaAllStarUtil.checkIsInArea(targetRect, Area_Type.ForbidArea) then
		return false, worldMapLayInstanceTypeErrorDef.nebulaEmperor_forbid
	end
	return true
end
function nebulaAllStarUtil.getTransferErrorTip(layInstanceError)
	_ENV = nil
	;(nil)[worldMapLayInstanceTypeErrorDef.nebulaEmperor_forbid] = i18n("nebulaemperor_text_232")
	;(nil)[worldMapLayInstanceTypeErrorDef.nebulaAllStar_allStar] = i18n("NebulaAllstar_258")
	local (nil)[worldMapLayInstanceTypeErrorDef.nebulaAllStar_support], config = i18n("NebulaAllstar_260"), nil
	return config[layInstanceError]
end
function nebulaAllStarUtil.checkIsCanZhanling(point)
	local ok, errTip = nebulaAllStarUtil.checkSelfCityPos()
	if not ok then
		return ok, errTip
	end
	local ok, err = nebulaAllStarUtil.checkIsCanTransfer(point)
	if not ok then
		local isSuperTeam = nebulaAllStarCtrl:getMyTeamInfo():getIsSuperTeam()
		if isSuperTeam then
			return false, i18n("NebulaAllstar_390")
		else
			return false, i18n("NebulaAllstar_391")
		end
	end
	return true
end
function nebulaAllStarUtil.checkSelfCityPos(...)
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local cityPos = cityCtrl:getCurCityPos()
	local ok, err = nebulaAllStarUtil.checkIsCanTransfer(cityPos)
	if not ok then
		local isSuperTeam = nebulaAllStarCtrl:getMyTeamInfo():getIsSuperTeam()
		if isSuperTeam then
			return false, i18n("NebulaAllstar_390")
		else
			return false, i18n("NebulaAllstar_391")
		end
	end
	return true
end
function nebulaAllStarUtil.checkBuildCanAttack(buildType)
	local ok, errTip = nebulaAllStarUtil.checkSelfCityPos()
	if not ok then
		return ok, errTip
	end
	local isSuperTeam = nebulaAllStarCtrl:getMyTeamInfo():getIsSuperTeam()
	if nebulaAllStarUtil.isBackupAreaBuild(buildType) and isSuperTeam then
		return false, i18n("NebulaAllstar_134")
	elseif nebulaAllStarUtil.isAllStarAreaBuild(buildType) and not isSuperTeam then
		return false, i18n("NebulaAllstar_131")
	end
	return true
end
function nebulaAllStarUtil.checkForbitTipButtonType(tipButtonType)
	_ENV = nil
	;(nil)[worldMapDefine.worldMapTipButtonType_qianCheng] = true
	;(nil)[worldMapDefine.worldMapTipButtonType_gongJi] = true
	;(nil)[worldMapDefine.worldMapTipButtonType_zhenCha] = true
	local (nil)[worldMapDefine.worldMapTipButtonType_xuanZhan], config = true, nil
	if config[tipButtonType] and nebulaAllStarCtrl:getWarTipRemainTime() > 0 then
		SoraDShowMsgTip(i18n("NebulaAllstar_243"))
		return true
	else
		return false
	end
end
function nebulaAllStarUtil.checkForbitRandomMove(...)
	if nebulaAllStarCtrl:getWarTipRemainTime() > 0 then
		SoraDShowMsgTip(i18n("NebulaAllstar_243"))
		return true
	else
		return false
	end
end
function nebulaAllStarUtil.isBackupAreaBuild(buildType)
	_ENV = nil
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarBigSpring] = true
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarSmallSpring] = true
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarObservation] = true
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarEngine] = true
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarCrossbow] = true
	local (nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarWorkshop], config = true, nil
	return config[buildType] or false
end
function nebulaAllStarUtil.isAllStarAreaBuild(buildType)
	_ENV = nil
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarPalace] = true
	local (nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarTower], config = true, nil
	return config[buildType] or false
end
function nebulaAllStarUtil.getAreanNameByPoint(point, mapInstance)
	local targetRect = cc.rect(point.x, point.y, 0, 0)
	if not mapInstance and nebulaAllStarUtil.checkIsInArea(targetRect, Area_Type.ForbidArea) then
		return i18n("common_text_515")
	end
	if nebulaAllStarUtil.checkIsInArea(targetRect, Area_Type.AllStarArea) then
		return i18n("NebulaAllstar_rule_msg36")
	end
	if nebulaAllStarUtil.checkIsInArea(targetRect, Area_Type.SupportArea) then
		return i18n("NebulaAllstar_rule_msg42")
	end
	if nebulaAllStarUtil.checkIsInArea(targetRect, Area_Type.BornArea) then
		return i18n("NebulaAllstar_399")
	end
	return i18n("NebulaAllstar_398")
end
return nebulaAllStarUtil
