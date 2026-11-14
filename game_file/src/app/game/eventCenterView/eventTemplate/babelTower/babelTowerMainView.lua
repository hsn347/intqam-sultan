local babelTowerCtrl = SoraDGetCtrl("babelTowerCtrl")
local babelTowerRead = gModuleMgr.sharedMgr("babelTowerRead")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local babelTowerMainView = class("babelTowerMainView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("babelTowerMainView")
end)
_ENV, _ENV, _UPVALUE14_ = nil, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("babelTowerMainView")
end, "babelTowerMainView"
;(nil).x = 725
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("babelTowerMainView")
end).to, (nil).y = nil, 430
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("babelTowerMainView")
end).flipx = true
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("babelTowerMainView")
end).normalImg = "xbz_pb_wn_01.png"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("babelTowerMainView")
end).angle = "pb_wn"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("babelTowerMainView")
end).needMove = true
_ENV, _ENV, (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("babelTowerMainView")
end).nextIndex = nil, nil, 4
;(nil).x = 506
;(nil).to, (nil).y = nil, 630
;(nil).flipx = false
;(nil).normalImg = "xbz_pb_n_01.png"
;(nil).angle = "pb_n"
;(nil).needMove = true
_ENV, _ENV, (nil).nextIndex = nil, nil, 8
;(nil).x = 260
;(nil).to, (nil).y = nil, 430
;(nil).flipx = false
;(nil).normalImg = "xbz_pb_wn_01.png"
;(nil).angle = "pb_wn"
;(nil).needMove = true
_ENV, _ENV, (nil).nextIndex = nil, nil, 5
;(nil).x = 750
;(nil).to, (nil).y = nil, 630
;(nil).flipx = false
;(nil).normalImg = "xbz_pb_n_01.png"
;(nil).angle = "pb_n"
;(nil).needMove = true
_ENV, _ENV, (nil).nextIndex = nil, nil, 6
;(nil).x = 247
;(nil).to, (nil).y = nil, 630
;(nil).flipx = false
;(nil).normalImg = "xbz_pb_n_01.png"
;(nil).angle = "pb_n"
;(nil).needMove = true
_ENV, _ENV, (nil).nextIndex = nil, nil, 7
;(nil).x = 705
;(nil).to, (nil).y = nil, 900
;(nil).flipx = false
;(nil).normalImg = "xbz_pb_n_01.png"
;(nil).angle = "pb_n"
;(nil).needMove = true
_ENV, _ENV, (nil).nextIndex = nil, nil, 9
;(nil).x = 300
;(nil).to, (nil).y = nil, 900
;(nil).flipx = false
;(nil).normalImg = "xbz_pb_n_01.png"
;(nil).angle = "pb_n"
;(nil).needMove = true
_ENV, _ENV, (nil).nextIndex = nil, nil, 10
;(nil).x = 512
;(nil).to, (nil).y = nil, 1000
;(nil).flipx = false
;(nil).normalImg = "xbz_pb_n_01.png"
;(nil).angle = "pb_n"
_ENV, _ENV, (nil).needMove = nil, nil, true
;(nil).x = 512
;(nil).to, (nil).y = nil, 1000
;(nil).flipx = false
;(nil).normalImg = "xbz_pb_wn_01.png"
;(nil).angle = "pb_wn"
_ENV, _ENV, (nil).needMove = nil, nil, true
;(nil).x = 512
;(nil).to, (nil).y = nil, 1000
;(nil).flipx = true
;(nil).normalImg = "xbz_pb_wn_01.png"
;(nil).angle = "pb_wn"
_ENV, (nil).needMove = nil, true
;(nil).flipx = false
;(nil).normalImg = "xbz_sj_01.png"
;(nil).angle = "sj"
;(nil).needMove = false
_ENV, (nil).needDelay = nil, 0.8
;(nil).flipx = false
;(nil).normalImg = "xbz_sw_01.png"
;(nil).angle = "sw"
;(nil).needMove = false
_ENV, _ENV, (nil).needDelay = nil, nil, 0.8
;(nil).x = 512
;(nil).to, (nil).y = nil, 1100
;(nil).flipx = false
;(nil).normalImg = "xbz_yd_n_01.png"
;(nil).angle = "yd_n"
;(nil).needMove = true
_ENV, _ENV, (nil).fadeToAction = nil, nil, true
;(nil).x = 512
;(nil).to, (nil).y = nil, 110
;(nil).flipx = false
;(nil).normalImg = "xbz_yd_n_01.png"
;(nil).angle = "yd_n"
;(nil).needMove = true
;(nil).fadeToAction = true
;("babelTowerMainView")[1] = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("babelTowerMainView")
end
;("babelTowerMainView")[2] = nil
;("babelTowerMainView")[3] = nil
;("babelTowerMainView")[4] = nil
;("babelTowerMainView")[5] = nil
;("babelTowerMainView")[6] = nil
;("babelTowerMainView")[7] = nil
;("babelTowerMainView")[8] = nil
;("babelTowerMainView")[9] = nil
;("babelTowerMainView")[10] = nil
;("babelTowerMainView")[11] = nil
;("babelTowerMainView")[12] = nil
;("babelTowerMainView")[13] = nil
local ("babelTowerMainView")[14], posList = nil, "babelTowerMainView"
function babelTowerMainView:onEnterPanel()
	SoraDShowLoading(self)
	babelTowerCtrl:reqTongtianTowerInfo()
