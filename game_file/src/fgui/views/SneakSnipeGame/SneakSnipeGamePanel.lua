local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SneakSnipeGamePanel = class("SneakSnipeGamePanel", baseFguiPanel)
local enemyHalfSize = cc.size(40, 70)
local maxBlood = 10
local fightDistance = 4225
local scaleView = 2.0
local arrowSpeed = 4000
local offSetY = (display.height - 1386) / 2
local offsetIphoneX = display.iPhoneXOffset - display.iPhoneXBottom
local realHeight = display.height
_ENV, _UPVALUE4_, _ENV = nil, nil, nil
_UPVALUE1_, (nil).pos = cc.p(-1920, offSetY), cc.p(-1920, offSetY)
;(nil).indexs, cc.p(-1920, offSetY)[1] = cc.p(-1920, offSetY), 8
_ENV, (nil).needFade = cc.p(-1920, offSetY), true
_UPVALUE2_, cc.p(-1920, offSetY).pos = cc.p(-1506, offSetY), cc.p(-1506, offSetY)
_ENV, cc.p(-1920, offSetY).indexs, cc.p(-1506, offSetY)[1] = cc.p(-1506, offSetY), cc.p(-1506, offSetY), 5
_ENV, cc.p(-1920, offSetY).indexs, cc.p(-1506, offSetY)[2] = cc.p(-1506, offSetY), cc.p(-1506, offSetY), 6
_UPVALUE2_, cc.p(-1506, offSetY).pos = cc.p(-50, offSetY), cc.p(-50, offSetY)
cc.p(-1506, offSetY).indexs, cc.p(-50, offSetY)[1] = cc.p(-50, offSetY), 2
cc.p(-1506, offSetY).indexs, cc.p(-50, offSetY)[2] = cc.p(-50, offSetY), 7
_ENV, cc.p(-1506, offSetY).needFade = cc.p(-50, offSetY), true
_UPVALUE5_, cc.p(-50, offSetY).pos = cc.p(-800, math.max(-130, offSetY)), cc.p(-800, math.max(-130, offSetY))
cc.p(-50, offSetY).indexs, cc.p(-800, math.max(-130, offSetY))[1] = cc.p(-800, math.max(-130, offSetY)), 4
cc.p(-50, offSetY).indexs, cc.p(-800, math.max(-130, offSetY))[2] = cc.p(-800, math.max(-130, offSetY)), 3
cc.p(-50, offSetY).indexs, cc.p(-800, math.max(-130, offSetY))[3] = cc.p(-800, math.max(-130, offSetY)), 1
cc.p(-50, offSetY).indexs, cc.p(-800, math.max(-130, offSetY))[4] = cc.p(-800, math.max(-130, offSetY)), 9
cc.p(-50, offSetY).indexs, cc.p(-800, math.max(-130, offSetY))[5] = cc.p(-800, math.max(-130, offSetY)), 10
cc.p(-50, offSetY).needFade = true
_ENV, _UPVALUE3_, (nil)[1], (nil)[1] = nil, nil, nil, nil
_ENV, _UPVALUE3_, (nil)[1], (nil)[2] = nil, nil, nil, cc.p(-1920, offSetY)
_ENV, _UPVALUE3_, (nil)[1], (nil)[3] = nil, nil, nil, cc.p(-1506, offSetY)
_ENV, _UPVALUE3_, (nil)[1], (nil)[4] = nil, nil, nil, cc.p(-50, offSetY)
_UPVALUE5_, (nil).pos = cc.p(-1642, offSetY), cc.p(-1642, offSetY)
;(nil).indexs, cc.p(-1642, offSetY)[1] = cc.p(-1642, offSetY), 5
;(nil).indexs, cc.p(-1642, offSetY)[2] = cc.p(-1642, offSetY), 6
;(nil).indexs, cc.p(-1642, offSetY)[3] = cc.p(-1642, offSetY), 7
;(nil).indexs, cc.p(-1642, offSetY)[4] = cc.p(-1642, offSetY), 8
;(nil).indexs, cc.p(-1642, offSetY)[5] = cc.p(-1642, offSetY), 11
_ENV, (nil).needFade = cc.p(-1642, offSetY), true
_UPVALUE5_, cc.p(-1642, offSetY).pos = cc.p(-260, offSetY), cc.p(-260, offSetY)
cc.p(-1642, offSetY).indexs, cc.p(-260, offSetY)[1] = cc.p(-260, offSetY), 13
cc.p(-1642, offSetY).indexs, cc.p(-260, offSetY)[2] = cc.p(-260, offSetY), 1
cc.p(-1642, offSetY).indexs, cc.p(-260, offSetY)[3] = cc.p(-260, offSetY), 2
cc.p(-1642, offSetY).indexs, cc.p(-260, offSetY)[4] = cc.p(-260, offSetY), 3
cc.p(-1642, offSetY).indexs, cc.p(-260, offSetY)[5] = cc.p(-260, offSetY), 12
_ENV, cc.p(-1642, offSetY).needFade = cc.p(-260, offSetY), true
_UPVALUE5_, cc.p(-260, offSetY).pos = cc.p(-1060, offSetY), cc.p(-1060, offSetY)
cc.p(-260, offSetY).indexs, cc.p(-1060, offSetY)[1] = cc.p(-1060, offSetY), 4
cc.p(-260, offSetY).indexs, cc.p(-1060, offSetY)[2] = cc.p(-1060, offSetY), 9
cc.p(-260, offSetY).indexs, cc.p(-1060, offSetY)[3] = cc.p(-1060, offSetY), 10
cc.p(-260, offSetY).indexs, cc.p(-1060, offSetY)[4] = cc.p(-1060, offSetY), 14
cc.p(-260, offSetY).indexs, cc.p(-1060, offSetY)[5] = cc.p(-1060, offSetY), 15
cc.p(-260, offSetY).needFade = true
_ENV, _UPVALUE3_, (nil)[2], (nil)[1] = nil, nil, nil, nil
_ENV, _UPVALUE3_, (nil)[2], (nil)[2] = nil, nil, nil, cc.p(-1642, offSetY)
_ENV, _UPVALUE3_, (nil)[2], (nil)[3] = nil, nil, nil, cc.p(-260, offSetY)
_UPVALUE5_, (nil).pos = cc.p(-1577, offSetY), cc.p(-1577, offSetY)
;(nil).indexs, cc.p(-1577, offSetY)[1] = cc.p(-1577, offSetY), 15
;(nil).indexs, cc.p(-1577, offSetY)[2] = cc.p(-1577, offSetY), 14
;(nil).indexs, cc.p(-1577, offSetY)[3] = cc.p(-1577, offSetY), 13
;(nil).indexs, cc.p(-1577, offSetY)[4] = cc.p(-1577, offSetY), 11
;(nil).indexs, cc.p(-1577, offSetY)[5] = cc.p(-1577, offSetY), 12
_ENV, (nil).needFade = cc.p(-1577, offSetY), true
_UPVALUE5_, cc.p(-1577, offSetY).pos = cc.p(-360, offSetY), cc.p(-360, offSetY)
cc.p(-1577, offSetY).indexs, cc.p(-360, offSetY)[1] = cc.p(-360, offSetY), 1
cc.p(-1577, offSetY).indexs, cc.p(-360, offSetY)[2] = cc.p(-360, offSetY), 2
cc.p(-1577, offSetY).indexs, cc.p(-360, offSetY)[3] = cc.p(-360, offSetY), 3
cc.p(-1577, offSetY).indexs, cc.p(-360, offSetY)[4] = cc.p(-360, offSetY), 4
cc.p(-1577, offSetY).indexs, cc.p(-360, offSetY)[5] = cc.p(-360, offSetY), 5
_ENV, cc.p(-1577, offSetY).needFade = cc.p(-360, offSetY), true
_UPVALUE5_, cc.p(-360, offSetY).pos = cc.p(-933, offSetY), cc.p(-933, offSetY)
cc.p(-360, offSetY).indexs, cc.p(-933, offSetY)[1] = cc.p(-933, offSetY), 9
cc.p(-360, offSetY).indexs, cc.p(-933, offSetY)[2] = cc.p(-933, offSetY), 8
cc.p(-360, offSetY).indexs, cc.p(-933, offSetY)[3] = cc.p(-933, offSetY), 7
cc.p(-360, offSetY).indexs, cc.p(-933, offSetY)[4] = cc.p(-933, offSetY), 6
cc.p(-360, offSetY).indexs, cc.p(-933, offSetY)[5] = cc.p(-933, offSetY), 10
cc.p(-360, offSetY).needFade = true
_ENV, _UPVALUE1_, _ENV, (nil)[3], (nil)[1] = (cc.p(-1577, offSetY))
_ENV, _UPVALUE1_, _ENV, (nil)[3], (nil)[2] = cc.p(-1577, offSetY), nil, nil, nil, cc.p(-1577, offSetY)
_ENV, _UPVALUE1_, _ENV, (nil)[3], (nil)[3] = cc.p(-1577, offSetY), nil, nil, nil, cc.p(-360, offSetY)
local sceneConfig
_UPVALUE5_, cc.p(-1577, offSetY).pos = cc.p(-800, math.max(-130, offSetY)), cc.p(-800, math.max(-130, offSetY))
cc.p(-1577, offSetY).indexs, cc.p(-800, math.max(-130, offSetY))[1] = cc.p(-800, math.max(-130, offSetY)), 4
cc.p(-1577, offSetY).indexs, cc.p(-800, math.max(-130, offSetY))[2] = cc.p(-800, math.max(-130, offSetY)), 3
cc.p(-1577, offSetY).indexs, cc.p(-800, math.max(-130, offSetY))[3] = cc.p(-800, math.max(-130, offSetY)), 1
cc.p(-1577, offSetY).indexs, cc.p(-800, math.max(-130, offSetY))[4] = cc.p(-800, math.max(-130, offSetY)), 9
cc.p(-1577, offSetY).indexs, cc.p(-800, math.max(-130, offSetY))[5] = cc.p(-800, math.max(-130, offSetY)), 10
_ENV, _UPVALUE1_, (nil)[1], (nil)[1] = cc.p(-1577, offSetY), nil, nil, cc.p(-1577, offSetY)
_UPVALUE5_, cc.p(-1577, offSetY).pos = cc.p(-1060, offSetY), cc.p(-1060, offSetY)
cc.p(-1577, offSetY).indexs, cc.p(-1060, offSetY)[1] = cc.p(-1060, offSetY), 4
cc.p(-1577, offSetY).indexs, cc.p(-1060, offSetY)[2] = cc.p(-1060, offSetY), 9
cc.p(-1577, offSetY).indexs, cc.p(-1060, offSetY)[3] = cc.p(-1060, offSetY), 10
cc.p(-1577, offSetY).indexs, cc.p(-1060, offSetY)[4] = cc.p(-1060, offSetY), 14
cc.p(-1577, offSetY).indexs, cc.p(-1060, offSetY)[5] = cc.p(-1060, offSetY), 15
_ENV, _UPVALUE3_, (nil)[2], (nil)[1] = cc.p(-1577, offSetY), nil, nil, cc.p(-1577, offSetY)
_UPVALUE3_, cc.p(-1577, offSetY).pos = cc.p(-1577, offSetY), cc.p(-1577, offSetY)
cc.p(-1577, offSetY).indexs, cc.p(-1577, offSetY)[1] = cc.p(-1577, offSetY), 13
cc.p(-1577, offSetY).indexs, cc.p(-1577, offSetY)[2] = cc.p(-1577, offSetY), 11
cc.p(-1577, offSetY).indexs, cc.p(-1577, offSetY)[3] = cc.p(-1577, offSetY), 14
_ENV, cc.p(-1577, offSetY).needFade = cc.p(-1577, offSetY), true
_UPVALUE3_, cc.p(-1577, offSetY).pos = cc.p(-360, offSetY), cc.p(-360, offSetY)
cc.p(-1577, offSetY).indexs, cc.p(-360, offSetY)[1] = cc.p(-360, offSetY), 1
cc.p(-1577, offSetY).indexs, cc.p(-360, offSetY)[2] = cc.p(-360, offSetY), 3
cc.p(-1577, offSetY).indexs, cc.p(-360, offSetY)[3] = cc.p(-360, offSetY), 5
_ENV, cc.p(-1577, offSetY).needFade = cc.p(-360, offSetY), true
_UPVALUE3_, cc.p(-360, offSetY).pos = cc.p(-933, offSetY), cc.p(-933, offSetY)
cc.p(-360, offSetY).indexs, cc.p(-933, offSetY)[1] = cc.p(-933, offSetY), 9
cc.p(-360, offSetY).indexs, cc.p(-933, offSetY)[2] = cc.p(-933, offSetY), 8
cc.p(-360, offSetY).indexs, cc.p(-933, offSetY)[3] = cc.p(-933, offSetY), 6
cc.p(-360, offSetY).needFade = true
_UPVALUE10_, _ENV, (nil)[3], (nil)[1] = cc.p(-1577, offSetY), nil, nil, cc.p(-1577, offSetY)
_UPVALUE10_, _ENV, (nil)[3], (nil)[2] = cc.p(-1577, offSetY), nil, nil, cc.p(-1577, offSetY)
_UPVALUE10_, _ENV, (nil)[3], (nil)[3] = cc.p(-1577, offSetY), nil, nil, cc.p(-360, offSetY)
local sceneConfig_new
_UPVALUE15_, (nil)[1], cc.p(-1577, offSetY)[1] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 0
_UPVALUE15_, (nil)[1], cc.p(-1577, offSetY)[2] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 0
_UPVALUE15_, (nil)[1], cc.p(-1577, offSetY)[3] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 0
_UPVALUE15_, (nil)[1], cc.p(-1577, offSetY)[4] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 260
_UPVALUE15_, (nil)[1], cc.p(-1577, offSetY)[5] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 0
_UPVALUE15_, (nil)[1], cc.p(-1577, offSetY)[6] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 0
_UPVALUE15_, (nil)[1], cc.p(-1577, offSetY)[7] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 0
_UPVALUE15_, (nil)[1], cc.p(-1577, offSetY)[8] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 0
_UPVALUE15_, (nil)[1], cc.p(-1577, offSetY)[9] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), -300
_UPVALUE15_, (nil)[1], cc.p(-1577, offSetY)[10] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 300
_UPVALUE15_, (nil)[2], cc.p(-1577, offSetY)[1] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 0
_UPVALUE15_, (nil)[2], cc.p(-1577, offSetY)[2] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 0
_UPVALUE15_, (nil)[2], cc.p(-1577, offSetY)[3] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 0
_UPVALUE15_, (nil)[2], cc.p(-1577, offSetY)[4] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 200
_UPVALUE15_, (nil)[2], cc.p(-1577, offSetY)[5] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 0
_UPVALUE15_, (nil)[2], cc.p(-1577, offSetY)[6] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 0
_UPVALUE15_, (nil)[2], cc.p(-1577, offSetY)[7] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 0
_UPVALUE15_, (nil)[2], cc.p(-1577, offSetY)[8] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 0
_UPVALUE15_, (nil)[2], cc.p(-1577, offSetY)[9] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), -250
_UPVALUE15_, (nil)[2], cc.p(-1577, offSetY)[10] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 200
_UPVALUE15_, (nil)[2], cc.p(-1577, offSetY)[11] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 0
_UPVALUE15_, (nil)[2], cc.p(-1577, offSetY)[12] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 200
_UPVALUE15_, (nil)[2], cc.p(-1577, offSetY)[13] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 0
_UPVALUE15_, (nil)[2], cc.p(-1577, offSetY)[14] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), 170
_UPVALUE15_, (nil)[2], cc.p(-1577, offSetY)[15] = cc.p(-1577, offSetY), cc.p(-1577, offSetY), -150
;(nil)[3], cc.p(-1577, offSetY)[1] = cc.p(-1577, offSetY), 0
;(nil)[3], cc.p(-1577, offSetY)[2] = cc.p(-1577, offSetY), 0
;(nil)[3], cc.p(-1577, offSetY)[3] = cc.p(-1577, offSetY), 0
;(nil)[3], cc.p(-1577, offSetY)[4] = cc.p(-1577, offSetY), 0
;(nil)[3], cc.p(-1577, offSetY)[5] = cc.p(-1577, offSetY), 0
;(nil)[3], cc.p(-1577, offSetY)[6] = cc.p(-1577, offSetY), 0
;(nil)[3], cc.p(-1577, offSetY)[7] = cc.p(-1577, offSetY), 0
;(nil)[3], cc.p(-1577, offSetY)[8] = cc.p(-1577, offSetY), 300
;(nil)[3], cc.p(-1577, offSetY)[9] = cc.p(-1577, offSetY), -300
;(nil)[3], cc.p(-1577, offSetY)[10] = cc.p(-1577, offSetY), 0
;(nil)[3], cc.p(-1577, offSetY)[11] = cc.p(-1577, offSetY), 0
;(nil)[3], cc.p(-1577, offSetY)[12] = cc.p(-1577, offSetY), 0
;(nil)[3], cc.p(-1577, offSetY)[13] = cc.p(-1577, offSetY), 0
;(nil)[3], cc.p(-1577, offSetY)[14] = cc.p(-1577, offSetY), 0
;(nil)[3], cc.p(-1577, offSetY)[15] = cc.p(-1577, offSetY), 0
local sceneEnemyStatus
function SneakSnipeGamePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("SneakSnipeGamePanel:ctor", self.viewName)
end
function SneakSnipeGamePanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
	end
	return self._packageList
