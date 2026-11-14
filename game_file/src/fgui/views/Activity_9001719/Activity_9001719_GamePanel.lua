local LONG_PRESS_TIME = 0.1
local constantRead = include("constantRead")
local activity_9001719_Read = include("activity_9001719_Read")
local activity_9001719_Ctrl = SoraDGetCtrl("activity_9001719_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001719_GamePanel = class("Activity_9001719_GamePanel", baseFguiPanel)
function Activity_9001719_GamePanel:ctor(...)
	self.isLRU = true
	Activity_9001719_GamePanel.super.ctor(self, ...)
	print("Activity_9001719_GamePanel:ctor", self.viewName)
	self.isCantCloseByReturn = true
end
function Activity_9001719_GamePanel:onInit()
	print("=======Activity_9001719_GamePanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001719"), handler(self, self.onClickClose))
	self.fields.Label_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = fguiHelper.getColorString("#F0E6D2", time)
		return i18n("lost_ruins_text_21", nil)
	end)
	self.fields.Com_touch:addClickListener(handler(self, self.onTouchClick))
	self.fields.Com_touch:addEventListener(fgui.UIEventType.TouchBegin, function(context)
		context:captureTouch()
		self.t_bTime = os.clock()
	end)
	self.fields.Com_touch:addEventListener(fgui.UIEventType.TouchMove, function(context)
		local cur_Time = os.clock()
		if cur_Time - self.t_bTime <= LONG_PRESS_TIME or self.isPause then
			return
		end
		local touchPos = self:globalToLocal(context:getInput():getPosition())
		local posX = math.max(self.leftX, math.min(self.rightX, touchPos.x))
		self.fields.Com_role:stopAllActions()
		self.fields.Com_role:setPositionX(posX)
	end)
end
function Activity_9001719_GamePanel:endShow()
	print("=======Activity_9001719_GamePanel:endShow")
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
	self.GAME_TIME = constantRead.getConstValue("MAGIC_CARPET_TOTAL_TIME", 180)
	self.isPause = false
	self.score = 0
	self.gameTime = 0
	self.gameDt = 0
	self.npcPool, _ENV, self.numPool, _ENV, self.gameT = constantRead.getConstValue("MAGIC_CARPET_TOTAL_TIME", 180), constantRead.getConstValue("MAGIC_CARPET_TOTAL_TIME", 180), constantRead.getConstValue("MAGIC_CARPET_TOTAL_TIME", 180), constantRead.getConstValue("MAGIC_CARPET_TOTAL_TIME", 180), 0
	self.fields.Com_source:removeAllChildren()
	self.fields.Com_num:removeAllChildren()
	self.fields.Com_role:setPositionX(self:getWidth() / 2)
	self.rolePosY = self.fields.Com_role:getPositionY()
	self.leftX = self.fields.Com_role:getWidth() / 2
	self.rightX = self:getWidth() - self.fields.Com_role:getWidth() / 2
	self:setLeftTime()
	self:updateScore()
	_ENV = self.fields.Com_role
	self.fields.Com_role.callback = handler(self, self.onGameStart)
	self.fields.Com_starTime:startGame(self.fields.Com_role)
end
function Activity_9001719_GamePanel:setLeftTime()
	local leftTime = self.GAME_TIME - math.floor(self.gameTime)
	_ENV = nil
	;(nil).time = fguiHelper.getColorString("#F0E6D2", SoraDConvertSecondToString(leftTime))
	self.fields.Label_time:setString(i18n("lost_ruins_text_21", nil))
	if leftTime <= 0 then
		_ENV = i18n("lost_ruins_text_21", nil)
		i18n("lost_ruins_text_21", nil).score = self.score
		uiManager:show("Activity_9001719_End", i18n("lost_ruins_text_21", nil))
		self.isPause = true
	end
end
function Activity_9001719_GamePanel:onGameStart()
	print("游戏开始")
	self.orderIndex, self.orderInterval = activity_9001719_Read.getMonsterOrderCfg(math.floor(self.gameTime))
	if activity_9001719_Ctrl:isNeedGuide() then
		_ENV = activity_9001719_Ctrl
		activity_9001719_Ctrl.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		activity_9001719_Ctrl.step = 9991800
		SoraDSendMessage(activity_9001719_Ctrl)
		self.isPause = true
	else
		self:initGameTimer()
	end
