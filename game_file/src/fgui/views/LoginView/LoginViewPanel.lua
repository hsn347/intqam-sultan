local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LoginViewPanel = class("LoginViewPanel", baseFguiPanel)
function LoginViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("LoginViewPanel:ctor", self.viewName)
	if G_IS_UNITY then
		SoraDGetDefaultLanguage()
		SoraDSetDefaultLanguage()
	end
end
function LoginViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "LoginView"
	end
	return self._packageList
end
function LoginViewPanel:onInit()
	self._isOnInited = false
	local devicePerformanceUtil = require("app.devicePerformanceUtil")
	devicePerformanceUtil.setQualitySetting()
	CSUserSDKManager:SetupOutputCategoryForMic(true)
	if not g_is_preparedFont then
		g_is_preparedFont = true
		if SoraDIsMemoryLowLevel() then
			local defualtFont = CS.FairyGUI.FontManager.GetFont("NotoNaskhArabicDiy-Regular")
			defualtFont.keepCrisp = false
		end
		local scale = 1.125 / (display.widthInPixels / display.width)
		for i = 1, 20 do
			self:runAction(ffa.seq(ffa.delay(0.016666666666666666 * i), ffa.callFunc(function()
				self.fields.prepare_font:setFontSize((90 - 2 * i) * scale)
				self.fields.prepare_font:setString("abcdefghijklmnopqrstuvwxyz0123456789")
			end)))
		end
	end
	self.newLoginModel = true
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	cc.UserDefault:getInstance():setBoolForKey("System:RAMADAN_SWITCH~bool", self.newLoginModel)
	self.isHideCurrentSceneView = true
	userSDKManager.resetTimeInfo()
	userSDKManager.registCallBackFunc()
	userSDKManager.setChangeOrUpdatePasswordBlock()
	notificationManager.registerNotification()
	if device.platform == "android" then
		_ENV = "System:RAMADAN_SWITCH~bool"
		userSDKManager.logEvent(gSDKDef.TDonEvent.require_permssin_success, "System:RAMADAN_SWITCH~bool")
	end
	self:initVars()
	self:initView()
	self:initUpdateInfo()
	self:setMainSenceMsgListener()
	self:setVersion2Top()
	self:initSpineAnimation()
	self.testArrayImages, _ENV = self.initSpineAnimation, self.initSpineAnimation
end
function LoginViewPanel:onShow()
	print("=======LoginViewPanel:onShow")
	release_print("finishLoadImages ", device.platform, DEBUG)
	self._isOnInited = true
	self:startPatchUpdate()
end
function LoginViewPanel:onHide()
	print("=======LoginViewPanel:onHide")
end
function LoginViewPanel:onDispose()
	print("=======LoginViewPanel:onDispose")
	local packageManager = require("fgui.base.packageManager")
	packageManager:clearUnusedPackage()
	display.removeUnusedSpriteFrames()
end
function LoginViewPanel:initVars()
	Global_isLoginNeedLoading = false
	GAME_LOGIN_FAIL_COUNT = 0
	self.initFinishCount = 0
	self.showViewType = VIEW_TYPE_CITY
end
function LoginViewPanel:setMainSenceMsgListener()
	if display.getRunningScene() and display.getRunningScene().name == "MainScene" then
		display.getRunningScene():onMessageListener()
	end
end
function LoginViewPanel:initView()
	local logo = self.fields.logo_en
	if IsArClient then
		self:initKOHView()
		logo = SoraDFIsRA() and self.fields.logo_ar or self.fields.logo_en
	else
		self:initROSView()
	end
	if display.rheight < 960 then
		logo:setScale(0.6)
	else
		logo:setScale(0.78)
	end
	self.fields.Center_pyramid:setVisible(false)
	self.fields.Text_tips:setVisible(false)
	self.fields.Button_box:addClickEventListener(handler(self, self.onClickUpdateFix))
	self.fields.Button_box:setTitle(i18n("download_first_description_013"))
end
function LoginViewPanel:initKOHView()
	self.controllers.logo:setSelectedIndex(SoraDFIsRA() and 0 or 1)
	local logo = SoraDFIsRA() and self.fields.logo_ar or self.fields.logo_en
	if not SoraDFIsRA() then
		logo:setPositionY(120)
	else
		logo:setPositionY(142)
	end
	if display.rheight > 1136 then
		logo:setPositionY(200)
	end
