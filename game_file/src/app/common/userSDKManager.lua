userSDKManager, _ENV = nil, nil
local CSUserSDKManager = CS.Sultan.Manager.UserSDKManager.GetInstance()
local isAndroidOrIsIPhone = UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer
local isSDKLogin = false
userSDKManager.sdkConstSaveTable, _ENV = nil, nil
function userSDKManager.resetTimeInfo()
	_ENV, _ENV = nil, nil
	;(nil).tbegin = 0
	_ENV, (nil).t_total, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_sdk, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_login, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_gamelogin, (nil).tend = nil, nil, 0
	;(nil).tbeign = 0
	_ENV, (nil).t_gamedata, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	;(nil).tend = 0
	_ENV, (nil).t_res, (nil).taccu = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_mainui, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_maincity, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	userSDKManager.timeInfo, (nil).t_maincityp, (nil).tend = nil, nil, 0
end
userSDKManager.userid = nil
userSDKManager.onEnterForegroundEventList, _ENV = function()
	_ENV, _ENV = nil, nil
	;(nil).tbegin = 0
	_ENV, (nil).t_total, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_sdk, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_login, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_gamelogin, (nil).tend = nil, nil, 0
	;(nil).tbeign = 0
	_ENV, (nil).t_gamedata, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	;(nil).tend = 0
	_ENV, (nil).t_res, (nil).taccu = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_mainui, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_maincity, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	userSDKManager.timeInfo, (nil).t_maincityp, (nil).tend = nil, nil, 0
end, function()
	_ENV, _ENV = nil, nil
	;(nil).tbegin = 0
	_ENV, (nil).t_total, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_sdk, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_login, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_gamelogin, (nil).tend = nil, nil, 0
	;(nil).tbeign = 0
	_ENV, (nil).t_gamedata, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	;(nil).tend = 0
	_ENV, (nil).t_res, (nil).taccu = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_mainui, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_maincity, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	userSDKManager.timeInfo, (nil).t_maincityp, (nil).tend = nil, nil, 0
end
userSDKManager.need2CallBackEventList, _ENV = function()
	_ENV, _ENV = nil, nil
	;(nil).tbegin = 0
	_ENV, (nil).t_total, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_sdk, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_login, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_gamelogin, (nil).tend = nil, nil, 0
	;(nil).tbeign = 0
	_ENV, (nil).t_gamedata, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	;(nil).tend = 0
	_ENV, (nil).t_res, (nil).taccu = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_mainui, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_maincity, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	userSDKManager.timeInfo, (nil).t_maincityp, (nil).tend = nil, nil, 0
end, function()
	_ENV, _ENV = nil, nil
	;(nil).tbegin = 0
	_ENV, (nil).t_total, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_sdk, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_login, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_gamelogin, (nil).tend = nil, nil, 0
	;(nil).tbeign = 0
	_ENV, (nil).t_gamedata, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	;(nil).tend = 0
	_ENV, (nil).t_res, (nil).taccu = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_mainui, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	_ENV, (nil).t_maincity, (nil).tend = nil, nil, 0
	;(nil).tbegin = 0
	userSDKManager.timeInfo, (nil).t_maincityp, (nil).tend = nil, nil, 0
end
userSDKManager.isFabricEnable = true
userSDKManager.isSecondaryLockShow = false
userSDKManager.isSecondaryLockEnable = false
userSDKManager.secondaryStatusCallback = nil
userSDKManager.secondaryCheckCallback = nil
userSDKManager.maintainCallback = nil
userSDKManager.unreadCountCallback = nil
userSDKManager.unreadCount = nil
userSDKManager.actionJumpCallback = nil
function userSDKManager.login(user)
	print("userSDKManager.login_New")
	userSDKManager.userid = nil
	_ENV = nil
	userSDKManager.logEvent(gSDKDef.TDonEvent.star_login_sdk, nil)
	local curTime = SoraDGetSocketTime()
	userSDKManager.timeInfo.t_total.tbegin = curTime
	userSDKManager.timeInfo.t_sdk.tbegin = curTime
	if user == "" then
		local lang = userSDKManager.getChannel()
		CSUserSDKManager:loginWithParam(true)
	else
		userSDKManager_sdkLoginCallBack(user)
	end
end
function userSDKManager.setLanguage(lang)
	print("语言是")
	if isAndroidOrIsIPhone then
		CSUserSDKManager:setLanguage(lang)
		if lang == gSDKDef.ClientLanguage["zh-CN"] then
			fgui.UIConfig.defaultFont = "NotoSansSC-Regular"
		else
			local channel = userSDKManager.getChannel()
			if channel == "ar" then
				fgui.UIConfig.defaultFont = "NotoNaskhArabicDiy-Regular"
			else
				fgui.UIConfig.defaultFont = ""
			end
		end
	end
end
function userSDKManager.setSDKNoticeEnable(...)
	CSUserSDKManager:setSDKNoticeEnable()
end
function userSDKManager.setChangeOrUpdatePasswordBlock(...)
end
function userSDKManager.gotoSettingPushNotification(...)
	local ok, ret = CSUserSDKManager:gotoSettingPushNotification()
	print("gotoSettingPushNotification", ok, ret)
end
function userSDKManager.getPushNotificationState(...)
	local _state = false
	_state = CSUserSDKManager:getPushNotificationState()
	return _state
end
function userSDKManager.getIsGooglePlayInstalled(...)
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android then
		local ret = CSUserSDKManager:getIsGooglePlayInstalled()
		return ret
	end
	return false
end
function userSDKManager.setOnMessageListener()
	if isSDKLogin then
		CSUserSDKManager:setOnMessageListener()
	end
end
function userSDKManager.setOnNoticeBoardListener(...)
	if isSDKLogin then
		CSUserSDKManager:setOnNoticeBoardListener()
	end
end
function userSDKManager.setFabricEnable(bool)
end
function userSDKManager.causeACrash()
	SoraDCreatePanel("crashTest"):show()
end
function userSDKManager.setReloadListener()
end
function userSDKManager.readFromSaveConstTable(field)
	local ok, ret
	if userSDKManager.sdkConstSaveTable[field] ~= nil then
		ok = true
		ret = userSDKManager.sdkConstSaveTable[field]
	else
		ok = false
	end
	return ok, ret
end
function userSDKManager.report2firebase(target, argTbl)
	target = target or ""
	if not argTbl then
		argTbl, isAndroidOrIsIPhone = nil, nil
	end
	if isAndroidOrIsIPhone then
		local argJsonStr = json.encode(argTbl)
		CSUserSDKManager:report2firebase(target, argJsonStr)
	end
end
function userSDKManager.reportGameUserInfo()
	if isSDKLogin == true then
		print("userSDKManager.reportGameUserInfo")
		local lordLocalData = include("lordLocalData")
		local gametop = gModuleMgr.getObject("gametop")
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local lordInfo = lordInfoCtrl:getBaseInfo()
		local playerID = "" .. gametop.playertop_:getPlayerID()
		local serverID = "" .. gametop.playertop_:getKingdomID()
		local avatar = lordLocalData.getHead(lordInfo.imageId)
		local nickName = lordInfo.nickName or ""
		if lordInfo.avatar and lordInfo.avatar ~= "" then
			avatar = lordInfo.avatar
		end
		CSUserSDKManager:reportGameUserInfo(nickName, playerID, serverID, avatar, "")
	end
