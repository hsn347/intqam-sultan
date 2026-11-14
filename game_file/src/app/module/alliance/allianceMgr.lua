local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local allianceClass = include("alliance")
local msgCtrl = include("msgCtrl")
local allianceMgr = class("allianceMgr", gameModule)
local _ENV, REQ = "allianceMgr", "allianceMgr"
local _ENV, RSP = gameModule, gameModule
function allianceMgr:ctor(properties)
	allianceMgr.super.ctor(self, properties)
	self:resetData()
end
function allianceMgr:EnterGame()
	allianceMgr.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_CREATE, handler(self, RSP.createAllianceRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DISMISS, handler(self, RSP.dismissAllianceRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_JOIN, handler(self, RSP.commonRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_QUIT, handler(self, RSP.commonRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_EXPEL_MEMBER, handler(self, RSP.commonRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_APPLY_JOIN, handler(self, RSP.applyJion))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_CANCEL_APPLY, handler(self, RSP.cancelApplyJoin))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_AGREE_APPLY, handler(self, RSP.agreeApply))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_REJECT_APPLY, handler(self, RSP.rejectApply))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_INVITE_JOIN, handler(self, RSP.inviteJoinRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_AGREE_INVITE, handler(self, RSP.agreeInvite))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_REJECT_INVITE, handler(self, RSP.rejectInvite))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_NOTICE_INVITE, handler(self, RSP.reqNoticeInviteRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DEMISE, handler(self, RSP.commonRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_REPLACE_LEADER, handler(self, RSP.commonRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_PROMOTE_MEMBER, handler(self, RSP.commonRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DEMOTE_MEMBER, handler(self, RSP.commonRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_INVITE_MOVE_CITY, handler(self, RSP.reqInviteMoveCityRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_REJECT_INVITE_MOVE_CITY, handler(self, RSP.commonRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_SEND_ALL_MAIL, handler(self, RSP.sendAllianceAllMailRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REA_ALLIANCE_OPEN_ESCORT_ADD, handler(self, RSP.openEscortAddRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_ALLIANCE_SCIENCE, handler(self, RSP.getAllianceScienceRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_OFFICIAL_APPLY, handler(self, RSP.officailApplyRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_OFFICIAL_APPOINT, handler(self, RSP.officailAppointRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_OFFICAIL_FIRE, handler(self, RSP.officailFireRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANEC_CREATE_LEGION, handler(self, RSP.createLegionRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_RESEARCH_SCI_SPEED, handler(self, RSP.speedAllianceScienceRsp))
end
function allianceMgr:Logout()
	allianceMgr.super.Logout(self)
	self:resetData()
end
function allianceMgr:resetData()
	self.alliances, _UPVALUE0_ = nil, nil
	self.ownaid = nil
	self.officialApplyList, _UPVALUE0_, self.officialList, _UPVALUE0_, self.leaderPos = nil, nil, nil, nil, nil
	self.ownTeamID = nil
end
function allianceMgr:hasJoinAlliance(team)
	if team then
		return self:getOwnTeamID()
	end
	return self:getOwnAid()
end
function allianceMgr:setOwnAid(aid)
	print("allianceMgr:setOwnAid")
	self.ownaid = aid
end
function allianceMgr:getOwnAid()
	return self.ownaid
end
function allianceMgr:setOwnTeamID(teamID)
	self.ownTeamID = teamID
end
function allianceMgr:getOwnTeamID()
	return self.ownTeamID or self.ownaid
end
function allianceMgr:getRealTeamID()
	return self.ownTeamID
end
function allianceMgr:getAlliance(aid)
	aid = aid or self.ownaid
	if aid then
		return self.alliances[aid]
	end
end
function allianceMgr:isLeader()
	local alliance = self:getAlliance()
	if alliance then
		local leader = alliance:getProperty("leader")
		local uid = gametop.playertop_:getPlayerID()
		if leader == uid then
			return true
		end
	end
end
function allianceMgr:getAllianceProperty(key, aid)
	aid = aid ~= "" and aid or self.ownaid
	local alliance = self:getAlliance(aid)
	return alliance and alliance:getProperty(key)
end
function allianceMgr:getAllianceInfo(aid)
	aid = aid ~= "" and aid or self.ownaid
	local alliance = self:getAlliance(aid)
	return alliance and alliance:getAllianceInfo()
end
function allianceMgr:getLegionList(aid)
	local _ENV, ret
	aid = aid ~= "" and aid or self.ownaid
	local alliance = self:getAlliance(aid)
	if alliance then
		local legionList = alliance.legionList
		for i, v in ipairs(legionList) do
			table.insert(ret, v)
		end
		return ret
	end
end
function allianceMgr:getMemberList(aid)
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local gametop, ret = gametop.playertop_, gametop.playertop_
	aid = aid or self.ownaid
	local alliance = self:getAlliance(aid)
	if alliance then
		local gametop, memberlist = self, self
		local memberIdList = alliance.memberlist
		for k, v in pairs(memberIdList) do
			local member = memberMgr:getMember(v)
			table.insert(memberlist, member)
		end
		local applyIdList = alliance.applylist
		for k, v in pairs(applyIdList) do
			local member = memberMgr:getMember(v)
			table.insert(memberlist, member)
		end
		local isself = false
		if aid == self.ownaid then
			isself = true
		end
		ret = memberMgr:getRankMemberList(memberlist, isself)
	end
	return ret
end
function allianceMgr:getAllianceTotalBattle(aid)
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ret = 0
	aid = aid or self.ownaid
	local alliance = self:getAlliance(aid)
	if alliance then
		ret = alliance.totalBattle
	end
	return ret
end
function allianceMgr:getAllianceLeaderName(aid)
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ret = ""
	aid = aid or self.ownaid
	local alliance = self:getAlliance(aid)
	if alliance then
		ret = alliance.leaderName
	end
	return ret
end
function allianceMgr:addAllianceList(alliance)
	local aid = alliance:getProperty("aid")
	if not aid or aid == 0 then
		return
	end
	self.alliances[aid] = alliance
end
function allianceMgr:removeAlliance(aid)
	if not aid then
		return
	end
	if self.ownaid == aid then
		local allianceHelp = gametop.playertop_:getModule("allianceHelp")
		allianceHelp:resetData()
		local allianceStore = gametop.playertop_:getModule("allianceStore")
		allianceStore:resetData()
		local allianceScience = gametop.playertop_:getModule("allianceScience")
		allianceScience:resetData()
		local allianceMsg = gametop.playertop_:getModule("allianceMsg")
		allianceMsg:resetData()
		local allianceLog = gametop.playertop_:getModule("allianceLog")
		allianceLog:resetData()
	end
	self.alliances[aid] = nil
end
function allianceMgr:createAlliance(params)
	if not params then
		return
	end
	local alliance = allianceClass.new(params)
	self:addAllianceList(alliance)
	return alliance
end
function allianceMgr:updateAlliance(aid, params)
	if params and aid then
		local alliance = self.alliances[aid]
		if alliance then
			for k, v in pairs(params) do
				alliance:setProperty(k, v)
			end
		end
		return alliance
	end
end
function allianceMgr:getAllianceBattlePeopleCount()
	local base = gConstValue.ALLIANCE_ARMY_PEOPLE_COUNT
	local worldMapWarDef = include("worldMapWarDef")
	local alliance_sci_add = worldMapWarDef.getAllianceBattlePeopleAdd()
	local total = base + alliance_sci_add
	return total
end
function allianceMgr:updateLeaderPos(pos)
	self.leaderPos = pos
end
function allianceMgr:getLeaderPos()
	if self.leaderPos and 0 == tonumber(self.leaderPos.x) and 0 == tonumber(self.leaderPos.y) then
		return
	end
	return self.leaderPos
end
function allianceMgr:setOfficialList(list)
	self.officialList = list
end
function allianceMgr:getOfficialList()
	return self.officialList
end
function allianceMgr:setOfficialApplyList(list)
	self.officialApplyList = list
end
function allianceMgr:getApplyListByOfficialID(official)
	if not self.officialApplyList[tostring(official)] then
		_ENV = self.officialApplyList[tostring(official)]
	end
	return self.officialApplyList[tostring(official)]
end
function allianceMgr:getOfficialApplyList()
	return self.officialApplyList
end
function allianceMgr:reqCreateAlliance(name, abbr, manifesto, language, ...)
	serverproxy = nil
	;(nil).name = name
	;(nil).abbr = abbr
	;(nil).manifesto = manifesto
	;(nil).language = language
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_CREATE, nil, ...)
end
function allianceMgr:reqDismissAlliance(...)
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DISMISS, nil, ...)
end
function allianceMgr:reqJoinAlliance(aid, ...)
	serverproxy = nil
	;(nil).aid = aid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_JOIN, nil, ...)
end
function allianceMgr:reqQuitAlliance(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_QUIT, nil, ...)
end
function allianceMgr:reqExpelMember(uid, ...)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_EXPEL_MEMBER, nil, ...)
end
function allianceMgr:reqApplyJion(aid, ...)
	serverproxy = nil
	;(nil).aid = aid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_APPLY_JOIN, nil, ...)
end
function allianceMgr:reqCancelApplyJoin(aid, ...)
	serverproxy = nil
	;(nil).aid = aid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_CANCEL_APPLY, nil, ...)
end
function allianceMgr:reqAgreeApplication(uid, ...)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_AGREE_APPLY, nil, ...)
end
function allianceMgr:reqRejectApplication(uid, ...)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_REJECT_APPLY, nil, ...)
end
function allianceMgr:reqInviteJoin(uid, ...)
	if uid then
		serverproxy = nil
		;(nil).uid = uid
		serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_INVITE_JOIN, nil, ...)
	else
		local msgNotice = include("msgNotice")
		msgNotice.notice("notice_0026")
	end
end
function allianceMgr:reqAgreeInviteJoin(aid, uid, ...)
	serverproxy = nil
	;(nil).aid = aid
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_AGREE_INVITE, nil, ...)
end
function allianceMgr:reqRejectInviteJoin(aid, ...)
	serverproxy = nil
	;(nil).aid = aid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_REJECT_INVITE, nil, ...)
end
function allianceMgr:reqNoticeInvite(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_NOTICE_INVITE, nil, ...)
end
function allianceMgr:reqDemiseAlliance(uid, ...)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DEMISE, nil, ...)
end
function allianceMgr:reqReplaceLeader(uid, ...)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_REPLACE_LEADER, nil, ...)
end
function allianceMgr:reqPromoteMember(uid, ...)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_PROMOTE_MEMBER, nil, ...)
end
function allianceMgr:reqDemoteMember(uid, ...)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DEMOTE_MEMBER, nil, ...)
end
function allianceMgr:reqInviteMoveCity(uid, pos, mtype, ...)
	serverproxy = nil
	;(nil).uid = uid
	;(nil).pos = pos
	;(nil).mtype = mtype
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_INVITE_MOVE_CITY, nil, ...)
end
function allianceMgr:reqRejectInviteMoveCity(aid, ...)
	serverproxy = nil
	;(nil).aid = aid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_REJECT_INVITE_MOVE_CITY, nil, ...)
