local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local allianceQuery = class("allianceQuery", gameModule)
local _ENV, RSP = "allianceQuery", "allianceQuery"
function allianceQuery:ctor(properties)
	allianceQuery.super.ctor(self, properties)
	self:resetData()
end
function allianceQuery:EnterGame()
	allianceQuery.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_INFO_BY_ID, handler(self, RSP.queryAllianceRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_LIST, handler(self, RSP.queryAllianceListRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_INFO_BY_NAME, handler(self, RSP.queryAllianceByNameRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_MEMBER_INFO, handler(self, RSP.queryMemberInfoRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_MEMBER_LIST, handler(self, RSP.queryMemberListRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_APPLY_LIST, handler(self, RSP.queryApplyListRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_INVITE_LIST, handler(self, RSP.queryInviteListRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_CHECK_NAME, handler(self, RSP.checkAllianceNameRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_CHECK_ABBR, handler(self, RSP.checkAllianceAbbrRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_SEARCH_PLAYER_NAME, handler(self, RSP.queryLordInfoListRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_LIST_BY_CONDITION, handler(self, RSP.queryAllianceListByConditionRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_KINGALLIANCE_INFO, handler(self, RSP.queryKingAllianceRsp))
	msgCtrl.register(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_INVITE_LIST, handler(self, RSP.queryAllianceInviteListRsp))
	msgCtrl.register(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_INFO, handler(self, RSP.queryAllianceInfoRsp))
	msgCtrl.register(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_SEARCH_ALLIANCE_ALL_WORLD, handler(self, RSP.queryAllianceInfoAllWorldRsp))
end
function allianceQuery:Logout()
	self:resetData()
end
function allianceQuery:resetData()
	self.queryLordInfoList, _UPVALUE0_, self.queryaidlist, _UPVALUE0_, self.userInfoList, _UPVALUE0_, self.uidlist, _UPVALUE0_, self.allianceIDList, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
end
function allianceQuery:getAllianceInviteList(index)
	index = index or 1
	local _ENV, tableAllianceInviteList
	local haveMore = index + 9 < #self.uidlist
	for i = index, index + 9 do
		local uid = self.uidlist[i]
		local userInfo = self.userInfoList[tostring(uid)]
		if uid and userInfo then
			userInfo.uid = uid
			table.insert(tableAllianceInviteList, userInfo)
		else
			break
		end
	end
	return tableAllianceInviteList, haveMore
end
function allianceQuery:getAllianceList(index)
	index = index or 1
	local gametop, tableAllianceList
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local haveMore = index + 9 < #self.allianceIDList
	for i = index, index + 9 do
		local allianceData = allianceMgr:getAlliance(self.allianceIDList[i])
		if allianceData and self.allianceIDList[i] then
			table.insert(tableAllianceList, allianceData)
		else
			break
		end
	end
	return tableAllianceList, haveMore
end
function allianceQuery:getQueryAllianceResult()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local selflanguage = gLanguage.ARAB
	local aidlist = self.queryaidlist
	local gametop, samelan
	local gametop, alllan
	local gametop, otherlan
	for k, aid in pairs(aidlist) do
		local alliance = allianceMgr:getAlliance(aid)
		local language = alliance:getProperty("language")
		if language == selflanguage then
			table.insert(samelan, alliance)
		elseif language == gLanguage.ALL then
			table.insert(alllan, alliance)
		else
			table.insert(otherlan, alliance)
		end
	end
	table.sort(samelan, function(l, r)
		if l and r then
			return l:getProperty("bonus") > r:getProperty("bonus")
		else
			return false
		end
	end)
	local gametop, ret = table.sort, table.sort
	for k, alliance in pairs(samelan) do
		table.insert(ret, alliance)
	end
	for k, alliance in pairs(alllan) do
		table.insert(ret, alliance)
	end
	for k, alliance in pairs(otherlan) do
		table.insert(ret, alliance)
	end
	return ret
end
function allianceQuery:reqAllianceByID(idtable, ...)
	if idtable then
		local aid = idtable.aid
		local uid = idtable.uid
		local kid = idtable.kid
		if aid then
			serverproxy = nil
			;(nil).aid = aid
			;(nil).kid = kid
			serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_INFO_BY_ID, nil, ...)
		elseif uid then
			serverproxy = nil
			;(nil).uid = uid
			;(nil).kid = kid
			serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_INFO_BY_ID, nil, ...)
		end
	end
end
function allianceQuery:reqAllianceListByIndex(languageType, index)
	local _ENV, aidlist
	for i = index, index + 9 do
		local aid = self.allianceIDList[i]
		if aid ~= nil then
			table.insert(aidlist, aid)
		else
			break
		end
	end
	if 0 < #aidlist then
		self:reqAllianceList(languageType, aidlist)
	end
end
function allianceQuery:reqAllianceList(languageType, aidlist, ...)
	print("allianceQuery:reqAllianceList")
	if not aidlist then
		self.allianceIDList, _ENV = print, print
	end
	_ENV = nil
	;(nil).languageType = languageType
	;(nil).aidlist = aidlist
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_LIST, nil, ...)
end
function allianceQuery:reqAllianceListByIndexAndCondition(index)
	local _ENV, aidlist
	for i = index, index + 9 do
		local aid = self.allianceIDList[i]
		if aid ~= nil then
			table.insert(aidlist, aid)
		else
			break
		end
	end
	if 0 < #aidlist then
		self:reqAllianceListByCondition(nil, aidlist)
	end
end
function allianceQuery:reqAllianceListByCondition(languageTable, aidlist, fullType, allianceRequire)
	if not aidlist then
		self.allianceIDList, serverproxy = nil, nil
	end
	local serverproxy, data
	data.languageTable = languageTable
	data.aidlist = aidlist
	data.fullType = fullType
	data.allianceRequire = allianceRequire
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_LIST_BY_CONDITION, data)
end
function allianceQuery:reqAllianceByName(keyname, ...)
	print("allianceQuery:reqAllianceByName")
	self.queryaidlist, _ENV = print, print
	_ENV = nil
	;(nil).keyname = keyname
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_INFO_BY_NAME, nil, ...)
end
function allianceQuery:reqMemberInfo(uid, ...)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_MEMBER_INFO, nil, ...)
end
function allianceQuery:reqMemberList(aid, ...)
	serverproxy = nil
	;(nil).aid = aid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_MEMBER_LIST, nil, ...)
end
function allianceQuery:reqApplyList(aid, ...)
	serverproxy = nil
	;(nil).aid = aid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_APPLY_LIST, nil, ...)
end
function allianceQuery:reqKingAlliance()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_KINGALLIANCE_INFO, nil)
end
function allianceQuery:removeMemberFromInviteListByUid(uid)
	for i, v in ipairs(self.uidlist) do
		if v == uid then
			table.remove(self.uidlist, i)
		end
	end
	self.userInfoList[tostring(uid)] = nil
end
function allianceQuery:reqAllianceInviteListByIndex(index)
	local _ENV, reqUidlist
	for i = index, index + 9 do
		local uid = self.uidlist[i]
		if uid ~= nil then
			table.insert(reqUidlist, uid)
		else
			break
		end
	end
	if 0 < #reqUidlist then
		self:reqInviteList(reqUidlist)
	end
end
function allianceQuery:reqInviteList(uidlist, ...)
	if not uidlist then
		self.userInfoList, serverproxy, self.uidlist, serverproxy = nil, nil, nil, nil
	end
	serverproxy = nil
	;(nil).uidlist = uidlist
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_INVITE_LIST, nil, ...)
end
function allianceQuery:reqCheckAllianceName(name, ...)
	local err = gErrDef.Err_None
	if err == gErrDef.Err_None then
		_ENV = nil
		;(nil).name = name
		serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_CHECK_NAME, nil, ...)
	end
	return err