end
function SneakSnipeGamePanel:onInit()
	print("=======SneakSnipeGamePanel:onInit")
	SoraDPlayStopMusic()
	self.tf_bgm = SoraDPlayMusic("towerDefend", "td_bgm")
	self.enemyTable, _ENV, self.isTouchBegin = SoraDPlayMusic("towerDefend", "td_bgm"), SoraDPlayMusic("towerDefend", "td_bgm"), false
	self.sceneType = self.proxy.param.sceneType
	self.isTaskGame = self.proxy.param.isTaskGame
	self.sceneConfig = self.isTaskGame and sceneConfig or sceneConfig_new
	self.level = 1
	self.battleTime = 90
	self.blood = maxBlood
	self.isPause = false
	self.enemySpace, _ENV, self.canTouch = maxBlood, maxBlood, true
	self.fields.btn_hide:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onTouchStart))
	self.fields.btn_hide:setTouchEnabled(false)
	self:addEventListener(fgui.UIEventType.TouchBegin, function(context)
		context:CaptureTouch()
	end)
	self:addEventListener(fgui.UIEventType.TouchMove, handler(self, self.onTouchMove))
	self:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onTouchEnd))
	self.fields.node_time:setString(SoraDConvertSecondToStringNoDayNoHour(self.battleTime))
	self.fields.Com_Arrow:setPrepareCallback(function()
		self.fields.Com_Arrow.effect:start()
		self.fields.Com_Arrow:setUsmPos(cc.p(0, -50))
	end)
	self.fields.Com_Bow:setAllFrameName("qianxingjuji_nu_%02d.png", 1)
	self.fields.Com_Bow:setPlaySettings(0, 0, 1, -1)
	self.fields.Com_Bow:setPlaying(false)
	_ENV = self.fields.Com_Bow
	self.fields.Com_Bow.cssFileName = "node_attacked_effect"
	self.fields.Com_Bow.loop = false
	self.fields.Com_Bow.speed = 1.0
	self.effectNode = SoraDCreatAnimationParam(self.fields.Com_Bow)
	self.fields.csdLoad:setContent(self.effectNode)