end
function allianceMgr:reqSendAllianceAllMail(content)
	serverproxy = nil
	;(nil).content = content
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_SEND_ALL_MAIL, nil)
end
function allianceMgr:reqOpenEscortAdd(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REA_ALLIANCE_OPEN_ESCORT_ADD, nil, ...)
end
function allianceMgr:reqGetAllianceScience(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_ALLIANCE_SCIENCE, nil, ...)
end
function allianceMgr:reqSpeedAllianceScience(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_RESEARCH_SCI_SPEED, nil, ...)
end
function allianceMgr:reqApplyAllianceOfficial(official, ...)
	serverproxy = nil
	;(nil).official = official
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_OFFICIAL_APPLY, nil, ...)
end
function allianceMgr:reqAppointAllianceOfficial(uid, official, ...)
	serverproxy = nil
	;(nil).uid = uid
	;(nil).official = official
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_OFFICIAL_APPOINT, nil, ...)
end
function allianceMgr:reqFireAllianceOfficial(official, ...)
	serverproxy = nil
	;(nil).official = official
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_OFFICAIL_FIRE, nil, ...)
end
function allianceMgr:reqCreateLegion(legionName, ...)
	print("legionName", legionName)
	_ENV = nil
	;(nil).legionName = legionName
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANEC_CREATE_LEGION, nil, ...)
end
function RSP:commonRsp(content)
	SoraDCloseLoading()
	if content.err ~= gErrDef.Err_None then
		print("rsp error: ", content.err)
		if content.err == gErrDef.Err_ALLIANCE_CANNOT_EXIT_HAS_ARMY then
			SoraDShowMsgTip(i18n("common_text_808"))
		end
		if content.err == gErrDef.Err_ALLIANCE_CANNOT_KICK_HAS_ANCIENT_TREASURY_QUEUE then
			SoraDShowMsgTip(i18n("AncienTreasure_text_79"))
		end
		if content.err == gErrDef.Err_ALLIANCE_CANNOT_EXIT_HAS_ATK_STRONGHOLD_QUEUE then
			SoraDShowMsgTip(i18n("alliance_stronghold_text_125"))
		end
		return
	end
