GAME_VERSION = "0.00.001"
G_MAINSCENE_CURRENT_VIEW_TYPE = VIEW_TYPE_NONE
local MainScene = class("MainScene", function()
	return display.newPhysicsScene("MainScene")
end)
function MainScene:ctor()
	if userSDKManager.isBeta() or userSDKManager.isGameService() then
	end
	local deviceDPI = cc.Device:getDPI()
	print("deviceDPI:", deviceDPI)
	SoraDGetDefaultLanguage()
	self.isComeFromBackGroud = false
	self.foreBackGroudTimer = nil
	self.currentViewType = VIEW_TYPE_NONE
	self.isHideMainUICount = 0
	self.isHideCurrentSceneViewCount = 0
	self.gameGuideView = nil
	self.switcherViewIng = false
	if device.platform ~= "windows" then
		self:startGame()
	end
	self:onMessageListener()
	if device.platform == "mac" then
		self:listenerKeyPad_imgui()
	end
end
function MainScene:onEnter()
	if device.platform == "windows" then
		self:startGame()
		self:listenerKeyPad_imgui()
	end
end
function MainScene:onExit()
	print("main scene  exit ")
	SoraDRemoveMessageByTarget(self)
end
function MainScene:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", handler(self, self.gotoForeBackGroud))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_ONSHOW", handler(self, self.showView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_HIDE_SCENEVIEW_MAINUI", handler(self, self.hideCurrentSceneViewAndMainUI))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINSUCCESS", handler(self, self.creatMainView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFINSH", handler(self, self.loginFinsh))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFAIL", handler(self, self.serverSocketLoginFail))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINAGAIN", handler(self, self.serverSocketLoginAgain))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINAGAIN_QUICK", handler(self, self.serverSocketLoginAgain_Quick))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_SOCKET_KICKOUT", handler(self, self.serverSocketKickOut))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_MESSAGEINFO", handler(self, self.showServerMessageInfo))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPGRADE_LEVEL", handler(self, self.msgLordLevelUpView))
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_START_BY_STEP", handler(self, self.gameGuideStart))
	SoraDAddMessage(self, "MESSAGE_MAIN_SCENE_IPHONEX", handler(self, self.showIphoneX))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LUA_WILL_OPEN", handler(self, self.willOpen))
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_SHARE_BTN_UPDATE", handler(self, self.updateShareButton))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILD_QUEQUE_CALLBACK", function(target, data)
		if data.bid == BUILDID.CASTLE then
			self:updateShareButton()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SPEAKSTYLE_REFRESH", handler(self, self.updateVoiceButton))
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SERVER_NOTICE_INVITEMSG", handler(self, self.updateVoiceInviteButton))
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_END", function(target, data)
		self.gameGuideView = nil
		if data.needUpdate then
			local gametop = gModuleMgr.getObject("gametop")
			local guideCtrl = gametop.playertop_:getModule("guideCtrl")
			local step = guideCtrl:updateNewGuide()
			print("step=========", step)
			if not step then
				local newPlayerTaskCtrl = gametop.playertop_:getModule("newPlayerTaskCtrl")
				if newPlayerTaskCtrl:getCurChapterID() > 4103000 then
					self = newPlayerTaskCtrl
					newPlayerTaskCtrl.msg = "MESSAGE_MAIN_AGREEMENT_BOX"
					SoraDSendMessage(newPlayerTaskCtrl)
				end
				local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
				if remainsTeamCtrl:isHasInvitedInfo() then
					self = remainsTeamCtrl
					remainsTeamCtrl.msg = "MESSAGE_SERVER_REMAINS_TEAM_INVITED_INFO"
					SoraDSendMessage(remainsTeamCtrl)
				end
				self = remainsTeamCtrl
				remainsTeamCtrl.msg = "MESSAGE_SERVER_PYRAMIDBATTLE_GUIDECLOSEPOPEXPLAIN"
				SoraDSendMessage(remainsTeamCtrl)
			end
		end
	end)
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_COMMON_ICON_TIP", handler(self, self.updateCommonIconTip))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_POWER_UPDATE", handler(self, self.updatePower))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_EXP_UPDATE", handler(self, self.updateEXP))
end
function MainScene:startGame()
	self:initData()
end
function MainScene:initData()
	require("app.module.gModuleMgr")
	gModuleMgr.init()
	self:createPanelView()
	local inputTypeIndex = SoraDConfigGet("System:GameOptionsView:inputBox~integer") or 2
	FairyGUI.InputTextField.setUseNativeInput(inputTypeIndex == 2)
	self:createLoginView()
end
function MainScene:loginFinsh()
	print("登录流程走完了")
	SoraDCloseLoading()
end
function MainScene:createPanelView()
	local PanelViewCls = require("midware.baseComponent.PanelView")
	self.panelView = PanelViewCls:create()
	self.panelView:makeFullScreen(false)
	self:addChild(self.panelView, 6)
	self.panelView:setName("panelView")
	uiManager:setGrootNomal(self.panelView)
end
function MainScene:getPanelView()
	return self.panelView
end
function MainScene:cleanPanelView()
	_UPVALUE2_ = nil
	;(nil)[1] = "LoginView"
	;(nil)[2] = "mainUI"
	uiManager:closeAllUI(nil)
	_ENV = uiManager.closeAllUI
	uiManager.closeAllUI.commonSystemMsgBox = 1
	uiManager.closeAllUI.LoginViewPanel = 1
	uiManager.closeAllUI.mainUIPanel = 1
	local uiManager.closeAllUI.RoaringFlame_SwitcherPanel, panelName = 1, uiManager.closeAllUI
	local _ENV, list = uiManager, uiManager
	for k, v in ipairs(self.panelView:getChildren()) do
		table.insert(list, v)
	end
	for k, v in ipairs(list) do
		if not panelName[v:getName()] then
			if v:getName() == "worldMapFaceToDistance" then
				if self.panelView.faceToDistanceNode then
					self.panelView.faceToDistanceNode:setVisible(false)
				end
			else
				v:removeFromParent()
			end
		end
	end