end
function userSDKManager.showSocial()
	if isSDKLogin == true then
		CSUserSDKManager:showSocial()
	end
end
function userSDKManager.showFAQs()
	if isSDKLogin == true then
		SoraDPlaySound("uicontrol", 32)
		CSUserSDKManager:showFAQs()
	end
end
function userSDKManager.showFAQSection(sectionid)
	if isSDKLogin == true then
		SoraDPlaySound("uicontrol", 32)
		CSUserSDKManager:showFAQSection(sectionid)
	end
end
function userSDKManager.onGuideEvent(step)
	if isSDKLogin == true then
		print("================================step ", step)
		local eventId = gSDKDef.TDonEvent.guideStep
		isSDKLogin = step
		userSDKManager.logEvent(eventId .. step, step)
	end
end
function userSDKManager.showSingleFAQ(questionid)
	if isSDKLogin == true then
		CSUserSDKManager:showSingleFAQ(questionid)
	end
end
function userSDKManager.pickAvatar(...)
	if isSDKLogin == true then
		CSUserSDKManager:pickAvatar()
	end
end
function userSDKManager.captureAvatar(...)
	if isSDKLogin == true then
		CSUserSDKManager:captureAvatar()
	end
end
function userSDKManager.showUserCenter()
	if isSDKLogin == true then
		CSUserSDKManager:showUserCenter()
	end
end
function userSDKManager.showSwitchAccountView()
	if isSDKLogin == true then
		CSUserSDKManager:showSwitchAccountView()
	end
end
function userSDKManager.showNewAccountView()
	if isSDKLogin == true then
		CSUserSDKManager:showNewAccountView()
	end
end
function userSDKManager.reportOnline()
	local gametop = gModuleMgr.getObject("gametop")
	local premiumStoreCtrl = gametop.playertop_:getModule("premiumStoreCtrl")
	local totalRecharge = premiumStoreCtrl:getDollor()
	local vipLv = 0
	if totalRecharge <= 0 then
	elseif totalRecharge <= 200 then
		vipLv = 1
	elseif totalRecharge <= 1000 then
		vipLv = 2
	elseif totalRecharge <= 6000 then
		vipLv = 3
	elseif totalRecharge <= 30000 then
		vipLv = 4
	elseif 30000 < totalRecharge then
		vipLv = 5
	end
	if isSDKLogin == true then
		print("userSDKManager.reportOnline()")
		local gametop = gModuleMgr.getObject("gametop")
		local playerID = "" .. gametop.playertop_:getPlayerID()
		local serverID = "" .. gametop.playertop_:getKingdomID()
		local gameVersion = GAME_VERSION
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local lordInfo = lordInfoCtrl:getBaseInfo()
		CSUserSDKManager:reportOnline(playerID, tostring(lordInfo.nickName), serverID, gameVersion, vipLv)
	end
end
function userSDKManager.reportReline()
	if isSDKLogin == true then
		print("userSDKManager.reportReline")
		CSUserSDKManager:reportReline()
	end
end
function userSDKManager.reportFinishGuide()
	if isSDKLogin == true then
		CSUserSDKManager:reportFinishGuide()
	end
end
function userSDKManager.reportPay(_payNum)
	print("userSDKManager.reportPay", _payNum)
	_payNum = _payNum or 0
	if isSDKLogin == true then
		CSUserSDKManager:reportPay(_payNum)
	end
end
function userSDKManager.reportMoneyCurrent(...)
	local moneyType
	for _, v in pairs(paymentManager.products) do
		moneyType = v.currency
		break
	end
	local gametop = gModuleMgr.getObject("gametop")
	local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
	rechargeActivityCtrl:sendSelfMonetyType(moneyType)
end
function userSDKManager.reportCastleLevel()
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local cLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	_UPVALUE12_ = cityCtrl
	cityCtrl[1] = 3
	cityCtrl[2] = 5
	cityCtrl[3] = 6
	cityCtrl[4] = 10
	cityCtrl[5] = 11
	cityCtrl[6] = 13
	cityCtrl[7] = 15
	cityCtrl[8] = 16
	cityCtrl[9] = 19
	cityCtrl[10] = 20
	cityCtrl[11] = 25
	local cityCtrl[12], needUp = 30, cityCtrl
	local canUp = false
	for _, v in pairs(needUp) do
		if cLevel == v then
			canUp = true
		end
	end
	print("上报城堡等级:", cLevel)
	if isSDKLogin == true and canUp then
		CSUserSDKManager:reportCastleLevel(cLevel)
	end
end
function userSDKManager.openSDKWebLink(_url)
	_url = _url or ""
	if isSDKLogin == true then
		CSUserSDKManager:openSDKWebLink(_url)
	end
end
function userSDKManager.openSDKLink(_url)
	_url = _url or ""
	if isSDKLogin == true then
		CSUserSDKManager:openSDKLink(_url)
	end
end
function userSDKManager.initADs()
end
function userSDKManager.registCallBackFunc()
	if device.platform == "ios" then
		_ENV = nil
		;(nil).shareCallBack = userSDKManager_commonShare_callBack
		luaoc.callStaticMethod("NCSGameCenter", "registGameCenterCallBackFunc", nil)
	end
end
function userSDKManager.shareFacebookLinkContent(contentUrl)
	if isSDKLogin == true then
		CSUserSDKManager:shareFacebookLinkContent(contentUrl)
	end
end
function userSDKManager.shareToKakaoTalk(content)
	if isSDKLogin == true then
		local path = "kakaolink://send?" .. content
		userSDKManager.openSDKWebLink(content)
	end
end
function userSDKManager.shareWhatsappLinkContent(contentUrl)
	if isSDKLogin == true then
		CSUserSDKManager:shareWhatsappLinkContent(contentUrl)
	end
end
function userSDKManager.popQuestionnaire(contentUrl)
	if isSDKLogin == true then
		CSUserSDKManager:popQuestionnaire(contentUrl)
	end
end
function userSDKManager.openFeedback(source, isDirectToFeedback)
	if isSDKLogin == true then
		local sourceStr = source or ""
		CSUserSDKManager:openFeedback(sourceStr)
	end
end
function userSDKManager.releaseRes()
	if isSDKLogin == true then
		CSUserSDKManager:releaseRes()
	end
end
function userSDKManager.setAppVersion(appVersion)
	if isSDKLogin == true then
		CSUserSDKManager:setAppVersion(appVersion)
	end
end
function userSDKManager.checkIsEmulator(funPermit, funForbid)
	userSDKManager.isNotEmulator = funPermit
	userSDKManager.isEmulator = funForbid
	print("userSDKManager.checkIsEmulator", UnityEngine.Application.platform, UnityEngine.RuntimePlatform.Android)
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android then
		userSDKManager_checkIsEmulator_Android(false)
	else
		if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
			userSDKManager_checkIsEmulator_IOS(false)
		else
		end
	end
