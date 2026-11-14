local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local allianceMsg = class("allianceMsg", gameModule)
local msgCtrl = include("msgCtrl")
function allianceMsg:ctor(properties)
	allianceMsg.super.ctor(self, properties)
	self:resetData()
end
function allianceMsg:resetData()
	self.aMsgList, (nil).shieldalliance, _UPVALUE0_, (nil).shieldlord, _UPVALUE0_, (nil).msglist, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
end
function allianceMsg:EnterGame()
	allianceMsg.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MESSAGE_SHIELD_LIST, handler(self, self.getAllianceMessageShieldListRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MESSAGE_SHIELD_OPERATE, handler(self, self.operateShieldListRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_SEND_MESSAGE, handler(self, self.sendAllianceMsgRsp))
	msgCtrl.register(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MSG_LIST, handler(self, self.getAllianceMsgListRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DEL_MESSAGE, handler(self, self.deleteAllianceMsgRsp))
end
function allianceMsg:Logout()
	self:resetData()
end
function allianceMsg:isLordInShieldList(uid)
	for i, v in pairs(self.aMsgList.shieldlord) do
		if uid == v.uid then
			return true, i
		end
	end
end
function allianceMsg:isAllianceInShieldList(aid)
	for i, v in pairs(self.aMsgList.shieldalliance) do
		if aid == v.aid then
			return true, i
		end
	end
end
function allianceMsg:addShieldLord(uid)
	local isfind = self:isLordInShieldList(uid)
	if not isfind then
		_ENV = nil
		;(nil).uid = uid
		table.insert(self.aMsgList.shieldlord, nil)
		return true
	end
end
function allianceMsg:delShieldLord(uid)
	local isfind, index = self:isLordInShieldList(uid)
	if isfind then
		table.remove(self.aMsgList.shieldlord, index)
		return true
	end
end
function allianceMsg:addShieldAlliance(aid)
	local isfind = self:isAllianceInShieldList(aid)
	if not isfind then
		_ENV = nil
		;(nil).aid = aid
		table.insert(self.aMsgList.shieldalliance, nil)
		return true
	end
end
function allianceMsg:delShieldAlliance(aid)
	local isfind, index = self:isAllianceInShieldList(aid)
	if isfind then
		table.remove(self.aMsgList.shieldalliance, index)
		return true
	end
end
function allianceMsg:reqAllianceMessageShieldList(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MESSAGE_SHIELD_LIST, nil, ...)
end
function allianceMsg:reqOperateShieldList(optype, data, ...)
	serverproxy = nil
	;(nil).optype = optype
	;(nil).data = data
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MESSAGE_SHIELD_OPERATE, nil, ...)
end
function allianceMsg:reqSendAllianceMsg(aid, content, ...)
	serverproxy = nil
	;(nil).aid = aid
	;(nil).content = content
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_SEND_MESSAGE, nil, ...)
end
function allianceMsg:reqDeleteAllianceMsg(msgID, ...)
	serverproxy = nil
	;(nil).msgID = msgID
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DEL_MESSAGE, nil, ...)
end
function allianceMsg:reqAllianceMsgList(aid, index, ...)
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if allianceMgr:getOwnAid() and allianceMgr:getOwnAid() == aid and index == 1 then
		self:reqAllianceMessageShieldList()
	end
	gametop = nil
	;(nil).aid = aid
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MSG_LIST, nil, ...)
end
function allianceMsg:getAllianceMessageShieldListRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.data.retdata
		self.aMsgList.shieldlord = data.shieldlord
		self.aMsgList.shieldalliance = data.shieldalliance
		_ENV = data.shieldalliance
		data.shieldalliance.msg = "MESSAGE_ALLIACNE_GET_SHIELD_LIST_SUCCESS"
		SoraDSendMessage(data.shieldalliance)
	else
		print("rsp error: ", content.err)
	end
end
function allianceMsg:operateShieldListRsp(content)
	if content.err == gErrDef.Err_None then
		local optype = content.data.optype
		local data = content.data.data
		local aid = data.aid
		local uid = data.uid
		if aid then
			if optype == gAShieldListOperate.add then
				self:addShieldAlliance(aid)
			elseif optype == gAShieldListOperate.del then
				self:delShieldAlliance(aid)
				_ENV = self
				self.msg = "MESSAGE_ALLIACNE_UNLOCK_SHIELD_SUCCESS"
				SoraDSendMessage(self)
			end
		elseif uid then
			if optype == gAShieldListOperate.add then
				self:addShieldLord(uid)
			elseif optype == gAShieldListOperate.del then
				self:delShieldLord(uid)
				_ENV = self
				self.msg = "MESSAGE_ALLIACNE_UNLOCK_SHIELD_SUCCESS"
				SoraDSendMessage(self)
			end
		end
	else
		print("allianceMsg:operateShieldListRsp rsp error: ", content.err)
	end
end
function allianceMsg:sendAllianceMsgRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.data.retdata
		local isGM = data.isGM
		if type(data.content) == "string" then
			_ENV = type(data.content)
			type(data.content).contentType = 0
			data.content, type(data.content).content = type(data.content), data.content
		end
		_ENV = data.content
		data.content.msg = "MESSAGE_ALLIANCE_NEW_ALLIANCE_MSG"
		data.content.allianceMsg = data
		SoraDSendMessage(data.content)
	else
	end
end
function allianceMsg:getAllianceMsgListRsp(content)
	if content.err == gErrDef.Err_None then
		local retdata = content.data.retdata
		SoraDCloseLoading()
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		for i, v in ipairs(retdata.msglist) do
			if v.nickName == nil then
				v.nickName = lordInfoCtrl:getLordInfo().base.nickName
			end
			if v.iconID == nil then
				v.iconID = lordInfoCtrl:getLordInfo().base.imageId
			end
			if type(v.content) == "string" then
				_ENV = type(v.content)
				type(v.content).contentType = gAllianceChatMsgType.text
				v.content, type(v.content).content = type(v.content), v.content
			end
			local isGM = v.isGM or false
		end
		_ENV = ipairs(retdata.msglist)
		ipairs(retdata.msglist).msg = "MESSAGE_ALLIANCE_HISTORY_ALLIANCE_MSG"
		ipairs(retdata.msglist).nextindex = retdata.nextindex
		ipairs(retdata.msglist).retdata = retdata
		ipairs(retdata.msglist).aid = content.data.aid
		SoraDSendMessage(ipairs(retdata.msglist))
	else
	end
end
function allianceMsg:deleteAllianceMsgRsp(content)
	dump(content, "content=========", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ALLIANCE_DEL_ALLIANCE_MSG"
		gErrDef.Err_None.msgID = content.data.msgID
		gErrDef.Err_None.aid = content.data.aid
		SoraDSendMessage(gErrDef.Err_None)
	end
end
return allianceMsg
