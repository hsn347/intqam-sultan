local activity_9001735_Read = include("activity_9001735_Read")
local activity_9001735_Ctrl = SoraDGetCtrl("activity_9001735_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local guideCtrl = SoraDGetCtrl("guideCtrl")
local constantRead = include("constantRead")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001735_MainPanel = class("Activity_9001735_MainPanel", baseFguiPanel)
function Activity_9001735_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001735_MainPanel.super.ctor(self, ...)
	print("Activity_9001735_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.FREE_KICK_MASTER_ACTIVITY
	self.itemID = constantRead.getConstValue("FREEKICK_MASTER_GAME_COST", 882601)
	self.ballTime = constantRead.getConstValue("FREEKICK_MASTER_FOOTBALL_MOVE_TIME", 1)
	self.keeperTime = constantRead.getConstValue("FREEKICK_MASTER_OBSTACLE_MOVE_SPEED", 0.8)
	self.ballChargeMinTime = 0.4
end
function Activity_9001735_MainPanel:onInit()
	print("=======Activity_9001735_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.mv_goal:setAllFrameName("dh_jiesuosjb_%.2d.png", 1)
	self.fields.Button_game:setTitle(i18n("common_text_1139"))
	self.fields.Button_game:addClickListener(handler(self, self.onClick_Button_game))
	self.fields.Button_reward:setTitle(i18n("decrypt_text_03"))
	self.fields.Button_reward:addClickListener(handler(self, self.onClick_Button_reward))
	self.fields.Button_rank:setTitle(i18n("common_text_851"))
	self.fields.Button_rank:addClickListener(handler(self, self.onClick_Button_rank))
	self.fields.Button_gift:setTitle(i18n("snow_competition_text_11"))
	self.fields.Button_gift:addClickListener(handler(self, self.onClick_Button_gift))
	self.fields.Com_boxList:setBarColor(3)
	self.fields.Com_have:setAddCallBack(handler(self, self.onClick_Button_gift))
	self.fields.Lab_tip:setString(i18n("freekick_master_text_09"))
	self.fields.Text_tip:setString(i18n("freekick_master_text_16"))
	self.fields.Button_ball:getChild("mv_xz"):setAllFrameName("2026ryqdashi_%.2d.png", 1)
	self.fields.Button_ball:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onBallTouchBegin))
	self.fields.Button_ball:addEventListener(fgui.UIEventType.TouchMove, handler(self, self.onBallTouchMove))
	self.fields.Button_ball:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onBallTouchEnd))
	self.fields.Button_ball:addLongPressListener(handler(self, self.onClick_Button_ball_longPress), self.ballChargeMinTime)
	self.fields.Button_ball:setTouchEnabled(false)
	self.fields.door:addClickListener(handler(self, self.onClick_Button_door))
	self.fields.aim:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onAimTouchBegin))
	self.fields.aim:addEventListener(fgui.UIEventType.TouchMove, handler(self, self.onAimTouchMove))
end
function Activity_9001735_MainPanel:onAimTouchBegin(context)
	context:captureTouch()
end
function Activity_9001735_MainPanel:clampAimInDoor(localPos)
	local door = self.fields.door
	localPos.x = math.max(door:getPositionX(), math.min(localPos.x, door:getPositionX() + door:getWidth()))
	localPos.y = math.max(door:getPositionY(), math.min(localPos.y, door:getPositionY() + door:getHeight()))
	return localPos
end
function Activity_9001735_MainPanel:setAimFromInput(globalPos)
	self.fields.aim:setPosition(self:clampAimInDoor(self:globalToLocal(globalPos)))
end
function Activity_9001735_MainPanel:onAimTouchMove(context)
	self:setAimFromInput(context:getInput():getPosition())