end
function SneakSnipeGamePanel:onShow()
	print("=======SneakSnipeGamePanel:onShow")
	self:initSchedulerAndManager()
	self:initSceneEnemy()
	if self.sceneConfig[self.sceneType][self.level].needFade then
		self.sceneView:setPositionX(0)
		_UPVALUE1_ = nil
		;(nil)[1] = ffa.sineOut(ffa.moveTo(2, self.sceneConfig[self.sceneType][self.level].pos.x, self.sceneView:getPositionY()))
		;(nil)[2] = ffa.callFunc(function()
			self = nil
			;(nil).callback = handler(self, self.onGameStart)
			self.fields.node_start:startGame(nil)
		end)
		;(nil)[3] = ffa.callFunc(function()
			self = nil
			;(nil).callback = handler(self, self.onGameStart)
			self.fields.node_start:startGame(nil)
		end)
		;(nil)[4] = ffa.callFunc(function()
			self = nil
			;(nil).callback = handler(self, self.onGameStart)
			self.fields.node_start:startGame(nil)
		end)
		;(nil)[5] = ffa.callFunc(function()
			self = nil
			;(nil).callback = handler(self, self.onGameStart)
			self.fields.node_start:startGame(nil)
		end)
		;(nil)[6] = ffa.callFunc(function()
			self = nil
			;(nil).callback = handler(self, self.onGameStart)
			self.fields.node_start:startGame(nil)
		end)
		self.sceneView:runAction(ffa.seq(nil))
	else
		local pos = self.sceneConfig[self.sceneType][self.level].pos
		self.sceneView:setPosition(pos)
		_ENV = pos
		pos.callback = handler(self, self.onGameStart)
		self.fields.node_start:startGame(pos)
	end