end
function userSDKManager.returnAccountBindType(platform)
	if isSDKLogin == true then
		print("returnAccountBindType", platform)
		local _state = CSUserSDKManager:returnAccountBindType(platform)
		print("returnAccountBindType", _state)
		return _state
	end
	return
end
function userSDKManager.showBindView()
	if isSDKLogin == true then
		CSUserSDKManager:showBindView()
	end
end
function userSDKManager.isAccountBound()
	if isSDKLogin == true then
		local _status = CSUserSDKManager:isAccountBound()
		return _status
	end
	return
end
function userSDKManager.logEvent(event, eventData)
	if not event then
		return
	end
	if not eventData then
		eventData, _ENV = nil, nil
	end
	print("logEvent", event)
	if isAndroidOrIsIPhone then
		local dataJson = json.encode(eventData)
		CSUserSDKManager:logEvent(event, dataJson)
	end
end
function userSDKManager.logError(errorname, errormsg)
	if isAndroidOrIsIPhone then
		CSUserSDKManager:logEvent(errorname, errormsg)
	end
end
function userSDKManager.isGameDevelop()
	return SoraDConfigGet("System:GameDevelopMode~bool")
end
local gameServices
function userSDKManager.isGameService()
	local config = SoraDConfigGet("System:GameDevelopService~bool")
	if not config then
		if gameServices == nil then
			if CSUserSDKManager.isGameServices then
			else
			end
		end
		config = gameServices
	end
	return config
end
function userSDKManager.isReportError()
	return SoraDConfigGet("System:RepotrError~bool")
end
function userSDKManager.isBeta()
	local isBeta = false
	local conOk, conRet = userSDKManager.readFromSaveConstTable("userSDKManager.isBeta")
	print("isBeta", conRet, conOk)
	if conOk then
		isBeta = conRet
	else
		isBeta = CSUserSDKManager:isBeta()
		print("isBeta", isBeta)
		userSDKManager.sdkConstSaveTable["userSDKManager.isBeta"] = isBeta
	end
	return isBeta
end
function userSDKManager.isAR()
	local channel = userSDKManager.getChannel()
	if channel == "ar" then
		return true
	end
	return false
end
function userSDKManager.isEN()
	local channel = userSDKManager.getChannel()
	if channel == "en" then
		return true
	end
	return false
end
function userSDKManager.isFA()
	local channel = userSDKManager.getChannel()
	if channel == "fa" then
		return true
	end
	return false
end
function userSDKManager.isKO()
	local channel = userSDKManager.getChannel()
	if channel == "ko_android" or channel == "ko_onestore" or channel == "ko_ios" then
		return true
	end
	return false
end
function userSDKManager.isHuawei()
	return paymentManager.getStoreChannel() == gRechargeChannel.HUAWEI
end
function userSDKManager.getStore()
	local store = ""
	if userSDKManager.getPlatformChannel() == "huawei" then
		store = "huawei"
	elseif UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android then
		store = "google"
	elseif UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
		store = "apple"
	end
	return store
end
function userSDKManager.getTargetProject()
	if userSDKManager.isAR() then
		return "koh"
	elseif userSDKManager.isEN() then
		return "ros"
	elseif userSDKManager.isKO() then
		return "rosko"
	end
	return "koh"
end
function userSDKManager.getAppID()
	local appId = 100000601
	local conOk, conRet = userSDKManager.readFromSaveConstTable("userSDKManager.getAppID")
	if conOk then
		appId = conRet
	else
		if isAndroidOrIsIPhone then
			appId = CSUserSDKManager:getAppID()
		end
		userSDKManager.sdkConstSaveTable["userSDKManager.getAppID"] = appId
	end
	return appId
end
function userSDKManager.getChannel()
	local channel = "ar"
	local conOk, conRet = userSDKManager.readFromSaveConstTable("userSDKManager.getChannel")
	if conOk then
		channel = conRet
	else
		if isAndroidOrIsIPhone then
			channel = CSUserSDKManager:getChannel()
			print("getChannel-1", channel)
		else
			channel = gGameDefaultChannel
		end
		userSDKManager.sdkConstSaveTable["userSDKManager.getChannel"] = channel
	end
	print("getChannel-2", channel)
	return channel
end
function userSDKManager.getPlatformChannel()
	local channel = ""
	local conOk, conRet = userSDKManager.readFromSaveConstTable("userSDKManager.getPlatformChannel")
	if conOk then
		channel = conRet
	elseif UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android then
		channel = CSUserSDKManager:getPlatformChannel()
		userSDKManager.sdkConstSaveTable["userSDKManager.getPlatformChannel"] = channel
	end
	return channel
end
function userSDKManager.getDeviceOSVersion()
	local osVersion = CSUserSDKManager:getDeviceOSVersion()
	return osVersion
end
function userSDKManager.scoreInAppStore()
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
		CSUserSDKManager:showStoreReview()
	end
end
function userSDKManager.isIPhoneNotchScreen()
	if device.platform == "ios" then
		return CSUserSDKManager:isNotchScreen()
	end
	return false
end
function userSDKManager.capture()
	if device.platform == "ios" or device.platform == "android" then
		CSUserSDKManager:capture()
	end
end
function userSDKManager.cancelCapture()
	if device.platform == "ios" or device.platform == "android" then
		CSUserSDKManager:cancelCapture()
	end
end
function userSDKManager.stopCapture()
	if device.platform == "ios" or device.platform == "android" then
		CSUserSDKManager:stopCapture()
	end
end
function userSDKManager.stopPlay()
	if device.platform == "ios" or device.platform == "android" then
		CSUserSDKManager:stopPlay()
	end
end
function userSDKManager.uploadRec(recIdentifier)
	CSUserSDKManager:uploadRec(recIdentifier)
end
function userSDKManager.getDuration(localRecIdentifier)
	print("getDuration", localRecIdentifier)
	local duration = CSUserSDKManager:getDuration(localRecIdentifier)
	print("getDuration", duration)
	return duration
end
function userSDKManager.downloadRec(recIdentifier)
	CSUserSDKManager:downloadRec(recIdentifier)
end
function userSDKManager.playOrStop(recIdentifier)
	CSUserSDKManager:playOrStop(recIdentifier)
end
function userSDKManager.setAudioTarget(target)
	userSDKManager.audioTarget = target
end
function userSDKManager.isSupportReplay()
	local isSupport = CSUserSDKManager:isSupportReplay()
	return isSupport
end
function userSDKManager.isRecording()
	local isRecording = CSUserSDKManager:isRecording()
	return isRecording
end
function userSDKManager.startRecording()
	_ENV = nil
	;(nil).type = 1
	userSDKManager.logEvent(gSDKDef.TDonEvent.screen_recording_log, nil)
	CSUserSDKManager:startRecording()
end
function userSDKManager.stopRecording()
	CSUserSDKManager:stopRecording()
end
function userSDKManager.discardRecording()
	CSUserSDKManager:discardRecording()
end
function userSDKManager.displayRecordingContent()
	CSUserSDKManager:displayRecordingContent()