end
function babelTowerMainView:ctor(properties)
	self.isHideCurrentSceneView = true
	self.activityID = gActivityTimeActivityID.TONGTIAN_TOWER_ACTIVITY
	self.ticketsID = 726001
	self.nowFloor = 1
	self.canChallenge = false
	self.chooseIndex = 1
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeCommonFramTitle:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.nodeCommonFramTitle:setTitle(i18n("activity_name_9001273"))
	self.imgBg = SoraDGetChildByName(self, "Image_Bg")
	self.nodeBottom = SoraDGetChildByName(self, "Node_Bottom")
	self.nodeTime = SoraDGetChildByName(self, "Top_Node_time")
	self.textActivityTime = SoraDGetChildByName(self.nodeTime, "Text_ActivityTime")
	self.textActivityTime = SoraDCreateTimerLabel(self, self.textActivityTime)
	self.textFloorName = SoraDGetChildByName(self, "Text_FloorTitle")
	self.imgItemIcon = SoraDGetChildByName(self, "Image_ItemIcon")
	self.textItemNum = SoraDGetChildByName(self, "Text_ItemNum")
	self.btnJumpToRecharge = SoraDGetChildByName(self, "Button_JumpToRecharge")
	self.btnJumpToRecharge:addTouchEventListener(handler(self, self.btnJumpToRechargeClick))
	self.nodeLifeBar = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_bar")
	self.loadBarBg = SoraDGetChildByName(self.nodeLifeBar, "LoadingBar_progress_1")
	_ENV = "LoadingBar_progress_1"
	;("LoadingBar_progress_1").maxValue = 1000
	;("LoadingBar_progress_1").curValue = 1000
	self.nodeLifeBar:setProgressDate("LoadingBar_progress_1")
	self.nodeLifeBar:setLocalZOrder(3)
	self.textProgress = SoraDGetChildByName(self, "Text_progress")
	self.btnRank = SoraDGetChildByName(self, "Button_Rank")
	SoraDGetChildByName(self.btnRank, "Text_Describe"):setString(i18n("common_text_851"))
	self.btnRank:addTouchEventListener(handler(self, self.btnRankClick))
	self.btnFloorReward = SoraDGetChildByName(self, "Button_Reward")
	SoraDGetChildByName(self.btnFloorReward, "Text_Describe"):setString(i18n("Promise_Summit_text_16"))
	self.btnFloorReward:addTouchEventListener(handler(self, self.btnFloorRewardClick))
	self.btnBuff = SoraDGetChildByName(self, "Button_Buff")
	SoraDGetChildByName(self.btnBuff, "Text_Describe"):setString(i18n("Promise_Summit_text_02"))
	self.btnBuff:addTouchEventListener(handler(self, self.btnBuffClick))
	self.btnReset = SoraDGetChildByName(self, "Button_Reset")
	self.btnReset:setPressedActionEnabled(false)
	self.btnReset:addTouchEventListener(handler(self, self.btnResetClick))
	self.btnDoorList = SoraDGetChildsArrayByName(self, "Button_DoorClick_", 3, 1)
	for i, v in ipairs(self.btnDoorList) do
		v:setTag(SoraDFIsRA() and 4 - i or i)
		v:addTouchEventListener(handler(self, self.btnChallengeClick))
	end
	self.nodeNpc = SoraDGetChildByName(self, "Node_Player")
	self.imgNpc = SoraDGetChildByName(self.nodeNpc, "Image_Player")
	self.nodeEventAction = SoraDGetChildByName(self.nodeNpc, "Node_EventAction")
	self.nodeAddBloodAction = SoraDGetChildByName(self.nodeNpc, "Node_AddBloodAction")
	self.nodeBgEffect = SoraDGetChildByName(self, "Node_BgEffect")
	self.nodeBgEffect_1 = SoraDGetChildByName(self, "Node_BgEffect_1")
	self.nodeAddBloodAction:setLocalZOrder(2)
	self.nodeEventAction:setLocalZOrder(2)
	self.blackPanel = SoraDGetChildByName(self, "Panel_Black_Size")
	self.blackPanel:setVisible(false)
	self.btnNowBox = SoraDGetChildByName(self, "Button_NowBox")
	self.btnNowBox:addTouchEventListener(handler(self, self.btnNowBoxClick))
	self.textReset = SoraDGetChildByName(self, "Text_Reset")
	self.textReset:setString(i18n("common_text_4152"))
	self.nodeFinger = SoraDGetChildByName(self, "Node_Finger")
	self.nodeFinger:setVisible(false)
	self.Text_cost_num = SoraDGetChildByName(self, "Text_cost_num")
	self.Text_cost_des = SoraDGetChildByName(self, "Text_2")
	self.Button_ten = SoraDGetChildByName(self, "Button_ten")
	self.Button_ten:addTouchEventListener(handler(self, self.btnTenClick))
	self:initActivityTime()
	self:initViewAndEffect()
end
function babelTowerMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.activityStatusCallBack))
	SoraDAddMessage(self, "MESSAGE_BABEL_TOWER_REFRESH", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updataItemNum))
end
function babelTowerMainView:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.textActivityTime:setTimeLast(function(ticket)
		return ticket
	end)
	if self.eventTime then
		self.textActivityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
