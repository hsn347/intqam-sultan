local gametop = gModuleMgr.getObject("gametop")
local allianceHuntCtrl = gametop.playertop_:getModule("allianceHuntCtrl")
local allianceHuntDesRead = include("allianceHuntDesRead")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local constantRead = include("constantRead")
_ENV = "constantRead"
_ENV, ("constantRead").count_num = nil, 3
;(nil).screenWidth = 750
;(nil).safeAreaBottom = 320
;(nil).safeAreaTop = 220
_ENV, ("constantRead").battleArea, (nil).maxGroundH = nil, nil, 640
;(nil)[1] = cc.c4f(0, 0, 1, 1)
;(nil)[2] = cc.c4f(0, 1, 0, 1)
;(nil)[3] = cc.c4f(0, 1, 1, 1)
;("constantRead").debugColor, (nil)[4] = nil, cc.c4f(1, 0, 0, 1)
;("constantRead").timeSpeedNormal = 1.0
;("constantRead").timeSpeedFast = 2.0
;("constantRead").spawnScaleNoraml = 1.0
local ("constantRead").spawnScaleFast, _defaultParam = 2.0, "constantRead"
_defaultParam.battleArea.spawnX = -50
_defaultParam.battleArea.endX = -_defaultParam.battleArea.spawnX + _defaultParam.battleArea.screenWidth
_defaultParam.battleArea.totalH = display.height - (_defaultParam.battleArea.safeAreaBottom + _defaultParam.battleArea.safeAreaTop)
_defaultParam.battleArea.singleH = _defaultParam.battleArea.totalH / 5
local roadGroud3Top = _defaultParam.battleArea.safeAreaBottom + _defaultParam.battleArea.totalH / 5 * 3
if roadGroud3Top > _defaultParam.battleArea.maxGroundH then
	_defaultParam.battleArea.singleH = (_defaultParam.battleArea.maxGroundH - _defaultParam.battleArea.safeAreaBottom) / 3
	_defaultParam.battleArea.totalH = _defaultParam.battleArea.singleH * 5
end
_defaultParam.battleArea.roadH, _ENV = _defaultParam.battleArea.singleH * 5, _defaultParam.battleArea.singleH * 5
for i = 1, 3 do
	_defaultParam.battleArea.roadH[i] = _defaultParam.battleArea.safeAreaBottom + _defaultParam.battleArea.totalH / 5 * (i - 1)