end
function userSDKManager.openMadeleinePrice(...)
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local lordInfo = lordInfoCtrl:getBaseInfo()
	local playerID = "" .. gametop.playertop_:getPlayerID()
	local serverID = "" .. gametop.playertop_:getKingdomID()
	CSUserSDKManager:openMadeleinePrice(playerID, lordInfo.nickName, serverId)
end
function userSDKManager.openNoticeBorad(...)
	CSUserSDKManager:openNoticeBorad()
end
function userSDKManager.openAlbumSetting(...)
	CSUserSDKManager:openAlbumSetting()
end
function userSDKManager.saveShareImage(fileName)
	local writablePath = cc.FileUtils:getInstance():getWritablePath()
	path = writablePath .. "/" .. fileName
	if device.platform == "android" then
		CSUserSDKManager:saveShareImage(path, fileName)
	elseif device.platform == "ios" then
		_ENV = device.platform
		device.platform.fileName = fileName
		local device.platform.path, args = path, device.platform
		local ok, ret = luaoc.callStaticMethod("NCSGameCenter", "copyToPicturesDoucument", args)
	end
end
function userSDKManager.commonShare(sayWord, fileName)
	local writablePath = cc.FileUtils:getInstance():getWritablePath()
	path = writablePath .. "/" .. fileName
	CSUserSDKManager:shareImages(sayWord, path)
end
function UserSDKManager_ScreenShot_CallBack(...)
	if isSDKLogin == true and commonCheck.SCREEN_SHOT then
		isSDKLogin = nil
		;(nil).msg = "MESSAGE_SERVER_OPTION_SHARE_BTN_UPDATE"
		;(nil).otherPic = false
		SoraDSendMessage(nil)
		local panel = SoraDCreatePanel("commonSharePic")
		panel:initData(SoraDCreateScreenShot(), 1)
		panel:show()
		isSDKLogin = panel
		panel.msg = "MESSAGE_SERVER_OPTION_SHARE_BTN_UPDATE"
		panel.otherPic = true
		SoraDSendMessage(panel)
	end
end
function userSDKManager_commonShare_callBack(result)
	dump(result, "userSDKManager_commonShare_callBack")
	_ENV = result
	result.msg = "MESSAGE_TOP_COMMON_SHARE_BACK"
	result.result = result
	SoraDSendMessage(result)
	if "saveFail" == result then
	elseif "saveSuccess" == result then
	elseif 1 == result then
	elseif 0 == result then
	elseif "BigDeny" == result then
		SoraDShowMsgBox(i18n("screen_text_05"), i18n("screen_btn_03"), nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				userSDKManager.openAlbumSetting()
			end
		end)
	elseif "SmallDeny" == result then
	end
end
function userSDKManager.postEvent2Fabric(info)
end
function userSDKManager.openWithFacebook(scheme, webUrl)
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android then
		CSUserSDKManager:openWithFacebook(scheme, webUrl)
	elseif device.platform == "ios" then
		_ENV = device.platform
		device.platform.scheme = scheme
		local device.platform.webUrl, args = webUrl, device.platform
		luaoc.callStaticMethod("NCSGameCenter", "openWithFacebook", args)
	else
		device.openURL(webUrl)
	end
end
function userSDKManager.sendTwitter(contentText)
	CSUserSDKManager:sendTwitter(contentText)
end
function userSDKManager_attGrantedComplete(dataJson)
	print("userSDKManager_attGrantedComplete")
	_ENV = "userSDKManager_attGrantedComplete"
	;("userSDKManager_attGrantedComplete").msg = "MESSAGE_IOS_ATT_GRANTED_FIN"
	SoraDSendMessage("userSDKManager_attGrantedComplete")
end
function userSDKManager_sdkLoginCallBack(dataJson)
	local dataUserInfo = json.decode(dataJson)
	local user = dataUserInfo.user
	local deviceId = dataUserInfo.deviceId
	local authId = dataUserInfo.authId
	print("userSDKManager_sdkLoginCallBack user: " .. user)
	print("userSDKManager_sdkLoginCallBack deviceId: " .. deviceId)
	print("userSDKManager_sdkLoginCallBack authId: " .. authId)
	print("登录成功回调====")
	userSDKManager.timeInfo.t_sdk.tend = SoraDGetSocketTime()
	sendReviewLog(string.format("sdk login callBack user:%s deviceId:%s authId:%s", tostring(user), tostring(deviceId), tostring(authId)))
	if user ~= nil then
		_ENV = string.format("sdk login callBack user:%s deviceId:%s authId:%s", tostring(user), tostring(deviceId), tostring(authId))
		userSDKManager.logEvent(gSDKDef.TDonEvent.end_login_sdk, string.format("sdk login callBack user:%s deviceId:%s authId:%s", tostring(user), tostring(deviceId), tostring(authId)))
		userSDKManager.userid = user
		userSDKManager.deviceId = deviceId
		userSDKManager.authId = authId
		SoraDAddLoginViewProgress(gLoginRangeTbl.connectServer, 50)
		SoraDStartLoginServer()
	else
		print("gameLogin user is nil")
	end
end
function userSDKManager_sdkUserInfoChangeCallBack(dataJson)
	local dataUserInfo = json.decode(dataJson)
	local user = dataUserInfo.user
	local deviceId = dataUserInfo.deviceId
	local authId = dataUserInfo.authId
	print("userSDKManager_sdkUserInfoChangeCallBack user: " .. user)
	print("userSDKManager_sdkUserInfoChangeCallBack deviceId: " .. deviceId)
	print("userSDKManager_sdkUserInfoChangeCallBack authId: " .. authId)
	sendReviewLog(string.format("sdk user info change callBack user:%s deviceId:%s authId:%s", tostring(user), tostring(deviceId), tostring(authId)))
	if user ~= nil then
		userSDKManager.userid = user
		userSDKManager.deviceId = deviceId
		userSDKManager.authId = authId
	end
end
function userSDKManager_sdkMessageCallBack(jsonInfo)
	print("sdkMessageCount", jsonInfo)
	if not json.decode(jsonInfo) then
		local _ENV, info = json.decode(jsonInfo), json.decode(jsonInfo)
	end
	local msgType = info.msgType
	local count = info.count or 0
	local isSuccess = info.success or false
	if not isSuccess then
		return
	end
	if not userSDKManager.sdkMessageCount then
		_ENV = nil
		;(nil).bbsCount = 0
		userSDKManager.sdkMessageCount, (nil).serviceCount = nil, 0
	end
	if msgType == "community" then
		userSDKManager.sdkMessageCount.bbsCount = info.count
	elseif msgType == "faq" then
		userSDKManager.sdkMessageCount.serviceCount = info.count
	end
	_ENV = info.count
	info.count.msg = "MESSAGE_MAINCITYVIEW_SHOW_COMMUNITYCENTER_MSG"
	info.count.msgCount = userSDKManager.sdkMessageCount.bbsCount + userSDKManager.sdkMessageCount.serviceCount
	info.count.bbsCount = userSDKManager.sdkMessageCount.bbsCount
	info.count.serviceCount = userSDKManager.sdkMessageCount.serviceCount
	SoraDSendMessage(info.count)
