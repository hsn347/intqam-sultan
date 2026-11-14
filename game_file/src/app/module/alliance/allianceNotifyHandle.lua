local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local buildRead = include("buildDescribeRead")
local allianceNotifyHandle = class("allianceNotifyHandle", gameModule)
function allianceNotifyHandle:ctor(properties)
	allianceNotifyHandle.super.ctor(self, properties)
end
function allianceNotifyHandle:EnterGame()
end
function allianceNotifyHandle:resetData()
end
function allianceNotifyHandle:Logout()
	allianceNotifyHandle.super.Logout(self)
	self:resetData()
end
function allianceNotifyHandle:notifyHandle(event)
	local data = event.data
	for i, notifyData in ipairs(data) do
		local eventName = notifyData.eventName
		if eventName == gEventName.event_alliance_add_helpinfo_success then
			self:nodifyAddAllianceHelpInfo(notifyData)
		elseif eventName == gEventName.event_alliance_help_member_success then
			self:notidyHelpOne(notifyData)
		elseif eventName == gEventName.event_alliance_help_all_success then
			self:notidyHelpAll(notifyData)
		elseif eventName == gEventName.event_alliance_log_add_success then
			self:notifyAddAllianceLog(notifyData)
		elseif eventName == gEventName.event_alliance_del_help_data_success then
			self:removeHelpData(notifyData)
		elseif eventName == gEventName.event_alliancemsg_push then
			self:allianceMsgNotify(notifyData)
		elseif eventName == gEventName.event_alliance_rome_activity then
			self:handleAllianceRomeActivityData(notifyData)
		elseif eventName == gEventName.event_alliance_bwidlist_addordel then
			self:handleAllianceBWIDListAddOrDel(notifyData)
		elseif eventName == gEventName.event_alliance_bwidlist_update then
			self:publishAllianceBWIDListUpdate(notifyData)
		elseif eventName == gEventName.event_alliance_msg_shieldlist_operate then
			self:publishAllianceMsgShieldListOperate(notifyData)
		elseif eventName == gEventName.event_alliance_update_res_point then
			self:publishAllianceBuilding(notifyData)
		elseif eventName == gEventName.event_alliance_update_leader_pos then
			self:publishAllianceLeaderChange(notifyData)
		elseif eventName == gEventName.event_alliance_modify_permission then
			self:publishAllianceModifyPermission(notifyData)
		elseif eventName == gEventName.event_update_escort_add then
			self:publishUpdateEscortAdd(notifyData)
		elseif eventName == gEventName.event_alliance_update_best_alliance then
			self:publishUpdateBestAlliance(notifyData)
		elseif eventName == gEventName.event_alliance_update_ramadan_mobilize_top_alliance then
			self:publishUpdateRamadanBestAlliance(notifyData)
		elseif eventName == gEventName.event_alliance_relation_change then
			self:publishAllianceRelationChange(notifyData)
		elseif eventName == gEventName.event_alliance_update_king_packs_info then
			self:publishUpdateKingPacksInfo(notifyData)
		elseif eventName == gEventName.event_alliance_pyramidwar then
			self:handleAlliancePyramidWarData(notifyData)
		elseif eventName == gEventName.event_pyramidwar_appoint then
			self:notifyPyramidWarAppoint(notifyData)
		elseif eventName == gEventName.event_alliance_treasure_add then
			self:notifyAllianceTreasureInfoAdd(notifyData)
		elseif eventName == gEventName.event_alliance_treasure_reduce then
			self:notifyAllianceTreasureInfoReduce(notifyData)
		elseif eventName == gEventName.event_alliance_add_science_recommend then
			self:notifyAllianceScienceAddRecommend(notifyData)
		elseif eventName == gEventName.event_alliance_rm_science_recommend then
			self:notifyAllianceScienceRemoveRecommend(notifyData)
		elseif eventName == gEventName.event_alliance_call_beast or eventName == gEventName.event_alliance_beast_return or eventName == gEventName.event_alliance_beast_trial or eventName == gEventName.event_alliance_beast_blessing_open or eventName == gEventName.event_alliance_beast_blessing_close or eventName == gEventName.event_alliance_attack_beast then
			self:notifyAlliancePetInfoUpdate(notifyData)
		elseif eventName == gEventName.event_alliance_worship_beast then
			self:notifyAlliacneInfo(notifyData)
		elseif eventName == gEventName.event_alliance_official_appoint then
			self:notifyAllianceOfficialAppoint(notifyData)
		elseif eventName == gEventName.event_alliance_official_fire then
			self:notifyAllianceOfficialFire(notifyData)
		elseif eventName == gEventName.event_alliance_official_apply then
			self:notifyAllianceOfficialApply(notifyData)
		elseif eventName == gEventName.event_chronicle_achieve_update then
			local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
			legendMCtrl:onNotify_allianceAchieve(notifyData.allianceAchieve)
		elseif eventName == gEventName.event_alliance_legion_list then
			self:notifyAlliacneInfo(notifyData)
		elseif eventName == gEventName.event_alliance_legion_data then
			if notifyData.retdata and notifyData.retdata.alliancePyramidWarData then
				local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
				pyramidWarCtrl:legionInfoUpdate(notifyData.retdata.alliancePyramidWarData)
			end
		elseif eventName == gEventName.event_alliance_all_legion_info then
			if notifyData.retdata and notifyData.retdata then
				local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
				pyramidWarCtrl:initLegionInfoData(notifyData.retdata)
			end
		elseif eventName == gEventName.event_alliance_radiance_war_building_change then
			local radianceWarCtrl = gametop.playertop_:getModule("radianceWarCtrl")
			radianceWarCtrl:updateBuildData(notifyData)
		elseif eventName == gEventName.event_alliance_stronghold then
			local allianceStrontholdCtrl = gametop.playertop_:getModule("allianceStrontholdCtrl")
			if notifyData.data and notifyData.data.notifydata then
				allianceStrontholdCtrl:updateBuildData(notifyData.data.notifydata)
			end
		elseif eventName == gEventName.event_alliance_voice_room then
			local voiceRoomCtrl = SoraDGetCtrl("voiceRoomCtrl")
			if notifyData.data.notifyType == "delete" then
				voiceRoomCtrl:onRoomDelete()
			elseif notifyData.data.notifyType == "create" then
				voiceRoomCtrl:onRoomCreate()
			end
		else
			self:notifyAlliacneInfo(notifyData)
		end
	end
