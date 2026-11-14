local gametop = gModuleMgr.getObject("gametop")
local miraculousWeaponCtrl = gametop.playertop_:getModule("miraculousWeaponCtrl")
local miraculousWeaponltCtrl = include("miraculousWeaponltCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local buildLogic = include("buildLogic")
local godEquipmentChipsView = class("godEquipmentChipsView", function(luaFileName)
	return SoraDCreateBasePanel(luaFileName)
end)
function godEquipmentChipsView:ctor()
	self.isMoved = false
	self.index = 1
	self.weaponID = nil
	self.isAwake = false
	self.baseConfig, _ENV, self.chipsArray, _ENV, self.isAllUnlocked = nil, nil, nil, nil, false
	self.selectConfig, _ENV, self.selectChip = nil, nil, nil
	self.actMoveOffset = 30
	self.Node_chips = SoraDGetChildByName(self, "Node_chips")
	for i = 1, gWeaponChipNum do
		local chip = SoraDGetChildByName(self, "Image_chip_" .. i)
		chip:setTag(i)
		chip:setLocalZOrder(0)
		chip:setTouchEnabled(true)
		chip:setPreciseTouchEnabled(true)
		chip:addTouchEventListener(handler(self, self.btnChipCallBack))
		chip:setSwallowTouches(false)
		chip.status = gWeaponChipStatus.LOCKED
		self.chipsArray[i] = chip
		_ENV = chip
		chip.chip = chip
		chip.pos = cc.p(chip:getPositionX(), chip:getPositionY())
		self.baseConfig[i], chip.scale = chip, chip:getScale()
	end
	self.Node_equipment = SoraDGetChildByName(self, "Node_equipment")
	self.Node_equipment:setVisible(false)
	self:runChipsAction()
end
function godEquipmentChipsView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_GODEQUIP_CHIPS_UPDATE", handler(self, self.backNormalView))
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_UNLOCK_UPDATE", handler(self, self.updateChip))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.updateChip))
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_MERGE_BACK", handler(self, self.mergeBack))
end
function godEquipmentChipsView:updateSource()
	for k, v in ipairs(self.chipsArray) do
		v:loadTexture(miraculousWeaponltCtrl.getChipsInfo(self.weaponID, k).icon, ccui.TextureResType.plistType)
	end
	local Image_equipment = SoraDGetChildByName(self.Node_equipment, "Image_equipment")
	Image_equipment:loadTexture(miraculousWeaponltCtrl.getWeaponInfo(self.weaponID).icon, ccui.TextureResType.plistType)
end
function godEquipmentChipsView:getChip(weaponID, chipIndex)
	if self.weaponID == weaponID then
		return self.chipsArray[chipIndex]
	end
end
function godEquipmentChipsView:chipLockShow(chip, status, isMsg)
	local status = status or gWeaponChipStatus.LOCKED
	local updateBar = function(remainTime, totalTime)
		local percent = (totalTime - remainTime) * 100 / totalTime
		chip.timeBar:setPercentage(percent)
		chip.etNode:setRotation(percent * 3.6)
	end
	local closeTimer = function()
		if self.unlockTimer then
			SoraDManagerRemoveTimer(self, self.unlockTimer)
			self.unlockTimer = nil
		end
		if chip.timeBar then
			chip.timeBar:removeFromParent()
			chip.timeBar = nil
		end
		if chip.etNode then
			chip.etNode:removeFromParent()
			chip.etNode = nil
		end
	end
	if chip.timeBar then
		chip.timeBar:setVisible(false)
	end
	if chip.etNode then
		chip.etNode:setVisible(false)
	end
	if chip.actLock then
		chip.actLock:setVisible(false)
	end
	if chip.lock then
		chip.lock:setVisible(false)
	end
	if status == gWeaponChipStatus.UNLOCKED then
		chip:setColor(cc.c3b(255, 255, 255))
		closeTimer()
		if isMsg and (chip.status == gWeaponChipStatus.UNLOCKING or chip.status == gWeaponChipStatus.BEUNLOCK) then
			self:chipLockShow(chip, gWeaponChipStatus.UNLOCKACT, isMsg)
		end
	elseif status == gWeaponChipStatus.UNLOCKING then
		chip:setColor(cc.c3b(255, 255, 255))
		if not chip.lock then
			chip.lock = display.newSprite("#btn_cw_lock.png")
			chip.lock:setScale(0.8)
			chip.lock:setPosition(chip:getContentSize().width / 2, chip:getContentSize().height / 2)
			chip.lock:addTo(chip)
		else
			chip.lock:setVisible(true)
		end
		if not chip.timeBar then
			local bar = display.newSprite("#dh_shenqisuo_01.png")
			SoraDMixtureGLONE(bar)
			chip.timeBar = display.newProgressTimer(bar, display.PROGRESS_TIMER_RADIAL)
			chip.timeBar:setPosition(chip:getContentSize().width / 2 - 1, chip:getContentSize().height / 2 + 2)
			chip.timeBar:addTo(chip)
			bar:removeFromParent()
			chip.timeBar:setScale(0.8)
		else
			chip.timeBar:setVisible(true)
		end
		if not chip.etNode then
			chip.etNode = display.newNode()
			chip.etNode:setPosition(chip:getContentSize().width / 2 - 1, chip:getContentSize().height / 2 + 2)
			chip.etNode:addTo(chip, 1)
			local particle_effect = cc.ParticleSystemQuad:create("Particle/et_shenqisuo_01.plist")
			SoraDMixtureGLONE(particle_effect)
			particle_effect:setPosition(0, 30)
			particle_effect:setScaleX(-1.21)
			particle_effect:setScaleY(1.21)
			particle_effect:setRotation(-15)
			particle_effect:addTo(chip.etNode)
		else
			chip.etNode:setVisible(true)
		end
		local unlockQueue = queueCtrl:queryQueue(gQueueTypeDef.miraculous_weapon_unlock)
		if isMsg and not self.actTimer then
			local curPercent = chip.timeBar:getPercentage()
			local percent = curPercent
			local remainTime = unlockQueue.timerNode.timer:getRemainTime()
			local totalTime = unlockQueue.ottime or unlockQueue.lefttime or unlockQueue.totaltime
			local targetPercent = (totalTime - remainTime) * 100 / totalTime
			local dtPercent = (targetPercent - curPercent) / 60
			self.actTimer = SoradCreateTimer(self, function(dt)
				if percent >= targetPercent then
					SoraDManagerRemoveTimer(self, self.actTimer)
					self.actTimer = nil
					if chip.timeBar and chip.etNode then
						chip.timeBar:setPercentage(targetPercent)
						chip.etNode:setRotation(targetPercent * 3.6)
					end
				elseif chip.timeBar and chip.etNode then
					chip.timeBar:setPercentage(percent)
					chip.etNode:setRotation(percent * 3.6)
				end
			end, true)
		elseif unlockQueue and not self.unlockTimer then
			local totalTime = unlockQueue.ottime or unlockQueue.lefttime or unlockQueue.totaltime
			updateBar(unlockQueue.timerNode.timer:getRemainTime(), totalTime)
			self.unlockTimer = SoradCreateTimer(self, function()
				local remainTime = unlockQueue.timerNode.timer:getRemainTime()
				if remainTime <= 0 then
					closeTimer()
					self:chipLockShow(chip, gWeaponChipStatus.UNLOCKACT)
				else
					updateBar(remainTime, totalTime)
				end
			end)
		elseif not unlockQueue then
			closeTimer()
		end
		if self.selectChip and self.selectChip == chip then
			_ENV = SoradCreateTimer(self, function()
				local remainTime = unlockQueue.timerNode.timer:getRemainTime()
				if remainTime <= 0 then
					closeTimer()
					self:chipLockShow(chip, gWeaponChipStatus.UNLOCKACT)
				else
					updateBar(remainTime, totalTime)
				end
			end)
			SoradCreateTimer(self, function()
				local remainTime = unlockQueue.timerNode.timer:getRemainTime()
				if remainTime <= 0 then
					closeTimer()
					self:chipLockShow(chip, gWeaponChipStatus.UNLOCKACT)
				else
					updateBar(remainTime, totalTime)
				end
			end).msg = "MESSAGE_UI_GODEQUIP_PANELTOUCH_UPDATE"
			SoradCreateTimer(self, function()
				local remainTime = unlockQueue.timerNode.timer:getRemainTime()
				if remainTime <= 0 then
					closeTimer()
					self:chipLockShow(chip, gWeaponChipStatus.UNLOCKACT)
				else
					updateBar(remainTime, totalTime)
				end
			end).enable = true
			SoradCreateTimer(self, function()
				local remainTime = unlockQueue.timerNode.timer:getRemainTime()
				if remainTime <= 0 then
					closeTimer()
					self:chipLockShow(chip, gWeaponChipStatus.UNLOCKACT)
				else
					updateBar(remainTime, totalTime)
				end
			end).chipStatus = self.selectChip.status
			SoraDSendMessage((SoradCreateTimer(self, function()
				local remainTime = unlockQueue.timerNode.timer:getRemainTime()
				if remainTime <= 0 then
					closeTimer()
					self:chipLockShow(chip, gWeaponChipStatus.UNLOCKACT)
				else
					updateBar(remainTime, totalTime)
				end
			end)))
		end
	elseif status == gWeaponChipStatus.BEUNLOCK then
		chip:setColor(cc.c3b(255, 255, 255))
		if not chip.actLock then
			queueCtrl, chip.actLock = SoraDCreatAnimation("petLock"), SoraDCreatAnimation("petLock")
			SoraDCreatAnimation("petLock")[1] = SoraDGetChildByName(chip.actLock, "dh_lock_circle")
			SoraDCreatAnimation("petLock")[2] = SoraDGetChildByName(chip.actLock, "dh_lock_glow")
			SoraDCreatAnimation("petLock")[3] = SoraDGetChildByName(chip.actLock, "dh_lock_glow")
			SoraDCreatAnimation("petLock")[4] = SoraDGetChildByName(chip.actLock, "dh_lock_glow")
			SoraDCreatAnimation("petLock")[5] = SoraDGetChildByName(chip.actLock, "dh_lock_glow")
			SoraDCreatAnimation("petLock")[6] = SoraDGetChildByName(chip.actLock, "dh_lock_glow")
			SoraDCreatAnimation("petLock")[7] = SoraDGetChildByName(chip.actLock, "dh_lock_glow")
			SoraDCreatAnimation("petLock")[8] = SoraDGetChildByName(chip.actLock, "dh_lock_glow")
			SoraDCreatAnimation("petLock")[9] = SoraDGetChildByName(chip.actLock, "dh_lock_glow")
			local SoraDCreatAnimation("petLock")[10], array = SoraDGetChildByName(chip.actLock, "dh_lock_glow")
			SoraDSetNodeArrayAdditive(array)
			chip.actLock:setPosition(chip:getContentSize().width / 2, chip:getContentSize().height / 2)
			chip.actLock:setScale(0.8)
			chip.actLock:addTo(chip)
		else
			chip.actLock:setVisible(true)
		end
	elseif status == gWeaponChipStatus.LOCKED then
		chip:setColor(cc.c3b(100, 100, 100))
		if not chip.lock then
		else
			chip.lock:setVisible(true)
		end
	elseif status == gWeaponChipStatus.UNLOCKACT then
		chip:setColor(cc.c3b(255, 255, 255))
		if not chip.unlockAct then
			chip.unlockAct = SoraDCreatAnimationEx("petCarUnlock", nil, false)
			chip.unlockAct:setScale(0.8)
			chip.unlockAct:setPosition(chip:getContentSize().width / 2, chip:getContentSize().height / 2)
			chip.unlockAct:addTo(chip)
		else
			local action = chip.unlockAct.action
			if action and tolua.cast(action, "cc.Action") then
				action:gotoFrameAndPlay(0, false)
			end
		end
	end
end
function godEquipmentChipsView:showUnlockChips()
	for k, v in ipairs(self.chipsArray) do
		local chipInfo = miraculousWeaponCtrl:getWeaponChipsInfo(self.weaponID, k)
		if chipInfo.status == gWeaponChipStatus.UNLOCKING then
			self:btnChipCallBack(v, ccui.TouchEventType.ended, true)
			return
		end
	end
end
function godEquipmentChipsView:initData(weaponID)
	self.weaponID = weaponID
	self:initView()
end
function godEquipmentChipsView:initView()
	local isMerged = miraculousWeaponCtrl:isWeaponMerged(self.weaponID)
	self.isAwake = isMerged
	if isMerged then
		self.Node_equipment:setVisible(true)
		SoraDCreatAnimation("gEAction_" .. self.index, self.Node_equipment, true)
		for k, v in ipairs(SoraDGetChildByName(self.Node_equipment, "Node_particle_1"):getChildren()) do
			local nameTB = SoraDStringSplit(v:getName(), "_")
			if nameTB[1] == "glone" then
				SoraDMixtureGLONE(v)
			end
		end
		for k, v in ipairs(SoraDGetChildByName(self.Node_equipment, "Node_particle_2"):getChildren()) do
			local nameTB = SoraDStringSplit(v:getName(), "_")
			if nameTB[1] == "glone" then
				SoraDMixtureGLONE(v)
			end
		end
		self.Node_chips:setVisible(false)
	else
		for k, v in ipairs(self.chipsArray) do
			local chipInfo = miraculousWeaponCtrl:getWeaponChipsInfo(self.weaponID, k)
			self:setChipStatus(v, chipInfo.status, chipInfo.cityLevel)
		end
		self:checkAllChipsUnlock()
	end
end
function godEquipmentChipsView:setChipStatus(chip, status, cityLevel, isMsg)
	self:chipLockShow(chip, status, isMsg)
	if cityLevel then
		chip.unlockLevel = cityLevel
	end
	chip.status = status
end
function godEquipmentChipsView:updateChip(target, data)
	if data.weaponID and self.weaponID == data.weaponID or data.qtype and data.qtype == gQueueTypeDef.miraculous_weapon_unlock then
		for k, v in ipairs(self.chipsArray) do
			local chipInfo = miraculousWeaponCtrl:getWeaponChipsInfo(self.weaponID, v:getTag())
			self:setChipStatus(v, chipInfo.status, chipInfo.cityLevel, true)
		end
		self:checkAllChipsUnlock()
	end
end
function godEquipmentChipsView:runChipsAction()
	for k, v in ipairs(self.baseConfig) do
		local delay = math.random(0, 100) / 100
		_UPVALUE4_ = nil
		;(nil)[1] = cca.delay(delay)
		;(nil)[2] = cca.moveTo(1, v.pos.x, v.pos.y + 5)
		;(nil)[3] = cca.moveTo(1, v.pos.x, v.pos.y - 5)
		;(nil)[4] = cca.moveTo(1, v.pos.x, v.pos.y + 3)
		;(nil)[5] = cca.moveTo(1, v.pos.x, v.pos.y - 3)
		;(nil)[6] = cca.moveTo(1, v.pos.x, v.pos.y - 3)
		;(nil)[7] = cca.moveTo(1, v.pos.x, v.pos.y - 3)
		;(nil)[8] = cca.moveTo(1, v.pos.x, v.pos.y - 3)
		v.chip:runAction(cc.RepeatForever:create(cca.seq(nil)))
	end
end
function godEquipmentChipsView:checkAllChipsUnlock()
	local ret = true
	for k, v in ipairs(self.chipsArray) do
		if v.status ~= gWeaponChipStatus.UNLOCKED then
			ret = false
			break
		end
	end
	self.isAllUnlocked = ret
	print("self.isAllUnlocked====", self.isAllUnlocked)
	_ENV = "self.isAllUnlocked===="
	;("self.isAllUnlocked====").msg = "MESSAGE_UI_GODEQUIP_NOTIFY_UNLOCK"
	;("self.isAllUnlocked====").weaponID = self.weaponID
	;("self.isAllUnlocked====").ret = self.isAllUnlocked
	SoraDSendMessage("self.isAllUnlocked====")
end
function godEquipmentChipsView:setIndex(index)
	self.index = index
end
function godEquipmentChipsView:mergeBack(target, data)
	if data.weaponID == self.weaponID then
		self.isAwake = true
		local actTime = 1
		_UPVALUE2_ = nil
		;(nil)[1] = cca.callFunc(function()
			for k, v in ipairs(self.chipsArray) do
				actTime = nil
				;(nil)[1] = cca.moveTo(actTime, 0, 0)
				;(nil)[2] = cca.scaleTo(actTime, 0)
				;(nil)[3] = cca.fadeTo(actTime, 0)
				;(nil)[4] = cca.fadeTo(actTime, 0)
				;(nil)[5] = cca.fadeTo(actTime, 0)
				v:runAction(cca.spawn(nil))
			end
			self.Node_equipment:setOpacity(0)
			self.Node_equipment:setScale(0)
			self.Node_equipment:setVisible(true)
		end)
		;(nil)[2] = cca.delay(actTime)
		;(nil)[3] = cca.callFunc(function()
			actTime = nil
			;(nil)[1] = cca.scaleTo(actTime, 1)
			;(nil)[2] = cca.fadeTo(actTime, 1)
			;(nil)[3] = cca.rotateBy(actTime, 1080)
			;(nil)[4] = cca.rotateBy(actTime, 1080)
			;(nil)[5] = cca.rotateBy(actTime, 1080)
			self.Node_equipment:runAction(cca.spawn(nil))
			self.Node_chips:setVisible(false)
			self = self.Node_chips
			self.Node_chips.msg = "MESSAGE_UI_GODEQUIP_SHOWMODEL_UPDATE"
			SoraDSendMessage(self.Node_chips)
		end)
		;(nil)[4] = cca.callFunc(function()
			actTime = nil
			;(nil)[1] = cca.scaleTo(actTime, 1)
			;(nil)[2] = cca.fadeTo(actTime, 1)
			;(nil)[3] = cca.rotateBy(actTime, 1080)
			;(nil)[4] = cca.rotateBy(actTime, 1080)
			;(nil)[5] = cca.rotateBy(actTime, 1080)
			self.Node_equipment:runAction(cca.spawn(nil))
			self.Node_chips:setVisible(false)
			self = self.Node_chips
			self.Node_chips.msg = "MESSAGE_UI_GODEQUIP_SHOWMODEL_UPDATE"
			SoraDSendMessage(self.Node_chips)
		end)
		local seq = cca.seq(nil)
		self:runAction(seq)
		_ENV = cca.callFunc(function()
			actTime = nil
			;(nil)[1] = cca.scaleTo(actTime, 1)
			;(nil)[2] = cca.fadeTo(actTime, 1)
			;(nil)[3] = cca.rotateBy(actTime, 1080)
			;(nil)[4] = cca.rotateBy(actTime, 1080)
			;(nil)[5] = cca.rotateBy(actTime, 1080)
			self.Node_equipment:runAction(cca.spawn(nil))
			self.Node_chips:setVisible(false)
			self = self.Node_chips
			self.Node_chips.msg = "MESSAGE_UI_GODEQUIP_SHOWMODEL_UPDATE"
			SoraDSendMessage(self.Node_chips)
		end)
		cca.callFunc(function()
			actTime = nil
			;(nil)[1] = cca.scaleTo(actTime, 1)
			;(nil)[2] = cca.fadeTo(actTime, 1)
			;(nil)[3] = cca.rotateBy(actTime, 1080)
			;(nil)[4] = cca.rotateBy(actTime, 1080)
			;(nil)[5] = cca.rotateBy(actTime, 1080)
			self.Node_equipment:runAction(cca.spawn(nil))
			self.Node_chips:setVisible(false)
			self = self.Node_chips
			self.Node_chips.msg = "MESSAGE_UI_GODEQUIP_SHOWMODEL_UPDATE"
			SoraDSendMessage(self.Node_chips)
		end).byLTID = true
		SoraDConfigSet("Game:godEquipmentView:index~integer", self.index, cca.callFunc(function()
			actTime = nil
			;(nil)[1] = cca.scaleTo(actTime, 1)
			;(nil)[2] = cca.fadeTo(actTime, 1)
			;(nil)[3] = cca.rotateBy(actTime, 1080)
			;(nil)[4] = cca.rotateBy(actTime, 1080)
			;(nil)[5] = cca.rotateBy(actTime, 1080)
			self.Node_equipment:runAction(cca.spawn(nil))
			self.Node_chips:setVisible(false)
			self = self.Node_chips
			self.Node_chips.msg = "MESSAGE_UI_GODEQUIP_SHOWMODEL_UPDATE"
			SoraDSendMessage(self.Node_chips)
		end))
	elseif data.weaponID == miraculousWeaponltCtrl.getWeaponInfo(self.weaponID).unlockCondition then
		_ENV = miraculousWeaponltCtrl.getWeaponInfo(self.weaponID).unlockCondition
		miraculousWeaponltCtrl.getWeaponInfo(self.weaponID).unlockCondition.msg = "MESSAGE_SERVER_GODEQUIP_UNLOCK_UPDATE"
		miraculousWeaponltCtrl.getWeaponInfo(self.weaponID).unlockCondition.weaponID = self.weaponID
		SoraDSendMessage(miraculousWeaponltCtrl.getWeaponInfo(self.weaponID).unlockCondition)
	end
end
function godEquipmentChipsView:backNormalView(target, data)
	if self.index == data.index and self.selectChip and self.selectChip:getLocalZOrder() > 1 then
		for k, v in ipairs(self.baseConfig) do
			if v.chip ~= self.selectChip then
				v.chip:stopAllActions()
				_UPVALUE2_ = nil
				;(nil)[1] = cca.moveTo(0.3, v.pos.x, v.pos.y)
				;(nil)[2] = cca.scaleTo(0.3, v.scale)
				;(nil)[3] = cca.fadeTo(0.3, 1)
				;(nil)[4] = cca.fadeTo(0.3, 1)
				;(nil)[5] = cca.fadeTo(0.3, 1)
				;(nil)[6] = cca.fadeTo(0.3, 1)
				;(nil)[7] = cca.fadeTo(0.3, 1)
				;(nil)[8] = cca.fadeTo(0.3, 1)
				;(nil)[9] = cca.fadeTo(0.3, 1)
				;(nil)[10] = cca.fadeTo(0.3, 1)
				;(nil)[11] = cca.fadeTo(0.3, 1)
				v.chip:runAction(cca.spawn(nil))
			else
				self.selectChip:stopAllActions()
				self.selectChip:setLocalZOrder(0)
				_UPVALUE1_ = cca.spawn(nil)
				cca.spawn(nil)[1] = cca.moveTo(0.3, self.selectConfig.pos.x, self.selectConfig.pos.y)
				cca.spawn(nil)[2] = cca.scaleTo(0.3, self.selectConfig.scale)
				cca.spawn(nil)[3] = cca.scaleTo(0.3, self.selectConfig.scale)
				cca.spawn(nil)[4] = cca.scaleTo(0.3, self.selectConfig.scale)
				cca.spawn(nil)[5] = cca.scaleTo(0.3, self.selectConfig.scale)
				cca.spawn(nil)[6] = cca.scaleTo(0.3, self.selectConfig.scale)
				cca.spawn(nil)[7] = cca.scaleTo(0.3, self.selectConfig.scale)
				cca.spawn(nil)[8] = cca.scaleTo(0.3, self.selectConfig.scale)
				cca.spawn(nil)[9] = cca.scaleTo(0.3, self.selectConfig.scale)
				cca.spawn(nil)[10] = cca.scaleTo(0.3, self.selectConfig.scale)
				cca.spawn(nil)[11] = cca.scaleTo(0.3, self.selectConfig.scale)
				self.selectChip:runAction(cca.spawn(cca.spawn(nil)))
			end
			local delay = math.random(0, 100) / 100
			_UPVALUE4_ = cca.spawn(cca.spawn(nil))
			cca.spawn(cca.spawn(nil))[1] = cca.delay(delay + 0.3)
			cca.spawn(cca.spawn(nil))[2] = cca.moveTo(1, v.pos.x, v.pos.y + 5)
			cca.spawn(cca.spawn(nil))[3] = cca.moveTo(1, v.pos.x, v.pos.y - 5)
			cca.spawn(cca.spawn(nil))[4] = cca.moveTo(1, v.pos.x, v.pos.y + 3)
			cca.spawn(cca.spawn(nil))[5] = cca.moveTo(1, v.pos.x, v.pos.y - 3)
			cca.spawn(cca.spawn(nil))[6] = cca.moveTo(1, v.pos.x, v.pos.y - 3)
			cca.spawn(cca.spawn(nil))[7] = cca.moveTo(1, v.pos.x, v.pos.y - 3)
			cca.spawn(cca.spawn(nil))[8] = cca.moveTo(1, v.pos.x, v.pos.y - 3)
			v.chip:runAction(cc.RepeatForever:create(cca.seq(cca.spawn(cca.spawn(nil)))))
		end
		if self.isRun then
			self:stopActionByTag(1)
			self.isRun = false
		end
	end
end
function godEquipmentChipsView:btnChipCallBack(target, event, isNoSound)
	if event == ccui.TouchEventType.ended then
		if self.isRun then
			return
		end
		if self.isMoved then
			self.isMoved = false
			return
		end
		if not isNoSound then
			SoraDPlaySound()
		end
		print("点击碎片")
		if target.status == gWeaponChipStatus.UNLOCKED then
		elseif target.status == gWeaponChipStatus.LOCKED then
			if SoraDGetCastleLv() >= target.unlockLevel then
				SoraDShowMsgTip(i18n("weapon_text_21"))
				_ENV = i18n("weapon_text_21")
				i18n("weapon_text_21").msg = "MESSAGE_UI_GODEQUIP_TO_BEUNLOCK_CHIP"
				SoraDSendMessage(i18n("weapon_text_21"))
			else
				local ret, wlv, percent = buildLogic.isBuildWarLv(target.unlockLevel)
				if percent == 0 then
					_ENV = i18n("weapon_text_21")
					i18n("weapon_text_21").lv = wlv
					if i18n("weapon_text_01", i18n("weapon_text_21")) then
						goto lbl_70
					end
				end
				_ENV = i18n("weapon_text_21")
				i18n("weapon_text_21").lv = wlv .. "~" .. percent * 100 .. "%"
				local msg = i18n("weapon_text_01", i18n("weapon_text_21"))
				::lbl_70::
				SoraDShowMsgBox(msg, i18n("common_text_477"), nil, function(event)
					if event == MSGBOX_CALLBACK_YES then
						local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
						_ENV = nil
						;(nil).bid = BUILDID.CASTLE
						;(nil).lv = target.unlockLevel
						mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.BUILD_UPGRADE, nil)
						SoraDRemoveAllPanelFromManager()
					end
				end)
			end
		else
			self.selectConfig = self.baseConfig[target:getTag()]
			self.selectChip = target
			self.selectChip:setLocalZOrder(2)
			self.selectChip:stopAllActions()
			buildLogic = i18n("weapon_text_01", i18n("weapon_text_21"))
			i18n("weapon_text_01", i18n("weapon_text_21"))[1] = cca.moveTo(0.3, 0, 0)
			i18n("weapon_text_01", i18n("weapon_text_21"))[2] = cca.scaleTo(0.3, 1.5)
			i18n("weapon_text_01", i18n("weapon_text_21"))[3] = cca.scaleTo(0.3, 1.5)
			i18n("weapon_text_01", i18n("weapon_text_21"))[4] = cca.scaleTo(0.3, 1.5)
			i18n("weapon_text_01", i18n("weapon_text_21"))[5] = cca.scaleTo(0.3, 1.5)
			i18n("weapon_text_01", i18n("weapon_text_21"))[6] = cca.scaleTo(0.3, 1.5)
			i18n("weapon_text_01", i18n("weapon_text_21"))[7] = cca.scaleTo(0.3, 1.5)
			i18n("weapon_text_01", i18n("weapon_text_21"))[8] = cca.scaleTo(0.3, 1.5)
			i18n("weapon_text_01", i18n("weapon_text_21"))[9] = cca.scaleTo(0.3, 1.5)
			i18n("weapon_text_01", i18n("weapon_text_21"))[10] = cca.scaleTo(0.3, 1.5)
			i18n("weapon_text_01", i18n("weapon_text_21"))[11] = cca.scaleTo(0.3, 1.5)
			i18n("weapon_text_01", i18n("weapon_text_21"))[12] = cca.scaleTo(0.3, 1.5)
			self.selectChip:runAction(cca.spawn((i18n("weapon_text_01", i18n("weapon_text_21")))))
			for k, v in ipairs(self.baseConfig) do
				if k ~= target:getTag() then
					local _x = 0 < v.pos.x and v.pos.x - self.actMoveOffset or v.pos.x + self.actMoveOffset
					local _y = 0 < v.pos.y and v.pos.y - self.actMoveOffset or v.pos.y + self.actMoveOffset
					v.chip:stopAllActions()
					miraculousWeaponltCtrl = cca.spawn((i18n("weapon_text_01", i18n("weapon_text_21"))))
					cca.spawn((i18n("weapon_text_01", i18n("weapon_text_21"))))[1] = cca.moveTo(0.3, _x, _y)
					cca.spawn((i18n("weapon_text_01", i18n("weapon_text_21"))))[2] = cca.scaleTo(0.3, v.scale - 0.2)
					cca.spawn((i18n("weapon_text_01", i18n("weapon_text_21"))))[3] = cca.fadeTo(0.3, 0.2)
					cca.spawn((i18n("weapon_text_01", i18n("weapon_text_21"))))[4] = cca.fadeTo(0.3, 0.2)
					cca.spawn((i18n("weapon_text_01", i18n("weapon_text_21"))))[5] = cca.fadeTo(0.3, 0.2)
					v.chip:runAction(cca.spawn(cca.spawn((i18n("weapon_text_01", i18n("weapon_text_21"))))))
				end
			end
			_ENV = ipairs(self.baseConfig)
			ipairs(self.baseConfig).msg = "MESSAGE_UI_GODEQUIP_PANELTOUCH_UPDATE"
			ipairs(self.baseConfig).enable = true
			ipairs(self.baseConfig).chipStatus = self.selectChip.status
			SoraDSendMessage(ipairs(self.baseConfig))
			if target.status == gWeaponChipStatus.BEUNLOCK then
				self.isRun = true
				buildLogic = gWeaponChipStatus.BEUNLOCK
				gWeaponChipStatus.BEUNLOCK[1] = cca.delay(0.5)
				gWeaponChipStatus.BEUNLOCK[2] = cca.callFunc(function()
					local costTime = miraculousWeaponltCtrl.getChipsInfo(self.weaponID, target:getTag()).costTime
					local gold = serviceFunctions.timeConvertToGold(costTime)
					SoraDShowBuyBox(i18n("weapon_text_02"), gold, i18n("weapon_btn_01"), handler(self, self.unlockImmediately), true, nil, handler(self, self.unlockNormal), i18n("common_text_740"), costTime)
					self.isRun = false
				end)
				gWeaponChipStatus.BEUNLOCK[3] = cca.callFunc(function()
					local costTime = miraculousWeaponltCtrl.getChipsInfo(self.weaponID, target:getTag()).costTime
					local gold = serviceFunctions.timeConvertToGold(costTime)
					SoraDShowBuyBox(i18n("weapon_text_02"), gold, i18n("weapon_btn_01"), handler(self, self.unlockImmediately), true, nil, handler(self, self.unlockNormal), i18n("common_text_740"), costTime)
					self.isRun = false
				end)
				gWeaponChipStatus.BEUNLOCK[4] = cca.callFunc(function()
					local costTime = miraculousWeaponltCtrl.getChipsInfo(self.weaponID, target:getTag()).costTime
					local gold = serviceFunctions.timeConvertToGold(costTime)
					SoraDShowBuyBox(i18n("weapon_text_02"), gold, i18n("weapon_btn_01"), handler(self, self.unlockImmediately), true, nil, handler(self, self.unlockNormal), i18n("common_text_740"), costTime)
					self.isRun = false
				end)
				gWeaponChipStatus.BEUNLOCK[5] = cca.callFunc(function()
					local costTime = miraculousWeaponltCtrl.getChipsInfo(self.weaponID, target:getTag()).costTime
					local gold = serviceFunctions.timeConvertToGold(costTime)
					SoraDShowBuyBox(i18n("weapon_text_02"), gold, i18n("weapon_btn_01"), handler(self, self.unlockImmediately), true, nil, handler(self, self.unlockNormal), i18n("common_text_740"), costTime)
					self.isRun = false
				end)
				gWeaponChipStatus.BEUNLOCK[6] = cca.callFunc(function()
					local costTime = miraculousWeaponltCtrl.getChipsInfo(self.weaponID, target:getTag()).costTime
					local gold = serviceFunctions.timeConvertToGold(costTime)
					SoraDShowBuyBox(i18n("weapon_text_02"), gold, i18n("weapon_btn_01"), handler(self, self.unlockImmediately), true, nil, handler(self, self.unlockNormal), i18n("common_text_740"), costTime)
					self.isRun = false
				end)
				gWeaponChipStatus.BEUNLOCK[7] = cca.callFunc(function()
					local costTime = miraculousWeaponltCtrl.getChipsInfo(self.weaponID, target:getTag()).costTime
					local gold = serviceFunctions.timeConvertToGold(costTime)
					SoraDShowBuyBox(i18n("weapon_text_02"), gold, i18n("weapon_btn_01"), handler(self, self.unlockImmediately), true, nil, handler(self, self.unlockNormal), i18n("common_text_740"), costTime)
					self.isRun = false
				end)
				gWeaponChipStatus.BEUNLOCK[8] = cca.callFunc(function()
					local costTime = miraculousWeaponltCtrl.getChipsInfo(self.weaponID, target:getTag()).costTime
					local gold = serviceFunctions.timeConvertToGold(costTime)
					SoraDShowBuyBox(i18n("weapon_text_02"), gold, i18n("weapon_btn_01"), handler(self, self.unlockImmediately), true, nil, handler(self, self.unlockNormal), i18n("common_text_740"), costTime)
					self.isRun = false
				end)
				gWeaponChipStatus.BEUNLOCK[9] = cca.callFunc(function()
					local costTime = miraculousWeaponltCtrl.getChipsInfo(self.weaponID, target:getTag()).costTime
					local gold = serviceFunctions.timeConvertToGold(costTime)
					SoraDShowBuyBox(i18n("weapon_text_02"), gold, i18n("weapon_btn_01"), handler(self, self.unlockImmediately), true, nil, handler(self, self.unlockNormal), i18n("common_text_740"), costTime)
					self.isRun = false
				end)
				gWeaponChipStatus.BEUNLOCK[10] = cca.callFunc(function()
					local costTime = miraculousWeaponltCtrl.getChipsInfo(self.weaponID, target:getTag()).costTime
					local gold = serviceFunctions.timeConvertToGold(costTime)
					SoraDShowBuyBox(i18n("weapon_text_02"), gold, i18n("weapon_btn_01"), handler(self, self.unlockImmediately), true, nil, handler(self, self.unlockNormal), i18n("common_text_740"), costTime)
					self.isRun = false
				end)
				gWeaponChipStatus.BEUNLOCK[11] = cca.callFunc(function()
					local costTime = miraculousWeaponltCtrl.getChipsInfo(self.weaponID, target:getTag()).costTime
					local gold = serviceFunctions.timeConvertToGold(costTime)
					SoraDShowBuyBox(i18n("weapon_text_02"), gold, i18n("weapon_btn_01"), handler(self, self.unlockImmediately), true, nil, handler(self, self.unlockNormal), i18n("common_text_740"), costTime)
					self.isRun = false
				end)
				gWeaponChipStatus.BEUNLOCK[12] = cca.callFunc(function()
					local costTime = miraculousWeaponltCtrl.getChipsInfo(self.weaponID, target:getTag()).costTime
					local gold = serviceFunctions.timeConvertToGold(costTime)
					SoraDShowBuyBox(i18n("weapon_text_02"), gold, i18n("weapon_btn_01"), handler(self, self.unlockImmediately), true, nil, handler(self, self.unlockNormal), i18n("common_text_740"), costTime)
					self.isRun = false
				end)
				gWeaponChipStatus.BEUNLOCK[13] = cca.callFunc(function()
					local costTime = miraculousWeaponltCtrl.getChipsInfo(self.weaponID, target:getTag()).costTime
					local gold = serviceFunctions.timeConvertToGold(costTime)
					SoraDShowBuyBox(i18n("weapon_text_02"), gold, i18n("weapon_btn_01"), handler(self, self.unlockImmediately), true, nil, handler(self, self.unlockNormal), i18n("common_text_740"), costTime)
					self.isRun = false
				end)
				gWeaponChipStatus.BEUNLOCK[14] = cca.callFunc(function()
					local costTime = miraculousWeaponltCtrl.getChipsInfo(self.weaponID, target:getTag()).costTime
					local gold = serviceFunctions.timeConvertToGold(costTime)
					SoraDShowBuyBox(i18n("weapon_text_02"), gold, i18n("weapon_btn_01"), handler(self, self.unlockImmediately), true, nil, handler(self, self.unlockNormal), i18n("common_text_740"), costTime)
					self.isRun = false
				end)
				local msgBoxAction = cca.seq(gWeaponChipStatus.BEUNLOCK)
				msgBoxAction:setTag(1)
				self:runAction(msgBoxAction)
			end
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.isMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.isMoved = false
	end
end
function godEquipmentChipsView:unlockImmediately(event)
	if event == MSGBOX_CALLBACK_YES then
		miraculousWeaponCtrl:reqUnlock(self.weaponID, self.selectChip:getTag(), gUnlockOpType.GOLD)
	end
end
function godEquipmentChipsView:unlockNormal(event)
	if event == MSGBOX_CALLBACK_YES then
		miraculousWeaponCtrl:reqUnlock(self.weaponID, self.selectChip:getTag(), gUnlockOpType.NORMAL)
	end
end
return godEquipmentChipsView