end
function allianceQuery:reqCheckAllianceAbbr(abbr, ...)
	local err = gErrDef.Err_None
	if err == gErrDef.Err_None then
		_ENV = nil
		;(nil).abbr = abbr
		serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_CHECK_ABBR, nil, ...)
	end
	return err
end
function allianceQuery:reqQueryLordInfoList(keyname, ...)
	self.queryLordInfoList, serverproxy = nil, nil
	serverproxy = nil
	;(nil).keyname = keyname
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_SEARCH_PLAYER_NAME, nil, ...)
end
function allianceQuery:validateNameLegality(allianceName)
end
function allianceQuery:validateAbbrLegality(allianceAbbr)
end
function allianceQuery:queryAllianceInviteList(aid, index, keyname, pid, num, ...)
	_ENV = nil
	;(nil).aid = aid
	;(nil).index = index
	;(nil).keyname = keyname
	;(nil).pid = pid
	local (nil).num, data = num, nil
	dump(data, "queryAllianceInviteList=====")
	serverproxy:Request(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_INVITE_LIST, data, ...)
end
function allianceQuery:reqAllianceInfo(kid, aid, ...)
	serverproxy = nil
	;(nil).kid = kid
	;(nil).aid = aid
	serverproxy:Request(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_INFO, nil, ...)