end
function allianceNotifyHandle:removeHelpData(notifyData)
	if not notifyData then
		return
	end
	local uid = notifyData.uid
	local queueTp = notifyData.queueTp
	local allianceHelp = gametop.playertop_:getModule("allianceHelp")
	if uid and queueTp then
		allianceHelp:removeHelp(uid, queueTp)
		if queueTp == gQueueTypeDef.eid_celebration_activity then
			SoraDGetCtrl("activity_9001643_Ctrl"):reqHelpList()
		end
	end
	if uid and not queueTp then
		allianceHelp:removePlayerHelpData(uid)
	end
	gametop = allianceHelp
	allianceHelp.msg = "MESSAGE_ALLIACNE_GET_ALLIANCE_HELP_LIST_SUCCESS"
	SoraDSendMessage(allianceHelp)
	gametop = allianceHelp
	allianceHelp.msg = "MESSAGE_MAINCITYVIEW_UPDATE_ALLIANCE_HELP_LIST"
	SoraDSendMessage(allianceHelp)
	gametop = allianceHelp
	allianceHelp.msg = "MESSAGE_GREEN_POINT_UPDATE"
	allianceHelp.type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_HELP
	SoraDSendMessage(allianceHelp)
end
function allianceNotifyHandle:notifyAddAllianceLog(notifyData)
	if not notifyData then
		return
	end
	local alog = notifyData.alog
	local allianceLog = gametop.playertop_:getModule("allianceLog")
	allianceLog:addLog(alog)
	gametop = allianceLog
	allianceLog.msg = "MESSAGE_ALLIACNE_LOG_ADD_SUCCESS"
	SoraDSendMessage(allianceLog)
end
function allianceNotifyHandle:nodifyAddAllianceHelpInfo(notifyData)
	if not notifyData then
		return
	end
	local helpData = notifyData.helpData
	local allianceHelp = gametop.playertop_:getModule("allianceHelp")
	allianceHelp:addHelp(helpData)
	gametop = allianceHelp
	allianceHelp.msg = "MESSAGE_ALLIACNE_GET_ALLIANCE_HELP_LIST_SUCCESS"
	SoraDSendMessage(allianceHelp)
	print("allianceNotifyHandle:nodifyAddAllianceHelpInfo111")
	gametop = "allianceNotifyHandle:nodifyAddAllianceHelpInfo111"
	;("allianceNotifyHandle:nodifyAddAllianceHelpInfo111").msg = "MESSAGE_MAINCITYVIEW_UPDATE_ALLIANCE_HELP_LIST"
	SoraDSendMessage("allianceNotifyHandle:nodifyAddAllianceHelpInfo111")
	gametop = "allianceNotifyHandle:nodifyAddAllianceHelpInfo111"
	;("allianceNotifyHandle:nodifyAddAllianceHelpInfo111").msg = "MESSAGE_GREEN_POINT_UPDATE"
	;("allianceNotifyHandle:nodifyAddAllianceHelpInfo111").type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_HELP
	SoraDSendMessage("allianceNotifyHandle:nodifyAddAllianceHelpInfo111")
end
function allianceNotifyHandle:notidyHelpOne(notifyData)
	if not notifyData then
		return
	end
	local cid = notifyData.cid
	local nickName = notifyData.nickName
	local helpData = notifyData.helpData
	local allianceHelp = gametop.playertop_:getModule("allianceHelp")
	if helpData then
		allianceHelp:updateHelp(helpData)
		local pid = gametop.playertop_:getPlayerID()
		local uid = helpData.uid
		if pid == uid then
			local reducetime = helpData.reduceTime
			local queuetype = helpData.queueTp
			local queueCtrl = gametop.playertop_:getModule("queueCtrl")
			queueCtrl:updateLeftTime(queuetype, -reducetime)
			gametop = queueCtrl
			queueCtrl.msg = "MESSAGE_ITEM_SPEED_UP_BACK"
			queueCtrl.qtype = tonumber(queuetype)
			SoraDSendMessage(queueCtrl)
			local msgNotice = include("msgNotice")
			local buildLogic = include("buildLogic")
			gametop = nil
			;(nil).sec = buildLogic.getAllianceHelpCountAndDescTime().reduceTime.total
			local descTime = i18n("common_text_666", nil)
			if helpData.helpTp == gAHelpType.CURE_ARMY then
				gametop = buildLogic.getAllianceHelpCountAndDescTime().reduceTime.total
				buildLogic.getAllianceHelpCountAndDescTime().reduceTime.total.name = nickName
				buildLogic.getAllianceHelpCountAndDescTime().reduceTime.total.time = descTime
				msgNotice.notice("notice_0064", buildLogic.getAllianceHelpCountAndDescTime().reduceTime.total)
			elseif helpData.helpTp == gAHelpType.BUILD_UPGRADE then
				local isShowWarLv, textLv = SoraDGetBuildWarLv(helpData.data.blv)
				if not isShowWarLv then
					gametop = nil
					;(nil).name = nickName
					;(nil).lv = textLv
					;(nil).buildID = helpData.data.bid
					;(nil).time = descTime
					msgNotice.notice("notice_0063", nil)
				else
					gametop = nil
					;(nil).name = nickName
					;(nil).lv = textLv
					;(nil).buildID = helpData.data.bid
					;(nil).time = descTime
					msgNotice.notice("common_text_4121", nil)
				end
			elseif helpData.helpTp == gAHelpType.TECH_RESEARCH then
				local technologyCtrl = SoraDGetCtrl("technologyCtrl")
				if technologyCtrl:isProcessTech(helpData.data.techid) then
					gametop = helpData.data.techid
					helpData.data.techid.name = nickName
					helpData.data.techid.techID = helpData.data.techid
					helpData.data.techid.time = descTime
					msgNotice.notice("Soldiers_armor_text_55", helpData.data.techid)
				else
					gametop = helpData.data.techid
					helpData.data.techid.name = nickName
					helpData.data.techid.techID = helpData.data.techid
					helpData.data.techid.time = descTime
					msgNotice.notice("notice_0065", helpData.data.techid)
				end
			elseif helpData.helpTp == gAHelpType.FORGING_EQUIP then
				gametop = "notice_0065"
				;("notice_0065").name = nickName
				;("notice_0065").equipID = helpData.data.equipid
				;("notice_0065").time = descTime
				msgNotice.notice("common_text_1269", "notice_0065")
			elseif helpData.helpTp == gAHelpType.EID_CELEBRATION_ACTIVITY then
				SoraDGetCtrl("activity_9001643_Ctrl"):reqHelpList()
			elseif helpData.helpTp == gAHelpType.GARDEN_BUILD_UPGRADE then
				local manorCityRead = include("manorCityRead")
				local blv = helpData.data.blv
				local bid = helpData.data.bid
				local buildName = manorCityRead.getBuildName(bid)
				gametop = nil
				;(nil).name = nickName
				;(nil).lv = blv
				;(nil).buildID = buildName
				;(nil).time = descTime
				local msgTip = i18n("notice_0063", nil)
				SoraDShowMsgTip(msgTip)
			end
		end
	end
	gametop = helpData.uid
	helpData.uid.msg = "MESSAGE_ALLIACNE_GET_ALLIANCE_HELP_LIST_SUCCESS"
	SoraDSendMessage(helpData.uid)
	gametop = helpData.uid
	helpData.uid.msg = "MESSAGE_MAINCITYVIEW_UPDATE_ALLIANCE_HELP_LIST"
	SoraDSendMessage(helpData.uid)
	gametop = helpData.uid
	helpData.uid.msg = "MESSAGE_GREEN_POINT_UPDATE"
	helpData.uid.type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_HELP
	SoraDSendMessage(helpData.uid)
