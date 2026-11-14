local baseComponent = require("fgui.base.baseComponent")
local Com_9001665_game = fgui.extension_class(fgui.GComponent, baseComponent)
local constantRead = include("constantRead")
local activity_9001665_Read = include("activity_9001665_Read")
local activity_9001665_Ctrl = SoraDGetCtrl("activity_9001665_Ctrl")
fgui.register_extension("ui://Activity_9001665/Com_9001665_game", Com_9001665_game)
local gameRectHeight = 460
local focusHeight = 100
local successTime = 1000
local failProgress = 100
local initialProgress = 100
local moveProbability = 400
local sprintProbability = 600
local moveDistance = 3
local moveSpeed = 1
local sprintSpeed = 5
function Com_9001665_game:onInit()
	self.fields.Com_bait:setTitle(i18n("fishingmaster_text_19"))
	self.fields.Com_bait:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onPullTouchStart))
	self.fields.Com_bait:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onPullTouchEnd))
	self.isCanCheat = device.platform == "mac" or userSDKManager.isBeta() or userSDKManager.isGameDevelop()
	self.controllers.c1:setSelectedIndex(self.isCanCheat and 1 or 0)
	if self.isCanCheat then
		self.fields.text_cheat:setString("失败的进度,初始进度,加速概率,游动距离,游动速度,加速速度,成功时间（1000,100,200,600,3,1,5,1000）")
		self.fields.cheat:setTitle("测试重新开始")
		self.fields.cheat:addClickEventListener(function()
			self:startGame(self.curHard, true)
		end)
	end
end
function Com_9001665_game:setTimePull(time_pull)
	self.time_pull = time_pull
end
function Com_9001665_game:onShow()
	self.timer = SoradCreateTimer(self, handler(self, self.updateUI), true)
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_LAST_FINISH", handler(self, self.msgGuideEnd))
end
function Com_9001665_game:msgGuideEnd()
	_UPVALUE0_ = nil
	;(nil).callback = function()
		self.isGameStart = true
	end
	self.time_pull:startGame(nil)
end
function Com_9001665_game:setResultCallback(callback)
	self.resultCallback = callback
end
function Com_9001665_game:startGame(hard, isCheat)
	self.curHard = hard
	self.pointCfg = activity_9001665_Read.getPointCfg(hard)
	if self.isCanCheat then
		local cheatStr = self.fields.input_cheat:getText()
		dump(cheatStr, "cheatStr")
		local isInCheat = false
		if cheatStr ~= "" and isCheat then
			local values = string.split(cheatStr, ",")
			if #values == 7 then
				isInCheat = true
			end
		end
		if not isInCheat then
			cheatStr = failProgress .. "," .. initialProgress .. "," .. sprintProbability .. "," .. moveDistance .. "," .. moveSpeed .. "," .. sprintSpeed .. "," .. successTime
			self.fields.input_cheat:setText(cheatStr)
		end
		self.fields.input_cheat:setText(cheatStr)
	end
	self.fields.focus:setPositionY(gameRectHeight - focusHeight)
	self.fields.fish:setPositionY(gameRectHeight - focusHeight / 2)
	self.isLastFrameHit = false
	self.isPulling = false
	self.curV = 0
	self.passTime = 0
	self.curPercent = initialProgress / 10
	self.fishUpdateTime = 0
	self.curFishMoveLength = moveDistance * 30
	self.isFirstFrame = true
	self:checkIsHit(0)
	if activity_9001665_Ctrl:getIsNeedGuide() then
		self.time_pull:setVisible(false)
		activity_9001665_Read = self.time_pull
		self.time_pull.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		self.time_pull.step = 9991601
		SoraDSendMessage(self.time_pull)
	else
		activity_9001665_Read = false
		;(false).callback = function()
			self.isGameStart = true
		end
		self.time_pull:startGame(false)
	end
end
function Com_9001665_game:updateUI(dt)
	if not self.isGameStart then
		return
	end
	self.passTime = self.passTime + dt
	if self.isCanCheat then
		self.fields.text_useTime:setString("时间：" .. math.floor(self.passTime * 1000) .. "ms")
	end
	self:updateFish(dt)
	self:updateFocus(dt)
	self:checkIsHit(dt)
	self.isFirstFrame = false