end
function userSDKManager_sdkNoticeBoardMessageCallBack(command)
	print("收到命令command = ", command)
	local valueTbl = SoraDStringSplit(command, "@")
	local eventType = tonumber(valueTbl[1])
	local count = tonumber(valueTbl[2])
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_SHOW_BULLETINBOARD_MSG"
	;(nil).eventType = eventType
	;(nil).count = count
	SoraDSendMessage(nil)
end
function userSDKManager_sdkOpenCallBack()
	local openFunc = function(...)
		local gametop = gModuleMgr.getObject("gametop")
		gametop:Logout()
		SoraDShowLoginView()
		print("游戏重新登录回调=========")
	end
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
		openFunc()
	elseif UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android then
		if gIsGameInFrontOrBack then
			openFunc()
		else
			table.insert(userSDKManager.onEnterForegroundEventList, openFunc)
		end
	else
		openFunc()
	end
end
function userSDKManager_sdkExitCallBack()
	app:exit()
end
function userSDKManager_sdkFaceBookShareCallBack(result)
	print("facebook分享回调============")
	SoraDCloseLoading()
	if result and result == 0 then
		print("facebook分享成功============")
		_ENV = "facebook分享成功============"
		;("facebook分享成功============").msg = "MESSAGE_FACEBOOK_SHARE_SUCCESS"
		SoraDSendMessage("facebook分享成功============")
	elseif result and result == 1 then
		print("facebook分享失败============")
		_ENV = "facebook分享失败============"
		;("facebook分享失败============").msg = "MESSAGE_FACEBOOK_SHARE_FAIL"
		SoraDSendMessage("facebook分享失败============")
	elseif result and result == 2 then
		print("facebook分享取消============")
		_ENV = "facebook分享取消============"
		;("facebook分享取消============").msg = "MESSAGE_FACEBOOK_SHARE_CANCEL"
		SoraDSendMessage("facebook分享取消============")
	end
end
function userSDKManager_sdkWhatsAppShareCallBack(result)
	print("facebook分享回调============")
	SoraDCloseLoading()
	if result and result == 0 then
		print("wahtsapp分享成功============")
		_ENV = "wahtsapp分享成功============"
		;("wahtsapp分享成功============").msg = "MESSAGE_WHATSAPP_SHARE_SUCCESS"
		SoraDSendMessage("wahtsapp分享成功============")
	elseif result and result == 1 then
		print("wahtsapp分享失败============")
		_ENV = "wahtsapp分享失败============"
		;("wahtsapp分享失败============").msg = "MESSAGE_WHATSAPP_SHARE_FAIL"
		SoraDSendMessage("wahtsapp分享失败============")
	elseif result and result == 2 then
		print("wahtsapp分享取消============")
		_ENV = "wahtsapp分享取消============"
		;("wahtsapp分享取消============").msg = "MESSAGE_WHATSAPP_SHARE_CANCEL"
		SoraDSendMessage("wahtsapp分享取消============")
	end
end
function userSDKManager_captureProgressCallBack(dataJson)
	local jsonData = json.decode(dataJson)
	local decibel = jsonData.decibel
	local timeInterval = jsonData.timeInterval
	if userSDKManager.audioTarget and userSDKManager.audioTarget.userSDKManager_captureProgressCallBack then
		userSDKManager.audioTarget:userSDKManager_captureProgressCallBack(decibel, timeInterval)
	end
end
function userSDKManager_stopCaptureCallBack(recIdentifier)
	print("userSDKManager_stopCaptureCallBack( recIdentifier )-----·", recIdentifier, ", userSDKManager.audioTarget = ", userSDKManager.audioTarget)
	if userSDKManager.audioTarget and userSDKManager.audioTarget.userSDKManager_stopCaptureCallBack then
		userSDKManager.audioTarget:userSDKManager_stopCaptureCallBack(recIdentifier)
	end
end
function userSDKManager_uploadRecCallBack(dataJson)
	local jsonData = json.decode(dataJson)
	local finished = jsonData.finished
	local localIdentifier = jsonData.localIdentifier
	local remoteIdentifier = jsonData.remoteIdentifier
	if userSDKManager.audioTarget and userSDKManager.audioTarget.userSDKManager_uploadRecCallBack then
		userSDKManager.audioTarget:userSDKManager_uploadRecCallBack(finished, localIdentifier, remoteIdentifier)
	end
end
function userSDKManager_downloadRecCallBack(dataJson)
	local jsonData = json.decode(dataJson)
	local finished = jsonData.finished
	local localIdentifier = jsonData.localIdentifier
	local remoteIdentifier = jsonData.remoteIdentifier
	if userSDKManager.audioTarget and userSDKManager.audioTarget.userSDKManager_downloadRecCallBack then
		userSDKManager.audioTarget:userSDKManager_downloadRecCallBack(finished, localIdentifier, remoteIdentifier)
	end
end
function userSDKManager_playOrStopRecProgressCallBack(dataJson)
	local jsonData = json.decode(dataJson)
	local decibel = jsonData.decibel
	local timeInterval = jsonData.timeInterval
	if userSDKManager.audioTarget and userSDKManager.audioTarget.userSDKManager_playOrStopRecProgressCallBack then
		userSDKManager.audioTarget:userSDKManager_playOrStopRecProgressCallBack(decibel, timeInterval)
	end
end
function userSDKManager_startRecordCallBack()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAIN_RECORD_SCREEN"
	SoraDSendMessage(nil)
end
function userSDKManager_checkIsEmulator_IOS(bool)
	if bool then
		userSDKManager.isEmulator()
	else
		userSDKManager.isNotEmulator()
	end
end
function userSDKManager_checkIsEmulator_Android(bool)
	if bool then
		userSDKManager.isEmulator()
	else
		userSDKManager.isNotEmulator()
	end
end
function userSDKManager.onEnterForegroundEvent(...)
	if next(userSDKManager.onEnterForegroundEventList) ~= nil then
		for _, v in pairs(userSDKManager.onEnterForegroundEventList) do
			if v then
				v()
			end
		end
	end
	userSDKManager.onEnterForegroundEventList, _ENV = pairs(userSDKManager.onEnterForegroundEventList)
end
function userSDKManager.insertNeedCallBack2SDK(info)
	if info and info.viewName and info.func and info.data then
		_ENV = nil
		;(nil).func = info.func
		userSDKManager.need2CallBackEventList[info.viewName], (nil).data = nil, info.data
		return true
	end
	return false
end
function userSDKManager.needCallBack2SDK(viewName)
	if viewName and viewName ~= "" then
		local key = userSDKManager.need2CallBackEventList[viewName]
		if key then
			xpcall(function()
				key.func(key.data)
			end, function()
				print("viewName = ", viewName, "的函数不存在了")
			end)
			userSDKManager.need2CallBackEventList[viewName] = nil
			return true
		end
	end
	return false
