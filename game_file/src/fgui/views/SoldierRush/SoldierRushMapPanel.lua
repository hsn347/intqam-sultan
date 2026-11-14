local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SoldierRushMapPanel = class("SoldierRushMapPanel", baseFguiPanel)
function SoldierRushMapPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("SoldierRushMapPanel:ctor", self.viewName)
end
function SoldierRushMapPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
	end
	return self._packageList
end
function SoldierRushMapPanel:onInit()
	print("=======SoldierRushMapPanel:onInit")
	self.chapter = self.param.chapter
	self.gate = self.param.gate
	self.id = self.param.id
	self.isPause = false
	self.warnTime = 10
	self.isShowAttr = false
	self.buildList, _ENV, self.useSkillCount = self.param.id, self.param.id, 0
	self.armyQueueNum = 0
	self.isInGameGuide = false
	self.isInGuide = false
	self.isGuide_move = false
	self.isGuide_upgrade = false
	self.isGuide_Occupy = false
	self.isGuide_change = false
	self.isGuide_changeBuff = false
	self.controllers.c1:setSelectedIndex(0)
	self.fields.Com_info:setVisible(false)
	self.fields.Button_menu:addClickListener(handler(self, self.onMenuClick))
	self.fields.cheat:setString("作弊过关")
	self.fields.cheat:setVisible(false)
	if device.platform == "mac" or userSDKManager.isBeta() or userSDKManager.isGameDevelop() then
		self.fields.cheat:setVisible(true)
	end
	self.fields.cheat:addClickListener(handler(self, self.onCheatClick))
	self.fields.Csd_finger:setVisible(false)
	self.fields.com_menu:setVisible(false)
	SoraDPlayStopMusic()
	SoraDPlayMusic("worldMap", "worldMap")
	self:addEventListener(fgui.UIEventType.TouchEnd, function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SOLDIERRUSH_UI_SKILL_INFO"
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_SOLDIERRUSH_UI_BUILD_MENU"
		SoraDSendMessage(nil)
	end)
end
function SoldierRushMapPanel:onShow()
	print("=======SoldierRushMapPanel:onShow")
	self.fields.rangeNode:setGroupID(1, true)
	self.fields.buildNode:setGroupID(2, true)
	self.fields.armyNode:setGroupID(3, true)
	self.fields.lvNode:setGroupID(5, true)
	self.fields.com_menu:setGroupID(9, true)
	self.fields.node_start:setGroupID(99, true)
	self:initMap()
	_ENV = 99
	;(99).callback = handler(self, self.onGameStart)
	;(99).initScale = 1
	;(99).toScale = 0.5
	self.fields.node_start:startGame(99)
end
function SoldierRushMapPanel:initMap()
	local lvCfg = soldierRushRead.getLevelCfg(self.id)
	self.mapCfg = soldierRushRead.getMapCfg(lvCfg.LevelMap)
	self.controllers.c2:setSelectedIndex(self.mapCfg.SceneID)
	self.offset = 30
	dump(self.mapCfg.BuildConstant, "self.mapCfg.BuildConstant==")
	local soldierRushRead, forceCount = dump, dump
	for k, v in ipairs(self.mapCfg.BuildConstant) do
		local buildCfg = soldierRushRead.getBuildCfg(v.bid)
		if not self.buildList[k] then
			self.buildList[k] = fgui.UIPackage:createObjectFromURL("ui://SoldierRush/Com_build")
			self.buildList[k]:setPosition(self:getWidth() / 2 + v.x * self.offset - self.buildList[k]:getWidth() / 2, self:getHeight() / 2 - v.y * self.offset - self.buildList[k]:getHeight() / 2)
			self.view:addChildAt(self.buildList[k], self.view:getChildIndex(self.fields.rangeNode) + 1)
			self.buildList[k]:setGroupID(2)
		end
		self.buildList[k]:initData(v, self.id)
		soldierRushRead = self.id
		self.id.upgradeCD = 0
		self.id.changeCD = 0
		self.id.bType = v.bType
		self.id.lv = v.initLv
		self.id.status = 0
		self.id.armyNum = v.initArmy
		self.id.force = v.force
		self.id.x = v.x
		self.id.y = v.y
		soldierRushCtrl:setBuildInfo(v.bid, self.id)
		soldierRushCtrl:setBuildPosMap(v.bid, self.buildList[k]:localToGlobal(cc.p(60, 60)))
		if not forceCount[v.force] and v.force ~= 2 then
			forceCount[v.force] = 1
		end
	end
	self.fields.Bar_rush:initForceNum(table.nums(forceCount))
	self.fields.Bar_rush:initData()