end
function allianceNotifyHandle:notidyHelpAll(notifyData)
	if not notifyData then
		return
	end
	local allianceHelp = gametop.playertop_:getModule("allianceHelp")
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local cid = notifyData.cid
	local nickName = notifyData.nickName
	local helplist = notifyData.helplist
	if type(helplist) == "table" then
		for i, helpData in ipairs(helplist) do
			allianceHelp:updateHelp(helpData)
			local pid = gametop.playertop_:getPlayerID()
			local uid = helpData.uid
			if pid == uid then
				local reducetime = helpData.reduceTime
				local queuetype = helpData.queueTp
				queueCtrl:updateLeftTime(queuetype, -reducetime)
				gametop = queueCtrl
				queueCtrl.msg = "MESSAGE_ITEM_SPEED_UP_BACK"
				queueCtrl.qtype = tonumber(queuetype)
				SoraDSendMessage(queueCtrl)
				local msgNotice = include("msgNotice")
				local buildLogic = include("buildLogic")
				gametop = nil
				;(nil).sec = buildLogic.getAllianceHelpCountAndDescTime().reduceTime.total
				local descTime = i18n("common_text_666", nil)
				if helpData.helpTp == gAHelpType.CURE_ARMY then
					gametop = buildLogic.getAllianceHelpCountAndDescTime().reduceTime.total
					buildLogic.getAllianceHelpCountAndDescTime().reduceTime.total.name = nickName
					buildLogic.getAllianceHelpCountAndDescTime().reduceTime.total.time = descTime
					msgNotice.notice("notice_0064", buildLogic.getAllianceHelpCountAndDescTime().reduceTime.total)
				elseif helpData.helpTp == gAHelpType.BUILD_UPGRADE then
					local isShowWarLv, textLv = SoraDGetBuildWarLv(helpData.data.blv)
					if not isShowWarLv then
						gametop = nil
						;(nil).name = nickName
						;(nil).lv = textLv
						;(nil).buildID = helpData.data.bid
						;(nil).time = descTime
						msgNotice.notice("notice_0063", nil)
					else
						gametop = nil
						;(nil).name = nickName
						;(nil).lv = textLv
						;(nil).buildID = helpData.data.bid
						;(nil).time = descTime
						msgNotice.notice("common_text_4121", nil)
					end
				elseif helpData.helpTp == gAHelpType.TECH_RESEARCH then
					local technologyCtrl = SoraDGetCtrl("technologyCtrl")
					if technologyCtrl:isProcessTech(helpData.data.techid) then
						gametop = helpData.data.techid
						helpData.data.techid.name = nickName
						helpData.data.techid.techID = helpData.data.techid
						helpData.data.techid.time = descTime
						msgNotice.notice("Soldiers_armor_text_55", helpData.data.techid)
					else
						gametop = helpData.data.techid
						helpData.data.techid.name = nickName
						helpData.data.techid.techID = helpData.data.techid
						helpData.data.techid.time = descTime
						msgNotice.notice("notice_0065", helpData.data.techid)
					end
				elseif helpData.helpTp == gAHelpType.FORGING_EQUIP then
					gametop = "notice_0065"
					;("notice_0065").name = nickName
					;("notice_0065").equipID = helpData.data.equipid
					;("notice_0065").time = descTime
					msgNotice.notice("common_text_1269", "notice_0065")
				elseif helpData.helpTp == gAHelpType.GARDEN_BUILD_UPGRADE then
					local manorCityRead = include("manorCityRead")
					local blv = helpData.data.blv
					local bid = helpData.data.bid
					local buildName = manorCityRead.getBuildName(bid)
					gametop = nil
					;(nil).name = nickName
					;(nil).lv = blv
					;(nil).buildID = buildName
					;(nil).time = descTime
					local msgTip = i18n("notice_0063", nil)
					SoraDShowMsgTip(msgTip)
				end
			end
		end
	end
	gametop = ipairs(helplist)
	ipairs(helplist).msg = "MESSAGE_ALLIACNE_GET_ALLIANCE_HELP_LIST_SUCCESS"
	SoraDSendMessage(ipairs(helplist))
	gametop = ipairs(helplist)
	ipairs(helplist).msg = "MESSAGE_MAINCITYVIEW_UPDATE_ALLIANCE_HELP_LIST"
	SoraDSendMessage(ipairs(helplist))
	gametop = ipairs(helplist)
	ipairs(helplist).msg = "MESSAGE_GREEN_POINT_UPDATE"
	ipairs(helplist).type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_HELP
	SoraDSendMessage(ipairs(helplist))
end
function allianceNotifyHandle:allianceMsgNotify(notifyData)
	if not notifyData then
		return
	end
	local aid = notifyData.aid
	local data = notifyData.data
	if type(data.content) == "string" then
		_ENV = type(data.content)
		type(data.content).contentType = 0
		data.content, type(data.content).content = type(data.content), data.content
	end
	_ENV = data.content
	data.content.msg = "MESSAGE_ALLIANCE_NEW_ALLIANCE_MSG"
	data.content.allianceMsg = data
	SoraDSendMessage(data.content)