end
function SneakSnipeGamePanel:onHide()
	SoraDResetBackGroundMusic()
	if self.param.closeCallback then
		self.param.closeCallback(self.isWin)
	end
	self:stopAllActions()
	self.fields.Com_warn:getTransition("t0"):stop()
	if self.timeHandler then
		SoraDManagerRemoveTimerCustom(self.myScheduler, self, self.timeHandler)
		self.timeHandler = nil
	end
	if self.myScheduler then
		scheduler.unscheduleGlobal(self.mySchedulerHandle)
		self.myScheduler = nil
	end
	if self.mySchedulerHandle then
		SoraDManagerRemoveTimer(self, self.mySchedulerHandle)
		self.mySchedulerHandle = nil
	end
end
function SneakSnipeGamePanel:onGameStart()
	if self.fingerEffect then
		self.fingerEffect:setVisible(true)
	end
	self:beginTime()
	self:getNewEnemyTable()
	self.fields.btn_hide:setTouchEnabled(true)
end
function SneakSnipeGamePanel:initSchedulerAndManager()
	self.mySchedulerHandle = SoradCreateTimer(self, handler(self, self.updateSchedulerCall), true)
	self.myScheduler = cc.Scheduler:new()
	SoraDSetNodeSchedulerAndManager(self:displayObject(), self.myScheduler)