end
function babelTowerMainView:initViewAndEffect()
	local height = display.height - 70
	self.bgScale = math.max(0.625, height / 1320)
	print("self.bgScale", self.bgScale)
	self.imgBg:setScale(self.bgScale)
	self.nodeNpc:setPosition(cc.p(320, 110 * self.bgScale))
	self.nodeEventAction = SoraDCreatAnimationEx("babelTowerEventAction", self.nodeEventAction, false)
	self.nodeEventAction:setVisible(false)
	self.nodeEventAction.action:gotoFrameAndPause(0)
	local loop = true
	local cssFileName = "babelTowerMainView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:runAction(action)
	self.nodeAddBloodAction = SoraDCreatAnimationEx("babelTowerAddBlood", self.nodeAddBloodAction, false)
	self.nodeAddBloodAction:setVisible(false)
	self.nodeAddBloodAction.action:gotoFrameAndPause(0)
	self.nodeBgEffect = SoraDCreatAnimationEx("babelTowerEffect", self.nodeBgEffect, true)
	if SoraDFIsRA() then
		self.nodeBgEffect:setPositionX(519)
		self.nodeBgEffect:setScaleX(-1)
	end
	self.nodeBgEffect_1 = SoraDCreatAnimationEx("babelTowerEffectMore", self.nodeBgEffect_1, true)
	self.Node_sun = SoraDGetChildByName(self, "Node_sun")
	for k, v in ipairs(self.Node_sun:getChildren()) do
		if v.resetSystem then
			v:setAutoCull(false)
		end
	end
	local Particle_bwq = SoraDGetChildByName(self, "Particle_bwq")
	Particle_bwq:setAutoCull(false)
	_UPVALUE2_ = Particle_bwq.setAutoCull
	Particle_bwq.setAutoCull[1] = cc.p(-250, -36)
	Particle_bwq.setAutoCull[2] = cc.p(0, 0)
	Particle_bwq.setAutoCull[3] = cc.p(255, -36)
	Particle_bwq.setAutoCull[4] = cc.p(255, -36)
	Particle_bwq.setAutoCull[5] = cc.p(255, -36)
	Particle_bwq.setAutoCull[6] = cc.p(255, -36)
	Particle_bwq.setAutoCull[7] = cc.p(255, -36)
	local Particle_bwq.setAutoCull[8], posList = cc.p(255, -36)
	for i = 1, 3 do
		local nodeSingle = SoraDFingerAction(true)
		nodeSingle:addTo(self.nodeFinger)
		nodeSingle:setPosition(posList[i])
	end
end
function babelTowerMainView:initData()
	self:updateFloor()
	self:updataItemNum()
	self:updateBlood()
end
function babelTowerMainView:updataItemNum()
	self.numOfTickets = backpackCtrl:getItemCount(self.ticketsID)
	self.textItemNum:setString(self.numOfTickets)
	self.maxNum = babelTowerRead:getTowerNum()
	local lastNum = math.max(math.min(10, self.maxNum - self.nowFloor + 1), 0)
	self.lastNum = lastNum
	backpackCtrl = nil
	;(nil).num = lastNum
	self.Text_cost_des:setString(i18n("Promise_Summit_text_50", nil))
	lastNum = babelTowerCtrl:isFirstClimb() and 0 < lastNum and lastNum - 1 or lastNum
	self.Text_cost_num:setString(lastNum)
	self.isEnough = true
	if lastNum > self.numOfTickets then
		self.isEnough = false
		self.Text_cost_num:setColor(cc.c3b(255, 1, 1))
	else
		self.Text_cost_num:setColor(cc.c3b(255, 255, 255))
	end
end
function babelTowerMainView:updateBlood(fromDead)
	local actionValue = self.lifeNum or babelTowerCtrl:getBlood()
	if fromDead then
		self.lifeNum = 0
	else
		self.lifeNum = babelTowerCtrl:getBlood()
	end
	self.bloodMax = babelTowerCtrl:getBloodMax()
	babelTowerCtrl = nil
	;(nil).maxValue = self.bloodMax
	;(nil).curValue = self.lifeNum
	self.nodeLifeBar:setProgressDate(nil)
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	if actionValue ~= self.lifeNum then
		self.timer = SoradCreateTimer(self, function(...)
			local preValue = (self.lifeNum - actionValue) / 35
			self.loadBarBg:setPercent(actionValue / self.bloodMax * 100)
		end, true)
	else
		self.loadBarBg:setPercent(self.lifeNum / self.bloodMax * 100)
	end
	babelTowerCtrl = nil
	;(nil).name = i18n("common_text_147")
	;(nil).msg = string.format("%d/%d", self.lifeNum, self.bloodMax)
	self.textProgress:setString(i18n("common_text_1000", nil))
end
function babelTowerMainView:updateFloor(target, data)
	self.nowFloor = babelTowerCtrl:getFloor()
	if self.nowFloor >= babelTowerRead:getTowerNum() then
		self.textFloorName:setString(i18n("Promise_Summit_text_26"))
	else
		babelTowerCtrl = i18n("Promise_Summit_text_26")
		i18n("Promise_Summit_text_26").num = self.nowFloor
		self.textFloorName:setString(i18n("Promise_Summit_text_01", i18n("Promise_Summit_text_26")))
	end
end
function babelTowerMainView:updateButtonState(state)
	self.canChallenge = state