end
function LoginViewPanel:initROSView()
	self.controllers.logo:setSelectedIndex(1)
	self.fields.logo_en:setPositionY(120)
end
function LoginViewPanel:startObbLoad()
	print("LoginViewPanel startObbLoad")
	self:switchNextLoading(gLoginRangeTbl.obbUpdate)
	local CSOBBManager = CS.Sultan.Manager.OBBManager.GetInstance()
	CSOBBManager:startOBBAction()
end
function LoginViewPanel:checkObbExported()
	return true
end
function LoginViewPanel:startValidateObb()
	print("LoginViewPanel startValidateObb")
	self:switchNextLoading(gLoginRangeTbl.obbValidate)
end
function LoginViewPanel:validateObbSuccess()
	print("LoginViewPanel downloadObbSuccess")
	self:finishRange(gLoginRangeTbl.obbValidate)
	self:runAction(ffa.seq(ffa.delay(0), ffa.callFunc(function()
		self:startGame()
	end)))
end
function LoginViewPanel:waitForAttGranted()
	print("onAttGrantedComplete")
	local ok, ret = luaoc.callStaticMethod("UserSDKManager", "isWaitAttGranted", nil)
	print("isWaitAttGranted back", ok, ret)
	if ok and ret then
		self.proxy:addIosAttGrantedFinEvent()
	else
		self:onAttGrantedComplete()
	end
end
function LoginViewPanel:onAttGrantedComplete()
	print("onAttGrantedComplete")
	self.proxy:removeIosAttGrantedFinEvent()
end
function LoginViewPanel:startPatchUpdate()
	self:switchNextLoading(gLoginRangeTbl.gameUpdate)
	self:start2CheckVersion()
end
function LoginViewPanel:start2CheckVersion(...)
	self:loadBar(1)
	require("app.includes.requireFiles")
	local is64bit
	if device.platform == "android" and cc.Device.is64Bit then
		is64bit = cc.Device:is64Bit()
	end
	_ENV = cc.Device
	cc.Device.is64bit = is64bit
	cc.Device.isGooglePlayGamePC = SoraDIsGooglePlayGamePC() and 1 or 0
	dump(cc.Device, "gSDKDef.TDonEvent.star_game")
	_ENV = "gSDKDef.TDonEvent.star_game"
	;("gSDKDef.TDonEvent.star_game").is64bit = is64bit
	;("gSDKDef.TDonEvent.star_game").isGooglePlayGamePC = SoraDIsGooglePlayGamePC() and "1" or "0"
	userSDKManager.logEvent(gSDKDef.TDonEvent.star_game, "gSDKDef.TDonEvent.star_game")
	if self.isUpdateReload or device.platform == "mac" or device.platform == "windows" then
		self:updateSucess()
	else
		require("app.game.updateModule.updateModule"):getInstance():checkVersion()
		_ENV = "gSDKDef.TDonEvent.star_game"
		userSDKManager.logEvent(gSDKDef.TDonEvent.star_check_innerVer, "gSDKDef.TDonEvent.star_game")
	end