end
function MainScene:createLoginView(showViewType, kingdomClass)
	showViewType = showViewType or VIEW_TYPE_CITY
	self:releaseMainView()
	self:stopAllActions()
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(0.016666666666666666)
	;(nil)[2] = cca.callFunc(function()
		self:loginSettingRun()
		AudioEngine.stopMusic()
		AudioEngine.playMusic(getAudioFileNameByPlatform("loading", "BGM"), true)
		local musicVolume = SoraDConfigGet("System:GameOptionsView:musicVolume~float")
		AudioEngine.setMusicVolume(musicVolume)
	end)
	;(nil)[3] = cca.callFunc(function()
		self:loginSettingRun()
		AudioEngine.stopMusic()
		AudioEngine.playMusic(getAudioFileNameByPlatform("loading", "BGM"), true)
		local musicVolume = SoraDConfigGet("System:GameOptionsView:musicVolume~float")
		AudioEngine.setMusicVolume(musicVolume)
	end)
	self:runAction(cca.seq(nil))
	if self.loginView then
		self.loginView:removeFromParent(true)
		self.loginView = nil
	end
	self.loginView = uiManager:show("LoginView").view
	self.loginView:setKingdomClass(kingdomClass)
	self.loginView.showViewType = showViewType
	SoraDCloseSwitcherView()
	ShackModule.unload()
end
function MainScene:removeLoginView()
	local ret = false
	if self.loginView then
		ret = true
		self.loginView:removeFromParent(true)
		self.loginView = nil
		if self.iphoneXTop then
			self.iphoneXTop:setVisible(device.isIphoneXMode())
		end
		if self.iphoneXBottom then
			self.iphoneXBottom:setVisible(device.isIphoneXMode())
		end
	end
	return ret
end
function MainScene:willOpen()
	VoiceChatSDKManager:getInstance():leaveChannel()
end
function MainScene:updateShareButton(target, data)
	if not commonCheck.SCREEN_SHOT then
		if self.shareBtn then
			self.shareBtn:setVisible(false)
		end
		return
	end
	if data and self.shareBtn and data.otherPic ~= nil then
		self.shareBtn:setVisible(data.otherPic)
	else
		_ENV = data.otherPic
		data.otherPic.byUID = true
		local isShow = SoraDConfigGet("Game:GameOptionsView:showShareBtn~integer", data.otherPic)
		if isShow == 0 then
			local gametop = gModuleMgr.getObject("gametop")
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) >= 10 then
				_ENV = nil
				;(nil).byUID = true
				SoraDConfigSet("Game:GameOptionsView:showShareBtn~integer", 1, nil)
				isShow = 1
			end
		end
		if isShow == 1 and self.shareBtn == nil then
			self.shareBtn = SoraDCreatePanel("commonShareButton")
			self.shareBtn:setPosition(0, 0)
			self:addChild(self.shareBtn, 8)
		elseif isShow ~= 1 and self.shareBtn and self.shareBtn then
			self.shareBtn:removeFromParent()
			self.shareBtn = nil
		end
	end
end
function MainScene:updatePower(target, data)
	if not self.oriPower then
		self.oriPower = data.oriPower
	end
	self.curPower = data.curPower
	self.isWaiting = false
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	if guideCtrl:getCurMainCityGuideStep() ~= nil and data.curPower - self.oriPower > 500 then
		return
	end
	SoraDDelayCallOnce("mainUI_lordPowerChange", function()
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINUI_POWER_UPDATE"
		SoraDSendMessage(nil)
		print("播放战力变化动画===========", self.oriPower, self.curPower)
		_ENV = self.oriPower
		self.oriPower.oriPower = self.oriPower
		self.oriPower.curPower = data.curPower
		SoraDShowPowerChange(false, self.oriPower)
		advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_fight_point, data.curPower)
		_ENV = gSDKDef.TDonEvent.advertise_fight_point
		gSDKDef.TDonEvent.advertise_fight_point.msg = "MESSAGE_MAIN_AGREEMENT_BOX"
		gSDKDef.TDonEvent.advertise_fight_point.showPush = true
		SoraDSendMessage(gSDKDef.TDonEvent.advertise_fight_point)
		self.oriPower = nil
	end, 0.8)
end
function MainScene:updateEXP(target, data)
	SoraDDelayCallOnce("mainUI_lordEXPChange", function()
		SoraDShowEXPChange(data.addEXP)
	end, 0.5)
end
function MainScene:updateCommonIconTip(target, data)
	uiManager:close("DivineBeastMarkTips")
	local id = data.id
	local num = data.num
	local pos = data.pos
	local customName = data.customName
	local customTip = data.customTip
	local commonTip = display.getRunningScene():getChildByName("commonItemTips")
	if not (id or customTip) or not pos then
		if commonTip then
			commonTip:setVisible(false)
		end
		return
	end
	pos.y = fgui.GRoot:getInstance():getSize().height - pos.y
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local ret, show, isShow = backpackltCtrl:getRandomGiftShowItems(id)
	if ret and next(ret) and isShow then
		_ENV = nil
		;(nil).itemID = id
		uiManager:show("CommonItemShowBox", nil)
		return
	end
	local isDressShow = backpackltCtrl:isSkinShow(id)
	if isDressShow then
		_ENV = nil
		;(nil).itemID = id
		uiManager:show("commonDressPreview", nil)
		return
	end
	if self.id == gBuffEffect.LEV_29_INSTANT_BUILD_SPEED_BOOST then
		local panel = SoraDCreatePanel("princeGiftBuffPreviewPopView")
		panel:show()
		return
	end
	local sType = serviceFunctions.getIDType(id)
	if sType == gIDType.DIVINE_BEAST_MARK then
		_ENV = nil
		;(nil).id = id
		;(nil).y = pos.y
		;(nil).mark = customTip
		uiManager:show("DivineBeastMarkTips", nil)
		return
	end
	local buffDesRead = include("buffDesRead")
	if commonTip and self.commonTipRA ~= SoraDFIsRA() then
		commonTip:removeFromParent(true)
		commonTip = nil
	end
	if not commonTip then
		self.commonTipRA = SoraDFIsRA()
		commonTip = SoraDCreatePanel("commonItemTips")
		commonTip:setName("commonItemTips")
		display.getRunningScene():addChild(commonTip, 9999)
	else
		commonTip:setVisible(true)
	end
	local value
	if customTip then
		commonTip:customData(customName, customTip)
	elseif value and sType ~= gIDType.ITEM and buffDesRead.isBuff(id) then
		commonTip:setBuffInfo(id, num)
	else
		commonTip:initData(id, num)
	end
	local height = 0
	local parent = fgui.GRoot:getInstance()
	height = parent:getSize().height
	if parent then
		local containerSize = parent:getSize()
		local size = commonTip:getBgSize()
		if SoraDFIsRA() then
			pos.x = pos.x + size.width / 2
			if 0 > pos.x - size.width then
				pos.x = size.width
			elseif pos.x > containerSize.width then
				pos.x = containerSize.width
			end
		else
			pos.x = pos.x - size.width / 2
			if 0 > pos.x then
				pos.x = 0
			elseif pos.x + size.width > containerSize.width then
				pos.x = containerSize.width - size.width
			end
		end
		pos.y = math.max(math.min(pos.y + size.height, height), size.height)
	end
	commonTip:setPosition(pos)
