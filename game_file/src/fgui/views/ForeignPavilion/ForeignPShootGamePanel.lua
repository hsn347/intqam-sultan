local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ForeignPShootGamePanel = class("ForeignPShootGamePanel", baseFguiPanel)
local longEventTime = 0.4
local spaceTime = 0.1
local longActTag = 100
function ForeignPShootGamePanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("ForeignPShootGamePanel:ctor", self.viewName)
end
function ForeignPShootGamePanel:getPackageList()
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[6] = self._packageList, "fonts"
	end
	return self._packageList
end
function ForeignPShootGamePanel:onInit()
	print("=======ForeignPShootGamePanel:onInit")
	self.fields.com_title:initData(i18n("exitic_pavillion_text_0125"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.orginPos = self.fields.target:getPosition()
	self.isShootStart = false
	self.fields.btn_hide:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onTouchStart))
	self:addEventListener(fgui.UIEventType.TouchBegin, function(context)
		context:CaptureTouch()
	end)
	self:addEventListener(fgui.UIEventType.TouchMove, handler(self, self.onTouchMove))
	self.fields.btn_hide:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onTouchEnd))
	self.startTouchId = -1
	self.bulletCount = 3
	self.maxCount = 3
	self.point = 0
	self.fields.text_bullet:setString(i18n("exitic_pavillion_text_0105"))
	self.fields.text_point:setString(i18n("exitic_pavillion_text_0106"))
	self.fields.text_tip:setString(i18n("exitic_pavillion_text_0145"))
	self.fields.text_bullet_num:setString(self.bulletCount .. "/" .. self.maxCount)
	self.fields.text_point_num:setString(0)
end
function ForeignPShootGamePanel:onShow()
	print("=======ForeignPShootGamePanel:onShow")
	_ENV = nil
	;(nil).callback = handler(self, self.onGameStart)
	self.fields.node_start:startGame(nil)
	self.fields.target:stopAllActions()
	_UPVALUE1_ = self.fields.target
	self.fields.target[1] = ffa.moveBy(4, cc.p(250, 0))
	self.fields.target[2] = ffa.moveBy(4, cc.p(-250, 0))
	self.fields.target[3] = ffa.moveBy(4, cc.p(-250, 0))
	self.fields.target[4] = ffa.moveBy(4, cc.p(-250, 0))
	self.fields.target[5] = ffa.moveBy(4, cc.p(-250, 0))
	self.fields.target[6] = ffa.moveBy(4, cc.p(-250, 0))
	local seq = ffa.seq(self.fields.target)
	self.fields.target:setPositionX(self.orginPos.x - 100)
	self.fields.target:runAction(ffa.repeatForever(ffa.seq(seq)))
	self.fields.shootBg:gameStart()
end
function ForeignPShootGamePanel:onHide()
	print("=======ForeignPShootGamePanel:onHide")
end
function ForeignPShootGamePanel:onDispose()
	print("=======ForeignPShootGamePanel:onDispose")
end
function ForeignPShootGamePanel:onTouchStart(eventContext)
	print("=======ForeignPShootGamePanel:onTouchStart")
	if self.bulletCount <= 0 then
		return
	end
	if self.startTouchId ~= -1 then
		return
	end
	self.startTouchId = eventContext:getInput():getTouchId()
	self:runLongPress(longEventTime)
	self.touchBeganPoint = eventContext:getInput():getPosition()
	self.lastTouchPoint = self.touchBeganPoint
	self.isMove = false
end
function ForeignPShootGamePanel:onTouchMove(eventContext)
	if self.touchBeganPoint == nil then
		return
	end
	if self.startTouchId ~= eventContext:getInput():getTouchId() then
		return
	end
	print("=======ForeignPShootGamePanel:onTouchMove")
	self.touchmovePoint = eventContext:getInput():getPosition()
	self.isMove = true
	if self.isMove and self.isShootStart then
		self.fields.shootBg:setData(self.lastTouchPoint, self.touchmovePoint)
	end
	self.lastTouchPoint = self.touchmovePoint
