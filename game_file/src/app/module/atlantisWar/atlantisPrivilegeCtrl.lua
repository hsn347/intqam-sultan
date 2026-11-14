local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local atlantisPrivilegeCtrl = class("atlantisPrivilegeCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local atlantisTitleBuff = include("atlantisTitleBuff")
local atlantisActivityRead = include("atlantisActivityRead")
function atlantisPrivilegeCtrl:ctor(properties)
	atlantisPrivilegeCtrl.super.ctor(self, properties)
	self:resetData()
end
function atlantisPrivilegeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ATLANTIS_PRIVILEGE_MODULE, gCmd.REQ_ATLANTIS_PRIVILEGE_INIT, handler(self, self.reqAtlantisPrivilegeInitRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_PRIVILEGE_MODULE, gCmd.REQ_ATLANTIS_PRIVILEGE_APPOINT, handler(self, self.reqAtlantisPrivilegeAppointRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_PRIVILEGE_MODULE, gCmd.REQ_ATLANTIS_PRIVILEGE_DISMISS, handler(self, self.reqAtlantisPrivilegeDismissRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_PRIVILEGE_MODULE, gCmd.REQ_ATLANTIS_PRIVILEGE_TREASURE, handler(self, self.reqAtlantisPrivilegeTreasureRsp))
	msgCtrl.register(gCmd.CMD_ATLANTIS_PRIVILEGE_MODULE, gCmd.REQ_ATLANTIS_PRIVILEGE_RECORD, handler(self, self.reqAtlantisPrivilegeRecordRsp))
	self:registerNotify()
	self:reqAtlantisPrivilegeInit()
end
function atlantisPrivilegeCtrl:Logout()
	atlantisPrivilegeCtrl.super.Logout(self)
	self:resetData()
end
function atlantisPrivilegeCtrl:resetData()
	self.treasureList, _UPVALUE0_, self.kindomList, _UPVALUE0_, self.memberList, _UPVALUE0_ = nil, nil, nil, nil, nil, nil
	self.myOfficialType = 0
end
function atlantisPrivilegeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ATLANTIS_PRIVILEGE, handler(self, self.notifyHandler))
end
function atlantisPrivilegeCtrl:notifyHandler(event)
	dump(event.data, "atlantisPrivilegeCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.atlantisOfficialType then
			self.myOfficialType = v.atlantisOfficialType
			if self.myOfficialType > 0 then
				atlantisTitleBuff:notifyBuffChange(self.myOfficialType)
			end
			local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
			lordInfoCtrl:setAtlantisLordTitle(v.atlantisOfficialType)
			_ENV = lordInfoCtrl
			lordInfoCtrl.msg = "MESSAGE_ATLANTISWAR_PRIVILEGE_REFRESH_TITLE"
			SoraDSendMessage(lordInfoCtrl)
		end
		if v.kingdomgPrivilegeData then
			self.memberList = v.kingdomgPrivilegeData.member
			self.kindomList = v.kingdomgPrivilegeData.kingdoms
			self.treasureList = v.kingdomgPrivilegeData.treasure
		end
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_ATLANTISWAR_PRIVILEGE_REFRESH"
		SoraDSendMessage(SoraDSendMessage)
	end
end
function atlantisPrivilegeCtrl:reqAtlantisPrivilegeInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ATLANTIS_PRIVILEGE_MODULE, gCmd.REQ_ATLANTIS_PRIVILEGE_INIT, nil)
end
function atlantisPrivilegeCtrl:reqAtlantisPrivilegeAppoint(data)
	serverproxy:Request(gCmd.CMD_ATLANTIS_PRIVILEGE_MODULE, gCmd.REQ_ATLANTIS_PRIVILEGE_APPOINT, data)
end
function atlantisPrivilegeCtrl:reqAtlantisPrivilegeDismiss(data)
	serverproxy:Request(gCmd.CMD_ATLANTIS_PRIVILEGE_MODULE, gCmd.REQ_ATLANTIS_PRIVILEGE_DISMISS, data)
end
function atlantisPrivilegeCtrl:reqAtlantisPrivilegeTreasure(data)
	serverproxy:Request(gCmd.CMD_ATLANTIS_PRIVILEGE_MODULE, gCmd.REQ_ATLANTIS_PRIVILEGE_TREASURE, data)
end
function atlantisPrivilegeCtrl:reqAtlantisPrivilegeRecord()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ATLANTIS_PRIVILEGE_MODULE, gCmd.REQ_ATLANTIS_PRIVILEGE_RECORD, nil)
end
function atlantisPrivilegeCtrl:reqAtlantisPrivilegeInitRsp(content)
	dump(content, "atlantisPrivilegeCtrl:reqAtlantisPrivilegeInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata.atlantisPrivilegeData.atlantisPrivilegeData.member then
			_ENV = content.rspdata.atlantisPrivilegeData.atlantisPrivilegeData.member
		end
		self.memberList = content.rspdata.atlantisPrivilegeData.atlantisPrivilegeData.member
		if not content.rspdata.atlantisPrivilegeData.atlantisPrivilegeData.kingdoms then
			_ENV = content.rspdata.atlantisPrivilegeData.atlantisPrivilegeData.kingdoms
		end
		self.kindomList = content.rspdata.atlantisPrivilegeData.atlantisPrivilegeData.kingdoms
		if not content.rspdata.atlantisPrivilegeData.atlantisPrivilegeData.treasure then
			_ENV = content.rspdata.atlantisPrivilegeData.atlantisPrivilegeData.treasure
		end
		self.treasureList = content.rspdata.atlantisPrivilegeData.atlantisPrivilegeData.treasure
		if content.rspdata.atlantisPrivilegeData.atlantisOfficialType then
			self.myOfficialType = content.rspdata.atlantisPrivilegeData.atlantisOfficialType
			if self.myOfficialType > 0 then
				atlantisTitleBuff:notifyBuffChange(self.myOfficialType)
			end
		end
		_ENV = atlantisTitleBuff
		atlantisTitleBuff.msg = "MESSAGE_ATLANTISWAR_PRIVILEGE_REFRESH"
		SoraDSendMessage(atlantisTitleBuff)
	end
end
function atlantisPrivilegeCtrl:reqAtlantisPrivilegeAppointRsp(content)
	dump(content, "atlantisPrivilegeCtrl:reqAtlantisPrivilegeAppointRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_1431"))
	elseif content.err == gErrDef.Err_ATLANTIS_PRIVILEGE_IN_CD then
		SoraDShowMsgTip(i18n("legendaryking_text_15"))
	else
		SoraDShowMsgTip(i18n("atlantiswar_privilege_text_0009"))
	end
end
function atlantisPrivilegeCtrl:reqAtlantisPrivilegeDismissRsp(content)
	dump(content, "atlantisPrivilegeCtrl:reqAtlantisPrivilegeDismissRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_4370"))
	else
		SoraDShowMsgTip(i18n("atlantiswar_privilege_text_0008"))
	end
