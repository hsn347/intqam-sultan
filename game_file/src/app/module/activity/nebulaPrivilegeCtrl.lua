local GameModule = include("GameModule")
local nebulaPrivilegeCtrl = class("nebulaPrivilegeCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local nebulaPrivilegeBuff = include("nebulaPrivilegeBuff")
local nebulaPrivilegelRead = include("nebulaPrivilegelRead")
function nebulaPrivilegeCtrl:ctor(properties)
	nebulaPrivilegeCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NEBULA_PRIVILEGE
end
function nebulaPrivilegeCtrl:getRound()
	return self.data.round
end
function nebulaPrivilegeCtrl:getOfficer(officerID)
	return self.data.officerData[tostring(officerID)]
end
function nebulaPrivilegeCtrl:isKing(officerID)
	local info = self.data.officerData[tostring(officerID)]
	if info then
		return info.officerUid == gametop.playertop_:getPlayerID()
	end
	return false
end
function nebulaPrivilegeCtrl:getBuff(effectType)
	if self.myOfficialType then
		return nebulaPrivilegeBuff:getTitleBuff(self.myOfficialType, effectType)
	else
		return 0
	end
end
function nebulaPrivilegeCtrl:calcMyOfficerID()
	local uid = gametop.playertop_:getPlayerID()
	local gametop, officers = gametop.playertop_, gametop.playertop_
	for _, v in pairs(self.data.officerData) do
		if v.officerUid == uid then
			officers[v.officerID] = true
		end
	end
	return officers
end
function nebulaPrivilegeCtrl:getMemberList()
	return self.data.officerData
end
function nebulaPrivilegeCtrl:getKindomList()
	return self.data.kids
end
function nebulaPrivilegeCtrl:getLimitUser()
	return self.data.treasureData
end
function nebulaPrivilegeCtrl:getGiftSendNum(treasureID)
	local num = 0
	for _, v in pairs(self.data.treasureData) do
		if v.treasureID == treasureID then
			num = num + 1
		end
	end
	return num
end
_ENV, nebulaPrivilegeCtrl.EnterGame = function(self)
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_APPOINT, handler(self, self.reqAppointRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_DISMISS, handler(self, self.reqDismissRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_TREASURE, handler(self, self.reqTreasureRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_RECORD, handler(self, self.reqRecordRsp))
	self:resetData()
	self:registerNotify()
end, function(self)
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_APPOINT, handler(self, self.reqAppointRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_DISMISS, handler(self, self.reqDismissRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_TREASURE, handler(self, self.reqTreasureRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_RECORD, handler(self, self.reqRecordRsp))
	self:resetData()
	self:registerNotify()
end
;(function(self)
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_APPOINT, handler(self, self.reqAppointRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_DISMISS, handler(self, self.reqDismissRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_TREASURE, handler(self, self.reqTreasureRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_RECORD, handler(self, self.reqRecordRsp))
	self:resetData()
	self:registerNotify()
end).regionId = 1
;(function(self)
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_APPOINT, handler(self, self.reqAppointRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_DISMISS, handler(self, self.reqDismissRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_TREASURE, handler(self, self.reqTreasureRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_RECORD, handler(self, self.reqRecordRsp))
	self:resetData()
	self:registerNotify()
end).round = 1
;(function(self)
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_APPOINT, handler(self, self.reqAppointRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_DISMISS, handler(self, self.reqDismissRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_TREASURE, handler(self, self.reqTreasureRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_RECORD, handler(self, self.reqRecordRsp))
	self:resetData()
	self:registerNotify()
end).season = 1
;(function(self)
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_APPOINT, handler(self, self.reqAppointRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_DISMISS, handler(self, self.reqDismissRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_TREASURE, handler(self, self.reqTreasureRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_RECORD, handler(self, self.reqRecordRsp))
	self:resetData()
	self:registerNotify()
end).treasureData, _ENV, (function(self)
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_APPOINT, handler(self, self.reqAppointRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_DISMISS, handler(self, self.reqDismissRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_TREASURE, handler(self, self.reqTreasureRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_RECORD, handler(self, self.reqRecordRsp))
	self:resetData()
	self:registerNotify()
end).officerData, _ENV, (function(self)
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_APPOINT, handler(self, self.reqAppointRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_DISMISS, handler(self, self.reqDismissRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_TREASURE, handler(self, self.reqTreasureRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_RECORD, handler(self, self.reqRecordRsp))
	self:resetData()
	self:registerNotify()
end).kids, _ENV, (function(self)
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_APPOINT, handler(self, self.reqAppointRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_DISMISS, handler(self, self.reqDismissRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_TREASURE, handler(self, self.reqTreasureRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_RECORD, handler(self, self.reqRecordRsp))
	self:resetData()
	self:registerNotify()
end).cd = nil, nil, nil, nil, nil, nil, 1655707559
local function data_default(self)
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_APPOINT, handler(self, self.reqAppointRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_DISMISS, handler(self, self.reqDismissRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_TREASURE, handler(self, self.reqTreasureRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_RECORD, handler(self, self.reqRecordRsp))
	self:resetData()
	self:registerNotify()
end
data_default.__index = data_default
function nebulaPrivilegeCtrl:resetData()
	_UPVALUE0_ = nil
	self:setData(nil)
	self.myOfficialType, _UPVALUE0_ = self.setData, self.setData
end
function nebulaPrivilegeCtrl:setData(data, notify)
	if not data then
		data, _ENV = nil, nil
	end
	if not self:mergeGroupData(data) then
		_ENV = self:mergeGroupData(data)
	end
	self.data = self:mergeGroupData(data)
	setmetatable(self.data, data_default)
	if notify then
		_ENV = self.data
		self.data.msg = "MESSAGE_NEBULA_PRIVILEGE_REFRESH"
		SoraDSendMessage(self.data)
		self:updateOfficialTitle()
	end
end
function nebulaPrivilegeCtrl:mergeGroupData(data)
	if not next(data) then
		return
	end
	local nebulaWarUtil = include("nebulaWarUtil")
	local selfKid = gametop.playertop_:getKingdomID()
	local selfGroupId, curRound
	for k, v in pairs(data) do
		local groupId = tonumber(k)
		if table.indexof(v.kids, selfKid) then
			selfGroupId = groupId
			curRound = v.round
		end
	end
	if not selfGroupId then
		return
	end
	if not data[tostring(selfGroupId)] then
		local _ENV, ret = data[tostring(selfGroupId)], data[tostring(selfGroupId)]
	end
	local selfAgainstId
	local groupCount = nebulaWarUtil.getGroupCount()
	for groupId = 1, groupCount do
		local _data = data[tostring(groupId)]
		if _data and groupId ~= selfGroupId then
			local needMerge = true
			if curRound and curRound <= 3 then
				selfAgainstId = selfAgainstId or nebulaWarUtil.getNebulaGroupAgainstId(selfGroupId, curRound)
				local againstId = nebulaWarUtil.getNebulaGroupAgainstId(groupId, _data.round)
				needMerge = selfAgainstId == againstId
			end
			if needMerge then
				if not ret.officerData then
					_ENV = ret.officerData
				end
				ret.officerData = ret.officerData
				table.merge(ret.officerData, _data.officerData)
				if not ret.treasureData then
					_ENV = ret.treasureData
				end
				ret.treasureData = ret.treasureData
				table.merge(ret.treasureData, _data.treasureData)
			end
		end
	end
	return ret
end
function nebulaPrivilegeCtrl:updateOfficialTitle()
	local newOfficialType = self:calcMyOfficerID() or 0
	local update = false
	if table.nums(newOfficialType) ~= table.nums(self.myOfficialType) then
		update = true
	else
		for title in pairs(newOfficialType) do
			if not self.myOfficialType[title] then
				update = true
				break
			end
		end
	end
	if update then
		self.myOfficialType = newOfficialType
		if 0 < #self.myOfficialType then
			nebulaPrivilegeBuff:notifyBuffChange(self.myOfficialType)
		end
		local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
		lordInfoCtrl:setNebulaLordTitle(newOfficialType)
		_ENV = lordInfoCtrl
		lordInfoCtrl.msg = "MESSAGE_NEBULA_PRIVILEGE_REFRESH_TITLE"
		SoraDSendMessage(lordInfoCtrl)
	end
end
function nebulaPrivilegeCtrl:setDataByInit(initData, notify)
	if not initData.nebulaPrivilegeData then
		_UPVALUE0_ = initData.nebulaPrivilegeData
	end
	self:setData(initData.nebulaPrivilegeData, notify)
end
function nebulaPrivilegeCtrl:Logout()
	self:resetData()
	nebulaPrivilegeCtrl.super.Logout(self)
end
function nebulaPrivilegeCtrl:initClientData(data)
	dump(data, "nebulaPrivilegeCtrl:initClientData====")
	if data then
		self:setData(data)
	end
	self:sendInit()
end
function nebulaPrivilegeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.NEBULA_PRIVILEGE, handler(self, self.notifyHandler))
end
function nebulaPrivilegeCtrl:notifyHandler(content)
	dump(content, "nebulaPrivilegeCtrl:notifyHandler=====", 10)
	local notifydata = content.data
	for _, data in ipairs(notifydata) do
		self:setDataByInit(data, true)
	end
end
function nebulaPrivilegeCtrl:sendInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_INIT, nil)
end
function nebulaPrivilegeCtrl:sendAppoint(uid, officerID)
	serverproxy = nil
	;(nil).uid = uid
	;(nil).officerID = officerID
	serverproxy:Request(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_APPOINT, nil)
end
function nebulaPrivilegeCtrl:sendDismiss(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_DISMISS, nil)
end
function nebulaPrivilegeCtrl:sendTreasure(uid, treasureID)
	serverproxy = nil
	;(nil).uid = uid
	;(nil).treasureID = treasureID
	serverproxy:Request(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_TREASURE, nil)
end
function nebulaPrivilegeCtrl:sendRecord()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEBULA_PRIVILEGE_MODULE, gCmd.REQ_NEBULA_PRIVILEGE_RECORD, nil)
end
function nebulaPrivilegeCtrl:reqInitRsp(content)
	dump(content, "==nebulaPrivilegeCtrl:reqInitRsp==", 10)
	if content.err == gErrDef.Err_None then
		self:setDataByInit(content.rspdata.initData, true)
	end
end
function nebulaPrivilegeCtrl:reqAppointRsp(content)
	dump(content, "==nebulaPrivilegeCtrl:reqAppointRsp==", 10)
	if content.err == gErrDef.Err_None then
		self:setDataByInit(content.rspdata.initData, true)
		SoraDShowMsgTip(i18n("common_text_1431"))
	elseif content.err == gErrDef.Err_NEBULA_PRIVILEGE_IN_CD then
		SoraDShowMsgTip(i18n("legendaryking_text_15"))
	else
		SoraDShowMsgTip(i18n("atlantiswar_privilege_text_0009"))
	end
end
function nebulaPrivilegeCtrl:reqDismissRsp(content)
	dump(content, "==nebulaPrivilegeCtrl:reqDismissRsp==", 10)
	if content.err == gErrDef.Err_None then
		self:setDataByInit(content.rspdata.initData, true)
		SoraDShowMsgTip(i18n("common_text_4370"))
	else
		SoraDShowMsgTip(i18n("atlantiswar_privilege_text_0008"))
	end
end
function nebulaPrivilegeCtrl:reqTreasureRsp(content)
	dump(content, "==nebulaPrivilegeCtrl:reqTreasureRsp==", 10)
	if content.err == gErrDef.Err_None then
		self:setDataByInit(content.rspdata.initData, true)
		SoraDShowMsgTip(i18n("common_text_1190"))
		_ENV = i18n("common_text_1190")
		i18n("common_text_1190").msg = "MESSAGE_SERVER_HEGEMON_LORD_AWARD_GIFT_BACK"
		SoraDSendMessage(i18n("common_text_1190"))
	elseif content.err == gErrDef.Err_NEBULA_PRIVILEGE_HAVE_TREASURE then
		_ENV = i18n("common_text_1190")
		i18n("common_text_1190").name = ""
		SoraDShowMsgTip(i18n("common_text_1191", i18n("common_text_1190")))
	else
		SoraDShowMsgTip(i18n("atlantiswar_privilege_text_0010"))
	end
end
function nebulaPrivilegeCtrl:reqRecordRsp(content)
	dump(content, "==nebulaPrivilegeCtrl:reqRecordRsp==", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_NEBULA_PRIVILEGE_LOG"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function nebulaPrivilegeCtrl:getReceiveStatusAndNum(activityID)
	local ret, num = self:getGiftStatusAndNum()
	if ret then
		return ret, num
	end
	local ret, num = self:getOfficerStatusAndNum()
	if ret then
		return ret, num
	end
	return false
end
function nebulaPrivilegeCtrl:getGiftStatusAndNum()
	local round = self:getRound()
	local awards = nebulaPrivilegelRead.getOfficerAwardNew(round)
	local isKing = false
	for i, cfg in ipairs(awards) do
		if self:isKing(cfg.appointID) then
			isKing = true
			break
		end
	end
	if not isKing then
		return false
	end
	local nebulaPrivilegelRead, sendNums = false, false
	for _, v in pairs(self.data.treasureData) do
		sendNums[v.treasureID] = (sendNums[v.treasureID] or 0) + 1
	end
	for __, cfg in ipairs(awards) do
		if self:isKing(cfg.appointID) then
			local sendNum = sendNums[cfg.treasureID] or 0
			local leftNum = cfg.count - sendNum
			if 0 < leftNum then
				return true, -1
			end
		end
	end
	return false
end
function nebulaPrivilegeCtrl:getOfficerStatusAndNum()
	local round = self:getRound()
	local officers = nebulaPrivilegelRead.getOfficers(round)
	for i, cfg in ipairs(officers) do
		if self:isKing(cfg.appointID) and not self:getOfficer(cfg.officerID) then
			return true, -1
		end
	end
	return false
end
return nebulaPrivilegeCtrl