end
_defaultParam.battleArea.roadH[4] = _defaultParam.battleArea.safeAreaBottom + _defaultParam.battleArea.totalH / 5 * 4
local allianceHuntBattleView = class("allianceHuntBattleView", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("allianceHuntBattleView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function allianceHuntBattleView:ctor()
	self.isDebug = gAllianceHuntDebug
	self:createUI()
	self.battleLayer = SoraDGetChildByName(self, "Size_Battle_Layer")
	self.bgAllianceHuntSky6 = SoraDGetChildByName(self, "bg_alliance_hunt_sky_6")
	self.bgAllianceHunt5 = SoraDGetChildByName(self, "bg_alliance_hunt_5")
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.imgTextBg = SoraDGetChildByName(self, "img_text_bg")
	self.textOp = SoraDGetChildByName(self, "text_op")
	self.imgSheerBg = SoraDGetChildByName(self, "img_sheer_bg")
	self.txtTopTip = SoraDGetChildByName(self, "txt_top_tip")
	self.textTime = SoraDGetChildByName(self, "text_time")
	self.frameSJDTJuli9 = SoraDGetChildByName(self, "frame_SJDT_juli_9")
	self.txtArrowNum = SoraDGetChildByName(self, "txt_arrow_num")
	self.imgArrow = SoraDGetChildByName(self, "img_arrow")
	self.nodeProgressBar = SoraDGetChildByName(self, "node_progress_bar")
	self.imgProgressBg = SoraDGetChildByName(self, "img_progress_bg")
	self.imgProgressBgBlack = SoraDGetChildByName(self, "img_progress_bg_black")
	self.progressbarEnergy = SoraDGetChildByName(self, "progressbar_energy")
	self.spProgress1 = SoraDGetChildByName(self, "sp_progress_1")
	self.spProgress2 = SoraDGetChildByName(self, "sp_progress_2")
	self.spProgress3 = SoraDGetChildByName(self, "sp_progress_3")
	self.spProgress4 = SoraDGetChildByName(self, "sp_progress_4")
	self.btnClose = SoraDGetChildByName(self, "Button_close")
	self.imgClose = SoraDGetChildByName(self, "Image_close")
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.bmFontCountDown = SoraDGetChildByName(self, "bm_font_count_down")
	self.bottomNode = SoraDGetChildByName(self, "BottomNode")
	self.nodeBolt = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeBolt_node")
	self.et_ah_progressbar = SoraDGetChildByName(self, "et_ah_progressbar")
	self.et_ah_power_tip = SoraDGetChildByName(self, "et_ah_power_tip")
	self.img_battle_end = SoraDGetChildByName(self, "img_battle_end")
	self.HUNTING_MAX_KILL_POINT = constantRead.getConstValue("HUNTING_MAX_KILL_POINT", 5000)
	self.topNodeInfo = SoraDGetChildByName(self, "Top_Node_Info")
	self.heroHuntingItem = SoraDGetExtendChildFromCCSByName(self, "CCS_heroHuntingItem_Node")
	self.txtArrowNum = SoraDGetChildByName(self, "Text_Info_Arrow_Num")
	self.txtInfoSkillNum = SoraDGetChildByName(self, "Text_Info_Skill_Num")
	self.txtInfoHeroSkillNum = SoraDGetChildByName(self, "Text_Info_HeroSkill_Num")
	self.txtArrowNum:setTextColor(cc.c3b(182, 182, 182))
	self.txtArrowNum:setColor(cc.c3b(255, 255, 255))
	self.txtInfoSkillNum:setTextColor(cc.c3b(182, 182, 182))
	self.txtInfoSkillNum:setColor(cc.c3b(255, 255, 255))
	self.txtInfoHeroSkillNum:setTextColor(cc.c3b(182, 182, 182))
	self.txtInfoHeroSkillNum:setColor(cc.c3b(255, 255, 255))
	SoraDChangeTextToHtml(self.txtArrowNum)
	SoraDChangeTextToHtml(self.txtInfoSkillNum)
	SoraDChangeTextToHtml(self.txtInfoHeroSkillNum)
	self.nodeInfoHeroSkill = SoraDGetChildByName(self, "node_info_heroSkill")
	self.nodeInfoSkill = SoraDGetChildByName(self, "node_info_skill")
	self.nodeInfoArrow = SoraDGetChildByName(self, "node_info_arrow")
	self.imgFight = SoraDGetChildByName(self, "img_fight")
	self.img_battle_end:setVisible(false)
	constantRead = self.img_battle_end.setVisible
	self.img_battle_end.setVisible[1] = SoraDGetChildByName(self.et_ah_power_tip, "dh_chongwuguanbj_01_5")
	self.img_battle_end.setVisible[2] = SoraDGetChildByName(self.et_ah_power_tip, "Particle_Node")
	self.img_battle_end.setVisible[3] = SoraDGetChildByName(self.et_ah_power_tip, "Particle_Node")
	self.img_battle_end.setVisible[4] = SoraDGetChildByName(self.et_ah_power_tip, "Particle_Node")
	local self.img_battle_end.setVisible[5], childs = SoraDGetChildByName(self.et_ah_power_tip, "Particle_Node")
	SoraDSetNodeArrayAdditive(childs)
	self.nodeBolt:setBattleView(self)
	self:bindBtnClose()
	self.bgAllianceHuntSky6:setSpriteFrame("bg_alliance_hunt_sky.png")
	self.bgAllianceHunt5:setSpriteFrame("bg_alliance_hunt.png")
	self.bmFontCountDown:setVisible(false)
	self.txtTopTip:setString(i18n("arena_btn_04"))
	self.et_ah_progressbar:setVisible(false)
	self.et_ah_power_tip:setVisible(false)
	self.bmFontPower = SoraDGetChildByName(self.et_ah_power_tip, "bm_font_strafe_count_down")
	self:resetData()
	SoraDChangeTextToHtml(self.textOp)
	self.battleLayer:setTouchEnabled(true)
	self.battleLayer:addTouchEventListener(handler(self, self.onBattleLayer))
	self.tbAnimals, _ENV, self.hasResHunt = self.battleLayer.addTouchEventListener, self.battleLayer.addTouchEventListener, false
	self.baseClose = self.close
	self.close = self.closeCallBack
	self:initZorder()
	self:initSchedulerAndManager()
	self:checkHideSmallBg()
	self.tbEnergyNode, _ENV = self.checkHideSmallBg, self.checkHideSmallBg
end
function allianceHuntBattleView:initSchedulerAndManager()
	self.mySchedulerHandle = SoradCreateTimer(self, handler(self, self.updateSchedulerCall), true)
	self.myScheduler = cc.Scheduler:new()
	_UPVALUE5_, self.myActionManager = cc.ActionManager:new(), cc.ActionManager:new()
	cc.ActionManager:new()[1] = self
	cc.ActionManager:new()[2] = self.et_ah_progressbar
	cc.ActionManager:new()[3] = self.et_ah_power_tip
	cc.ActionManager:new()[4] = self.bmFontPower
	local cc.ActionManager:new()[5], nodes = self.bmFontCountDown, cc.ActionManager:new()
	SoraDSetNodesSchedulerAndManager(nodes, self.myScheduler, self.myActionManager)
	self.nodeBolt:initSchedulerAndManager(self.myScheduler, self.myActionManager)
end
function allianceHuntBattleView:updateSchedulerCall(dt)
	if not self.myScheduler then
		return
	end
	if not self.isPause then
		self.myScheduler:update(dt)
		self.myActionManager:update(dt)
	end
end
function allianceHuntBattleView:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function allianceHuntBattleView:init(data)
	self.data = data
	dump(self.data, "allianceHuntBattleView===self.data=======", 10)
	local uid = self.data.rankData.uid or 0
	local times = self.data.times or 1
	if uid == 0 then
		self.isTargetRobot = true
	else
		self.isTargetRobot = false
		self.uinfoTarget = self.data.rankData.uinfo
		dump(self.uinfoTarget, "self.uinfoTarget", 10)
	end
	local selectHeroID = self.data.selectHeroID
	self.selectHeroID = selectHeroID
	self.challengePoint = self.data.rankData.score or 0
	if self.selectHeroID and self.selectHeroID ~= 0 then
		self.heroScoreRate = heroCtrl:getHeroHuntingRate(self.selectHeroID)
	else
		self.heroScoreRate = 1.0
	end
	self.maxScoreLimit = self:getScoreLimit()
	allianceHuntCtrl:reqChallenge(uid, selectHeroID or 0, times)
	self:countDown()
	self.isCountedZero = false
	self.isChallengeSuccess = false
	self:updateScore()
	self:initDebugView()
	self.imgFight:setVisible(false)
	self:updateHeroInfo(selectHeroID)
end
function allianceHuntBattleView:getScoreLimit()
	print("self.heroScoreRate = ", self.heroScoreRate, ", awardPoint = ", self.awardPoint)
	return self.HUNTING_MAX_KILL_POINT * self.heroScoreRate + self.awardPoint
end
function allianceHuntBattleView:initDebugView()
	if not self.isDebug then
		return
	end
	if not self._debugNode then
		local drawNode = cc.DrawNode:create()
		drawNode:setName("debugNode")
		drawNode:addTo(self, 2)
		drawNode:setPosition(cc.p(0, 0))
		self._debugNode = drawNode
	end
	self._debugNode:clear()
	dump(_defaultParam.battleArea.roadH, "_defaultParam.battleArea.roadH[i]")
	for i = 1, 4 do
		local yBottom = _defaultParam.battleArea.roadH[i]
		local yTop = yBottom + _defaultParam.battleArea.singleH
		local beginX = _defaultParam.battleArea.spawnX
		local endX = _defaultParam.battleArea.endX
		local lb = cc.p(beginX, yBottom)
		local lt = cc.p(beginX, yTop)
		local rt = cc.p(endX, yTop)
		local rb = cc.p(endX, yBottom)
		_UPVALUE4_ = cc.p(0, 0)
		cc.p(0, 0)[1] = lb
		cc.p(0, 0)[2] = lt
		cc.p(0, 0)[3] = rt
		cc.p(0, 0)[4] = rb
		self._debugNode:drawPoly(cc.p(0, 0))
	end
end
function allianceHuntBattleView:bindBtnClose()
	self.closeButton = SoraDGetChildByName(self, "Button_close")
	print("self.closeButton = ", self.closeButton)
	if self.closeButton then
		self.closeButton:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				self:closeCallBack(ref, type)
			end
		end)
	end
end
function allianceHuntBattleView:closeCallBack(ref, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound("uicontrol", 1)
		if not self.isBattleEnd then
			self:pause()
			SoraDShowMsgBox(i18n("alliance_hunt_text_10"), i18n("common_text_204"), i18n("common_text_185"), function(boxEvent)
				if tolua.isnull(self) then
					return
				end
				self:resume()
				if boxEvent == MSGBOX_CALLBACK_YES then
					self:endBattle()
				end
			end)
		else
			self.baseClose(self, ref, type)
		end
	end
end
function allianceHuntBattleView:onEnterPanel()
	SoraDSwitchMsgTipOff()
	AudioEngine.stopMusic()
	self.soundId = SoraDPlaySound("huntSound", "hunt_forestAmb")
	AudioEngine.playMusic(getAudioFileNameByPlatform("hunt_bg", "BGM"), true)
end
function allianceHuntBattleView:onExitPanel()
	if self.soundId then
		AudioEngine.stopEffect(self.soundId)
	end
	SoraDSwitchMsgTipOn()
	self:cleanTimers()
	if self.myScheduler then
		scheduler.unscheduleGlobal(self.mySchedulerHandle)
		self.myScheduler = nil
	end
	SoraDResetBackGroundMusic()
	if self.isBatleBegan == true and self.isMarkBattleEnd == false then
		print("检测到异常退出，发起退出请求---------------")
	end
end
function allianceHuntBattleView:countDown()
	self.bmFontCountDown:setVisible(true)
	self.countNum = _defaultParam.count_num
	if self.ctTimeHandler then
		SoraDManagerRemoveTimerCustom(self.myScheduler, self, self.ctTimeHandler)
		self.ctTimeHandler = nil
	end
	self:updateCountTime()
	self.ctTimeHandler = SoraDCreateTimerCustom(self.myScheduler, self, handler(self, self.updateCountTime))
end
function allianceHuntBattleView:updateCountTime()
	if self.countNum <= 0 then
		self.isCountedZero = true
		self:checkBeginBattle()
		self.imgFight:setVisible(true)
		self:playFightAction(self.imgFight)
		return
	end
	self.bmFontCountDown:setString(self.countNum)
	self.bmFontCountDown:setOpacity(255)
	self:playCountDownAction()
	if self.countNum > 0 then
		SoraDPlaySound("huntSound", "hunt_star_time")
	end
	self.countNum = math.max(0, self.countNum - 1)
end
function allianceHuntBattleView:endCountDown()
	if self.ctTimeHandler then
		SoraDManagerRemoveTimerCustom(self.myScheduler, self, self.ctTimeHandler)
		self.ctTimeHandler = nil
	end
	self.bmFontCountDown:stopAllActions()
	self.bmFontCountDown:setOpacity(255)
	self.bmFontCountDown:setVisible(false)
	self.imgFight:setVisible(true)
end
function allianceHuntBattleView:checkBeginBattle()
	if self.isCountedZero == true and self.isChallengeSuccess == true then
		self:endCountDown()
		self:beginBattle()
	end
end
function allianceHuntBattleView:resetData()
	self.battleTime = HUNTING_ROUND_TIME
	self.oriSumScore = 0
	self.curScore = 0
	self.awardPoint = 0
	self.isBattleEnd = false
	self.isMarkBattleEnd = false
	self.arrowNum = HUNTING_MAX_ARROW
	self.energyPoint = 0
	self.preyAnimals, _ENV, self.deEnergyPoint = HUNTING_MAX_ARROW, HUNTING_MAX_ARROW, 0
	self.powerMode = HUNTING_POWER_MODE.NORMAL
	self.isTouchBegin = false
	self.hasPlayedEndAnim = false
	self.isBattleEnd = false
	self.isPlayingEndAnim = false
	self:updateArrowNum()
	self.isBatleBegan = false
end
function allianceHuntBattleView:beginBattle()
	if self.isBattleEnd == true then
		return
	end
	print("倒计时结束，开始战斗--------------------------")
	self:resetData()
	self.challengePoint = self.huntData.curRoundData.targetInfo.challengePoint or 0
	self.awardPoint = allianceHuntCtrl:getAwardPoint()
	self.maxScoreLimit = self:getScoreLimit()
	SoraDPlaySound("huntSound", "hunt_star_war")
	print("self.maxScoreLimit = ", self.maxScoreLimit)
	self.isBatleBegan = true
	self:beginTime()
	self:beginSpawn()
end
function allianceHuntBattleView:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimerCustom(self.myScheduler, self, self.timeHandler)
		self.timeHandler = nil
	end
	self:updateTime()
	print("开始创建自定义定时器--------------")
	self.timeHandler = SoraDCreateTimerCustom(self.myScheduler, self, handler(self, self.updateTime))
end
function allianceHuntBattleView:updateTime()
	print("allianceHuntBattleView:updateTime()---------------------xxxxx")
	if self.battleTime <= 0 then
		self.bmFontCountDown:setVisible(false)
		self:endTime()
		self:endBattle()
	end
	local timeStr = SoraDConvertSecondToStringNoDayNoHour(self.battleTime)
	self.textTime:setString(timeStr)
	if self.battleTime <= 10 then
		self.textTime:setTextColor(cc.c3b(255, 0, 0))
		if self.battleTime <= 5 and self.battleTime > 0 then
			self.bmFontCountDown:setOpacity(160)
			self.bmFontCountDown:setString(self.battleTime)
			self.bmFontCountDown:setVisible(true)
			self:playCountDownAction()
			SoraDPlaySound("huntSound", "hunt_star_time")
		end
	else
		self.textTime:setTextColor(cc.c3b(255, 255, 255))
	end
	self.battleTime = math.max(0, self.battleTime - 1)
end
function allianceHuntBattleView:playCountDownAction(target)
	target = target or self.bmFontCountDown
	if target then
		target:stopAllActions()
		target:setScale(3.2)
		_UPVALUE1_ = nil
		;(nil)[1] = cca.scaleTo(0.4, 2.0)
		;(nil)[2] = cca.fadeOut(0.3)
		;(nil)[3] = cca.fadeOut(0.3)
		target:runAction(cca.seq(nil))
	end
end
function allianceHuntBattleView:playFightAction(target)
	target = target or self.imgFight
	if target then
		target:stopAllActions()
		target:setScale(0.6)
		_UPVALUE1_ = nil
		;(nil)[1] = cca.scaleTo(0.4, 0.4)
		;(nil)[2] = cca.fadeOut(0.3)
		;(nil)[3] = cca.fadeOut(0.3)
		target:runAction(cca.seq(nil))
	end
end
function allianceHuntBattleView:endBattle()
	if self.isMarkBattleEnd == true then
		return
	end
	print("狩猎结束-----")
	self:endTime()
	self:endSpawn()
	SoraDShowLoading(self, nil, nil, true)
	self.isMarkBattleEnd = true
	allianceHuntCtrl:reqExit()
	self:playEndAnim()
end
function allianceHuntBattleView:endTime()
	if self.timeHandler then
		SoraDManagerRemoveTimerCustom(self.myScheduler, self, self.timeHandler)
		self.timeHandler = nil
	end
end
function allianceHuntBattleView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_CHALLENGE_SUCCESS", handler(self, self.sMsgChallengeSuccess))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_CHALLENGE_FAILED", handler(self, self.sMsgChallengeFailed))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_BATTLE_END", handler(self, self.sMsgBattleEnd))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_CLOSE_BATTLE", handler(self, self.msgCloseSelf))
	SoraDAddMessage(self, "MESSAGE_FILE_DOWNLOAD_SUCCESS_BY_KEY", handler(self, self.onKeyFileDownloadSuccess))