end
function Activity_9001719_GamePanel:endGuide(target, data)
	if data and data.step and tonumber(data.step) == 9991803 then
		self.isPause = false
		self:initGameTimer()
	end
end
function Activity_9001719_GamePanel:initGameTimer()
	SoradCreateTimer(self, handler(self, self.updateTime), true)
	self:updateTime(0)
end
function Activity_9001719_GamePanel:updateTime(dt)
	if self.isPause then
		self:pauseGame()
	else
		self:continueGame()
		self.gameDt = self.gameDt + dt
		self.gameTime = math.min(self.GAME_TIME, self.gameTime + dt)
		self.gameT = self.gameT + dt
		if self.gameT >= 1 then
			self.gameT = 0
			self:setLeftTime()
		end
		local orderIndex, orderInterval = activity_9001719_Read.getMonsterOrderCfg(math.min(self.GAME_TIME, math.floor(self.gameTime)))
		if orderIndex ~= self.orderIndex then
			self.orderIndex = orderIndex
			self.orderInterval = orderInterval
		end
		if self.gameDt >= self.orderInterval then
			self.gameDt = 0
			self:outputNPC()
		end
		local npcList = self:getShowNpc()
		local npcW = 56
		for _, npc in ipairs(npcList) do
			local posP = npc:getPosition()
			_ENV = npc
			npc.x = posP.x - npcW / 2
			npc.y = posP.y - npcW / 2
			npc.width = npcW
			local npc.height, rectNpc = npcW, npc
			local posQ = self.fields.Com_role:getPosition()
			_ENV = self.fields.Com_role
			self.fields.Com_role.x = posQ.x - self.fields.Com_role:getWidth() / 2
			self.fields.Com_role.y = posQ.y - self.fields.Com_role:getHeight() / 2
			self.fields.Com_role.width = self.fields.Com_role:getWidth()
			local _ENV, self.fields.Com_role.height, rectRole1 = self.fields.Com_role:getHeight(), self.fields.Com_role:getHeight(), self.fields.Com_role
			self.fields.Com_role:getHeight().x = posQ.x - 85
			self.fields.Com_role:getHeight().y = posQ.y + 10
			self.fields.Com_role:getHeight().width = 170
			local self.fields.Com_role:getHeight().height, rectRole2 = 42, self.fields.Com_role:getHeight()
			if SoraDRectIntersectsRect(rectNpc, rectRole1) or SoraDRectIntersectsRect(rectNpc, rectRole2) then
				local npcData = npc:getData()
				if npcData.type == 1 then
					self:getGold(npc, npcData.score)
				elseif npcData.type == 2 then
					npc:showZDEffect()
					_ENV = npcData.score
					npcData.score.score = self.score
					uiManager:show("Activity_9001719_End", npcData.score)
					self.isPause = true
				end
			end
		end
	end