end
function MainScene:updateVoiceButton(target, redata)
	if VoiceChatSDKManager:getInstance().voiceState == gVoiceState.inRoom then
		if not self.voiceBtn then
			self.voiceBtn = SoraDCreatePanel("voiceChatFloatButton")
			self.voiceBtn:setPosition(0, 0)
			self:addChild(self.voiceBtn, 9)
		end
	elseif self.voiceBtn then
		self.voiceBtn:removeFromParent()
		self.voiceBtn = nil
	end
end
function MainScene:updateVoiceInviteButton(target, redata)
	local voiceInviteBtn = self:getChildByName("voiceChatInviteButton")
	if voiceInviteBtn then
		voiceInviteBtn:removeFromParent()
	end
	local info = redata.redata
	voiceInviteBtn = SoraDCreatePanel("voiceChatInviteButton")
	voiceInviteBtn:initData(info)
	voiceInviteBtn:setPosition(50, display.height / 2)
	self:addChild(voiceInviteBtn, 10)
end
function MainScene:showIphoneX(target, data)
	if data.isShow then
		if self.iphoneXTop then
			self.iphoneXTop:setVisible(device.isIphoneXMode())
		end
		if self.iphoneXBottom then
			self.iphoneXBottom:setVisible(device.isIphoneXMode())
		end
	else
		if self.iphoneXTop then
			self.iphoneXTop:setVisible(false)
		end
		if self.iphoneXBottom then
			self.iphoneXBottom:setVisible(false)
		end
	end
end
function MainScene:createWorldResourceMap()
	if self.worldResourceMap then
		self.worldResourceMap:removeFromParent(true)
		self.worldResourceMap = nil
	end
	self.worldResourceMap = include("worldResourceMap").new()
	self.worldResourceMap:setName("worldResourceMap")
	self.panelView:addChild(self.worldResourceMap, 1)
	return self.worldResourceMap
end
function MainScene:removeWorldResourceMap()
	if self.worldResourceMap then
		self.worldResourceMap:removeFromParent(true)
		self.worldResourceMap = nil
	end
end
function MainScene:creatMainView(target, data)
	self:initLoginSuccess()
	self:releaseMainView()
	self.currentShowView = nil
	print("开始创建mainui------")
	userSDKManager.timeInfo.t_mainui.tbegin = SoraDGetSocketTime()
	if _G.SoraDGetCtrl("settingCtrl"):isAnchorSwitchOn() then
	elseif not uiManager:isShow("mainUI") then
		uiManager:show("mainUI")
	end
	userSDKManager.timeInfo.t_mainui.tend = SoraDGetSocketTime()
	print("结束创建mainui------")
	self.worldResourceMap = nil
	self.systemNoticeView = include("systemNoticeView").new()
	self:addChild(self.systemNoticeView, 6)
	if self.iphoneXTop then
		self.iphoneXTop:removeFromParent()
		self.iphoneXTop = nil
	end
	self.iphoneXTop = fguiHelper.createObject("MainUI", "iphoneXTop")
	self.iphoneXTop:setAnchorPoint(cc.p(0.5, 1))
	self.iphoneXTop:setVisible(false)
	self.iphoneXTop:setPosition(display.cx, 0)
	self:addChild(self.iphoneXTop, 6)
	if self.iphoneXBottom then
		self.iphoneXBottom:removeFromParent()
		self.iphoneXBottom = nil
	end
	self.iphoneXBottom = fguiHelper.createObject("MainUI", "iphoneXBottom")
	self.iphoneXBottom:setAnchorPoint(cc.p(0.5, 0))
	_UPVALUE3_ = self.iphoneXBottom
	self.iphoneXBottom[1] = display.height
	self.iphoneXBottom[2] = display.iPhoneXOffset
	self.iphoneXBottom[3] = display.height + display.iPhoneXOffset
	dump(self.iphoneXBottom, "display.height+display.iPhoneXOffset")
	self.iphoneXBottom:setPosition(display.cx, display.height + display.iPhoneXOffset)
	self.iphoneXBottom:setVisible(false)
	self:addChild(self.iphoneXBottom, 6)
	if device.isIpadMode() then
		self.padIndex = 1
		self.padSpirteL = display.newSprite("#frame_ipad_biankuang_L.png")
		self.padSpirteL:setPosition(32, 0)
		self.padSpirteL:setAnchorPoint(cc.p(0.5, 0))
		self:addChild(self.padSpirteL, 6)
		self.padSpirteR = display.newSprite("#frame_ipad_biankuang_R.png")
		self.padSpirteR:setPosition(display.realSize.width - 32, 0)
		self.padSpirteR:setAnchorPoint(cc.p(0.5, 0))
		self:addChild(self.padSpirteR, 6)
	end
	self:updateShareButton()
	self:updateVoiceButton()
	local showViewType = data.showViewType or VIEW_TYPE_CITY
	local otherData = data.otherData
	_ENV = 6
	;(6).msg = "MESSAGE_MAINSCEN_ONSHOW"
	;(6).viewType = showViewType
	;(6).otherData = otherData
	;(6).isFromLogin = true
	SoraDSendMessage(6)