end
function babelTowerMainView:resetAction(fromReset)
	self.blackPanel:setVisible(true)
	self.blackPanel:setOpacity(0)
	_UPVALUE2_ = nil
	;(nil)[1] = cca.delay(0.5)
	;(nil)[2] = cca.fadeTo(0.6666666666666666, 1)
	;(nil)[3] = cca.fadeTo(0.3333333333333333, 0)
	;(nil)[4] = cca.fadeTo(0.3333333333333333, 0)
	;(nil)[5] = cca.fadeTo(0.3333333333333333, 0)
	;(nil)[6] = cca.fadeTo(0.3333333333333333, 0)
	;(nil)[7] = cca.fadeTo(0.3333333333333333, 0)
	;(nil)[8] = cca.fadeTo(0.3333333333333333, 0)
	self.blackPanel:runAction(cca.seq(nil))
	self.nodeTime:setOpacity(255)
	self.nodeBottom:setOpacity(255)
	_UPVALUE3_ = cca.seq(nil)
	cca.seq(nil)[1] = cca.delay(0.16666666666666666)
	cca.seq(nil)[2] = cca.fadeTo(0.5, 0)
	cca.seq(nil)[3] = cca.delay(0.6666666666666666)
	cca.seq(nil)[4] = cca.fadeTo(0.5, 1)
	cca.seq(nil)[5] = cca.fadeTo(0.5, 1)
	cca.seq(nil)[6] = cca.fadeTo(0.5, 1)
	cca.seq(nil)[7] = cca.fadeTo(0.5, 1)
	cca.seq(nil)[8] = cca.fadeTo(0.5, 1)
	self.nodeBottom:runAction(cca.seq(cca.seq(nil)))
	_UPVALUE3_ = cca.seq(cca.seq(nil))
	cca.seq(cca.seq(nil))[1] = cca.delay(0.16666666666666666)
	cca.seq(cca.seq(nil))[2] = cca.fadeTo(0.5, 0)
	cca.seq(cca.seq(nil))[3] = cca.delay(0.6666666666666666)
	cca.seq(cca.seq(nil))[4] = cca.fadeTo(0.5, 1)
	cca.seq(cca.seq(nil))[5] = cca.fadeTo(0.5, 1)
	cca.seq(cca.seq(nil))[6] = cca.fadeTo(0.5, 1)
	cca.seq(cca.seq(nil))[7] = cca.fadeTo(0.5, 1)
	cca.seq(cca.seq(nil))[8] = cca.fadeTo(0.5, 1)
	self.nodeTime:runAction(cca.seq(cca.seq(cca.seq(nil))))
	self.imgNpc:stopAllActions()
	self.nodeNpc:stopAllActions()
	if not fromReset then
		self.nodeNpc:setPosition(320, 1000 * self.bgScale)
		self.chooseIndex = 13
		self:runNpcAction(true)
	else
		_UPVALUE3_ = 1000 * self.bgScale
		;(1000 * self.bgScale)[1] = cca.delay(0.23333333333333334)
		;(1000 * self.bgScale)[2] = cca.fadeTo(0.16666666666666666, 0.93)
		;(1000 * self.bgScale)[3] = cca.fadeTo(0.3333333333333333, 0.04)
		;(1000 * self.bgScale)[4] = cca.fadeTo(0.6, 0)
		;(1000 * self.bgScale)[5] = cca.fadeTo(0.6, 0)
		;(1000 * self.bgScale)[6] = cca.fadeTo(0.6, 0)
		;(1000 * self.bgScale)[7] = cca.fadeTo(0.6, 0)
		;(1000 * self.bgScale)[8] = cca.fadeTo(0.6, 0)
		self.nodeNpc:runAction(cca.seq(1000 * self.bgScale))
	end
	self.imgBg:setOpacity(255)
	_UPVALUE5_ = self.imgBg
	_UPVALUE1_ = cca.seq(1000 * self.bgScale)
	_UPVALUE1_ = 0
	;(0)[1] = cca.scaleTo(0.45, self.bgScale * 1.135)
	;(0)[2] = cca.scaleTo(0.21666666666666667, self.bgScale * 1.2)
	;(0)[3] = cca.scaleTo(0.21666666666666667, self.bgScale * 1.2)
	;(0)[4] = cca.scaleTo(0.21666666666666667, self.bgScale * 1.2)
	cca.seq(1000 * self.bgScale)[1] = cca.fadeTo(0.6666666666666666, 0)
	cca.seq(1000 * self.bgScale)[2] = cca.seq(0)
	cca.seq(1000 * self.bgScale)[3] = cca.seq(0)
	cca.seq(1000 * self.bgScale)[4] = cca.seq(0)
	cca.seq(1000 * self.bgScale)[5] = cca.seq(0)
	cca.seq(1000 * self.bgScale)[6] = cca.seq(0)
	cca.seq(1000 * self.bgScale)[7] = cca.seq(0)
	_UPVALUE1_ = cca.seq(0)
	cca.seq(0)[1] = cca.fadeTo(0.3333333333333333, 1)
	cca.seq(0)[2] = cca.scaleTo(0.3333333333333333, self.bgScale)
	cca.seq(0)[3] = cca.scaleTo(0.3333333333333333, self.bgScale)
	cca.seq(0)[4] = cca.scaleTo(0.3333333333333333, self.bgScale)
	cca.seq(0)[5] = cca.scaleTo(0.3333333333333333, self.bgScale)
	self.imgBg[1] = cca.delay(0.6666666666666666)
	self.imgBg[2] = cca.spawn(cca.seq(1000 * self.bgScale))
	self.imgBg[3] = cca.callFunc(function()
		self:updateBlood()
		self:updateFloor()
		self.nodeNpc:setPosition(320, 0)
		self.chooseIndex = 14
		self:updataItemNum()
		self:runNpcAction(true)
	end)
	self.imgBg[4] = cca.spawn(cca.seq(0))
	self.imgBg[5] = cca.delay(0.6666666666666666)
	self.imgBg[6] = cca.callFunc(function()
		self.nodeNpc:stopAllActions()
		self.imgNpc:stopAllActions()
		self.blackPanel:setVisible(false)
		self:updateButtonState(true)
		self.runingAction = false
		if self.nextTenAction then
			self.nextTenAction = false
			self:challangeTen()
		end
	end)
	self.imgBg[7] = cca.callFunc(function()
		self.nodeNpc:stopAllActions()
		self.imgNpc:stopAllActions()
		self.blackPanel:setVisible(false)
		self:updateButtonState(true)
		self.runingAction = false
		if self.nextTenAction then
			self.nextTenAction = false
			self:challangeTen()
		end
	end)
	self.imgBg[8] = cca.callFunc(function()
		self.nodeNpc:stopAllActions()
		self.imgNpc:stopAllActions()
		self.blackPanel:setVisible(false)
		self:updateButtonState(true)
		self.runingAction = false
		if self.nextTenAction then
			self.nextTenAction = false
			self:challangeTen()
		end
	end)
	self.imgBg[9] = cca.callFunc(function()
		self.nodeNpc:stopAllActions()
		self.imgNpc:stopAllActions()
		self.blackPanel:setVisible(false)
		self:updateButtonState(true)
		self.runingAction = false
		if self.nextTenAction then
			self.nextTenAction = false
			self:challangeTen()
		end
	end)
	self.imgBg[10] = cca.callFunc(function()
		self.nodeNpc:stopAllActions()
		self.imgNpc:stopAllActions()
		self.blackPanel:setVisible(false)
		self:updateButtonState(true)
		self.runingAction = false
		if self.nextTenAction then
			self.nextTenAction = false
			self:challangeTen()
		end
	end)
	local actionImg = cca.seq(self.imgBg)
	self.imgBg:runAction(actionImg)