end
function allianceQuery:queryAllianceInfoAllWorld(keyname, ...)
	print("allianceQuery:queryAllianceInfoAllWorld")
	_ENV = nil
	;(nil).keyname = keyname
	serverproxy:Request(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_SEARCH_ALLIANCE_ALL_WORLD, nil, ...)
end
function RSP:queryAllianceRsp(content)
	if content.err == gErrDef.Err_None then
		local allianceinfo = content.data.retdata.allianceinfo
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local alliance = allianceMgr:createAlliance(allianceinfo)
		alliance.leaderName = content.data.retdata.leadername
		alliance.totalBattle = content.data.retdata.totalpower
		_ENV = allianceinfo
		allianceinfo.msg = "MESSAGE_ALLIANCE_REQ_INFO_BACK"
		allianceinfo.alliance = alliance
		allianceinfo.clientData = content.clientData
		SoraDSendMessage(allianceinfo)
	else
		print("获取联盟信息错误", content.err)
		SoraDCloseLoading()
		_ENV = "获取联盟信息错误"
		;("获取联盟信息错误").msg = "MESSAGE_ALLIANCE_REQ_INFO_BACK_ERR"
		SoraDSendMessage("获取联盟信息错误")
	end
end
function RSP:queryAllianceListRsp(content)
	dump(content.data, "==RSP.queryAllianceListRsp==", 10)
	if content.err == gErrDef.Err_None then
		local ret = content.data.retdata
		local aidlist = ret.aidlist
		local allianceInfoList = ret.allianceInfoList
		if aidlist then
			self.allianceIDList = aidlist
		end
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		for k, v in pairs(allianceInfoList) do
			local alliance = allianceMgr:createAlliance(v.allianceinfo)
			alliance.leaderName = v.leadername
			alliance.totalBattle = v.totalpower
		end
		_ENV = pairs(allianceInfoList)
		pairs(allianceInfoList).msg = "MESSAGE_ALLIACNE_GET_ALLIANCE_LIST_SUCCESS"
		SoraDSendMessage(pairs(allianceInfoList))
	else
		print("获取联盟列表错误", content.err)
	end
end
function RSP:queryKingAllianceRsp(content)
	dump(content.data, "==RSP.queryKingAllianceRsp==", 10)
	if content.err == gErrDef.Err_None then
		local ret = content.data.retdata
		local allianceInfoList = ret.allianceInfoList
		self.allianceIDList, _ENV = "==RSP.queryKingAllianceRsp==", "==RSP.queryKingAllianceRsp=="
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		for k, v in pairs(allianceInfoList) do
			table.insert(self.allianceIDList, tonumber(k))
			local alliance = allianceMgr:createAlliance(v.allianceinfo)
			alliance.leaderName = v.leadername
			alliance.totalBattle = v.totalpower
		end
		_ENV = pairs(allianceInfoList)
		pairs(allianceInfoList).msg = "MESSAGE_ALLIACNE_GET_ALLIANCE_LIST_SUCCESS"
		SoraDSendMessage(pairs(allianceInfoList))
	else
		print("获取联盟列表错误", content.err)
	end
end
function RSP:queryAllianceListByConditionRsp(content)
	if content.err == gErrDef.Err_None then
		local ret = content.data.retdata
		local aidlist = ret.aidlist
		local allianceInfoList = ret.allianceInfoList
		if aidlist then
			self.allianceIDList = aidlist
		end
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		for k, v in pairs(allianceInfoList) do
			local alliance = allianceMgr:createAlliance(v.allianceinfo)
			alliance.leaderName = v.leadername
			alliance.totalBattle = v.totalpower
		end
		_ENV = pairs(allianceInfoList)
		pairs(allianceInfoList).msg = "MESSAGE_ALLIACNE_GET_ALLIANCE_LIST_SUCCESS"
		pairs(allianceInfoList).err = content.err
		SoraDSendMessage(pairs(allianceInfoList))
	else
		print("没有符合条件的联盟", content.err)
		SoraDShowMsgTip(i18n("common_text_4134"))
	end