end
function allianceNotifyHandle:notifyAlliacneInfo(notifyData)
	if not notifyData then
		return
	end
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local allianceStore = gametop.playertop_:getModule("allianceStore")
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local allianceBuild = gametop.playertop_:getModule("allianceBuild")
	local eventName = notifyData.eventName
	local aid = notifyData.aid
	local cid = notifyData.cid
	local uid = notifyData.uid
	local allianceData = notifyData.alliance
	local leadername = notifyData.leadername
	local totalpower = notifyData.totalpower
	local leaderPos = notifyData.leaderPos
	local memberlist = notifyData.member
	local storeinfo = notifyData.storeinfo
	local itemshopinfo = notifyData.itemshopinfo
	local scienceinfo = notifyData.scienceinfo
	local somemember = notifyData.somemember
	local buildData = notifyData.buildData
	local feastInfo = notifyData.feastInfo
	if allianceData then
		local alliance = allianceMgr:updateAlliance(aid, allianceData)
		if alliance then
			alliance.leaderName = leadername
			alliance.totalBattle = totalpower
		end
	end
	if somemember then
		for k, onemember in pairs(somemember) do
			local member = include("member").new()
			member:setProperty("minfo", onemember.minfo)
			member:setProperty("uinfo", onemember.uinfo)
			memberMgr:addMember(member)
		end
	end
	if memberlist then
		for k, v in pairs(memberlist) do
			local member = include("member").new()
			member:setProperty("minfo", v.minfo)
			member:setProperty("uinfo", v.uinfo)
			memberMgr:addMember(member)
		end
	end
	if storeinfo then
		allianceStore:setItemList(storeinfo)
	end
	if itemshopinfo then
		allianceStore:setShopList(itemshopinfo)
	end
	if scienceinfo then
		local scienceRecommendList = notifyData.scienceRecommendList
		allianceScience:setScienceList(scienceinfo, scienceRecommendList)
	end
	if buildData then
		allianceBuild:initClientData(buildData)
	end
	local recycleBuildings = notifyData.recycleBuildings
	if recycleBuildings then
		local allianceTerritoryCtrl = SoraDGetCtrl("allianceTerritoryCtrl")
		allianceTerritoryCtrl:initRecycleBuildings(recycleBuildings)
	end
	local permissionData = notifyData.permissionData
	if permissionData then
		gModuleMgr.getObject("permissionCtrl"):initClientData(permissionData)
	end
	local territoryData = notifyData.territoryData
	if territoryData then
		local allianceTerritoryCtrl = gametop.playertop_:getModule("allianceTerritoryCtrl")
		allianceTerritoryCtrl:initializeLoginData(territoryData)
	end
	self:notifyAlliancePetInfoUpdate(notifyData)
	if leaderPos then
		allianceMgr:updateLeaderPos(leaderPos)
	end
	local pid = gametop.playertop_:getPlayerID()
	if gEventName.event_alliance_expel_member_success == eventName then
		self:expelMember(aid, uid, pid)
		gametop = self
		self.msg = "MESSAGE_ALLIACNE_MEMBER_UPDATE"
		SoraDSendMessage(self)
		gametop = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage(self)
	elseif gEventName.event_alliance_join_alliance_success == eventName then
		self:joinAlliance(aid, allianceData, leadername, totalpower, cid, pid)
		gametop = self
		self.msg = "MESSAGE_ALLIACNE_MEMBER_UPDATE"
		SoraDSendMessage(self)
	elseif gEventName.event_alliance_agree_application_success == eventName then
		self:agreeApplication(aid, allianceData, leadername, totalpower, uid, pid)
		gametop = self
		self.msg = "MESSAGE_ALLIACNE_MEMBER_UPDATE"
		SoraDSendMessage(self)
	elseif gEventName.event_alliance_agree_invitation_success == eventName then
		self:agreeInvitation(aid, allianceData, leadername, totalpower, cid, pid)
		gametop = self
		self.msg = "MESSAGE_ALLIACNE_MEMBER_UPDATE"
		SoraDSendMessage(self)
	elseif gEventName.event_alliance_apply_join_success == eventName then
		gametop = self
		self.msg = "MESSAGE_ALLIACNE_MEMBER_UPDATE"
		SoraDSendMessage(self)
	elseif gEventName.event_alliance_cancel_application_success == eventName then
		gametop = self
		self.msg = "MESSAGE_ALLIACNE_MEMBER_UPDATE"
		SoraDSendMessage(self)
	elseif gEventName.event_alliance_reject_application_success == eventName then
		gametop = self
		self.msg = "MESSAGE_ALLIACNE_MEMBER_UPDATE"
		SoraDSendMessage(self)
	elseif gEventName.event_alliance_quit_alliance_success == eventName then
		self:quitAlliance(aid, cid, pid)
		gametop = self
		self.msg = "MESSAGE_ALLIACNE_MEMBER_UPDATE"
		SoraDSendMessage(self)
		gametop = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage(self)
	elseif gEventName.event_alliance_promote_member_success == eventName then
		gametop = self
		self.msg = "MESSAGE_ALLIACNE_MEMBER_UPDATE"
		SoraDSendMessage(self)
		gametop = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage(self)
	elseif gEventName.event_alliance_demote_member_success == eventName then
		gametop = self
		self.msg = "MESSAGE_ALLIACNE_MEMBER_UPDATE"
		SoraDSendMessage(self)
		gametop = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage(self)
	elseif gEventName.event_alliance_demise == eventName then
		gametop = self
		self.msg = "MESSAGE_ALLIACNE_MEMBER_UPDATE"
		SoraDSendMessage(self)
		gametop = self
		self.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMALLIANCE_GIFT"
		SoraDSendMessage(self)
		gametop = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage(self)
	elseif gEventName.event_alliance_replace_leader == eventName then
		gametop = self
		self.msg = "MESSAGE_ALLIACNE_MEMBER_UPDATE"
		SoraDSendMessage(self)
		gametop = self
		self.msg = "MESSAGE_ALLIANCE_ACTIVE_OFFICE_UPDATE"
		SoraDSendMessage(self)
		gametop = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage(self)
	elseif gEventName.event_alliance_setting_success == eventName then
		gametop = self
		self.msg = "MESSAGE_ALLIACNE_SETTINGS_SUCCESS"
		SoraDSendMessage(self)
		gametop = self
		self.msg = "MESSAGE_ALLIACNE_CHANGE_FLAG_SUCCESS"
		SoraDSendMessage(self)
		self:allianceSettingSuccess()
	elseif gEventName.event_alliance_store_success == eventName then
		gametop = self
		self.msg = "MESSAGE_ALLIANCE_SCIENCE_POINT_UPDATE"
		SoraDSendMessage(self)
	elseif gEventName.event_alliance_science_success == eventName then
		gametop = aid
		aid.name = gEventName.event_alliance_science_success
		allianceScience:dispatchEvent(aid)
		self.queue = allianceScience:queryQueue(SCIENCE_RESEARCH_QUEUE)
		if self.queue then
			gametop = allianceScience
			allianceScience.msg = "MESSAGE_ALLIANCE_STUDY_BACK"
			allianceScience.sciid = self.queue.data.sciid
			SoraDSendMessage(allianceScience)
		end
		gametop = allianceScience
		allianceScience.msg = "MESSAGE_ALLIANCE_SCIENCE_POINT_UPDATE"
		SoraDSendMessage(allianceScience)
	elseif gEventName.event_alliance_science_research_complete == eventName then
		gametop = allianceScience
		allianceScience.msg = "MESSAGE_ALLIANCE_SCIENCE_DATA_BACK"
		SoraDSendMessage(allianceScience)
	elseif gEventName.event_alliance_update_territory == eventName then
		local allianceTerritoryCtrl = gametop.playertop_:getModule("allianceTerritoryCtrl")
		allianceTerritoryCtrl:updateData(notifyData)
	elseif gEventName.event_ramadan_feast_change == eventName then
		print("到这里咯")
		gametop = "到这里咯"
		;("到这里咯").msg = "MESSAGE_RAMADAN_FEAST_INFO"
		SoraDSendMessage("到这里咯")
	end
	gametop = allianceTerritoryCtrl
	allianceTerritoryCtrl.name = eventName
	self:dispatchEvent(allianceTerritoryCtrl)