end
function babelTowerMainView:runNpcAction(isSpawn)
	self.runingAction = true
	print("self.chooseIndex", self.chooseIndex)
	local config = posList[self.chooseIndex]
	self.nodeNpc:stopAllActions()
	self.imgNpc:stopAllActions()
	self.imgNpc:setSpriteFrame(config.normalImg)
	self.imgNpc:setFlippedX(config.flipx)
	local speed = 240
	local frames = display.newFrames("xbz_" .. config.angle .. "_%02d.png", 1, 16)
	if self.chooseIndex <= 10 then
		frameTime = 0.5333
	elseif self.chooseIndex == 11 then
		frameTime = 0.8
	elseif self.chooseIndex == 12 then
		frameTime = 1.07
	else
		speed = 80
		frameTime = 1.07
	end
	local animation = display.newAnimation(frames, frameTime / 16)
	self.imgNpc:playAnimationForever(animation)
	local _ENV, actionList = self.imgNpc.playAnimationForever, self.imgNpc.playAnimationForever
	if config.needMove then
		local ePos = self:getRunToPos(config.to)
		_ENV = self
		self.x = self.nodeNpc:getPositionX()
		local self.y, bPos = self.nodeNpc:getPositionY(), self
		local distance = cc.pGetDistance(bPos, ePos)
		table.insert(actionList, cca.moveTo(distance / speed, ePos.x, ePos.y))
	end
	if config.needDelay then
		local delayTime = 0.8
		if self.chooseIndex == 11 then
			delayTime = 0.8
			if self.nodeEventAction:isVisible() then
				delayTime = 1.7
			end
		end
		table.insert(actionList, cca.delay(delayTime))
	end
	if config.fadeToAction then
		if self.chooseIndex == 13 then
			_UPVALUE3_ = cca.delay(delayTime)
			cca.delay(delayTime)[1] = cca.delay(0.23333333333333334)
			cca.delay(delayTime)[2] = cca.fadeTo(0.16666666666666666, 0.93)
			cca.delay(delayTime)[3] = cca.fadeTo(0.3333333333333333, 0.04)
			cca.delay(delayTime)[4] = cca.fadeTo(0.6, 0)
			cca.delay(delayTime)[5] = cca.fadeTo(0.6, 0)
			cca.delay(delayTime)[6] = cca.fadeTo(0.6, 0)
			table.insert(actionList, cca.seq(cca.delay(delayTime)))
		elseif self.chooseIndex == 14 then
			_ENV = cca.seq(cca.delay(delayTime))
			cca.seq(cca.delay(delayTime))[1] = cca.fadeTo(0.5, 1)
			cca.seq(cca.delay(delayTime))[2] = cca.fadeTo(0.5, 1)
			cca.seq(cca.delay(delayTime))[3] = cca.fadeTo(0.5, 1)
			cca.seq(cca.delay(delayTime))[4] = cca.fadeTo(0.5, 1)
			cca.seq(cca.delay(delayTime))[5] = cca.fadeTo(0.5, 1)
			cca.seq(cca.delay(delayTime))[6] = cca.fadeTo(0.5, 1)
			table.insert(actionList, cca.seq(cca.seq(cca.delay(delayTime))))
		end
	end
	if isSpawn then
		self.nodeNpc:runAction(cca.spawn(actionList))
	else
		table.insert(actionList, cca.callFunc(handler(self, self.npcActionEnd)))
		self.nodeNpc:runAction(cca.seq(actionList))
	end