end
function MainScene:releaseMainView()
	userSDKManager.need2CallBackEventList, _ENV = nil, nil
	self.isHideMainUICount = 0
	self.isHideCurrentSceneViewCount = 0
	SoraDCloseLoading(self)
	if self.currentShowView then
		self.currentShowView:removeFromParent(true)
		self.currentShowView = nil
	end
	if self.mainUIView then
		self.mainUIView:removeFromParent(true)
		self.mainUIView = nil
	end
	if uiManager:isShow("mainUI") then
		uiManager:close("mainUI")
	end
	if self.worldResourceMap then
		self.worldResourceMap:removeFromParent(true)
		self.worldResourceMap = nil
	end
	self:cleanPanelView()
	if self.iphoneXTop then
		self.iphoneXTop:removeFromParent()
		self.iphoneXTop = nil
	end
	if self.iphoneXBottom then
		self.iphoneXBottom:removeFromParent()
		self.iphoneXBottom = nil
	end
	if self.shareBtn then
		self.shareBtn:removeFromParent()
		self.shareBtn = nil
	end
	if self.voiceBtn then
		self.voiceBtn:removeFromParent()
		self.voiceBtn = nil
	end
	if self.systemNoticeView then
		self.systemNoticeView:removeFromParent(true)
		self.systemNoticeView = nil
	end
	local voiceInviteBtn = self:getChildByName("voiceChatInviteButton")
	if voiceInviteBtn then
		voiceInviteBtn:removeFromParent()
	end
	local instanceCacheMgr = include("instanceCacheMgr")
	instanceCacheMgr.clearCache()
	if self.warnningList then
		for k, v in pairs(self.warnningList) do
			v:removeFromParent()
		end
		self.warnningList = nil
	end
	SoraDClearItemwAwards()
	cocosUIManager:clearCachedInstanceView()
end
function MainScene:showView(target, data)
	local isJudgeCurScene = data.isJudgeCurScene or false
	local isBottom = data.isBottom or false
	if isJudgeCurScene and data.viewType == self.currentViewType then
		return
	end
	if data.viewType == VIEW_TYPE_NONE then
		return
	end
	local isFromLogin = data.isFromLogin or false
	worldMapDefine.currentMapKindomID = nil
	if not isFromLogin and SoraDCurrentMainUI() == nil then
		print("SoraDCurrentMainUI() == nil")
		return
	end
	local switcherView = function()
		if self.currentShowView then
			if self.currentViewType == data.viewType then
				self.currentShowView.freeImagesOnExit = false
			end
			if data.isFactionSwitch then
				self.currentShowView.freeImagesOnExit = true
			end
			self.currentShowView:removeFromParent(true)
			self.currentShowView = nil
			criAdxAux.freeAudio()
			imageManager.switchScene()
		end
		local worldMapDefine = include("worldMapDefine")
		local otherData = data.otherData
		if otherData and otherData.kingdomID then
			worldMapDefine.currentMapKindomID = otherData.kingdomID
		else
			local gametop = gModuleMgr.getObject("gametop")
			local selfKindomID = gametop.playertop_:getMapID()
			worldMapDefine.currentMapKindomID = selfKindomID
		end
		local atlantisWarUtil = include("atlantisWarUtil")
		atlantisWarUtil.removeWorldMapAtlantisWarInfo()
		local showView
		AudioEngine.stopMusic()
		if data.viewType == VIEW_TYPE_CITY then
			if self.panelView.faceToDistanceNode then
				self.panelView.faceToDistanceNode:setVisible(false)
			end
			if self.loginView then
				print("登入进入主城")
				self = false
				userSDKManager.logEvent(gSDKDef.TDonEvent.star_enter_city, false)
				local isSupport = gl.isSupportsASTC()
				self = nil
				;(nil).support = isSupport
				userSDKManager.logEvent(gSDKDef.TDonEvent.check_astc_support, nil)
				self = nil
				;(nil).byUID = true
				local isLog = SoraDConfigGet("Game:RechargeUI:log~bool", nil)
				print("打点充值界面======", GLOBAL_GAME_RECHARGE_MODE, isLog)
				if not isLog then
					self = GLOBAL_GAME_RECHARGE_MODE
					GLOBAL_GAME_RECHARGE_MODE.choose = GLOBAL_GAME_RECHARGE_MODE and 2 or 1
					userSDKManager.logEvent(gSDKDef.TDonEvent.recharge_interface_selection, GLOBAL_GAME_RECHARGE_MODE)
					self = GLOBAL_GAME_RECHARGE_MODE and 2 or 1
					;(GLOBAL_GAME_RECHARGE_MODE and 2 or 1).byUID = true
					SoraDConfigSet("Game:RechargeUI:log~bool", true, GLOBAL_GAME_RECHARGE_MODE and 2 or 1)
				end
				if gl.isSupportsETC2 then
					isSupport = gl.isSupportsETC2()
					self = true
					;(true).support = isSupport
					userSDKManager.logEvent(gSDKDef.TDonEvent.check_etc2_support, true)
				end
			end
			showView = include("mainCityView").new(otherData)
			showView:setName("mainCityView")
			local guideCtrl = SoraDGetCtrl("guideCtrl")
			if guideCtrl:getCurMainCityGuideStep() ~= nil then
				AudioEngine.playMusic(getAudioFileNameByPlatform("worldMap", "BGM"), true)
			else
				AudioEngine.playMusic(getAudioFileNameByPlatform("mainCity", "BGM"), true)
			end
		elseif data.viewType == VIEW_TYPE_MAP then
			showView = include("worldMapViewFactory").new(otherData)
			showView:setName("worldMapView")
			local dressCtrl = SoraDGetCtrl("dressCtrl")
			local skinID = dressCtrl:getDressOfCastle()
			if skinID then
				local castleModel = include("castleSkinRead").getCastleType(skinID)
				self = GLOBAL_GAME_RECHARGE_MODE and 2 or 1
				;(GLOBAL_GAME_RECHARGE_MODE and 2 or 1).byUID = true
				local musicSwitch = SoraDConfigGet("Game:castleChangeView:music~bool", GLOBAL_GAME_RECHARGE_MODE and 2 or 1) or false
				if castleModel == BUILD_CASTLE_MODEL.MUSICCASTLESENIOR and musicSwitch then
					AudioEngine.playMusic(getAudioFileNameByPlatform("Oud_and_Stars", "BGM"), true)
				else
					AudioEngine.playMusic(getAudioFileNameByPlatform("worldMap", "BGM"), true)
				end
			else
				AudioEngine.playMusic(getAudioFileNameByPlatform("worldMap", "BGM"), true)
			end
		end
		self:addChild(showView, 1)
		self.currentViewType = data.viewType
		G_MAINSCENE_CURRENT_VIEW_TYPE = self.currentViewType
		self.currentShowView = showView
		self.switcherViewIng = false
		if self:currentMainUI() then
			self = self
			self.msg = "MESSAGE_MAINSCEN_MAINUITOP_EVENT_REFRESH"
			SoraDSendMessage(self)
		end
	end
	util.resetCSDCatch()
	if isFromLogin or isBottom then
		switcherView()
		if data.viewType == VIEW_TYPE_MAP then
			local cityBuildFunction = include("cityBuildFunction")
			cityBuildFunction:setIsFirstLogin(false)
		end
	elseif not self.switcherViewIng then
		self.switcherViewIng = true
		SoraDShowSwitcherView(data.otherData)
		_ENV = false
		;(false).delay = 1.0
		;(false).onComplete = function()
			switcherView()
		end
		transition.execute(self, nil, false)
	else
		print("正在切换场景中ing")
		self:stopAllActions()
		switcherView()
	end