end
function allianceHuntBattleView:sMsgCheckHideSmallBg(target, data)
	if data.file == "bg_alliance_hunt.png" then
		print("战斗背景图下好了--------")
		self:checkHideSmallBg()
	elseif data.file == "bg_alliance_hunt_sky.png" then
		print("天空背景图下好了--------")
		self:checkHideSmallBg()
	end
end
function allianceHuntBattleView:checkHideSmallBg()
	do return end
	local _, isSkyExist = SoraDIsFileExistByFileName("bg_alliance_hunt_sky.png")
	local _, isBattBgExist = SoraDIsFileExistByFileName("bg_alliance_hunt.png")
	print("isSkyExist,isBattBgExist ", isSkyExist, isBattBgExist)
	if isSkyExist and isBattBgExist then
		self.bgHuntSmall:setVisible(false)
	else
		self.bgHuntSmall:setVisible(true)
	end
end
function allianceHuntBattleView:sMsgChallengeSuccess(target, data)
	self.huntData = allianceHuntCtrl:getHuntData()
	self.isChallengeSuccess = true
	self:checkBeginBattle()
end
function allianceHuntBattleView:sMsgChallengeFailed(target, data)
	self.isChallengeSuccess = false
	SoraDShowMsgTip("Challenge Failed!")