end
function Activity_9001735_MainPanel:keeperMove()
	self.fields.keeper:stopAllActions()
	local doorW = self.fields.door:getWidth()
	local halfRange = doorW / 2
	local dir = math.random(1, 2) == 1 and 1 or -1
	self.fields.keeper:setPositionX(self:getWidth() / 2)
	_UPVALUE1_ = self
	_UPVALUE1_ = self.fields.keeper:getPositionY()
	self.fields.keeper:getPositionY()[1] = ffa.moveTo(self.keeperTime, self:getWidth() / 2 - halfRange * dir, self.fields.keeper:getPositionY())
	self.fields.keeper:getPositionY()[2] = ffa.moveTo(self.keeperTime, self:getWidth() / 2 + halfRange * dir, self.fields.keeper:getPositionY())
	self.fields.keeper:getPositionY()[3] = ffa.moveTo(self.keeperTime, self:getWidth() / 2 + halfRange * dir, self.fields.keeper:getPositionY())
	self.fields.keeper:getPositionY()[4] = ffa.moveTo(self.keeperTime, self:getWidth() / 2 + halfRange * dir, self.fields.keeper:getPositionY())
	self.fields.keeper:getPositionY()[5] = ffa.moveTo(self.keeperTime, self:getWidth() / 2 + halfRange * dir, self.fields.keeper:getPositionY())
	self.fields.keeper:getPositionY()[6] = ffa.moveTo(self.keeperTime, self:getWidth() / 2 + halfRange * dir, self.fields.keeper:getPositionY())
	self[1] = ffa.moveTo(self.keeperTime / 2, self:getWidth() / 2 + halfRange * dir, self.fields.keeper:getPositionY())
	self[2] = ffa.repeatForever(ffa.seq(self.fields.keeper:getPositionY()))
	self[3] = ffa.repeatForever(ffa.seq(self.fields.keeper:getPositionY()))
	self[4] = ffa.repeatForever(ffa.seq(self.fields.keeper:getPositionY()))
	self[5] = ffa.repeatForever(ffa.seq(self.fields.keeper:getPositionY()))
	self[6] = ffa.repeatForever(ffa.seq(self.fields.keeper:getPositionY()))
	self[7] = ffa.repeatForever(ffa.seq(self.fields.keeper:getPositionY()))
	self[8] = ffa.repeatForever(ffa.seq(self.fields.keeper:getPositionY()))
	self[9] = ffa.repeatForever(ffa.seq(self.fields.keeper:getPositionY()))
	self[10] = ffa.repeatForever(ffa.seq(self.fields.keeper:getPositionY()))
	self.fields.keeper:runAction(ffa.seq(self))
end
function Activity_9001735_MainPanel:onClick_Button_door(context)
	SoraDPlaySound()
	self:setAimFromInput(context:getInput():getPosition())
end
function Activity_9001735_MainPanel:isGlobalPosInBall(globalPos)
	local ball = self.fields.Button_ball
	if not ball or not ball:isVisible() then
		return false
	end
	local margin = 12
	local left, right, top, bottom = self:getGlobalAABB(ball)
	_UPVALUE0_ = nil
	;(nil).x = left - 30
	;(nil).y = top - 30
	;(nil).width = 60
	local (nil).height, rectBall = 60, nil
	return globalPos.x >= rectBall.x - margin and globalPos.x <= rectBall.x + rectBall.width + margin and globalPos.y >= rectBall.y - margin and globalPos.y <= rectBall.y + rectBall.height + margin
end
function Activity_9001735_MainPanel:cancelBallCharge(keepPower)
	self.isTouch = false
	self.isCharging = false
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	self.fields.Button_ball:getController("button"):setSelectedIndex(0)
	self.touchTime = 0
	if not keepPower then
		self.realBallTime = 0.1
		self.fields.Slider_power:getChild("power"):setFillAmount(0)
	end
end
function Activity_9001735_MainPanel:onBallTouchBegin(context)
	self.isOut = false
	self.isCharging = false
	self.isTouch = false
end
function Activity_9001735_MainPanel:onBallTouchMove(context)
	if not self.isTouch then
		return
	end
	if not self:isGlobalPosInBall(context:getInput():getPosition()) then
		self.isOut = true
		self:cancelBallCharge()
	else
		self.isOut = false
	end
end
function Activity_9001735_MainPanel:onBallTouchEnd(context)
	if self.isCharging and not self.isOut then
		self:onClick_Button_ball_click(context)
	elseif not self.isOut then
		SoraDShowMsgTip(i18n("freekick_master_text_10"))
		self:cancelBallCharge()
	else
		self:cancelBallCharge()
	end
end
function Activity_9001735_MainPanel:onClick_Button_ball_click(context)
	if self.isOut then
		return
	end
	self:cancelBallCharge(true)
	self.fields.football_shadow:setVisible(false)
	local aimPos = self.fields.aim:getPosition()
	local ballPos = self.fields.Button_ball:getPosition()
	local dx = aimPos.x - ballPos.x
	local dy = aimPos.y - ballPos.y
	activity_9001735_Ctrl = nil
	;(nil)[1] = ffa.moveBy(1 - self.realBallTime, dx, dy)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.keeper:stopAllActions()
		local isCollision = self:checkBallKeeperCollision()
		print("isCollision==============", isCollision)
		if not isCollision then
			self.transitions.win:play(function()
				activity_9001735_Ctrl:reqShoot(not isCollision)
			end)
		else
			self.transitions.lose:play(function()
				activity_9001735_Ctrl:reqShoot(not isCollision)
			end)
		end
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.keeper:stopAllActions()
		local isCollision = self:checkBallKeeperCollision()
		print("isCollision==============", isCollision)
		if not isCollision then
			self.transitions.win:play(function()
				activity_9001735_Ctrl:reqShoot(not isCollision)
			end)
		else
			self.transitions.lose:play(function()
				activity_9001735_Ctrl:reqShoot(not isCollision)
			end)
		end
	end)
	;(nil)[4] = ffa.callFunc(function()
		self.fields.keeper:stopAllActions()
		local isCollision = self:checkBallKeeperCollision()
		print("isCollision==============", isCollision)
		if not isCollision then
			self.transitions.win:play(function()
				activity_9001735_Ctrl:reqShoot(not isCollision)
			end)
		else
			self.transitions.lose:play(function()
				activity_9001735_Ctrl:reqShoot(not isCollision)
			end)
		end
	end)
	self.fields.Button_ball:runAction(ffa.seq(nil))
