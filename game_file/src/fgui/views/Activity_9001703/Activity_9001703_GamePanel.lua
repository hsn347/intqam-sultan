local LONG_PRESS_TIME = 0.1
local constantRead = include("constantRead")
local activity_9001703_Read = include("activity_9001703_Read")
local activity_9001703_Ctrl = SoraDGetCtrl("activity_9001703_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001703_GamePanel = class("Activity_9001703_GamePanel", baseFguiPanel)
function Activity_9001703_GamePanel:ctor(...)
	self.isLRU = true
	Activity_9001703_GamePanel.super.ctor(self, ...)
	print("Activity_9001703_GamePanel:ctor", self.viewName)
	self.isCantCloseByReturn = true
end
function Activity_9001703_GamePanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
	end
	return self._packageList
end
function Activity_9001703_GamePanel:onInit()
	print("=======Activity_9001703_GamePanel:onInit")
	self.maxHP = constantRead.getConstValue("BALLOON_HUNTER_PLAYER_HP", 3000)
	self.fields.Com_title:initData(i18n("balloon_hunter_001"), handler(self, self.onClickClose))
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillRenderer))
	self.fields.Text_detail:setString(i18n("common_text_1720"))
	self.fields.Text_detail:addClickListener(handler(self, self.btnViewSkillClick))
	self.fields.Com_touch:addClickListener(handler(self, self.onTouchClick))
	self.fields.Com_touch:addEventListener(fgui.UIEventType.TouchBegin, function(context)
		context:captureTouch()
		self.t_bTime = os.clock()
	end)
	self.fields.Com_touch:addEventListener(fgui.UIEventType.TouchMove, function(context)
		local cur_Time = os.clock()
		if cur_Time - self.t_bTime <= LONG_PRESS_TIME then
			return
		end
		local touchPos = context:getInput():getPosition()
		local rotation = -math.deg(math.atan((touchPos.x - self.hunterPos.x) / -math.abs(touchPos.y - self.hunterPos.y)))
		self:updateHunterRotation(rotation)
	end)
	self.fields.Lab_lv:fixPos()
end
function Activity_9001703_GamePanel:onSkillRenderer(index, obj)
	obj:fixChildrenPos()
	local skillID = self.skillData[index + 1]
	local showCfg = activity_9001703_Read.getSkillShow(skillID)
	obj:setIcon(showCfg.skillIcon)
	local val, valShow = activity_9001703_Ctrl:getSkillLvEffect(skillID)
	obj:setTitle(valShow)
end
function Activity_9001703_GamePanel:endShow()
	print("=======Activity_9001703_GamePanel:endShow")
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
	self.isGuide = self.param and self.param.isGuide or false
	self.fields.Bar_lv:hideTitle()
	self.isPause = false
	self.gameTime = 0
	self.balloonPool, _ENV, self.hitPool, _ENV, self.gameDt = self.fields.Bar_lv.hideTitle, self.fields.Bar_lv.hideTitle, self.fields.Bar_lv.hideTitle, self.fields.Bar_lv.hideTitle, 0
	self.balloonTag = 0
	self.fields.Com_source:removeAllChildren()
	self.fields.Com_num:removeAllChildren()
	self.hunterPos = self.fields.Com_hunter:getGunPos()
	self.fields.Com_hunter:setPause(true)
	self:initView()
	self.expPos = self.fields.Bar_lv:localToGlobal(cc.p(self.fields.Bar_lv:getWidth() / 2, 0))
	_ENV = cc.p(self.fields.Bar_lv:getWidth() / 2, 0)
	cc.p(self.fields.Bar_lv:getWidth() / 2, 0).callback = handler(self, self.onGameStart)
	self.fields.Com_starTime:startGame(cc.p(self.fields.Bar_lv:getWidth() / 2, 0))