end
function UserSDKManager_SdkBindCallBack()
	local checkBind = function()
		print("安卓返回检测用户绑定状态=========")
		_ENV = "安卓返回检测用户绑定状态========="
		;("安卓返回检测用户绑定状态=========").msg = "MESSAGE_LORDINFO_BIND_AWARD"
		SoraDSendMessage("安卓返回检测用户绑定状态=========")
	end
	if gIsGameInFrontOrBack then
		checkBind()
	else
		table.insert(userSDKManager.onEnterForegroundEventList, checkBind)
	end
end
function UserSDKManager_ControlMuteVar(ret)
	dump(ret, "UserSDKManager_ControlMuteVar")
	if "false" == ret then
		if AudioEngine.getEffectsVolume() > 0 then
			gIsGameSoundEffectMuted = false
		end
	elseif "true" == ret then
		gIsGameSoundEffectMuted = true
	end
end
function userSDKManager.popSelectAvatarMenu(...)
end
function userSDKManager_popSelectAvatarMenuSuccess(ret)
	local retTbl = json.decode(ret)
	dump(retTbl, "userSDKManager_popSelectAvatarMenuSuccess")
	if retTbl then
		if retTbl.isSuccess then
			userSDKManager.avatarDiyCfg, _ENV = retTbl, retTbl
			userSDKManager.avatarDiyCfg.status = tonumber(retTbl.status or 0)
			userSDKManager.avatarDiyCfg.uploadTime = tonumber(retTbl.uploadTime or 0)
			userSDKManager_getAvatarLastTimeCallBack(ret)
			_ENV = ret
			ret.msg = "MESSAGE_LORDINFO_AVATAR_UPLOAD_SUCCESS"
			SoraDSendMessage(ret)
			SoraDShowMsgTip(i18n("game_avatar_submit_success_tooltip"))
		else
			local errCode = retTbl.error
			if errCode then
				if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android and (errCode == 1001 or errCode == 1007) then
				elseif UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer and (errCode == 1000 or errCode == 1001) then
				else
					SoraDShowMsgTip(i18n("game_avatar_submit_fail_tooltip"))
				end
			else
				SoraDShowMsgTip(i18n("game_avatar_submit_fail_tooltip"))
			end
		end
	end
	_ENV = SoraDShowMsgTip
	SoraDShowMsgTip.msg = "MESSAGE_LORDINFO_AVATAR_UPDATE"
	SoraDSendMessage(SoraDShowMsgTip)
end
function userSDKManager.getAvatarURL(avatar)
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
		local ret = CSUserSDKManager:getAvatarURL(avatar)
		print("userSDKManager.getAvatarURL ret:", ret)
		return ret
	elseif UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android then
		local ret = CSUserSDKManager:getAvatarURL(avatar)
		print("userSDKManager.getAvatarURL ret:", ret)
		return ret
	elseif UnityEngine.Application.platform == UnityEngine.RuntimePlatform.OSXEditor then
		local baseUrl = "hayyaimage.onemt.co/"
		return "https://" .. string.gsub(baseUrl .. avatar, "//", "/")
	end
end
function userSDKManager.downloadAvatar(_url)
end
function userSDKManager.downloadBigAvatar(_url)
end
function userSDKManager_downloadAvatarCallBack(ret)
	if ret == "false" then
	else
		local valueTbl = SoraDStringsSplit(ret, "@avatar_split@")
		local oriUrl = valueTbl[1]
		local localPath = valueTbl[2]
		if SoraDSetHeadToManager then
			SoraDSetHeadToManager(oriUrl, localPath)
		end
	end
end
function userSDKManager_sdkLoginFailCallback()
	local showMsg = i18n("common_text_1030")
	local msgBoxPanel = SoraDShowMsgBox(showMsg, i18n("common_text_204"), nil, function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			userSDKManager.login("")
		end
	end)
	msgBoxPanel.enableTouchCloseSelf = true
	msgBoxPanel:setName("SocketFailedMsgBox")
end
function userSDKManager_downloadBigAvatarCallBack(ret)
	if ret == "false" then
		if SoraDSetHeadToManager then
			_ENV = nil
			;(nil).msg = "MESSAGE_LORDINFO_BIG_HEAD"
			;(nil).ret = false
			SoraDSendMessage(nil)
		end
	else
		local valueTbl = SoraDStringsSplit(ret, "@avatar_split@")
		local oriUrl = "/"
		local urlTbl = SoraDStringsSplit(valueTbl[1], "/")
		for i, v in ipairs(urlTbl) do
			if v ~= "" then
				if i == #urlTbl then
					oriUrl = oriUrl .. "108x108_" .. v
				else
					oriUrl = oriUrl .. v .. "/"
				end
			end
		end
		local localPath = valueTbl[2]
		if SoraDSetHeadToManager then
			SoraDSetHeadToManager(oriUrl, localPath, true)
			_ENV = oriUrl
			oriUrl.msg = "MESSAGE_LORDINFO_BIG_HEAD"
			oriUrl.avatar = oriUrl
			oriUrl.ret = true
			SoraDSendMessage(oriUrl)
		end
	end
end
function userSDKManager.getAvatarLastTime(...)
	local CDTime = 0
	local status = 0
	local gametop = gModuleMgr.getObject("gametop")
	local playerID = "" .. gametop.playertop_:getPlayerID()
	if userSDKManager.avatarDiyCfg and userSDKManager.avatarDiyCfg.playerID == playerID then
		CDTime = userSDKManager.avatarDiyCfg.uploadTime + 604800 - serviceFunctions.systemTime()
		status = userSDKManager.avatarDiyCfg.status
	else
		_ENV = nil
		;(nil).byUID = true
		local uploadTime = SoraDConfigGet("System:avatarDiyCfg:uploadTime~integer", nil) or 0
		CDTime = uploadTime + 604800 - serviceFunctions.systemTime()
		_ENV = nil
		;(nil).byUID = true
		status = SoraDConfigGet("System:avatarDiyCfg:status~integer", nil) or 0
	end
	print("CDTime = ", CDTime)
	print("status =", status)
	return CDTime, status
end
function userSDKManager_getAvatarLastTimeCallBack(ret)
	dump(ret, "userSDKManager_getAvatarLastTimeCallBack")
	local retTbl = json.decode(ret)
	if retTbl == nil then
		return
	end
	local gametop = gModuleMgr.getObject("gametop")
	local playerID = "" .. gametop.playertop_:getPlayerID()
	local retPlayerID = retTbl.playerID or playerID
	if retPlayerID == playerID then
		userSDKManager.avatarDiyCfg, _ENV = nil, nil
		userSDKManager.avatarDiyCfg.playerID = retPlayerID
		userSDKManager.avatarDiyCfg.status = tonumber(retTbl.status or 0)
		userSDKManager.avatarDiyCfg.uploadTime = tonumber(retTbl.uploadTime or 0)
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("System:avatarDiyCfg:uploadTime~integer", userSDKManager.avatarDiyCfg.uploadTime, nil)
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("System:avatarDiyCfg:status~integer", userSDKManager.avatarDiyCfg.status, nil)
		_ENV = "System:avatarDiyCfg:status~integer"
		;("System:avatarDiyCfg:status~integer").msg = "MESSAGE_LORDINFO_AVATAR_UPDATE"
		SoraDSendMessage("System:avatarDiyCfg:status~integer")
	end