end
function SneakSnipeGamePanel:initSceneEnemy()
	self.fields.Bg:getController("c1"):setSelectedIndex(self.sceneType - 1)
	self.sceneView = self.fields.Bg:getChild(string.format("n%d", self.sceneType - 1))
	local controller1 = self.sceneView:getController("c1")
	if controller1 then
		controller1:setSelectedIndex(self.isTaskGame and 1 or 0)
	end
	self.fingerEffect = self.sceneView:getChild("Effect_finger")
	for i, v in ipairs(sceneEnemyStatus[self.sceneType]) do
		local enemy = self.sceneView:getChildByName("Enemy_" .. i)
		if v ~= 0 then
			enemy:toWalk(v)
		else
			enemy:toStand()
		end
	end
end
function SneakSnipeGamePanel:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimerCustom(self.myScheduler, self, self.timeHandler)
		self.timeHandler = nil
	end
	self:updateTime()
	self.timeHandler = SoraDCreateTimerCustom(self.myScheduler, self, handler(self, self.updateTime))
end
function SneakSnipeGamePanel:getNewEnemyTable()
	self.enemyTable, _ENV, self.config = self.sceneConfig[self.sceneType][self.level], self.sceneConfig[self.sceneType][self.level], self.sceneConfig[self.sceneType][self.level]
	for i, v in ipairs(self.config.indexs) do
		local enemy = self.sceneView:getChildByName("Enemy_" .. v)
		table.insert(self.enemyTable, enemy)
	end
end
function SneakSnipeGamePanel:updateSchedulerCall(dt)
	if not self.myScheduler then
		return
	end
	if not self.isPause and not self.isGameOver then
		self.myScheduler:update(dt)
	end
end
function SneakSnipeGamePanel:updateTime()
	if self.battleTime < 0 then
		self:onGameFinish()
		return
	end
	local timeStr = SoraDConvertSecondToStringNoDayNoHour(self.battleTime)
	self.fields.node_time:setString(timeStr)
	self.battleTime = self.battleTime - 1