end
function Activity_9001719_GamePanel:getGold(npc, score)
	local num
	if #self.numPool > 0 then
		num = table.remove(self.numPool)
		num.isInPool = false
	else
		num = fguiHelper.createObject("Activity_9001719", "Lab_num")
		num:addTo(self.fields.Com_num)
	end
	_ENV = nil
	;(nil).value = score
	num:setTitle(i18n("common_text_1952", nil))
	num:setVisible(true)
	num:setAlpha(1)
	num:setPosition(cc.p(self.fields.Com_role:getPositionX(), self.fields.Com_role:getPositionY()))
	num:setScale(0.6)
	local randomX = math.random(-30, 30)
	local randomY = math.random(0, 30)
	_UPVALUE4_ = cc.p(self.fields.Com_role:getPositionX(), self.fields.Com_role:getPositionY())
	_UPVALUE1_ = cc.p(self.fields.Com_role:getPositionX(), self.fields.Com_role:getPositionY())
	cc.p(self.fields.Com_role:getPositionX(), self.fields.Com_role:getPositionY())[1] = ffa.scaleTo(0.2, 1.1, 1.1)
	cc.p(self.fields.Com_role:getPositionX(), self.fields.Com_role:getPositionY())[2] = ffa.moveBy(0.2, randomX, randomY)
	cc.p(self.fields.Com_role:getPositionX(), self.fields.Com_role:getPositionY())[3] = ffa.moveBy(0.2, randomX, randomY)
	cc.p(self.fields.Com_role:getPositionX(), self.fields.Com_role:getPositionY())[4] = ffa.moveBy(0.2, randomX, randomY)
	cc.p(self.fields.Com_role:getPositionX(), self.fields.Com_role:getPositionY())[5] = ffa.moveBy(0.2, randomX, randomY)
	cc.p(self.fields.Com_role:getPositionX(), self.fields.Com_role:getPositionY())[1] = ffa.spawn(cc.p(self.fields.Com_role:getPositionX(), self.fields.Com_role:getPositionY()))
	cc.p(self.fields.Com_role:getPositionX(), self.fields.Com_role:getPositionY())[2] = ffa.scaleTo(0.15, 1, 1)
	cc.p(self.fields.Com_role:getPositionX(), self.fields.Com_role:getPositionY())[3] = ffa.delay(0.5)
	cc.p(self.fields.Com_role:getPositionX(), self.fields.Com_role:getPositionY())[4] = ffa.fadeOut(0.3)
	cc.p(self.fields.Com_role:getPositionX(), self.fields.Com_role:getPositionY())[5] = ffa.callFunc(function()
		self:addToNumPool(num)
	end)
	cc.p(self.fields.Com_role:getPositionX(), self.fields.Com_role:getPositionY())[6] = ffa.callFunc(function()
		self:addToNumPool(num)
	end)
	cc.p(self.fields.Com_role:getPositionX(), self.fields.Com_role:getPositionY())[7] = ffa.callFunc(function()
		self:addToNumPool(num)
	end)
	num:runAction(ffa.seq(cc.p(self.fields.Com_role:getPositionX(), self.fields.Com_role:getPositionY())))
	self.score = self.score + score
	self:updateScore()
	self:addToPool(npc)
end
function Activity_9001719_GamePanel:addToNumPool(num)
	if num.isInPool then
		return
	end
	num:stopAllActions()
	num:setPosition(cc.p(0, 0))
	num:setVisible(false)
	num.isInPool = true
	table.insert(self.numPool, num)
end
function Activity_9001719_GamePanel:outputNPC()
	local npc
	if #self.npcPool > 0 then
		npc = table.remove(self.npcPool)
		npc.isInPool = false
	else
		npc = fguiHelper.createObject("Activity_9001719", "Com_npc")
		npc:addTo(self.fields.Com_source)
	end
	local npcData = activity_9001719_Read.getRandomMonsterCfg(math.min(self.GAME_TIME, math.floor(self.gameTime)))
	npc:setIcon(npcData.model)
	npc:initData(npcData)
	npc:setVisible(true)
	local randomX = math.random(100 + npc:getWidth() / 2, math.floor(self:getWidth()) - npc:getWidth() / 2 - 100)
	local randomY = math.random(-npc:getWidth() / 2, npc:getWidth() / 2)
	npc:stopAllActions()
	npc:setAlpha(0)
	npc:setPosition(cc.p(randomX, randomY))
	local moveTime = (self:getHeight() + randomY) / npcData.speed
	local toPosY = self:getHeight() + npc:getHeight() / 2
	activity_9001719_Read = cc.p(randomX, randomY)
	activity_9001719_Read = cc.p(randomX, randomY)
	cc.p(randomX, randomY)[1] = ffa.fadeIn(1)
	cc.p(randomX, randomY)[2] = ffa.moveTo(moveTime, randomX, toPosY)
	cc.p(randomX, randomY)[3] = ffa.moveTo(moveTime, randomX, toPosY)
	cc.p(randomX, randomY)[4] = ffa.moveTo(moveTime, randomX, toPosY)
	cc.p(randomX, randomY)[5] = ffa.moveTo(moveTime, randomX, toPosY)
	cc.p(randomX, randomY)[1] = ffa.spawn(cc.p(randomX, randomY))
	cc.p(randomX, randomY)[2] = ffa.callFunc(function()
		self:addToPool(npc)
	end)
	cc.p(randomX, randomY)[3] = ffa.callFunc(function()
		self:addToPool(npc)
	end)
	cc.p(randomX, randomY)[4] = ffa.callFunc(function()
		self:addToPool(npc)
	end)
	cc.p(randomX, randomY)[5] = ffa.callFunc(function()
		self:addToPool(npc)
	end)
	cc.p(randomX, randomY)[6] = ffa.callFunc(function()
		self:addToPool(npc)
	end)
	cc.p(randomX, randomY)[7] = ffa.callFunc(function()
		self:addToPool(npc)
	end)
	npc:runAction(ffa.seq(cc.p(randomX, randomY)))