end
function allianceNotifyHandle:joinAlliance(aid, allianceData, leadername, totalpower, cid, pid)
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if cid == pid then
		local alliance = allianceMgr:createAlliance(allianceData)
		alliance.leaderName = leadername
		alliance.totalBattle = totalpower
		alliance:setEscortInfo(allianceData.property.escortinfo)
		allianceMgr:setOwnAid(aid)
		SoraDRemoveAllPanelFromManager()
		if GLOBAL_GAME_ALLIANCE_MODE then
			gametop = nil
			;(nil).isNeedGuide = true
			;(nil).isShowMsg = true
			;(nil).allianceName = allianceData.property.name
			uiManager:show("allianceMainView", nil)
		else
			local panel = SoraDCreatePanel("allianceMainView")
			panel:show()
			gametop = allianceData.property.name
			allianceData.property.name.alliance = allianceData.property.name
			SoraDShowMsgBox(i18n("common_text_813", allianceData.property.name), i18n("common_text_054"), nil, function(type, target)
				if not GLOBAL_GAME_ALLIANCE_MODE then
					if tolua.isnull(panel) then
						return
					end
					panel:click2View()
				end
			end)
		end
		gametop = SoraDShowMsgBox
		SoraDShowMsgBox.msg = "MESSAGE_ALLIANCE_JOIN_SUCCESS"
		SoraDSendMessage(SoraDShowMsgBox)
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		kingdomMapCtrl:onJoinAlliance(aid)
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		lordInfoCtrl.lordInfo.abbr = alliance.property.abbr
		local allianceMsg = gametop.playertop_:getModule("allianceMsg")
		allianceMsg:reqAllianceMessageShieldList()
		local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
		allianceRelationCtrl:notifyMap(aid)
	end
end
function allianceNotifyHandle:quitAlliance(aid, cid, pid)
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if cid == pid then
		allianceMgr:removeAlliance(aid)
		allianceMgr:setOwnAid(nil)
		gametop = allianceMgr
		allianceMgr.msg = "MESSAGE_MAINCITYVIEW_UPDATE_ALLIANCE_HELP_LIST"
		SoraDSendMessage(allianceMgr)
		gametop = allianceMgr
		allianceMgr.msg = "MESSAGE_GREEN_POINT_UPDATE"
		allianceMgr.type = GREEN_POINT_NOTICE_TYPE.ALLIANCE
		SoraDSendMessage(allianceMgr)
		SoraDRemoveAllPanelFromManager()
		SoraDCloseLoading()
		gametop = allianceMgr
		allianceMgr.msg = "MESSAGE_ALLIANCE_QUIT_SUCCESS"
		SoraDSendMessage(allianceMgr)
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		kingdomMapCtrl:onQuitAlliance(aid)
		local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
		romeActivityCtrl:resetAllianceRomeActivityData()
		local allianceBWList = gametop.playertop_:getModule("allianceBWList")
		allianceBWList:resetData()
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		lordInfoCtrl.lordInfo.abbr = ""
		local allianceScience = gametop.playertop_:getModule("allianceScience")
		allianceScience:resetData()
		gametop = nil
		;(nil).name = gEventName.event_alliance_science_success
		allianceScience:dispatchEvent(nil)
		local allianceBuild = gametop.playertop_:getModule("allianceBuild")
		allianceBuild:demolishAllBuild()
		local escortIntelCtrl = gametop.playertop_:getModule("escortIntelCtrl")
		escortIntelCtrl:quitAlliance()
		gModuleMgr.getObject("permissionCtrl"):Logout()
		local allianceTerritoryCtrl = gametop.playertop_:getModule("allianceTerritoryCtrl")
		allianceTerritoryCtrl:destroyTerritory()
		local allianceTreasureCtrl = gametop.playertop_:getModule("allianceTreasureCtrl")
		allianceTreasureCtrl:resetData()
		gametop = allianceTreasureCtrl
		allianceTreasureCtrl.msg = "MESSAGE_MAINCITYVIEW_ADD_WAREHOUSE_GIFT_TOP_TIP"
		SoraDSendMessage(allianceTreasureCtrl)
		local allianceActiveCtrl = gametop.playertop_:getModule("allianceActiveCtrl")
		allianceActiveCtrl:resetData()
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local member = memberMgr:getOwnMember()
		if member then
			member:reset()
		end
		local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
		allianceRelationCtrl:notifyMap(aid)
		local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
		pyramidWarCtrl:resetAlliancePyramidWarData()
		local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
		alliancePetCtrl:resetData()
		local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
		pyramidWarCtrl:cleanGroupData()
		local allianceStrontholdCtrl = gametop.playertop_:getModule("allianceStrontholdCtrl")
		allianceStrontholdCtrl:resetData()
	else
		gametop = gametop.playertop_:getModule("romeActivityCtrl")
		gametop.playertop_:getModule("romeActivityCtrl").msg = "MESSAGE_ALLIACNE_MEMBER_UPDATE"
		gametop.playertop_:getModule("romeActivityCtrl").reload = true
		SoraDSendMessage((gametop.playertop_:getModule("romeActivityCtrl")))
		gametop = gametop.playertop_:getModule("romeActivityCtrl")
		gametop.playertop_:getModule("romeActivityCtrl").msg = "MESSAGE_ALLIACNE_MEMBER_SETTING_CLOSE"
		gametop.playertop_:getModule("romeActivityCtrl").uid = cid
		SoraDSendMessage((gametop.playertop_:getModule("romeActivityCtrl")))
	end
end
function allianceNotifyHandle:allianceSettingSuccess()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local alliance = allianceMgr:getAlliance()
	if alliance then
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		lordInfoCtrl.lordInfo.abbr = alliance.property.abbr
	end