end
function ForeignPShootGamePanel:onTouchEnd(eventContext)
	self.startTouchId = -1
	if self.isLong then
		self:setIsShootStart(false)
		SoraDPlaySound("foreignPavilion", "exotic_archery")
		self.fields.focus:setVisible(false)
		self.fields.focus2:setVisible(true)
		self.fields.focus2:clearEffect()
		self.fields.focus2:setEffectPath("shejian.usm", false)
		self.fields.focus2:setCompleteCallback(function()
			self.fields.focus2:setVisible(false)
		end)
		local targetPos = self.fields.shootBg.fields.bg:getTargetPos()
		local focusPos = self:getFocusPos()
		local distance = cc.pGetDistance(targetPos, focusPos)
		local point = math.ceil((95 - distance) / 95 * 10)
		point = point < 0 and 0 or point
		self:showGetPoint(point)
		self.isLong = false
	end
	self:stopActionByTag(longActTag)
	self.touchBeganPoint = nil
end
function ForeignPShootGamePanel:runLongPress(dt)
	self.isLong = false
	self.stop = true
	longActTag = nil
	;(nil)[1] = ffa.delay(dt)
	;(nil)[2] = ffa.callFunc(function()
		self.isLong = true
		self:setIsShootStart(true)
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.isLong = true
		self:setIsShootStart(true)
	end)
	local seqLong = ffa.seq(nil)
	seqLong:setTag(longActTag)
	self:runAction(seqLong)
end
function ForeignPShootGamePanel:showGetPoint(point)
	self.bulletCount = self.bulletCount - 1
	self.fields.text_bullet_num:setString(self.bulletCount .. "/" .. self.maxCount)
	self.point = self.point + point
	self.fields.text_point_num:setString(self.point)
	self.fields.point:addPoint(point)
	if self.bulletCount == 0 then
		local isWin = self.point >= 20
		self:showResult(isWin)
	end
end
function ForeignPShootGamePanel:showResult(isWin)
	if self.isShowedResult then
		return
	end
	self.isShowedResult = true
	self.fields.node_time:removeTime()
	if self.msgPanel then
		self.msgPanel:removeFromParent()
	end
	self.msgPanel = nil
	if self.proxy.param and self.proxy.param.resultCallback then
		self.proxy.param.resultCallback(isWin)
	else
		_ENV = nil
		;(nil).type = 3
		;(nil).isWin = isWin
		;(nil).isInStory = false
		uiManager:show("ForeignPsettlement", nil)
	end
end
function ForeignPShootGamePanel:setIsShootStart(isStart)
	self.isShootStart = isStart
	self.fields.shootBg:setShow(isStart)
	self.controllers.c1:setSelectedIndex(isStart and 0 or 1)
	if isStart then
		self.fields.focus:setVisible(true)
		self.fields.focus:clearEffect()
		self.fields.focus:setEffectPath("lagong.usm", false)
		self.fields.focus:setCompleteCallback(function()
			self.fields.focus.effect:pause()
		end)
	end
end
function ForeignPShootGamePanel:getFocusPos()
	local pos = cc.p(self.fields.focus:displayObject():getPosition())
	pos = self.fields.focus:displayObject():getParent():convertToWorldSpace(pos)
	return pos
end
function ForeignPShootGamePanel:onGameStart()
	self.fields.node_time:startGame(30, handler(self, self.onGameFinish))
	self:setIsShootStart(false)
end
function ForeignPShootGamePanel:onGameFinish()
	self.isGameOver = true
	self:showResult(self.point >= 20)
end
function ForeignPShootGamePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("exitic_pavillion_text_0103")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function ForeignPShootGamePanel:onClickClose()
	self.msgPanel = SoraDShowMsgBoxNew(i18n("exitic_pavillion_text_0118"), nil, i18n("common_text_185"), function(exitType)
		self.msgPanel = nil
		if exitType == MSGBOX_CALLBACK_YES then
			if self.isGameOver then
				return
			end
			self = nil
			;(nil).msg = "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE"
			;(nil).isWin = false
			;(nil).gameType = 3
			;(nil).isInStory = false
			SoraDSendMessage(nil)
		end
	end)
end
return ForeignPShootGamePanel