end
function babelTowerMainView:npcActionEnd()
	if self.chooseIndex == 2 or self.chooseIndex == 4 or self.chooseIndex == 5 then
		if self.msgData.subMsg == "ten" then
			self.chooseIndex = posList[self.chooseIndex].nextIndex
			self:runNpcAction()
		elseif self.msgData.isPass then
			self.lastIndex = self.chooseIndex
			if self.msgData.eventIndex == 0 then
				if self.msgData.hasBuff then
					self:resetNpcStatus(true)
					self:openBuffChooseView()
				else
					self.chooseIndex = posList[self.chooseIndex].nextIndex
					self:runNpcAction()
				end
			else
				self:showEventAction()
				if 0 > self.msgData.changeBlood then
					self:addSpriteNameAction(true)
					_ENV = nil
					;(nil)[1] = cca.delay(0.5)
					;(nil)[2] = cca.callFunc(function()
						self:addBloodText(self.msgData.changeBlood)
						self:updateBlood()
					end)
					;(nil)[3] = cca.callFunc(function()
						self:addBloodText(self.msgData.changeBlood)
						self:updateBlood()
					end)
					self:runAction(cca.seq(nil))
				end
				self.chooseIndex = 11
				self:runNpcAction()
				return
			end
		else
			self:addBloodText(-self.lifeNum)
			self:updateBlood(true)
			self.chooseIndex = 12
			self:runNpcAction()
			return
		end
	elseif self.chooseIndex == 1 or self.chooseIndex == 3 or self.chooseIndex == 6 or self.chooseIndex == 7 then
		self.chooseIndex = posList[self.chooseIndex].nextIndex
		self:runNpcAction()
	elseif self.chooseIndex <= 10 and self.chooseIndex >= 8 then
		if self.msgData.subMsg == "ten" then
			local panel = SoraDCreatePanel("babelTowerTenResult")
			panel:initData(self.msgData.tenResult)
			panel:show()
		else
			babelTowerCtrl:reqNextFloor()
		end
		self:resetNpcStatus(true)
		self.msgData = nil
	elseif self.chooseIndex == 11 then
		self:resetNpcStatus(true)
		self.nodeEventAction:setVisible(false)
		if self.msgData.hasBuff then
			self:openBuffChooseView()
		else
			self:runNextAction()
		end
	elseif self.chooseIndex == 12 then
		self.imgNpc:stopAllActions()
		self.nodeNpc:stopAllActions()
		self:showResultView(false)
		self.msgData = nil
	end
end
function babelTowerMainView:runAddBloodAction()
	self.imgNpc:setVisible(false)
	self.nodeAddBloodAction:setVisible(true)
	SoraDGetChildByName(self.nodeAddBloodAction, "et_Par_ttt_013"):resetSystem()
	self.nodeAddBloodAction.action:gotoFrameAndPlay(0, false)
end
function babelTowerMainView:addBloodText(numStr)
	if numStr == nil then
		return
	end
	if not self.textBlood then
		_ENV = nil
		;(nil).font = "Arial"
		;(nil).text = ""
		;(nil).size = 28
		;(nil).align = SoraDFLabelR()
		;(nil).valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
		self.textBlood = display.newTTFLabel(nil)
		self.textBlood:enableOutline(cc.c3b(0, 0, 0), 1)
		self.textBlood:addTo(self.nodeNpc, 1)
	end
	if numStr < 0 then
		self:addRedSheerAction(true)
	end
	self.textBlood:setPosition(9, 80)
	self.textBlood:setColor(0 < numStr and cc.c3b(0, 255, 12) or cc.c3b(255, 0, 0))
	self.textBlood:setString(0 < numStr and "+" .. numStr or numStr)
	self.textBlood:setOpacity(255)
	self.textBlood:setScale(0.1)
	_UPVALUE3_ = numStr
	_UPVALUE2_ = 0
	;(0)[1] = cca.moveTo(0.3, self.textBlood:getPositionX(), self.textBlood:getPositionY() + 50)
	;(0)[2] = cca.fadeTo(0.3, 1)
	;(0)[3] = cca.scaleTo(0.3, 1)
	;(0)[4] = cca.scaleTo(0.3, 1)
	;(0)[5] = cca.scaleTo(0.3, 1)
	numStr[1] = cca.spawn(0)
	numStr[2] = cca.delay(0.3)
	numStr[3] = cca.fadeTo(0.2, 0)
	numStr[4] = cca.callFunc(function()
		self:addRedSheerAction(false)
		self:addSpriteNameAction(false)
	end)
	numStr[5] = cca.callFunc(function()
		self:addRedSheerAction(false)
		self:addSpriteNameAction(false)
	end)
	numStr[6] = cca.callFunc(function()
		self:addRedSheerAction(false)
		self:addSpriteNameAction(false)
	end)
	numStr[7] = cca.callFunc(function()
		self:addRedSheerAction(false)
		self:addSpriteNameAction(false)
	end)
	self.textBlood:runAction(cca.seq(numStr))
end
function babelTowerMainView:addSpriteNameAction(visible)
	if not self.spriteName then
		self.spriteName = display.newSprite()
		self.spriteName:addTo(self.nodeNpc, 1)
		self.spriteName:setPosition(9, 200)
		self.spriteName:setVisible(false)
	end
	if visible then
		local eventType = babelTowerRead:getEventType(self.nowFloor, self.msgData.eventIndex)
		local paramStr = "tm"
		if eventType == 1 then
			paramStr = "dq"
		end
		local spriteName = string.format("font_ttt_%s_%s.png", paramStr, SoraDFIsRA() and "ar" or "en")
		self.spriteName:stopAllActions()
		self.spriteName:setSpriteFrame(spriteName)
		self.spriteName:setVisible(true)
		self.spriteName:setOpacity(0)
		self.spriteName:runAction(cca.fadeIn(0.3))
	elseif self.spriteName:isVisible() then
		self.spriteName:stopAllActions()
		self.spriteName:runAction(cca.fadeOut(0.2))
	else
		self.spriteName:setVisible(false)
	end