end
function MainScene:serverSocketLoginFail(target, data)
	local failType = "loginFail"
	local haveCancelBtn = true
	local showMsg = i18n("common_text_1122")
	local eventFunc = _G.SoraDStartLoginServerAndCheckVersion
	local isShowDefaultMsgBox = true
	local isCheckHasMaintenance = false
	if data.type == gLoginFailTypeDef.loginFailType_client then
		_ENV = nil
		userSDKManager.logEvent(gSDKDef.TDonEvent.login_fail_client, nil)
		failType = "networkTimeout"
		haveCancelBtn = false
		showMsg = i18n("common_text_795")
		isCheckHasMaintenance = true
	elseif data.type == gLoginFailTypeDef.loginFailType_server then
		print("失败了进这里吧")
		_ENV = nil
		userSDKManager.logEvent(gSDKDef.TDonEvent.login_fail_server, nil)
		failType = "serverMaintenance"
		haveCancelBtn = false
		isShowDefaultMsgBox = false
		showMsg = i18n("common_text_939")
		if self.loginView then
			if device.platform == "mac" then
				isShowDefaultMsgBox = true
			else
				local prePanel = SoraDSearchPanelFromManagerByName("CommonMaintainView")
				if prePanel then
					prePanel:initData(data.serverTime or os.time())
				else
					SoraDPostCheckMaintain(data.kid, data.serverTime)
				end
			end
		end
	elseif data.type == gLoginFailTypeDef.loginFailType_version then
		failType = "serverLimitVersion"
		haveCancelBtn = false
		showMsg = i18n("common_text_899")
	elseif data.type == gLoginFailTypeDef.loginFailType_startLogin then
		_ENV = data.kid
		userSDKManager.logEvent(gSDKDef.TDonEvent.login_fail_start_login, data.kid)
		failType = "loginTimeout"
		haveCancelBtn = true
		showMsg = i18n("common_text_1122")
		isCheckHasMaintenance = true
	elseif data.type == gLoginFailTypeDef.loginFailType_getUserInfo then
		_ENV = data.kid
		userSDKManager.logEvent(gSDKDef.TDonEvent.login_fail_get_user_info, data.kid)
		failType = "getUserInfoFail"
		haveCancelBtn = true
		showMsg = i18n("common_text_1123")
	elseif data.type == gLoginFailTypeDef.loginFailType_sdkTokenError then
		_ENV = data.kid
		userSDKManager.logEvent(gSDKDef.TDonEvent.login_fail_sdk_token_error, data.kid)
		failType = "sdkTokenError"
		haveCancelBtn = true
		showMsg = i18n("common_text_3764")
		function eventFunc(...)
			SoraDShowLoginView()
		end
	end
	if isCheckHasMaintenance and self.loginView and device.platform ~= "mac" then
		local prePanel = SoraDSearchPanelFromManagerByName("CommonMaintainView")
		if prePanel then
			return
		end
	end
	if isShowDefaultMsgBox then
		local panel = SoraDShowLoginFailBox(failType, showMsg, haveCancelBtn, function()
			eventFunc()
		end)
		panel:setName("SocketFailedMsgBox")
	end
end
function MainScene:serverSocketLoginAgain_Quick(target, data)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_CLOSE_GUIDE"
	SoraDSendMessage(nil)
	VoiceChatSDKManager:getInstance():leaveChannel()
	SoraDReloginReleaseManagerData()
	SoraDCloseLoading()
	Global_isLoginNeedLoading = true
	print("-----快速断线重登-----")
	SoraDRemoveAllPanelFromManager()
	self:cleanPanelView()
	SoraDStartGetLoginData()
