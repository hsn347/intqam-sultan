local gametop = gModuleMgr.getObject("gametop")
local linkCtrl = gametop.playertop_:getModule("linkCtrl")
local funUnlockRead = include("funUnlockRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local mainUIPanel = class("mainUIPanel", baseFguiPanel)
function mainUIPanel:ctor(...)
	self.super.ctor(self, ...)
	print("mainUIPanel:ctor", self.viewName)
	self.currentViewType = VIEW_TYPE_CITY
	self.isShowVisible = true
	self.eventForegroundID = nil
	self.eventBackgroundID = nil
	self:listenerKeyPad()
	userSDKManager.reportOnline()
	userSDKManager.reportGameUserInfo()
	userSDKManager.reportMoneyCurrent()
	userSDKManager.setOnMessageListener()
	userSDKManager.setOnNoticeBoardListener()
	userSDKManager.getSafePasswordStatus(function()
		userSDKManager.syncSecondaryLockStatus()
	end)
	userSDKManager.registerUnreadCountListener(function(unreadCount)
		print("注册未读导航公告条数====", unreadCount)
		userSDKManager.unreadCount = unreadCount
	end)
	userSDKManager.registerActionCallback(function(actionType, actionValue)
		if actionType and actionType == 3 then
			local activityID = tonumber(actionValue)
			if activityID then
				if clientEventMgr.getEventOriginalInfo(activityID) and clientEventMgr.getEventInfoByeid(activityID) then
					clientEventMgr.singleClickEvent(activityID)
				elseif not clientEventMgr.getEventOriginalInfo(activityID) then
					clientEventMgr.singleClickEvent(activityID)
				end
			end
			return
		end
	end)
	if SoraDConfigGet("System:GameDevelopLangCN~bool") then
		SoraDSetGameLanguage("zh_cn")
	end
	local devicePerformanceUtil = require("app.devicePerformanceUtil")
	devicePerformanceUtil.sendSdkLog()
	local sp = display.newSprite("#ltzd.png")
	sp:setPosition(-500, -500)
	sp:addTo(self)
end
function mainUIPanel:onShow()
	self._isInited = true
	print("=======mainUIPanel:onShow")
	print("mainUIPanel in")
	self.eventForegroundID = app:addEventListener(app.APP_ENTER_FOREGROUND_EVENT, handler(self, self.onEnterForeground))
	self.eventBackgroundID = app:addEventListener(app.APP_ENTER_BACKGROUND_EVENT, handler(self, self.onEnterBackground))
	self:checkPandect()
end
function mainUIPanel:onHide()
	print("=======mainUIPanel:onHide")
	print("mainUIPanel out")
	app:removeEventListener(self.eventForegroundID)
	app:removeEventListener(self.eventBackgroundID)
end
function mainUIPanel:setMainUIHiddle(data)
	if data.isHiddle ~= nil then
		self.isShowVisible = not data.isHiddle
		self:setVisible(self.isShowVisible)
		self.isToVisible = not data.isLogin and self.isShowVisible
	else
		self.isShowVisible = true
		self:setVisible(self.isShowVisible)
		self.isToVisible = false
	end
	print("mainUIPanel setMainUIHiddle=======", self.isToVisible, self.isShowVisible)
end
function mainUIPanel:playAnimation()
	print("mainUIPanel playAnimation=======", self.isToVisible, self.isShowVisible)
end
function mainUIPanel:isVisible()
	return self.isShowVisible
end
function mainUIPanel:listenerKeyPad()
	local currentScene = display.getRunningScene()
	if not currentScene then
		return
	end
	currentScene:listenerKeyPad()
end
function mainUIPanel:checkPandect()
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.PANDECT)
	self.fields.pandectView:setVisible(self.currentViewType == VIEW_TYPE_CITY and unlockLv <= SoraDGetCastleLv())
end
function mainUIPanel:onEnterForeground()
	if not self:getName() then
		return
	end
	if not gIsGameInFrontOrBack then
		print("进入前台")
		gIsGameInFrontOrBack = true
		notificationManager.refreshPushPermission()
		local isNeedRefreshGame = true
		print("前台:isNeedRefreshGame = ", isNeedRefreshGame)
		if isNeedRefreshGame then
			notificationManager.removeAllNotification()
			linkCtrl:onInvChange(GOTO_FOREG_GROUD)
			_ENV = linkCtrl
			linkCtrl.msg = "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD"
			linkCtrl.groudType = GOTO_FOREG_GROUD
			SoraDSendMessage(linkCtrl)
		end
		paymentManager.onEnterForeground()
		VoiceChatSDKManager:getInstance():enableAudio()
		userSDKManager.onEnterForegroundEvent()
		multiClientInitialize.judgeUserIsOnline2CallSDK2Push()
	end