end
function SneakSnipeGamePanel:onGameFinish()
	self.isGameOver = true
	self:showResult(false)
end
function SneakSnipeGamePanel:shotArrow(info)
	self.fields.com_TouchEffect:setVisible(true)
	self.fields.com_TouchEffect:setPosition(self.touchPoint)
	self.fields.com_TouchEffect:getTransition("t0"):play()
	self.fields.Com_Arrow:stopAllActions()
	self.fields.Com_Arrow:setVisible(true)
	self.fields.Com_Arrow:setPosition(cc.p(328, self:getHeight()))
	self.fields.Com_Arrow:setAnchorPoint(cc.p(0.5, 1))
	local distance = cc.pGetDistance(self.touchPoint, self.fields.Com_Bow:getPosition())
	_UPVALUE3_ = self.fields.Com_Bow:getPosition()
	self.fields.Com_Bow:getPosition()[1] = ffa.moveTo(distance / arrowSpeed, self.touchPoint.x, self.touchPoint.y)
	self.fields.Com_Bow:getPosition()[2] = ffa.callFunc(function()
		self.fields.csdLoad:setVisible(true)
		self.fields.csdLoad:setPosition(self.touchPoint)
		self.effectNode.action:gotoFrameAndPlay(0, false)
		self.fields.Com_Arrow:setVisible(false)
	end)
	self.fields.Com_Bow:getPosition()[3] = ffa.delay(0.01)
	self.fields.Com_Bow:getPosition()[4] = ffa.callFunc(function()
		self:hitCheck()
	end)
	self.fields.Com_Bow:getPosition()[5] = ffa.callFunc(function()
		self:hitCheck()
	end)
	self.fields.Com_Bow:getPosition()[6] = ffa.callFunc(function()
		self:hitCheck()
	end)
	local seqAction = ffa.seq(self.fields.Com_Bow:getPosition())
	self.fields.Com_Arrow:runAction(seqAction)
	self.fields.Com_Bow:setPlaySettings(5, 14, 1, -1, function()
		self.canTouch = true
	end)
end
function SneakSnipeGamePanel:hitCheck()
	if self.sceneView.hitTestEX == nil then
		function self.sceneView.hitTestEX(obj, pos)
			for k, v in pairs(self.enemyTable) do
				local tmppos = v:convertToNodeSpace(cc.p(pos.x, display.height - pos.y))
				local boundRect = cc.rect(0, 0, v:getContentSize().width, v:getContentSize().height)
				if cc.rectContainsPoint(boundRect, tmppos) then
					return v
				end
			end
			return nil
		end
	end
	local isToFight = false
	for i, v in ipairs(self.enemyTable) do
		local targetPos = self:convertToNodeSpace(cc.pMul(v:convertToWorldSpace(cc.p(0, 0)), self:getScale()))
		targetPos = cc.pMul(targetPos, 1 / self:getScale())
		local distanceX = math.abs(targetPos.x - self.touchPoint.x)
		local distanceY = math.abs(targetPos.y - self.touchPoint.y)
		local axisPoint = cc.p(targetPos.x + enemyHalfSize.width, targetPos.y + enemyHalfSize.height)
		local c = cc.p(enemyHalfSize.width, enemyHalfSize.height)
		local p = cc.p(self.touchPoint.x - axisPoint.x, self.touchPoint.y - axisPoint.y)
		_ENV = self.touchPoint.x - axisPoint.x
		;(self.touchPoint.x - axisPoint.x).x = math.abs(p.x + c.x)
		local _ENV, (self.touchPoint.x - axisPoint.x).y, ctop = math.abs(p.y + c.y), math.abs(p.y + c.y), self.touchPoint.x - axisPoint.x
		math.abs(p.y + c.y).x = math.max(ctop.x - c.x, 0)
		local math.abs(p.y + c.y).y, d = math.max(ctop.y - c.y, 0), math.abs(p.y + c.y)
		local target
		if G_IS_UNITY then
			target = self.sceneView:hitTestEX(self:convertToWorldSpace(cc.p(self.touchPoint.x, self.touchPoint.y + offsetIphoneX)))
		else
			target = self.sceneView:hitTest(self:convertToWorldSpace(cc.p(self.touchPoint.x, self.touchPoint.y + offsetIphoneX)), display.getRunningScene():getDefaultCamera())
		end
		if target then
			print("hittest", target:getName())
		end
		if target and target == v then
			v:toDead()
			self:recyleEnemy(i)
			isToFight = true
			break
		elseif cc.pDot(d, d) <= fightDistance then
			isToFight = true
		end
	end
	if isToFight then
		self:changeToFightModule()
	end
	self:checkEnemyLeft()