end
function Com_9001665_game:updateFocus(dt)
	local va = self.isPulling and -200 or 200
	if self.isPulling and self.curV > 0 then
		self.curV = 0
	end
	local nowY = self.fields.focus:getPositionY()
	self.curV = self.curV + va * dt
	if nowY >= gameRectHeight - focusHeight and self.curV >= 0 then
		self.curV = 0
		nowY = gameRectHeight - focusHeight
	elseif nowY <= 0 and self.curV <= 0 then
		self.curV = 0
		nowY = 0
	else
		nowY = nowY + self.curV * dt
	end
	self.fields.focus:setPositionY(nowY)
end
function Com_9001665_game:updateFish(dt)
	if self.curFishMoveLength >= moveDistance * 30 then
		local rvalue = not self.isLastFrameHit and 1000 or math.random(0, 1000)
		local v = 0
		if self.isFirstFrame or rvalue <= sprintProbability then
			v = sprintSpeed * 30
		else
			v = moveSpeed * 30
		end
		local random = self.isFirstFrame and 0 or math.random(0, 1000)
		self.curFishV = 500 < random and v or -v
		self.curFishMoveLength = 0
	end
	local nowY = self.fields.fish:getPositionY()
	if nowY >= gameRectHeight - 30 and 0 <= self.curFishV then
		self.curFishV = -self.curFishV
		nowY = gameRectHeight - 30
	elseif nowY <= 30 and 0 >= self.curFishV then
		self.curFishV = -self.curFishV
		nowY = 30
	else
		local addLength = self.curFishV * dt
		nowY = nowY + addLength
		self.curFishMoveLength = self.curFishMoveLength + math.abs(addLength)
	end
	self.fields.fish:setPositionY(nowY)
end
function Com_9001665_game:checkIsHit(dt)
	local focusPosY = self.fields.focus:getPositionY()
	local fishPosY = self.fields.fish:getPositionY()
	local isHit = focusPosY <= fishPosY and fishPosY <= focusPosY + focusHeight
	local curURL = isHit and "frame_9001665_greenbar.png" or "frame_9001665_yellownbar.png"
	self.fields.focus:setURL(curURL)
	if self.isLastFrameHit and isHit then
		self.curPercent = math.max(self.curPercent, 0)
		self.curPercent = self.curPercent + dt * successTime / 100
	elseif not isHit then
		self.curPercent = self.curPercent - dt * successTime / 100
	end
	self.isLastFrameHit = isHit
	if self.curPercent >= 100 then
		self:playWin()
	elseif self.curPercent <= -failProgress / 10 then
		self:playLose()
	end
	local showPercent = math.clamp(self.curPercent, 0, 100)
	self.fields.progress:setPercent(showPercent / 100)
	self.fields.text_percent:setString(string.format("%.1f%%", showPercent))
	if self.curPercent >= 0 and not self.fields.fish.isInAction and self.fields.fish:getAlpha() < 1 then
		self.fields.fish:stopAllActions()
		self.fields.fish:runAction(ffa.seq(ffa.fadeIn(0.1), ffa.callFunc(function()
			self.fields.fish.isInAction = false
		end)))
		self.fields.fish.isInAction = true
	elseif self.curPercent < 0 then
		self.fields.fish:stopAllActions()
		self.fields.fish.isInAction = false
		print(0.5 + (1 + self.curPercent / failProgress) * 0.5, "0.5 + (1+self.curPercent/failProgress)*0.5")
		self.fields.fish:setAlpha(0.4 + (1 + self.curPercent / (failProgress / 10)) * 0.6)
	end
end
function Com_9001665_game:playWin()
	self.isGameStart = false
	local difficultPoint = self.pointCfg.difficultPoint
	local operatePoint = self.pointCfg.operatePoint
	operatePoint = math.max(0, operatePoint - activity_9001665_Read.getOperatePoint(math.floor(self.passTime * 100)))
	if self.resultCallback then
		self.resultCallback(true, self.curHard, self.passTime, difficultPoint, operatePoint)
	end
end
function Com_9001665_game:playLose()
	self.isGameStart = false
	if self.resultCallback then
		self.resultCallback(false)
	end
end
function Com_9001665_game:finishGame()
	self.isGameStart = false
end
function Com_9001665_game:onPullTouchStart()
	self.isPulling = true
	self:updateUI(0)
end
function Com_9001665_game:onPullTouchEnd()
	self.isPulling = false
	self:updateUI(0)
end
return Com_9001665_game
