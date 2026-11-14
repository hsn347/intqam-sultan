local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local massSettingWhiteListCtrl = class("massSettingWhiteListCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function massSettingWhiteListCtrl:ctor(properties)
	massSettingWhiteListCtrl.super.ctor(self, properties)
	self:resetData()
end
function massSettingWhiteListCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_MASS_SETTING_MODULE, gCmd.REQ_MASS_SETTING_DATA, handler(self, self.onRspData))
	msgCtrl.register(gCmd.CMD_MASS_SETTING_MODULE, gCmd.REQ_MASS_SETTING_SPEED_WHITE_LIST_ENABLE, handler(self, self.onRspEnable))
	msgCtrl.register(gCmd.CMD_MASS_SETTING_MODULE, gCmd.REQ_MASS_SETTING_SPEED_WHITE_LIST_ADD, handler(self, self.onRspAdd))
	msgCtrl.register(gCmd.CMD_MASS_SETTING_MODULE, gCmd.REQ_MASS_SETTING_SPEED_WHITE_LIST_REM, handler(self, self.onRspRemove))
	msgCtrl.register(gCmd.CMD_MASS_SETTING_MODULE, gCmd.REQ_MASS_SETTING_SPEED_WHITE_LIST_SEARCH, handler(self, self.onRspSearch))
end
function massSettingWhiteListCtrl:Logout()
	massSettingWhiteListCtrl.super.Logout(self)
	self:resetData()
end
function massSettingWhiteListCtrl:resetData()
	self.whiteListData, _UPVALUE0_ = nil, nil
end
function massSettingWhiteListCtrl:initClientData(data)
	dump(data, "massSettingWhiteListCtrl:initClientData", 10)
	if data then
		self.whiteListData = data
	end
end
function massSettingWhiteListCtrl:sendReqData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_MASS_SETTING_MODULE, gCmd.REQ_MASS_SETTING_DATA, nil)
end
function massSettingWhiteListCtrl:onRspData(content)
	dump(content, "massSettingWhiteListCtrl:onRspData", 10)
	if content.err == gErrDef.Err_None then
		self.whiteListData = content.rspdata
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_MASS_SETTING_WHITE_LIST_UPDATE"
	SoraDSendMessage(gErrDef.Err_None)
end
function massSettingWhiteListCtrl:sendReqEnable(speedWhiteListEnable)
	serverproxy = nil
	;(nil).speedWhiteListEnable = speedWhiteListEnable
	serverproxy:Request(gCmd.CMD_MASS_SETTING_MODULE, gCmd.REQ_MASS_SETTING_SPEED_WHITE_LIST_ENABLE, nil)
end
function massSettingWhiteListCtrl:onRspEnable(content)
	dump(content, "massSettingWhiteListCtrl:onRspEnable", 10)
	if content.err == gErrDef.Err_None then
		for k, v in pairs(content.rspdata) do
			if self.whiteListData[tostring(k)] then
				self.whiteListData[tostring(k)].speedWhiteListEnable = v.speedWhiteListEnable
			end
		end
		_ENV = pairs(content.rspdata)
		pairs(content.rspdata).msg = "MESSAGE_MASS_SETTING_WHITE_LIST_UPDATE"
		SoraDSendMessage(pairs(content.rspdata))
	end
end
function massSettingWhiteListCtrl:sendReqAdd(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_MASS_SETTING_MODULE, gCmd.REQ_MASS_SETTING_SPEED_WHITE_LIST_ADD, nil)
end
function massSettingWhiteListCtrl:onRspAdd(content)
	dump(content, "massSettingWhiteListCtrl:onRspAdd", 10)
	if content.err == gErrDef.Err_None then
		for k, v in pairs(content.rspdata) do
			if not v.speedWhiteList then
				_ENV = v.speedWhiteList
			end
			for _, w in pairs(v.speedWhiteList) do
				if not self.whiteListData[tostring(k)] then
					_ENV = self.whiteListData[tostring(k)]
				end
				self.whiteListData[tostring(k)] = self.whiteListData[tostring(k)]
				self.whiteListData[tostring(k)].speedWhiteList[w.uid] = w
			end
		end
		_ENV = pairs(content.rspdata)
		pairs(content.rspdata).msg = "MESSAGE_MASS_SETTING_WHITE_LIST_UPDATE"
		SoraDSendMessage(pairs(content.rspdata))
	end
end
function massSettingWhiteListCtrl:sendReqRemove(uids)
	serverproxy = nil
	;(nil).uids = uids
	serverproxy:Request(gCmd.CMD_MASS_SETTING_MODULE, gCmd.REQ_MASS_SETTING_SPEED_WHITE_LIST_REM, nil)
end
function massSettingWhiteListCtrl:onRspRemove(content)
	dump(content, "massSettingWhiteListCtrl:onRspRemove", 10)
	if content.err == gErrDef.Err_None then
		local kType = content.rspdata
		local whiteList = self:getWhiteList(kType)
		for _, v in ipairs(content.data.uids) do
			whiteList[tostring(v)] = nil
			dump(whiteList, "massSettingWhiteListCtrl:onRspRemove", 10)
		end
		_ENV = ipairs(content.data.uids)
		ipairs(content.data.uids).msg = "MESSAGE_MASS_SETTING_WHITE_LIST_UPDATE"
		SoraDSendMessage(ipairs(content.data.uids))
	end
end
function massSettingWhiteListCtrl:sendReqSearch(name, pid)
	serverproxy = nil
	;(nil).name = name
	;(nil).pid = pid
	serverproxy:Request(gCmd.CMD_MASS_SETTING_MODULE, gCmd.REQ_MASS_SETTING_SPEED_WHITE_LIST_SEARCH, nil)
end
function massSettingWhiteListCtrl:onRspSearch(content)
	dump(content, "massSettingWhiteListCtrl:onRspSearch", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_MASS_SETTING_WHITE_LIST_SEARCH"
		gErrDef.Err_None.list = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function massSettingWhiteListCtrl:isEnabled()
	local mapClassType = worldMapDefine.getKingdomMapClassByKingdomId()
	return self.whiteListData[tostring(mapClassType)] and self.whiteListData[tostring(mapClassType)].speedWhiteListEnable or false
end
function massSettingWhiteListCtrl:getMembers()
	return self:getWhiteList()
end
function massSettingWhiteListCtrl:getIsInWhiteList(uid)
	local whiteList = self:getWhiteList()
	for _, v in pairs(whiteList) do
		if v.uid == uid then
			return true
		end
	end
end
function massSettingWhiteListCtrl:getWhiteList(mapClassType)
	mapClassType = mapClassType or worldMapDefine.getKingdomMapClassByKingdomId()
	if not self.whiteListData[tostring(mapClassType)] or not self.whiteListData[tostring(mapClassType)].speedWhiteList then
		_ENV = self.whiteListData[tostring(mapClassType)].speedWhiteList
	end
	return self.whiteListData[tostring(mapClassType)].speedWhiteList
end
return massSettingWhiteListCtrl