end
function RSP:createAllianceRsp(content)
	if content.err == gErrDef.Err_None then
		local allianceinfo = content.data.retdata.allianceinfo
		local alliance = self:createAlliance(allianceinfo)
		local aid = alliance:getProperty("aid")
		self.ownaid = aid
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local memberinfo = content.data.retdata.memberinfo
		if memberinfo then
			for k, v in pairs(memberinfo) do
				local member = include("member").new()
				member:setProperty("minfo", v.minfo)
				member:setProperty("uinfo", v.uinfo)
				memberMgr:addMember(member)
			end
		end
		local sciencelist = content.data.retdata.scienceinfo
		local allianceScience = gametop.playertop_:getModule("allianceScience")
		if sciencelist then
			local scienceRecommendList = content.data.retdata.scienceRecommendList
			allianceScience:setScienceList(sciencelist, scienceRecommendList)
		end
		local leadername = content.data.retdata.leadername
		if leadername then
			alliance.leaderName = leadername
		end
		self.leaderPos = content.data.retdata.leaderPos
		local totalBattle = content.data.retdata.totalpower
		if totalBattle then
			alliance.totalBattle = totalBattle
		end
		local buildData = content.data.retdata.buildData
		if buildData then
			local allianceBuild = gametop.playertop_:getModule("allianceBuild")
			allianceBuild:initClientData(buildData)
		end
		local territoryData = content.data.retdata.territoryData
		local allianceTerritoryCtrl = gametop.playertop_:getModule("allianceTerritoryCtrl")
		allianceTerritoryCtrl:initializeLoginData(territoryData)
		_ENV = allianceTerritoryCtrl
		allianceTerritoryCtrl.msg = "MESSAGE_ALLIACNE_CREATE_SUCCESS"
		allianceTerritoryCtrl.content = content
		SoraDSendMessage(allianceTerritoryCtrl)
		_ENV = allianceTerritoryCtrl
		allianceTerritoryCtrl.msg = "MESSAGE_ALLIANCE_JOIN_SUCCESS"
		SoraDSendMessage(allianceTerritoryCtrl)
		_ENV = allianceTerritoryCtrl
		allianceTerritoryCtrl.msg = "MESSAGE_ALLIANCE_MAINUIINVITE_REFRESH"
		SoraDSendMessage(allianceTerritoryCtrl)
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		lordInfoCtrl.lordInfo.abbr = alliance.property.abbr
	else
		_ENV = self:createAlliance(allianceinfo)
		self:createAlliance(allianceinfo).msg = "MESSAGE_ALLIANCE_CREATE_ERR_BACK"
		self:createAlliance(allianceinfo).err = content.err
		SoraDSendMessage((self:createAlliance(allianceinfo)))
	end