end
function SoldierRushMapPanel:reStartGame(target, data)
	self.isInGameGuide = false
	self.isInGuide = false
	self.isGuide_move = false
	self.isGuide_upgrade = false
	self.isGuide_Occupy = false
	self.isGuide_change = false
	self.isGuide_changeBuff = false
	self.armyQueueNum = 0
	if self.gameTimer then
		SoraDManagerRemoveTimer(self, self.gameTimer)
		self.gameTimer = nil
	end
	self.fields.com_menu:setVisible(false)
	self.chapter = data.chapter
	self.gate = data.gate
	self.id = data.id
	local levelCfg = soldierRushRead.getLevelCfg(self.id)
	self.GAME_TIME = levelCfg.LevelTime
	self.gameTime = self.GAME_TIME
	self.isPause = false
	self.useSkillCount = 0
	self.controllers.c1:setSelectedIndex(0)
	self.fields.Com_info:setVisible(false)
	for k, v in ipairs(self.buildList) do
		v:reset()
	end
	soldierRushCtrl:reStart()
	self:initMap()
	self:clearEvent()
	_ENV = ipairs(self.buildList)
	ipairs(self.buildList).callback = handler(self, self.onGameStart)
	ipairs(self.buildList).initScale = 1
	ipairs(self.buildList).toScale = 0.5
	self.fields.node_start:startGame(ipairs(self.buildList))
end
function SoldierRushMapPanel:endGame(target, data)
	self.armyQueueNum = 0
	soldierRushCtrl:resetClientData()
	self:clearEvent()
	self:close()
end
function SoldierRushMapPanel:clearEvent()
	if self.arrow then
		self.arrow:removeFromParent()
		self.arrow = nil
	end
	for k, v in ipairs(self.fields.event:getChildren()) do
		if v and not tolua.isnull(v) then
			v:stopAllActions()
			v:removeFromParent()
		end
	end
end
function SoldierRushMapPanel:onGameStart()
	print("=======SoldierRushMapPanel:onGameStart")
	local showRatioID = soldierRushRead.getConstantVal("Send_Soldier_Ratio_Show")
	self.fields.Com_progress:setVisible(self.id == showRatioID or soldierRushCtrl:getGateRecord(showRatioID) and true or false)
	self.fields.Com_progress:initData()
	if self.id == 101 and not soldierRushCtrl:getGateRecord(self.id) then
		self.isGuide_move = true
		_ENV = soldierRushCtrl
		soldierRushCtrl.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		soldierRushCtrl.step = 1100001
		SoraDSendMessage(soldierRushCtrl)
		self.isPause = true
		self.isInGameGuide = true
	end
	if self.id == 103 and not soldierRushCtrl:getGateRecord(self.id) then
		self.isGuide_upgrade = true
		_ENV = soldierRushCtrl
		soldierRushCtrl.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		soldierRushCtrl.step = 1300001
		SoraDSendMessage(soldierRushCtrl)
		self.isPause = true
		self.isInGameGuide = true
	end
	if self.id == 105 and not soldierRushCtrl:getGateRecord(self.id) then
		_ENV = soldierRushCtrl
		soldierRushCtrl.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		soldierRushCtrl.step = 1500001
		SoraDSendMessage(soldierRushCtrl)
		self.isPause = true
		self.isInGameGuide = true
		self.fields.Com_progress:initData(100)
	end
	if self.id == 107 and not soldierRushCtrl:getGateRecord(self.id) then
		self.isGuide_change = true
		_ENV = soldierRushCtrl
		soldierRushCtrl.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		soldierRushCtrl.step = 1400001
		SoraDSendMessage(soldierRushCtrl)
		self.isPause = true
		self.isInGameGuide = true
	end
	if self.id == 109 and not soldierRushCtrl:getGateRecord(self.id) then
		self.isGuide_changeBuff = true
		_ENV = soldierRushCtrl
		soldierRushCtrl.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		soldierRushCtrl.step = 1600001
		SoraDSendMessage(soldierRushCtrl)
		self.isPause = true
		self.isInGameGuide = true
	end
	self.controllers.c1:setSelectedIndex(1)
	self:initMap()
	local levelCfg = soldierRushRead.getLevelCfg(self.id)
	self.GAME_TIME = levelCfg.LevelTime
	self.gameTime = self.GAME_TIME
	self.useSkillCount = 0
	self.fields.Com_skill:initData()
	self:initGameTimer()