end
local MAX_SHOW_ERROR = 0
function LoginViewPanel:onReceiveObbMsg(target, data)
	if not data.data then
		local _ENV, info = data.data, data.data
	end
	if info.msgCode == "UpdateProgress" then
		print("info.msgCode UpdateProgress")
		self:loadBar(1 + tonumber(info.progressRate) / 100 * 99)
	elseif info.msgCode == "startDownloadObb" then
		_ENV = 1 + tonumber(info.progressRate) / 100 * 99
		userSDKManager.logEvent(gSDKDef.TDonEvent.start_obb_download, 1 + tonumber(info.progressRate) / 100 * 99)
		self:switchNextLoading(gLoginRangeTbl.obbUpdate)
	elseif info.msgCode == "exportObbStart" then
		_ENV = gLoginRangeTbl.obbUpdate
		userSDKManager.logEvent(gSDKDef.TDonEvent.start_obb_export, gLoginRangeTbl.obbUpdate)
		self:switchNextLoading(gLoginRangeTbl.obbValidate)
	elseif info.msgCode == "exportObbSuccess" then
		_ENV = gLoginRangeTbl.obbValidate
		userSDKManager.logEvent(gSDKDef.TDonEvent.export_obb_success, gLoginRangeTbl.obbValidate)
		self:validateObbSuccess()
	elseif info.msgCode == "exportObbFail" then
		_ENV = gLoginRangeTbl.obbValidate
		userSDKManager.logEvent(gSDKDef.TDonEvent.export_obb_fail, gLoginRangeTbl.obbValidate)
		self.alradyShowNum = self.alradyShowNum == nil and 1 or self.alradyShowNum + 1
		self.alradyShow = self.alradyShowNum > MAX_SHOW_ERROR
		if _G.gSvrConfig.isReview or self.alradyShow then
			self:validateObbSuccess()
		elseif not self.obbMsgBox then
			_ENV = nil
			;(nil).canNotClose = true
			self.obbMsgBox = SoraDShowMsgBox(i18n("login_text_14"), i18n("common_text_054"), nil, function(exitType)
				self.obbMsgBox = nil
				self:startObbLoad()
			end, nil)
		end
	elseif info.msgCode == "downloadSuccess" then
		_ENV = i18n("common_text_054")
		userSDKManager.logEvent(gSDKDef.TDonEvent.download_obb_success, (i18n("common_text_054")))
	elseif info.msgCode == "validataObbError" then
		_ENV = i18n("common_text_054")
		i18n("common_text_054").errCode = info.errorCode
		userSDKManager.logEvent(gSDKDef.TDonEvent.validata_obb_error, (i18n("common_text_054")))
	elseif info.msgCode == "validataObbSuccess" then
		_ENV = i18n("common_text_054")
		userSDKManager.logEvent(gSDKDef.TDonEvent.validata_obb_success, (i18n("common_text_054")))
	elseif info.msgCode == "DownloadError" then
		_ENV = i18n("common_text_054")
		i18n("common_text_054").errCode = info.errorCode
		userSDKManager.logEvent(gSDKDef.TDonEvent.download_obb_error, (i18n("common_text_054")))
		print("info.msgCode compare error")
		self.alradyShowNum = self.alradyShowNum == nil and 1 or self.alradyShowNum + 1
		self.alradyShow = self.alradyShowNum > MAX_SHOW_ERROR
		if _G.gSvrConfig.isReview or self.alradyShow then
			self:validateObbSuccess()
		elseif not self.obbMsgBox then
			_ENV = nil
			;(nil).canNotClose = true
			self.obbMsgBox = SoraDShowMsgBox(i18n("login_text_14"), i18n("common_text_054"), nil, function(exitType)
				self.obbMsgBox = nil
				self:startObbLoad()
			end, nil)
		end
	end
end
function LoginViewPanel:initUpdateInfo()
	self.isUpdateReload = true
	if ng_sys_getIsOpen then
		self.isUpdateReload = ng_sys_getIsOpen()
	end
	GAME_VERSION = "99.99.001"
	if ng_sys_setPath then
		GAME_VERSION = require("app.game.updateModule.updateModule"):getInstance():getVersion()
	end
end
function LoginViewPanel:startGameAction()
	self:runAction(ffa.seq(ffa.delay(0), ffa.callFunc(function()
		self:startGame()
	end)))
end
function LoginViewPanel:updateSucess()
	if not self._isOnInited then
		return
	end
	self:finishRange(gLoginRangeTbl.gameUpdate)
	self:setVersion2Top()
	self.initFinishCount = self.initFinishCount + 1
	if device.platform == "android" and not self:checkObbExported() then
		self:startObbLoad()
	else
		self:runAction(ffa.seq(ffa.delay(0), ffa.callFunc(function()
			self:startGame()
		end)))
	end
end
function LoginViewPanel:onDownloadProgress(target, data)
	self:loadBar(1 + data.percent / 100 * 99)
end
function LoginViewPanel:onPreDownloadProgress(target, data)
	local total = data.total
	local downloaded = data.downloaded
	if not (total and downloaded) or not (0 < total) then
		return
	end
	local percent = downloaded / total * 100
	local cur = 1 + percent / 100 * 99
	self:loadBar(cur)
	if 0 < cur then
		local strDownload = SoraDConvertNumberWithUnit(downloaded)
		local strTotal = SoraDConvertNumberWithUnit(total)
		_ENV = nil
		;(nil).var1 = strDownload
		;(nil).var2 = strTotal
		self.fields.Text_loginNote:setString(i18n("download_first_description_03", nil))
	end