end
function MainScene:serverSocketLoginAgain(target, data)
	print("sldkfjksljflksdjf")
	local loginAgainFunc = function()
		Global_isLoginNeedLoading = true
		print("-----断线重连------")
		print("-----关闭所有界面-----")
		SoraDCleanPopupWindowManager()
		SoraDRemoveAllPanelFromManager()
		if device.platform ~= "mac" then
			print("-----断线重连热更检查-----")
			require("app.game.updateModule.updateModule"):getInstance():disconnectedCheckVersion()
		end
		SoraDStartLoginServer()
	end
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_CLOSE_GUIDE"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_PRINCE_GIFT_GUIDE_REFRESH"
	;(nil).isRelogin = true
	SoraDSendMessage(nil)
	VoiceChatSDKManager:getInstance():leaveChannel()
	SoraDReloginReleaseManagerData()
	SoraDCloseLoading()
	if self.isComeFromBackGroud then
		loginAgainFunc()
	else
		_ENV = nil
		;(nil).loginagainTag = data.loginagainTag
		userSDKManager.logEvent(gSDKDef.TDonEvent.login_fail_again, nil)
		local msgBoxPanel = SoraDShowMsgBox(i18n("common_text_1030"), i18n("common_text_204"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				print("sldkfjksljflksdjf22222")
				loginAgainFunc()
			end
		end)
		msgBoxPanel.enableTouchCloseSelf = true
		msgBoxPanel:setName("SocketFailedMsgBox")
	end
end
function MainScene:serverSocketKickOut(target, data)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_CLOSE_GUIDE"
	SoraDSendMessage(nil)
	VoiceChatSDKManager:getInstance():leaveChannel()
	SoraDReleaseManagerData()
	SoraDCloseLoading()
	local customData
	local showMsg = i18n("common_text_794")
	if data.type == gUserKickOutTypeDef.userKickOutType_serverRepair then
		_ENV = nil
		userSDKManager.logEvent(gSDKDef.TDonEvent.login_server_repair, nil)
		showMsg = i18n("common_text_939")
	elseif data.type == gUserKickOutTypeDef.userKickOutType_otherDeviceLogin then
		_ENV = nil
		userSDKManager.logEvent(gSDKDef.TDonEvent.login_fail_other_device_login, nil)
		showMsg = i18n("common_text_794")
	elseif data.type == gUserKickOutTypeDef.userKickOutType_accountBeClosed then
		local sealType = data.sealType
		_ENV = nil
		userSDKManager.logEvent(gSDKDef.TDonEvent.login_fail_account_be_closed, nil)
		_ENV = userSDKManager.logEvent
		userSDKManager.logEvent[gSealAccountType.DEFAULT] = "common_text_1038"
		userSDKManager.logEvent[gSealAccountType.SELL_RESOURCE] = "common_text_4283"
		userSDKManager.logEvent[gSealAccountType.TOO_MANY_ACCOUNTS] = "common_text_4284"
		userSDKManager.logEvent[gSealAccountType.CURSE] = "common_text_4285"
		userSDKManager.logEvent[gSealAccountType.DEVICE] = "commom_text_4304"
		userSDKManager.logEvent[gSealAccountType.DEL_ACCOUNT] = "writeoff_text_1"
		local userSDKManager.logEvent[gSealAccountType.RECHARGE_ILLEGAL], msgTb = "common_text_4794", userSDKManager.logEvent
		local key = msgTb[gSealAccountType.DEFAULT]
		if sealType and msgTb[sealType] ~= nil then
			key = msgTb[sealType]
		end
		_ENV, showMsg = i18n(key), i18n(key)
		i18n(key).sealType = data.sealType
		customData, i18n(key).isOnline = i18n(key), data.isOnline
	end
	SordDShowExitGameBox(showMsg, data.type, customData)
end
function MainScene:hideCurrentSceneViewAndMainUI(target, data)
	local guideCtrl = SoraDGetCtrl("guideCtrl", nil, true)
	if not guideCtrl or guideCtrl:getCurMainCityGuideStep() ~= nil then
		return
	end
	local hideData = data.hideData
	if hideData.isHideCurrentSceneView ~= nil then
		if hideData.isHideCurrentSceneView then
			self.isHideCurrentSceneViewCount = self.isHideCurrentSceneViewCount + 1
		else
			self.isHideCurrentSceneViewCount = math.max(0, self.isHideCurrentSceneViewCount - 1)
		end
		if self.currentShowView then
			self.currentShowView:setVisible(self.isHideCurrentSceneViewCount == 0)
			_ENV = self.currentShowView
			_ENV, self.currentShowView.msg = self.isHideCurrentSceneViewCount == 0, "MESSAGE_MAINSCEN_CURRENT_SHOWVIEW_HIDED"
			;(self.isHideCurrentSceneViewCount == 0).view = self.currentShowView
			self.currentShowView.data, (self.isHideCurrentSceneViewCount == 0).isVisible = self.isHideCurrentSceneViewCount == 0, self.isHideCurrentSceneViewCount == 0
			SoraDSendMessage(self.currentShowView)
		end
	end
	if self:currentMainUI() and hideData.isHideMainUI ~= nil then
		if hideData.isHideMainUI then
			self.isHideMainUICount = self.isHideMainUICount + 1
		else
			self.isHideMainUICount = math.max(0, self.isHideMainUICount - 1)
		end
		if self.mainUIView then
			self.mainUIView:setVisible(self.isHideMainUICount == 0)
		end
		_ENV = self.mainUIView
		self.mainUIView.msg = "MESSAGE_MAIN_UI_HIDDLE"
		self.mainUIView.isHiddle = self.isHideMainUICount ~= 0
		SoraDSendMessage(self.mainUIView)
		local gametop = gModuleMgr.getObject("gametop")
		local guideCtrl = gametop.playertop_:getModule("guideCtrl")
		local newPlayerTaskCtrl = gametop.playertop_:getModule("newPlayerTaskCtrl")
		if self:currentMainUI():isVisible() and SoraDIsGameGuide() == nil and (newPlayerTaskCtrl:getCurChapterID() > 4103000 or newPlayerTaskCtrl:getCurChapterID() == 0) then
			_ENV = newPlayerTaskCtrl
			newPlayerTaskCtrl.msg = "MESSAGE_MAIN_AGREEMENT_BOX"
			SoraDSendMessage(newPlayerTaskCtrl)
		end
		if self:currentMainUI():isVisible() then
			print("主UI可见了，刷新一下红点========")
			_ENV = "主UI可见了，刷新一下红点========"
			;("主UI可见了，刷新一下红点========").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			SoraDSendMessage("主UI可见了，刷新一下红点========")
			_ENV = "主UI可见了，刷新一下红点========"
			;("主UI可见了，刷新一下红点========").msg = "MESSAGE_ACTIVITY_9001608_UPDATE_RED"
			SoraDSendMessage("主UI可见了，刷新一下红点========")
		end
	end
	print("self.isHideCurrentSceneViewCount: " .. self.isHideCurrentSceneViewCount)
	print("self.isHideMainUICount: " .. self.isHideMainUICount)
end
function MainScene:showServerMessageInfo(target, data)
	local messageID = data.messageID
	local iconSprite
	local iconData = data.iconData
	if iconData then
		if iconData.iconType == gNoticeIconTypeDef.ICON_BUILD then
			local buildDescribeRead = include("buildDescribeRead")
			iconSprite = display.newSprite(buildDescribeRead.getIcon(iconData.iconID, true))
		elseif iconData.iconType == gNoticeIconTypeDef.ICON_ITEM then
			local publicRead = include("publicRead")
			iconSprite = display.newSprite(publicRead.getIcon(iconData.iconID, true))
		elseif iconData.iconType == gNoticeIconTypeDef.ICON_SOLIDER then
			local armyDesRead = include("armyDesRead")
			iconSprite = display.newSprite(armyDesRead.getIcon(iconData.iconID, true))
		elseif iconData.iconType == gNoticeIconTypeDef.ICON_REOURCE then
			local resDesRead = include("resDesRead")
			iconSprite = display.newSprite(resDesRead.getIcon(iconData.iconID))
		elseif iconData.iconType == gNoticeIconTypeDef.ICON_TECH then
			local collegeDesRead = include("collegeDesRead")
			iconSprite = display.newSprite(collegeDesRead.getIcon(iconData.iconID, true))
		elseif iconData.iconType == gNoticeIconTypeDef.ICON_ARMY then
			iconSprite = display.newSprite("#icon_fight_expedition.png")
		elseif iconData.iconType == gNoticeIconTypeDef.ICON_REWARD then
			iconSprite = display.newSprite("#icon_equip_box2.png")
		elseif iconData.iconType == gNoticeIconTypeDef.ICON_NORMAL then
			iconSprite = display.newSprite(iconData.iconID)
		end
	end
	local param = data.param
	if param then
		if param.buildID then
			local buildDescribeRead = include("buildDescribeRead")
			param.buildID = buildDescribeRead.getName(param.buildID)
		end
		if param.itemID then
			local publicRead = include("publicRead")
			param.itemID = publicRead.getName(param.itemID)
		end
		if param.soliderID then
			local armyDesRead = include("armyDesRead")
			param.soliderID = armyDesRead.getName(param.soliderID)
		end
		if param.resourceID then
			local resDesRead = include("resDesRead")
			param.resourceID = resDesRead.getName(param.resourceID)
		end
		if param.techID then
			local collegeDesRead = include("collegeDesRead")
			if collegeDesRead.getName(param.techID) then
				param.techID = collegeDesRead.getName(param.techID)
			end
			local allianceDesRead = include("allianceDesRead")
			if allianceDesRead.isScience(param.techID) then
				param.techID = allianceDesRead.getScienceName(param.techID)
			end
		end
		if param.equipID then
			local equipDesRead = include("equipDesRead")
			if equipDesRead.getName(param.equipID) then
				param.equipID = equipDesRead.getName(param.equipID)
			end
		end
		if param.languageID then
			local allianceDesRead = include("allianceDesRead")
			if allianceDesRead.getLanguageName(param.languageID) then
				param.languageID = allianceDesRead.getLanguageName(param.languageID)
			end
		end
	end
	local languageString = i18n(tostring(messageID), param)
	SoraDShowMsgTip(languageString, iconSprite)
end
function MainScene:msgLordLevelUpView(target, data)
	if SoraDGetCtrl("lordInfoCtrl"):getLordUpgradePopStatus() then
		SoraDShowLordUPView()
	end
end
function MainScene:gotoForeBackGroud(target, data)
	local schedulerTime = require(cc.PACKAGE_NAME .. ".scheduler")
	local callFunc = function()
		self.isComeFromBackGroud = false
		if self.foreBackGroudTimer then
			SoraDManagerRemoveTimer(self, self.foreBackGroudTimer)
			self.foreBackGroudTimer = nil
			print("mainscene:isComeFromBackGroud,false")
		end
	end
	local groudType = data.groudType
	if groudType == GOTO_FOREG_GROUD then
		print("mainscene:foreGroud")
		self.isComeFromBackGroud = true
		self.foreBackGroudTimer = SoraDCreateDelayTimer(self, callFunc, 10)
	elseif groudType == GOTO_BACK_GROUD then
		print("mainscene:backGroud")
		callFunc()
	end
end
function MainScene:currentSceneShowView()
	return self.currentShowView
end
function MainScene:currentMainUI()
	return uiManager:getProxy("mainUI") and uiManager:getProxy("mainUI"):getPanel()
end
function MainScene:runTestScript(code)
	local index = 1
	if 76 <= code and code <= 85 then
		index = code - 76
	elseif 124 <= code and code <= 149 then
		index = string.byte("A", 1)
		index = index + code - 124
		index = string.char(index)
	else
		index = "_" .. code
	end
	local runScript = function()
		package.loaded.test = nil
		local test = requireLocal(".test")
		local funcName = "cmd" .. index
		if test[funcName] then
			test[funcName]()
		end
	end
	local errorFng = function(errorMessage)
		print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
		print(debug.traceback())
	end
	xpcall(runScript, errorFng)
end
function MainScene:listenerKeyPad_imgui()
	if self.listenerLayerImgui then
		return
	end
	self.listenerLayerImgui = display.newLayer()
	self.listenerLayerImgui:addTo(self, 101)
	self.listenerLayerImgui:setKeypadEnabled(true)
	self.listenerLayerImgui:setSwallowTouches(false)
	self.listenerLayerImgui:addEventListener1(fgui.UIEventType.KeyDown, function(context)
		if fgui.Stage.inst:HasInput() then
			return
		end
		_ENV = fgui.Stage.inst:HasInput()
		local fgui.Stage.inst:HasInput().code, event = utils.CastEnumToInt(context.inputEvent.keyCode), fgui.Stage.inst:HasInput()
		print("event===", event.code, cc.KeyCode.KEY_F8)
		if cc.KeyCode.KEY_F10 == event.code then
			print("imgui.toggleKeepOnTop")
			if not _G.imgui then
				local _ENV, imgui = _G.imgui, _G.imgui
			end
			if imgui.toggleKeepOnTop then
				imgui.toggleKeepOnTop()
			end
		elseif cc.KeyCode.KEY_F8 == event.code then
			if not uiManager:isShow("test") then
				uiManager:show("test")
			else
				uiManager:close("test")
			end
		end
	end)
end
function MainScene:listenerKeyPad()
	if self.listenerLayer then
		return
	end
	_ENV = self.listenerLayer
	self.listenerLayer.ForeignPShootGamePanel = 1
	self.listenerLayer.LinkLinkViewPanel = 1
	self.listenerLayer.RoadRoughViewPanel = 1
	self.listenerLayer.TowerDefendPanel = 1
	self.listenerLayer.SoldierRushMapPanel = 1
	local self.listenerLayer.SoldierRushLosePanel, closeClientViewCfg = 1, self.listenerLayer
	self.listenerLayer = display.newLayer()
	self.listenerLayer:addTo(self, 6)
	self.listenerLayer:setName("listenerKeyPad")
	self.listenerLayer:setContentSize(display.width, display.height)
	self.listenerLayer:setKeypadEnabled(true)
	self.listenerLayer:setSwallowTouches(false)
	local isCmdMode = false
	self.listenerLayer:addEventListener1(fgui.UIEventType.KeyDown, function(context)
		if fgui.Stage.inst:HasInput() then
			return
		end
		_ENV = fgui.Stage.inst:HasInput()
		local fgui.Stage.inst:HasInput().code, event = utils.CastEnumToInt(context.inputEvent.keyCode), fgui.Stage.inst:HasInput()
		if DEBUG > 0 and device.platform == "mac" then
			print("event.code = ", event.code, event.key, ", KeyCodeKey = ")
			if cc.KeyCode.KEY_ENTER == event.code or cc.KeyCode.KEY_KP_ENTER == event.code or cc.KeyCode.KEY_DPAD_CENTER == event.code then
				print("app:callOpenLua4Dev")
				app:callOpenLua4Dev()
			elseif cc.KeyCode.KEY_GRAVE == event.code then
				app:returnToMainScene4Dev()
			elseif event.code == cc.KeyCode.KEY_CTRL then
				print("cmd mode on")
			elseif event.code == cc.KeyCode.KEY_ALT then
				print("cmd mode off")
			elseif event.code == cc.KeyCode.KEY_C then
				uiManager:show("CheatView")
			elseif event.code == cc.KeyCode.KEY_S then
				package.loaded["app.game.clientFilter.shenmiButton"] = nil
				include("shenmiButton").new()
			elseif event.code == cc.KeyCode.KEY_D then
				SoraDRemoveAllPanelFromManager()
				print("uiManager:clearCachedInstanceView")
				uiManager:clearCachedInstanceView()
				print("uiManager:clearLRUCache")
				uiManager:clearLRUCache()
				local packageManager = require("fgui.base.packageManager")
				packageManager:clearUnusedPackage()
			elseif event.code == 98 then
				uiManager:show("RoaringFlameWarBuildTest")
			elseif isCmdMode then
				self:runTestScript(event.code)
			end
		end
		if SoraDIsGameGuide() then
			return
		end
		print("code", event.code, cc.KeyCode.KEY_BACK, cc.KeyCode.KEY_BACK == event.code)
		if cc.KeyCode.KEY_ESCAPE == event.code or cc.KeyCode.KEY_BACK == event.code then
			local topPanel = SoraDCurrentTopPanelFromManager()
			dump(topPanel, " ==========topPanel")
			if topPanel then
				if topPanel.__cname == "LegendMain" or topPanel.__cname == "allianceHuntPopView" then
					topPanel:goBack(topPanel.closeButton, ccui.TouchEventType.ended)
				elseif topPanel.__cname == "commonAgreementBox" or topPanel.__cname == "commonNormalAgreementBox" then
					topPanel:closeConfirm()
				elseif topPanel.__cname == "chapterTaskShowView" then
					if userSDKManager.isKO() then
						topPanel:closeView(topPanel.closeButton, ccui.TouchEventType.ended)
					end
				elseif topPanel.__cname == "commonPromptBox" and topPanel:getName() == "SocketFailedMsgBox" then
					topPanel:exitView(MSGBOX_CALLBACK_YES)
				elseif topPanel.__cname == "commonSystemMsgBox" and topPanel.style == topPanel.showType.download then
					print("强更框，不做处理")
				elseif topPanel.__cname == "lordLevelUpView" then
					topPanel:closeView(topPanel.closeButton, ccui.TouchEventType.ended)
				elseif closeClientViewCfg[topPanel.__cname] then
					topPanel:onClickClose()
				elseif topPanel.isCantCloseByReturn then
					print("不做处理", topPanel.__cname)
				elseif topPanel.obSystemBackKeyClick then
					topPanel:obSystemBackKeyClick()
				else
					topPanel:close(topPanel.closeButton, ccui.TouchEventType.ended)
				end
			else
				local showMsg = i18n("notice_0169")
				SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("heroDes_text_07"), function(callType)
					if callType == MSGBOX_CALLBACK_YES then
						print("点击确定")
						local noticeModule = include("noticeModule")
						noticeModule.addNotice()
						app:exit()
					end
				end)
			end
		elseif event.key == "menu" then
			print("点击菜单按钮")
		end
	end)