end
function RSP:dismissAllianceRsp(content)
	if content.err == gErrDef.Err_None then
		local property = content.data.retdata
		self:removeAlliance(self.ownaid)
		print("ownaid=", self.ownaid)
		self.leaderPos = nil
		_ENV = self.ownaid
		_ENV, self.ownaid.name = gEventName.event_alliance_dismiss_success, gEventName.event_alliance_dismiss_success
		self.ownaid.data, gEventName.event_alliance_dismiss_success.aid = gEventName.event_alliance_dismiss_success, self.ownaid
		self:dispatchEvent(self.ownaid)
		self.ownaid = nil
		SoraDRemoveAllPanelFromManager()
		_ENV = self
		self.msg = "MESSAGE_ALLIANCE_DISMISS_SUCCESS"
		SoraDSendMessage(self)
		local allianceTreasureCtrl = gametop.playertop_:getModule("allianceTreasureCtrl")
		allianceTreasureCtrl:resetData()
		_ENV = allianceTreasureCtrl
		allianceTreasureCtrl.msg = "MESSAGE_MAINCITYVIEW_REMOVE_WAREHOUSE_GIFT_TOP_TIP"
		SoraDSendMessage(allianceTreasureCtrl)
		local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
		romeActivityCtrl:resetAllianceRomeActivityData()
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		lordInfoCtrl.lordInfo.abbr = ""
		local allianceScience = gametop.playertop_:getModule("allianceScience")
		allianceScience:resetData()
		_ENV = nil
		;(nil).name = gEventName.event_alliance_science_success
		allianceScience:dispatchEvent(nil)
		local allianceBuild = gametop.playertop_:getModule("allianceBuild")
		allianceBuild:demolishAllBuild()
		local allianceTerritoryCtrl = gametop.playertop_:getModule("allianceTerritoryCtrl")
		allianceTerritoryCtrl:destroyTerritory()
		local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
		allianceRelationCtrl:clear()
		local allianceBWList = gametop.playertop_:getModule("allianceBWList")
		allianceBWList:resetData()
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		kingdomMapCtrl:onDismissAlliance()
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local member = memberMgr:getOwnMember()
		if member then
			member:reset()
		end
		local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
		pyramidWarCtrl:resetAlliancePyramidWarData()
		local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
		alliancePetCtrl:resetData()
		local allianceActiveCtrl = gametop.playertop_:getModule("allianceActiveCtrl")
		allianceActiveCtrl:resetData()
	else
	end
	SoraDCloseLoading()