end
function SoldierRushMapPanel:initGameTimer()
	if not self.gameTimer then
		self.gameTimer = SoradCreateTimer(self, handler(self, self.updateTime))
		self.fields.Com_timer:setString(SoraDConvertSecondToString(self.gameTime))
		self:updateTime()
	end
end
function SoldierRushMapPanel:getStar(starType, val1, val2, val3)
	local star = 0
	if starType == 1 then
		if soldierRushCtrl:isWin() and val1 > self.GAME_TIME - self.gameTime then
			star = 1
		end
	elseif starType == 2 then
		local num = 0
		for k, v in ipairs(soldierRushCtrl:getBuildList()) do
			if v.force == 1 and val1 <= v.lv then
				if val2 == 0 then
					num = num + 1
				elseif val2 == 1 and v.bType == 1 then
					num = num + 1
				elseif val2 == 2 and v.bType == 2 then
					num = num + 1
				elseif val2 == 3 and v.bType == 3 then
					num = num + 1
				end
			end
		end
		star = val3 <= num and 1 or 0
	elseif starType == 3 then
		if val1 > self.useSkillCount then
			star = 1
		end
	elseif starType == 4 then
		local num = 0
		for k, v in ipairs(soldierRushCtrl:getBuildList()) do
			if v.force == 1 then
				if val1 == 0 and val2 <= v.lv then
					num = num + 1
				elseif val1 == 1 and v.bType == 1 and val2 <= v.lv then
					num = num + 1
				elseif val1 == 2 and v.bType == 2 and val2 <= v.lv then
					num = num + 1
				elseif val1 == 3 and v.bType == 3 and val2 <= v.lv then
					num = num + 1
				end
			end
		end
		star = 0 < num and 1 or 0
	end
	return star
end
function SoldierRushMapPanel:getStarInfo()
	local soldierRushCtrl, starInfo
	starInfo[1] = soldierRushCtrl:isWin() and 1 or 0
	local lvCfg = soldierRushRead.getLevelCfg(self.id)
	starInfo[2] = self:getStar(lvCfg.StarCondition1[1], lvCfg.StarCondition1[2], lvCfg.StarCondition1[3], lvCfg.StarCondition1[4])
	starInfo[3] = self:getStar(lvCfg.StarCondition2[1], lvCfg.StarCondition2[2], lvCfg.StarCondition2[3], lvCfg.StarCondition2[4])
	return starInfo
end
function SoldierRushMapPanel:updateTime()
	if not self.isPause then
		if self.gameTime <= 0 then
			if self.gameTimer then
				SoraDManagerRemoveTimer(self, self.gameTimer)
				self.gameTimer = nil
			end
			soldierRushCtrl:setCurStarInfo(self:getStarInfo())
			_ENV = self:getStarInfo()
			self:getStarInfo().id = self.id
			self:getStarInfo().chapter = self.chapter
			self:getStarInfo().gate = self.gate
			uiManager:show("SoldierRushLose", self:getStarInfo())
			soldierRushCtrl:sendWin(self.id, self:getStarInfo(), 0)
			self.isPause = true
			return
		end
		if soldierRushCtrl:isWin() then
			soldierRushCtrl:sendWin(self.id, self:getStarInfo(), 1)
			self.isPause = true
			return
		end
		if soldierRushCtrl:isLost() then
			soldierRushCtrl:setCurStarInfo(self:getStarInfo())
			_ENV = self:getStarInfo()
			self:getStarInfo().id = self.id
			self:getStarInfo().chapter = self.chapter
			self:getStarInfo().gate = self.gate
			uiManager:show("SoldierRushLose", self:getStarInfo())
			soldierRushCtrl:sendWin(self.id, self:getStarInfo(), 0)
			self.isPause = true
			return
		end
		self.fields.Bar_rush:initData()
		for k, v in ipairs(self.buildList) do
			v:update()
		end
		if self.fields.com_menu:isVisible() then
			self.fields.com_menu:update()
		end
		self.fields.Com_timer:setString(SoraDConvertSecondToString(self.gameTime))
		self.fields.Com_timer:setTitleColor(self.gameTime > self.warnTime and cc.c3b(125, 230, 195) or cc.c3b(190, 40, 40))
		self.gameTime = self.gameTime - 1
	end