end
function Activity_9001719_GamePanel:addToPool(npc)
	if npc.isInPool then
		return
	end
	npc:stopAllActions()
	npc:setPosition(cc.p(0, 0))
	npc:setVisible(false)
	npc.isInPool = true
	table.insert(self.npcPool, npc)
end
function Activity_9001719_GamePanel:getShowNpc()
	local _ENV, ret
	for _, v in ipairs(self.fields.Com_source:getChildren()) do
		if v:isVisible() then
			table.insert(ret, v)
		end
	end
	return ret
end
function Activity_9001719_GamePanel:updateScore()
	_ENV = nil
	;(nil).num = fguiHelper.getColorString("#FFD43E", self.score)
	self.fields.Text_score:setString(i18n("pet_flip_text_03", nil))
	_UPVALUE2_ = self.fields.Text_score.setString
	self.fields.Text_score.setString[1] = math.min(self.GAME_TIME, math.floor(self.gameTime))
	local self.fields.Text_score.setString[2], recordTable = self.score, self.fields.Text_score.setString
	_ENV = math.floor(self.gameTime)
	math.floor(self.gameTime).byUID = true
	SoraDConfigSet("Game:Com_9001719_game:recordTable~table", recordTable, math.floor(self.gameTime))
end
function Activity_9001719_GamePanel:pauseGame()
	for _, v in ipairs(self.fields.Com_source:getChildren()) do
		v:pause()
		v:getActionManager():pauseTarget(v)
	end
	self.fields.Com_role:pause()
	self.fields.Com_role:getActionManager():pauseTarget(self.fields.Com_role)
end
function Activity_9001719_GamePanel:continueGame()
	for _, v in ipairs(self.fields.Com_source:getChildren()) do
		v:resume()
		v:getActionManager():resumeTarget(v)
	end
	self.fields.Com_role:resume()
	self.fields.Com_role:getActionManager():resumeTarget(self.fields.Com_role)
end
function Activity_9001719_GamePanel:endGame()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:Com_9001719_game:recordTable~table", nil, nil)
	activity_9001719_Ctrl:reqGameEnd(math.min(self.GAME_TIME, math.floor(self.gameTime)), self.score)
	self:close()
end
function Activity_9001719_GamePanel:onTouchClick(context)
	if self.isPause then
		return
	end
	local touchPos = self:globalToLocal(context:getInput():getPosition())
	local posX = math.max(self.leftX, math.min(self.rightX, touchPos.x))
	local offset = math.abs(self.fields.Com_role:getPositionX() - posX)
	local time = offset / 1300
	if 0 < time then
		self.fields.Com_role:stopAllActions()
		_ENV = math.min(self.rightX, touchPos.x)
		math.min(self.rightX, touchPos.x)[1] = ffa.moveTo(time, posX, self.rolePosY)
		math.min(self.rightX, touchPos.x)[2] = ffa.moveTo(time, posX, self.rolePosY)
		math.min(self.rightX, touchPos.x)[3] = ffa.moveTo(time, posX, self.rolePosY)
		math.min(self.rightX, touchPos.x)[4] = ffa.moveTo(time, posX, self.rolePosY)
		self.fields.Com_role:runAction(ffa.seq(math.min(self.rightX, touchPos.x)))
	end
end
function Activity_9001719_GamePanel:onClickClose()
	print("游戏暂停弹窗")
	self.isPause = true
	_ENV = nil
	;(nil).secs = self.gameTime
	;(nil).score = self.score
	;(nil).callback = function(ret)
		if ret then
			self:endGame()
		else
			self.isPause = false
		end
	end
	uiManager:show("Activity_9001719_Pause", nil)
end
function Activity_9001719_GamePanel:gameGuide_getTarget(itemName, parameters)
	return self.fields[itemName]
end
return Activity_9001719_GamePanel