end
function LoginViewPanel:onPreDownloadProgressUNZip(target, data)
	local total = data.total
	local downloaded = data.downloaded
	if not (total and downloaded) or not (0 < total) then
		return
	end
	local percent = downloaded / total * 100
	local cur = 1 + percent / 100 * 99
	self:loadBar(cur)
	if 0 < cur then
		local strDownload = string.formatnumberthousands(downloaded)
		local strTotal = string.formatnumberthousands(total)
		_ENV = nil
		;(nil).var1 = strDownload
		;(nil).var2 = strTotal
		self.fields.Text_loginNote:setString(i18n("download_first_description_016", nil))
	end
end
local format_version = function(version)
	return version:gsub("^(%d+)%.(%d+)%.(%d+)$", function(major, minor, patch)
		return string.format("%s.%s.001", major, minor)
	end)
end
function LoginViewPanel:setVersion2Top(...)
	local version = GAME_VERSION
	if not userSDKManager.isBeta() and not userSDKManager.isGameDevelop() then
		version = format_version(GAME_VERSION) or GAME_VERSION
	end
	self.fields.Text_version:setString(version)
	if self.newLoginModel and IsArClient then
		self.fields.Text_version:setColor(cc.c3b(255, 255, 255))
	else
		self.fields.Text_version:setColor(IsArClient and cc.c3b(0, 0, 0) or cc.c3b(255, 255, 255))
	end
end
function LoginViewPanel:loadWhenTheRightRange(rangeid, cur)
	if self:getLoadRangeID() == rangeid then
		self:loadBar(cur)
	else
		self.loginRangeState[rangeid].ready = cur
	end
end
function LoginViewPanel:switchNextLoading(rangeid)
	if not self.initLoadingRange then
		_ENV = self.initLoadingRange
		_ENV = nil
		;(nil).ready = 0
		;(nil).startLang = i18n("common_text_3853")
		;(nil).loadLang = i18n("common_text_3853")
		self.initLoadingRange[gLoginRangeTbl.obbUpdate], (nil).doneLang = nil, i18n("login_text_12")
		_ENV = nil
		;(nil).ready = 0
		;(nil).startLang = i18n("login_text_13")
		;(nil).loadLang = i18n("login_text_13")
		self.initLoadingRange[gLoginRangeTbl.obbValidate], (nil).doneLang = nil, i18n("login_text_15")
		_ENV = nil
		;(nil).ready = 0
		;(nil).startLang = i18n("login_text_1")
		;(nil).loadLang = i18n("login_text_2")
		self.initLoadingRange[gLoginRangeTbl.gameUpdate], (nil).doneLang = nil, i18n("login_text_3")
		_ENV = nil
		;(nil).ready = 0
		;(nil).startLang = i18n("login_text_4")
		;(nil).loadLang = i18n("login_text_5")
		self.initLoadingRange[gLoginRangeTbl.loadImages], (nil).doneLang = nil, i18n("login_text_6")
		_ENV = nil
		;(nil).ready = 0
		;(nil).startLang = i18n("login_text_7")
		;(nil).loadLang = i18n("login_text_8")
		self.loginRangeState, self.initLoadingRange[gLoginRangeTbl.connectServer], (nil).doneLang = self.initLoadingRange, nil, i18n("login_text_9")
		self.curLoadingRange = gLoginRangeTbl.gameUpdate
		self.initLoadingRange = true
	else
		self.curLoadingRange = rangeid
	end
	self:loadBar(self.loginRangeState[self.curLoadingRange].ready)
	if 0 >= self.loginRangeState[self.curLoadingRange].ready then
		self.fields.Text_loginNote:setString(self.loginRangeState[self.curLoadingRange].startLang)
	else
		self.fields.Text_loginNote:setString(self.loginRangeState[self.curLoadingRange].loadLang)
	end
end
function LoginViewPanel:finishRange(rangeid)
	self:loadBar(100)
	self.fields.Text_loginNote:setString(self.loginRangeState[rangeid].doneLang)
end
function LoginViewPanel:getLoadRangeID(...)
	return self.curLoadingRange
end
function LoginViewPanel:loadBar(cur)
	if not cur then
		return
	end
	self.fields.login_progress:setPercent(cur, SoraDFValueSuit(math.ceil(cur), "%"))
	if 0 < cur then
		self.fields.Text_loginNote:setString(self.loginRangeState[self.curLoadingRange].loadLang)
	end