end
function SoldierRushMapPanel:onGameContinue()
	self.isPause = false
	self:getActionManager():resumeTarget(self)
	soldierRushCtrl:resumeQueue()
	for k, v in ipairs(self.buildList) do
		v:resumeEffect()
	end
end
function SoldierRushMapPanel:continuePlay()
	self.isGuide_change = false
	self.isPause = false
	self.isInGameGuide = false
	self.isGuide_changeBuff = false
end
function SoldierRushMapPanel:showSkillInfo(target, data)
	if data and data.index then
		self.fields.Com_info:setVisible(true)
		self.fields.Com_info:initData(data.index)
	else
		self.fields.Com_info:setVisible(false)
	end
end
function SoldierRushMapPanel:onClickClose()
	if self.isInGameGuide then
		return
	end
	if self.gameTime and self.gameTime > 0 then
		self.isPause = true
		_ENV = nil
		;(nil).id = self.id
		;(nil).chapter = self.chapter
		;(nil).gate = self.gate
		uiManager:show("SoldierRushPause", nil)
		self:getActionManager():pauseTarget(self)
		soldierRushCtrl:pauseQueue()
		for k, v in ipairs(self.buildList) do
			v:pauseEffect()
		end
	else
		self:close()
	end
end
function SoldierRushMapPanel:onMenuClick()
	SoraDPlaySound()
	self.isShowAttr = not self.isShowAttr
	_ENV = nil
	;(nil).msg = "MESSAGE_SOLDIERRUSH_UI_ATTR_SHOW"
	;(nil).isShow = self.isShowAttr
	SoraDSendMessage(nil)
end
function SoldierRushMapPanel:onCheatClick()
	SoraDPlaySound()
	_UPVALUE3_ = nil
	;(nil)[1] = 1
	;(nil)[2] = 1
	;(nil)[3] = 1
	soldierRushCtrl:sendWin(self.id, nil, 1)
end
function SoldierRushMapPanel:showArrow(target, data)
	if data.bid and self.buildList[data.bid] then
		if self.arrow then
			self.arrow:setVisible(true)
		else
			self.arrow = fgui.UIPackage:createObjectFromURL("ui://SoldierRush/Com_arrow")
			self.arrow:setScale(0.5)
			self.arrow:addTo(self.fields.event)
		end
		local curPos = self.buildList[data.bid]:localToGlobal(cc.p(60, 60))
		curPos = self.fields.event:globalToLocal(curPos)
		local toPos = self.fields.event:globalToLocal(data.toPos)
		self.arrow:setPosition(curPos)
		local rotation = SoraDGetAngleByPos(toPos, curPos)
		local distance = math.sqrt((toPos.x - curPos.x) * (toPos.x - curPos.x) + (toPos.y - curPos.y) * (toPos.y - curPos.y)) * 2
		self.arrow:setRotation(rotation)
		self.arrow:setWidth(distance)
		local toBid = soldierRushCtrl:getBuildByPos(data.toPos)
		if toBid and toBid ~= data.bid and self.buildList[toBid] then
			if self.arrow:getAlpha() < 1.0 then
				self.arrow:runAction(ffa.fadeIn(0.1))
			end
			self.buildList[toBid]:setChooseVisible(true)
			if self.tempToBid and self.tempToBid ~= toBid then
				self.buildList[self.tempToBid]:setChooseVisible(false)
			end
			self.tempToBid = toBid
		else
			if self.arrow:getAlpha() >= 1.0 then
				self.arrow:runAction(ffa.fadeTo(0.1, 0.5))
			end
			if self.tempToBid then
				self.buildList[self.tempToBid]:setChooseVisible(false)
			end
		end
	else
		if self.arrow then
			self.arrow:setVisible(false)
		end
		if self.tempToBid then
			self.buildList[self.tempToBid]:setChooseVisible(false)
		end
	end