end
function mainUIPanel:onEnterBackground()
	if not self:getName() then
		return
	end
	if gIsGameInFrontOrBack then
		print("进入后台")
		gIsGameInFrontOrBack = false
		local isNeedRefreshGame = true
		print("后台:isNeedRefreshGame = ", isNeedRefreshGame)
		if isNeedRefreshGame then
			local noticeModule = include("noticeModule")
			noticeModule.addNotice()
			linkCtrl:onInvChange(GOTO_BACK_GROUD)
			_ENV = linkCtrl
			linkCtrl.msg = "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD"
			linkCtrl.groudType = GOTO_BACK_GROUD
			SoraDSendMessage(linkCtrl)
		end
		VoiceChatSDKManager:getInstance():disableAudio()
	end
end
function mainUIPanel:reLoginFinish()
	self:refreshEventModule()
end
function mainUIPanel:refreshEventModule(redata)
	if redata and redata.activityID then
		if type(redata.activityID) == "table" then
			for _, v in pairs(redata.activityID) do
				clientEventMgr.getEventStateInfo(v)
			end
		elseif type(redata.activityID) == "number" then
			clientEventMgr.getEventStateInfo(redata.activityID)
		else
			clientEventMgr.getEventStateInfo()
		end
	else
		clientEventMgr.getEventStateInfo()
	end
	_ENV = redata.activityID
	redata.activityID.msg = "MESSAGE_UI_EVENTCENTER_REFRESHISNEW"
	SoraDSendMessage(redata.activityID)
end
function mainUIPanel:changeMainScene(data)
	if data.viewType == VIEW_TYPE_NONE or self.currentViewType == data.viewType or tolua.isnull(self) then
		return
	end
	self.currentViewType = data.viewType
	if data.viewType == VIEW_TYPE_CITY then
		self:checkPandect()
	else
		self.fields.pandectView:setVisible(false)
	end
end
function mainUIPanel:newDayReset(data)
	local loginGiftCtrl = gametop.playertop_:getModule("loginGiftCtrl")
	loginGiftCtrl:resetLoginDays()
	local starRhapsodyCtrl = gametop.playertop_:getModule("starRhapsodyCtrl")
	starRhapsodyCtrl:resetResetTimes()
	local activity_9001619_Ctrl = gametop.playertop_:getModule("activity_9001619_Ctrl")
	activity_9001619_Ctrl:resetResetTimes()
	local spiritualGiftCtrl = gametop.playertop_:getModule("spiritualGiftCtrl")
	spiritualGiftCtrl:resetDrawCount()
	local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
	intetiorCtrl:resetLoginDays()
end
function mainUIPanel:newChapterTaskOpen(data)
	if data and data.isUpdate then
		SoraDNewChapterOpen(true)
	end
	if data then
		gModuleMgr.sharedMgr("mildGuideManager"):starMildByNewPlayerQuestID(gNewPLayerTaskType.TO_GET_CASTLE_LV2)
	end
end
function mainUIPanel:lordSkillEffect(data)
	local currentScene = display.getRunningScene()
	local skillID = data.skillID
	if skillID == lordSkillIDDefine.backAtonce then
		if currentScene.name == "MainScene" then
			local currentView = currentScene:currentSceneShowView()
			if currentView.__cname == "worldMapView" then
			else
				_ENV = nil
				;(nil).msg = "MESSAGE_MAINSCEN_ONSHOW"
				;(nil).viewType = VIEW_TYPE_MAP
				;(nil).otherData = data
				SoraDSendMessage(nil)
			end
		end
	elseif skillID == lordSkillIDDefine.fullHP then
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_WORLD_MAP_DISPATCH_ARMY"
		SoraDSendMessage.style = 2
		SoraDSendMessage(SoraDSendMessage)
	elseif skillID == lordSkillIDDefine.harvest or skillID == lordSkillIDDefine.trapAction then
		local currentView = currentScene:currentSceneShowView()
		if currentView.__cname == "worldMapView" then
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINSCEN_ONSHOW"
			;(nil).viewType = VIEW_TYPE_CITY
			;(nil).otherData = data
			SoraDSendMessage(nil)
		else
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_LORD_SKILL_EFFECT"
			;(nil).data = data
			SoraDSendMessage(nil)
		end
	elseif skillID == lordSkillIDDefine.rescue or skillID == lordSkillIDDefine.collectprotect or skillID == lordSkillIDDefine.fastmarch then
		local panel = SoraDCreatePanel("commonUseSkill")
		panel:initData(skillID)
		panel:show()
	elseif skillID == lordSkillIDDefine.transres then
		include("effectMainUITop").lordSkillTransresEffect()
	end