end
function allianceHuntBattleView:beginSpawn()
	self.spawnIndex = 1
	self.spawnTick = 0
	if self.timeSpawn then
		SoraDManagerRemoveTimerCustom(self.myScheduler, self, self.timeSpawn)
		self.timeSpawn = nil
	end
	self:spawnUpdate(0)
	self.timeSpawn = SoraDCreateTimerCustom(self.myScheduler, self, handler(self, self.spawnUpdate), true)
end
function allianceHuntBattleView:spawnUpdate(dt)
	local dtScale = _defaultParam.spawnScaleNoraml
	if self.powerMode == HUNTING_POWER_MODE.FULL then
		dtScale = _defaultParam.spawnScaleFast
	end
	self.spawnTick = self.spawnTick + dt * dtScale
	local generateSet = self.huntData.generateSet
	if self.spawnIndex > #generateSet then
		self:endSpawn()
		return
	end
	while self.spawnIndex <= #generateSet and self.spawnTick >= generateSet[self.spawnIndex].beginTime / 100 do
		self:spawnWithIndex(self.spawnIndex)
		self.spawnIndex = self.spawnIndex + 1
	end
	if self.spawnIndex > #generateSet then
		self:endSpawn()
	end
end
function allianceHuntBattleView:endSpawn()
	if self.timeSpawn then
		SoraDManagerRemoveTimerCustom(self.myScheduler, self, self.timeSpawn)
		self.timeSpawn = nil
	end
end
function allianceHuntBattleView:spawnWithIndex(spawnIndex)
	local spdata = self.huntData.generateSet[spawnIndex]
	local preyAnimal = self:spawnPrey(spdata, _defaultParam.battleArea)
end
function allianceHuntBattleView:spawnPrey(spdata, battleArea)
	local preyAnimal
	if #self.tbAnimals > 0 then
		preyAnimal = table.remove(self.tbAnimals)
		preyAnimal:setVisible(true)
		print("这是从回收池取出来的animal")
	else
		preyAnimal = include("allianceHuntPrey").new()
		preyAnimal:addTo(self.battleLayer)
		preyAnimal:initSchedulerAndManager(self.myScheduler, self.myActionManager)
		preyAnimal:setHeroScoreRate(self.heroScoreRate)
		preyAnimal:setBattleView(self)
	end
	preyAnimal:init(spdata, battleArea)
	self.preyAnimals[preyAnimal] = preyAnimal
	return preyAnimal
end
function allianceHuntBattleView:onBattleLayer(target, event)
	if event == ccui.TouchEventType.began or event == ccui.TouchEventType.ended then
		print("onBattleLayer", event, self.isBatleBegan, self:isBoltInCD())
	end
	if not self.isBatleBegan then
		return
	end
	if self:isBoltInCD() then
		return
	end
	if event == ccui.TouchEventType.began then
		local touchBeganPoint = target:getTouchBeganPosition()
		self.touchPoint = touchBeganPoint
		self:showBullsEye(self.touchPoint, true)
		self.isTouchBegin = true
		self:zoomBattleLayer(true)
	elseif event == ccui.TouchEventType.ended then
		if not self.isTouchBegin then
			return
		end
		local touchEndPoint = target:getTouchEndPosition()
		self.touchPoint = touchEndPoint
		self:playTouchEffect(self.touchPoint)
		self:hideBullsEye()
		self:playBoltAnim(self.touchPoint)
		self:zoomBattleLayer(false)
	elseif event == ccui.TouchEventType.moved then
		if not self.isTouchBegin then
			return
		end
		local touchPoint = target:getTouchMovePosition()
		self.touchPoint = touchPoint
		self:showBullsEye(self.touchPoint)
	elseif event == ccui.TouchEventType.canceled then
		if not self.isTouchBegin then
			return
		end
		self:playTouchEffect(self.touchPoint)
		self:hideBullsEye()
		self:playBoltAnim(self.touchPoint)
		self:zoomBattleLayer(false)
	end
end
function allianceHuntBattleView:zoomBattleLayer(isBig)
	self.bgAllianceHunt5:stopAllActions()
	if isBig then
		self.bgAllianceHunt5:runAction(cca.scaleTo(0.2, 1.0015))
	else
		self.bgAllianceHunt5:runAction(cca.scaleTo(0.2, 1.0))
	end
end
function allianceHuntBattleView:isBoltInCD()
	return self.nodeBolt:getIsInCD()
end
function allianceHuntBattleView:showBullsEye(touchPoint, bResetAction)
	if self:isBoltInCD() then
		return
	end
	if not self.spBullsEye then
		bResetAction = true
		self.spBullsEye = display.newSprite("#dh_gongjianmz_01.png")
		self.spBullsEye:addTo(self, allianceHuntDesRead.zOrder.z_bullsEye)
	end
	local nodePos = self:convertToNodeSpace(touchPoint)
	self.spBullsEye:setPosition(nodePos)
	self.spBullsEye:setVisible(true)
	self.nodeBolt:updateBoltPos(touchPoint, bResetAction)
	if bResetAction then
		self.spBullsEye:stopAllActions()
		self.spBullsEye:setScale(1.0)
		_UPVALUE3_ = self.spBullsEye
		self.spBullsEye[1] = cca.scaleTo(0.3, 1.2)
		self.spBullsEye[2] = cca.scaleTo(0.3, 1.0)
		self.spBullsEye[3] = cca.scaleTo(0.3, 0.9)
		self.spBullsEye[4] = cca.scaleTo(0.3, 1.0)
		self.spBullsEye[5] = cca.scaleTo(0.3, 1.0)
		self.spBullsEye[6] = cca.scaleTo(0.3, 1.0)
		local action = cca.seq(self.spBullsEye)
		local repeatAction = cca.repeatForever(action)
		self.spBullsEye:runAction(repeatAction)
	end