end
function Activity_9001703_GamePanel:onGameStart()
	print("游戏开始")
	self.orderIndex, self.orderInterval = activity_9001703_Read.getMonsterOrderCfg(math.floor(self.gameTime))
	if self.isGuide then
		_ENV = activity_9001703_Read.getMonsterOrderCfg(math.floor(self.gameTime))
		activity_9001703_Read.getMonsterOrderCfg(math.floor(self.gameTime)).msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		activity_9001703_Read.getMonsterOrderCfg(math.floor(self.gameTime)).step = 9991700
		SoraDSendMessage(activity_9001703_Read.getMonsterOrderCfg(math.floor(self.gameTime)))
		self.isPause = true
	else
		self.fields.Com_hunter:setPause(false)
		self:initGameTimer()
	end
end
function Activity_9001703_GamePanel:endGuide(target, data)
	if data and data.step and tonumber(data.step) == 9991704 then
		self.isPause = false
		self.fields.Com_hunter:setPause(false)
		self:initGameTimer()
	end
end
function Activity_9001703_GamePanel:initView()
	self:updateScore()
	self:updateHunterHP()
	self:updateLvEXP()
	self:updateHunterBuff()
	self:updateSkill()
end
function Activity_9001703_GamePanel:initGameTimer()
	SoradCreateTimer(self, handler(self, self.updateTime), true)
	self:updateTime(0)
end
function Activity_9001703_GamePanel:updateTime(dt)
	if self.isPause then
		self:pauseGame()
	else
		self:continueGame()
		self.gameDt = self.gameDt + dt
		self.gameTime = self.gameTime + dt
		local orderIndex, orderInterval = activity_9001703_Read.getMonsterOrderCfg(math.floor(self.gameTime))
		if orderIndex ~= self.orderIndex then
			self.orderIndex = orderIndex
			self.orderInterval = orderInterval
		end
		if self.gameDt >= self.orderInterval then
			self.gameDt = 0
			self:outputBalloon()
		end
		local balloonList = self:getShowBalloon()
		local bulletList = self.fields.Com_hunter:getShowBullet()
		for _, balloon in ipairs(balloonList) do
			local balloonR = balloon:getWidth() / 2
			local balloonH = balloon:getHeight() - balloonR
			local posP = balloon:localToGlobal(cc.p(0, 0))
			local bTag = balloon:getBalloonTag()
			for _, bullet in ipairs(bulletList) do
				local posQ = bullet:localToGlobal(cc.p(0, 0))
				if not (0 > posQ.x) and not (posQ.x > self:getWidth()) and not (posQ.y > self:getHeight()) and 0 < posP.y then
					local isInCircle = balloonR >= serviceFunctions.lineSpace(posQ.x, posQ.y, posP.x, posP.y)
					local s1 = serviceFunctions.heronForS(posP.x - balloonR, posP.y, posP.x + balloonR, posP.y, posQ.x, posQ.y)
					local s2 = serviceFunctions.heronForS(posP.x - balloonR, posP.y, posP.x, posP.y + balloonH, posQ.x, posQ.y)
					local s3 = serviceFunctions.heronForS(posP.x + balloonR, posP.y, posP.x, posP.y + balloonH, posQ.x, posQ.y)
					local isInTriangle = s1 + s2 + s3 <= balloonR * balloonH
					if (isInCircle or isInTriangle) and not bullet:isHited(bTag) then
						balloon:beHit(self.fields.Com_num, posP, self.expPos, self.hitPool, handler(self, self.addToHitPool))
						bullet:hit(bTag)
					end
				end
			end
		end
	end
end
function Activity_9001703_GamePanel:updateScore()
	local score = activity_9001703_Ctrl:getScore()
	activity_9001703_Ctrl = nil
	;(nil).num = fguiHelper.getColorString("#F0E6D2", score)
	self.fields.Text_score:setString(i18n("balloon_hunter_017", nil))
	local killNum = activity_9001703_Ctrl:getKillMonsterNum()
	activity_9001703_Ctrl = i18n("balloon_hunter_017", nil)
	i18n("balloon_hunter_017", nil).num = fguiHelper.getColorString("#F0E6D2", killNum)
	self.fields.Text_killed:setString(i18n("balloon_hunter_049", i18n("balloon_hunter_017", nil)))