end
function Activity_9001735_MainPanel:getGlobalAABB(obj)
	local w = obj:getWidth() * obj:getScaleX()
	local h = obj:getHeight() * obj:getScaleY()
	local p0 = obj:localToGlobal(cc.p(0, 0))
	local p1 = obj:localToGlobal(cc.p(w, h))
	local left = math.min(p0.x, p1.x)
	local right = math.max(p0.x, p1.x)
	local top = math.min(p0.y, p1.y)
	local bottom = math.max(p0.y, p1.y)
	return left, right, top, bottom
end
function Activity_9001735_MainPanel:checkBallKeeperCollision()
	local ball = self.fields.Button_ball
	local keeper = self.fields.keeper
	if not (ball and keeper and ball:isVisible()) or not keeper:isVisible() then
		return false
	end
	local l1, _, t1, _ = self:getGlobalAABB(ball)
	_ENV = nil
	;(nil).x = l1 - 30
	;(nil).y = t1 - 30
	;(nil).width = 60
	local (nil).height, rectBall = 60, nil
	local l2, _, t2, _ = self:getGlobalAABB(keeper)
	_ENV = nil
	;(nil).x = l2 - 30
	;(nil).y = t2 - 100
	;(nil).width = 60
	local (nil).height, rectKeeper = 200, nil
	local p1 = cc.p(rectBall.x, rectBall.y)
	local p2 = cc.p(rectBall.x + rectBall.width, rectBall.y)
	local p3 = cc.p(rectBall.x, rectBall.y + rectBall.height)
	local p4 = cc.p(rectBall.x + rectBall.width, rectBall.y + rectBall.height)
	local isInRect = function(p, rect)
		return p.x >= rect.x and p.x <= rect.x + rect.width and p.y >= rect.y and p.y <= rect.y + rect.height
	end
	return isInRect(p1, rectKeeper) or isInRect(p2, rectKeeper) or isInRect(p3, rectKeeper) or isInRect(p4, rectKeeper)
end
function Activity_9001735_MainPanel:onClick_Button_ball_longPress()
	SoraDPlaySound()
	self.isTouch = true
	self.isCharging = true
	self.touchTime = 0
	self.isOut = false
	self.fields.Button_ball:getController("button"):setSelectedIndex(1)
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	self.timer = SoradCreateTimer(self, handler(self, self.updateTime), true)
end
function Activity_9001735_MainPanel:updateTime(dt)
	if not self.isTouch then
		return
	end
	self.touchTime = self.touchTime + dt
	local t = self.touchTime % 4
	local power
	if t < 2 then
		power = self.ballTime * (t / 2)
	else
		power = self.ballTime * (1 - (t - 2) / 2)
	end
	local fill = self.ballTime > 0 and power / self.ballTime or 0
	if fill < 0 then
		fill = 0
	elseif 1 < fill then
		fill = 1
	end
	self.realBallTime = math.max(self.ballTime * fill, 0.1)
	self.fields.Slider_power:getChild("power"):setFillAmount(fill)
end
function Activity_9001735_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("freekick_master_text_02")
	uiManager:show("RuleView", nil)
end
function Activity_9001735_MainPanel:obSystemBackKeyClick()
	self:onClickClose()
end
function Activity_9001735_MainPanel:onClickClose()
	SoraDPlaySound("uicontrol", 1)
	if self.controllers.c1:getSelectedIndex() == 2 then
		if self.transitions.game:isPlaying() then
			return
		end
		_ENV = nil
		;(nil).content = i18n("freekick_master_text_05")
		;(nil).cancel = true
		;(nil).confirmFunc = function()
			self:exitGame()
		end
		uiManager:show("MessageBox", nil)
	else
		self:close()
	end