end
function MainScene:getGameGuideStep()
	local guideCtrl = SoraDGetCtrl("guideCtrl", nil, true)
	local currentMainCityGuideStep = guideCtrl and guideCtrl:getCurMainCityGuideStep() or nil
	if currentMainCityGuideStep then
		return tonumber(currentMainCityGuideStep)
	end
	if self.gameGuideView then
		return self.gameGuideView:getCurIndex()
	else
		return nil
	end
end
function MainScene:gameGuideStart(target, data)
	local step = data.step
	if self.gameGuideView == nil and step then
		if step == 51001 then
			local gametop = gModuleMgr.getObject("gametop")
			local heroCtrl = gametop.playertop_:getModule("heroCtrl")
			local heroInfo = heroCtrl:getHeroInfoByID(1700)
			if heroInfo ~= nil then
				return
			end
		end
		self.gameGuideView = include("gameGuideView").new()
		self.gameGuideView:show()
		self.gameGuideView:startGuideWithStep(step, data.otherData)
	end
end
function MainScene:loginSettingRun()
	local musicVolume = SoraDConfigGet("System:GameOptionsView:musicVolume~float")
	AudioEngine.setMusicVolume(musicVolume)
	local soundVolume = SoraDConfigGet("System:GameOptionsView:soundVolume~float")
	AudioEngine.setEffectsVolume(soundVolume)
	print("loginSetting", musicVolume, soundVolume)