end
function RSP:queryAllianceByNameRsp(content)
	if content.err == gErrDef.Err_None then
		local alliancelist = content.data.retdata
		for k, v in pairs(alliancelist) do
			table.insert(self.queryaidlist, v.allianceinfo.property.aid)
			local allianceMgr = gametop.playertop_:getModule("allianceMgr")
			local alliance = allianceMgr:createAlliance(v.allianceinfo)
			alliance.leaderName = v.leadername
			alliance.totalBattle = v.totalpower
		end
		_ENV = pairs(alliancelist)
		pairs(alliancelist).msg = "MESSAGE_ALLIACNE_SEARCH_ALLIANCE_LIST_SUCCESS"
		SoraDSendMessage(pairs(alliancelist))
	end
end
function RSP:queryMemberInfoRsp(content)
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	if content.err == gErrDef.Err_None then
		local memberinfo = content.data.retdata
		local member = include("member").new()
		member:setProperty("minfo", memberinfo.minfo)
		member:setProperty("uinfo", memberinfo.uinfo)
		memberMgr:addMember(member)
	else
		print("获取单个联盟成员信息错误", content.err)
	end
end
function RSP:queryMemberListRsp(content)
	dump(content, "RSP.queryMemberListRsp", 20)
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	if content.err == gErrDef.Err_None then
		memberMgr:cleatMemNotSelf()
		local memberlist = content.data.retdata
		for k, v in pairs(memberlist) do
			local member = include("member").new()
			member:setProperty("minfo", v.minfo)
			member:setProperty("uinfo", v.uinfo)
			memberMgr:addMember(member)
		end
		_ENV = pairs(memberlist)
		pairs(memberlist).msg = "MESSAGE_ALLIACNE_GET_MEMBER_LIST_SUCCESS"
		SoraDSendMessage(pairs(memberlist))
	else
		print("获取联盟成员列表错误", content.err)
	end
end
function RSP:queryApplyListRsp(content)
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	if content.err == gErrDef.Err_None then
		local memberlist = content.data.retdata
		for k, v in pairs(memberlist) do
			local member = include("member").new()
			v.minfo.official = 0
			v.minfo.rank = 0
			member:setProperty("minfo", v.minfo)
			member:setProperty("uinfo", v.uinfo)
			memberMgr:addMember(member)
		end
		gametop = pairs(memberlist)
		pairs(memberlist).msg = "MESSAGE_ALLIACNE_GET_MEMBER_LIST_SUCCESS"
		SoraDSendMessage(pairs(memberlist))
	end
end
function RSP:queryInviteListRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.data.retdata
		local uidlist = data.uidlist
		local userInfoList = data.userInfoList
		if uidlist then
			self.uidlist = uidlist
		end
		for k, v in pairs(userInfoList) do
			self.userInfoList[tostring(k)] = v
		end
		_ENV = pairs(userInfoList)
		pairs(userInfoList).msg = "MESSAGE_ALLIACNE_GET_INVITE_LIST_SUCCESS"
		SoraDSendMessage(pairs(userInfoList))
	else
		print("获取联盟邀请列表错误", content.err)
	end
end
function RSP:checkAllianceNameRsp(content)
	if content.err == gErrDef.Err_None then
	else
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ALLIANCE_CREATE_ERR_BACK"
		gErrDef.Err_None.err = content.err
		gErrDef.Err_None.type = "name"
		SoraDSendMessage(gErrDef.Err_None)
		print("联盟名字错误", content.err)
	end
end
function RSP:checkAllianceAbbrRsp(content)
	if content.err == gErrDef.Err_None then
	else
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ALLIANCE_CREATE_ERR_BACK"
		gErrDef.Err_None.err = content.err
		gErrDef.Err_None.type = "abbr"
		SoraDSendMessage(gErrDef.Err_None)
		print("联盟缩写错误", content.err)
	end