end
function babelTowerMainView:addRedSheerAction(visible)
	if not self.redWarnning then
		self.redWarnning = ccui.ImageView:create("frame_sheer_red_01.png", ccui.TextureResType.plistType)
		self.redWarnning:ignoreContentAdaptWithSize(false)
		self.redWarnning:setContentSize(cc.size(640, display.height - 75))
		self.redWarnning:setAnchorPoint(cc.p(0, 0))
		self.redWarnning:setPosition(cc.p(0, 0))
		self.redWarnning:addTo(self, 1)
	end
	self.redWarnning:setVisible(visible)
	if visible then
		self.redWarnning:stopAllActions()
		self.redWarnning:setOpacity(0)
		local actionTintTo = cca.fadeTo(0.5, 0)
		local actionTinBack = cca.fadeTo(0.5, 1)
		_UPVALUE2_ = cc.p(0, 0)
		cc.p(0, 0)[1] = actionTinBack
		cc.p(0, 0)[2] = actionTintTo
		local actionRepeat = cca.rep(cca.seq(cc.p(0, 0)), 1)
		self.redWarnning:runAction(actionRepeat)
	end
end
function babelTowerMainView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		_ENV = "Promise_Summit_text_40"
		;("Promise_Summit_text_40").align = SoraDFIsRA() and cc.TEXT_ALIGNMENT_RIGHT or cc.TEXT_ALIGNMENT_LEFT
		SoraDShowHelpMsgTip(i18n("Promise_Summit_text_40"), "Promise_Summit_text_40")
	end
end
function babelTowerMainView:btnJumpToRechargeClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		self:openRechargeView()
	end
end
function babelTowerMainView:openRechargeView()
	local giftData = self:getGiftInfo()
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).rechargeID = giftData and tonumber(giftData.ID)
		uiManager:show("rechargeView", nil)
	else
		local panel = SoraDCreatePanel("rechargeView")
		if giftData then
			panel:jumpToLimitNode(giftData.category, tonumber(giftData.ID))
		end
		panel:show()
	end
end
function babelTowerMainView:btnRankClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("babelTowerRankView")
		panel:show()
	end
end
function babelTowerMainView:btnBuffClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("babelTowerBuffInfo")
		panel:show()
	end
end
function babelTowerMainView:btnResetClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.runingAction then
			return
		end
		SoraDPlaySound()
		SoraDShowMsgBox(i18n("Promise_Summit_text_06"), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if MSGBOX_CALLBACK_YES == type then
				babelTowerCtrl:reqResetTowerFloor()
			end
		end)
	end
end
function babelTowerMainView:btnChallengeClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if self.canChallenge and not self.isFloorInfoShow then
			self.nodeFinger:setVisible(false)
			self.chooseIndex = tag
			if babelTowerCtrl:getIsSkipInfo() and self.nowFloor <= babelTowerRead:getTowerNum() then
				self.costItemNum = babelTowerRead:getCostItemAndNum(self.nowFloor)
				self.itemNumHave = backpackCtrl:getItemCount(self.costItemNum[1])
				if self.costItemNum[2] > self.itemNumHave and not babelTowerCtrl:isFirstClimb() then
					SoraDShowMsgBox(i18n("Promise_Summit_text_65"), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
						if eventType == MSGBOX_CALLBACK_YES then
							self:openRechargeView()
						end
					end)
				else
					_ENV = i18n("common_text_204")
					i18n("common_text_204").floor = self.nowFloor
					i18n("common_text_204").door = tag
					babelTowerCtrl:reqTongtianTowerClimb((i18n("common_text_204")))
				end
			else
				self.isFloorInfoShow = true
				local panel = SoraDCreatePanel("babelTowerFloorInfo")
				panel:initData(self.nowFloor, tag)
				panel:show()
			end
		end
	end
end
function babelTowerMainView:btnRewardClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local nextTenFloor = math.ceil(self.nowFloor / 10) * 10
		local panel = SoraDCreatePanel("babelTowerBoxInfo")
		panel:initData(nextTenFloor)
		panel:show()
	end
end
function babelTowerMainView:btnFloorRewardClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("babelTowerFloorAward")
		panel:initData(self.nowFloor)
		panel:show()
	end
end
function babelTowerMainView:btnNowBoxClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("babelTowerNowFloorAward")
		panel:initData(self.nowFloor)
		panel:show()
	end
end
function babelTowerMainView:btnTenClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.canChallenge and not self.isFloorInfoShow then
			self:challangeTen()
		end
	end
end
function babelTowerMainView:challangeTen()
	if self.lastNum <= 0 then
		return
	end
	if not self.isEnough then
		SoraDShowMsgBox(i18n("Promise_Summit_text_65"), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
			if eventType == MSGBOX_CALLBACK_YES then
				self:openRechargeView()
			end
		end)
		return
	end
	local buffList
	local floor = -1
	for i = self.nowFloor, self.nowFloor + self.lastNum - 1 do
		print("floor ======== ", i)
		local tmpBuffList = babelTowerRead:getBuffList(i)
		if 0 < #tmpBuffList then
			buffList = tmpBuffList
			floor = i
			break
		end
	end
	if buffList then
		self:openBuffChooseView(floor, true)
	else
		babelTowerCtrl:reqTen(0)
	end
