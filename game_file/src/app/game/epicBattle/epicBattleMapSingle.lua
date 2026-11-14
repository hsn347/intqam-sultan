local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicBattleDef = include("epicBattleDef")
local publicRead = include("publicRead")
local epicBattleMapSingle = class("epicBattleMapSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicBattleMapSingle")
	end
	return target
end)
function epicBattleMapSingle:ctor()
	self.data = nil
	self.frame_target = SoraDGetChildByName(self, "frame_target")
	self.frame_target:setVisible(false)
	self.etPetCardNode = SoraDGetChildByName(self, "et_petcard_unlock_node")
	self.etPetCardNode:setVisible(false)
	self.Node_effect = SoraDGetChildByName(self, "Node_effect")
	self.Node_lock = SoraDGetChildByName(self, "Node_lock")
	self.Node_lock:setVisible(false)
	self.Node_progress = SoraDGetChildByName(self, "Node_progress")
	self.Node_progress:setVisible(false)
	self.sp_progressbg = SoraDGetChildByName(self, "spriteLoadingBarBg")
	self.sp_progressbg:setGroupID(epicBattleDef.groupDef.progressbg)
	self.Node_pro = SoraDGetChildByName(self, "Node_pro")
	self.LoadingBar_bar = SoraDGetChildByName(self, "LoadingBar_bar")
	self.LoadingBar_bar_act = SoraDGetChildByName(self, "LoadingBar_bar_act")
	self.Node_pro:setGroupID(epicBattleDef.groupDef.progress)
	self.Node_pro:setGroupAuto(true)
	self.Text_percent = SoraDGetChildByName(self, "Text_percent")
	self.Text_percent:setGroupID(epicBattleDef.groupDef.progersstext)
	self.Text_percent:setGroupAuto(true)
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Panel_touch:setTouchEnabled(true)
	self.Panel_touch:setSwallowTouches(false)
	self.Panel_touch:addTouchEventListener(handler(self, self.onTouchBack))
	self.Node_xr1 = SoraDGetChildByName(self, "Node_xr1")
	self.Node_xr2 = SoraDGetChildByName(self, "Node_xr2")
	self.Node_chjt = SoraDGetChildByName(self, "Node_chjt")
	self.Node_jtgj = SoraDGetChildByName(self, "Node_jtgj")
	self.Node_jssb = SoraDGetChildByName(self, "Node_jssb")
	self.Node_gjsw = SoraDGetChildByName(self, "Node_gjsw")
	self.Node_xr = SoraDGetChildByName(self, "Node_xr")
	self.Node_jztx = SoraDGetChildByName(self, "Node_jztx")
	self.frame_bossPre = SoraDGetChildByName(self, "frame_bossPre")
	self.frame_bossPre:setVisible(false)
	self.frame_select = SoraDGetChildByName(self, "frame_select")
	self.frame_select:setVisible(false)
	self.Node_nextGate = SoraDGetChildByName(self, "Node_nextGate")
	self.Node_nextGate:setVisible(false)
	self.Text_nextGate = SoraDGetChildByName(self, "Text_nextGate")
	self.Text_nextGate:setString(i18n("tactic_next_stage_name"))
	self.Text_nextGate:enableShadow(cc.c3b(0, 0, 0), cc.size(1, -1))
	self.Node_next1 = SoraDGetChildByName(self, "Node_next1")
	self.Node_next2 = SoraDGetChildByName(self, "Node_next2")
	self.Node_Strategys = SoraDGetChildByName(self, "Node_Strategys")
	self.Node_Strategys:setVisible(false)
	self.Image_quality = SoraDGetChildByName(self, "Image_quality")
	self.Image_strategy = SoraDGetChildByName(self, "Image_strategy")
	self.Node_etCL = SoraDGetChildByName(self.Node_Strategys, "Node_etCL")
	self.Node_etGB = SoraDGetChildByName(self.Node_Strategys, "Node_etGB")
end
function epicBattleMapSingle:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_DESTORY_TOWER", handler(self, self.showDestoryEffect))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_TOWER_ATTACK", handler(self, self.showTowerAttackEffect))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_DAMAGE_BOSS", handler(self, self.showDamageBossEffect))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_WEEK_BOSS", handler(self, self.showWeekEffect))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_FINISH_CHALLENGE", handler(self, self.showNextGateEffect))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_ATTACK_FAIL", handler(self, self.showAttackFailEffect))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_ATTACK_WIN", handler(self, self.showAttackWinEffect))
end
function epicBattleMapSingle:initData(data, x, y, isUnlock, unlockPos, nextStage)
	epicWarCtrl, self.data = nil, data
	;(nil).x = x
	self.pos, (nil).y = nil, y
	self.isCanExplore = false
	self.isUnlock = isUnlock
	self.unlockPos = unlockPos
	self.nextStage = nextStage
	if self.nextStage then
		self.bossLock = nil
		self.isAction = nil
		self:deleteBuildEffect()
		self:deleteRelexEffect()
	end
	self:deleteWeekEffect()
	self:deleteBossSeeEffect()
	self:deleteNextGateEffect()
	if self.data.isReal then
		if self.isUnlock and self.unlockPos and self.unlockPos.x == x and self.unlockPos.y == y then
			self:unlockAction()
		else
			self:setInstanceByPointType()
		end
	else
		if epicWarCtrl:isHaveAliveBoss(self.pos.x, self.pos.y) or self.data.status == epicBattleDef.gBoardPointStatusEnum.LOCK then
			self:setExploreLockForest()
		elseif self.bossLock then
			self:unlockForest()
			self.bossLock = nil
		else
			self.isCanExplore = epicWarCtrl:isHaveExploredSpace(self.pos.x, self.pos.y)
			if self.isCanExplore then
				self:setExploreForest()
			else
				self:setLockForest()
			end
		end
		self:checkBossSeeEffect()
	end
