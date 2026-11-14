local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local allianceDesRead = include("allianceDesRead")
local allianceCtrl = class("allianceCtrl", gameModule)
local _ENV, REQ = "allianceCtrl", "allianceCtrl"
local _ENV, RSP = gameModule, gameModule
function allianceCtrl:ctor(properties)
	allianceCtrl.super.ctor(self, properties)
end
function allianceCtrl:EnterGame()
	allianceCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_INIT_ALLIANCEDATA, handler(self, RSP.initDataRsp))
end
function allianceCtrl:resetData()
	gModuleMgr.getObject("permissionCtrl"):Logout()
	self:resetAllianceInvitePopInfo()
end
function allianceCtrl:Logout()
	allianceCtrl.super.Logout(self)
	self:resetData()
end
function REQ.reqInitData(...)
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_INIT_ALLIANCEDATA, nil, ...)
end
function REQ.req4AllianceInviteData(...)
	serverproxy:Request(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_GET_RECOMMENT_ALLIANCE, nil, ...)
end
function RSP:initDataRsp(content)
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	if content.err == gErrDef.Err_None then
		local data = content.data.retdata
		local ownermemberinfo = data.ownermemberinfo
		if ownermemberinfo then
			local member = include("member").new()
			member:setProperty("minfo", ownermemberinfo.minfo)
			member:setProperty("uinfo", ownermemberinfo.uinfo)
			memberMgr:addMember(member)
		else
			local allianceInfo = data.allianceInfo
			local allianceMgr = gametop.playertop_:getModule("allianceMgr")
			local alliance = allianceMgr:createAlliance(allianceInfo)
			local aid = alliance:getProperty("aid")
			allianceMgr:setOwnAid(aid)
			local leaderName = data.leaderName
			alliance.leaderName = leaderName
			local totalBattle = data.totalBattle
			alliance.totalBattle = totalBattle
			local memberinfo = data.memberinfo
			local member = include("member").new()
			member:setProperty("minfo", memberinfo.minfo)
			member:setProperty("uinfo", memberinfo.uinfo)
			memberMgr:addMember(member)
			local helplist = data.helplist
			local allianceHelp = gametop.playertop_:getModule("allianceHelp")
			allianceHelp:setHelpList(helplist)
			local sciencelist = data.sciencelist
			local allianceScience = gametop.playertop_:getModule("allianceScience")
			allianceScience:setScienceList(sciencelist)
			local donateCD = member:getProperty("donateCD")
			local starttime = donateCD.starttime
			local totaltime = donateCD.totaltime
			if starttime and totaltime then
				local nowtime = serviceFunctions.systemTime()
				local lasttime = nowtime - starttime
				local lefttime = totaltime - lasttime
				if lefttime <= 0 then
					lefttime = 0
				end
				allianceScience:addQueue(SCIENCE_DONATE_QUEUE, starttime, totaltime, lefttime)
			end
			local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
			allianceRelationCtrl:setRelationMap(data.relationMap)
			allianceRelationCtrl:setAllyInviteNum(data.allyInviteNum)
			gametop = allianceRelationCtrl
			allianceRelationCtrl.msg = "MESSAGE_GREEN_POINT_UPDATE"
			SoraDSendMessage(allianceRelationCtrl)
		end
	else
		print("未加入联盟")
	end
end
function RSP:updateDataRsp(event)
	local allianceNotifyHandle = gametop.playertop_:getModule("allianceNotifyHandle")
	allianceNotifyHandle:notifyHandle(event)
end
function RSP:allianceInviteCb(content)
	local loopData = content.data
	for i, notifyMsg in ipairs(loopData) do
		local revcDataType = notifyMsg.type
		local revcData = notifyMsg.data
		if revcData and next(revcData) and "recommend" == revcDataType then
			self.allianceInvitePopInfo = revcData
			_ENV = revcData
			revcData.msg = "MESSAGE_ALLIANCE_MAINUIINVITE_REFRESH"
			SoraDSendMessage(revcData)
		end
	end
end
function allianceCtrl:req4AllianceInviteData(...)
	REQ.req4AllianceInviteData()
end
function allianceCtrl:getAllianceInvitePopInfo(...)
	return self.allianceInvitePopInfo
end
function allianceCtrl:resetAllianceInvitePopInfo(...)
	self.allianceInvitePopInfo, _UPVALUE0_ = nil, nil
end
function allianceCtrl:checkAllianceName(name)
	if "string" == type(name) then
		return false
	end
	name = string.trim(name)
	local len = string.utf8len(name)
	if len < ALLIANCE_NAME_MIN or len > ALLIANCE_NAME_MAX then
		return false
	end
	local ret = string.match(name, "%W")
	if ret then
		return false
	end
	return true
end
function allianceCtrl:checkAllianceSign(sign)
	if "string" == type(sign) then
		return false
	end
	sign = string.trim(sign)
	local len = string.utf8len(name)
	if len ~= 3 then
		return false
	end
	local ret = string.match(sign, "%W")
	if ret then
		return false
	end
	return true
