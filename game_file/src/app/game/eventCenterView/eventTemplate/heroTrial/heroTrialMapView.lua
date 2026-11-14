local htPointMgr = include("htPointMgr")
local heroTrialltCtrl = include("heroTrialltCtrl")
local htBattleMgr = include("htBattleMgr")
local htMapMgr = include("htMapMgr")
local htLogMgr = include("htLogMgr")
local heroTrialEntity = include("heroTrialEntity")
local msgNotice = include("msgNotice")
local heroTrialCommon = include("heroTrialCommon")
local gametop = gModuleMgr.getObject("gametop")
local heroTrialCtrl = gametop.playertop_:getModule("heroTrialCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local dressCtrl = gametop.playertop_:getModule("dressCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local heroTrialMapView = class("heroTrialMapView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroTrialMapView")
	end
	return target
end)
heroTrialMapView.QUIT_COMPLETE = 1
heroTrialMapView.QUIT_MANUAL = 2
heroTrialMapView.QUIT_NOSOLDIERS = 3
function heroTrialMapView:ctor()
	local title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_eventCenter")
	self.upBtn = SoraDGetChildByName(self, "upBtn")
	local upTouch = SoraDGetChildByName(self, "upTouch")
	self.praiseBtn = SoraDGetChildByName(self, "praiseBtn")
	local praiseTouch = SoraDGetChildByName(self, "praiseTouch")
	local praiseBg = SoraDGetChildByName(self, "praiseBg")
	local fastPassTitle = SoraDGetChildByName(self, "fastPassTitle")
	local trialNumTitle = SoraDGetChildByName(self, "trialNumTitle")
	self.stopBtn = SoraDGetChildByName(self, "stopBtn")
	self.levelBg = SoraDGetChildByName(self, "levelBg")
	self.bottomBg = SoraDGetChildByName(self, "bottomBg")
	self.praiseNode = SoraDGetChildByName(self, "praiseNode")
	self.praiseTip = SoraDGetChildByName(self.praiseNode, "praiseTip")
	self.praiseLight = SoraDGetChildByName(self.praiseNode, "praiseLight")
	self.praiseLevel = SoraDGetChildByName(self, "levelText")
	self.trialNum = SoraDGetChildByName(self, "trialNum")
	self.resumeTime = SoraDGetChildByName(self, "resumeTime")
	self.autoNode = SoraDGetChildByName(self, "AutoBattleNode")
	self.stopAutoBtn = SoraDGetChildByName(self.autoNode, "stopAutoBtn")
	self.autoTip = SoraDGetChildByName(self.autoNode, "autoTip")
	self.autoTitle = SoraDGetChildByName(self.autoNode, "autoTitle")
	self.Node_vip = SoraDGetChildByName(self.autoNode, "Node_vip")
	self.autoTime = SoraDGetChildByName(self, "autoTime")
	self.autoTimeBg = SoraDGetChildByName(self, "autoTimeBg")
	self.marchingTroop = SoraDGetChildByName(self, "marchingTroop")
	self.marchingTroop = include("heroTrialMarchingTroop").new(self.marchingTroop)
	self.sweepNode = SoraDGetChildByName(self, "sweepNode")
	self.sweepBtn = SoraDGetChildByName(self.sweepNode, "sweepBtn")
	self.sweepBtn:addTouchEventListener(handler(self, self.onSweepClick))
	self.sweepTitle = SoraDGetChildByName(self.sweepNode, "sweepTitle")
	self.sweepTitle:setString(i18n("epicbattle_btn_01"))
	SoraDGetChildByName(self, "Size_Tile_prise_bg"):setFillType(1)
	self.btnHelp = SoraDGetChildByName(self.praiseNode, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.onBtnHelpClick))
	trialNumTitle:setFontSize(14)
	local trialNumBg = SoraDGetChildByName(self, "trialNumBg")
	trialNumBg:setTouchEnabled(true)
	trialNumBg:addTouchEventListener(handler(self, self.onTrialNum))
	self.stopBtn:addTouchEventListener(handler(self, self.onStopTrial))
	title:setTitle(i18n("common_text_1697"))
	fastPassTitle:setString(i18n("common_text_1722"))
	trialNumTitle:setString(i18n("common_text_1725"))
	self.stopAutoBtn:setPressedActionEnabled(true)
	self.upBtn:setPressedActionEnabled(true)
	_UPVALUE4_ = i18n("common_text_1725")
	i18n("common_text_1725")[1] = cca.fadeTo(0.5, 0.3)
	i18n("common_text_1725")[2] = cca.fadeTo(0.5, 1)
	i18n("common_text_1725")[3] = cca.fadeTo(0.5, 0.3)
	i18n("common_text_1725")[4] = cca.fadeTo(0.5, 1)
	i18n("common_text_1725")[5] = cca.delay(4)
	i18n("common_text_1725")[6] = cca.delay(4)
	self.upBtn:runAction(cca.repeatForever(cca.seq(i18n("common_text_1725"))))
	self.praiseBtn:setPressedActionEnabled(true)
	upTouch:setSwallowTouches(false)
	upTouch:addTouchEventListener(handler(self, self.onUp))
	praiseTouch:setSwallowTouches(false)
	praiseTouch:addTouchEventListener(handler(self, self.onLeft))
	self.resumeTime:setVisible(false)
	self.trialNum:setString(htPointMgr.getPoint())
	self.scrollView = SoraDGetChildByName(self, "scrollView")
	self.logContainer = ccui.Layout:create()
	self.scrollView:addChild(self.logContainer)
	self.scrollView:addEventListener(handler(self, self.scrollEventCallBack))
	self.scrollView:setBounceEnabled(true)
	local pos = cc.p(self.bottomBg:getPosition())
	self.moveY = pos.y
	self.moveX = -praiseBg:getContentSize().width + 5
	self.upState = 0
	self.leftState = 0
	self.isMoved = false
	self.isAttack = false
	self.isAuto = false
	self.isMapWin = false
	self.logCache, _ENV, self.isBattleFinish = -praiseBg:getContentSize().width + 5, -praiseBg:getContentSize().width + 5, true
	self.logHeight = 0
	self.entityZorder = 998
	self.marchZorder = 1000
	self.lineZorder = 999
	self:updatePraisePanel()
end
function heroTrialMapView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_POINT_UPDATE", self.updateData)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_MAPINFO", self.updatePraisePanel)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_RSP", self.handleRsp)
	SoraDAddMessage(self, "MESSAGE_UI_HEROTRIAL_NEED_OPEN", self.onNeedOpen)
	SoraDAddMessage(self, "MESSAGE_LORDVALUE_VIP", function()
		self:setAutoState(self.isAuto)
	end)
	SoraDCreateTimerEx(self, handler(self, self.onUpdateTime), 0.1)
	SoraDCreateTimerEx(self, handler(self, self.onUpdatePraiseData), 60)
end
function heroTrialMapView:onNeedOpen()
	self.needOpenTrial = true