end
function userSDKManager.updateColdDownTime(...)
	if isAndroidOrIsIPhone then
		local gametop = gModuleMgr.getObject("gametop")
		local playerID = tostring(gametop.playertop_:getPlayerID())
		CSUserSDKManager:getAvatarLastTime(playerID)
	end
end
function userSDKManager.reportAvatar(_url)
	CSUserSDKManager:reportAvatar(_url)
end
function userSDKManager_reportAvatarBack(ret)
	SoraDShowMsgTip(i18n("game_avatar_report_success_tooltip"))
end
function userSDKManager_ObbDownloadCallBack(msg)
	print("userSDKManager_ObbDownloadCallBack", msg)
	local info = loadstring("return " .. msg)()
	_ENV = msg
	msg.msg = "MESSAGE_RECEIVE_OBB_MSG"
	msg.data = info
	SoraDSendMessage(msg)
end
function userSDKManager.cleanCallBack2SDK()
	userSDKManager.need2CallBackEventList, _ENV = nil, nil
end
function userSDKManager_SDK2LuaEventDispose(target)
	local valueTbl = SoraDStringSplit(target, "@")
	local behavior = valueTbl[1]
	local isDelay = valueTbl[2] == "true" and true or false
	for k, v in pairs(userSDKManager.SDK2LuaEventListEnum) do
		if behavior == k then
			if isDelay then
				table.insert(userSDKManager.onEnterForegroundEventList, v)
			elseif gIsGameInFrontOrBack then
				v()
			else
				table.insert(userSDKManager.onEnterForegroundEventList, v)
			end
		end
	end
end
function userSDKManager.event_openRechargeView()
	print("event_openRechargeView")
	if not SoraDSearchPanelFromManagerByName("rechargeView") then
		SoraDCreatePanel("rechargeView"):show()
	end
end
function userSDKManager.event_openEventCenterView()
	print("event_openEventCenterView")
	if not SoraDSearchPanelFromManagerByName("eventCenterView") then
		SoraDCreatePanel("eventCenterView"):show()
	end
end
function userSDKManager.event_openGameMall()
	print("event_openGameMall")
	if not SoraDSearchPanelFromManagerByName("bagView") then
		local panel = SoraDCreatePanel("bagView")
		panel:initShowBtn(false)
		panel:show()
	end
end
function userSDKManager.event_openNoticeBorad()
	print("event_openNoticeBorad")
	userSDKManager.openNoticeBorad()
end
function userSDKManager.event_openMailView()
	print("event_openMailView")
	if not SoraDSearchPanelFromManagerByName("mailView") then
		local mailView = SoraDCreatePanel("mailView")
		mailView:show()
		mailView:initWithData(nil)
	end
end
function userSDKManager.event_showAchievements()
	print("event_rankingsView")
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	if curLevel < CASTLE_LV6_LIMITED then
		SoraDShowMsgTip(i18n("notice_0115"), nil, button)
	elseif not SoraDSearchPanelFromManagerByName("rankingsView") then
		SoraDCreatePanel("rankingsView"):show()
	end
end
local _sdkVersion
function userSDKManager.getAndroidSDKVersion()
	print("_sdkVersion", _sdkVersion)
	return _sdkVersion
end
function _ENV()
	print("_sdkVersion", _sdkVersion)
	return _sdkVersion
end
;(function()
	print("_sdkVersion", _sdkVersion)
	return _sdkVersion
end).openRechargeView = userSDKManager.event_openRechargeView
;(function()
	print("_sdkVersion", _sdkVersion)
	return _sdkVersion
end).openEventCenterView = userSDKManager.event_openEventCenterView
;(function()
	print("_sdkVersion", _sdkVersion)
	return _sdkVersion
end).openGameMall = userSDKManager.event_openGameMall
;(function()
	print("_sdkVersion", _sdkVersion)
	return _sdkVersion
end).openNoticeBorad = userSDKManager.event_openNoticeBorad
;(function()
	print("_sdkVersion", _sdkVersion)
	return _sdkVersion
end).openMailView = userSDKManager.event_openMailView
userSDKManager.SDK2LuaEventListEnum, (function()
	print("_sdkVersion", _sdkVersion)
	return _sdkVersion
end).showAchievements = function()
	print("_sdkVersion", _sdkVersion)
	return _sdkVersion
end, userSDKManager.event_showAchievements
function userSDKManager.logEventForNewAccount(event, eventData)
	if not SoraDGetCtrl("lordInfoCtrl"):isNewAccount() then
		return
	end
	print("logEventForNewAccount", event, eventData.target)
	userSDKManager.logEvent(event, eventData)
end
userSDKManager.AdvertisingStrategy, _ENV = function(event, eventData)
	if not SoraDGetCtrl("lordInfoCtrl"):isNewAccount() then
		return
	end
	print("logEventForNewAccount", event, eventData.target)
	userSDKManager.logEvent(event, eventData)
end, function(event, eventData)
	if not SoraDGetCtrl("lordInfoCtrl"):isNewAccount() then
		return
	end
	print("logEventForNewAccount", event, eventData.target)
	userSDKManager.logEvent(event, eventData)
end
function userSDKManager.getAdvertisingStrategy()
	local isReport = SoraDConfigGet("System:AdvertisingStrategy:Report~bool") or false
	print(isReport, "isReport", "getAdvertisingStrategy")
	if not IsArClient or isReport then
		return
	end
	if isAndroidOrIsIPhone then
		CSUserSDKManager:getAdvertisingStrategy()
	end
end
function userSDKManager_getAdvertisingStrategy(dataJson)
	local data = json.decode(dataJson)
	dump(data, "data--getAdvertisingStrategy", 10)
	if data.isMatch then
		local isReport = SoraDConfigGet("System:AdvertisingStrategy:Report~bool") or false
		print(isReport, "isReport", "userSDKManager_getAdvertisingStrategy")
		if not isReport then
			_ENV = print
			_UPVALUE4_, print.params, _ENV, print.requestEvent = isReport, isReport, isReport, "MayPay"
			print.platforms, isReport[1] = isReport, "OneMT"
			print.platforms, isReport[2] = isReport, "Facebook"
			print.platforms, isReport[3] = isReport, "Firebase"
			print.platforms, isReport[4] = isReport, "Adjust"
			local args = print
			userSDKManager.report2firebase("reportCustomEvent", args)
			SoraDConfigSet("System:AdvertisingStrategy:Report~bool", true)
		end
	end
end
function userSDKManager.visitorRegister(code)
	userSDKManager.newStartCode = code
	if isAndroidOrIsIPhone then
		CSUserSDKManager:visitorRegister()
	end