end
function LoginViewPanel:AutoLoadingBar(ePercent, frame)
	if self.loadImageFinsh then
		local actionLoading
		local stopTimer = function()
			if actionLoading then
				SoraDManagerRemoveTimer(self, actionLoading)
			end
		end
		self.isServerReturn = false
		stopTimer()
		actionLoading = SoradCreateTimer(self, function()
			if self.isServerReturn or self:getPercent() > ePercent then
				stopTimer()
			elseif self:getPercent() <= ePercent then
				self:loadBar(self:getPercent() + frame)
			end
		end, true)
	end
end
function LoginViewPanel:getPercent()
	return self.fields.login_progress:getValue()
end
function LoginViewPanel:initSpineAnimation()
	if IsArClient then
		self.fields.Usm_1:clearEffect()
		self.fields.Usm_1:setPrivewImage("SinglePicture/loginInitBg_koh.png", cc.size(852, 1386), true)
		self.fields.Usm_1:setEffectPath("login202607.usm")
	else
		self.fields.Usm_1:clearEffect()
		self.fields.Usm_1:setPrivewImage("SinglePicture/loginInitBg_ros_ex.png", cc.size(852, 1386), true)
		self.fields.Usm_1:setEffectPath("login202607.usm")
	end
	local winSize = cc.Director:getInstance():getWinSize()
	if winSize.height > self.fields.Usm_1:getHeight() then
		self.fields.Usm_1:setScale(winSize.height / self.fields.Usm_1:getHeight())
	end