end
function heroTrialMapView:initData(mapId)
	self.mapId = mapId
	local mapsInfo = require("app." .. LocalTblPath .. ".config_client.heroTrialMapInfo")
	self.mapInfo = mapsInfo[mapId]
	self.curUnlockId = htMapMgr.getLastUnlockStage()
	self.curStageId = tonumber(mapId .. "01")
	self:initMap()
	if heroTrialCommon.isTrialStarted(self.mapId) then
		self:startTrial()
		self:beginBattle()
		self:moveViewTo(self.mapInfo.list[self.curStageId].pos)
	else
		self:moveViewTo(self.mapInfo.list[self.curStageId].pos)
		self:setAutoState(false)
	end
	heroTrialCtrl:getMapInfo(self.mapId)
	self:updateLog()
	self:onUpdateTime()
	self.faceToDistanceNode = include("worldMapFaceToDistance").new()
	self:addChild(self.faceToDistanceNode)
	self.faceToDistanceNode:addTouchEventListener(handler(self, self.onFaceDistance))
	self:updateFaceToDistance()
	self:refreshSweepNode()
end
function heroTrialMapView:startTrial()
	SoraDAddMessage(self, "MESSAGE_UI_HEROTRIAL_ARMYGO", self.armyGo)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_BEGIN_BATTLE", self.beginBattle)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_END_BATTLE", self.endBattle)
	SoraDAddMessage(self, "MESSAGE_UI_HEROTRIAL_AUTOBATTLE", self.autoBattle)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_AUTOTIME", self.updateAutoTime)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_UPDATE_LOG", self.addNewLog)
	SoraDAddMessage(self, "MESSAGE_UI_HEROTRIAL_MOVETO_MARCH", self.moveToMarch)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_STOP_AUTO", self.stopAuto)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_SPEEDUP", self.speedUp)
	if htBattleMgr.autoStatus then
		self:setAutoState(true)
	else
		self:setAutoState(false)
	end
	self.curStageId = htBattleMgr.curTrialMap:getLastStage()
	self:updateLog()
	self:resetEntity()
end
function heroTrialMapView:stopTrial()
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_UI_HEROTRIAL_ARMYGO")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_SERVER_HEROTRIAL_BEGIN_BATTLE")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_SERVER_HEROTRIAL_END_BATTLE")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_UI_HEROTRIAL_AUTOBATTLE")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_SERVER_HEROTRIAL_AUTOTIME")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_SERVER_HEROTRIAL_UPDATE_LOG")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_UI_HEROTRIAL_MOVETO_MARCH")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_SERVER_HEROTRIAL_STOP_AUTO")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_SERVER_HEROTRIAL_SPEEDUP")
	self:setAutoState(false)
	self.marchingTroop:setVisible(false)
	if self.moveLine then
		self.moveLine:removeFromParent()
		self.moveLine = nil
	end
	if self.warMatrix then
		self.warMatrix:removeFromParent()
		self.warMatrix = nil
	end
	self.isAttack = false
	self.isAuto = false
	self.curStageId = tonumber(self.mapId .. "01")
	self:resetEntity()
end
function heroTrialMapView:updatePraisePanel(data)
	local children = self.praiseNode:getChildren()
	if not data then
		self.praiseTip:setString(i18n("common_text_1723"))
		self.praiseLight:setVisible(false)
		for i = 1, 3 do
			local item = SoraDGetChildByName(self.praiseNode, "praiseItemNode" .. i)
			item:setVisible(false)
		end
		return
	end
	if data.likeStatus then
		_ENV = SoraDGetChildByName(self.praiseNode, "praiseItemNode" .. i)
		SoraDGetChildByName(self.praiseNode, "praiseItemNode" .. i).buff = heroTrialltCtrl.getLikeAttackBuff()
		self.praiseTip:setString(i18n("common_text_1724", (SoraDGetChildByName(self.praiseNode, "praiseItemNode" .. i))))
	else
		self.praiseTip:setString(i18n("common_text_1723"))
	end
	if data.likeStatus == false and data.rankingData then
		self.praiseLight:setVisible(true)
		if not self.praiseLightAction then
			self.praiseLightAction = true
			self.praiseLight:setOpacity(0)
			_UPVALUE2_ = i18n("common_text_1723")
			i18n("common_text_1723")[1] = cca.fadeIn(1.5)
			i18n("common_text_1723")[2] = cca.delay(0.5)
			i18n("common_text_1723")[3] = cca.fadeOut(1.5)
			i18n("common_text_1723")[4] = cca.fadeOut(1.5)
			i18n("common_text_1723")[5] = cca.fadeOut(1.5)
			i18n("common_text_1723")[6] = cca.fadeOut(1.5)
			i18n("common_text_1723")[7] = cca.fadeOut(1.5)
			i18n("common_text_1723")[8] = cca.fadeOut(1.5)
			i18n("common_text_1723")[9] = cca.fadeOut(1.5)
			self.praiseLight:runAction(cca.repeatForever(cca.seq(i18n("common_text_1723"))))
		end
	else
		self.praiseLight:stopAllActions()
		self.praiseLight:setVisible(false)
		self.praiseLightAction = false
	end
	for i = 1, 3 do
		local item = SoraDGetChildByName(self.praiseNode, "praiseItemNode" .. i)
		local name = SoraDGetChildByName(item, "name")
		local praiseIcon = SoraDGetChildByName(item, "praiseIcon")
		local praiseNum = SoraDGetChildByName(item, "praiseNum")
		if data.rankingData and data.rankingData[i] and data.rankingData[i].playerInfo then
			item:setVisible(true)
			if data.rankingData[i].playerInfo.allianceAbbr then
				name:setString(string.format("(%s)%s", data.rankingData[i].playerInfo.allianceAbbr, data.rankingData[i].playerInfo.nickName))
			else
				name:setString(string.format("%s", data.rankingData[i].playerInfo.nickName))
			end
			name = SoraDCreateScrollLabel(name, 160)
			praiseNum:setString(data.rankingData[i].likeNum)
			if data.likeStatus then
				praiseIcon:setTouchEnabled(false)
				praiseIcon:loadTexture("btn_herotrial_good_02.png", ccui.TextureResType.plistType)
			else
				praiseIcon:setTouchEnabled(true)
				praiseIcon:loadTexture("btn_herotrial_good_01.png", ccui.TextureResType.plistType)
				praiseIcon.rank = i
				praiseIcon.uid = data.rankingData[i].uid
				praiseIcon:addTouchEventListener(handler(self, self.onPraise))
			end
		else
			item:setVisible(false)
		end
	end
