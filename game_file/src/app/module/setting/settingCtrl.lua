local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local settingCtrl = class("settingCtrl", gameModule)
local _ENV, REQ = "settingCtrl", "settingCtrl"
local _ENV, RSP = gameModule, gameModule
function settingCtrl:initClientData(data)
	self.settingData = data
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.SETTING, handler(self, RSP.noitfyDataRsp))
end
function settingCtrl:setClientLanguage(language)
	if not language then
		return false
	end
	self.settingData.cl = language
	REQ.reqSetClientLanguage(language)
	return true
end
function settingCtrl:setTranslateLanguage(tlList)
	for tl, status in pairs(tlList) do
		if not tl or nil == self.settingData.tl[tl] then
			return
		end
		if false ~= status and true ~= status then
			return
		end
	end
	for tl, status in pairs(tlList) do
		self.settingData.tl[tl] = status
	end
	REQ.reqSetTranslateLanguage(tlList)
	return true
end
function settingCtrl:setAutoTranslateSwitchOn()
	self.settingData.autoSwitch = gStatus.OPEN
	for k, v in pairs(self.settingData.tl) do
		self.settingData.tl[k] = true
	end
	REQ.reqSetAutoTranslateSwitch(gStatus.OPEN)
end
function settingCtrl:setAutoTranslateSwitchOff()
	self.settingData.autoSwitch = gStatus.CLOSE
	for k, v in pairs(self.settingData.tl) do
		self.settingData.tl[k] = false
	end
	REQ.reqSetAutoTranslateSwitch(gStatus.CLOSE)
end
function settingCtrl:isAutoTranslateSwitchOn()
	if gStatus.OPEN == self.settingData.autoSwitch then
		return true
	end
	return false
end
function settingCtrl:setAnchorSwitchOn()
	REQ.reqSetAnchorSwitch(gStatus.OPEN)
end
function settingCtrl:setAnchorSwitchOff()
	REQ.reqSetAnchorSwitch(gStatus.CLOSE)
end
function settingCtrl:isAnchorSwitchOn()
	if gStatus.OPEN == self.settingData.anchorMode then
		return true
	end
	return false
end
function settingCtrl:reqWebPayVerifyTokenRefresh()
	REQ.reqWebPayVerifyTokenRefresh()
end
function settingCtrl:setQueueShowSwitch(v)
	print("settingCtrl:setQueueShowSwitch(v)", v)
	if not self.settingData.kvs then
		self.settingData.kvs, _ENV = "settingCtrl:setQueueShowSwitch(v)", "settingCtrl:setQueueShowSwitch(v)"
	end
	self.settingData.kvs[tostring(gSettingKeyType.QueueShowSwitch)] = v
	REQ.reqSetKeyValue(gSettingKeyType.QueueShowSwitch, v)
	return true
end
function settingCtrl:setQueueShowSolider(v)
	print("settingCtrl:setQueueShowSolider(v)", v)
	if not self.settingData.kvs then
		self.settingData.kvs, _ENV = "settingCtrl:setQueueShowSolider(v)", "settingCtrl:setQueueShowSolider(v)"
	end
	self.settingData.kvs[tostring(gSettingKeyType.QueueShowSolider)] = v
	REQ.reqSetKeyValue(gSettingKeyType.QueueShowSolider, v)
	return true
end
function settingCtrl:setTranslateTL(ttl)
	if not ttl or ttl == self.settingData.ttl then
		return
	end
	self.settingData.ttl = ttl
	REQ.reqTranslateTL(ttl)
	return true
end
function settingCtrl:getClientLanguage()
	return self.settingData.cl
end
function settingCtrl:getTranslateLanguage()
	return self.settingData.ttl
end
function settingCtrl:getTranslateLanguageStatus(tl)
	return self.settingData.tl[tl]
end
function settingCtrl:getTLList()
	return self.settingData.tl
end
function settingCtrl:getQueueShowSwitch()
	if not self.settingData.kvs or not self.settingData.kvs[tostring(gSettingKeyType.QueueShowSwitch)] then
		return 1
	else
		return self.settingData.kvs[tostring(gSettingKeyType.QueueShowSwitch)]
	end
end
function settingCtrl:getQueueShowSolider()
	if not self.settingData.kvs or not self.settingData.kvs[tostring(gSettingKeyType.QueueShowSolider)] then
		return 1
	else
		return self.settingData.kvs[tostring(gSettingKeyType.QueueShowSolider)]
	end
end
function settingCtrl:setShareEquipmentToAllianceChatOn()
	if not self:setKeyValue(gSettingKeyType.ShareEquipmentToAllianceChat, gStatus.YES) then
		print("setShareEquipmentToAllianceChatOff failed!")
		return false
	end
	return true