end
function SoldierRushMapPanel:showArmy(target, data)
	local toBid = data.toBid
	if toBid and self.buildList[toBid] and toBid ~= data.bid then
		self.buildList[toBid]:setChooseVisible(false)
		self.armyQueueNum = self.armyQueueNum + 1
		local armyGroup = fgui.UIPackage:createObjectFromURL("ui://SoldierRush/Com_armyGroup")
		armyGroup:addTo(self.fields.event, -1)
		armyGroup.num = data.num or 8
		armyGroup.force = data.force
		armyGroup.toBid = toBid
		armyGroup.index = self.armyQueueNum
		armyGroup:setVisible(false)
		local curBuild = self.buildList[data.bid]
		local curPos = curBuild:localToGlobal(cc.p(60, 60))
		curPos = self.fields.event:globalToLocal(curPos)
		local toBuild = self.buildList[toBid]
		local toPos = toBuild:localToGlobal(cc.p(60, 60))
		toPos = self.fields.event:globalToLocal(toPos)
		armyGroup:setPosition(curPos)
		local rotation = SoraDGetAngleByPos(toPos, curPos)
		local distance = math.sqrt((toPos.x - curPos.x) * (toPos.x - curPos.x) + (toPos.y - curPos.y) * (toPos.y - curPos.y))
		local index, dir, isFlipX = soldierRushRead.getArmyShowCfg(rotation)
		local armyCfg = soldierRushRead.getArmyConfig(data.force, self.id)
		armyGroup:setGroupCfg(index, dir, isFlipX, data.force, data.num)
		armyGroup:setGroupID(3)
		if data.force == 1 then
			soldierRushCtrl:addArmyQueue(armyGroup)
		else
			soldierRushCtrl:addEnemyQueue(armyGroup)
		end
		local offsetCfg = soldierRushRead.getDirOffset(index)
		soldierRushRead = isFlipX
		isFlipX[1] = ffa.delay(data.gIndex * soldierRushRead.getConstantVal("Send_Soldier_Time") / 1000)
		isFlipX[2] = ffa.callFunc(function()
			if armyGroup and not tolua.isnull(armyGroup) then
				_ENV = nil
				_ENV = nil
				;(nil)[1] = ffa.callFunc(function()
					armyGroup:inAct(distance / armyCfg.Speed)
					armyGroup:setVisible(true)
				end)
				;(nil)[2] = ffa.moveTo(distance / armyCfg.Speed, toPos.x + offsetCfg.x, toPos.y + offsetCfg.y)
				;(nil)[3] = ffa.moveTo(distance / armyCfg.Speed, toPos.x + offsetCfg.x, toPos.y + offsetCfg.y)
				;(nil)[4] = ffa.moveTo(distance / armyCfg.Speed, toPos.x + offsetCfg.x, toPos.y + offsetCfg.y)
				;(nil)[5] = ffa.moveTo(distance / armyCfg.Speed, toPos.x + offsetCfg.x, toPos.y + offsetCfg.y)
				;(nil)[6] = ffa.moveTo(distance / armyCfg.Speed, toPos.x + offsetCfg.x, toPos.y + offsetCfg.y)
				;(nil)[1] = ffa.spawn(nil)
				;(nil)[2] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[3] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[4] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[5] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[6] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[7] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[8] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				armyGroup:runAction(ffa.seq(nil))
			end
		end)
		isFlipX[3] = ffa.callFunc(function()
			if armyGroup and not tolua.isnull(armyGroup) then
				_ENV = nil
				_ENV = nil
				;(nil)[1] = ffa.callFunc(function()
					armyGroup:inAct(distance / armyCfg.Speed)
					armyGroup:setVisible(true)
				end)
				;(nil)[2] = ffa.moveTo(distance / armyCfg.Speed, toPos.x + offsetCfg.x, toPos.y + offsetCfg.y)
				;(nil)[3] = ffa.moveTo(distance / armyCfg.Speed, toPos.x + offsetCfg.x, toPos.y + offsetCfg.y)
				;(nil)[4] = ffa.moveTo(distance / armyCfg.Speed, toPos.x + offsetCfg.x, toPos.y + offsetCfg.y)
				;(nil)[5] = ffa.moveTo(distance / armyCfg.Speed, toPos.x + offsetCfg.x, toPos.y + offsetCfg.y)
				;(nil)[6] = ffa.moveTo(distance / armyCfg.Speed, toPos.x + offsetCfg.x, toPos.y + offsetCfg.y)
				;(nil)[1] = ffa.spawn(nil)
				;(nil)[2] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[3] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[4] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[5] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[6] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[7] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[8] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				armyGroup:runAction(ffa.seq(nil))
			end
		end)
		isFlipX[4] = ffa.callFunc(function()
			if armyGroup and not tolua.isnull(armyGroup) then
				_ENV = nil
				_ENV = nil
				;(nil)[1] = ffa.callFunc(function()
					armyGroup:inAct(distance / armyCfg.Speed)
					armyGroup:setVisible(true)
				end)
				;(nil)[2] = ffa.moveTo(distance / armyCfg.Speed, toPos.x + offsetCfg.x, toPos.y + offsetCfg.y)
				;(nil)[3] = ffa.moveTo(distance / armyCfg.Speed, toPos.x + offsetCfg.x, toPos.y + offsetCfg.y)
				;(nil)[4] = ffa.moveTo(distance / armyCfg.Speed, toPos.x + offsetCfg.x, toPos.y + offsetCfg.y)
				;(nil)[5] = ffa.moveTo(distance / armyCfg.Speed, toPos.x + offsetCfg.x, toPos.y + offsetCfg.y)
				;(nil)[6] = ffa.moveTo(distance / armyCfg.Speed, toPos.x + offsetCfg.x, toPos.y + offsetCfg.y)
				;(nil)[1] = ffa.spawn(nil)
				;(nil)[2] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[3] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[4] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[5] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[6] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[7] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				;(nil)[8] = ffa.callFunc(function()
					print("========== showArmy callback")
					if tolua.isnull(self) then
						return
					end
					local targetBuild = self.buildList[toBid]
					targetBuild:event(toBid, armyGroup.force, armyGroup.num)
					if self.fields.com_menu:isVisible() then
						self.fields.com_menu:update()
					end
					if armyGroup.force == 1 then
						soldierRushCtrl:removeArmyQueue(armyGroup)
					else
						soldierRushCtrl:removeEnemyQueue(armyGroup)
					end
					if armyGroup and not tolua.isnull(armyGroup) then
						print("armyGroup:removeFromParent")
						armyGroup:removeFromParent()
					end
				end)
				armyGroup:runAction(ffa.seq(nil))
			end
		end)
		self:runAction(ffa.seq(isFlipX))
		if self.isGuide_move then
			self.fields.Csd_finger:setVisible(false)
			self.fields.Csd_finger:stopAllActions()
			self.isPause = false
			_ENV = self.fields.Csd_finger
			self.fields.Csd_finger.msg = "MESSAGE_SERVER_GUIDE_STEP_END"
			self.fields.Csd_finger.step = 1100003
			SoraDSendMessage(self.fields.Csd_finger)
		end
	end