end
function SneakSnipeGamePanel:checkEnemyLeft()
	if self.isGameOver then
		return
	end
	if not next(self.enemyTable) then
		if self.sceneConfig[self.sceneType][self.level + 1] then
			self:nextLevel()
		else
			self.isGameOver = true
			_UPVALUE1_ = nil
			;(nil)[1] = ffa.delay(1)
			;(nil)[2] = ffa.callFunc(function()
				self:showResult(true)
			end)
			;(nil)[3] = ffa.callFunc(function()
				self:showResult(true)
			end)
			self:runAction(ffa.seq(nil))
		end
	end
end
function SneakSnipeGamePanel:nextLevel()
	self.level = self.level + 1
	self:getNewEnemyTable()
	if self.config.needFade then
		_UPVALUE3_ = nil
		;(nil)[1] = ffa.delay(1)
		;(nil)[2] = ffa.fadeTo(0.5, 1)
		;(nil)[3] = ffa.callFunc(function()
			self.sceneView:setPosition(self.config.pos)
		end)
		;(nil)[4] = ffa.fadeTo(0.5, 0)
		;(nil)[5] = ffa.fadeTo(0.5, 0)
		;(nil)[6] = ffa.fadeTo(0.5, 0)
		self.fields.frame_Black:runAction(ffa.seq(nil))
	else
		_UPVALUE1_ = ffa.seq(nil)
		ffa.seq(nil)[1] = ffa.delay(1)
		ffa.seq(nil)[2] = ffa.moveTo(0.5, self.config.pos.x, self.config.pos.y)
		ffa.seq(nil)[3] = ffa.moveTo(0.5, self.config.pos.x, self.config.pos.y)
		ffa.seq(nil)[4] = ffa.moveTo(0.5, self.config.pos.x, self.config.pos.y)
		ffa.seq(nil)[5] = ffa.moveTo(0.5, self.config.pos.x, self.config.pos.y)
		ffa.seq(nil)[6] = ffa.moveTo(0.5, self.config.pos.x, self.config.pos.y)
		self.sceneView:runAction(ffa.seq(ffa.seq(nil)))
	end
end
function SneakSnipeGamePanel:subBlood()
	if self.isGameOver then
		return
	end
	SoraDPlaySound("hideSnip", "snipe_injured")
	local index = math.floor((maxBlood - self.blood) / 2)
	self.blood = self.blood - 1
	if self.blood <= 0 then
		self.isGameOver = true
		for i, v in ipairs(self.enemyTable) do
			v:changToFinish()
		end
	end
	self.fields.Com_warn:setVisible(true)
	self.fields.Com_warn:getTransition("t0"):play(1, 0.5, function()
		local target = self.fields["Heart_" .. index]:getChildByName("n1")
		target:setFillAmount(target:getFillAmount() - 0.5)
		if self.blood <= 0 then
			self:onGameFinish()
		end
	end)
end
function SneakSnipeGamePanel:changeToFightModule()
	for i, v in ipairs(self.enemyTable) do
		v:toFight(math.random(0, 100) / 100)
	end
end
function SneakSnipeGamePanel:showBullsEye(touchPoint, bResetAction)
	local angle = math.deg(math.atan((self.touchPoint.x - self:getWidth() / 2) / math.max(0, self:getHeight() - self.touchPoint.y)))
	self.fields.Com_Bow:setRotation(angle)
	self.fields.Com_Arrow:setAnchorPoint(cc.p(0.5, 0))
	self.fields.Com_Arrow:setRotation(angle)
	self.fields.sp_Bulleye:setPosition(touchPoint)
	self.fields.sp_Bulleye:setVisible(true)
	if bResetAction then
		self.fields.sp_Bulleye:stopAllActions()
		self.fields.sp_Bulleye:setScale(1.0)
		_UPVALUE3_ = self.fields.sp_Bulleye
		self.fields.sp_Bulleye[1] = ffa.scaleTo(0.3, 1.2)
		self.fields.sp_Bulleye[2] = ffa.scaleTo(0.3, 1.0)
		self.fields.sp_Bulleye[3] = ffa.scaleTo(0.3, 0.9)
		self.fields.sp_Bulleye[4] = ffa.scaleTo(0.3, 1.0)
		self.fields.sp_Bulleye[5] = ffa.scaleTo(0.3, 1.0)
		self.fields.sp_Bulleye[6] = ffa.scaleTo(0.3, 1.0)
		local action = ffa.seq(self.fields.sp_Bulleye)
		local repeatAction = ffa.repeatForever(action)
		self.fields.sp_Bulleye:runAction(repeatAction)
	end
end
function SneakSnipeGamePanel:showResult(isWin)
	if self.isShowedResult then
		return
	end
	self.isShowedResult = true
	self.isWin = isWin
	if self.proxy.param and self.proxy.param.resultCallback then
		self.proxy.param.resultCallback(isWin)
	else
		_ENV = nil
		;(nil).isWin = isWin
		;(nil).gameType = 5
		uiManager:show("SneakSnipeResult", nil)
	end