end
function allianceNotifyHandle:expelMember(aid, uid, pid)
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if uid == pid then
		allianceMgr:removeAlliance(aid)
		allianceMgr:setOwnAid(nil)
		gametop = allianceMgr
		allianceMgr.msg = "MESSAGE_ALLIACNE_BE_KICKED"
		SoraDSendMessage(allianceMgr)
		SoraDShowMsgBox(i18n("common_text_814"), i18n("common_text_054"), nil, nil)
		gametop = i18n("common_text_814")
		i18n("common_text_814").msg = "MESSAGE_MAINCITYVIEW_UPDATE_ALLIANCE_HELP_LIST"
		SoraDSendMessage((i18n("common_text_814")))
		gametop = i18n("common_text_814")
		i18n("common_text_814").msg = "MESSAGE_GREEN_POINT_UPDATE"
		i18n("common_text_814").type = GREEN_POINT_NOTICE_TYPE.ALLIANCE
		SoraDSendMessage((i18n("common_text_814")))
		local allianceTreasureCtrl = gametop.playertop_:getModule("allianceTreasureCtrl")
		allianceTreasureCtrl:resetData()
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		kingdomMapCtrl:onQuitAlliance(aid)
		local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
		romeActivityCtrl:resetAllianceRomeActivityData()
		local allianceBWList = gametop.playertop_:getModule("allianceBWList")
		allianceBWList:resetData()
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		lordInfoCtrl.lordInfo.abbr = ""
		local allianceScience = gametop.playertop_:getModule("allianceScience")
		allianceScience:resetData()
		gametop = nil
		;(nil).name = gEventName.event_alliance_science_success
		allianceScience:dispatchEvent(nil)
		local allianceBuild = gametop.playertop_:getModule("allianceBuild")
		allianceBuild:demolishAllBuild()
		local escortIntelCtrl = gametop.playertop_:getModule("escortIntelCtrl")
		escortIntelCtrl:quitAlliance()
		gModuleMgr.getObject("permissionCtrl"):Logout()
		local allianceTerritoryCtrl = gametop.playertop_:getModule("allianceTerritoryCtrl")
		allianceTerritoryCtrl:destroyTerritory()
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local member = memberMgr:getOwnMember()
		if member then
			member:reset()
		end
		local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
		allianceRelationCtrl:notifyMap(aid)
		local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
		pyramidWarCtrl:resetAlliancePyramidWarData()
		local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
		alliancePetCtrl:resetData()
		local allianceStrontholdCtrl = gametop.playertop_:getModule("allianceStrontholdCtrl")
		allianceStrontholdCtrl:resetData()
	else
		gametop = gametop.playertop_:getModule("kingdomMapCtrl")
		gametop.playertop_:getModule("kingdomMapCtrl").msg = "MESSAGE_ALLIACNE_MEMBER_SETTING_CLOSE"
		gametop.playertop_:getModule("kingdomMapCtrl").uid = uid
		SoraDSendMessage((gametop.playertop_:getModule("kingdomMapCtrl")))
	end
end
function allianceNotifyHandle:agreeApplication(aid, allianceData, leadername, totalpower, uid, pid)
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if uid == pid then
		local alliance = allianceMgr:createAlliance(allianceData)
		alliance.leaderName = leadername
		alliance.totalBattle = totalpower
		allianceMgr:setOwnAid(aid)
		gametop = nil
		;(nil).alliance = allianceData.property.name
		SoraDShowMsgBox(i18n("common_text_813", nil), i18n("common_text_054"), nil, function(type, target)
			if type == MSGBOX_CALLBACK_YES then
				SoraDRemoveAllExceptPanelFromManager(target)
				if GLOBAL_GAME_ALLIANCE_MODE then
					_ENV = nil
					;(nil).isNeedGuide = true
					uiManager:show("allianceMainView", nil)
				else
					local panel = SoraDCreatePanel("allianceMainView")
					panel:show()
					panel:click2View()
				end
			end
		end)
		alliance:setEscortInfo(allianceData.property.escortinfo)
		gametop = alliance
		alliance.msg = "MESSAGE_ALLIANCE_JOIN_SUCCESS"
		SoraDSendMessage(alliance)
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		kingdomMapCtrl:onJoinAlliance(aid)
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		lordInfoCtrl.lordInfo.abbr = alliance.property.abbr
		local allianceMsg = gametop.playertop_:getModule("allianceMsg")
		allianceMsg:reqAllianceMessageShieldList()
		local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
		allianceRelationCtrl:notifyMap(aid)
	end
end
function allianceNotifyHandle:agreeInvitation(aid, allianceData, leadername, totalpower, cid, pid)
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if cid == pid then
		local alliance = allianceMgr:createAlliance(allianceData)
		alliance.leaderName = leadername
		alliance.totalBattle = totalpower
		allianceMgr:setOwnAid(aid)
		SoraDRemoveAllPanelFromManager()
		if GLOBAL_GAME_ALLIANCE_MODE then
			gametop = nil
			;(nil).isNeedGuide = true
			;(nil).isShowMsg = true
			;(nil).allianceName = allianceData.property.name
			uiManager:show("allianceMainView", nil)
		else
			local panel = SoraDCreatePanel("allianceMainView")
			panel:show()
			gametop = allianceData.property.name
			allianceData.property.name.alliance = allianceData.property.name
			SoraDShowMsgBox(i18n("common_text_813", allianceData.property.name), i18n("common_text_054"), nil, function(type, target)
				if not GLOBAL_GAME_ALLIANCE_MODE then
					if tolua.isnull(panel) then
						return
					end
					panel:click2View()
				end
			end)
		end
		alliance:setEscortInfo(allianceData.property.escortinfo)
		gametop = alliance
		alliance.msg = "MESSAGE_ALLIANCE_JOIN_SUCCESS"
		SoraDSendMessage(alliance)
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		kingdomMapCtrl:onJoinAlliance(aid)
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		lordInfoCtrl.lordInfo.abbr = alliance.property.abbr
		local allianceMsg = gametop.playertop_:getModule("allianceMsg")
		allianceMsg:reqAllianceMessageShieldList()
		local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
		allianceRelationCtrl:notifyMap(aid)
	end
end
function allianceNotifyHandle:handleAllianceRomeActivityData(notifyData)
	local retdata = notifyData.retdata
	if retdata then
		local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
		local allianceActivityData = retdata.allianceActivityData
		romeActivityCtrl:initAllianceActivityData(allianceActivityData)
		local memRomeActivityFlag = retdata.memRomeActivityFlag
		romeActivityCtrl:initMemFlag(memRomeActivityFlag)
		local atkPosInfo = retdata.atkPosInfo
		romeActivityCtrl:setRomeActivityAtkPos(atkPosInfo)
		gametop = romeActivityCtrl
		romeActivityCtrl.msg = "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_EVENTREFRESH"
		SoraDSendMessage(romeActivityCtrl)
		gametop = romeActivityCtrl
		romeActivityCtrl.msg = "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_ALLIANCEATTACK"
		SoraDSendMessage(romeActivityCtrl)
	end