end
function allianceCtrl:initClientData(data)
	dump(data, "allianceCtrl:initClientData====", 10)
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownermemberinfo = data.ownermemberinfo
	if ownermemberinfo then
		local member = include("member").new()
		member:setProperty("minfo", ownermemberinfo.minfo)
		member:setProperty("uinfo", ownermemberinfo.uinfo)
		memberMgr:addMember(member)
	else
		local allianceInfo = data.allianceInfo
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local alliance = allianceMgr:createAlliance(allianceInfo)
		local aid = alliance:getProperty("aid")
		allianceMgr:setOwnAid(aid)
		local leaderName = data.leaderName
		alliance.leaderName = leaderName
		local leaderPos = data.leaderPos
		allianceMgr:updateLeaderPos(leaderPos)
		local totalBattle = data.totalBattle
		alliance.totalBattle = totalBattle
		local memberinfo = data.memberinfo
		local member = include("member").new()
		member:setProperty("minfo", memberinfo.minfo)
		member:setProperty("uinfo", memberinfo.uinfo)
		memberMgr:addMember(member)
		local helplist = data.helplist
		local allianceHelp = gametop.playertop_:getModule("allianceHelp")
		allianceHelp:setHelpList(helplist)
		local sciencelist = data.sciencelist
		local allianceScience = gametop.playertop_:getModule("allianceScience")
		local scienceRecommendList = data.scienceRecommendList
		allianceScience:setScienceList(sciencelist, scienceRecommendList)
		local allianceBWList = gametop.playertop_:getModule("allianceBWList")
		allianceBWList:getAllianceBWIDList()
		local donateCD = member:getProperty("donateCD")
		local starttime = donateCD.starttime
		local totaltime = donateCD.totaltime
		if starttime and totaltime then
			local nowtime = serviceFunctions.systemTime()
			local lasttime = nowtime - starttime
			local lefttime = totaltime - lasttime
			if lefttime <= 0 then
				lefttime = 0
			end
			allianceScience:addQueue(SCIENCE_DONATE_QUEUE, starttime, totaltime, lefttime)
		end
		local buildData = data.buildData
		if buildData then
			local allianceBuild = gametop.playertop_:getModule("allianceBuild")
			allianceBuild:initClientData(buildData)
		end
		local recycleBuildings = data.recycleBuildings
		if recycleBuildings then
			local allianceTerritoryCtrl = SoraDGetCtrl("allianceTerritoryCtrl")
			allianceTerritoryCtrl:initRecycleBuildings(recycleBuildings)
		end
		local permissionData = data.permissionData
		if permissionData then
			local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
			permissionCtrl:initClientData(permissionData)
		end
		alliance:setEscortInfo(allianceInfo.property.escortinfo)
		alliance:setBestAllianceInfo(allianceInfo.property.bestAllianceInfo)
		local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
		allianceRelationCtrl:setRelationMap(data.relationMap)
		allianceRelationCtrl:setAllyInviteNum(data.allyInviteNum)
		local territoryData = data.territoryData
		local allianceTerritoryCtrl = gametop.playertop_:getModule("allianceTerritoryCtrl")
		allianceTerritoryCtrl:initializeLoginData(territoryData)
		_ENV = allianceTerritoryCtrl
		allianceTerritoryCtrl.msg = "MESSAGE_GREEN_POINT_UPDATE"
		SoraDSendMessage(allianceTerritoryCtrl)
		allianceMgr:setOfficialList(allianceInfo.official)
		allianceMgr:setOfficialApplyList(allianceInfo.officialApplyList)
		if data.aBeastStore then
			local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
			alliancePetCtrl:initClientData(data.aBeastStore)
		end
		allianceHelp:reqAllianceHelpData()
		local allianceMsg = gametop.playertop_:getModule("allianceMsg")
		allianceMsg:reqAllianceMessageShieldList()
		local allianceStrontholdCtrl = gametop.playertop_:getModule("allianceStrontholdCtrl")
		allianceStrontholdCtrl:reqAllianceStrontholdList()
	end
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.ALLIANCE, handler(self, RSP.updateDataRsp))
	notifyCtrl:register(gNotifyID.ALLIANCE_RECOMMEND, handler(self, RSP.allianceInviteCb))
end
function allianceCtrl:getBuffEffect(effectType)
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ret, official = memberMgr:isOwnOfficial()
	if official ~= nil and official ~= gAllianceOfficial.NONE then
		local attribute, attributeVal = allianceDesRead.getOfficialAttribute(official)
		if attributeVal ~= nil then
			for i = 1, #attributeVal, 2 do
				if attributeVal[i] == effectType then
					return attributeVal[i + 1]
				end
			end
		end
	end
end
function allianceCtrl:getAllianceWarListRallyMgr(indexID, warHallData)
	local allianceWarListRallyMgr = include("allianceWarListRallyMgr")
	allianceWarListRallyMgr:initData(indexID, warHallData)
	return allianceWarListRallyMgr
end
return allianceCtrl