end
function epicBattleMapSingle:copyMe()
	local copyItem = include("epicBattleMapSingle").new(self:clone())
	copyItem:initData(self.data, self.pos.x, self.pos.y)
	copyItem.sp_progressbg:setGroupID(0)
	copyItem.Node_pro:setGroupID(0)
	copyItem.Text_percent:setGroupID(0)
	return copyItem
end
function epicBattleMapSingle:setHandle(handle)
	self.handle = handle
end
function epicBattleMapSingle:getPos()
	return self.pos
end
function epicBattleMapSingle:unlockAction()
	if self.unlockPos.x == self.pos.x and self.unlockPos.y == self.pos.y then
		self.Node_effect:removeAllChildren()
		self.Node_effect:setVisible(true)
		_ENV, _ENV = self.Node_effect, self.Node_effect.setVisible
		self.Node_effect.plist = "et_sszzslxs_02.plist"
		_ENV, self.Node_effect.setVisible[1], self.Node_effect.scale = self.Node_effect, self.Node_effect, 1.35
		self.Node_effect.setVisible[2], self.Node_effect.plist = self.Node_effect, "et_sszzslxs_01.plist"
		local param = self.Node_effect.setVisible
		local et_node = SoraDCreateEffectNode(param)
		SoraDStopEffectNode(et_node)
		et_node:addTo(self.Node_effect)
		_UPVALUE3_ = et_node
		et_node[1] = cca.callFunc(function()
			SoraDResetEffectNode(et_node)
		end)
		et_node[2] = cca.fadeOut(0.2)
		et_node[3] = cca.delay(0.3)
		et_node[4] = cca.callFunc(function()
			self:setInstanceByPointType()
		end)
		et_node[5] = cca.callFunc(function()
			self:setInstanceByPointType()
		end)
		local seq = cca.seq(et_node)
		self.frame_target:runAction(seq)
	end
end
function epicBattleMapSingle:unlockForest()
	local runAnimation = function()
		self.Node_lock:setVisible(false)
		local etLockParticle = SoraDGetChildByName(self.etPetCardNode, "et_lock_particle")
		etLockParticle:resetSystem()
		self.etPetCardNode:setVisible(true)
		local etPetCardNode = SoraDGetChildByName(self.etPetCardNode, "node_unlok_effect")
		SoraDCreatAnimation("petCarUnlock", etPetCardNode, false)
	end
	_UPVALUE2_ = nil
	;(nil)[1] = cca.callFunc(function()
		runAnimation()
	end)
	;(nil)[2] = cca.delay(0.5)
	;(nil)[3] = cca.callFunc(function()
		self.isCanExplore = epicWarCtrl:isHaveExploredSpace(self.pos.x, self.pos.y)
		if self.isCanExplore then
			self:setExploreForest()
		else
			self:setLockForest()
		end
	end)
	;(nil)[4] = cca.callFunc(function()
		self.isCanExplore = epicWarCtrl:isHaveExploredSpace(self.pos.x, self.pos.y)
		if self.isCanExplore then
			self:setExploreForest()
		else
			self:setLockForest()
		end
	end)
	local seq = cca.seq(nil)
	self.frame_target:runAction(seq)
end
function epicBattleMapSingle:setLockForest()
	self.frame_target:stopAllActions()
	self.frame_target:setScale(1.0)
	self.frame_target:setPosition(0, 25)
	self.frame_target:setVisible(true)
	self.frame_target:setSpriteFrame("frame_ditu_zhiwu.png")
	self.etPetCardNode:setVisible(false)
	self.Node_effect:setVisible(false)
	self.Node_lock:setVisible(false)
	self.Node_progress:setVisible(false)
	self.Node_nextGate:setVisible(false)
	self.Node_Strategys:setVisible(false)
	self:setGray()
end
function epicBattleMapSingle:setExploreForest()
	self.frame_target:stopAllActions()
	self.frame_target:setScale(1.0)
	self.frame_target:setPosition(0, 25)
	self.frame_target:setVisible(true)
	self.frame_target:setSpriteFrame("frame_ditu_zhiwu.png")
	self.etPetCardNode:setVisible(false)
	self.Node_effect:setVisible(true)
	self.Node_lock:setVisible(false)
	self.Node_progress:setVisible(false)
	self.Node_nextGate:setVisible(false)
	self.Node_Strategys:setVisible(false)
	self:addUnlockTreeEffect()
	self:setNormal()
end
function epicBattleMapSingle:getBossArmyInfo()
	local curNum = 0
	local oriNum = 0
	local percent = 100
	for k, v in pairs(self.data.eventData.eventParam.curArmyList) do
		curNum = curNum + v
	end
	for k, v in pairs(self.data.eventData.eventParam.originalArmyList) do
		oriNum = oriNum + v
	end
	percent = curNum * 100 / oriNum
	return curNum, oriNum, percent
end
function epicBattleMapSingle:getBossRelexTimes()
	local relexTimes = 0
	if self.data.eventData.eventParam.relexTimes then
		relexTimes = self.data.eventData.eventParam.relexTimes
	end
	return relexTimes
end
function epicBattleMapSingle:isBossWeek()
	local ret = false
	if self.data.eventData.eventParam.strategyDemageReduce and self.data.eventData.eventParam.strategyDemageReduce > 0 then
		ret = true
	end
	return ret
end
function epicBattleMapSingle:setExploreLockForest()
	self.frame_target:stopAllActions()
	self.frame_target:setScale(1.0)
	self.frame_target:setPosition(0, 25)
	self.frame_target:setVisible(true)
	self.frame_target:setSpriteFrame("frame_ditu_zhiwu.png")
	self.etPetCardNode:setVisible(false)
	self.Node_effect:setVisible(false)
	self.Node_lock:setVisible(true)
	self.Node_progress:setVisible(false)
	self.Node_nextGate:setVisible(false)
	self.Node_Strategys:setVisible(false)
	self:setGray()
	self.bossLock = true