end
function RSP:inviteJoinRsp(content)
	local msgNotice = include("msgNotice")
	if content.err == gErrDef.Err_None then
		msgNotice.notice("notice_0092")
	elseif content.err == gErrDef.Err_ALLIANCE_INVITE_FUNCTION_NOT_OPEN then
		msgNotice.notice("common_text_4708")
	elseif content.err == gErrDef.Err_ALLIANCE_ALEADY_JOIN then
	else
		msgNotice.notice("common_text_991")
	end
end
function RSP:applyJion(content)
	if content.err == gErrDef.Err_None then
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local member = memberMgr:getOwnMember()
		member:setProperty("curApplyAid", content.data.aid)
		_ENV = content.data.aid
		content.data.aid.byUID = true
		SoraDConfigSet("Game:allianceInfoView:applyTime~integer", os.time(), content.data.aid)
		_ENV = "Game:allianceInfoView:applyTime~integer"
		;("Game:allianceInfoView:applyTime~integer").msg = "MESSAGE_ALLIACNE_APPLY_JOIN"
		;("Game:allianceInfoView:applyTime~integer").aid = content.data.aid
		SoraDSendMessage("Game:allianceInfoView:applyTime~integer")
		_ENV = "Game:allianceInfoView:applyTime~integer"
		;("Game:allianceInfoView:applyTime~integer").msg = "MESSAGE_ALLIACNE_CANCEL_APPLY_JOIN"
		;("Game:allianceInfoView:applyTime~integer").aid = content.data.aid
		SoraDSendMessage("Game:allianceInfoView:applyTime~integer")
	end