end
function settingCtrl:setShareEquipmentToAllianceChatOff()
	if not self:setKeyValue(gSettingKeyType.ShareEquipmentToAllianceChat, gStatus.NO) then
		print("setShareEquipmentToAllianceChatOn failed!")
		return false
	end
	return true
end
function settingCtrl:isShareEquipmentToAllianceChat()
	local value = self:getValue(gSettingKeyType.ShareEquipmentToAllianceChat)
	if not value then
		return true
	end
	if gStatus.YES == value then
		return true
	end
	return false
end
function settingCtrl:hideAllianceGiftMailNickname()
	if not self:setKeyValue(gSettingKeyType.HideAllianceGiftMailNickname, gStatus.YES) then
		print("hideAllianceGiftMailNickname failed!")
		return false
	end
	return true
end
function settingCtrl:showAllianceGiftMailNickname()
	if not self:setKeyValue(gSettingKeyType.HideAllianceGiftMailNickname, gStatus.NO) then
		print("showAllianceGiftMailNickname failed!")
		return false
	end
	return true
end
function settingCtrl:isHideAllianceGiftMailNickname()
	local value = self:getValue(gSettingKeyType.HideAllianceGiftMailNickname)
	if not value then
		return false
	end
	if gStatus.YES == value then
		return true
	end
	return false
end
function settingCtrl:hideAllianceGiftMailGiftName()
	if not self:setKeyValue(gSettingKeyType.HideAllianceGiftMailGiftName, gStatus.YES) then
		print("hideAllianceGiftMailNickname failed!")
		return false
	end
	return true
end
function settingCtrl:showAllianceGiftMailGiftName()
	if not self:setKeyValue(gSettingKeyType.HideAllianceGiftMailGiftName, gStatus.NO) then
		print("showAllianceGiftMailNickname failed!")
		return false
	end
	return true
end
function settingCtrl:isHideAllianceGiftMailGiftName()
	local value = self:getValue(gSettingKeyType.HideAllianceGiftMailGiftName)
	if not value then
		return false
	end
	if gStatus.YES == value then
		return true
	end
	return false
end
function settingCtrl:getKingdomSetting(key)
	return self.kingdomSettingData and self.kingdomSettingData.kvData and self.kingdomSettingData.kvData[key]
end
function REQ.reqSetClientLanguage(language)
	serverproxy = nil
	local (nil).language, data = language, nil
	serverproxy:Request(gCmd.CMD_SETTING_MODULE, gCmd.REQ_SET_CLIENT_LANGUAGE, data)
end
function REQ.reqSetTranslateLanguage(tlList)
	serverproxy = nil
	local (nil).tlList, data = tlList, nil
	serverproxy:Request(gCmd.CMD_SETTING_MODULE, gCmd.REQ_SET_TRANSLATE_LANGUAGE, data)
end
function REQ.reqTranslateTL(ttl)
	serverproxy = nil
	local (nil).ttl, data = ttl, nil
	serverproxy:Request(gCmd.CMD_SETTING_MODULE, gCmd.REQ_SET_TRANSLATE_TL, data)
end
function REQ.reqSetQueueShowSwitch(v)
	_ENV = nil
	;(nil).key = gSettingKeyType.QueueShowSwitch
	local (nil).value, data = v, nil
	serverproxy:Request(gCmd.CMD_SETTING_MODULE, gCmd.REQ_SET_KEY_VALUE, data)
end
function REQ.reqSetKeyValue(key, value)
	serverproxy = nil
	;(nil).key = key
	local (nil).value, data = value, nil
	serverproxy:Request(gCmd.CMD_SETTING_MODULE, gCmd.REQ_SET_KEY_VALUE, data)
end
function REQ.reqKingdomSettingData()
	serverproxy:Request(gCmd.CMD_SETTING_MODULE, gCmd.REQ_KINGDOM_SETTING_INIT_DATA)
end
function REQ.reqSetAutoTranslateSwitch(status)
	serverproxy = nil
	local (nil).status, data = status, nil
	serverproxy:Request(gCmd.CMD_SETTING_MODULE, gCmd.REQ_SET_AUTO_TRANSLATE_SWITCH, data)
end
function REQ.reqSetAnchorSwitch(status)
	serverproxy = nil
	local (nil).status, data = status, nil
	serverproxy:Request(gCmd.CMD_SETTING_MODULE, gCmd.REQ_SET_ANCHOR_MODE, data)
end
function REQ.reqWebPayVerifyTokenData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_WEB_PAY_VERIFY_TOKEN_MODULE, gCmd.REQ_WEB_PAY_VERIFY_TOKEN_DATA, nil)
end
function REQ.reqWebPayVerifyTokenRefresh()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_WEB_PAY_VERIFY_TOKEN_MODULE, gCmd.REQ_WEB_PAY_VERIFY_TOKEN_REFRESH, nil)
end
function RSP:setClientLanguageRsp(content)
	if content.err == gErrDef.Err_None then
	end