end
function epicBattleMapSingle:setBox()
	if self.isAction then
		return
	end
	self.isAction = true
	self.frame_target:stopAllActions()
	self.frame_target:setVisible(true)
	self:setNormal()
	_UPVALUE1_ = self
	self[1] = cca.callFunc(function()
		self.frame_target:setSpriteFrame("zwbx_01.png")
		local framesBx = display.newFrames("zwbx_%.2d.png", 1, 6)
		framesBx[#framesBx + 1] = cc.SpriteFrameCache:getInstance():getSpriteFrame("zwbx_01.png")
		local animationBx = display.newAnimation(framesBx, 1.2 / #framesBx)
		self.frame_target:playAnimationOnce(animationBx)
	end)
	self[2] = cca.delay(2)
	self[3] = cca.delay(2)
	self[4] = cca.delay(2)
	local seq = cca.seq(self)
	self.frame_target:runAction(cc.RepeatForever:create(seq))
	self.frame_target:setScale(0.8)
	self.frame_target:setPosition(0, 20)
	self:addTreasureBoxEffect()
	self.Node_effect:setVisible(true)
	self.etPetCardNode:setVisible(false)
	self.Node_lock:setVisible(false)
	self.Node_progress:setVisible(false)
	self.Node_nextGate:setVisible(false)
	self.Node_Strategys:setVisible(false)
end
function epicBattleMapSingle:setHome()
	self.frame_target:stopAllActions()
	self.frame_target:setSpriteFrame("frame_ditu_chushijianzhu.png")
	self:setNormal()
	self.frame_target:setVisible(true)
	self.frame_target:setPosition(0, 35)
	self.etPetCardNode:setVisible(false)
	self.Node_effect:setVisible(false)
	self.Node_lock:setVisible(false)
	self.Node_progress:setVisible(false)
	self.Node_Strategys:setVisible(false)
	self.Node_nextGate:setVisible(epicWarCtrl:getCurGateIndex() ~= 10)
	if epicWarCtrl:isBossKilled() then
		self:showNextGateEffect()
	else
		self:deleteNextGateEffect()
	end
end
function epicBattleMapSingle:setGuard()
	local status = self.data.eventData and self.data.eventData.status
	if status and status == epicBattleDef.gBoardEventStatusEnum.COMPLETE then
		self:setSpace()
		self.isAction = nil
		return
	end
	self.Node_jssb:setVisible(false)
	self.Node_gjsw:setVisible(false)
	self.Node_progress:setVisible(true)
	local curNum, oriNum, percent = self:getBossArmyInfo()
	if self.barTimer then
		SoraDManagerRemoveTimer(self, self.barTimer)
		self.barTimer = nil
	end
	local prePercent = self.LoadingBar_bar:getPercent()
	if prePercent ~= percent then
		self.barTimer = SoradCreateTimer(self, function(...)
			if prePercent == percent then
				return
			end
			local preValue = (percent - prePercent) / 35
			if self.LoadingBar_bar_act then
				self.LoadingBar_bar_act:setPercent(prePercent)
			end
		end, true)
	else
		self.LoadingBar_bar_act:setPercent(percent)
	end
	self.LoadingBar_bar:setPercent(percent)
	self.Text_percent:setString(curNum)
	local relexTimes = self:getBossRelexTimes()
	print("relexTimes========", relexTimes, self.data.status)
	if 0 < relexTimes then
		self:showRelexEffect()
	else
		self:deleteRelexEffect()
	end
	local isWeek = self:isBossWeek()
	if isWeek then
		epicBattleDef = nil
		;(nil).pos = self.pos
		self:showWeekEffect(self, nil)
	else
		self:deleteWeekEffect()
	end
	self.frame_target:setScale(0.8)
	self.frame_target:setPosition(0, 20)
	self.Node_effect:setVisible(false)
	self.etPetCardNode:setVisible(false)
	self.Node_lock:setVisible(false)
	self.Node_nextGate:setVisible(false)
	self.Node_Strategys:setVisible(false)
	self.frame_target:setVisible(true)
	self:setNormal()
	local ret = _G.SoraDIsFileExistByKey("worldMapBossNormal")
	if not self.isAction then
		self.frame_target:setSpriteFrame("pjys_dj_ws_01.png")
	else
		return
	end
	self.isAction = true
	self.frame_target:stopAllActions()
	local framesGuard = display.newFrames("pjys_dj_ws_%.2d.png", 1, 8)
	local animationGuard = display.newAnimation(framesGuard, 1.2 / #framesGuard)
	self.frame_target:playAnimationForever(animationGuard)
end
function epicBattleMapSingle:setBoss()
	local status = self.data.eventData and self.data.eventData.status
	if status and status == epicBattleDef.gBoardEventStatusEnum.COMPLETE then
		self:setSpace()
		self.isAction = nil
		return
	end
	self.Node_jssb:setVisible(false)
	self.Node_gjsw:setVisible(false)
	self.Node_progress:setVisible(true)
	local curNum, oriNum, percent = self:getBossArmyInfo()
	if self.barTimer then
		SoraDManagerRemoveTimer(self, self.barTimer)
		self.barTimer = nil
	end
	local prePercent = self.LoadingBar_bar:getPercent()
	if prePercent ~= percent then
		self.barTimer = SoradCreateTimer(self, function(...)
			if prePercent == percent then
				return
			end
			local preValue = (percent - prePercent) / 35
			if self.LoadingBar_bar_act then
				self.LoadingBar_bar_act:setPercent(prePercent)
			end
		end, true)
	else
		self.LoadingBar_bar_act:setPercent(percent)
	end
	self.LoadingBar_bar:setPercent(percent)
	self.Text_percent:setString(curNum)
	local relexTimes = self:getBossRelexTimes()
	print("relexTimes========", relexTimes, self.data.status)
	if 0 < relexTimes then
		self:showRelexEffect()
	else
		self:deleteRelexEffect()
	end
	local isWeek = self:isBossWeek()
	if isWeek then
		epicBattleDef = nil
		;(nil).pos = self.pos
		self:showWeekEffect(self, nil)
	else
		self:deleteWeekEffect()
	end
	self.frame_target:setScale(1.0)
	self.frame_target:setPosition(0, 20)
	self.Node_effect:setVisible(false)
	self.etPetCardNode:setVisible(false)
	self.Node_lock:setVisible(false)
	self.Node_nextGate:setVisible(false)
	self.Node_Strategys:setVisible(false)
	self.frame_target:setVisible(true)
	self:setNormal()
	local ret = _G.SoraDIsFileExistByKey("worldMapBossNormal")
	if not self.isAction then
		self.frame_target:setSpriteFrame("panjun_dj_ws_01.png")
	else
		return
	end
	self.isAction = true
	self.frame_target:stopAllActions()
	local framesBoss = display.newFrames("panjun_dj_ws_%.2d.png", 1, 8)
	local animationBoss = display.newAnimation(framesBoss, 1.2 / #framesBoss)
	self.frame_target:playAnimationForever(animationBoss)
end
function epicBattleMapSingle:setItem(itemID)
	self.frame_target:setVisible(true)
	self:setNormal()
	self.frame_target:setSpriteFrame(publicRead.getIcon(itemID))
	self.frame_target:setScale(0.5)
	self.Node_effect:setVisible(false)
	self.etPetCardNode:setVisible(false)
	self.Node_lock:setVisible(false)
	self.Node_progress:setVisible(false)
	self.Node_nextGate:setVisible(false)
	self.Node_Strategys:setVisible(false)
	if self.isAction then
		return
	end
	self.isAction = true
	self.frame_target:stopAllActions()
	self.frame_target:setPosition(0, 10)
	_ENV = self.frame_target
	self.frame_target[1] = cca.moveBy(1.0, 0, 5)
	self.frame_target[2] = cca.moveBy(1.0, 0, -5)
	self.frame_target[3] = cca.moveBy(1.0, 0, -5)
	self.frame_target[4] = cca.moveBy(1.0, 0, -5)
	self.frame_target[5] = cca.moveBy(1.0, 0, -5)
	local seq = cca.seq(self.frame_target)
	self.frame_target:runAction(cc.RepeatForever:create(seq))
end
function epicBattleMapSingle:setMountain()
	self.frame_target:stopAllActions()
	self.frame_target:setVisible(true)
	self:setNormal()
	self.frame_target:setPosition(0, 25)
	self.frame_target:setSpriteFrame("frame_ditu_shikuai.png")
	self.etPetCardNode:setVisible(false)
	self.Node_effect:setVisible(false)
	self.Node_lock:setVisible(false)
	self.Node_progress:setVisible(false)
	self.Node_nextGate:setVisible(false)
	self.Node_Strategys:setVisible(false)
end
function epicBattleMapSingle:setSpace()
	self.frame_target:stopAllActions()
	self.frame_target:setVisible(false)
	self.etPetCardNode:setVisible(false)
	self.Node_effect:setVisible(false)
	self.Node_lock:setVisible(false)
	self.Node_progress:setVisible(false)
	self.Node_nextGate:setVisible(false)
	self.Node_Strategys:setVisible(false)
	self:deleteRelexEffect()
	self:deleteBuildEffect()
	self:deleteWeekEffect()
end
function epicBattleMapSingle:setSilver()
	self.frame_target:setVisible(true)
	self:setNormal()
	self.frame_target:setSpriteFrame("icon_epicWar_sgyb.png")
	self.frame_target:setScale(0.5)
	self.Node_effect:setVisible(false)
	self.etPetCardNode:setVisible(false)
	self.Node_lock:setVisible(false)
	self.Node_progress:setVisible(false)
	self.Node_nextGate:setVisible(false)
	self.Node_Strategys:setVisible(false)
	if self.isAction then
		return
	end
	self.isAction = true
	self.frame_target:stopAllActions()
	self.frame_target:setPosition(0, 10)
	_UPVALUE1_ = self.frame_target
	self.frame_target[1] = cca.moveBy(1.0, 0, 5)
	self.frame_target[2] = cca.moveBy(1.0, 0, -5)
	self.frame_target[3] = cca.moveBy(1.0, 0, -5)
	self.frame_target[4] = cca.moveBy(1.0, 0, -5)
	self.frame_target[5] = cca.moveBy(1.0, 0, -5)
	local seq = cca.seq(self.frame_target)
	self.frame_target:runAction(cc.RepeatForever:create(seq))
end
function epicBattleMapSingle:setBartizan(isRuins)
	self.frame_target:stopAllActions()
	self.Node_chjt:setVisible(false)
	self.Node_gjsw:setVisible(false)
	self.frame_target:setVisible(true)
	self:setNormal()
	if isRuins then
		self.frame_target:setPosition(-35, 40)
	else
		self.frame_target:setPosition(0, 40)
	end
	self.frame_target:setSpriteFrame(isRuins and "icon_epicwar_tower_ruins.png" or "icon_epicwar_tower.png")
	self.etPetCardNode:setVisible(false)
	self.Node_effect:setVisible(false)
	self.Node_lock:setVisible(false)
	self.Node_progress:setVisible(false)
	self.Node_nextGate:setVisible(false)
	self.Node_Strategys:setVisible(false)
end
function epicBattleMapSingle:setMethod()
	self.Node_Strategys:setVisible(true)
	self.Node_etCL:setVisible(self.isUnlock)
	if self.isUnlock and self.Node_etCL:getChildrenCount() == 0 then
		SoraDCreatAnimation("animationEpicWarCLSG", nil, false):addTo(self.Node_etCL)
	end
	if self.Node_etGB:getChildrenCount() == 0 then
		SoraDCreatAnimation("animationEpicWarCLGB"):addTo(self.Node_etGB)
	end
	self.Node_nextGate:setVisible(false)
	self.frame_target:setVisible(false)
	local tacticsId = self.data.eventData.eventParam.tacticsId
	self.Image_strategy:loadTexture(epicWarltCtrl.getTacticsIcon(tacticsId), ccui.TextureResType.plistType)
	self.Image_quality:loadTexture(epicWarltCtrl.getTacticsIconBase(tacticsId), ccui.TextureResType.plistType)
	self.etPetCardNode:setVisible(false)
	self.Node_effect:setVisible(false)
	self.Node_lock:setVisible(false)
	self.Node_progress:setVisible(false)
	if self.isAction then
		return
	end
	self.Node_Strategys:stopAllActions()
	self.Node_Strategys:setPosition(0, 10)
	epicWarltCtrl = self.Node_Strategys
	self.Node_Strategys[1] = cca.moveBy(1.0, 0, 5)
	self.Node_Strategys[2] = cca.moveBy(1.0, 0, -5)
	self.Node_Strategys[3] = cca.moveBy(1.0, 0, -5)
	self.Node_Strategys[4] = cca.moveBy(1.0, 0, -5)
	self.Node_Strategys[5] = cca.moveBy(1.0, 0, -5)
	local seq = cca.seq(self.Node_Strategys)
	self.Node_Strategys:runAction(cc.RepeatForever:create(seq))
	self.isAction = true
end
function epicBattleMapSingle:setHospital()
	self.frame_target:stopAllActions()
	self.frame_target:setVisible(true)
	self:setNormal()
	self.frame_target:setScale(0.8)
	self.frame_target:setPosition(0, 25)
	self.frame_target:setSpriteFrame("icon_epicwar_hospital.png")
	self.etPetCardNode:setVisible(false)
	self.Node_effect:setVisible(false)
	self.Node_lock:setVisible(false)
	self.Node_progress:setVisible(false)
	self.Node_nextGate:setVisible(false)
	self.Node_Strategys:setVisible(false)
	self:showBuildEffect()
end
function epicBattleMapSingle:setBless()
	self.frame_target:stopAllActions()
	self.frame_target:setVisible(true)
	self:setNormal()
	self.frame_target:setScale(0.8)
	self.frame_target:setPosition(-10, 27)
	self.frame_target:setSpriteFrame("icon_epicwar_bless.png")
	self.etPetCardNode:setVisible(false)
	self.Node_effect:setVisible(false)
	self.Node_lock:setVisible(false)
	self.Node_progress:setVisible(false)
	self.Node_nextGate:setVisible(false)
	self.Node_Strategys:setVisible(false)
	self:showBuildEffect()
end
function epicBattleMapSingle:setStore()
	self.frame_target:stopAllActions()
	self.frame_target:setVisible(true)
	self:setNormal()
	self.frame_target:setScale(0.8)
	self.frame_target:setPosition(3, 18)
	self.frame_target:setSpriteFrame("icon_epicwar_store.png")
	self.etPetCardNode:setVisible(false)
	self.Node_effect:setVisible(false)
	self.Node_lock:setVisible(false)
	self.Node_progress:setVisible(false)
	self.Node_nextGate:setVisible(false)
	self.Node_Strategys:setVisible(false)
	self:showBuildEffect()
end
function epicBattleMapSingle:showRelexEffect()
	SoraDPlaySound("epicWar", 6)
	if not self.et_relex1 then
		self.et_relex1 = SoraDCreatAnimationEx("animationEpicWarSX1", nil, false)
		self.et_relex1:addTo(self.Node_xr1)
		_UPVALUE1_ = false
		;(false)[1] = cca.delay(2.0833333333333335)
		;(false)[2] = cca.callFunc(function()
			if self.et_relex1 then
				self.et_relex1.action:gotoFrameAndPlay(20, 125, true)
			end
		end)
		;(false)[3] = cca.callFunc(function()
			if self.et_relex1 then
				self.et_relex1.action:gotoFrameAndPlay(20, 125, true)
			end
		end)
		self:runAction(cca.seq(false))
	else
		self.et_relex1.action:gotoFrameAndPlay(20, 125, true)
	end
	if not self.et_relex2 then
		self.et_relex2 = SoraDCreatAnimationEx("animationEpicWarSX2", nil, false)
		self.et_relex2:addTo(self.Node_xr2)
		_UPVALUE1_ = false
		;(false)[1] = cca.delay(2.0833333333333335)
		;(false)[2] = cca.callFunc(function()
			if self.et_relex2 then
				self.et_relex2.action:gotoFrameAndPlay(20, 125, true)
			end
		end)
		;(false)[3] = cca.callFunc(function()
			if self.et_relex2 then
				self.et_relex2.action:gotoFrameAndPlay(20, 125, true)
			end
		end)
		self:runAction(cca.seq(false))
	else
		self.et_relex2.action:gotoFrameAndPlay(20, 125, true)
	end
end
function epicBattleMapSingle:deleteRelexEffect()
	if self.et_relex1 then
		self.et_relex1:removeFromParent()
		self.et_relex1 = nil
	end
	if self.et_relex2 then
		self.et_relex2:removeFromParent()
		self.et_relex2 = nil
	end
end
function epicBattleMapSingle:showDestoryEffect(target, data)
	local pos = data.pos
	if pos.x == self.pos.x and pos.y == self.pos.y then
		self.Node_chjt:setVisible(true)
		self.et_destory = SoraDCreatAnimation("animationEpicWarCHJT", nil, false)
		self.et_destory:addTo(self.Node_chjt)
		_UPVALUE1_ = false
		;(false)[1] = cca.delay(0.25)
		;(false)[2] = cca.callFunc(function()
			SoraDPlaySound("epicWar", 1)
			self:setBartizan(true)
		end)
		;(false)[3] = cca.callFunc(function()
			SoraDPlaySound("epicWar", 1)
			self:setBartizan(true)
		end)
		self:runAction(cca.seq(false))
	end
end
function epicBattleMapSingle:showTowerAttackEffect(target, data)
	local posArray = data.posArray
	for k, v in ipairs(posArray) do
		if v.x == self.pos.x and v.y == self.pos.y then
			SoraDPlaySound("epicWar", 4)
			if not self.et_attack then
				self.et_attack = SoraDCreatAnimationEx("animationEpicWarJTGJ", nil, false)
				self.et_attack:addTo(self.Node_jtgj)
			else
				self.et_attack.action:gotoFrameAndPlay(0, false)
			end
		end
	end
end
function epicBattleMapSingle:showAttackFailEffect(target, data)
	local pos = data.pos
	local pointType = data.pointType
	local handle = data.handle
	if pos.x == self.pos.x and pos.y == self.pos.y then
		SoraDPlaySound("epicWar", 8)
		self.Node_gjsw:setVisible(true)
		if not self.et_atk then
			self.et_atk = SoraDCreatAnimationEx("animationEpicWarGJSW", nil, false)
			self.et_atk:addTo(self.Node_gjsw)
		else
			self.et_atk.action:gotoFrameAndPlay(0, false)
		end
		local frames = pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS and display.newFrames("panjun_gj_ws_%.2d.png", 1, 8) or display.newFrames("pjys_gj_ws_%.2d.png", 1, 8)
		self.frame_target:stopAllActions()
		local animation = display.newAnimation(frames, 1.2 / #frames)
		self.frame_target:playAnimationOnce(animation, false, function()
			handle()
			self.isAction = nil
			if pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS then
				self:setBoss()
			else
				self:setGuard()
			end
		end, 0)
	end
end
function epicBattleMapSingle:showAttackWinEffect(target, data)
	local pos = data.pos
	local pointType = data.pointType
	local handle = data.handle
	if pos.x == self.pos.x and pos.y == self.pos.y then
		self.Node_gjsw:setVisible(true)
		if not self.et_atk then
			self.et_atk = SoraDCreatAnimationEx("animationEpicWarGJSW", nil, false)
			self.et_atk:addTo(self.Node_gjsw)
		else
			self.et_atk.action:gotoFrameAndPlay(0, false)
		end
		self.Text_percent:setString(0)
		if self.barTimer then
			SoraDManagerRemoveTimer(self, self.barTimer)
			self.barTimer = nil
		end
		local prePercent = self.LoadingBar_bar:getPercent()
		if prePercent ~= 0 then
			self.barTimer = SoradCreateTimer(self, function(...)
				if prePercent == 0 then
					return
				end
				local preValue = (0 - prePercent) / 35
				if self.LoadingBar_bar_act then
					self.LoadingBar_bar_act:setPercent(prePercent)
				end
			end, true)
		else
			self.LoadingBar_bar_act:setPercent(0)
		end
		self.LoadingBar_bar:setPercent(0)
		SoraDPlaySound("epicWar", 8)
		local frames = pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS and display.newFrames("panjun_sw_ws_%.2d.png", 1, 8) or display.newFrames("pjys_sw_ws_%.2d.png", 1, 8)
		self.frame_target:stopAllActions()
		local animation = display.newAnimation(frames, 1.2 / #frames)
		self.frame_target:playAnimationOnce(animation, false, function()
			handle()
			self.isAction = nil
			self:setSpace()
		end, 0)
	end
end
function epicBattleMapSingle:showDamageBossEffect(target, data)
	local pos = data.pos
	if pos.x == self.pos.x and pos.y == self.pos.y then
		SoraDPlaySound("epicWar", 3)
		self.Node_jssb:setVisible(true)
		if not self.et_damage then
			self.et_damage = SoraDCreatAnimationEx("animationEpicWarJSSB", nil, false)
			self.et_damage:addTo(self.Node_jssb)
		else
			self.et_damage.action:gotoFrameAndPlay(0, false)
		end
	end
end
function epicBattleMapSingle:showWeekEffect(target, data)
	local pos = data.pos
	if pos.x == self.pos.x and pos.y == self.pos.y then
		SoraDPlaySound("epicWar", 7)
		if not self.et_week then
			self.et_week = SoraDCreatAnimationEx("animationEpicWarXR", nil, false)
			self.et_week:addTo(self.Node_xr)
			_UPVALUE1_ = false
			;(false)[1] = cca.delay(2.1166666666666667)
			;(false)[2] = cca.callFunc(function()
				if self.et_week then
					self.et_week.action:gotoFrameAndPlay(57, 127, true)
				end
			end)
			;(false)[3] = cca.callFunc(function()
				if self.et_week then
					self.et_week.action:gotoFrameAndPlay(57, 127, true)
				end
			end)
			self:runAction(cca.seq(false))
		else
			self.et_week.action:gotoFrameAndPlay(57, 127, true)
		end
	end
end
function epicBattleMapSingle:deleteWeekEffect()
	if self.et_week then
		self.et_week:removeFromParent()
		self.et_week = nil
	end
end
function epicBattleMapSingle:checkBossSeeEffect()
	local pointType = self.data.pointType
	if pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.MONSTER then
		if epicWarCtrl:isShowBMonsterPre() then
			self:showBossSeeEffect()
		end
	elseif pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS then
		if epicWarCtrl:isShowBossPre() then
			self:showBossSeeEffect()
		end
	else
		self:deleteBossSeeEffect()
	end
end
function epicBattleMapSingle:showBossSeeEffect()
	local pointType = self.data.pointType
	local formatStr = pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS and "panjun_dj_ws_%.2d.png" or "pjys_dj_ws_%.2d.png"
	local framesBoss = display.newFrames(formatStr, 1, 8)
	local animationBoss = display.newAnimation(framesBoss, 1.2 / #framesBoss)
	self.frame_bossPre:setOpacity(178.5)
	self.frame_bossPre:stopAllActions()
	self.frame_bossPre:playAnimationForever(animationBoss)
	self.frame_bossPre:setVisible(true)
end
function epicBattleMapSingle:deleteBossSeeEffect()
	self.frame_bossPre:setVisible(false)
end
function epicBattleMapSingle:showBuildEffect()
	self.Node_jztx:setVisible(true)
	if self.data.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BLESSING then
		if not self.et_txqfg then
			self.et_txqfg = SoraDCreatAnimation("animationEpicWarJZQFG")
			self.et_txqfg:addTo(self.Node_jztx)
		else
			self.et_txqfg:setVisible(true)
		end
	end
	if self.data.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.CURE then
		if not self.et_txqzp then
			self.et_txqzp = SoraDCreatAnimation("animationEpicWarJZQZP")
			self.et_txqzp:addTo(self.Node_jztx)
		else
			self.et_txqzp:setVisible(true)
		end
	end
	if self.data.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.SHOP then
		if not self.et_txsd then
			self.et_txsd = SoraDCreatAnimation("animationEpicWarJZSD")
			self.et_txsd:addTo(self.Node_jztx)
		else
			self.et_txsd:setVisible(true)
		end
	end
end
function epicBattleMapSingle:deleteBuildEffect()
	self.Node_jztx:setVisible(false)
end
function epicBattleMapSingle:showNextGateEffect()
	if self.data.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.HOME and epicWarCtrl:isBossKilled() then
		self.Node_next1:setVisible(true)
		self.Node_next2:setVisible(true)
		if not self.et_next1 then
			self.et_next1 = SoraDCreatAnimationEx("animationEpicWarNext1", nil, false)
			self.et_next1:addTo(self.Node_next1)
		end
		if not self.et_next2 then
			self.et_next2 = true
			epicWarCtrl = false
			;(false)[1] = cca.delay(0.26666666666666666)
			;(false)[2] = cca.callFunc(function()
				self.et_next2 = SoraDCreatAnimation("animationEpicWarNext2")
				self.et_next2:addTo(self.Node_next2)
			end)
			;(false)[3] = cca.callFunc(function()
				self.et_next2 = SoraDCreatAnimation("animationEpicWarNext2")
				self.et_next2:addTo(self.Node_next2)
			end)
			self:runAction(cca.seq(false))
		end
	end
end
function epicBattleMapSingle:deleteNextGateEffect()
	self.Node_next1:setVisible(false)
	self.Node_next2:setVisible(false)
end
function epicBattleMapSingle:setInstanceByPointType()
	local pointType = self.data.pointType
	local status = self.data.eventData and self.data.eventData.status
	self.frame_target:setScale(1.0)
	self.frame_target:setOpacity(255)
	if status and status == epicBattleDef.gBoardEventStatusEnum.COMPLETE then
		if pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BARTIZAN then
			self:setBartizan(true)
			self.isAction = nil
			return
		end
		if pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS then
			local curNum, oriNum, percent = self:getBossArmyInfo()
			if 0 < curNum then
				self.isAction = true
				self:setBoss()
				return
			end
		end
		if pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.MONSTER then
			local curNum, oriNum, percent = self:getBossArmyInfo()
			if 0 < curNum then
				self.isAction = true
				self:setGuard()
				return
			end
		end
		self:setSpace()
		self.isAction = nil
		self:deleteBuildEffect()
		return
	end
	if pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.HOME then
		self:setHome()
		self.isAction = nil
		self:deleteBuildEffect()
	elseif pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS then
		self:setBoss()
		self:deleteBuildEffect()
	elseif pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.MONSTER then
		self:setGuard()
		self:deleteBuildEffect()
	elseif pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.TREASURE_CHEST then
		self:setBox()
		self:deleteBuildEffect()
	elseif pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.ITEMS then
		local itemID = self.data.eventData.eventParam.randomRet[1].id
		self:setItem(itemID)
		self:deleteBuildEffect()
	elseif pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.STRATEGY then
		self:setMethod()
		self:deleteBuildEffect()
	elseif pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BLESSING then
		self:setBless()
		self.isAction = nil
	elseif pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.CURE then
		self:setHospital()
		self.isAction = nil
	elseif pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.SHOP then
		self:setStore()
		self.isAction = nil
	elseif pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BARTIZAN then
		self:setBartizan()
		self.isAction = nil
		self:deleteBuildEffect()
	elseif pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.MITHRIL_PILE then
		self:setSilver()
		self:deleteBuildEffect()
	elseif pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.MOUNTAIN then
		self:setMountain()
		self.isAction = nil
		self:deleteBuildEffect()
	elseif pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.SPACE then
		self:setSpace()
		self.isAction = nil
		self:deleteBuildEffect()
	end
end
function epicBattleMapSingle:addUnlockTreeEffect()
	self.Node_effect:removeAllChildren()
	_ENV, _ENV = self.Node_effect, self.Node_effect.removeAllChildren
	_ENV, self.Node_effect.removeAllChildren[1], self.Node_effect.plist = self.Node_effect, self.Node_effect, "et_sszzshulin_01.plist"
	self.Node_effect.plist = "et_sszzshulin_02.plist"
	self.Node_effect.removeAllChildren[2], self.Node_effect.scale = self.Node_effect, 0.685
	local param = self.Node_effect.removeAllChildren
	local et_node = SoraDCreateEffectNode(param)
	et_node:addTo(self.Node_effect)
end
function epicBattleMapSingle:addTreasureBoxEffect()
	self.Node_effect:removeAllChildren()
	_ENV, _ENV = self.Node_effect, self.Node_effect.removeAllChildren
	self.Node_effect.plist = "et_shishizhizhangz_01.plist"
	_ENV, self.Node_effect.removeAllChildren[1], self.Node_effect.scale = self.Node_effect, self.Node_effect, 0.8
	self.Node_effect.plist = "et_shishizhizhangz_02.plist"
	self.Node_effect.removeAllChildren[2], self.Node_effect.scale = self.Node_effect, 0.84
	local param = self.Node_effect.removeAllChildren
	local et_node = SoraDCreateEffectNode(param)
	et_node:addTo(self.Node_effect)
end
function epicBattleMapSingle:setTouchEnabled(enable)
	self.Panel_touch:setTouchEnabled(enable)
	self.Panel_touch:setSwallowTouches(not enable)
end
function epicBattleMapSingle:setGray()
	self.frame_target:setColor(cc.c3b(120, 120, 120))
end
function epicBattleMapSingle:setNormal()
	self.frame_target:setColor(cc.c3b(255, 255, 255))
end
function epicBattleMapSingle:onTouchBack(button, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.handle then
			self.handle(self.pos)
		end
		if self.data.isReal then
			if self.data.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.HOME then
				SoraDPlaySound()
				local isKilled = epicWarCtrl:isBossKilled()
				if isKilled then
					if epicWarCtrl:getCurGateIndex() == 10 then
						SoraDShowMsgTip(i18n("tips_theLastStage_cant_enter"))
					else
						SoraDShowMsgBox(i18n("epic_war_nextStage_sure_desc"), i18n("common_text_204"), i18n("common_text_185"), function(event)
							if event == MSGBOX_CALLBACK_YES then
								epicWarCtrl:sendToNextStage()
							end
						end)
					end
				else
					SoraDShowMsgTip(i18n("tips_cant_enter_nextStage"))
				end
			elseif self.data.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.MOUNTAIN or self.data.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.SPACE then
			elseif self.data.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.TREASURE_CHEST then
				local status = self.data.eventData and self.data.eventData.status
				if status and status == epicBattleDef.gBoardEventStatusEnum.COMPLETE then
				else
					SoraDPlaySound("buildopsound", "OpPyramid")
					local panel = SoraDCreatePanel("epicBattleChooseAwardView")
					panel:initData(self.data, self.pos)
					panel:show()
				end
			elseif self.data.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.ITEMS or self.data.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.MITHRIL_PILE then
				local status = self.data.eventData and self.data.eventData.status
				if status and status == epicBattleDef.gBoardEventStatusEnum.COMPLETE then
				else
					epicWarCtrl:sendReqTriggerEvent(self.pos)
				end
			elseif self.data.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS or self.data.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.MONSTER then
				print("--点击boss")
				local status = self.data.eventData and self.data.eventData.status
				if status and status == epicBattleDef.gBoardEventStatusEnum.COMPLETE then
				elseif epicBattleDef.STRATEGYMODE == 1 then
					epicWarCtrl:sendUseStrategy(epicBattleDef.STRATEGYIDX, self.pos)
				else
					local panel = SoraDCreatePanel("epicBattleBossInfoView")
					panel:initData(self.data, self.pos)
					panel:show()
				end
			elseif self.data.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.STRATEGY then
				local status = self.data.eventData and self.data.eventData.status
				if status and status == epicBattleDef.gBoardEventStatusEnum.COMPLETE then
				else
					local strategyList = epicWarCtrl:getCurStrategyList()
					if table.nums(strategyList) >= 8 then
						SoraDShowMsgTip(i18n("tips_tactic_numLimit"))
					else
						epicWarCtrl:sendReqTriggerEvent(self.pos)
					end
				end
			elseif self.data.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BLESSING then
				local status = self.data.eventData and self.data.eventData.status
				if status and status == epicBattleDef.gBoardEventStatusEnum.COMPLETE then
				else
					local panel = SoraDCreatePanel("epicWarBlessDetailView")
					panel:initData(self.data, self.pos)
					panel:show()
				end
			elseif self.data.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.CURE then
				local status = self.data.eventData and self.data.eventData.status
				if status and status == epicBattleDef.gBoardEventStatusEnum.COMPLETE then
				else
					local panel = SoraDCreatePanel("epicWarHospitalDetailView")
					panel:initData(self.data, self.pos)
					panel:show()
				end
			elseif self.data.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.SHOP then
				local panel = SoraDCreatePanel("epicWarStoreDetailView")
				panel:initData(self.data, self.pos)
				panel:show()
			elseif self.data.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BARTIZAN then
				local status = self.data.eventData and self.data.eventData.status
				if status and status == epicBattleDef.gBoardEventStatusEnum.COMPLETE then
				elseif epicBattleDef.STRATEGYMODE == 2 then
					epicWarCtrl:sendUseStrategy(epicBattleDef.STRATEGYIDX, self.pos)
				else
					local panel = SoraDCreatePanel("epicWarTowerDetailView")
					panel:initData(self.data, self.pos)
					panel:show()
				end
			end
		elseif not epicWarCtrl:isHaveExploredSpace(self.pos.x, self.pos.y) then
			SoraDShowMsgTip(i18n("epicbattle_text_12"))
		elseif self.isCanExplore then
			local cutExploreCount = epicWarCtrl:getCurExploreCount()
			if 0 < cutExploreCount then
				SoraDPlaySound("innercontrol", 10)
				epicWarCtrl:sendReqExplore(self.pos)
			else
				SoraDCreatePanel("epicBattleActionBuyView"):show()
			end
		else
			SoraDShowMsgTip(i18n("epicbattle_text_45"))
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return epicBattleMapSingle