end
function allianceNotifyHandle:handleAllianceBWIDListAddOrDel(notifyData)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local allianceBWList = gametop.playertop_:getModule("allianceBWList")
	local aid = notifyData.aid
	local score = notifyData.score
	local bwListType = notifyData.bwListType
	local optype = notifyData.optype
	if aid and score and bwListType and optype then
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local alliance = allianceMgr:getAlliance()
		if alliance then
			alliance:setProperty("bonus", score)
		end
		if optype == gAllianceBWListOPType.ADD then
			allianceBWList:addBWID(aid, bwListType)
			if bwListType == gAllianceBWListType.BLACK then
				kingdomMapCtrl:onAddBlackList(aid)
			else
				kingdomMapCtrl:onAddWhiteList(aid)
			end
			gametop = kingdomMapCtrl
			kingdomMapCtrl.msg = "MESSAGE_ALLIACNE_ADD_BWLIST_SUCCESS"
			kingdomMapCtrl.aid = aid
			kingdomMapCtrl.bwtype = bwListType
			SoraDSendMessage(kingdomMapCtrl)
		else
			allianceBWList:delBWID(aid, bwListType)
			if bwListType == gAllianceBWListType.BLACK then
				kingdomMapCtrl:onDelBlackList(aid)
			else
				kingdomMapCtrl:onDelWhiteList(aid)
			end
			gametop = kingdomMapCtrl
			kingdomMapCtrl.msg = "MESSAGE_ALLIACNE_DEL_BWLIST_SUCCESS"
			kingdomMapCtrl.aid = aid
			kingdomMapCtrl.bwtype = bwListType
			SoraDSendMessage(kingdomMapCtrl)
		end
	end
end
function allianceNotifyHandle:publishAllianceBWIDListUpdate(notifyData)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local allianceBWList = gametop.playertop_:getModule("allianceBWList")
	local bwIDList = notifyData.bwIDList
	if bwIDList then
		allianceBWList:setBWIDList(bwIDList)
	end
end
function allianceNotifyHandle:publishAllianceMsgShieldListOperate(notifyData)
	local optype = notifyData.optype
	local targetaid = notifyData.targetaid
	local targetuid = notifyData.targetuid
	local allianceMsg = gametop.playertop_:getModule("allianceMsg")
	if optype == gAShieldListOperate.add then
		if targetaid then
			allianceMsg:addShieldAlliance(targetaid)
		end
		if targetuid then
			allianceMsg:addShieldLord(targetuid)
		end
	elseif optype == gAShieldListOperate.del then
		if targetaid then
			allianceMsg:delShieldAlliance(targetaid)
		end
		if targetuid then
			allianceMsg:delShieldLord(targetuid)
		end
	end
end
function allianceNotifyHandle:publishAllianceBuilding(notifyData)
	local allianceBuild = gametop.playertop_:getModule("allianceBuild")
	local bid = notifyData.property.bid
	local iid = notifyData.property.iid
	local allianceResPointltCtrl = include("allianceResPointltCtrl")
	if allianceResPointltCtrl.isResPoint(bid) then
		local ret, building = allianceBuild:getBuilding(bid, iid)
		if gErrDef.Err_None ~= ret then
			return ret
		end
		local optype = notifyData.optype
		if optype == "set" then
			local property = notifyData.property
			building:syncServiceData(property)
			local startTime, remainTime = allianceBuild:getTimeOfResPoint(bid, iid)
			local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
			kingdomMapCtrl:onSuperResBuildTimeChange(bid, iid, startTime, remainTime)
		elseif optype == "update" then
			local oldCaptainUID = building:getCaptainUID()
			local property = notifyData.property
			building:syncServiceData(property)
			local newCaptainUID = building:getCaptainUID()
			local startTime, remainTime = allianceBuild:getTimeOfResPoint(bid, iid)
			local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
			kingdomMapCtrl:onSuperResBuildTimeChange(bid, iid, startTime, remainTime)
			if oldCaptainUID ~= newCaptainUID then
				gametop = kingdomMapCtrl
				kingdomMapCtrl.msg = "MESSAGE_ALLIANCE_BUILD_INFOLIST_REFRESH"
				SoraDSendMessage(kingdomMapCtrl)
			end
		elseif optype == "demolish" then
			local property = notifyData.property
			building:syncServiceData(property)
			local startTime, remainTime = allianceBuild:getTimeOfResPoint(bid, iid)
			local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
			kingdomMapCtrl:onSuperResBuildTimeChange(bid, iid, startTime, remainTime)
			gametop = kingdomMapCtrl
			gametop, kingdomMapCtrl.msg = bid, "MESSAGE_ALLIANCE_BUILD_INFOLIST_DEMOLISH"
			bid.bid = bid
			kingdomMapCtrl.data, bid.iid = bid, iid
			SoraDSendMessage(kingdomMapCtrl)
		end
		gametop = allianceBuild:getTimeOfResPoint(bid, iid)
		allianceBuild:getTimeOfResPoint(bid, iid).msg = "MESSAGE_ALLIANCE_RES_MINE_PROFIT_BACK"
		SoraDSendMessage(allianceBuild:getTimeOfResPoint(bid, iid))
		gametop = allianceBuild:getTimeOfResPoint(bid, iid)
		allianceBuild:getTimeOfResPoint(bid, iid).msg = "MESSAGE_GREEN_POINT_UPDATE"
		allianceBuild:getTimeOfResPoint(bid, iid).justPoint = true
		allianceBuild:getTimeOfResPoint(bid, iid).type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_BUILD
		SoraDSendMessage(allianceBuild:getTimeOfResPoint(bid, iid))
	end
end
function allianceNotifyHandle:publishAllianceLeaderChange(notifyData)
	local uid = notifyData.uid
	local pos = notifyData.pos
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	allianceMgr:updateLeaderPos(pos)
end
function allianceNotifyHandle:publishAllianceModifyPermission(notifyData)
	local modifyList = notifyData.modifyList
	local _ENV, temp
	if "table" == type(modifyList) and next(modifyList) then
		for i, v in ipairs(modifyList) do
			local permission = v.permission
			local rank = v.rank
			local status = v.status
			if not temp[permission] then
				_ENV = temp[permission]
			end
			temp[permission] = temp[permission]
			local status = gStatus.YES == status
			temp[permission][rank] = status
		end
		modifyList = temp
		local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
		permissionCtrl:modifyPermission(modifyList)
	end
end
function allianceNotifyHandle:publishUpdateEscortAdd(notifyData)
	if notifyData then
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local escortinfo = notifyData.escortinfo
		local alliance = allianceMgr:getAlliance()
		if alliance then
			alliance:setEscortInfo(escortinfo)
		end
		gametop = alliance
		alliance.msg = "MESSAGE_SERVER_ESCORT_ESCORT_CAR_ADD_VALUE_UPDATE"
		SoraDSendMessage(alliance)
	end