end
function RSP:setTranslateLanguageRsp(content)
	if content.err == gErrDef.Err_None then
	end
end
function RSP:setTranslateTLRsp(content)
	if content.err == gErrDef.Err_None then
	end
end
function RSP:setQueueShowSwitchRsp(content)
	local switch = self:getQueueShowSwitch()
	print("RSP.setQueueShowSwitchRsp( self, content ) switch=", switch)
	if switch == 1 then
		_ENV = "RSP.setQueueShowSwitchRsp( self, content ) switch="
		;("RSP.setQueueShowSwitchRsp( self, content ) switch=").data, _ENV, ("RSP.setQueueShowSwitchRsp( self, content ) switch=").msg = switch, switch, "MESSAGE_SERVER_WORLD_MAP_MOVELINE_ALL_SHOW"
		SoraDSendMessage("RSP.setQueueShowSwitchRsp( self, content ) switch=", nil)
	else
		_ENV = "RSP.setQueueShowSwitchRsp( self, content ) switch="
		;("RSP.setQueueShowSwitchRsp( self, content ) switch=").data, _ENV, ("RSP.setQueueShowSwitchRsp( self, content ) switch=").msg = nil, nil, "MESSAGE_SERVER_WORLD_MAP_MOVELINE_ALL_HIDE"
		SoraDSendMessage("RSP.setQueueShowSwitchRsp( self, content ) switch=", nil)
	end
end
function RSP:setKeyValueRsp(content)
	if content.err == gErrDef.Err_None then
		local key = content.data.key
		local value = content.data.value
		if gSettingKeyType.QueueShowSwitch == key then
			local switch = self:getQueueShowSwitch()
			print("RSP.setQueueShowSwitchRsp( self, content ) switch=", switch)
			if switch == 1 then
				_ENV = "RSP.setQueueShowSwitchRsp( self, content ) switch="
				;("RSP.setQueueShowSwitchRsp( self, content ) switch=").data, _ENV, ("RSP.setQueueShowSwitchRsp( self, content ) switch=").msg = switch, switch, "MESSAGE_SERVER_WORLD_MAP_MOVELINE_ALL_SHOW"
				SoraDSendMessage("RSP.setQueueShowSwitchRsp( self, content ) switch=", nil)
			else
				_ENV = "RSP.setQueueShowSwitchRsp( self, content ) switch="
				;("RSP.setQueueShowSwitchRsp( self, content ) switch=").data, _ENV, ("RSP.setQueueShowSwitchRsp( self, content ) switch=").msg = nil, nil, "MESSAGE_SERVER_WORLD_MAP_MOVELINE_ALL_HIDE"
				SoraDSendMessage("RSP.setQueueShowSwitchRsp( self, content ) switch=", nil)
			end
		elseif gSettingKeyType.QueueShowSolider == key then
			local switch = self:getQueueShowSolider()
			print("RSP.setQueueShowSolider( self, content ) switch=", switch)
			_ENV = "RSP.setQueueShowSolider( self, content ) switch="
			;("RSP.setQueueShowSolider( self, content ) switch=").data, _ENV, ("RSP.setQueueShowSolider( self, content ) switch=").msg = switch, switch, "MESSAGE_SERVER_WORLD_MAP_MOVELINE_ALL_SHOW"
			SoraDSendMessage("RSP.setQueueShowSolider( self, content ) switch=", nil)
		end
	end
end
function RSP:getInitKingdomSettingDataRsp(content)
	if content.err == gErrDef.Err_None then
		self.kingdomSettingData = content.data
	end
end
function RSP:setAutoTranslateSwitchRsp(content)
	if content.err == gErrDef.Err_None then
	end