end
function allianceHuntBattleView:hideBullsEye()
	if self.spBullsEye then
		self.spBullsEye:setVisible(false)
	end
end
function allianceHuntBattleView:playBoltAnim(touchPos)
	local speedMode = self:getTimeSpeedMode()
	if not self.nodeBolt:getIsInCD() and self.powerMode == HUNTING_POWER_MODE.NORMAL then
		self.arrowNum = self.arrowNum - 1
		if self.arrowNum < 0 then
			return
		end
		self:updateArrowNum()
	end
	self.nodeBolt:playShotAnim(touchPos, speedMode)
end
function allianceHuntBattleView:getTimeSpeed()
	local speedMode = self:getTimeSpeedMode()
	if speedMode == gAllianceHuntSpeedMode.NORMAL then
		return _defaultParam.timeSpeedNormal
	elseif speedMode == gAllianceHuntSpeedMode.FAST then
		return _defaultParam.timeSpeedFast
	end
	return _defaultParam.timeSpeedNormal
end
function allianceHuntBattleView:getTimeSpeedMode()
	if self.powerMode == HUNTING_POWER_MODE.NORMAL then
		return gAllianceHuntSpeedMode.NORMAL
	elseif self.powerMode == HUNTING_POWER_MODE.FULL then
		return gAllianceHuntSpeedMode.FAST
	end
	return gAllianceHuntSpeedMode.NORMAL
end
function allianceHuntBattleView:hitTest(touchPoint, hitPowerMode)
	if self.isMarkBattleEnd then
		return
	end
	local sumScore = 0
	local sumArrow = 0
	local hasHitPrey = false
	local sumEnergyPoint = 0
	local _ENV, hitInfo
	local _ENV, headShotInfo
	local strafeStatus = 0
	if hitPowerMode == HUNTING_POWER_MODE.FULL then
		strafeStatus = 1
	end
	for _, v in pairs(self.preyAnimals) do
		if v:isAlive() then
			local attackType = v:hitTest(touchPoint)
			if attackType ~= ATTACK_TYPE.ATTACK_NONE then
				local hitType = HUNTING_HIT_TYPE.NORMAL_ATTACK
				_ENV = nil
				;(nil).attackType = attackType
				local score = v:hit(nil)
				sumScore = sumScore + score
				if 0 < score then
					sumArrow = sumArrow + v:getArrowNum()
				end
				hasHitPrey = true
				if attackType == ATTACK_TYPE.ATTACK_HEAD then
					if hitPowerMode == HUNTING_POWER_MODE.NORMAL then
						sumEnergyPoint = sumEnergyPoint + 1
					end
					hitType = HUNTING_HIT_TYPE.SUPER_ATTACK
					_ENV = nil
					;(nil).preyID = v.data.preyInfo.preyID
					;(nil).prey = v
					;(nil).hitPowerMode = hitPowerMode
					table.insert(headShotInfo, nil)
				end
				_ENV = nil
				;(nil).hitType = hitType
				;(nil).index = v.data.generateIndex
				;(nil).strafeStatus = strafeStatus
				table.insert(hitInfo, nil)
			end
		end
	end
	if 0 < sumEnergyPoint then
		self.deEnergyPoint = 0
	elseif sumEnergyPoint == 0 and hasHitPrey then
		self.deEnergyPoint = self.deEnergyPoint + 1
	end
	self.energyPoint = math.min(HUNTING_MAX_ENERGY, self.energyPoint + sumEnergyPoint)
	self:playHeadShotEnerty(headShotInfo)
	if self.powerMode ~= HUNTING_POWER_MODE.FULL and self.energyPoint >= HUNTING_MAX_ENERGY then
		self.powerMode = HUNTING_POWER_MODE.FULL
		self:enterPowerFullMode()
	end
	if not hasHitPrey then
		local hitType = HUNTING_HIT_TYPE.NORMAL_ATTACK
		_ENV, allianceHuntCtrl = headShotInfo, self
		headShotInfo.hitType = hitType
		headShotInfo.index = 0
		headShotInfo.strafeStatus = strafeStatus
		hitInfo, self[1] = self, headShotInfo
		if hitPowerMode == HUNTING_POWER_MODE.NORMAL then
			self.deEnergyPoint = self.deEnergyPoint + 1
		end
	end
	allianceHuntCtrl:reqHit(hitInfo)
	local scoreScale = self.heroScoreRate
	self.oriSumScore = self.oriSumScore + sumScore
	self.curScore = self.oriSumScore * scoreScale
	if self.curScore > self.challengePoint then
		self.curScore = self.curScore + self.awardPoint
	end
	self.curScore = math.min(self.maxScoreLimit, self.curScore)
	self.arrowNum = self.arrowNum + sumArrow
	if 0 < sumArrow then
		print("todohlp:弄个+5的动画")
	end
	if hitPowerMode == HUNTING_POWER_MODE.NORMAL then
		if self.deEnergyPoint == HUNTING_DE_ENERGY_POINT then
			self.energyPoint = math.max(0, self.energyPoint - 1)
			self.deEnergyPoint = 0
		end
		self:updateEnergy()
	end
	self:updateScore()
	self:updateArrowNum()
end
function allianceHuntBattleView:playHeadShotEnerty(headShotInfo)
	if not headShotInfo or #headShotInfo == 0 then
		return
	end
	for _, v in ipairs(headShotInfo) do
		if v.hitPowerMode == HUNTING_POWER_MODE.NORMAL then
			self:checkAndPlayEnergyAnim(v.prey)
		end
	end