end
function mainUIPanel:msgNoticeCumuReward(data)
	local total = data.total or 0
	local nType = data.nType
	if nType and 0 < total then
		local noticeId
		if nType % 2 == 1 then
			noticeId = "common_text_1884"
		else
			noticeId = "common_text_1885"
		end
		if noticeId ~= nil then
			do
				local msgNotice = include("msgNotice")
				local iconType = gNoticeIconTypeDef.ICON_REWARD
				_UPVALUE1_ = nil
				;(nil)[1] = ffa.delay(1)
				;(nil)[2] = ffa.callFunc(function()
					msgNotice = nil
					;(nil).total = total
					msgNotice.notice(noticeId, nil, iconType)
				end)
				;(nil)[3] = ffa.callFunc(function()
					msgNotice = nil
					;(nil).total = total
					msgNotice.notice(noticeId, nil, iconType)
				end)
				local seq = ffa.seq(nil)
				self:runAction(seq)
			end
		end
	end
end
function mainUIPanel:showEveluationView(data)
	if data.redata == true then
		print("显示评星界面----------------------------")
		SoraDShowRateStarView()
	end
end
function mainUIPanel:showHalloweenActionView(data)
	local panel = SoraDSearchPanelFromManagerByName("halloweenActionView")
	if panel == nil then
		panel = SoraDCreatePanel("halloweenActionView")
		panel:show()
	end
	panel:initData(false, data.data, data.isAFK)
end
function mainUIPanel:showAgreementBox(data)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local newPlayerTaskCtrl = gametop.playertop_:getModule("newPlayerTaskCtrl")
	local isPop = lordInfoCtrl:getUserAgreementPop()
	if data.showPush == nil and isPop and self:isVisible() and SoraDCurrentTopPanelFromManager() == nil then
		SoraDAddPopupWindow(function()
			SoraDCreatePanel("commonAgreementBox"):show()
		end, uiDequeTypeTab.AGREEMENT)
		userSDKManager.onGuideEvent(2801)
	elseif data.showPush and self:isVisible() and SoraDIsGameGuide() == nil and SoraDCurrentTopPanelFromManager() == nil and (newPlayerTaskCtrl:getCurChapterID() > 4103100 or newPlayerTaskCtrl:getCurChapterID() == 0) then
		self:stopActionByTag(120)
		local seq = ffa.seq(ffa.delay(0.016666666666666666), ffa.callFunc(function()
			SoraDCheckPopPushNotification(true)
		end))
		seq:setTag(120)
		self:runAction(seq)
	end
end
function mainUIPanel:msgCastleGift(data)
	if data.privilegeType == gPrivilegeType.PRIVILEGE_GIFT_WALL_LV then
		SoraDShowWallUPView(data.rid)
	else
		SoraDShowCastleUPView()
	end
end
function mainUIPanel:castleLevelUp(data)
	if not self._isInited then
		return
	end
	print("mainUIPanel:castleLevelUp")
	SoraDShowCastleUnlockView()
	local curLevel = SoraDGetCastleLv()
	advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_castle_level, curLevel)
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.FIRST_RECHARGE)
	if curLevel == unlockLv then
		include("cityBuildFunction"):checkCrazyTrio()
	end
	if curLevel == CASTLE_LV6_LIMITED then
		_ENV = nil
		;(nil).pType = uiDequeTypeTab.ACITIVITY_9001575
		cityBuildFunction:checkActivity9001575(nil)
	end
	self:checkPandect()
end
function mainUIPanel:getResTarget(resid)
	return self.fields.topArea:getResTarget(resid)
end
function mainUIPanel:getBtnTarget(id)
	return self.fields.bottomArea:getBtnTarget(id)
end
function mainUIPanel:updateWarning(data)
	self.fields.imgWarning:updateWarning(data)
end
function mainUIPanel:showLordHPChange(data)
	self.fields.com_hpup:setVisible(true)
	self.fields.com_hpup:playAct(data.style, data.hp)