end
function RSP:cancelApplyJoin(content)
	if content.err == gErrDef.Err_None then
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local member = memberMgr:getOwnMember()
		member:setProperty("curApplyAid", 0)
		_ENV = 0
		;(0).byUID = true
		SoraDConfigSet("Game:allianceInfoView:applyTime~integer", 0, 0)
		_ENV = "Game:allianceInfoView:applyTime~integer"
		;("Game:allianceInfoView:applyTime~integer").msg = "MESSAGE_ALLIACNE_CANCEL_APPLY_JOIN"
		;("Game:allianceInfoView:applyTime~integer").aid = content.data.aid
		SoraDSendMessage("Game:allianceInfoView:applyTime~integer")
	end
end
function RSP:sendAllianceAllMailRsp(content)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("Union_text_3"))
	else
		print("error=", content.err)
	end
end
function RSP:agreeInvite(content)
	if content.err == gErrDef.Err_None then
		if content.clientData then
			local mid = content.clientData.mid
			local mailSetType = gMailSetType.ALLIANCE
			_ENV = nil
			;(nil).msg = "MESSAGE_MAIL_UI_DEL_MAIL"
			;(nil).mailSetType = mailSetType
			_UPVALUE1_, (nil).keys = nil, nil
			;(nil).midArray, (nil)[1] = nil, mid
			SoraDSendMessage(nil)
		end
		SoraDCloseLoading()
	else
		SoraDCloseLoading()
		if content.err == gErrDef.Err_ALLIANCE_NOT_FOUND_ALLIANCE then
			SoraDShowMsgTip(i18n("common_text_3627"))
		end
	end
end
function RSP:agreeApply(content)
	if content.err == gErrDef.Err_None then
		if content.clientData then
			local mid = content.clientData.mid
			local mailSetType = gMailSetType.ALLIANCE
			_ENV = nil
			;(nil).msg = "MESSAGE_MAIL_UI_DEL_MAIL"
			;(nil).mailSetType = mailSetType
			_UPVALUE1_, (nil).keys = nil, nil
			;(nil).midArray, (nil)[1] = nil, mid
			SoraDSendMessage(nil)
		end
		_ENV = gMailSetType.ALLIANCE
		gMailSetType.ALLIANCE.msg = "MESSAGE_ALLIANCE_MAINUIINVITE_REFRESH"
		SoraDSendMessage(gMailSetType.ALLIANCE)
		SoraDCloseLoading()
	else
		local msgNotice = include("msgNotice")
		local noticeId = msgNotice.getTipCode(content.err)
		noticeId = noticeId or "notice_0026"
		msgNotice.notice(noticeId)
		SoraDCloseLoading()
	end