end
function allianceNotifyHandle:publishUpdateBestAlliance(notifyData)
	if notifyData then
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local alliance = allianceMgr:getAlliance()
		local bestAllianceInfo = notifyData.bestAllianceInfo
		if alliance and bestAllianceInfo then
			alliance:setBestAllianceInfo(bestAllianceInfo)
		end
	end
end
function allianceNotifyHandle:publishUpdateRamadanBestAlliance(notifyData)
	if notifyData then
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local alliance = allianceMgr:getAlliance()
		local ramadanMobilizeTopAlliance = notifyData.ramadanMobilizeTopAlliance
		if alliance and ramadanMobilizeTopAlliance then
			alliance:setBestRamadanMobiAllianceInfo(ramadanMobilizeTopAlliance)
		end
	end
end
function allianceNotifyHandle:publishAllianceRelationChange(notifyData)
	local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
	allianceRelationCtrl:onPublishMsg(notifyData)
end
function allianceNotifyHandle:publishUpdateKingPacksInfo(notifyData)
	if notifyData then
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local alliance = allianceMgr:getAlliance()
		local kingPacksInfo = notifyData.kingPacksInfo
		if alliance and kingPacksInfo then
			alliance:setAlliancePackInfo(kingPacksInfo)
		end
	end
end
function allianceNotifyHandle:handleAlliancePyramidWarData(notifyData)
	local retdata = notifyData.retdata
	if retdata then
		local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
		local alliancePyramidWarData = retdata.alliancePyramidWarData
		pyramidWarCtrl:initAlliancePyramidWarData(alliancePyramidWarData)
		gametop = pyramidWarCtrl
		pyramidWarCtrl.msg = "MESSAGE_SERVER_PYRAMIDBATTLE_MAINSTATECHANGE"
		SoraDSendMessage(pyramidWarCtrl)
		gametop = pyramidWarCtrl
		pyramidWarCtrl.msg = "MESSAGE_SERVER_PYRAMIDBATTLE_MAINUIICONCHECK"
		SoraDSendMessage(pyramidWarCtrl)
		gametop = pyramidWarCtrl
		_ENV, pyramidWarCtrl.msg = alliancePyramidWarData, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		pyramidWarCtrl.activityID, alliancePyramidWarData[1] = alliancePyramidWarData, _G.gActivityCenterUIEnum.PYRAMID_BATTLE
		SoraDSendMessage(pyramidWarCtrl)
	end
end
function allianceNotifyHandle:notifyPyramidWarAppoint(notifyData)
	local uidlist = notifyData.uidlist
	local tp = notifyData.tp
	local pid = gametop.playertop_:getPlayerID()
	for _, uid in ipairs(uidlist) do
		if uid == pid then
			print("allianceNotifyHandle:notifyPyramidWarAppoint", uid, tp)
			local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
			if tp == 1 then
				pyramidWarCtrl.memberState = gMemberState.APPOINT_ED
			elseif tp == 2 then
				pyramidWarCtrl.memberState = gMemberState.NO_APPOINT
			end
			gametop = "pyramidWarCtrl"
			;("pyramidWarCtrl").msg = "MESSAGE_SERVER_PYRAMIDBATTLE_MAINUIICONCHECK"
			SoraDSendMessage("pyramidWarCtrl")
		end
	end
end
function allianceNotifyHandle:notifyAllianceTreasureInfoAdd(notifyData)
	local digInfo = notifyData.digInfo
	if digInfo and next(digInfo) then
		local allianceTreasureCtrl = gametop.playertop_:getModule("allianceTreasureCtrl")
		allianceTreasureCtrl:addHelpListData(digInfo)
	end
end
function allianceNotifyHandle:notifyAllianceTreasureInfoReduce(notifyData)
	local digInfo = notifyData.digInfo
	if digInfo and next(digInfo) then
		local allianceTreasureCtrl = gametop.playertop_:getModule("allianceTreasureCtrl")
		allianceTreasureCtrl:delHelpListData(digInfo)
	end
end
function allianceNotifyHandle:notifyAllianceScienceAddRecommend(notifyData)
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local sciid = notifyData.data.sciid
	allianceScience:addRecommendSci(sciid)
end
function allianceNotifyHandle:notifyAllianceScienceRemoveRecommend(notifyData)
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local sciid = notifyData.data.sciid
	allianceScience:removeRecommendSci(sciid)
end
function allianceNotifyHandle:notifyAlliancePetInfoUpdate(notifyData)
	local beastData = notifyData.beastData
	if beastData and next(beastData) then
		local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
		alliancePetCtrl:initClientData(beastData)
	end
end
function allianceNotifyHandle:notifyAllianceOfficialAppoint(notifyData)
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	allianceMgr:setOfficialApplyList(notifyData.alliance.officialApplyList)
	allianceMgr:setOfficialList(notifyData.alliance.official)
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	memberMgr:updateMemberInfo(notifyData.somemember)
	gametop = memberMgr
	memberMgr.msg = "MESSAGE_ALLIANCE_OFFICIAL_APPOINT_BACK"
	SoraDSendMessage(memberMgr)
	gametop = memberMgr
	memberMgr.msg = "MESSAGE_ALLIANCE_ACTIVE_OFFICE_UPDATE"
	SoraDSendMessage(memberMgr)
	gametop = memberMgr
	memberMgr.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	SoraDSendMessage(memberMgr)
end
function allianceNotifyHandle:notifyAllianceOfficialFire(notifyData)
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	allianceMgr:setOfficialList(notifyData.alliance.official)
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	memberMgr:updateMemberInfo(notifyData.somemember)
	gametop = memberMgr
	memberMgr.msg = "MESSAGE_ALLIANCE_OFFICIAL_FIRE_BACK"
	SoraDSendMessage(memberMgr)
	gametop = memberMgr
	memberMgr.msg = "MESSAGE_ALLIANCE_ACTIVE_OFFICE_UPDATE"
	SoraDSendMessage(memberMgr)
	gametop = memberMgr
	memberMgr.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	SoraDSendMessage(memberMgr)
end
function allianceNotifyHandle:notifyAllianceOfficialApply(notifyData)
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	allianceMgr:setOfficialApplyList(notifyData.alliance.officialApplyList)
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	memberMgr:updateMemberInfo(notifyData.somemember)
	gametop = memberMgr
	memberMgr.msg = "MESSAGE_ALLIANCE_OFFICIAL_APPLY_BACK"
	SoraDSendMessage(memberMgr)
end
return allianceNotifyHandle