end
function mainUIPanel:pyramidBattleStartFun()
	self.fields.com_load:setVisible(true)
	local node = include("effectMainUITop").warStartVSEffect(function()
		self.fields.com_load:setVisible(false)
		self.fields.com_load:clearContent()
	end)
	self.fields.com_load:setContent(node)
end
function mainUIPanel:getCheckViewList()
	local _ENV, viewList
	if not self.checkViewNames then
		_UPVALUE3_ = self.checkViewNames
		self.checkViewNames, self.checkViewNames[1] = self.checkViewNames, "topArea"
		self.checkViewNames, self.checkViewNames[2] = self.checkViewNames, "pandectView"
		self.checkViewNames, self.checkViewNames[3] = self.checkViewNames, "bottomArea"
	end
	for _, viewName in ipairs(self.checkViewNames) do
		local view = self.fields[viewName]
		if view then
			table.insert(viewList, view)
		end
	end
	return viewList
end
function mainUIPanel:getMainUIBottom()
	return self.fields.bottomArea
end
function mainUIPanel:getMainUITop()
	return self.fields.topArea
end
function mainUIPanel:getMainUIBottomBag()
	return self.fields.bottomArea:getAreaBTarget("Button_items")
end
function mainUIPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "topHeadFrame" then
		return self.fields.topArea:getTarget("btn_head")
	elseif itemName == "bottomQuestBtn" then
		return self.fields.bottomArea:getTarget("questGuideNode")
	elseif itemName == "bottomItemsBtn" then
		return self.fields.bottomArea:getAreaBTarget("Button_items")
	elseif itemName == "bottomAllianceBtn" then
		return self.fields.bottomArea:getAreaBTarget("Button_alliance")
	elseif itemName == "bottomHeroBtn" then
		return self.fields.bottomArea:getAreaBTarget("Button_hero")
	elseif itemName == "bottomMailBtn" then
		return self.fields.bottomArea:getAreaBTarget("Button_mail")
	elseif itemName == "bottomQuestGuide" then
		return self.fields.bottomArea:getTarget("questGuideNode")
	elseif itemName == "bottomWorldBtn" then
		return self.fields.bottomArea:getAreaBTarget("Button_worldCity")
	elseif itemName == "Button_vip" then
		return self.fields.topArea:getTarget("btn_vip")
	elseif itemName == "Button_event" then
		return self.fields.topArea:getTarget("Node_event")
	elseif itemName == "goldBuilder" then
		return self.fields.topArea:getNodeLTTarget("builderIcon_gold")
	elseif itemName == "Button_gold" then
		return self.fields.topArea:getTarget("com_gold")
	elseif itemName == "top_starBuilder" then
		return self.fields.topArea:getNodeLTTarget("builderIcon_qh_free")
	elseif itemName == "Button_pandect" then
		return self.fields.pandectView:getBtnPandect()
	elseif itemName == "pandectFingerMove" then
		self.fields.pandectView:runFingerAction()
		return self.fields.pandectView:getList()
	elseif itemName == "Button_princeGiftBuff" then
		return self.fields.bottomArea:getSwitchTarget("Btn_princeGiftBuff")
	elseif itemName == "Btn_commandHall" then
		return self.fields.bottomArea:getSwitchTarget("Btn_commandHall")
	elseif itemName == "Btn_iceShimmer" then
		return self.fields.bottomArea:getSwitchTarget("Btn_iceShimmer")
	elseif itemName == "Btn_9001658" then
		return self.fields.bottomArea:getSwitchTarget("Btn_9001658")
	end
	return nil
end
function mainUIPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "MainUI"
		self._packageList, self._packageList[2] = self._packageList, "fonts"
		self._packageList, self._packageList[3] = self._packageList, "CastleSkin"
	end
	return self._packageList
end
function mainUIPanel:onInit()
	print("=======mainUIPanel:onInit")
	self.fields.imgWarning:setVisible(false)
	self.fields.com_hpup:setVisible(false)
	self.fields.com_load:setVisible(false)
end
function mainUIPanel:onDispose()
	print("=======mainUIPanel:onDispose")
end
function mainUIPanel:setMainCityGuideUI(index)
	self.controllers.guide:setSelectedIndex(1 <= index and 1 or 0)
	self.fields.bottomArea:setGuideContorller(index)
	self.fields.topArea:setGuideContorller(index)
	if index == 0 then
		self:checkPandect()
		return
	else
		self.fields.pandectView:setVisible(false)
	end
end
return mainUIPanel
