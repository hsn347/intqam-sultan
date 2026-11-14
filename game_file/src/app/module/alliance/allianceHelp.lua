local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local allianceHelp = class("allianceHelp", gameModule)
_ENV = "allianceHelp"
;("allianceHelp").uid = 0
;("allianceHelp").helpTp = 0
;("allianceHelp").queueTp = 0
;("allianceHelp").curHp = 0
;("allianceHelp").totalHp = 2
;("allianceHelp").data, _ENV, ("allianceHelp").helper, _ENV, ("allianceHelp").reduceTime = gameModule, gameModule, gameModule, gameModule, 0
;("allianceHelp").iconID = 0
local ("allianceHelp").nickName, helpData = "", "allianceHelp"
local _ENV, RSP = gameModule, gameModule
function allianceHelp:ctor(properties)
	allianceHelp.super.ctor(self, properties)
	self:resetData()
end
function allianceHelp:resetData()
	self.helpList, _UPVALUE0_ = nil, nil
end
function allianceHelp:setHelpList(helplist)
	self.helpList = helplist
end
function allianceHelp:getIsCanHelp()
	local pid = gametop.playertop_:getPlayerID()
	local otherhelplist = self:getHelpList().otherhelplist
	if otherhelplist then
		for k, helpdata in pairs(otherhelplist) do
			if helpdata.helper and #helpdata.helper > 0 then
				for _k, _v in pairs(helpdata.helper) do
					local isfind = false
					if pid == _v then
						isfind = true
					end
					if not isfind then
						return true
					end
				end
			elseif helpdata.helper and #helpdata.helper == 0 then
				return true
			end
		end
	end
end
function allianceHelp:getHelpList()
	local gametop, selfhelplist
	local gametop, otherhelplist
	local helplist = self.helpList
	local pid = gametop.playertop_:getPlayerID()
	for k, helpdata in pairs(helplist) do
		if pid == helpdata.uid then
			table.insert(selfhelplist, helpdata)
		else
			local isfind = false
			for _k, _v in pairs(helpdata.helper) do
				if pid == _v then
					isfind = true
				end
			end
			if not isfind then
				local curHp = helpdata.curHp
				local totalHp = helpdata.totalHp
				if curHp < totalHp then
					table.insert(otherhelplist, helpdata)
				end
			end
		end
	end
	local gametop, totalhelplist = (for generator), pairs(helplist)
	for k, v in pairs(selfhelplist) do
		table.insert(totalhelplist, v)
	end
	for k, v in pairs(otherhelplist) do
		table.insert(totalhelplist, v)
	end
	gametop = (for generator)
	pairs(otherhelplist).totalhelplist = totalhelplist
	pairs(otherhelplist).selfhelplist = selfhelplist
	local pairs(otherhelplist).otherhelplist, ret = otherhelplist, pairs(otherhelplist)
	return ret
end
function allianceHelp:addHelp(helpdata)
	if helpdata and not self:getHelpData(helpdata.uid, helpdata.queueTp) then
		table.insert(self.helpList, helpdata)
	end
end
function allianceHelp:updateHelp(helpdata)
	self:removeHelp(helpdata.uid, helpdata.queueTp)
	self:addHelp(helpdata)
end
function allianceHelp:removeHelp(uid, queuetype)
	print("allianceHelp:removeHelp", uid, queuetype)
	if self.helpList then
		for i, v in ipairs(self.helpList) do
			if v.uid == uid and v.queueTp == queuetype then
				table.remove(self.helpList, i)
				return true
			end
		end
	end
end
function allianceHelp:removePlayerHelpData(uid)
	local ret = false
	if uid then
		for i = #self.helpList, 1, -1 do
			if self.helpList[i].uid == uid then
				table.remove(self.helpList, i)
				ret = true
			end
		end
	end
	return ret
end
function allianceHelp:getHelpData(uid, queueTp)
	if uid and queueTp then
		for i, v in ipairs(self.helpList) do
			if v.uid == uid and v.queueTp == queueTp then
				return v
			end
		end
	end
end
function allianceHelp:EnterGame()
	allianceHelp.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_INIT_HELP, handler(self, RSP.AllianceHelpDataRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_REQ_HELP, handler(self, RSP.ReqAllianceHelpRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_HELP_MEMBER, handler(self, RSP.HelpOneRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_HELP_ALL, handler(self, RSP.HelpAllRsp))
end
function allianceHelp:Logout()
	self:resetData()
end
function allianceHelp:reqAllianceHelpData(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_INIT_HELP, nil, ...)
end
function allianceHelp:reqAllianceHelp(queuetype, data, ...)
	serverproxy = nil
	;(nil).queuetype = queuetype
	;(nil).data = data
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_REQ_HELP, nil, ...)
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	queueCtrl:setQueueHasReqHelp(queuetype)
	include("msgNotice").notice("notice_0061")
	serverproxy = "notice_0061"
	;("notice_0061").msg = "MESSAGE_ALLIACNE_GET_ALLIANCE_HELP_LIST_SUCCESS"
	SoraDSendMessage("notice_0061")
end
function allianceHelp:reqHelpOne(uid, queuetype, ...)
	serverproxy = nil
	;(nil).uid = uid
	;(nil).queuetype = queuetype
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_HELP_MEMBER, nil, ...)
end
function allianceHelp:reqHelpAll(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_HELP_ALL, nil, ...)
end
function RSP:AllianceHelpDataRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.data.retdata
		self:setHelpList(data)
		_ENV = self
		self.msg = "MESSAGE_ALLIACNE_GET_ALLIANCE_HELP_LIST_SUCCESS"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_GREEN_POINT_UPDATE"
		self.type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_HELP
		SoraDSendMessage(self)
	else
		print("rsp error: ", content.err)
	end
end
function RSP:ReqAllianceHelpRsp(content)
	if content.err == gErrDef.Err_None then
	else
		print("rsp error: ", content.err)
	end
end
function RSP:HelpOneRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.data.retdata
	else
		print("rsp error: ", content.err)
		if content.err == gErrDef.Err_ALLIANCE_ONLY_HELP_SAME_ALLIANCE then
			local uid = content.data.uid
			self:removePlayerHelpData(uid)
		end
	end
	_ENV = self.removePlayerHelpData
	self.removePlayerHelpData.msg = "MESSAGE_ALLIACNE_GET_ALLIANCE_HELP_LIST_SUCCESS"
	SoraDSendMessage(self.removePlayerHelpData)
	_ENV = self.removePlayerHelpData
	self.removePlayerHelpData.msg = "MESSAGE_GREEN_POINT_UPDATE"
	self.removePlayerHelpData.type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_HELP
	SoraDSendMessage(self.removePlayerHelpData)
end
function RSP:HelpAllRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.data.retdata
		include("msgNotice").notice("notice_0062")
		local notinallianceuids = content.data.retdata
		for k, uid in ipairs(notinallianceuids) do
			self:removePlayerHelpData(uid)
		end
	else
		print("rsp error: ", content.err)
	end
	_ENV = "rsp error: "
	;("rsp error: ").msg = "MESSAGE_ALLIACNE_GET_ALLIANCE_HELP_LIST_SUCCESS"
	SoraDSendMessage("rsp error: ")
	_ENV = "rsp error: "
	;("rsp error: ").msg = "MESSAGE_GREEN_POINT_UPDATE"
	;("rsp error: ").type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_HELP
	SoraDSendMessage("rsp error: ")
end
return allianceHelp