end
function allianceHuntBattleView:updateScore()
	local numColor = self.curScore > 0 and "#F6D35F" or "#FF0000"
	_ENV = math.floor(self.curScore)
	math.floor(self.curScore).color = numColor
	local Point = SoraDWrapHtmlTagByStyle(tostring((math.floor(self.curScore))), (math.floor(self.curScore)))
	local globalColor = "#F6D35F"
	_ENV = self.challengePoint
	self.challengePoint.color = globalColor
	local GoalPoint = SoraDWrapHtmlTagByStyle(tostring(self.challengePoint), self.challengePoint)
	_ENV = nil
	;(nil).Point = Point
	;(nil).GoalPoint = GoalPoint
	self.textOp:setString(i18n("alliance_hunt_text_11", nil))
	numColor = cc.c3b(255, 255, 255)
	_ENV = 255
	_ENV, _ENV, (255).num = i18n("alliance_hunt_text_11", nil)
	self.oriSumScore.num, i18n("alliance_hunt_text_11", nil).color = i18n("alliance_hunt_text_11", nil)
	local strSkillNum = i18n_html("alliance_hunt_text_34", 255, self.oriSumScore)
	print("strSkillNum = ", strSkillNum)
	self.txtInfoSkillNum:setString(strSkillNum)
	local scoreScale = self.heroScoreRate
	local numRate = math.floor(self.oriSumScore * (scoreScale - 1.0))
	_ENV = i18n("alliance_hunt_text_11", nil)
	_ENV, _ENV, i18n("alliance_hunt_text_11", nil).num = i18n("alliance_hunt_text_11", nil)
	i18n("alliance_hunt_text_11", nil).num, i18n("alliance_hunt_text_11", nil).color = i18n("alliance_hunt_text_11", nil)
	local str = i18n_html("alliance_hunt_text_33", i18n("alliance_hunt_text_11", nil))
	self.txtInfoHeroSkillNum:setString(str)
end
function allianceHuntBattleView:updateArrowNum()
	local numColor = cc.c3b(255, 255, 255)
	_ENV = nil
	_ENV, _ENV, (nil).num = nil, self.arrowNum, self.arrowNum
	self.arrowNum.num, (nil).color = nil, numColor
	self.txtArrowNum:setString(i18n_html("alliance_hunt_text_12", nil, self.arrowNum))
end
function allianceHuntBattleView:onShotCallBack(powerMode)
	self:hitTest(self.touchPoint, powerMode)
	self.isTouchBegin = false
	if self.arrowNum == 0 then
		print("弓箭数量消耗完了，提前结束")
		self:endBattle()
	end
end
function allianceHuntBattleView:sMsgBattleEnd(target, data)
	dump(data, "战斗结束", 10)
	self.isBattleEnd = true
	self.retData = data.data.retData
	self:checkAndShowResult()
end
function allianceHuntBattleView:msgCloseSelf(target, data)
	self:closePanel()
end
function allianceHuntBattleView:updateEnergy()
	local percent = math.min(100, math.max(0, self.energyPoint / HUNTING_MAX_ENERGY * 100))
	self.progressbarEnergy:setPercent(percent)
end
function allianceHuntBattleView:enterPowerFullMode()
	print("进入扫射模式----------------")
	self.nodeBolt:setPowerMode(HUNTING_POWER_MODE.FULL)
	if not self.redWarnning then
		local redWarnning
		_ENV = HUNTING_POWER_MODE.FULL
		HUNTING_POWER_MODE.FULL.cssFileName = "et_ah_full_power01"
		HUNTING_POWER_MODE.FULL.loop = true
		HUNTING_POWER_MODE.FULL.scheduler = self.myScheduler
		HUNTING_POWER_MODE.FULL.actionManager = self.myActionManager
		redWarnning = SoraDCreatAnimationParam(HUNTING_POWER_MODE.FULL)
		local childs = redWarnning:getChildren()
		SoraDSetNodeArrayAdditive(childs)
		redWarnning:setPosition(cc.p(display.cx, 0))
		redWarnning:setVisible(false)
		redWarnning:addTo(self, 20)
		self.redWarnning = redWarnning
	end
	self.redWarnning:setVisible(true)
	local reskey = "lucency"
	if not self.redWarnning2 and SoraDIsFileExistByKey(reskey) then
		_ENV = reskey
		reskey.cssFileName = "et_ah_full_power02"
		reskey.loop = true
		reskey.scheduler = self.myScheduler
		reskey.actionManager = self.myActionManager
		local redWarnning2 = SoraDCreatAnimationParam(reskey)
		local childs = redWarnning2:getChildren()
		SoraDSetNodeArrayAdditive(childs)
		redWarnning2:setPosition(cc.p(display.cx, 0))
		redWarnning2:setVisible(false)
		redWarnning2:addTo(self, 20)
		self.redWarnning2 = redWarnning2
	end
	if self.redWarnning2 then
		self.redWarnning2:setVisible(true)
	end
	self.et_ah_progressbar:setVisible(true)
	self.et_ah_power_tip:setVisible(true)
	SoraDCreatAnimationEx("et_ah_progressbar", self.et_ah_progressbar, true)
	SoraDCreatAnimationEx("et_ah_power_tip", self.et_ah_power_tip, false, 1, 0, 105)
	local delay1 = cca.delay(0.16666666666666666)
	local callFunc1 = cca.callFunc(function()
		local etParticle = SoraDGetChildByName(self.et_ah_power_tip, "Particle_Node")
		etParticle:resetSystem()
	end)
	_UPVALUE2_ = false
	;(false)[1] = delay1
	;(false)[2] = callFunc1
	local seq = cca.seq(false)
	self.et_ah_power_tip:runAction(seq)
	self:beginEnergyAnim()
	for _, v in pairs(self.preyAnimals) do
		v:setSpeedMode(gAllianceHuntSpeedMode.FAST)
	end
end
function allianceHuntBattleView:quitPowerFullMode()
	self:endEnergyAnim()
	self.nodeBolt:setPowerMode(HUNTING_POWER_MODE.NORMAL)
	self.powerMode = HUNTING_POWER_MODE.NORMAL
	print("退出扫射模式-----------------")
	self.redWarnning:setVisible(false)
	self.et_ah_progressbar:setVisible(false)
	if self.redWarnning2 then
		self.redWarnning2:setVisible(false)
	end
	self.energyPoint = 0
	self.deEnergyPoint = 0
	self:updateEnergy()
	for _, v in pairs(self.preyAnimals) do
		v:setSpeedMode(gAllianceHuntSpeedMode.NORMAL)
	end
	SoraDCreatAnimationEx("et_ah_power_tip", self.et_ah_power_tip, false, 1, 105, 117)
	_UPVALUE1_ = false
	;(false)[1] = cca.delay(0.3)
	;(false)[2] = cca.callFunc(function()
		self.et_ah_power_tip:setVisible(false)
	end)
	;(false)[3] = cca.callFunc(function()
		self.et_ah_power_tip:setVisible(false)
	end)
	;(false)[4] = cca.callFunc(function()
		self.et_ah_power_tip:setVisible(false)
	end)
	self.et_ah_power_tip:runAction(cca.seq(false))
	self.bmPowerNum = nil