end
function LoginViewPanel:loadCommonImages()
	self.loadImageFinsh = false
	self:switchNextLoading(gLoginRangeTbl.loadImages)
	if not SoraDHDResManager.isInit then
		SoraDInitHDResManager()
	end
	self:loadBar(1)
	local loadImageIndex = 0
	local arrayImagesPath = clone(commonArrayImagesPath)
	local format = "png"
	if device.platform == "android" then
		format = nil
	end
	print("开始加载资源:", #arrayImagesPath)
	for i, v in ipairs(arrayImagesPath) do
		self.testArrayImages[v.name .. ".plist"] = true
	end
	for k, v in pairs(arrayImagesPath) do
		local plistName = v.name .. ".plist"
		local imageName = getImageFileNameByPlatform(v.name, v.format)
		print("imageName", imageName)
		display.addSpriteFrames(plistName, imageName, function(plist, image)
			if not self.__cname then
				print("对象已经被释放")
				return
			end
			print("loadImageIndex " .. loadImageIndex)
			self.testArrayImages[plistName] = nil
			self:loadBar(1 + loadImageIndex / #arrayImagesPath * 99)
			if loadImageIndex >= #arrayImagesPath then
				self:finishRange(gLoginRangeTbl.loadImages)
				local sp = display.newSprite("#ltzd.png")
				sp:setPosition(-500, -500)
				sp:addTo(self)
				self.initFinishCount = self.initFinishCount + 1
				if not self.firstEnterLoginRange then
					self:switchNextLoading(gLoginRangeTbl.connectServer)
					self.firstEnterLoginRange = true
				end
				self.loadImageFinsh = true
			end
		end)
	end
end
function LoginViewPanel:loadAudios()
end
function LoginViewPanel:startGame()
	self:loadCommonImages()
	self:loadAudios()
	criAdxAux.loadLanguageAcb()
	self:startTimer()
	self:checkMaintainInfo()
	paymentManager.switchBullets()
	deepLinking.init()
	if userSDKManager.isBeta() or userSDKManager.isGameDevelop() then
		self.controllers.loginInput:setSelectedIndex(1)
		self.fields.inputNode:setMode(1, self)
	elseif userSDKManager.isGameService() then
		self.controllers.loginInput:setSelectedIndex(1)
		self.fields.inputNode:setMode(3, self)
	else
		self.controllers.loginInput:setSelectedIndex(0)
		userSDKManager.checkIsEmulator(function(...)
			print("=============开始使用sdk登录=============")
			userSDKManager.login("")
		end, function(...)
			print("============我是模拟器，禁止登陆==========")
			userSDKManager.login("")
		end)
	end
end
function LoginViewPanel:enterGame()
	print("开始进入游戏----")
	paymentManager.init()
	paymentManager.loadProducts()
	_ENV = nil
	;(nil).byUID = true
	local fConfig = SoraDConfigGet("Game:GetCrashlytics:track~table", nil)
	if fConfig.isAgree or userSDKManager.isBeta() or userSDKManager.isGameDevelop() then
		userSDKManager.setFabricEnable(true)
	end
	local gametop = gModuleMgr.getObject("gametop")
	local kindomID = gametop.playertop_:getKingdomID() or 0
	SoraDConfigSet("Game:LoginView:setKingdomID~integer", kindomID)
	_ENV = kindomID
	kindomID.byUID = true
	GLOBAL_GAME_RECHARGE_MODE = SoraDConfigGet("Game:GameOptionsView:recharge~bool", kindomID) or false
	self:resetSearchMonsterRecord()
	self:resetIceHuntingRecord()
	self:setStarBuildMiracleLv()
	local noticeCtrl = gametop.playertop_:getModule("noticeCtrl")
	noticeCtrl:setLanguage(GameLanguageCopy)
	notificationManager.removeAllNotification()
	paymentManager.start2PostGameServer4FinishTransaction()
	clientEventMgr.initialize()
	clientEventMgr.getEventStateInfo()
	local showViewType = self.showViewType
	local otherData
	local worldMapDefine = include("worldMapDefine")
	if worldMapDefine.isInWar() or worldMapDefine.isSwitchAnchorMode() then
		showViewType = VIEW_TYPE_MAP
	else
		local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
		local nebulaAllStarUtil = include("nebulaAllStarUtil")
		if nebulaAllStarCtrl:getIsViewer() then
			_ENV, showViewType = nebulaAllStarCtrl:getIsViewer(), VIEW_TYPE_MAP
			nebulaAllStarCtrl:getIsViewer().kingdomID = nebulaAllStarUtil.getKindomIDStart()
			otherData, nebulaAllStarCtrl:getIsViewer().tilePoint = nebulaAllStarCtrl:getIsViewer(), nebulaAllStarUtil.getCampBuildingPos()
		end
	end
	_ENV = include("nebulaAllStarUtil")
	include("nebulaAllStarUtil").msg = "MESSAGE_MAINSCEN_LOGINSUCCESS"
	include("nebulaAllStarUtil").showViewType = showViewType
	include("nebulaAllStarUtil").otherData = otherData
	SoraDSendMessage((include("nebulaAllStarUtil")))
end
function LoginViewPanel:resetIceHuntingRecord()
	_ENV = nil
	;(nil).byUID = true
	local result = SoraDConfigGet("Game:worldMapView:iceHuntingLVRange~string", nil)
	if result ~= "none" then
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:worldMapView:iceHuntingLVRange~string", result, nil)
	else
		_ENV = ","
		;(",").byUID = true
		SoraDConfigSet("Game:worldMapView:iceHuntingLVRange~string", 1 .. "," .. 1, ",")
	end
end
function LoginViewPanel:resetSearchMonsterRecord()
	SoraDConfigSet("Game:worldMapView:ResourceType~integer", 0)
	SoraDConfigSet("Game:worldMapView:ResourceLV~integer", 0)
	local gametop = gModuleMgr.getObject("gametop")
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	_ENV = nil
	;(nil).byUID = true
	local result = SoraDConfigGet("Game:worldMapView:monsterLVRange~string", nil)
	if result ~= "none" then
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:worldMapView:monsterLVRange~string", result, nil)
	else
		local min, max = tonumber(kingdomMapCtrl:getMaxCanKillLevel()), tonumber(kingdomMapCtrl:getMaxCanKillLevel())
		_ENV = ","
		;(",").byUID = true
		SoraDConfigSet("Game:worldMapView:monsterLVRange~string", min .. "," .. max, ",")
	end
	_ENV = SoraDConfigSet
	SoraDConfigSet.byUID = true
	local resultxy = SoraDConfigGet("Game:worldMapView:monsterXYLVRange~string", SoraDConfigSet)
	if resultxy ~= "none" then
		_ENV = min .. "," .. max
		;(min .. "," .. max).byUID = true
		SoraDConfigSet("Game:worldMapView:monsterXYLVRange~string", resultxy, min .. "," .. max)
	else
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		local maxLv = math.max(kingdomMapCtrl.kingdomMapCell.maxMapNpcLevel, kingdomMapCtrl.kingdomMapCell.maxNpcLevel + 1)
		local towerLv = nebulaActivityCtrl:getTowerLv()
		local max = 41
		if 41 < maxLv and 0 < towerLv then
			local nebulaTowerLvDesRead = include("nebulaTowerLvDesRead")
			max = math.min(nebulaTowerLvDesRead.getMonsterMaxLv(towerLv), maxLv)
		end
		local min = 41
		_ENV = ","
		;(",").byUID = true
		SoraDConfigSet("Game:worldMapView:monsterXYLVRange~string", min .. "," .. max, ",")
	end
	_ENV = math.min(nebulaTowerLvDesRead.getMonsterMaxLv(towerLv), maxLv)
	math.min(nebulaTowerLvDesRead.getMonsterMaxLv(towerLv), maxLv).byUID = true
	SoraDConfigSet("Game:heroMSkillFeedView:refresh~bool", false, (math.min(nebulaTowerLvDesRead.getMonsterMaxLv(towerLv), maxLv)))
	_ENV = math.min(nebulaTowerLvDesRead.getMonsterMaxLv(towerLv), maxLv)
	math.min(nebulaTowerLvDesRead.getMonsterMaxLv(towerLv), maxLv).byUID = true
	SoraDConfigSet("Game:getTogetherView:first~bool", true, (math.min(nebulaTowerLvDesRead.getMonsterMaxLv(towerLv), maxLv)))
end
function LoginViewPanel:setStarBuildMiracleLv()
	local bidLv = SoraDGetBuildStarLv(BUILDID.MIRACLE)
	_ENV = nil
	;(nil).byUID = true
	local curStarLv = SoraDConfigGet("Game:warGemView:starLv~integer", nil)
	print("slkdfjlsdjflds", bidLv, curStarLv)
	if curStarLv == -1 then
		_ENV = curStarLv
		curStarLv.byUID = true
		SoraDConfigSet("Game:warGemView:starLv~integer", bidLv, curStarLv)
	end
end
function LoginViewPanel:loginsuccess()
	self.isServerReturn = true
	self:finishRange(gLoginRangeTbl.connectServer)
	self:stopTimer()
	self:runAction(ffa.seq(ffa.delay(0), ffa.callFunc(function()
		self:enterGame()
	end)))
end
function LoginViewPanel:checkMaintainInfo()
	print("检测维护信息===")
	SoraDPostCheckMaintain()
end
function LoginViewPanel:startTimer()
	self:stopTimer()
	self.timerKey = SoradCreateTimer(self, handler(self, self.updateTime), true)
end
function LoginViewPanel:stopTimer()
	if self.timerKey then
		SoraDManagerRemoveTimer(self, self.timerKey)
		self.timerKey = nil
	end
end
function LoginViewPanel:updateTime()
	if not self then
		return
	end
	local gametop = gModuleMgr.getObject("gametop")
	local playertop_ = gametop.playertop_
	if playertop_ then
		local isdataready = playertop_:IsInitDataReady()
		if isdataready == true and self.initFinishCount >= 2 then
			self.initFinishCount = 0
			self:loginsuccess()
		elseif isdataready == false and self.initFinishCount >= 2 then
		elseif isdataready and self.initFinishCount == 1 then
			dump(self.testArrayImages, "self.testArrayImages", 10)
		end
	end
end
function LoginViewPanel:setKingdomClass(kingdomClass)
	self.kingdomClass = kingdomClass
end
function LoginViewPanel:setKingdomClassTips()
end
function LoginViewPanel:onClickUpdateFix()
	SoraDPlaySound()
	local aabUpdate = false
	if self.curLoadingRange == gLoginRangeTbl.obbUpdate and device.platform == "android" then
		local search = require("FileSearchPath")
		if search.isSupportAAB() then
			aabUpdate = true
		end
	end
	require("app.game.updateModule.updateModule"):getInstance():fixUpdateData(aabUpdate)
end
local clicknum = 0
function LoginViewPanel:onClickVersion()
	if clicknum % 7 == 0 then
		local setDevelop = function()
			if userSDKManager.isGameDevelop() then
				SoraDShowMsgTip("开发者模式--关闭")
				SoraDConfigSet("System:GameDevelopMode~bool", false)
			else
				SoraDShowMsgTip("开发者模式--开启")
				SoraDConfigSet("System:GameDevelopMode~bool", true)
			end
		end
		SoraDHttpRequest(setDevelop, gSvrConfig and gSvrConfig.insideNewArea or "https://p.onemt.co/", "GET")
	end
end
return LoginViewPanel