end
function Activity_9001735_MainPanel:endShow()
	print("=======Activity_9001735_MainPanel:endShow")
	self:initEnterShow()
	self.isTouch = false
	self.isCharging = false
	self.isOut = false
	self.touchTime = 0
	self.realBallTime = 0.1
	local _ENV, stageData = self.initEnterShow, self.initEnterShow
	local stageCfg = activity_9001735_Read.getStageRewardCfg()
	for __, cfg in ipairs(stageCfg) do
		_ENV = nil
		;(nil).stage = cfg.stage
		;(nil).point = cfg.point
		;(nil).rewards = cfg.reward
		table.insert(stageData, nil)
	end
	self.stageData = stageData
	_ENV = ipairs(stageCfg)
	ipairs(stageCfg).activityID = self.activityID
	ipairs(stageCfg).stageMax = #self.stageData
	self.fields.Com_boxList:initData(ipairs(stageCfg))
	self.tag = 1
	_ENV = ipairs(stageCfg)
	_ENV, _ENV, ipairs(stageCfg).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("activity_name_9001735")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("freekick_master_text_03")
	ipairs(stageCfg).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	ipairs(stageCfg).callback = handler(self, self.onTabClick)
	self.fields.Com_title:initTab(ipairs(stageCfg))
end
function Activity_9001735_MainPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:initView()
end
function Activity_9001735_MainPanel:initView(target, data)
	print("=======Activity_9001735_MainPanel:initView")
	self:setTabRedNum()
	if self.tag == 1 then
		self.fields.Com_have:initData(self.itemID)
		self.fields.Button_game:setCost(self.itemID, 1)
		local score = activity_9001735_Ctrl:getScore()
		_ENV = nil
		;(nil).num = fguiHelper.getColorString("#FFDF2D", score)
		self.fields.Lab_score:setTitle(i18n("eidTycoon2024_text_02", nil))
		for __, data in ipairs(self.stageData) do
			data.state = activity_9001735_Ctrl:getStageBoxStatues(data.point)
		end
		_ENV = ipairs(self.stageData)
		ipairs(self.stageData).score = score
		ipairs(self.stageData).stageData = self.stageData
		self.fields.Com_boxList:updateData(ipairs(self.stageData))
	else
		self.fields.Com_pass:initData()
	end
end
function Activity_9001735_MainPanel:enterGame()
	self.isOut = false
	self.fields.Com_title:setTabShow(false)
	self.fields.football_shadow:setVisible(true)
	self.fields.aim:setPosition(cc.p(self:getWidth() / 2, self:getHeight() / 2 - 146))
	self.controllers.c1:setSelectedIndex(2)
	local isNotGuide = guideCtrl:isGuideNotCompleted(gGuideModule.FREE_KICK_MASTER)
	self.fields.Button_ball:setTouchEnabled(not isNotGuide and true or false)
	self.transitions.game:play(function()
		self:keeperMove()
		if isNotGuide then
			print("触发引导")
			self.fields.Button_ball:setTouchEnabled(true)
			local step = tonumber(gGuideStep.FREE_KICK_MASTER_STEP_1)
			self = true
			;(true).msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
			;(true).step = step
			SoraDSendMessage(true)
			guideCtrl:CompleteGuideStep(step)
		end
	end)
	self:cancelBallCharge()
	self.fields.keeper:stopAllActions()
	self.fields.keeper:setPositionX(self:getWidth() / 2)
end
function Activity_9001735_MainPanel:exitGame()
	self:initEnterShow()
end
function Activity_9001735_MainPanel:initEnterShow()
	self.fields.Com_title:setTabShow(true)
	self.fields.football_shadow:setVisible(true)
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.controllers.c1:setSelectedIndex(0)
	self.fields.Button_ball:setTouchEnabled(false)
	self.transitions.enter:play()
end
function Activity_9001735_MainPanel:setTabRedNum()
	local itemRedNum = activity_9001735_Ctrl:getItemRedNum()
	local stageRedNum = activity_9001735_Ctrl:getStageRewardNum()
	local mainRedNum = itemRedNum + stageRedNum
	self.fields.Com_title:setBtnRedDot(1, 0 < mainRedNum)
	local passRedNum = activity_9001735_Ctrl:getPassRedNum()
	self.fields.Com_title:setBtnRedDot(2, 0 < passRedNum)
end
function Activity_9001735_MainPanel:onClick_Button_game(context)
	SoraDPlaySound()
	if self.fields.Button_game:checkItem() then
		self:enterGame()
	else
		SoraDShowMsgTip(i18n("notice_0120"))
		uiManager:show("Activity_9001735_Gift")
	end
end
function Activity_9001735_MainPanel:onClick_Button_reward(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001735_Reward")
end
function Activity_9001735_MainPanel:onClick_Button_rank(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001735_Rank")
end
function Activity_9001735_MainPanel:onClick_Button_gift(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001735_Gift")
end
return Activity_9001735_MainPanel
