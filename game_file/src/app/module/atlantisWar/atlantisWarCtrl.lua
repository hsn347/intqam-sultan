local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local atlantisWarCtrl = class("atlantisWarCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function atlantisWarCtrl:ctor(properties)
	atlantisWarCtrl.super.ctor(self, properties)
	self:resetData()
end
function atlantisWarCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_DATA, handler(self, self.reqWarDataRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_NOTIFY_FOCUS_POS, handler(self, self.reqNotifyFocusPosRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_SET_MEMBER_CLASS, handler(self, self.reqSetMemberClassRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_FORT_CMD_POST_DATA, handler(self, self.reqFortCmdPostDataRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_PLAYER_TOTAL_SCORE_RANK, handler(self, self.reqPlayerRankDataRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_PLAYER_TITLE_SCORE_RANK, handler(self, self.reqTitleRankDataRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_CAMP_PLAYER_LIST, handler(self, self.reqCampPlayerListRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_THROW_BOSS_SKILL_TO_PLAYER, handler(self, self.reqThrowBossSkillToPlayerRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_BUILD_OCCUPY_LOG, handler(self, self.reqBuildOccupyLogRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_PLAYER_COUNT, handler(self, self.reqWarPeopleNumRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_SET_OCCUPY_QUEUE_ARMY_MIN_LV, handler(self, self.reqSetArmyMinLvRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_SET_KINGDOM_ATLANTIS_TITLE, handler(self, self.reqSetAtlantisTitleRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_USE_FORT_CMD_POST_SKILL, handler(self, self.reqUsePostSkillRsp))
	self:registerNotify()
end
function atlantisWarCtrl:Logout()
	atlantisWarCtrl.super.Logout(self)
	self:resetData()
end
function atlantisWarCtrl:resetData()
	self.peopleNumInWar, _UPVALUE0_, self.occupyArmyLimit, _UPVALUE0_, self.campPlayerMap, _UPVALUE0_, self.campPlayerList, _UPVALUE0_, self.marshalMap, _UPVALUE0_, self.warData, _UPVALUE0_, self.campMap, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
end
function atlantisWarCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ATLANTIS_WAR, handler(self, self.notifyHandler))
end
function atlantisWarCtrl:notifyHandler(event)
	dump(event.data, "atlantisWarCtrl:notifyHandler", 10)
	if not worldMapDefine.isInAtlantis() then
		return
	end
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		self:notifyCampScore(notifyType, notifyData)
		self:notifyPlayerBuff(notifyType, notifyData)
		self:notifyPlayerCity(notifyType, notifyData)
		if notifyType == "focusPos" then
			_ENV = self
			self.msg = "MESSAGE_ATLANTISWAR_FOCUS_POS"
			self.info = notifyData
			SoraDSendMessage(self)
		elseif notifyType == "settleBossWindow" then
			if not SoraDIsGameGuide() then
				SoraDRemoveAllPanelFromManager()
				local panel = SoraDCreatePanel("atlantisBossResultView")
				panel:initData(notifyData)
				panel:show()
			end
		elseif notifyType == "settleWarWindow" then
			if not SoraDIsGameGuide() then
				SoraDRemoveAllPanelFromManager()
				self:onSettleWarWindow(notifyData)
			end
		elseif notifyType == "occupy" then
			local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
			kingdomMapCtrl:setWarBuildingOwner(worldMapDefine.currentMapKindomID, notifyData.buildId, notifyData.owner)
		elseif notifyType == "setFortCycleBeginTime" then
			local warData = self:getWarData()
			warData.fortCycleBeginTime = notifyData.fortCycleBeginTime
		elseif notifyType == "setFortCmdPostOwner" then
			local buildId = notifyData.buildId
			self.marshalMap[tostring(buildId)] = notifyData.cmdPostOwner
			_ENV = tostring(buildId)
			tostring(buildId).msg = "MESSAGE_ATLANTISWAR_MARSHAL_CHANGE"
			SoraDSendMessage((tostring(buildId)))
		elseif notifyType == "setMemberClass" then
			local warData = self:getWarData()
			warData.memberClass = notifyData
			_ENV = tostring(buildId)
			tostring(buildId).msg = "MESSAGE_ATLANTISWAR_MEMBERCLASS_CHANGE"
			SoraDSendMessage((tostring(buildId)))
		elseif notifyType == "addCampBuff" then
			self:onTeamBuffAdd(notifyData)
		elseif notifyType == "removeCampBuff" then
			self:onTeamBuffRemove(notifyData)
		elseif notifyType == "updateCampBuff" then
			self:onTeamBuffUpdate(notifyData)
		elseif notifyType == "setOccupyArmyLimit" then
			self.occupyArmyLimit = notifyData
		elseif notifyType == "killBoss" then
			self:showKillBoss(notifyData)
		elseif notifyType == "reachKillPlayerScoreLimit" then
			_ENV, _ENV = self, self.showKillBoss
			self.content = i18n("atlantiswar_text_0255")
			self.showKillBoss.content, self.weight = self, 1
			self.showKillBoss.kingdomMsgType = gSystemNoticeKingdomMsgTypeDef.atlantis_war_reach_kill_army_fc_limit
			local self.showKillBoss.sysNoticeType, noticeData = gSystemNoticeTypeDef.sys_notice_kingdom_msg, self.showKillBoss
			_ENV = i18n("atlantiswar_text_0255")
			i18n("atlantiswar_text_0255").msg = "MESSAGE_SYSTEM_NOTICE_UI_SHOW_NOTICE"
			i18n("atlantiswar_text_0255").data = noticeData
			SoraDSendMessage((i18n("atlantiswar_text_0255")))
		end
	end
end
function atlantisWarCtrl:notifyCampScore(notifyType, notifyData)
	_UPVALUE2_, _ENV = nil, nil
	_UPVALUE1_, (nil).setCampKillBossWlynFc, (nil)[1] = nil, nil, "killBossWlynFc"
	_UPVALUE1_, (nil).setCampKillBossWlynFc, (nil)[2] = nil, nil, "killBossWlynFcTime"
	_UPVALUE2_, (nil).setCampKillBossWlynScore, (nil)[1] = nil, nil, "killBossWlynScore"
	_UPVALUE1_, (nil).setCampKillBossSdFc, (nil)[1] = nil, nil, "killBossSdFc"
	_UPVALUE1_, (nil).setCampKillBossSdFc, (nil)[2] = nil, nil, "killBossSdFcTime"
	_UPVALUE2_, (nil).setCampKillBossSdScore, (nil)[1] = nil, nil, "killBossSdScore"
	_UPVALUE2_, (nil).setCampKillPlayerScore, (nil)[1] = nil, nil, "killPlayerScore"
	_UPVALUE2_, (nil).setCampKillPlayerScore, (nil)[2] = nil, nil, "killPlayerScoreTime"
	_UPVALUE1_, (nil).setCampOccupyScore, (nil)[1] = nil, nil, "occupyScore"
	_UPVALUE1_, (nil).setCampOccupyScore, (nil)[2] = nil, nil, "occupyScoreTime"
	_UPVALUE1_, (nil).setCampKillBossWlynCount, (nil)[1] = nil, nil, "killBossWlynCount"
	;(nil).setCampKillBossSdCount, (nil)[1] = nil, "killBossSdCount"
	local notifyTypeList
	local config = notifyTypeList[notifyType]
	if not config then
		return
	end
	dump(notifyData, "atlantisWarCtrl:notifyCampScore", 10)
	local camp = notifyData.camp
	if not self.campMap[camp] then
		local _ENV, campData = self.campMap[camp], self.campMap[camp]
	end
	for __, dataKey in ipairs(config) do
		if notifyData[dataKey] then
			campData[dataKey] = notifyData[dataKey]
		end
	end
	_ENV = ipairs(config)
	ipairs(config).msg = "MESSAGE_ATLANTISWAR_REFRESH_CAMPMAP"
	SoraDSendMessage(ipairs(config))
end
function atlantisWarCtrl:notifyPlayerBuff(notifyType, notifyData)
	_ENV = nil
	;(nil).addPlayerBuff = true
	;(nil).removePlayerBuff = true
	;(nil).updatePlayerBuff = true
	local (nil).addPlayerDebuff, notifyTypeList = true, nil
	local config = notifyTypeList[notifyType]
	if not config then
		return
	end
	dump(notifyData, "atlantisWarCtrl:notifyPlayerBuff", 10)
	local buffId, buffEffect
	if notifyType == "removePlayerBuff" then
		buffId = notifyData
		local buffList = self:getPlayerBuffList()
		if buffList[tostring(buffId)] then
			buffEffect = buffList[tostring(buffId)].effect
			buffList[tostring(buffId)] = nil
		end
	elseif notifyType == "addPlayerDebuff" then
		local atlantisWarUtil = include("atlantisWarUtil")
		atlantisWarUtil.showPlayerDebuffMsgTip(notifyData)
	else
		buffId = notifyData.id
		local buffList = self:getPlayerBuffList()
		buffList[tostring(buffId)] = notifyData
		if notifyType == "addPlayerBuff" and notifyData.effect == gBuffEffect.ATLANTIS_WAR_JUDGE then
			local remainTime = notifyData.endTime - serviceFunctions.systemTime()
			if 0 < remainTime then
				_ENV = nil
				;(nil).var = notifyData.value
				_ENV = notifyData.value
				notifyData.value.time = SoraDConvertSecondToStringNoDayNoHour(remainTime)
				local msgStr = string.format([[
%s
%s
%s]], i18n("atlantiswar_text_0412"), i18n("atlantiswar_text_0413", nil), i18n("atlantiswar_text_0414", notifyData.value))
				local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
				local config = atlantisActivityCtrl:getBuffConfig(notifyData.effect)
				local iconSprite = atlantisActivityCtrl:getSkillIconSprite(config.icon, config.itemquality)
				_ENV = i18n("atlantiswar_text_0414", notifyData.value)
				i18n("atlantiswar_text_0414", notifyData.value).offset = cc.p(0, 2)
				i18n("atlantiswar_text_0414", notifyData.value).sOrder = 1
				SoraDShowMsgTip(msgStr, iconSprite, nil, i18n("atlantiswar_text_0414", notifyData.value))
			end
		end
	end
	if buffId then
		_ENV = notifyData.endTime - serviceFunctions.systemTime()
		;(notifyData.endTime - serviceFunctions.systemTime()).msg = "MESSAGE_ATLANTISWAR_BUFF_NOTIFY"
		;(notifyData.endTime - serviceFunctions.systemTime()).notifyType = notifyType
		;(notifyData.endTime - serviceFunctions.systemTime()).notifyData = notifyData
		;(notifyData.endTime - serviceFunctions.systemTime()).buffId = buffId
		;(notifyData.endTime - serviceFunctions.systemTime()).buffEffect = buffEffect
		SoraDSendMessage(notifyData.endTime - serviceFunctions.systemTime())
	end
end
function atlantisWarCtrl:notifyPlayerCity(notifyType, notifyData)
	_ENV = nil
	;(nil).addPlayerCity = true
	local (nil).removePlayerCity, notifyTypeList = true, nil
	local config = notifyTypeList[notifyType]
	if not config then
		return
	end
	dump(notifyData, "atlantisWarCtrl:notifyPlayerCity", 10)
	_ENV = notifyData
	notifyData.msg = "MESSAGE_ATLANTISWAR_NOTIFYPLAYERCITY"
	notifyData.notifyType = notifyType
	notifyData.notifyData = notifyData
	SoraDSendMessage(notifyData)
end
function atlantisWarCtrl:onSettleWarWindow(notifyData)
	local campRank = notifyData.campRank
	local topScorePlayer = notifyData.topScorePlayer
	local titles = notifyData.titles
	local personalData = notifyData.personalData
	if campRank then
		local panel = SoraDCreatePanel("atlantisKingdomResultView")
		panel:initData(notifyData)
		panel:show()
	elseif topScorePlayer and next(topScorePlayer) or titles and next(titles) then
		local panel = SoraDCreatePanel("atlantisResultView")
		panel:initData(notifyData)
		panel:show()
	elseif personalData and next(personalData) then
		local panel = SoraDCreatePanel("atlantisPersonResultView")
		panel:initData(personalData)
		panel:show()
	end
end
function atlantisWarCtrl:showKillBoss(notifyData)
	local kingdomName = serviceFunctions.getKingdomFormatName(notifyData.kingdomName, notifyData.kid)
	local bossName = worldMapDefine.getWorldBossName(notifyData.bossType)
	_ENV = nil
	;(nil).kName = kingdomName
	;(nil).bName = i18n(bossName)
	;(nil).count = notifyData.count
	local msg = i18n("atlantiswar_text_0359", nil)
	local node = display.newNode()
	local bossInfo = worldMapDefine.getWorldBossShow(notifyData.bossType)
	local bossSprite = display.newSprite("#" .. bossInfo.image)
	SoraDSetNodeGray(bossSprite, true)
	bossSprite:addTo(node)
	bossSprite:setPosition(0, 0)
	bossSprite:setScale(100 / bossSprite:getContentSize().width)
	local killSprite = display.newSprite("#frame_shmc_img_04.png")
	killSprite:addTo(node)
	killSprite:setPosition(0, 0)
	killSprite:setScale(0.6)
	_ENV = nil
	;(nil).scale = 1
	SoraDShowMsgTip(msg, node, nil, nil)
end
function atlantisWarCtrl:reqWarData(mapId)
	print("==atlantisWarCtrl:reqWarData==", mapId, worldMapDefine.currentMapKindomID)
	mapId = mapId or worldMapDefine.currentMapKindomID
	if mapId == -1 then
		mapId = nil
	end
	_ENV = nil
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_DATA, nil)
end
function atlantisWarCtrl:reqNotifyFocusPos(x, y, mapId)
	_ENV = nil
	;(nil).mapId = mapId or worldMapDefine.currentMapKindomID
	;(nil).x = math.floor(x)
	local (nil).y, data = math.floor(y), nil
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_NOTIFY_FOCUS_POS, data)
end
function atlantisWarCtrl:reqSetMemberClass(uid, toMemberClass, fromMemberClass, mapId)
	mapId = mapId or worldMapDefine.currentMapKindomID
	_ENV = nil
	;(nil).mapId = mapId
	;(nil).uid = uid
	;(nil).toMemberClass = toMemberClass
	;(nil).fromMemberClass = fromMemberClass
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_SET_MEMBER_CLASS, nil)
end
function atlantisWarCtrl:reqFortCmdPostData(mapId)
	mapId = mapId or worldMapDefine.currentMapKindomID
	_ENV = nil
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_FORT_CMD_POST_DATA, nil)
end
function atlantisWarCtrl:reqPlayerRankData(iBegin, mapId)
	mapId = mapId or worldMapDefine.currentMapKindomID
	if mapId == -1 then
		mapId = nil
	end
	_ENV = nil
	;(nil).mapId = mapId
	;(nil).iBegin = iBegin
	;(nil).nCount = 20
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_PLAYER_TOTAL_SCORE_RANK, nil)
end
function atlantisWarCtrl:reqTitleRankData(title, iBegin, mapId)
	mapId = mapId or worldMapDefine.currentMapKindomID
	if mapId == -1 then
		mapId = nil
	end
	_ENV = nil
	;(nil).mapId = mapId
	;(nil).iBegin = iBegin
	;(nil).title = title
	;(nil).nCount = 20
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_PLAYER_TITLE_SCORE_RANK, nil)
end
function atlantisWarCtrl:reqCampPlayerList(mapId)
	mapId = mapId or worldMapDefine.currentMapKindomID
	_ENV = nil
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_CAMP_PLAYER_LIST, nil)
end
function atlantisWarCtrl:reqThrowBossSkillToPlayer(buffEffect, uid, mapId)
	mapId = mapId or worldMapDefine.currentMapKindomID
	_ENV = nil
	;(nil).mapId = mapId
	;(nil).buffEffect = buffEffect
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_THROW_BOSS_SKILL_TO_PLAYER, nil)
end
function atlantisWarCtrl:reqBuildOccupyLog(buildId, iBegin, mapId)
	mapId = mapId or worldMapDefine.currentMapKindomID
	_ENV = nil
	;(nil).mapId = mapId
	;(nil).buildId = buildId
	;(nil).iBegin = iBegin
	;(nil).nCount = 20
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_BUILD_OCCUPY_LOG, nil)
end
function atlantisWarCtrl:reqWarPeopleNum(mapId)
	mapId = mapId or worldMapDefine.currentMapKindomID
	_ENV = nil
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_PLAYER_COUNT, nil)
end
function atlantisWarCtrl:reqSetArmyMinLv(fromMinLv, toMinLv, mapId)
	mapId = mapId or worldMapDefine.currentMapKindomID
	_ENV = nil
	;(nil).mapId = mapId
	;(nil).fromMinLv = fromMinLv
	;(nil).toMinLv = toMinLv
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_SET_OCCUPY_QUEUE_ARMY_MIN_LV, nil)
end
function atlantisWarCtrl:reqSetAtlantisTitle(season)
	serverproxy = nil
	;(nil).season = season
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_SET_KINGDOM_ATLANTIS_TITLE, nil)
end
function atlantisWarCtrl:reqSetAtlantisTitleRsp(content)
	dump(content, "atlantisWarCtrl:reqSetAtlantisTitleRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if content.data.season then
			SoraDShowMsgTip(i18n("atlantiswar_text_0423"))
		else
			SoraDShowMsgTip(i18n("atlantiswar_text_0424"))
		end
		local KWKingdomCtrl = SoraDGetCtrl("KWKingdomCtrl")
		KWKingdomCtrl:setAtlantisTitle(content.data.season)
		_ENV = KWKingdomCtrl
		KWKingdomCtrl.msg = "MESSAGE_ATLANTISWAR_TITLE_REFRESH"
		SoraDSendMessage(KWKingdomCtrl)
	end
end
function atlantisWarCtrl:reqUsePostSkill(mapId)
	mapId = mapId or worldMapDefine.currentMapKindomID
	_ENV = nil
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_ATLANTIS_WAR_MODULE, gCmd.REQ_ATLANTIS_WAR_USE_FORT_CMD_POST_SKILL, nil)
end
function atlantisWarCtrl:reqUsePostSkillRsp(content)
	dump(content, "atlantisWarCtrl:reqUsePostSkillRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
		local config = atlantisActivityCtrl:getBuffConfig(gBuffEffect.ATLANTIS_WAR_JUDGE)
		_ENV = nil
		;(nil).var = i18n(config.name)
		local msgStr = i18n("atlantiswar_skill_text_037", nil) .. "\n" .. i18n(config.describe)
		local iconSprite = atlantisActivityCtrl:getSkillIconSprite(config.icon, config.itemquality)
		_ENV = nil
		;(nil).offset = cc.p(0, 2)
		SoraDShowMsgTip(msgStr, iconSprite, nil, nil)
	end
end
function atlantisWarCtrl:reqWarDataRsp(content)
	dump(content, "atlantisWarCtrl:reqWarDataRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		self.campMap = content.rspdata.campMap
		self.warData = content.rspdata.warData
		self.marshalMap = content.rspdata.fortCmdPostOwnerMap
		self.atlantisWarData = content.rspdata.warData.campBuffList
		self.occupyArmyLimit = content.rspdata.occupyArmyLimit
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ATLANTISWAR_REFRESH_WARDATA"
		SoraDSendMessage(gErrDef.Err_None)
		if worldMapDefine.isInAtlantis() then
			local atlantisWarUtil = include("atlantisWarUtil")
			atlantisWarUtil.initWarStageView()
		end
	end
end
function atlantisWarCtrl:reqNotifyFocusPosRsp(content)
	dump(content, "atlantisWarCtrl:reqNotifyFocusPosRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	elseif content.err == gErrDef.ERR_REQ_FREQUENTLY then
		SoraDShowMsgTip(i18n("common_text_046"))
	end
end
function atlantisWarCtrl:reqSetMemberClassRsp(content)
	dump(content, "atlantisWarCtrl:reqSetMemberClassRsp(content)", 10)
	if content.err == gErrDef.Err_None or content.err == gErrDef.Err_ATLANTIS_WAR_MEMBER_CLASS_HAS_CHANGED then
		local uid = content.data.uid
		local memberClass = content.rspdata.memberClass
		local player = self:getCampPlayerByUid(uid)
		player.memberClass = memberClass
		_ENV = uid
		uid.msg = "MESSAGE_ATLANTISWAR_MEMBERCLASS"
		uid.uid = uid
		uid.err = content.err
		SoraDSendMessage(uid)
	end
end
function atlantisWarCtrl:reqFortCmdPostDataRsp(content)
	dump(content, "atlantisWarCtrl:reqFortCmdPostDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ATLANTISWAR_FORTCMDPOSTDATA"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function atlantisWarCtrl:reqPlayerRankDataRsp(content)
	dump(content, "atlantisWarCtrl:reqRankDataRsp(content)", 10)
	_ENV = content
	content.msg = "MESSAGE_ATLANTISWAR_REFRESH_POINT_RANK"
	content.key = "reqRankDataRsp"
	content.rspdata = content.rspdata
	content.err = content.err
	SoraDSendMessage(content)
end
function atlantisWarCtrl:reqTitleRankDataRsp(content)
	dump(content, "atlantisWarCtrl:reqRankDataRsp(content)", 10)
	_ENV = content
	content.msg = "MESSAGE_ATLANTISWAR_REFRESH_POINT_RANK"
	content.key = "reqRankDataRsp"
	content.rspdata = content.rspdata
	content.err = content.err
	SoraDSendMessage(content)
end
function atlantisWarCtrl:reqCampPlayerListRsp(content)
	dump(content, "atlantisWarCtrl:reqCampPlayerListRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.campPlayerMap, _ENV, self.campPlayerList = rspdata.players, rspdata.players, rspdata.players
		for i, v in ipairs(self.campPlayerList) do
			self.campPlayerMap[tostring(v.uid)] = i
		end
		_ENV = ipairs(self.campPlayerList)
		ipairs(self.campPlayerList).msg = "MESSAGE_ATLANTISWAR_CAMPPLAYERLIST"
		ipairs(self.campPlayerList).rspdata = rspdata
		SoraDSendMessage(ipairs(self.campPlayerList))
	end
end
function atlantisWarCtrl:reqThrowBossSkillToPlayerRsp(content)
	dump(content, "atlantisWarCtrl:reqThrowBossSkillToPlayerRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("epicbattle_text_51"))
	else
		SoraDShowMsgTip(i18n("endless_treasures_text_13"))
	end
end
function atlantisWarCtrl:reqBuildOccupyLogRsp(content)
	dump(content, "atlantisWarCtrl:reqBuildOccupyLogRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_KINGDOMWAR_GETLOG_PALACE"
		gErrDef.Err_None.retdate = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function atlantisWarCtrl:reqWarPeopleNumRsp(content)
	dump(content, "atlantisWarCtrl:reqWarPeopleNumRsp(content)", 10)
	self.peopleNumInWar = content.rspdata
	_ENV = content
	content.msg = "MESSAGE_ATLANTISWAR_REFRESH_POINT_RANK"
	content.key = "reqWarPeopleNumRsp"
	content.err = content.err
	SoraDSendMessage(content)
end
function atlantisWarCtrl:reqSetArmyMinLvRsp(content)
	dump(content, "atlantisWarCtrl:reqSetArmyMinLvRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_4512"))
	else
		SoraDShowMsgTip(i18n("atlantiswar_text_0298"))
	end
end
function atlantisWarCtrl:getCampMap()
	return self.campMap
end
function atlantisWarCtrl:getWarData()
	return self.warData
end
function atlantisWarCtrl:getMarshalMap()
	return self.marshalMap
end
function atlantisWarCtrl:getPlayerBuffList()
	local warData = self:getWarData()
	if not warData.playerBuffList then
		warData.playerBuffList, _UPVALUE0_ = warData.playerBuffList, warData.playerBuffList
	end
	return warData.playerBuffList
end
function atlantisWarCtrl:getCampData(camp)
	if not self.campMap[camp] then
		self.campMap[camp], _UPVALUE0_ = nil, nil
	end
	return self.campMap[camp]
end
function atlantisWarCtrl:getCampKid(camp)
	local campData = self:getCampData(camp)
	return campData.kid or 0
end
function atlantisWarCtrl:getWarStage(...)
	local warData = self:getWarData()
	local curTime = serviceFunctions.systemTime()
	_ENV = nil
	;(nil)[gAtlantisWarStageType.wlynReady] = warData.bossWlynStartTime
	;(nil)[gAtlantisWarStageType.wlynIng] = warData.bossWlynEndTime
	;(nil)[gAtlantisWarStageType.sdReady] = warData.bossSdStartTime
	;(nil)[gAtlantisWarStageType.sdIng] = warData.bossSdEndTime
	;(nil)[gAtlantisWarStageType.warAreaReady] = warData.warAreaStartTime
	local (nil)[gAtlantisWarStageType.warAreaIng], timeConfig = warData.warAreaEndTime, nil
	local stage = gAtlantisWarStageType.battleEnd
	local leftTime = 0
	for i, time in ipairs(timeConfig) do
		if time > curTime then
			stage = i
			leftTime = time - curTime
			break
		end
	end
	print("==atlantisWarCtrl:getWarStage==", stage, leftTime)
	return stage, leftTime
end
function atlantisWarCtrl:getWarStageTime(stage)
	local warData = self:getWarData()
	_ENV = self
	self[gAtlantisWarStageType.wlynReady] = warData.bossWlynStartTime
	self[gAtlantisWarStageType.wlynIng] = warData.bossWlynEndTime
	self[gAtlantisWarStageType.sdReady] = warData.bossSdStartTime
	self[gAtlantisWarStageType.sdIng] = warData.bossSdEndTime
	self[gAtlantisWarStageType.warAreaReady] = warData.warAreaStartTime
	local self[gAtlantisWarStageType.warAreaIng], timeConfig = warData.warAreaEndTime, self
	return timeConfig[stage] or 0
end
function atlantisWarCtrl:getWarStageRemainTime(stage)
	local curTime = serviceFunctions.systemTime()
	return math.max(0, self:getWarStageTime(stage) - curTime)
end
function atlantisWarCtrl:getKindomPointRank()
	local _ENV, rankList
	local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
	local curState = atlantisActivityCtrl:getActivityCurState()
	for camp, campData in ipairs(self.campMap) do
		local kindomInfo
		if curState >= ATLANTIS_WAR_STATE.BATTLE and curState ~= ATLANTIS_WAR_STATE.RESULT then
			kindomInfo = atlantisActivityCtrl:getMatchKindomInfoByKid(campData.kid)
		end
		if not kindomInfo then
			local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
			local ret, kingdom = kingdomCtrl:isFoundKingdomID(campData.kid)
			_ENV = campData.kid
			campData.kid.flag = kingdom and kingdom.flagid or 0
			campData.kid.kname = kingdom and kingdom.kname
			kindomInfo, campData.kid.kingdomName = campData.kid, ""
		end
		local killBossScore = (campData.killBossWlynScore or 0) + (campData.killBossSdScore or 0)
		local lastScoreTime = math.max(campData.killBossWlynFcTime or 0, campData.killBossSdFcTime or 0, campData.killPlayerScoreTime or 0, campData.occupyScoreTime or 0)
		_ENV = campData.killBossWlynFcTime or 0
		;(campData.killBossWlynFcTime or 0).camp = camp
		;(campData.killBossWlynFcTime or 0).kid = campData.kid
		;(campData.killBossWlynFcTime or 0).flag = kindomInfo.flag
		;(campData.killBossWlynFcTime or 0).nameStr = kindomInfo.kname or serviceFunctions.getKingdomFormatName(kindomInfo.kingdomName, campData.kid)
		;(campData.killBossWlynFcTime or 0).killBossScore = killBossScore
		;(campData.killBossWlynFcTime or 0).killPlayerScore = campData.killPlayerScore or 0
		;(campData.killBossWlynFcTime or 0).occupyScore = campData.occupyScore or 0
		;(campData.killBossWlynFcTime or 0).totalScore = killBossScore + (campData.killPlayerScore or 0) + (campData.occupyScore or 0)
		local (campData.killBossWlynFcTime or 0).t, data = lastScoreTime, campData.killBossWlynFcTime or 0
		local people = self.peopleNumInWar and self.peopleNumInWar[camp]
		if people then
			data.peopleNum = people.commonCount + people.managerCount
		end
		table.insert(rankList, data)
	end
	_UPVALUE2_, _UPVALUE3_ = nil, ipairs(self.campMap)
	_UPVALUE2_, (nil)[1] = "totalScore", "totalScore"
	_UPVALUE2_, (nil)[2] = "totalScore", ">"
	_UPVALUE2_, ("totalScore")[1] = "t", "t"
	_UPVALUE2_, ("totalScore")[2] = "t", "<"
	;("t")[1] = "camp"
	;("t")[2] = ">"
	ipairs(self.campMap)[1] = nil
	ipairs(self.campMap)[2] = "totalScore"
	ipairs(self.campMap)[3] = "t"
	serviceFunctions.sort(rankList, ipairs(self.campMap))
	return rankList
end
function atlantisWarCtrl:getCampPlayerList(...)
	return self.campPlayerList
end
function atlantisWarCtrl:getCampPlayerByUid(uid)
	local index = self.campPlayerMap[tostring(uid)]
	if index then
		local player = self.campPlayerList[index]
		return player
	end
end
function atlantisWarCtrl:getSelfMemberClass(...)
	local warData = self:getWarData()
	return warData.memberClass or gAtlantisRankType.R1
end
function atlantisWarCtrl:getSelfCamp(...)
	local selfKid = gametop.playertop_:getKingdomID()
	for camp, v in pairs(self.campMap) do
		if v.kid == selfKid then
			return camp
		end
	end
end
function atlantisWarCtrl:getMarshalTime(...)
	local warData = self:getWarData()
	local beginTime = warData.fortCycleBeginTime or warData.warAreaStartTime or 0
	local endTime = beginTime + ATLANTIS_WAR_MARSHAL_TIME
	local time = endTime - serviceFunctions.systemTime()
	if 0 < time then
		return time
	else
		return 0
	end
end
function atlantisWarCtrl:getPlayerBuffValue(buffEffect)
	local buffValue = 0
	local leftTime = 0
	local sysTime = serviceFunctions.systemTime()
	local playerBuffList = self:getPlayerBuffList()
	for _, buffData in pairs(playerBuffList) do
		if buffData.effect == buffEffect and sysTime < buffData.endTime then
			buffValue = buffValue + buffData.value
			local time = buffData.endTime - sysTime
			if leftTime < time then
				leftTime = time
			end
		end
	end
	return buffValue, leftTime
end
function atlantisWarCtrl:getTeamBuffValue(buffEffect)
	local buffValue = 0
	local leftTime = 0
	local sysTime = serviceFunctions.systemTime()
	local teamBuffList = self:getAtlentisWarData()
	for _, buffData in pairs(teamBuffList) do
		if buffData.effect == buffEffect and sysTime < buffData.endTime then
			buffValue = buffValue + buffData.value
			local time = buffData.endTime - sysTime
			if leftTime < time then
				leftTime = time
			end
		end
	end
	return buffValue, leftTime
end
function atlantisWarCtrl:getScoreWeight(...)
	local warData = self:getWarData()
	return warData and warData.scoreWeight or 1
end
function atlantisWarCtrl:getAtlentisWarData()
	if not self.atlantisWarData then
		self.atlantisWarData, _UPVALUE0_ = self.atlantisWarData, self.atlantisWarData
	end
	return self.atlantisWarData
end
function atlantisWarCtrl:onTeamBuffAdd(notifyData)
	dump(notifyData, "atlantisWarCtrl:onTeamBuffAdd()", 10)
	if notifyData then
		local buffid = tostring(notifyData.id)
		self.atlantisWarData = self:getAtlentisWarData()
		self.atlantisWarData[buffid] = notifyData
	end
end
function atlantisWarCtrl:onTeamBuffRemove(notifyData)
	dump(notifyData, "atlantisWarCtrl:onTeamBuffRemove()", 10)
	local buffid = tostring(notifyData.buffId)
	self.atlantisWarData = self:getAtlentisWarData()
	if self.atlantisWarData[buffid] then
		self.atlantisWarData[buffid] = nil
	end
end
function atlantisWarCtrl:onTeamBuffUpdate(notifyData)
	dump(notifyData, "atlantisWarCtrl:onTeamBuffUpdate()", 10)
	if notifyData then
		local buffid = tostring(notifyData.id)
		self.atlantisWarData = self:getAtlentisWarData()
		if self.atlantisWarData[buffid] then
			self.atlantisWarData[buffid] = notifyData
		end
	end
end
function atlantisWarCtrl:getOccupyQueueArmyMinLv(...)
	return self.occupyArmyLimit and self.occupyArmyLimit.occupyQueueArmyMinLv or 1
end
return atlantisWarCtrl