end
function heroTrialMapView:onPraise(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		sender:setTouchEnabled(false)
		self.praiseIcon = sender
		heroTrialCtrl:like(self.mapId, sender.uid, sender.rank)
	end
end
function heroTrialMapView:updateData()
	self.trialNum:setString(htPointMgr.getPoint())
end
function heroTrialMapView:initMap()
	self.mapView = SoraDTMXTiledMap:create(self.mapInfo.mapFile)
	self.mapViewSize = self.mapView:getContentSize()
	self.entityList, _ENV, self.buildLayer = self.mapView:getLayer("tile"), self.mapView:getLayer("tile"), self.mapView:getLayer("tile")
	local start = display.newSprite("#" .. self.mapInfo.start.data)
	start:setScaleX(self.mapInfo.start.scaleX)
	start:setScaleY(self.mapInfo.start.scaleY)
	start:setFlippedX(self.mapInfo.start.flipX)
	start:setPosition(self.mapInfo.start.pos)
	self.mapView:addChild(start, self.entityZorder)
	local entity
	for stageId, v in pairs(self.mapInfo.list) do
		entity = heroTrialEntity.new()
		entity:initData(v, self.levelBg, stageId, self)
		entity:idle()
		self.mapView:addChild(entity, self.entityZorder)
		self.entityList[stageId] = entity
	end
	local designSize = cc.size(640, 960)
	local viewSize = self:getContentSize()
	local factor = viewSize.height / designSize.height
	local addHeight = math.abs(self.moveY) + 100
	local containerViewSize = cc.size(designSize.width * 3 * factor, (designSize.height + addHeight) * factor)
	self.containerView = ccui.Layout:create()
	self.containerView:setContentSize(containerViewSize)
	self.containerView:setScale(3)
	self.containerView:setTouchEnabled(true)
	self.containerView:setSwallowTouches(false)
	self.containerView:addTouchEventListener(handler(self, self.onMapTouch))
	self.bgArea = display.newTilesSprite("SinglePicture/bg_mapTile.png", cc.rect(0, 0, containerViewSize.width, containerViewSize.height))
	self.bgArea:ignoreAnchorPointForPosition(false)
	self.bgArea:setAnchorPoint(cc.p(0.0, 0.0))
	self.containerView:addChild(self.bgArea, 0)
	self.tiledBg = display.newTilesSprite("SinglePicture/tiledmap.png", cc.rect(0, 0, containerViewSize.width, containerViewSize.height))
	self.tiledBg:ignoreAnchorPointForPosition(false)
	self.tiledBg:setAnchorPoint(cc.p(0.0, 0.0))
	self.containerView:addChild(self.tiledBg, 1)
	self.mapView:setScale(factor)
	self.mapView:ignoreAnchorPointForPosition(false)
	self.mapView:setAnchorPoint(cc.p(0.5, 0.5))
	self.mapView:setPosition(cc.p(containerViewSize.width / 2, containerViewSize.height / 2))
	self.containerView:addChild(self.mapView, 2)
	self.viewScrollView = cc.ScrollView:create(viewSize)
	self.viewScrollView:setContainer(self.containerView)
	self.viewScrollView:setMinScale(0.9)
	self.viewScrollView:setMaxScale(1.35)
	self.viewScrollView:setZoomScale(1.0)
	self.viewScrollView:setBounceable(false)
	self.viewScrollView:setInertiaValue(0.35)
	self.viewScrollView:setPosition(cc.p(0, 0))
	self:addChild(self.viewScrollView, 0)
end
function heroTrialMapView:onUpdatePraiseData()
	if self.mapId then
		heroTrialCtrl:getMapInfo(self.mapId)
	end
end
function heroTrialMapView:onUpdateTime()
	self:updateAutoTime()
	self.marchingTroop:updateTime()
end
function heroTrialMapView:onUp(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		sender:setTouchEnabled(false)
		local moveTime = 0.1
		local callFunc = cca.callFunc(function()
			self.upBtn:setFlippedY(not self.upBtn:isFlippedY())
			sender:setTouchEnabled(true)
			sender:setSwallowTouches(false)
		end)
		local moveBy = cca.moveBy(moveTime, 0, -self.moveY)
		if self.upState == 0 then
			_UPVALUE2_ = nil
			;(nil)[1] = moveBy
			;(nil)[2] = callFunc
			self.bottomBg:runAction(cca.seq(nil))
			self.upState = 1
			self.upBtn:setOpacity(255)
			self.upBtn:stopAllActions()
		else
			_UPVALUE2_ = cca.seq(nil)
			cca.seq(nil)[1] = moveBy:reverse()
			cca.seq(nil)[2] = callFunc
			self.bottomBg:runAction(cca.seq(cca.seq(nil)))
			self.upState = 0
			_UPVALUE4_ = cca.seq(cca.seq(nil))
			cca.seq(cca.seq(nil))[1] = cca.fadeTo(0.5, 0.3)
			cca.seq(cca.seq(nil))[2] = cca.fadeTo(0.5, 1)
			cca.seq(cca.seq(nil))[3] = cca.fadeTo(0.5, 0.3)
			cca.seq(cca.seq(nil))[4] = cca.fadeTo(0.5, 1)
			cca.seq(cca.seq(nil))[5] = cca.delay(4)
			cca.seq(cca.seq(nil))[6] = cca.delay(4)
			self.upBtn:runAction(cca.repeatForever(cca.seq(cca.seq(cca.seq(nil)))))
		end
	end
end
function heroTrialMapView:onLeft(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		sender:setTouchEnabled(false)
		local moveTime = 0.5
		local callFunc = cca.callFunc(function()
			if self.leftState == 0 then
				self.praiseBtn:loadTextureNormal("btn_herotrial_round_01.png", ccui.TextureResType.plistType)
				self.praiseBtn:loadTexturePressed("btn_herotrial_round_01.png", ccui.TextureResType.plistType)
			else
				self.praiseBtn:loadTextureNormal("btn_herotrial_round_02.png", ccui.TextureResType.plistType)
				self.praiseBtn:loadTexturePressed("btn_herotrial_round_02.png", ccui.TextureResType.plistType)
			end
			sender:setTouchEnabled(true)
			sender:setSwallowTouches(false)
		end)
		local moveBy = cca.moveBy(moveTime, self.moveX, 0)
		if self.leftState == 0 then
			_UPVALUE2_ = nil
			;(nil)[1] = moveBy
			;(nil)[2] = callFunc
			self.praiseNode:runAction(cc.EaseExponentialOut:create(cca.seq(nil)))
			self.leftState = 1
		else
			_UPVALUE2_ = cc.EaseExponentialOut:create(cca.seq(nil))
			cc.EaseExponentialOut:create(cca.seq(nil))[1] = moveBy:reverse()
			cc.EaseExponentialOut:create(cca.seq(nil))[2] = callFunc
			self.praiseNode:runAction(cc.EaseExponentialOut:create(cca.seq(cc.EaseExponentialOut:create(cca.seq(nil)))))
			self.leftState = 0
		end
	end
end
function heroTrialMapView:quitPanel(type)
	local closeCb = function()
		self:close(nil, ccui.TouchEventType.ended)
	end
	if type == heroTrialMapView.QUIT_COMPLETE then
		local panel = SoraDCreatePanel("heroTrialFinish")
		if SoraDFIsRA() then
			panel:initData("winAr", closeCb)
		else
			panel:initData("winEn", closeCb)
		end
		panel:show()
	elseif type == heroTrialMapView.QUIT_MANUAL then
		self:close(nil, ccui.TouchEventType.ended)
	elseif type == heroTrialMapView.QUIT_NOSOLDIERS then
		local panel = SoraDCreatePanel("heroTrialFinish")
		if SoraDFIsRA() then
			panel:initData("loseAr", closeCb)
		else
			panel:initData("loseEn", closeCb)
		end
		panel:show()
	end
end
function heroTrialMapView:onExitPanel()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_HEROTRIAL_UPDATE_AREA"
	SoraDSendMessage(nil)
	SoraDRemoveAllAfterPanelFromManager(self, true)
end
function heroTrialMapView:onBtnHelpClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("common_text_3161"))
	end
end
function heroTrialMapView:onStopTrial(sender, type)
	if type == ccui.TouchEventType.ended and heroTrialCommon.isTrialStarted(self.mapId) then
		SoraDPlaySound()
		_ENV = nil
		;(nil).point = HEROTRIAL_COST_POINTS
		SoraDShowMsgBox(i18n("common_text_1746", nil), i18n("common_text_054"), i18n("common_text_185"), function(type, sender)
			if type == MSGBOX_CALLBACK_YES then
				self.quitType = heroTrialMapView.QUIT_MANUAL
				heroTrialCtrl:quitTrial()
			end
		end)
	end
end
function heroTrialMapView:checkOpenTrial()
	local title = i18n("common_text_1742")
	if htBattleMgr.trialStatus then
		title = i18n("common_text_1836")
	end
	SoraDShowMsgBox(title, i18n("common_text_054"), i18n("common_text_185"), function(type, sender)
		if type == MSGBOX_CALLBACK_YES then
			local armyIDList = armyCtrl:getArmyIDList()
			local count = 0
			for i, v in ipairs(armyIDList) do
				count = count + armyCtrl:getArmyCount(v, ARMY_OPTYPE.ALL_ARMY)
			end
			if 0 < count then
				heroTrialCtrl:openTrial(self.mapId)
				self.canOpenTrial = true
				self.stopAutoBtn:setTouchEnabled(false)
			else
				SoraDShowMsgBox(i18n("common_text_1744"), i18n("common_text_054"))
			end
		end
	end)
end
function heroTrialMapView:openDispatch()
	local dispatchPanel = include("heroTrialDispatchArmy").new()
	local beginTile, endTile = self:getMarchTile()
	dispatchPanel:initData(true, beginTile, endTile)
	dispatchPanel:show()
end
function heroTrialMapView:onStartAuto(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self.isAttack then
			if not heroTrialCommon.isTrialStarted(self.mapId) then
				if htPointMgr.isPointEnough(heroTrialltCtrl.getCostPointOfTrial()) then
					self:checkOpenTrial()
				else
					local itemId = 800301
					local itemCount = backpackCtrl:getItemCount(itemId)
					if 0 < itemCount then
						_ENV, _ENV = heroTrialltCtrl.getCostPointOfTrial()
						heroTrialltCtrl.getCostPointOfTrial().id = itemId
						heroTrialltCtrl.getCostPointOfTrial().itemData, heroTrialltCtrl.getCostPointOfTrial().count = heroTrialltCtrl.getCostPointOfTrial()
						heroTrialltCtrl.getCostPointOfTrial().msg = i18n("common_text_3420")
						uiManager:show("newItemSingleUse", heroTrialltCtrl.getCostPointOfTrial())
					else
						_ENV = heroTrialltCtrl.getCostPointOfTrial()
						heroTrialltCtrl.getCostPointOfTrial().point = HEROTRIAL_COST_POINTS
						SoraDShowMsgTip(i18n("common_text_1743", heroTrialltCtrl.getCostPointOfTrial()))
					end
				end
			else
				self:openDispatch()
			end
		else
			SoraDShowMsgTip(i18n("common_text_1745"))
		end
	end
end
function heroTrialMapView:onStopAuto(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgBox(i18n("common_text_1747"), i18n("common_text_054"), i18n("common_text_185"), function(type, sender)
			if type == MSGBOX_CALLBACK_YES then
				heroTrialCtrl:quitAutoTrial()
				self:setAutoState(false)
			end
		end)
	end
end
function heroTrialMapView:setAutoState(isAuto)
	if isAuto then
		self.isAuto = true
		self.autoNode:setVisible(true)
		self.stopBtn:setVisible(false)
		self.autoTitle:setString(i18n("common_text_1767"))
		self.stopAutoBtn:addTouchEventListener(handler(self, self.onStopAuto))
	else
		self.isAuto = false
		self.autoNode:setVisible(true)
		if heroTrialCommon.isTrialStarted(self.mapId) then
			self.stopBtn:setVisible(true)
		else
			self.stopBtn:setVisible(false)
		end
		self.autoTitle:setString(i18n("common_text_1766"))
		self.stopAutoBtn:addTouchEventListener(handler(self, self.onStartAuto))
	end
	self:updateAutoTime()
	self.Node_vip:setVisible(false)
	local vip_limited = IsArClient and _G.VIP_LV5_LIMITED or _G.VIP_LV4_LIMITED
	_ENV = handler(self, self.onStartAuto)
	handler(self, self.onStartAuto).vip = vip_limited
	self.autoTip:setString(i18n("common_text_1771", handler(self, self.onStartAuto)))
	local vipDetail = lordInfoCtrl:getVipDetails()
	if not vipDetail.isActivated or not (vip_limited <= vipDetail.level) then
		self.Node_vip:setVisible(true)
		self.stopAutoBtn:addTouchEventListener(function(sender, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				SoraDShowMsgBox(i18n("common_text_1837"), i18n("common_text_449"), i18n("common_text_1838"), handler(self, self.openVipView))
			end
		end)
	end
end
function heroTrialMapView:openVipView(type)
	if type == MSGBOX_CALLBACK_YES then
		SoraDPlaySound()
		uiManager:show("vipCenterView")
	end
end
function heroTrialMapView:onMapTouch(sender, type)
	if type == ccui.TouchEventType.began then
		self.isMoved = false
	elseif type == ccui.TouchEventType.moved then
		local beganPos = sender:getTouchBeganPosition()
		local movePos = sender:getTouchMovePosition()
		local distance = cc.pGetDistance(beganPos, movePos)
		if distance > TOUCH_MOVED_ERROR_VALUE then
			self.isMoved = true
		end
		self:updateFaceToDistance()
	elseif type == ccui.TouchEventType.ended then
		if self.isMoved then
			return
		end
		local endPos = sender:getTouchEndPosition()
		for stageId, entity in pairs(self.entityList) do
			if entity:hitTest(endPos) then
				SoraDPlaySound()
				self:onEntityTouch(stageId)
				break
			end
		end
	end
end
function heroTrialMapView:onEntityTouch(stageId)
	if stageId < self.curStageId then
		return
	end
	SoraDPlaySound()
	local panel = SoraDCreatePanel("heroTrialLevelInfo")
	local canAttack, defendSoldiers
	if stageId == self.curStageId and not self.isAttack and not self.isAuto then
		canAttack = true
		if heroTrialCommon.isTrialStarted(self.mapId) then
			defendSoldiers = htBattleMgr.curTrialMap:getDefendingSoldiers()
		else
			defendSoldiers = heroTrialltCtrl.getDefendingSoldiersOfStage(stageId)
		end
	else
		canAttack = false
		defendSoldiers = heroTrialltCtrl.getDefendingSoldiersOfStage(stageId)
	end
	local bustName = "icon_herotrial_monster_01.png"
	if heroTrialCommon.convertLevelToNum(stageId) % 10 == 0 then
		bustName = "icon_herotrial_monster_02.png"
	end
	if self.mapInfo.list[stageId].typeName == "animation" then
		local str = util.split(self.mapInfo.list[stageId].data, "_")
		bustName = str[1] .. "_bust.png"
	end
	local beginTile, endTile = self:getMarchTile()
	panel:initData(canAttack, defendSoldiers, stageId, bustName, beginTile, endTile, self.mapId)
	panel:show()
end
function heroTrialMapView:onTrialDetail(sender, type)
	if type == ccui.TouchEventType.ended then
		local logData = sender.data.logData
		if logData and logData.report then
			SoraDPlaySound()
			local panel = SoraDCreatePanel("heroTrialReport")
			panel:initData(logData)
			panel:show()
		end
	end
end
function heroTrialMapView:updateAutoTime()
	self.autoTimeBg:setVisible(false)
	local queue = queueCtrl:queryQueue(gQueueTypeDef.auto_trial_prepare)
	if queue then
		local leftTime = queue.timerNode.timer:getRemainTime()
		if 0 < leftTime then
			self.autoTimeBg:setVisible(true)
		end
		queueCtrl = nil
		;(nil).time = SoraDConvertSecondToString(leftTime)
		self.autoTime:setString(i18n("common_text_1768", nil))
	end
end
function heroTrialMapView:autoBattle(data)
	heroTrialCtrl:autoTrial(self.curStageId, data.armyList)
end
function heroTrialMapView:autoRsp(err)
	if err == gErrDef.Err_None then
		self:setAutoState(true)
	end
end
function heroTrialMapView:quitRsp(err, data)
	if err == gErrDef.Err_None then
		self:quitPanel(self.quitType)
		self.quitType = nil
	end
end
function heroTrialMapView:likeRsp(err, data)
	if err == gErrDef.Err_None then
		if self.praiseIcon then
			SoraDCreateWaveLabel("+1", self.praiseIcon)
		end
		data.likeStatus = true
		self:updatePraisePanel(data)
	end
end
function heroTrialMapView:startTrialRsp(err)
	if err == gErrDef.Err_None then
		self:startTrial()
		if self.canOpenTrial then
			self.canOpenTrial = false
			self:openDispatch()
			self.stopAutoBtn:setTouchEnabled(true)
		end
	end
end
function heroTrialMapView:handleRsp(data)
	local specialErr
	if data.rsp.subcmd == gCmd.REQ_HT_OPEN_TRIAL and data.rsp.data.mapID == self.mapId then
		self:startTrialRsp(data.rsp.err, data.rsp.data)
	elseif data.rsp.subcmd == gCmd.REQ_HT_QUIT_TRIAL then
		specialErr = self:quitRsp(data.rsp.err, data.rsp.data)
	elseif data.rsp.subcmd == gCmd.REQ_HT_AUTO_TRIAL and heroTrialCommon.isTrialStarted(self.mapId) then
		specialErr = self:autoRsp(data.rsp.err, data.rsp.data)
	elseif data.rsp.subcmd == gCmd.REQ_HT_LIKE and data.rsp.data.mapID == self.mapId then
		specialErr = self:likeRsp(data.rsp.err, data.rsp.data)
	else
		specialErr = data.rsp.err
	end
	if not specialErr and data.rsp.err ~= gErrDef.Err_None then
		local errStr = msgNotice.getTipCode(data.rsp.err)
		if not errStr then
			errStr = data.rsp.err
		else
			errStr = i18n(errStr)
		end
		SoraDShowMsgTip(errStr)
	end
end
function heroTrialMapView:armyGo(data)
	heroTrialCtrl:attackStage(self.curStageId, data.armyList)
end
function heroTrialMapView:getMarchTile()
	local beginPos, endPos = self:getMarchPos()
	local beginTile = heroTrialCommon.nodeToTileCoord(self.mapView, beginPos)
	local endTile = heroTrialCommon.nodeToTileCoord(self.mapView, endPos)
	return beginTile, endTile
end
function heroTrialMapView:getMarchPos()
	local firstStageId = heroTrialltCtrl.getFirstStageOfMap(self.mapId)
	local beginPos
	local endPos = self.mapInfo.list[self.curStageId].pos
	if self.curStageId == firstStageId then
		beginPos = self.mapInfo.start.pos
	else
		beginPos = self.mapInfo.list[self.curStageId - 1].pos
	end
	return beginPos, endPos
end
function heroTrialMapView:beginBattle()
	self.queue = queueCtrl:queryQueue(gQueueTypeDef.trial_march)
	if not self.queue then
		return
	end
	if not self.isBattleFinish then
		self:stopAllActions()
		self:battleFinish()
	end
	self.isAttack = true
	local soldiers = self.queue.data.soldiers
	self.marchingTroop:setVisible(true)
	self.marchingTroop:updateTime()
	local beginPos, endPos = self:getMarchPos()
	if self.warMatrix then
		self.warMatrix:removeFromParent()
		self.warMatrix = nil
	end
	if self.moveLine then
		self.moveLine:removeFromParent()
		self.moveLine = nil
	end
	local node = display.newNode()
	node:setGroupID(worldMapDefine.GROU_ID.group_moveline_particle, true)
	node:addTo(self.mapView, self.marchZorder + 1)
	local troopsMatrix = include("troopsMatrixHeroTrial")
	self.warMatrix = troopsMatrix.new()
	self.mapView:addChild(self.warMatrix, self.marchZorder)
	queueCtrl, _ENV = nil, 0
	;(nil).armyList = soldiers
	;(0)[1] = nil
	self.warMatrix:initData(beginPos, endPos, cc.p(0, 0), cc.p(0, 0), 4, 0)
	self.warMatrix:setPosition(beginPos)
	self.warMatrix:setVisible(true)
	self.warMatrix:setTouchEnabled(false)
	self.warMatrix:setSoliderVisible(true)
	self.moveLine = include("worldMapMoveLine").new(beginPos, endPos)
	self.moveLine:setPosition(beginPos)
	self.moveLine:setMoveLineID(1)
	self.moveLine:showMoveline(0)
	self.moveLine:setMoveLineColor(gMapMoveLineColor.moveLineColorGreen)
	self.mapView:addChild(self.moveLine, self.lineZorder)
	self.warMatrix:setMoveLine(self.moveLine)
	local data = htBattleMgr.getMVTimeData()
	if data then
		local totalTime = 0
		for i, v in ipairs(data.moveSpan) do
			totalTime = totalTime + v.time
		end
		local leftTime = self.queue.timerNode.timer:getRemainTime()
		local currTime = util.clampf(totalTime - leftTime, 0, totalTime)
		print("currTime = ", currTime)
		dump(data.moveSpan, "data.moveSpan = ")
		queueCtrl = "data.moveSpan = "
		;("data.moveSpan = ").currentMoveTime = currTime
		;("data.moveSpan = ").moveTimeSpan = data.moveSpan
		self.warMatrix:setMoveTimeData("data.moveSpan = ")
		self.warMatrix:beginMove(0)
		self.warMatrix:setMedalEffect(dressCtrl:getCurDressID(gDressType.MARCH), false)
	end
end
function heroTrialMapView:endBattle(data)
	self.marchingTroop:setVisible(false)
	if self.warMatrix then
		self.warMatrix:removeFromParent()
		self.warMatrix = nil
	end
	if self.moveLine then
		self.moveLine:removeFromParent()
		self.moveLine = nil
	end
	local soldiers = data.soldiers
	local troopsMatrix = include("troopsMatrixHeroTrial")
	self.warMatrix = troopsMatrix.new()
	self.mapView:addChild(self.warMatrix, self.marchZorder)
	local beginPos, endPos = self:getMarchPos()
	_ENV, dressCtrl = nil, 0
	;(nil).armyList = soldiers
	;(0)[1] = nil
	self.warMatrix:initData(beginPos, endPos, cc.p(0, 0), cc.p(0, 0), 4, 0)
	self.warMatrix:setPosition(endPos)
	self.warMatrix:setVisible(true)
	self.warMatrix:setTouchEnabled(false)
	self.warMatrix:setMedalEffect(dressCtrl:getCurDressID(gDressType.MARCH), false)
	self.warMatrix:setSoliderVisible(true)
	self.moveLine = include("worldMapMoveLine").new(endPos, endPos)
	self.moveLine:setPosition(endPos)
	self.moveLine:setMoveLineID(1)
	self.moveLine:showMoveline(0)
	self.moveLine:setMoveLineColor(gMapMoveLineColor.moveLineColorGreen)
	self.mapView:addChild(self.moveLine, self.lineZorder)
	self.warMatrix:setMoveLine(self.moveLine)
	self.moveLine:setVisible(false)
	self.endBattleData = data
	self.isBattleFinish = false
	_UPVALUE2_ = self.lineZorder
	self.lineZorder[1] = cca.callFunc(handler(self, self.battleAttack))
	self.lineZorder[2] = cca.delay(5)
	self.lineZorder[3] = cca.callFunc(handler(self, self.battleFinish))
	self.lineZorder[4] = cca.callFunc(handler(self, self.battleFinish))
	self.lineZorder[5] = cca.callFunc(handler(self, self.battleFinish))
	self.lineZorder[6] = cca.callFunc(handler(self, self.battleFinish))
	self:runAction(cca.seq(self.lineZorder))
end
function heroTrialMapView:battleAttack()
	local entity = self.entityList[self.curStageId]
	if entity and self.warMatrix then
		self.warMatrix:setMatrixState(gMapMoveLineStatusType.moveLineStatusTypeWorking)
		entity:attack()
	end
end
function heroTrialMapView:battleFinish()
	if not self.endBattleData then
		return
	end
	local entity = self.entityList[self.curStageId]
	local data = self.endBattleData
	if data.battleRet then
		self:playWin()
	else
		self:playLose()
	end
	self.curUnlockId = htMapMgr.getLastUnlockStage()
	if not data.finish then
		self.curStageId = htBattleMgr.curTrialMap:getLastStage()
		self.entityList[self.curStageId]:updateState()
		self:moveViewTo(self.mapInfo.list[self.curStageId].pos, 1.0)
		self:updateFaceToDistance()
	end
	if self.moveLine then
		self.moveLine:removeFromParent()
	end
	if self.warMatrix then
		self.warMatrix:removeFromParent()
	end
	if data.battleRet then
		if data.finish then
			self.isMapWin = true
		end
		entity:dead()
	else
		entity:idle()
	end
	self.moveLine = nil
	self.warMatrix = nil
	self.isAttack = false
	self.isBattleFinish = true
	if data.battleRet and data.finish then
		self:quitPanel(heroTrialMapView.QUIT_COMPLETE)
	elseif data.battleRet == false and data.finish then
		self:quitPanel(heroTrialMapView.QUIT_NOSOLDIERS)
	elseif self.isAutoQuit then
		SoraDShowMsgBox(i18n("common_text_1877"), i18n("common_text_054"))
		self.isAutoQuit = false
	end
	if self.updateLogAfterAdd then
		self:updateLog()
		self.updateLogAfterAdd = false
	end
end
function heroTrialMapView:playWin()
	local logList = htLogMgr:getLogList()
	local rewards
	for i, v in ipairs(logList) do
		if v.logData and v.logData.stageID == self.curStageId then
			rewards = v.logData.reward
		end
	end
	if rewards and 0 < #rewards then
		local htLogMgr, itemList = #rewards, #rewards
		for i, v in ipairs(rewards) do
			itemList[v.id] = v.count
		end
		SoraDMailGainItems(itemList)
	end
end
function heroTrialMapView:playLose(...)
	local logList = htLogMgr:getLogList()
	for i, v in ipairs(logList) do
		if v.logData and v.logData.stageID == self.curStageId then
			logData = v.logData
			break
		end
	end
	local panel = SoraDCreatePanel("epicBattleLostPopView")
	panel:setBtnLookHandle(function()
		local panel = SoraDCreatePanel("heroTrialReport")
		panel:initData(logData)
		panel:show()
	end)
	panel:setSpineVisible(false)
	panel:show()
end
function heroTrialMapView:addTrailLog(data)
	local scrollViewSize = self.scrollView:getContentSize()
	local timeStr = os.date("[%Y-%m-%d %H:%M:%S]", data.time)
	if heroTrialCommon.isSameDay(data.time, os.time()) then
		timeStr = os.date("[%H:%M:%S]", data.time)
	end
	_UPVALUE6_ = os.date("[%H:%M:%S]", data.time)
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[1] = i18n("common_text_1713"), i18n("common_text_1713")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[2] = i18n("common_text_1713"), i18n("common_text_1714")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[3] = i18n("common_text_1713"), "common_text_1716"
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[4] = i18n("common_text_1713"), "common_text_1716"
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[5] = i18n("common_text_1713"), i18n("common_text_1717")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[6] = i18n("common_text_1713"), i18n("common_text_1718")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[7] = i18n("common_text_1713"), i18n("common_text_1719")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[8] = i18n("common_text_1713"), i18n("common_text_1719")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[9] = i18n("common_text_1713"), i18n("common_text_1719")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[10] = i18n("common_text_1713"), i18n("common_text_1719")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[11] = i18n("common_text_1713"), i18n("common_text_1719")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[12] = i18n("common_text_1713"), i18n("common_text_1719")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[13] = i18n("common_text_1713"), i18n("common_text_1719")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[14] = i18n("common_text_1713"), i18n("common_text_1719")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[15] = i18n("common_text_1713"), i18n("common_text_1719")
	local heroTrialCommon, os.date("[%H:%M:%S]", data.time)[16], strList = i18n("common_text_1713"), i18n("common_text_1719")
	i18n("common_text_1713")[1] = i18n("common_text_152")
	i18n("common_text_1713")[2] = i18n("mail_text_14")
	i18n("common_text_1713")[3] = i18n("mail_text_14")
	i18n("common_text_1713")[4] = i18n("mail_text_14")
	i18n("common_text_1713")[5] = i18n("mail_text_14")
	i18n("common_text_1713")[6] = i18n("mail_text_14")
	i18n("common_text_1713")[7] = i18n("mail_text_14")
	i18n("common_text_1713")[8] = i18n("mail_text_14")
	i18n("common_text_1713")[9] = i18n("mail_text_14")
	i18n("common_text_1713")[10] = i18n("mail_text_14")
	i18n("common_text_1713")[11] = i18n("mail_text_14")
	i18n("common_text_1713")[12] = i18n("mail_text_14")
	i18n("common_text_1713")[13] = i18n("mail_text_14")
	i18n("common_text_1713")[14] = i18n("mail_text_14")
	local i18n("common_text_1713")[15], strResult = i18n("mail_text_14")
	local contentStr = strList[data.logType]
	local lookStr = i18n("common_text_1720")
	local limitWidth = scrollViewSize.width - 10
	local logCell = ccui.Layout:create()
	_ENV = i18n("mail_text_14")
	i18n("mail_text_14").anchor = cc.p(0, 0.5)
	local label = SoraDCreateHtmlRichText(i18n("mail_text_14"))
	if data.logType == gTrialLogType.ATTACK_STAGE_SUCCESS or data.logType == gTrialLogType.ATTACK_STAGE_FAILED then
		_ENV = 0
		;(0).level = heroTrialCommon.convertLevelToNum(data.logData.stageID)
		contentStr = i18n(contentStr, 0)
		_ENV = contentStr
		contentStr.color = cc.c3b(212, 206, 180)
		local str = SoraDWrapHtmlTagByStyle(timeStr .. contentStr, contentStr)
		local resultStr, resultColor
		if data.logType == gTrialLogType.ATTACK_STAGE_SUCCESS then
			resultStr = strResult[1]
			resultColor = cc.c3b(0, 255, 72)
		else
			resultStr = strResult[2]
			resultColor = cc.c3b(255, 0, 72)
		end
		_ENV = 72
		;(72).color = resultColor
		str = str .. SoraDWrapHtmlTagByStyle(resultStr, 72)
		label:setString(str)
		local btnWidth = 60
		SoraDGetAutoHeightLabel(label, limitWidth - btnWidth)
		local lookBtn = ccui.Button:create("icon_map_search.png", "", "", ccui.TextureResType.plistType)
		lookBtn.data = data
		lookBtn:addTouchEventListener(handler(self, self.onTrialDetail))
		lookBtn:addTo(logCell)
		if SoraDFIsRA() then
			lookBtn:setPositionX(limitWidth - btnWidth / 2)
		else
			label:setPositionX(btnWidth)
			lookBtn:setPositionX(btnWidth / 2)
		end
	else
		_ENV = contentStr
		contentStr.color = cc.c3b(212, 206, 180)
		local str = SoraDWrapHtmlTagByStyle(timeStr .. contentStr, contentStr)
		label:setString(str)
		SoraDGetAutoHeightLabel(label, limitWidth)
	end
	logCell:setContentSize(cc.size(limitWidth, label:getContentSize().height + 20))
	logCell:addChild(label)
	local size = logCell:getContentSize()
	local curY = -(self.logHeight + size.height / 2)
	self.logHeight = self.logHeight + size.height
	logCell:setPositionY(curY)
	self.logContainer:addChild(logCell)
	if scrollViewSize.height < self.logHeight then
		self.scrollView:setInnerContainerSize(cc.size(scrollViewSize.width, self.logHeight))
	end
	local innerSize = self.scrollView:getInnerContainerSize()
	self.logContainer:setPosition(cc.p(0, innerSize.height))
end
function heroTrialMapView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.bounceBottom then
	elseif event == ccui.ScrollviewEventType.bounceTop then
	end
end
function heroTrialMapView:addNewLog(data)
	self.updateLogAfterAdd = false
	if data.data.logType > 2 then
		self.updateLogAfterAdd = true
	else
		self:updateLog()
	end
end
function heroTrialMapView:updateLog()
	self:cleanLog()
	local logList = htLogMgr:getLogList()
	for i, v in ipairs(logList) do
		self:addTrailLog(v)
	end
end
function heroTrialMapView:cleanLog()
	self.logCache, _UPVALUE0_, self.logHeight = nil, nil, 0
	self.logContainer:removeAllChildren()
end
function heroTrialMapView:resetEntity()
	for id, v in pairs(self.entityList) do
		v:idle()
		if heroTrialCommon.isTrialStarted(self.mapId) and id < self.curStageId then
			v:deadEnd()
		end
	end
end
function heroTrialMapView:moveToMarch()
	if self.warMatrix then
		self:moveViewTo(cc.p(self.warMatrix:getPosition()))
	end
end
function heroTrialMapView:stopAuto()
	self.isAutoQuit = true
	self:setAutoState(false)
end
function heroTrialMapView:convertToContainerPos(pos)
	pos = self.mapView:convertToWorldSpace(pos)
	return self.containerView:convertToNodeSpace(pos)
end
function heroTrialMapView:moveViewTo(point, moveTime)
	point = self:convertToContainerPos(point)
	local zoomScale = self.viewScrollView:getZoomScale()
	local centerPoint = cc.p(display.cx, display.cy)
	local covertPoint = self.containerView:convertToNodeSpace(centerPoint)
	local offsetPoint = self.viewScrollView:getContentOffset()
	local subPoint = cc.pSub(covertPoint, point)
	local containerSize = self.containerView:getContentSize()
	local newOffsetPoint = cc.pAdd(offsetPoint, subPoint)
	newOffsetPoint = cc.p(newOffsetPoint.x * zoomScale, newOffsetPoint.y * zoomScale)
	if newOffsetPoint.x > 0 then
		newOffsetPoint.x = 0
	end
	if newOffsetPoint.x < display.width - containerSize.width then
		newOffsetPoint.x = display.width - containerSize.width
	end
	if newOffsetPoint.y > 0 then
		newOffsetPoint.y = 0
	end
	if newOffsetPoint.y < display.height - containerSize.height then
		newOffsetPoint.y = display.height - containerSize.height
	end
	if moveTime then
		self.viewScrollView:setContentOffsetInDuration(newOffsetPoint, moveTime)
	else
		self.viewScrollView:setContentOffset(newOffsetPoint)
	end
end
function heroTrialMapView:speedUp()
	if not self.warMatrix then
		return
	end
	local data = htBattleMgr.getMVTimeData()
	if data then
		htBattleMgr = nil
		;(nil).currentMoveTime = data.currentMoveTime
		;(nil).moveTimeSpan = data.moveSpan
		self.warMatrix:setMoveTimeData(nil)
		self.warMatrix:beginMove(0)
	end
end
function heroTrialMapView:onTrialNum(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).total = HEROTRIAL_TOTAL_COUNT
		_ENV = nil
		;(nil).vip = VIP_LV8_LIMITED
		;(nil).point = HEROTRIAL_VIP8_GET_POINTS
		_ENV = "\n"
		;("\n").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("common_text_1750", nil) .. "\n" .. i18n("common_text_1751", nil), "\n")
	end
end
function heroTrialMapView:onFaceDistance()
	local beginPos, endPos = self:getMarchPos()
	self:moveViewTo(endPos)
	self:updateFaceToDistance()
end
function heroTrialMapView:updateFaceToDistance()
	local beginPos, endPos = self:getMarchPos()
	local centerPos = self.buildLayer:convertToNodeSpace(cc.p(display.cx, display.cy))
	local distance = math.ceil(cc.pGetDistance(endPos, centerPos))
	if self.faceToDistanceNode and 400 < distance then
		self.faceToDistanceNode:updateData(math.floor(distance / 256))
		local showRect = cc.rect(60, 150, display.width - 120, display.height - 300)
		local isIntersect, intersectPointArray = SoraDLineIntersectRect(self.buildLayer:convertToWorldSpace(endPos), cc.p(display.cx, display.cy), showRect)
		if isIntersect and 0 < #intersectPointArray then
			local intersectPoint = intersectPointArray[1]
			self.faceToDistanceNode:setVisible(true)
			self.faceToDistanceNode:setPosition(intersectPoint)
			local rotation = SoraDGetAngleByPos(centerPos, endPos)
			if math.abs(rotation) > 90 then
				self.faceToDistanceNode:setFlippedY(true)
				self.faceToDistanceNode.distanceText:setFlippedX(true)
			else
				self.faceToDistanceNode:setFlippedY(false)
				self.faceToDistanceNode.distanceText:setFlippedX(false)
			end
			self.faceToDistanceNode:setRotation(-rotation)
		else
			self.faceToDistanceNode:setVisible(false)
		end
	else
		self.faceToDistanceNode:setVisible(false)
	end
end
function heroTrialMapView:initMapBorderData()
	local borderWidth = cc.pGetDistance(cc.p(0, 0), cc.p(self.mapViewSize.width / 2, self.mapViewSize.height / 2))
	local borderHeigh = borderWidth
	local rotation = -SoraDGetAngleByPos(cc.p(0, self.mapViewSize.height / 2), cc.p(self.mapViewSize.width / 2, self.mapViewSize.height))
	self.leftTop_borderArea = display.newTilesSprite("SinglePicture/bg_mapTile.png", cc.rect(0, 0, borderWidth, borderHeigh))
	self.leftTop_borderArea:ignoreAnchorPointForPosition(false)
	self.leftTop_borderArea:setAnchorPoint(cc.p(0.0, 0.0))
	self.leftTop_borderArea:setPosition(cc.p(0, self.mapViewSize.height / 2))
	self.leftTop_borderArea:setRotation(rotation)
	self.containerView:addChild(self.leftTop_borderArea, 1)
	rotation = -SoraDGetAngleByPos(cc.p(0, self.mapViewSize.height / 2), cc.p(self.mapViewSize.width / 2, 0))
	self.leftBottom_borderArea = display.newTilesSprite("SinglePicture/bg_mapTile.png", cc.rect(0, 0, borderWidth, borderHeigh))
	self.leftBottom_borderArea:ignoreAnchorPointForPosition(false)
	self.leftBottom_borderArea:setAnchorPoint(cc.p(0.0, 1.0))
	self.leftBottom_borderArea:setPosition(cc.p(0, self.mapViewSize.height / 2))
	self.leftBottom_borderArea:setRotation(rotation)
	self.containerView:addChild(self.leftBottom_borderArea, 1)
	rotation = -SoraDGetAngleByPos(cc.p(self.mapViewSize.width / 2, self.mapViewSize.height), cc.p(self.mapViewSize.width, self.mapViewSize.height / 2))
	self.rightTop_borderArea = display.newTilesSprite("SinglePicture/bg_mapTile.png", cc.rect(0, 0, borderWidth, borderHeigh))
	self.rightTop_borderArea:ignoreAnchorPointForPosition(false)
	self.rightTop_borderArea:setAnchorPoint(cc.p(0.0, 0.0))
	self.rightTop_borderArea:setPosition(cc.p(self.mapViewSize.width / 2, self.mapViewSize.height))
	self.rightTop_borderArea:setRotation(rotation)
	self.containerView:addChild(self.rightTop_borderArea, 1)
	rotation = -SoraDGetAngleByPos(cc.p(self.mapViewSize.width / 2, 0), cc.p(self.mapViewSize.width, self.mapViewSize.height / 2))
	self.rightBottom_borderArea = display.newTilesSprite("SinglePicture/bg_mapTile.png", cc.rect(0, 0, borderWidth, borderHeigh))
	self.rightBottom_borderArea:ignoreAnchorPointForPosition(false)
	self.rightBottom_borderArea:setAnchorPoint(cc.p(0.0, 1.0))
	self.rightBottom_borderArea:setPosition(cc.p(self.mapViewSize.width / 2, 0))
	self.rightBottom_borderArea:setRotation(rotation)
	self.containerView:addChild(self.rightBottom_borderArea, 1)
end
function heroTrialMapView:refreshSweepNode(...)
	local isPass = htMapMgr.getIsPass(self.mapId)
	local hasPrivilege = SoraDGetCtrl("exaltedPrivilegeCtrl"):checkPrivilege(gExaltedPrivilegeType.HERO_TRIAL_SWEEP)
	if isPass and hasPrivilege then
		self.sweepNode:setVisible(true)
		if htPointMgr.getPoint() > 0 then
			self.sweepTitle:setColor(cc.c3b(255, 200, 100))
		else
			self.sweepTitle:setColor(cc.c3b(190, 40, 40))
		end
	else
		self.sweepNode:setVisible(false)
	end
end
function heroTrialMapView:onSweepClick(target, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if htPointMgr.getPoint() <= 0 then
			SoraDShowMsgTip(i18n("privilege_text_95"))
			return
		end
		local dailyRemindManager = include("dailyRemindManager")
		local ctype = dailyRemindManager.REMIND_TYPE.heroTrialMapView
		if dailyRemindManager.checkNeedRemind(ctype) then
			SoraDShowMsgBox(i18n("privilege_text_96"), i18n("common_text_204"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					dailyRemindManager.addRemindToManager(ctype)
					heroTrialCtrl:reqSweep(self.mapId)
				end
			end)
		else
			heroTrialCtrl:reqSweep(self.mapId)
		end
	end
end
function heroTrialMapView:gameGuide_getTarget(itemName, parameters)
	if itemName == "challenge" then
		local single = self.entityList[self.curStageId]
		return single
	end
	return SoraDGetChildByName(self, itemName)
end
return heroTrialMapView