end
function SneakSnipeGamePanel:onTouchStart(eventContext)
	print("=======SneakSnipeGamePanel:onTouchStart")
	if not self.canTouch or self.isGameOver then
		return
	end
	self.lagong = SoraDPlaySound("hideSnip", "snipe_attack01")
	self.touchPoint = cc.pMul(eventContext:getInput():getPosition(), 1 / self:getScale())
	self.isTouchBegin = true
	self.touchPoint = cc.p(self.touchPoint.x, self.touchPoint.y - offsetIphoneX)
	print("self.touchPoint", self.touchPoint.x, self.touchPoint.y, realHeight, display.height)
	self.anchorPoint = cc.p(self.touchPoint.x / 640, (realHeight - self.touchPoint.y) / realHeight)
	self.fields.Bg:setAnchorPoint(self.anchorPoint)
	self.fields.Bg:setPosition(cc.p(self.touchPoint.x, self.touchPoint.y))
	self.fields.Bg:runAction(ffa.scaleTo(0.2, scaleView))
	self:showBullsEye(self.touchPoint, true)
	self.fields.Com_Bow:setPlaySettings(0, 5, 1, -1)
	self.fields.Com_Bow:setPlaying(true)
end
function SneakSnipeGamePanel:onTouchMove(eventContext)
	if not (self.isTouchBegin and self.canTouch) or self.isGameOver then
		return
	end
	print("=======SneakSnipeGamePanel:onTouchMove")
	local touchPoint = eventContext:getInput():getPosition()
	local distance = cc.pGetDistance(self.touchPoint, touchPoint)
	self.touchPoint = cc.p(math.min(display.width, math.max(touchPoint.x, 0)), math.min(realHeight - 46, math.max(touchPoint.y - offsetIphoneX, 0)))
	self:showBullsEye(self.touchPoint)
	print("self.touchPoint", self.touchPoint.x, self.touchPoint.y)
end
function SneakSnipeGamePanel:onTouchEnd(eventContext)
	if not (self.isTouchBegin and self.canTouch) or self.isGameOver then
		return
	end
	print("=======SneakSnipeGamePanel:onTouchEnd")
	SoraDPlayStopEffect(self.lagong)
	SoraDPlaySound("hideSnip", "snipe_attack02")
	self.isTouchBegin = false
	self.canTouch = false
	self.fields.sp_Bulleye:setVisible(false)
	local centerPos = self.fields.Bg:getPosition()
	print("(self.touchPoint.x - centerPos.x)", self.touchPoint.x, centerPos.x)
	self.touchPoint = cc.p((self.touchPoint.x - centerPos.x) / scaleView + centerPos.x, (self.touchPoint.y - centerPos.y) / scaleView + centerPos.y)
	local distance = cc.pGetDistance(self.touchPoint, self.fields.Com_Bow:getPosition())
	self.fields.Bg:stopAllActions()
	self.fields.Bg:runAction(ffa.scaleTo(distance / arrowSpeed, 1))
	self:shotArrow()
	if self.fingerEffect then
		self.fingerEffect:setVisible(false)
	end
end
function SneakSnipeGamePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("exitic_pavillion_text_0103")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function SneakSnipeGamePanel:onClickClose()
	self:pause()
	SoraDShowMsgBoxNew(i18n("exitic_pavillion_text_0118"), nil, i18n("common_text_185"), function(exitType)
		if tolua.isnull() then
			return
		end
		if exitType == MSGBOX_CALLBACK_YES then
			if self.isGameOver then
				return
			end
			_ENV = nil
			;(nil).msg = "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE"
			;(nil).isWin = false
			;(nil).gameType = 5
			SoraDSendMessage(nil)
		elseif self.resume then
			self:resume()
		end
	end)
end
function SneakSnipeGamePanel:recyleEnemy(i)
	local item = table.remove(self.enemyTable, i)
end
function SneakSnipeGamePanel:pause()
	self.isPause = true
	_UPVALUE2_ = nil
	;(nil)[1] = self.fields.node_start
	;(nil)[2] = self.fields.Com_Arrow
	for i, v in ipairs(nil) do
		self:getActionManager():pauseTarget(v)
	end
	self.fields.Com_warn:getTransition("t0"):setPaused(true)
	for i, v in ipairs(self.enemyTable) do
		self:getActionManager():pauseTarget(v)
		for i, child in ipairs(v:getChildren()) do
			if child.setPlaying then
				child:setPlaying(false)
			end
		end
	end
end
function SneakSnipeGamePanel:resume()
	self.isPause = false
	_UPVALUE2_ = nil
	;(nil)[1] = self.fields.node_start
	;(nil)[2] = self.fields.Com_Arrow
	for i, v in ipairs(nil) do
		self:getActionManager():resumeTarget(v)
	end
	self.fields.Com_warn:getTransition("t0"):setPaused(true)
	for i, v in ipairs(self.enemyTable) do
		self:getActionManager():resumeTarget(v)
		for i, child in ipairs(v:getChildren()) do
			if child.setPlaying then
				child:setPlaying(true)
			end
		end
	end
end
return SneakSnipeGamePanel