end
function SoldierRushMapPanel:upgradeBuild(target, data)
	local buildInfo = self.buildList[data.bid]
	local buildCfg = soldierRushRead.getBuildCfgByTypeAndLv(buildInfo.bType, buildInfo.lv)
	buildInfo:upgrade(buildCfg.UpgradeCost, buildCfg.UpgradeCD)
	if self.isGuide_upgrade then
		self.isPause = false
		self.isInGameGuide = false
	end
end
function SoldierRushMapPanel:guideUpgradeBuild(target, data)
	if self.isGuide_upgrade then
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		;(nil).step = 1300004
		SoraDSendMessage(nil)
		self.isGuide_upgrade = false
	end
end
function SoldierRushMapPanel:hideMineGuideArrow(target, data)
	for k, v in ipairs(self.buildList) do
		v:hideGuideArrow()
	end
end
function SoldierRushMapPanel:changeBuild(target, data)
	local buildInfo = self.buildList[data.bid]
	local changeCD = soldierRushRead.getConstantVal("Build_Change_Cd")
	local changeCDPro = technologyCtrl:getTechnologyPower(gTechnologyType.SOLDIER_RUSH_SWITCH_BUILD_REDUCE_CD) or 0
	changeCD = math.ceil(changeCD * (1 - changeCDPro))
	buildInfo:change(data.cost, changeCD)
	if self.isGuide_change then
		self.isPause = false
		self.isInGameGuide = false
	end
	technologyCtrl = changeCD
	changeCD[1] = ffa.delay(changeCD)
	changeCD[2] = ffa.callFunc(function()
		buildInfo:doneChange(data.toBtype)
		if self.isGuide_change then
			self.isPause = true
			self.isInGameGuide = true
			print("启动妹子===========")
			buildInfo = "启动妹子==========="
			;("启动妹子===========").msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
			;("启动妹子===========").step = 1400004
			SoraDSendMessage("启动妹子===========")
		end
	end)
	changeCD[3] = ffa.callFunc(function()
		buildInfo:doneChange(data.toBtype)
		if self.isGuide_change then
			self.isPause = true
			self.isInGameGuide = true
			print("启动妹子===========")
			buildInfo = "启动妹子==========="
			;("启动妹子===========").msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
			;("启动妹子===========").step = 1400004
			SoraDSendMessage("启动妹子===========")
		end
	end)
	buildInfo:runAction(ffa.seq(changeCD))