end
function atlantisPrivilegeCtrl:reqAtlantisPrivilegeTreasureRsp(content)
	dump(content, "atlantisPrivilegeCtrl:reqAtlantisPrivilegeTreasureRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_1190"))
		local receiveUid = content.data.receiveUid
		local treasureID = content.data.treasureID
		if not self.treasureList[tostring(treasureID)] then
			local _ENV, treasureList = self.treasureList[tostring(treasureID)], self.treasureList[tostring(treasureID)]
		end
		_ENV = receiveUid
		receiveUid.uid = receiveUid
		treasureList[tostring(receiveUid)], receiveUid.time = receiveUid, serviceFunctions.systemTime()
		self.treasureList[tostring(treasureID)] = treasureList
		_ENV = tostring(treasureID)
		tostring(treasureID).msg = "MESSAGE_ATLANTISWAR_PRIVILEGE_TREASURE"
		SoraDSendMessage((tostring(treasureID)))
	elseif content.err == gErrDef.Err_ATLANTIS_PRIVILEGE_ALREADY_RECEIVE then
		_ENV = SoraDSendMessage
		SoraDSendMessage.name = ""
		SoraDShowMsgTip(i18n("common_text_1191", SoraDSendMessage))
	else
		SoraDShowMsgTip(i18n("atlantiswar_privilege_text_0010"))
	end
end
function atlantisPrivilegeCtrl:reqAtlantisPrivilegeRecordRsp(content)
	dump(content, "atlantisPrivilegeCtrl:reqAtlantisPrivilegeRecordRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ATLANTISWAR_PRIVILEGE_REFRESH"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function atlantisPrivilegeCtrl:getMemberList()
	if not self.memberList then
		_UPVALUE0_ = self.memberList
	end
	return self.memberList
end
function atlantisPrivilegeCtrl:getInfoByOfficialType(officialType)
	for i, v in pairs(self.memberList) do
		if v.type == officialType then
			return v
		end
	end
end
function atlantisPrivilegeCtrl:isKing()
	if next(self.memberList) and self.memberList["1"] then
		local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
		return self.memberList["1"].uid == lordInfoCtrl:getLordInfo().base.uid
	else
		return false
	end
end
function atlantisPrivilegeCtrl:getKindomList()
	return self.kindomList
end
function atlantisPrivilegeCtrl:getGiftSendNum(treasureID)
	if self.treasureList[tostring(treasureID)] then
		local sendNum = table.nums(self.treasureList[tostring(treasureID)])
		return sendNum
	else
		return 0
	end
end
function atlantisPrivilegeCtrl:getLimitUser(treasureID)
	return self.treasureList
end
function atlantisPrivilegeCtrl:getBuff(effectType)
	if worldMapDefine.isInLegendLord() then
		return 0
	end
	if self.myOfficialType and 0 < self.myOfficialType then
		return atlantisTitleBuff:getTitleBuff(self.myOfficialType, effectType)
	else
		return 0
	end
end
function atlantisPrivilegeCtrl:getReceiveStatusAndNum(activityID)
	if not self:isKing() then
		return false
	end
	local awards = atlantisActivityRead.getOfficerAward()
	for __, cfg in ipairs(awards) do
		local sendNum = self:getGiftSendNum(cfg.treasureID) or 0
		local leftNum = cfg.count - sendNum
		if 0 < leftNum then
			return true, -1
		end
	end
	return false
end
return atlantisPrivilegeCtrl