end
function userSDKManager_visitorRegister(dataJson)
	local data = json.decode(dataJson)
	local userId = data.userId
	local authId = data.authId
	local deviceId = data.deviceId
	print("userSDKManager_visitorRegister", userId, authId, deviceId)
	dump(data, "data--getAdvertisingStrategy", 10)
	if data.userId then
		userSDKManager.userid = userId
		userSDKManager.deviceId = deviceId
		userSDKManager.authId = authId
		_ENV = 10
		;(10).byLTID = true
		SoraDConfigSet("Game:GameSettingView:newStartCode~string", userSDKManager.newStartCode, 10)
		local gametop = gModuleMgr.getObject("gametop")
		gametop:Logout()
		SoraDShowLoginView()
		SoraDStartLoginServer()
	else
		local errorCode = data.errorCode
		local errorMsg = data.errorMsg
		print(errorCode, errorMsg)
		SoraDShowMsgTip(errorMsg)
	end
end
function userSDKManager.getSafePasswordStatus(callback)
	if not IsArClient or not isAndroidOrIsIPhone then
		return
	end
	userSDKManager.secondaryStatusCallback = callback
	CSUserSDKManager:getSafePasswordStatus()
end
function userSDKManager.checkSafePassword(password, callback)
	if not IsArClient or not isAndroidOrIsIPhone then
		return
	end
	userSDKManager.secondaryCheckCallback = callback
	CSUserSDKManager:checkSafePassword(password)
end
function userSDKManager.showSafePasswordSettingView()
	if isAndroidOrIsIPhone then
		CSUserSDKManager:showSafePasswordSettingView()
	end
end
function userSDKManager.showForgotSafePasswordView()
	if isAndroidOrIsIPhone then
		CSUserSDKManager:showForgotSafePasswordView()
	end
end
function UserSDKManager_getSafePasswordStatusComplete(ret)
	dump(ret, "UserSDKManager_getSafePasswordStatusComplete")
	if "open" == ret then
		userSDKManager.isSecondaryLockShow = true
		userSDKManager.isSecondaryLockEnable = true
	elseif "close" == ret then
		userSDKManager.isSecondaryLockShow = true
		userSDKManager.isSecondaryLockEnable = false
	else
		userSDKManager.isSecondaryLockEnable = false
		userSDKManager.isSecondaryLockShow = false
		print("安全码状态请求失败:", ret)
	end
	if userSDKManager.secondaryStatusCallback then
		userSDKManager.secondaryStatusCallback()
		userSDKManager.secondaryStatusCallback = nil
	end
end
function UserSDKManager_checkSafePasswordComplete(ret)
	local results = 0
	dump(ret, "UserSDKManager_checkSafePasswordComplete")
	if "success" == ret then
		results = 1
	elseif "BUSINESS_SAFE_PASSWORD_DISABLED" == ret then
		results = 1
	elseif "BUSINESS_SAFE_PASSWORD_INCORRECT" == ret then
		results = 2
	elseif "BUSINESS_SAFE_PASSWORD_FORBIDDEN" == ret then
		results = 3
	else
		results = 2
	end
	if userSDKManager.secondaryCheckCallback then
		userSDKManager.secondaryCheckCallback(results)
	end
	userSDKManager.secondaryCheckCallback = nil
end
function userSDKManager.isNeedVerify()
	return userSDKManager.isSecondaryLockEnable
end
function userSDKManager.getIsSecondaryLockShow()
	return IsArClient and userSDKManager.isSecondaryLockShow
end
function userSDKManager.syncSecondaryLockStatus()
	if not isSDKLogin then
		return
	end
	local isSdkSwitchOn = userSDKManager.isNeedVerify()
	local settingCtrl = SoraDGetCtrl("settingCtrl")
	local isServerSwitchOn = settingCtrl:checkValue(gSettingKeyType.passwdVerify)
	if not isSdkSwitchOn and isSdkSwitchOn ~= isServerSwitchOn then
		local status = isSdkSwitchOn and gStatus.YES or gStatus.NO
		settingCtrl:checkValue(gSettingKeyType.passwdVerify)
		settingCtrl:setKeyValue(gSettingKeyType.passwdVerify, status)
	end
end
function userSDKManager.showMaintainNotice(callback)
	if isAndroidOrIsIPhone then
		userSDKManager.maintainCallback = callback
		CSUserSDKManager:showMaintainNotice(tostring(SoraDGetPlayerID()), "0", tostring(SoraDGetCtrl("lordInfoCtrl"):getMapSourceKid()), SoraDGetDefaultLanguage())
	end
end
function userSDKManager_maintain_callBack()
	if userSDKManager.maintainCallback then
		userSDKManager.maintainCallback()
		userSDKManager.maintainCallback = nil
	end
end
function userSDKManager.closeMaintainNotice()
	if isAndroidOrIsIPhone then
		CSUserSDKManager:closeMaintainNotice()
	end
end
function userSDKManager.showNaviNotice(isAuto)
	if isAndroidOrIsIPhone and isSDKLogin == true then
		CSUserSDKManager:showNaviNotice(tostring(SoraDGetPlayerID()), "0", tostring(SoraDGetCtrl("lordInfoCtrl"):getMapSourceKid()), SoraDGetDefaultLanguage(), isAuto or false)
	end
end
function userSDKManager.preload()
	if isAndroidOrIsIPhone and isSDKLogin == true then
		CSUserSDKManager:preload(tostring(SoraDGetPlayerID()), "0", tostring(SoraDGetCtrl("lordInfoCtrl"):getMapSourceKid()), SoraDGetDefaultLanguage())
	end
end
function userSDKManager.getUserParams()
	if isAndroidOrIsIPhone then
		local jsonInfo = CSUserSDKManager:getUserParams(tostring(SoraDGetPlayerID()), "0", tostring(SoraDGetCtrl("lordInfoCtrl"):getMapSourceKid()), SoraDGetDefaultLanguage())
		if not jsonInfo or not json.decode(jsonInfo) then
			local isAndroidOrIsIPhone, info = json.decode(jsonInfo), json.decode(jsonInfo)
		end
		return info
	end
end
function userSDKManager.registerUnreadCountListener(callback)
	if isAndroidOrIsIPhone then
		userSDKManager.unreadCountCallback = callback
		CSUserSDKManager:registerUnreadCountListener()
	end
end
function userSDKManager_unreadCount_callBack(unreadCount)
	if userSDKManager.unreadCountCallback then
		userSDKManager.unreadCountCallback(unreadCount)
	end
end
function userSDKManager.registerActionCallback(callback)
	if isAndroidOrIsIPhone then
		userSDKManager.actionJumpCallback = callback
		CSUserSDKManager:registerActionCallback()
	end
end
function userSDKManager_action_callBack(dataJson)
	local dataUserInfo = json.decode(dataJson)
	local actionType = dataUserInfo.actionType
	local actionValue = dataUserInfo.actionValue
	if userSDKManager.actionJumpCallback then
		userSDKManager.actionJumpCallback(actionType, actionValue)
	end
end
function userSDKManager_audio_callBack()
	local chatMgrs = include("chatMgrs")
	local chatAudioMgr = gChatMgrs:getMgr("chatAudioMgr")
	chatAudioMgr:setAudioPermission(true)
end
function userSDKManager.isDebug()
	return device.platform == "mac" or userSDKManager.isBeta() or userSDKManager.isGameDevelop() or false
end
return userSDKManager