end
function SoldierRushMapPanel:menuShow(target, data)
	if data and data.bid and soldierRushCtrl:getBuildInfo(data.bid) then
		self.fields.com_menu:setVisible(data.isOpen)
		self.fields.com_menu:init(data.bid, self.id)
		local pos = soldierRushCtrl:getBuildMap(data.bid)
		pos = self.fields.event:globalToLocal(pos)
		self.fields.com_menu:setPosition(pos.x, pos.y + 85)
	else
		self.fields.com_menu:setVisible(false)
	end
end
function SoldierRushMapPanel:guideOccupy(target, data)
	if self.isGuide_move and not self.isGuide_Occupy and data.bid == 2 then
		self.isGuide_Occupy = true
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		;(nil).step = 1200001
		SoraDSendMessage(nil)
		self.isPause = true
	end
end
function SoldierRushMapPanel:onHide()
	print("=======SoldierRushMapPanel:onHide")
	SoraDPlayStopMusic()
	SoraDPlayMusic("mainCity", "mainCity")
end
function SoldierRushMapPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "guideMove" then
		if not self.isInGuide then
			self.isInGuide = true
			self.fields.Csd_finger:setIsLoop(false)
			local fromBuild = self.buildList[parameters.fromID]
			local fromPos = fromBuild:localToGlobal(cc.p(60, 60))
			fromPos = self:globalToLocal(fromPos)
			local toBuild = self.buildList[parameters.toID]
			local toPos = toBuild:localToGlobal(cc.p(60, 60))
			toPos = self:globalToLocal(toPos)
			self.fields.Csd_finger:setPosition(fromPos.x, fromPos.y)
			_UPVALUE7_ = cc.p(60, 60)
			cc.p(60, 60)[1] = ffa.callFunc(function()
				self.fields.Csd_finger:setVisible(true)
				self.fields.Csd_finger:playOnce()
			end)
			cc.p(60, 60)[2] = ffa.scaleTo(0.1, 1.2)
			cc.p(60, 60)[3] = ffa.scaleTo(0.1, 1)
			cc.p(60, 60)[4] = ffa.delay(0.2)
			cc.p(60, 60)[5] = ffa.moveTo(1.5, toPos.x, toPos.y)
			cc.p(60, 60)[6] = ffa.callFunc(function()
				self.fields.Csd_finger:playOnce()
			end)
			cc.p(60, 60)[7] = ffa.delay(0.5)
			cc.p(60, 60)[8] = ffa.callFunc(function()
				self.fields.Csd_finger:setVisible(false)
				self.fields.Csd_finger:setPosition(fromPos.x, fromPos.y)
			end)
			cc.p(60, 60)[9] = ffa.callFunc(function()
				self.fields.Csd_finger:setVisible(false)
				self.fields.Csd_finger:setPosition(fromPos.x, fromPos.y)
			end)
			self.fields.Csd_finger:runAction(ffa.repeatForever(ffa.seq(cc.p(60, 60))))
		end
	elseif itemName == "build" then
		if parameters.isStopGuide then
			self.isPause = false
			self.isInGameGuide = false
		end
		return self.buildList[parameters.ID]
	elseif itemName == "build_top" then
		return self.buildList[parameters.ID]:getTopLv()
	elseif itemName == "upgrade" then
		return self.fields.com_menu:getUpgradeBtn()
	elseif itemName == "changeTower" then
		return self.fields.com_menu:getTowerBtn()
	elseif itemName == "changeBuff" then
		return self.fields.com_menu:getBuffBtn()
	elseif itemName == "dispatchPro" then
		self.isPause = false
		self.isInGameGuide = false
		return self.fields.Com_progress:getBtnIndex(parameters.index)
	else
		return self.fields[itemName]
	end
end
return SoldierRushMapPanel