end
function allianceHuntBattleView:playTouchEffect(touchPos)
	if self:isBoltInCD() then
		return
	end
	local timeSpeed = self:getTimeSpeed()
	local viewPos = self:convertToNodeSpace(touchPos)
	local effectNode = SoraDCreatAnimationEx("node_bulls_eye", nil, false, timeSpeed)
	effectNode:addTo(self, allianceHuntDesRead.zOrder.z_bullsEye)
	effectNode:setPosition(viewPos)
	allianceHuntDesRead = allianceHuntDesRead.zOrder.z_bullsEye
	allianceHuntDesRead.zOrder.z_bullsEye[1] = cca.delay(0.7 / timeSpeed + 0.02)
	allianceHuntDesRead.zOrder.z_bullsEye[2] = cca.callFunc(function()
		effectNode:removeFromParent()
	end)
	allianceHuntDesRead.zOrder.z_bullsEye[3] = cca.callFunc(function()
		effectNode:removeFromParent()
	end)
	effectNode:runAction(cca.seq(allianceHuntDesRead.zOrder.z_bullsEye))
end
function allianceHuntBattleView:getScheduler()
	return self.myScheduler
end
function allianceHuntBattleView:pause()
	self.isPause = true
	self:getActionManager():pauseTarget(self)
	self.nodeBolt:pause()
	for _, v in pairs(self.preyAnimals) do
		v:pause()
	end
end
function allianceHuntBattleView:resume()
	self.isPause = false
	self:getActionManager():resumeTarget(self)
	self.nodeBolt:resume()
	for _, v in pairs(self.preyAnimals) do
		v:resume(v)
	end
end
function allianceHuntBattleView:beginEnergyAnim()
	print("allianceHuntBattleView:beginEnergyAnim()-----能量条动画开始")
	self.energyTotal = HUNTING_STRAFE_MODE_TIME
	self.energyTick = 0
	if self.timeEnergy then
		SoraDManagerRemoveTimerCustom(self.myScheduler, self, self.timeEnergy)
		self.timeEnergy = nil
	end
	self.bmPowerNum = nil
	self:updateEnergyCall(0)
	self.timeEnergy = SoraDCreateTimerCustom(self.myScheduler, self, handler(self, self.updateEnergyCall), true)
end
function allianceHuntBattleView:updateEnergyCall(dt)
	self.energyTick = self.energyTick + dt
	local percent = (self.energyTotal - self.energyTick) / self.energyTotal
	percent = math.min(100, math.max(0, percent * 100))
	self.progressbarEnergy:setPercent(percent)
	if not self.bmPowerNum then
		self.bmPowerNum = self.energyTotal
		self.bmFontPower:setString(self.bmPowerNum)
	else
		local curNum = math.ceil(self.energyTotal * percent / 100)
		if curNum ~= self.bmPowerNum then
			self.bmPowerNum = curNum
			self.bmFontPower:setString(self.bmPowerNum)
		end
	end
	if percent == 100 then
	end
	if percent == 0 then
		self:quitPowerFullMode()
	end
end
function allianceHuntBattleView:endEnergyAnim()
	self.progressbarEnergy:setPercent(0)
	if self.timeEnergy then
		SoraDManagerRemoveTimerCustom(self.myScheduler, self, self.timeEnergy)
		self.timeEnergy = nil
	end
end
function allianceHuntBattleView:initZorder()
	_UPVALUE2_, _UPVALUE3_ = nil, nil
	_UPVALUE2_, (nil)[1] = self.bottomNode, self.bottomNode
	_UPVALUE2_, (nil)[2] = self.bottomNode, allianceHuntDesRead.zOrder.z_bottomNode
	_UPVALUE2_, self.bottomNode[1] = self.topNode, self.topNode
	_UPVALUE2_, self.bottomNode[2] = self.topNode, allianceHuntDesRead.zOrder.z_topNode
	self.topNode[1] = self.centerNode
	self.topNode[2] = allianceHuntDesRead.zOrder.z_centerNode
	;(nil)[1] = nil
	;(nil)[2] = self.bottomNode
	local (nil)[3], zOrderMap = self.topNode, nil
	for i, v in ipairs(zOrderMap) do
		if v[1] then
			print("i = ", i, ", zOrder = ", v[2])
			v[1]:setLocalZOrder(v[2])
		end
	end
end
function allianceHuntBattleView:onKeyFileDownloadSuccess(target, data)
	if self.hasResHunt then
		return
	end
	local key = data.key
	if key == "alliancehunt" then
		for _, v in pairs(self.preyAnimals) do
			v:updateAnimation()
		end
		self.hasResHunt = true
	end
end
function allianceHuntBattleView:recyclePrey(preyAnimal)
	if preyAnimal then
		table.insert(self.tbAnimals, preyAnimal)
		self.preyAnimals[preyAnimal] = nil
	end
end
function allianceHuntBattleView:showResult()
	print("-------function allianceHuntBattleView:showResult()")
	SoraDCloseLoading(self)
	local popStyle
	if self.curScore >= self.challengePoint then
		popStyle = 1
	else
		popStyle = 2
	end
	local chatFunctions = include("chatFunctions")
	_ENV = "chatFunctions"
	;("chatFunctions").uid = chatFunctions:getSelfId()
	;("chatFunctions").iconID = chatFunctions:getSelfImageId()
	;("chatFunctions").avatar = chatFunctions:getSelfAvatar()
	local ("chatFunctions").nickName, uinfoSelf = chatFunctions:getSelfNickName(), "chatFunctions"
	self.curScore = self.retData.baseScore
	local preScore = self.curScore
	if preScore > self.challengePoint then
		preScore = preScore - self.awardPoint
	end
	self.oriSumScore = math.ceil(preScore / self.heroScoreRate)
	self:updateScore()
	if GLOBAL_GAME_ALLIANCE_MODE then
		local popView = uiManager:show("allianceHuntPopView").view
		_ENV = nil
		;(nil).popStyle = popStyle
		;(nil).score = self.curScore
		;(nil).multipleTimes = self.retData.multipleTimes
		;(nil).challengePoint = self.challengePoint
		;(nil).uinfoSelf = uinfoSelf
		;(nil).uinfoTarget = self.uinfoTarget
		;(nil).isTargetRobot = self.isTargetRobot
		popView:init(nil)
	else
		local popView = SoraDCreatePanel("allianceHuntPopView")
		_ENV = nil
		;(nil).popStyle = popStyle
		;(nil).score = self.curScore
		;(nil).multipleTimes = self.retData.multipleTimes
		;(nil).challengePoint = self.challengePoint
		;(nil).uinfoSelf = uinfoSelf
		;(nil).uinfoTarget = self.uinfoTarget
		;(nil).isTargetRobot = self.isTargetRobot
		popView:init(nil)
		popView:show()
	end