end
function MainScene:initLoginSuccess()
	local worldMapDefine = include("worldMapDefine")
	worldMapDefine.doSwitchToAnchor()
	if _G.fabric then
		_G.fabric:getInstance():reportDeviceInfoChange()
	end
	local worldMapUtil = include("worldMapUtil")
	worldMapUtil.resetConfig()
	local gametop = gModuleMgr.getObject("gametop")
	local militaryRankCtrl = gametop.playertop_:getModule("militaryRankCtrl")
	militaryRankCtrl:sendMarshalLoginTip()
end
function MainScene:getTest()
	package.loaded.test = nil
	local test = requireLocal(".test")
	return test
end
function MainScene:getCheckViewList()
	local _ENV, viewList
	if self:currentMainUI() then
		table.insert(viewList, self:currentMainUI())
		local mainuiViewList = self:currentMainUI():getCheckViewList()
		for _, view in ipairs(mainuiViewList) do
			table.insert(viewList, view)
		end
	end
	table.insert(viewList, self.systemNoticeView)
	if self.currentShowView then
		table.insert(viewList, self.currentShowView)
	end
	if self.worldResourceMap then
		table.insert(viewList, self.worldResourceMap)
	end
	return viewList
end
function MainScene:addChild(child, ...)
	if child ~= self.panelView then
	end
	fgui.GComponent.addChild(self, child, ...)
end
return MainScene
