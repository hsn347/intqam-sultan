local gamemodulec = include("GameModule")
local loginDataInitCtrl = class("loginDataInitCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function loginDataInitCtrl:ctor(properties)
	loginDataInitCtrl.super.ctor(self, properties)
	self:resetData()
end
function loginDataInitCtrl:resetData()
	self.isDataInit = false
end
function loginDataInitCtrl:EnterGame()
end
function loginDataInitCtrl:Logout()
	loginDataInitCtrl.super.Logout(self)
	self:resetData()
end
function loginDataInitCtrl:getLoginDataInitReq(...)
	serverproxy:RequestLoginInitData()
end
local initCtrlData_imp = function(info, retdata)
	local ctrl = gametop.playertop_:getModule(info.name)
	if ctrl then
		if info.fun then
			info.fun(ctrl, retdata)
		else
			local key = info.key or info.name
			ctrl:initClientData(retdata[key])
		end
	end
end
local initCtrlData = function(retdata)
	local trackback = _G.__G__TRACKBACK__
	local playerTopModule = include("PlayerTopModule")
	if not playerTopModule.initDataTable then
		local _ENV, initDataTable = playerTopModule.initDataTable, playerTopModule.initDataTable
	end
	for _, info in ipairs(initDataTable) do
		xpcall(function()
			initCtrlData_imp(info, retdata)
		end, trackback)
	end
end
function loginDataInitCtrl:getLoginDataInitRsp(content)
	_G.SoraDClearViewMessages()
	if content.err ~= gErrDef.Err_None then
		_ENV = nil
		;(nil).canNotClose = true
		;(nil).otherBtn, _ENV, (nil).canNotBtnClose = nil, nil, true
		SoraDShowMsgBox(i18n("common_text_1123"), i18n("common_text_4187"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				userSDKManager.showSwitchAccountView()
			elseif callType == MSGBOX_CALLBACK_OTHER then
				userSDKManager.openFeedback("accountMuted")
			end
		end, nil)
		return
	end
	local err = content.err
	local retdata = content.data.retdata
	if err == gErrDef.Err_None then
		gConstValue.IS_DEBUG_SERVER = content.IS_DEBUG_SERVER
		initCtrlData(retdata)
	end
	_G.SoraDResumeViewMessage()
	_ENV = retdata
	retdata.msg = "MESSAGE_MAINSCEN_LOGINFINSH"
	SoraDSendMessage(retdata)
	_G.SoraDFabricLog("getLoginDataInitRsp  complete")
	serviceFunctions.print("getLoginDataInitRsp  complete")
	print("end----")
	userSDKManager.timeInfo.t_gamedata.tend = SoraDGetSocketTime()
	self.isDataInit = true
	function _ENV(callType)
		if callType == MSGBOX_CALLBACK_YES then
			userSDKManager.showSwitchAccountView()
		elseif callType == MSGBOX_CALLBACK_OTHER then
			userSDKManager.openFeedback("accountMuted")
		end
	end
	;(function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			userSDKManager.showSwitchAccountView()
		elseif callType == MSGBOX_CALLBACK_OTHER then
			userSDKManager.openFeedback("accountMuted")
		end
	end).name = gEventName.event_client_req_data_complete
	self:dispatchEvent(function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			userSDKManager.showSwitchAccountView()
		elseif callType == MSGBOX_CALLBACK_OTHER then
			userSDKManager.openFeedback("accountMuted")
		end
	end)
	if device.platform == "ios" or device.platform == "android" then
		local boxType = userSDKManager.getPushNotificationState()
		if type(boxType) == "number" and boxType ~= 0 then
			userSDKManager.setSDKNoticeEnable()
		end
		notificationManager.refreshPushPermission()
	end
	local playerTopModule = include("PlayerTopModule")
	for k, v in ipairs(playerTopModule.delayInitCall) do
		if not v.checkOpen or v.checkOpen and clientEventMgr.judgeIsOpen(v.checkOpen) then
			local ctrl = SoraDGetCtrl(v.name)
			if ctrl and ctrl.sendReqInitDataMsg and clientEventMgr.checkCastleLvByActivityID(v.checkOpen) and clientEventMgr.checkCastleStarLvByActivityID(v.checkOpen) then
				ctrl:sendReqInitDataMsg(v.checkOpen)
			end
		end
	end
end
return loginDataInitCtrl