end
function babelTowerMainView:activityStatusCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function babelTowerMainView:msgCallBack(target, data)
	if data.subMsg == "rank" then
		return
	end
	self.msgData = data
	if data.subMsg == "init" then
		SoraDCloseLoading(self)
		self:updateButtonState(data.state == 0)
		self:initData()
		if data.state == 1 then
			self.lastIndex = self:getChooseIndex(data.door)
			self.nodeNpc:setPosition(self:getRunToPos(posList[self.lastIndex].to))
			self:openBuffChooseView()
		elseif data.state == 2 then
			self.lastIndex = self:getChooseIndex(data.door)
			self.nodeNpc:setPosition(self:getRunToPos(posList[self.lastIndex].to))
			self:runNextAction()
		elseif self.nowFloor > babelTowerRead:getTowerNum() then
			self:updateButtonState(false)
			self.nodeNpc:setPosition(320, 950 * self.bgScale)
			self:showMaxFloorResetMsgBox()
		end
	elseif data.subMsg == "climb" then
		self:updateButtonState(false)
		self:updataItemNum()
		self:runNpcAction()
	elseif data.subMsg == "chooseBuff" then
		if 0 < self.msgData.changeBlood then
			babelTowerRead = 950 * self.bgScale
			;(950 * self.bgScale)[1] = cca.callFunc(function()
				self.imgNpc:setVisible(false)
				self:addBloodText(self.msgData.changeBlood)
				self:runAddBloodAction()
				self:updateBlood()
			end)
			;(950 * self.bgScale)[2] = cca.delay(1.5)
			;(950 * self.bgScale)[3] = cca.callFunc(function()
				self:runNextAction()
			end)
			;(950 * self.bgScale)[4] = cca.callFunc(function()
				self:runNextAction()
			end)
			self:runAction(cca.seq(950 * self.bgScale))
		else
			self:runNextAction()
		end
	elseif data.subMsg == "reset" then
		babelTowerCtrl:setIsSkipInfo(false)
		self:resetAction(true)
	elseif data.subMsg == "nextFloor" then
		self:showResultView(true)
	elseif data.subMsg == "nextFloorAction" then
		self:resetAction()
	elseif data.subMsg == "nextTenAction" then
		self.nextTenAction = true
		self:resetAction()
	elseif data.subMsg == "maxTowerReset" then
		self:showMaxFloorResetMsgBox()
	elseif data.subMsg == "floorInfoClose" then
		self.isFloorInfoShow = false
	elseif data.subMsg == "showFinger" then
		self.nodeFinger:setVisible(true)
	elseif data.subMsg == "ten" then
		babelTowerCtrl = data.subMsg
		data.subMsg[1] = 1
		data.subMsg[2] = 2
		local data.subMsg[3], idxs = 3, data.subMsg
		self.chooseIndex = idxs[math.random(1, 3)]
		self:updateButtonState(false)
		self:updataItemNum()
		self:runNpcAction()
	end
end
function babelTowerMainView:runNextAction()
	self.imgNpc:setVisible(true)
	self.nodeAddBloodAction:setVisible(false)
	self.chooseIndex = posList[self.lastIndex].nextIndex
	self.lastIndex = nil
	self:runNpcAction()
end
function babelTowerMainView:showMaxFloorResetMsgBox()
	SoraDShowMsgBox(i18n("Promise_Summit_text_38"), i18n("common_text_204"), i18n("common_text_185"), function(type)
		if MSGBOX_CALLBACK_YES == type then
			babelTowerCtrl:reqResetTowerFloor()
		end
	end)
end
function babelTowerMainView:openBuffChooseView(floor, isInPreview)
	floor = floor and floor or self.nowFloor
	local panel = SoraDCreatePanel("babelTowerBuffChoose")
	local pos = cc.p(self.btnBuff:getPositionX(), self.btnBuff:getPositionY() + self.nodeTime:getPositionY())
	panel:initData(floor, pos, isInPreview)
	panel:show()
end
function babelTowerMainView:resetNpcStatus(isVisible)
	self.imgNpc:setVisible(isVisible)
	self.imgNpc:stopAllActions()
	self.imgNpc:setSpriteFrame("xbz_pb_n_01.png")
	self.nodeNpc:stopAllActions()
end
function babelTowerMainView:showEventAction()
	local eventType = babelTowerRead:getEventType(self.nowFloor, self.msgData.eventIndex)
	print("eventType", eventType)
	self.imgNpc:setVisible(false)
	self.nodeEventAction:getChildByName("Node_tengman"):setVisible(eventType == 2)
	self.nodeEventAction:getChildByName("Node_duqi"):setVisible(eventType == 1)
	self.nodeEventAction:setVisible(eventType == 2 or eventType == 1)
	SoraDGetChildByName(self.nodeEventAction, "et_Par_gmzz_005"):resetSystem()
	SoraDGetChildByName(self.nodeEventAction, "et_Par_ttt_003"):resetSystem()
	self.nodeEventAction.action:gotoFrameAndPlay(0, false)
end
function babelTowerMainView:showResultView(isWin)
	local panel = SoraDCreatePanel("babelTowerResult")
	panel:initData(self.nowFloor, self.msgData and self.msgData.reward, isWin)
	panel:show()
end
function babelTowerMainView:getRunToPos(pos)
	local _UPVALUE0_, retPos
	retPos.x = pos.x * self.bgScale - (512 * self.bgScale - 320)
	retPos.y = pos.y * self.bgScale
	return retPos
end
function babelTowerMainView:getGiftInfo()
	local giftInfo = rechargeActivityCtrl:getHotActivityList()
	dump(giftInfo, "giftInfo", 10)
	_UPVALUE4_ = giftInfo
	giftInfo[1] = 13941
	giftInfo[2] = 13940
	giftInfo[3] = 13939
	giftInfo[4] = 13938
	for _, v in ipairs(giftInfo) do
		local item = giftInfo[tostring(v)]
		if item and tonumber(item.extraData) >= 1 then
			return item
		end
	end
end
function babelTowerMainView:getChooseIndex(door)
	_UPVALUE3_ = nil
	;(nil)[1] = 4
	;(nil)[2] = 2
	local (nil)[3], indexList = 5, nil
	return indexList[door]
end
return babelTowerMainView