end
function RSP:queryLordInfoListRsp(content)
	if content.err == gErrDef.Err_None then
		local userInfoList = content.data.retdata
		self.queryLordInfoList = userInfoList
		_ENV = nil
		;(nil).msg = "MESSAGE_ALLIACNE_SEARCH_INVITE_LIST_SUCCESS"
		;(nil).userInfoList = self.queryLordInfoList
		SoraDSendMessage(nil)
	else
	end
end
function RSP:queryAllianceInviteListRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.data.retdata
		dump(data, "RSP.queryAllianceInviteListRsp", 10)
		table.sort(data.uinfolist, function(a, b)
			if a.totalFc ~= b.totalFc then
				return a.totalFc > b.totalFc
			end
			return a.uid < b.uid
		end)
		_ENV = data.uinfolist
		data.uinfolist.msg = "MESSAGE_ALLIACNE_GET_INVITE_LIST_SUCCESS"
		data.uinfolist.data = content.data.retdata
		SoraDSendMessage(data.uinfolist)
	else
	end
end
function RSP:queryAllianceInfoRsp(content)
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if content.err == gErrDef.Err_None then
		local retdata = content.data.retdata
		local kid = retdata.kid
		local allianceinfo = retdata.allianceinfo
		local alliance = allianceMgr:createAlliance(allianceinfo)
		alliance.leaderName = content.data.retdata.leadername
		alliance.totalBattle = content.data.retdata.totalpower
		gametop = allianceinfo
		allianceinfo.msg = "MESSAGE_ALLIANCE_REQ_INFO_BACK"
		allianceinfo.alliance = alliance
		allianceinfo.clientData = content.clientData
		SoraDSendMessage(allianceinfo)
	elseif content.err == gErrDef.Err_ALLIANCE_NOT_FOUND_ALLIANCE then
		gametop = gErrDef.Err_ALLIANCE_NOT_FOUND_ALLIANCE
		gErrDef.Err_ALLIANCE_NOT_FOUND_ALLIANCE.msg = "MESSAGE_ALLIANCE_REQ_INFO_FAIL_BACK"
		gErrDef.Err_ALLIANCE_NOT_FOUND_ALLIANCE.clientData = content.clientData
		gErrDef.Err_ALLIANCE_NOT_FOUND_ALLIANCE.err = gErrDef.Err_ALLIANCE_NOT_FOUND_ALLIANCE
		SoraDSendMessage(gErrDef.Err_ALLIANCE_NOT_FOUND_ALLIANCE)
	else
		print("获取联盟信息错误", content.err)
	end
end
function RSP:queryAllianceInfoAllWorldRsp(content)
	if content.err == gErrDef.Err_None then
		local allianceClass = include("alliance")
		local retdata = content.data.retdata
		local isMax = retdata.isMax
		local _ENV, data
		for k, v in pairs(retdata.alliancelist) do
			local kid = v.kid
			local allianceinfo = v.allianceinfo
			local alliance = allianceClass.new(allianceinfo)
			alliance.leaderName = v.leadername
			alliance.totalBattle = v.totalpower
			_ENV = nil
			;(nil).kid = kid
			;(nil).alliance = alliance
			table.insert(data, nil)
			if kid == gametop.playertop_:getKingdomID() then
				local allianceMgr = gametop.playertop_:getModule("allianceMgr")
				local kalliance = allianceMgr:createAlliance(allianceinfo)
				kalliance.leaderName = v.leadername
				kalliance.totalBattle = v.totalpower
			end
		end
		_ENV = pairs(retdata.alliancelist)
		pairs(retdata.alliancelist).msg = "MESSAGE_SERVER_OPTION_SEARCH_ALLIANCE"
		pairs(retdata.alliancelist).data = data
		pairs(retdata.alliancelist).isMax = isMax
		SoraDSendMessage(pairs(retdata.alliancelist))
	else
		_ENV = content.data.retdata
		content.data.retdata.data, _ENV, content.data.retdata.msg = retdata.isMax, retdata.isMax, "MESSAGE_SERVER_OPTION_SEARCH_ALLIANCE"
		content.data.retdata.isMax = false
		SoraDSendMessage(content.data.retdata)
		print("获取联盟信息错误", content.err)
	end
end
return allianceQuery