end
function Activity_9001703_GamePanel:updateHunterHP()
	self.fields.Com_hunter:updateHp()
	local hp = activity_9001703_Ctrl:getBlood()
	if hp <= 0 then
		uiManager:show("Activity_9001703_Finish")
		self.isPause = true
	end
end
function Activity_9001703_GamePanel:updateLvEXP()
	local exp = activity_9001703_Ctrl:getExp()
	local lv = activity_9001703_Ctrl:getLv()
	self.fields.Bar_lv:setMax(activity_9001703_Read.getNeedExp(lv + 1))
	self.fields.Bar_lv:setValue(exp)
	activity_9001703_Ctrl = activity_9001703_Read.getNeedExp(lv + 1)
	activity_9001703_Read.getNeedExp(lv + 1).lv = lv
	self.fields.Lab_lv:setString(i18n("common_text_100", activity_9001703_Read.getNeedExp(lv + 1)))
end
function Activity_9001703_GamePanel:updateSkill()
	self.skillData = activity_9001703_Read.getShowSkill()
	self.fields.List_skill:setNumItems(#self.skillData)
end
function Activity_9001703_GamePanel:updateHunterBuff()
	self.fields.Com_hunter:updateBuff()
end
function Activity_9001703_GamePanel:randomSkill(target, data)
	_ENV = nil
	;(nil).randomSkill = data.randomSkill
	;(nil).callback = function()
		self.isPause = false
	end
	uiManager:show("Activity_9001703_SkillPop", nil)
	self.isPause = true
end
function Activity_9001703_GamePanel:outputBalloon()
	local balloon
	if #self.balloonPool > 0 then
		balloon = table.remove(self.balloonPool)
		balloon.isInPool = false
	else
		balloon = fguiHelper.createObject("Activity_9001703", "Com_balloon")
		balloon:setBalloonTag(self.balloonTag)
		self.balloonTag = self.balloonTag + 1
		balloon:addTo(self.fields.Com_source)
	end
	local monsterData = activity_9001703_Read.getRandomMonsterCfg(math.floor(self.gameTime))
	balloon:setIcon(monsterData.balloonIcon)
	balloon:initData(monsterData, self)
	balloon:setVisible(true)
	local randomX = math.random(50, math.floor(self:getWidth()) - 200)
	local randomY = math.random(-50, 50)
	balloon:stopAllActions()
	balloon:setAlpha(0)
	balloon:setPosition(cc.p(randomX, randomY))
	local moveTime = (self:getHeight() + randomY) / monsterData.speed
	local toPosY = self:getHeight() - 290 - balloon:getHeight() / 2
	activity_9001703_Read = cc.p(randomX, randomY)
	activity_9001703_Read = cc.p(randomX, randomY)
	cc.p(randomX, randomY)[1] = ffa.fadeIn(1)
	cc.p(randomX, randomY)[2] = ffa.moveTo(moveTime, randomX, toPosY)
	cc.p(randomX, randomY)[3] = ffa.moveTo(moveTime, randomX, toPosY)
	cc.p(randomX, randomY)[4] = ffa.moveTo(moveTime, randomX, toPosY)
	cc.p(randomX, randomY)[5] = ffa.moveTo(moveTime, randomX, toPosY)
	cc.p(randomX, randomY)[1] = ffa.spawn(cc.p(randomX, randomY))
	cc.p(randomX, randomY)[2] = ffa.callFunc(function()
		local pos = balloon:localToGlobal(cc.p(0, 0))
		local beHit
		if 0 < #self.hitPool then
			beHit = table.remove(self.hitPool)
			beHit.isInPool = false
			beHit:setVisible(true)
		else
			beHit = fguiHelper.createObject("Activity_9001703", "Com_beHit")
			beHit:addTo(self.fields.Com_num)
		end
		beHit:setPosition(self.fields.Com_num:globalToLocal(pos))
		beHit:showHit(true, handler(self, self.addToHitPool))
		balloon = true
		;(true)[1] = balloon:getMonster()
		;(true)[2] = balloon:getMonster()
		;(true)[3] = balloon:getMonster()
		activity_9001703_Ctrl:reqMonsterAttack(true)
		balloon:setStatus(2)
		self:addToPool(balloon)
		self.fields.Com_hunter:beHit(balloon:getMonster())
	end)
	cc.p(randomX, randomY)[3] = ffa.callFunc(function()
		local pos = balloon:localToGlobal(cc.p(0, 0))
		local beHit
		if 0 < #self.hitPool then
			beHit = table.remove(self.hitPool)
			beHit.isInPool = false
			beHit:setVisible(true)
		else
			beHit = fguiHelper.createObject("Activity_9001703", "Com_beHit")
			beHit:addTo(self.fields.Com_num)
		end
		beHit:setPosition(self.fields.Com_num:globalToLocal(pos))
		beHit:showHit(true, handler(self, self.addToHitPool))
		balloon = true
		;(true)[1] = balloon:getMonster()
		;(true)[2] = balloon:getMonster()
		;(true)[3] = balloon:getMonster()
		activity_9001703_Ctrl:reqMonsterAttack(true)
		balloon:setStatus(2)
		self:addToPool(balloon)
		self.fields.Com_hunter:beHit(balloon:getMonster())
	end)
	cc.p(randomX, randomY)[4] = ffa.callFunc(function()
		local pos = balloon:localToGlobal(cc.p(0, 0))
		local beHit
		if 0 < #self.hitPool then
			beHit = table.remove(self.hitPool)
			beHit.isInPool = false
			beHit:setVisible(true)
		else
			beHit = fguiHelper.createObject("Activity_9001703", "Com_beHit")
			beHit:addTo(self.fields.Com_num)
		end
		beHit:setPosition(self.fields.Com_num:globalToLocal(pos))
		beHit:showHit(true, handler(self, self.addToHitPool))
		balloon = true
		;(true)[1] = balloon:getMonster()
		;(true)[2] = balloon:getMonster()
		;(true)[3] = balloon:getMonster()
		activity_9001703_Ctrl:reqMonsterAttack(true)
		balloon:setStatus(2)
		self:addToPool(balloon)
		self.fields.Com_hunter:beHit(balloon:getMonster())
	end)
	cc.p(randomX, randomY)[5] = ffa.callFunc(function()
		local pos = balloon:localToGlobal(cc.p(0, 0))
		local beHit
		if 0 < #self.hitPool then
			beHit = table.remove(self.hitPool)
			beHit.isInPool = false
			beHit:setVisible(true)
		else
			beHit = fguiHelper.createObject("Activity_9001703", "Com_beHit")
			beHit:addTo(self.fields.Com_num)
		end
		beHit:setPosition(self.fields.Com_num:globalToLocal(pos))
		beHit:showHit(true, handler(self, self.addToHitPool))
		balloon = true
		;(true)[1] = balloon:getMonster()
		;(true)[2] = balloon:getMonster()
		;(true)[3] = balloon:getMonster()
		activity_9001703_Ctrl:reqMonsterAttack(true)
		balloon:setStatus(2)
		self:addToPool(balloon)
		self.fields.Com_hunter:beHit(balloon:getMonster())
	end)
	cc.p(randomX, randomY)[6] = ffa.callFunc(function()
		local pos = balloon:localToGlobal(cc.p(0, 0))
		local beHit
		if 0 < #self.hitPool then
			beHit = table.remove(self.hitPool)
			beHit.isInPool = false
			beHit:setVisible(true)
		else
			beHit = fguiHelper.createObject("Activity_9001703", "Com_beHit")
			beHit:addTo(self.fields.Com_num)
		end
		beHit:setPosition(self.fields.Com_num:globalToLocal(pos))
		beHit:showHit(true, handler(self, self.addToHitPool))
		balloon = true
		;(true)[1] = balloon:getMonster()
		;(true)[2] = balloon:getMonster()
		;(true)[3] = balloon:getMonster()
		activity_9001703_Ctrl:reqMonsterAttack(true)
		balloon:setStatus(2)
		self:addToPool(balloon)
		self.fields.Com_hunter:beHit(balloon:getMonster())
	end)
	cc.p(randomX, randomY)[7] = ffa.callFunc(function()
		local pos = balloon:localToGlobal(cc.p(0, 0))
		local beHit
		if 0 < #self.hitPool then
			beHit = table.remove(self.hitPool)
			beHit.isInPool = false
			beHit:setVisible(true)
		else
			beHit = fguiHelper.createObject("Activity_9001703", "Com_beHit")
			beHit:addTo(self.fields.Com_num)
		end
		beHit:setPosition(self.fields.Com_num:globalToLocal(pos))
		beHit:showHit(true, handler(self, self.addToHitPool))
		balloon = true
		;(true)[1] = balloon:getMonster()
		;(true)[2] = balloon:getMonster()
		;(true)[3] = balloon:getMonster()
		activity_9001703_Ctrl:reqMonsterAttack(true)
		balloon:setStatus(2)
		self:addToPool(balloon)
		self.fields.Com_hunter:beHit(balloon:getMonster())
	end)
	balloon:runAction(ffa.seq(cc.p(randomX, randomY)))
end
function Activity_9001703_GamePanel:addToPool(balloon)
	if balloon.isInPool then
		return
	end
	balloon:stopAllActions()
	balloon:setPosition(cc.p(0, 0))
	balloon:setVisible(false)
	balloon.isInPool = true
	table.insert(self.balloonPool, balloon)
end
function Activity_9001703_GamePanel:addToHitPool(beHit)
	if beHit.isInPool then
		return
	end
	beHit:setPosition(cc.p(0, 0))
	beHit:setVisible(false)
	beHit.isInPool = true
	table.insert(self.hitPool, beHit)
end
function Activity_9001703_GamePanel:btnViewSkillClick()
	SoraDPlaySound()
	self.isPause = true
	_ENV = nil
	;(nil).callback = function()
		self.isPause = false
	end
	uiManager:show("Activity_9001703_Skill", nil)
end
function Activity_9001703_GamePanel:pauseGame()
	for _, v in ipairs(self.fields.Com_source:getChildren()) do
		v:pause()
		v:getActionManager():pauseTarget(v)
	end
	self.fields.Com_hunter:setPause(self.isPause)
end
function Activity_9001703_GamePanel:continueGame()
	for _, v in ipairs(self.fields.Com_source:getChildren()) do
		v:resume()
		v:getActionManager():resumeTarget(v)
	end
	self.fields.Com_hunter:setPause(self.isPause)
end
function Activity_9001703_GamePanel:getShowBalloon()
	local _ENV, ret
	for _, v in ipairs(self.fields.Com_source:getChildren()) do
		if v:isVisible() and v:getHp() > 0 then
			table.insert(ret, v)
		end
	end
	return ret
end
function Activity_9001703_GamePanel:updateHunterRotation(rotation)
	if rotation < 0 then
		rotation = math.max(rotation, -50)
	else
		rotation = math.min(rotation, 50)
	end
	self.fields.Com_hunter:setHunterRotation(rotation)
end
function Activity_9001703_GamePanel:onTouchClick(context)
	local touchPos = context:getInput():getPosition()
	local rotation = -math.deg(math.atan((touchPos.x - self.hunterPos.x) / -math.abs(touchPos.y - self.hunterPos.y)))
	self:updateHunterRotation(rotation)
end
function Activity_9001703_GamePanel:onClickClose()
	print("游戏暂停弹窗")
	self.isPause = true
	_ENV = nil
	;(nil).callback = function(ret)
		if ret then
			self:close()
		else
			self.isPause = false
		end
	end
	uiManager:show("Activity_9001703_Pause", nil)
end
function Activity_9001703_GamePanel:endGame()
	self:close()
end
function Activity_9001703_GamePanel:gameGuide_getTarget(itemName, parameters)
	return self.fields[itemName]
end
return Activity_9001703_GamePanel