end
function RSP:setAnchorSwitchRsp(content)
	dump(content, "RSP.setAnchorSwitchRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.data
		self.settingData.anchorMode = data.status
		local anchorUtil = include("anchorUtil")
		anchorUtil.doSwitchAnchor()
	end
end
function RSP:reqWebPayVerifyTokeDataRsp(content)
	dump(content, "RSP.reqWebPayVerifyTokeDataRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self.webPayVerifyToken = data.token
		self.webPayVerifyRefreshTime = data.createTokenTime
		_ENV = "RSP.reqWebPayVerifyTokeDataRsp"
		;("RSP.reqWebPayVerifyTokeDataRsp").msg = "MESSAGE_WEB_PAY_VERIFY_TOKEN_REFRESH"
		SoraDSendMessage("RSP.reqWebPayVerifyTokeDataRsp")
	end
end
function RSP:reqWebPayVerifyTokeRefreshRsp(content)
	dump(content, "RSP.reqWebPayVerifyTokeRefreshRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self.webPayVerifyToken = data.token
		self.webPayVerifyRefreshTime = data.createTokenTime
		_ENV = "RSP.reqWebPayVerifyTokeRefreshRsp"
		;("RSP.reqWebPayVerifyTokeRefreshRsp").msg = "MESSAGE_WEB_PAY_VERIFY_TOKEN_REFRESH"
		SoraDSendMessage("RSP.reqWebPayVerifyTokeRefreshRsp")
	end
end
function RSP:noitfyDataRsp(event)
	local data = event.data
	for i, notifyMsg in ipairs(data) do
		local notifyType = notifyMsg.notifyType
		if "change" == notifyType then
			local key = notifyMsg.key
			local value = notifyMsg.value
			if self.kingdomSettingData and self.kingdomSettingData.kvData then
				self.kingdomSettingData.kvData[key] = value
			end
		end
	end
end
function settingCtrl:ctor(properties)
	settingCtrl.super.ctor(self, properties)
	self.kingdomSettingData, settingCtrl, self.settingData, settingCtrl = settingCtrl.super.ctor, settingCtrl.super.ctor, settingCtrl.super.ctor, settingCtrl.super.ctor
end
function settingCtrl:EnterGame()
	settingCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_SETTING_MODULE, gCmd.REQ_SET_CLIENT_LANGUAGE, handler(self, RSP.setClientLanguageRsp))
	msgCtrl.register(gCmd.CMD_SETTING_MODULE, gCmd.REQ_SET_TRANSLATE_LANGUAGE, handler(self, RSP.setTranslateLanguageRsp))
	msgCtrl.register(gCmd.CMD_SETTING_MODULE, gCmd.REQ_SET_TRANSLATE_TL, handler(self, RSP.setTranslateTLRsp))
	msgCtrl.register(gCmd.CMD_SETTING_MODULE, gCmd.REQ_SET_KEY_VALUE, handler(self, RSP.setKeyValueRsp))
	msgCtrl.register(gCmd.CMD_SETTING_MODULE, gCmd.REQ_KINGDOM_SETTING_INIT_DATA, handler(self, RSP.getInitKingdomSettingDataRsp))
	msgCtrl.register(gCmd.CMD_SETTING_MODULE, gCmd.REQ_SET_AUTO_TRANSLATE_SWITCH, handler(self, RSP.setAutoTranslateSwitchRsp))
	msgCtrl.register(gCmd.CMD_SETTING_MODULE, gCmd.REQ_SET_ANCHOR_MODE, handler(self, RSP.setAnchorSwitchRsp))
	msgCtrl.register(gCmd.CMD_WEB_PAY_VERIFY_TOKEN_MODULE, gCmd.REQ_WEB_PAY_VERIFY_TOKEN_DATA, handler(self, RSP.reqWebPayVerifyTokeDataRsp))
	msgCtrl.register(gCmd.CMD_WEB_PAY_VERIFY_TOKEN_MODULE, gCmd.REQ_WEB_PAY_VERIFY_TOKEN_REFRESH, handler(self, RSP.reqWebPayVerifyTokeRefreshRsp))
	REQ.reqKingdomSettingData()
	REQ.reqWebPayVerifyTokenData()
end
function settingCtrl:resetData()
	self.kingdomSettingData, _UPVALUE0_, self.settingData, _UPVALUE0_ = nil, nil, nil, nil
end
function settingCtrl:Logout()
	settingCtrl.super.Logout(self)
	self:resetData()
end
function settingCtrl:setKeyValue(key, value)
	if not gCanSettingKeyType[key] then
		print("gCanSettingKeyType failed!")
		return false
	end
	if gSettingValueCheck[key] and not gSettingValueCheck[key](value) then
		print("gSettingValueCheck failed!")
		return false
	end
	if value == self:getValue(key) then
		print("repeat set!")
		return false
	end
	if not self.settingData.kvs then
		_ENV = self.settingData.kvs
	end
	self.settingData.kvs = self.settingData.kvs
	self.settingData.kvs[tostring(key)] = value
	REQ.reqSetKeyValue(key, value)
	return true
end
function settingCtrl:getValue(key)
	return self.settingData.kvs and self.settingData.kvs[tostring(key)]
end
function settingCtrl:checkValue(key)
	local value = self:getValue(key)
	if not value then
		return false
	end
	return value == gStatus.YES
end
function settingCtrl:getWebPayVerifyTokenData()
	_UPVALUE0_ = nil
	;(nil).token = self.webPayVerifyToken
	;(nil).refreshTime = self.webPayVerifyRefreshTime
	return nil
end
return settingCtrl