end
function RSP:rejectApply(content)
	if content.err == gErrDef.Err_None then
		if content.clientData then
			local mid = content.clientData.mid
			local mailSetType = gMailSetType.ALLIANCE
			_ENV = nil
			;(nil).msg = "MESSAGE_MAIL_UI_DEL_MAIL"
			;(nil).mailSetType = mailSetType
			_UPVALUE1_, (nil).keys = nil, nil
			;(nil).midArray, (nil)[1] = nil, mid
			SoraDSendMessage(nil)
		end
		_ENV = gMailSetType.ALLIANCE
		gMailSetType.ALLIANCE.msg = "MESSAGE_ALLIANCE_APPLY_REJECT"
		SoraDSendMessage(gMailSetType.ALLIANCE)
		SoraDCloseLoading()
	else
		local msgNotice = include("msgNotice")
		local noticeId = msgNotice.getTipCode(content.err)
		noticeId = noticeId or "notice_0026"
		msgNotice.notice(noticeId)
		SoraDCloseLoading()
	end
end
function RSP:rejectInvite(content)
	if content.err == gErrDef.Err_None then
		if content.clientData then
			local mid = content.clientData.mid
			local mailSetType = gMailSetType.ALLIANCE
			_ENV = nil
			;(nil).msg = "MESSAGE_MAIL_UI_DEL_MAIL"
			;(nil).mailSetType = mailSetType
			_UPVALUE1_, (nil).keys = nil, nil
			;(nil).midArray, (nil)[1] = nil, mid
			SoraDSendMessage(nil)
		end
		SoraDCloseLoading()
	else
		if content.clientData then
			local mid = content.clientData.mid
			local mailSetType = gMailSetType.ALLIANCE
			_ENV = nil
			;(nil).msg = "MESSAGE_MAIL_UI_DEL_MAIL"
			;(nil).mailSetType = mailSetType
			_UPVALUE1_, (nil).keys = nil, nil
			;(nil).midArray, (nil)[1] = nil, mid
			SoraDSendMessage(nil)
		end
		SoraDCloseLoading()
	end
end
function RSP:reqNoticeInviteRsp(content)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ALLIANCE_NOTICE_INVITE_SUCCESS"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function RSP:reqInviteMoveCityRsp(content)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_990"))
	else
		SoraDShowMsgTip(i18n("common_text_991"))
	end
end
function RSP:openEscortAddRsp(content)
	dump(content, "RSP.openEscortAddRsp", 10)
	if content.err == gErrDef.Err_None then
		local escortinfo = content.data.retdata
		local alliance = self:getAlliance()
		if alliance then
			alliance:setEscortInfo(escortinfo)
		end
		_ENV = alliance
		alliance.msg = "MESSAGE_SERVER_ESCORT_REQ_ESCORT_ALLIANCE_ADD_SUCCESS"
		SoraDSendMessage(alliance)
		_ENV = alliance
		alliance.msg = "MESSAGE_SERVER_ESCORT_ESCORT_CAR_ADD_VALUE_UPDATE"
		SoraDSendMessage(alliance)
	else
		_ENV = self:getAlliance()
		self:getAlliance().msg = "MESSAGE_SERVER_ESCORT_REQ_ESCORT_ALLIANCE_ADD_FAILED"
		SoraDSendMessage((self:getAlliance()))
	end
end
function RSP:getAllianceScienceRsp(content)
	if content.err == gErrDef.Err_None then
		local allianceScience = gametop.playertop_:getModule("allianceScience")
		local scienceinfo = content.data.retdata
		allianceScience:setScienceList(scienceinfo)
		_ENV = allianceScience
		allianceScience.msg = "MESSAGE_ALLIANCE_SCIENCE_DATA_BACK"
		SoraDSendMessage(allianceScience)
	else
	end
end
function RSP:speedAllianceScienceRsp(content)
	dump(content, "RSP.speedAllianceScienceRsp", 10)
	if content.err == gErrDef.Err_None then
		local allianceScience = gametop.playertop_:getModule("allianceScience")
		allianceScience:removeQueue(SCIENCE_RESEARCH_QUEUE)
		SoraDShowMsgTip(i18n("common_text_4726"))
	end