end
function allianceHuntBattleView:playEndAnim()
	if self.isPlayingEndAnim == true then
		return
	end
	self.isPlayingEndAnim = true
	self.hasPlayedEndAnim = false
	self.img_battle_end:setOpacity(0)
	self.img_battle_end:setVisible(true)
	_UPVALUE3_ = nil
	;(nil)[1] = cca.fadeIn(0.5)
	;(nil)[2] = cca.delay(1)
	;(nil)[3] = cca.fadeOut(0.5)
	;(nil)[4] = cca.callFunc(function()
		self.img_battle_end:setVisible(false)
		self.hasPlayedEndAnim = true
		self:checkAndShowResult()
	end)
	;(nil)[5] = cca.callFunc(function()
		self.img_battle_end:setVisible(false)
		self.hasPlayedEndAnim = true
		self:checkAndShowResult()
	end)
	self.img_battle_end:runAction(cca.seq(nil))
end
function allianceHuntBattleView:checkAndShowResult()
	if self.hasPlayedEndAnim and self.isBattleEnd == true then
		self:showResult()
	elseif not self.hasPlayedEndAnim then
		print("检测到还没有------")
		if not self.isPlayingEndAnim then
			self:playEndAnim()
		end
	end
end
function allianceHuntBattleView:cleanTimers()
	if self.timeHandler then
		SoraDManagerRemoveTimerCustom(self.myScheduler, self, self.timeHandler)
		self.timeHandler = nil
	end
	if self.timeSpawn then
		SoraDManagerRemoveTimerCustom(self.myScheduler, self, self.timeSpawn)
		self.timeSpawn = nil
	end
	if self.timeEnergy then
		SoraDManagerRemoveTimerCustom(self.myScheduler, self, self.timeEnergy)
		self.timeEnergy = nil
	end
	if self.ctTimeHandler then
		SoraDManagerRemoveTimerCustom(self.myScheduler, self, self.ctTimeHandler)
		self.ctTimeHandler = nil
	end
end
function allianceHuntBattleView:updateHeroInfo(heroID)
	if heroID and heroID ~= 0 then
		self.heroHuntingItem:setVisible(true)
		self.nodeInfoHeroSkill:setVisible(true)
		self.heroHuntingItem:initData(heroID)
	else
		self.heroHuntingItem:setVisible(false)
		self.nodeInfoHeroSkill:setVisible(false)
	end
end
function allianceHuntBattleView:checkAndPlayEnergyAnim(preyAnimal)
	if self.powerMode == HUNTING_POWER_MODE.FULL then
		return
	end
	local nodeEnergy = self:getEneryEffectNode()
	nodeEnergy:setPosition(cc.p(preyAnimal:getPositionX() + 60, preyAnimal:getPositionY() + 80))
	nodeEnergy:setVisible(true)
	nodeEnergy:setOpacity(255)
	nodeEnergy:stopAllActions()
	local dt = 0.2
	local delay1 = cca.delay(0.01)
	local posBar = cc.p(self.nodeProgressBar:getPosition())
	local posTarget = cc.p(posBar.x, posBar.y)
	local sepW = 33
	if SoraDFIsRA() then
		posTarget.x = posBar.x + 2 * sepW - sepW * (self.energyPoint - 1)
	else
		posTarget.x = posBar.x - 2 * sepW + sepW * (self.energyPoint - 1)
	end
	local moveTo = cca.moveTo(dt, posTarget)
	local delay2 = cca.delay(dt / 2)
	local callFunc2 = cca.callFunc(function()
		table.insert(self.tbEnergyNode, nodeEnergy)
	end)
	local fadeOut = cca.fadeOut(dt / 2)
	_UPVALUE1_ = self.nodeProgressBar:getPosition()
	_UPVALUE1_ = self.nodeProgressBar:getPosition()
	_UPVALUE3_ = self.nodeProgressBar:getPosition()
	self.nodeProgressBar:getPosition()[1] = delay2
	self.nodeProgressBar:getPosition()[2] = fadeOut
	self.nodeProgressBar:getPosition()[3] = callFunc2
	self.nodeProgressBar:getPosition()[1] = moveTo
	self.nodeProgressBar:getPosition()[2] = cca.seq(self.nodeProgressBar:getPosition())
	self.nodeProgressBar:getPosition()[3] = cca.seq(self.nodeProgressBar:getPosition())
	self.nodeProgressBar:getPosition()[4] = cca.seq(self.nodeProgressBar:getPosition())
	self.nodeProgressBar:getPosition()[5] = cca.seq(self.nodeProgressBar:getPosition())
	self.nodeProgressBar:getPosition()[6] = cca.seq(self.nodeProgressBar:getPosition())
	self.nodeProgressBar:getPosition()[1] = delay1
	self.nodeProgressBar:getPosition()[2] = cca.spawn(self.nodeProgressBar:getPosition())
	self.nodeProgressBar:getPosition()[3] = cca.spawn(self.nodeProgressBar:getPosition())
	self.nodeProgressBar:getPosition()[4] = cca.spawn(self.nodeProgressBar:getPosition())
	self.nodeProgressBar:getPosition()[5] = cca.spawn(self.nodeProgressBar:getPosition())
	self.nodeProgressBar:getPosition()[6] = cca.spawn(self.nodeProgressBar:getPosition())
	self.nodeProgressBar:getPosition()[7] = cca.spawn(self.nodeProgressBar:getPosition())
	self.nodeProgressBar:getPosition()[8] = cca.spawn(self.nodeProgressBar:getPosition())
	self.nodeProgressBar:getPosition()[9] = cca.spawn(self.nodeProgressBar:getPosition())
	local seq = cca.seq(self.nodeProgressBar:getPosition())
	nodeEnergy:runAction(seq)
end
function allianceHuntBattleView:getEneryEffectNode()
	if not self.tbEnergyNode then
		self.tbEnergyNode, _ENV = self.tbEnergyNode, self.tbEnergyNode
	end
	if #self.tbEnergyNode > 0 then
		return table.remove(self.tbEnergyNode)
	else
		local nodeEnergy = display.newNode()
		nodeEnergy:addTo(self, 3)
		local sp1 = display.newSprite("res/Particle/et_gongjian_01.png")
		local sp2 = display.newSprite("res/Particle/et_gongjian_04.png")
		sp1:setScale(1.64)
		sp2:setScale(0.84)
		sp1:addTo(nodeEnergy)
		sp2:addTo(nodeEnergy)
		_UPVALUE2_ = sp2
		sp2[1] = sp1
		sp2[2] = sp2
		SoraDSetNodeArrayAdditive(sp2)
		nodeEnergy:setCascadeOpacityEnabled(true)
		sp1:setCascadeOpacityEnabled(true)
		sp2:setCascadeOpacityEnabled(true)
		return nodeEnergy
	end
end
return allianceHuntBattleView