end
function RSP:officailApplyRsp(content)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local official = content.data.official
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local member = memberMgr:getOwnMember()
		if not member:getProperty("curApplyOfficial") then
			member.minfo.curApplyOfficial = 0
		end
		memberMgr:setMemberMinfo("curApplyOfficial", official)
		_ENV = memberMgr
		memberMgr.msg = "MESSAGE_ALLIANCE_OFFICIAL_APPLY_BACK"
		SoraDSendMessage(memberMgr)
	elseif content.err == gErrDef.Err_ALLIANCE_OFFICIAL_APPLY then
		SoraDShowMsgTip(i18n("alliance_office_text_16"))
	elseif content.err == gErrDef.Err_ALLIANCE_OFFICIAL_OCCUPIED then
		SoraDShowMsgTip(i18n("alliance_office_text_17"))
	elseif content.err == gErrDef.Err_ALLIANCE_OFFICIAL_APPLY_OTHER then
		SoraDShowMsgTip(i18n("alliance_office_text_18"))
	end
end
function RSP:officailAppointRsp(content)
	dump(content, "RSP.officailAppointRsp", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local official = content.data.official
		local uid = content.data.uid
		if self.officialApplyList[tostring(official)] and SoraDisInList(uid, self.officialApplyList[tostring(official)]) then
			for k, v in ipairs(self.officialApplyList[tostring(official)]) do
				if v == uid then
					table.remove(self.officialApplyList[tostring(official)], k)
					break
				end
			end
		end
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		memberMgr:setMemberMinfo("official", official, uid)
		memberMgr:setMemberMinfo("rank", gAllianceRank.OFFICIAL, uid)
		SoraDShowMsgTip(i18n("common_text_1431"))
		_ENV = i18n("common_text_1431")
		i18n("common_text_1431").msg = "MESSAGE_ALLIANCE_OFFICIAL_APPOINT_BACK"
		SoraDSendMessage(i18n("common_text_1431"))
	elseif content.err == gErrDef.Err_ALLIANCE_HAVE_OFFICIAL then
		SoraDShowMsgTip(i18n("alliance_office_text_02"))
	elseif content.err == gErrDef.Err_ALLIANCE_OFFICIAL_OCCUPIED then
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local member = memberMgr:getMember(content.data.uid)
		_ENV = i18n("alliance_office_text_02")
		i18n("alliance_office_text_02").name = member.uinfo.nickName
		SoraDShowMsgTip(i18n("common_text_1429", i18n("alliance_office_text_02")))
	else
		print("任命失败=====", content.err)
	end
end
function RSP:officailFireRsp(content)
	dump(content, "RSP.officailFireRsp", 10)
	if content.err == gErrDef.Err_None then
	else
	end
end
function RSP:createLegionRsp(content)
	dump(content, "RSP.createLegionRsp", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ALLIACNE_CREATE_SUCCESS"
		SoraDSendMessage(gErrDef.Err_None)
		local panel = SoraDCreatePanel("allianceGroupMemberList")
		panel:initData(#content.rspdata, true)
		panel:show()
	else
		if content.err == gErrDef.Err_ALLIANCE_LEGION_NOT_LEADER then
			SoraDShowMsgTip(i18n("notice_0026"))
		elseif content.err == gErrDef.Err_ALLIANCE_LEGION_LEADER_OR_CAPTAIN then
			SoraDShowMsgTip(i18n("pyramid_tips_11"))
		end
		_ENV = i18n("pyramid_tips_11")
		i18n("pyramid_tips_11").msg = "MESSAGE_ALLIANCE_CREATE_ERR_BACK"
		i18n("pyramid_tips_11").err = content.err
		SoraDSendMessage(i18n("pyramid_tips_11"))
	end
end
function allianceMgr:dump(title)
	print("==========" .. (title or "AllianceMgr Dump") .. "==========")
	print("ownaid = ", self.ownaid)
	for _, v in pairs(self.alliances) do
		v:dump()
	end
end
return allianceMgr
