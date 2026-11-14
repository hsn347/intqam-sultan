local buildLogic = include("buildLogic")
local cityBuildMagicLamp = class("cityBuildMagicLamp", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
local cityBuildConstDef = include("cityBuildConstDef")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local BUBBLE_ACTION_TAG = 994
local FINGER_ACTION_TAG = 995
_ENV = nil
;(nil).strength = "img_lampalert_upgrade.png"
;(nil).star = "img_lampalert_stars.png"
;(nil).class = "img_lampalert_rank.png"
;(nil).pray = "img_lampalert_pumping.png"
;(nil).merge = "img_lampalert_atlas.png"
;(nil).hatch_gift = "img_lampalert_reward.png"
;(nil).hatch_up = "img_lampalert_rare.png"
local _UPVALUE1_, _ENV, _ENV, (nil).star_river, bubbleIcons = nil, nil, nil, "img_lampalert_galaxy.png", nil
_UPVALUE2_, (nil).cooling, (nil)[1] = nil, nil, "zhenni_skill01_loop"
_UPVALUE2_, (nil).show, (nil)[1] = nil, nil, "zhenni_show"
_UPVALUE2_, (nil).show, (nil)[2] = nil, nil, "zhenni_stand"
_UPVALUE1_, (nil).cooling_stand, (nil)[1] = nil, nil, "zhenni_skill02"
_UPVALUE1_, (nil).cooling_stand, (nil)[2] = nil, nil, "zhenni_stand"
_UPVALUE1_, (nil).stand, (nil)[1] = nil, nil, "zhenni_stand"
_UPVALUE1_, _ENV, (nil)[1], (nil).idle, (nil)[1] = nil, nil, nil, nil, "zhenni_idle"
_UPVALUE2_, (nil).cooling, (nil)[1] = nil, nil, "zhenni_skill01_loop"
_UPVALUE2_, (nil).show, (nil)[1] = nil, nil, "zhenni_show"
_UPVALUE2_, (nil).show, (nil)[2] = nil, nil, "zhenni_stand"
_UPVALUE1_, (nil).cooling_stand, (nil)[1] = nil, nil, "zhenni_skill02"
_UPVALUE1_, (nil).cooling_stand, (nil)[2] = nil, nil, "zhenni_stand"
_UPVALUE1_, (nil).stand, (nil)[1] = nil, nil, "zhenni_stand"
;(nil)[2], (nil).idle, (nil)[1] = nil, nil, "zhenni_idle"
local spineAnis
function cityBuildMagicLamp:ctor()
	print("cityBuildMagicLamp:ctor")
	self.isLocked = false
	self.notAddName = true
	self.spineAni = spineAnis[1]
	self:setBuildIndex(cityBuildConstDef.buildIndexDef.index_MagicLamp)
	local constantRead = include("constantRead")
	self.JINN_RANDOM_EFFECT_TIME = constantRead.getConstValue("JINN_RANDOM_EFFECT_TIME", 10)
	self.JINN_RANDOM_EFFECT_PERCENT = constantRead.getConstValue("JINN_RANDOM_EFFECT_PERCENT", 50)
	self.remainTime = self.JINN_RANDOM_EFFECT_TIME
	if not self.timeHandle then
		self.timeHandle = SoradCreateTimer(self, handler(self, self.updateTime))
	end
	self:setCullRect(0, 0, display.width, display.height)
end
function cityBuildMagicLamp:updateTime(time)
	if not self.isLampUnlock then
		return
	end
	self.remainTime = self.remainTime - 1
	if self.remainTime > 0 then
		return
	end
	self.remainTime = self.JINN_RANDOM_EFFECT_TIME
	if self.spinePlayingName ~= "zhenni_stand" then
		return
	end
	local isVisibility = self:checkIsVisibleInCullRect()
	if isVisibility and math.random(1, 100) <= self.JINN_RANDOM_EFFECT_PERCENT then
		self:updateSpineNPC("idle", self.spinePlayingName)
	end
end
function cityBuildMagicLamp:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_UPDATE", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_HATCH_UPDATE", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_UPDATE_NEBULA_MILESTONE", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_NEBULA_GET_TOWER_DATA", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_BUILD_STAR_UPGRADE", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILDSTAR_QUEQUE_CALLBACK", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.updateBubble))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_SKILL_LOTTERY_UPDATE", handler(self, self.updateBubble))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_UPDATE_BUBBLEDATA", handler(self, self.updateBubble))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateBubble))
	SoraDAddMessage(self, "MESSAGE_FIRE_JINN_UNLOCK", handler(self, self.updateFireJinnUnlock))
end
function cityBuildMagicLamp:loadView()
	self:loadBaseView()
	self.oldClassLvs, _UPVALUE0_, self.oldStarLvs, _UPVALUE0_, self.oldLvs, _UPVALUE0_ = self.loadBaseView, self.loadBaseView, self.loadBaseView, self.loadBaseView, self.loadBaseView, self.loadBaseView
	self:updateView()
end
function cityBuildMagicLamp:msgUpdateView(target, data)
	self:updateView()
	self:updateFireJinnUnlock()
end
function cityBuildMagicLamp:getCoolingQueue()
	local queueCtrl = SoraDGetCtrl("queueCtrl")
	local breakQueue = queueCtrl:queryQueue(gQueueTypeDef.magic_lamp_jinn_star)
	local classQueue = queueCtrl:queryQueue(gQueueTypeDef.magic_lamp_jinn_class)
	local strengthQueue = queueCtrl:queryQueue(gQueueTypeDef.magic_lamp_jinn_level)
	local hatchUpQueue = queueCtrl:queryQueue(gQueueTypeDef.magic_lamp_hatch_level)
	return breakQueue, classQueue, strengthQueue, hatchUpQueue
end
function cityBuildMagicLamp:updateView()
	local isShowBuild = magicLampCtrl:getIsBuildShow()
	local parent = self:getParent()
	if parent then
		parent:setVisible(isShowBuild)
	end
	self.lastIsShowBuild = isShowBuild
	self:checkShowBuildTimer(isShowBuild)
	if not isShowBuild then
		return
	end
	self:updateIsLock()
	self.isLampUnlock = magicLampCtrl:getIsUnlock()
	self.isNeedShowUpEffect = false
	if self.isLampUnlock then
		local jinnDatas = magicLampCtrl:getJinnList()
		for i, v in ipairs(jinnDatas) do
			local jinnData = v
			local jinnType = self.curType
			self.isNeedShowUpEffect = self.isNeedShowUpEffect or self.oldClassLvs[jinnType] and self.oldClassLvs[jinnType] ~= jinnData.classLv or self.oldStarLvs[jinnType] and self.oldStarLvs[jinnType] ~= jinnData.starLv
			self.oldLvs[jinnType] = jinnData.lv
			self.oldStarLvs[jinnType] = jinnData.starLv
			self.oldClassLvs[jinnType] = jinnData.classLv
		end
	end
	local breakQueue, classQueue, strengthQueue, hatchUpQueue = self:getCoolingQueue()
	self.isLampCooling = breakQueue ~= nil or classQueue ~= nil or strengthQueue ~= nil or hatchUpQueue ~= nil
	self:updateMaigcLampEffect()
	self:updateBubble()
	magicLampCtrl = self
	self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_MAGIC_LAMP_COOLING_PANEL"
	self.buildIndex = self.buildIndex
	self.buildEntity = self
	SoraDSendMessage(self)
end
function cityBuildMagicLamp:updateMaigcLampEffect()
	local worldMapDefine = include("worldMapDefine")
	if self.isLampUnlock then
		if self.notAddName then
			self.notAddName = false
			_ENV = nil
			_ENV, (nil).name = i18n("magic_lamp_title_01"), i18n("magic_lamp_title_01")
			i18n("magic_lamp_title_01").x = 0
			;(nil).pos, i18n("magic_lamp_title_01").y = i18n("magic_lamp_title_01"), -100
			SoraDShowNameOnTouchEvent(self, nil)
		end
		self:stopActionByTag(FINGER_ACTION_TAG)
		if self.unlockFinger ~= nil then
			self.unlockFinger:removeFromParent()
			self.unlockFinger = nil
		end
		local spName = "#dh_shendengdj_01.png"
		local framesName = "dh_shendengdj_%02d.png"
		if self.normalEf == nil then
			self.normalEf = display.newSprite(spName)
			self.normalEf:addTo(self, 6)
		end
		if self.isLampCooling then
			spName = "#dh_sd_qhsj_cd_ADD_01.png"
			framesName = "dh_sd_qhsj_cd_ADD_%02d.png"
			self.normalEf:setBlendFunc(gl.ONE, gl.ONE)
			self.normalEf:setPosition(-19, 92)
			self.normalEf:setScale(1.7999999999999998)
		else
			self.normalEf:setBlendFunc(gl.ONE, gl.ONE)
			self.normalEf:setPosition(-19, 92)
			self.normalEf:setScale(1.2)
			if self.isNeedShowUpEffect and not SoraDGetChildByName(self, "upgradeCri") then
				local upgradeCri = cc.criSprite.createCriSprite("G_sd_sjcg.usm", true)
				upgradeCri:setScale(1.2)
				upgradeCri:setBlendFunc(gl.ONE, gl.ONE)
				upgradeCri:setName("upgradeCri")
				upgradeCri:setPosition(-19, 92)
				upgradeCri:addTo(self, 7)
			end
		end
		self.normalEf:stopAllActions()
		local frames = display.newFrames(framesName, 1, 30)
		local animation = display.newAnimation(frames, 0.06666666666666667)
		self.normalEf:playAnimationForever(animation)
		if self.isLocked then
			self.isLocked = false
			if not SoraDGetChildByName(self, "upgradeCri") then
				local upgradeCri = cc.criSprite.createCriSprite("G_shendengjiesuo_01.usm", true)
				upgradeCri:setScale(1.2)
				upgradeCri:setBlendFunc(gl.ONE, gl.ONE)
				upgradeCri:setPosition(-19, 92)
				upgradeCri:setName("upgradeCri")
				upgradeCri:addTo(self, 7)
			end
			self:updateSpineNPC("show")
		elseif self.isLampCooling then
			self:updateSpineNPC("cooling")
		elseif self.isNeedShowUpEffect or self.spinePlayingName == self.spineAni.cooling[1] then
			self:updateSpineNPC("cooling_stand")
		else
			self:updateSpineNPC("stand")
		end
		if SoraDGetCtrl("guideCtrl"):updateGuideModule(gGuideModule.MAGIC_LAMP) then
			SoraDRemoveAllAfterPanelFromManager(self, true)
		end
	else
		if self.normalEf then
			self.normalEf:removeFromParent()
			self.normalEf = nil
		end
		if self.spineNpc then
			self.spineNpc:removeFromParent()
			self.spineNpc = nil
		end
		self.isLocked = true
		local isCanUnock = magicLampCtrl:getIsCanUnlock()
		if isCanUnock then
			if self.unlockFinger ~= nil then
				self.unlockFinger:setVisible(true)
				return
			end
			self:stopActionByTag(FINGER_ACTION_TAG)
			FINGER_ACTION_TAG = self
			self[1] = cca.delay(1)
			self[2] = cca.callFunc(function()
				if self.unlockFinger == nil then
					local parent = self:getParent()
					self.unlockFinger = SoraDFingerAction()
					local posX, posY = parent:getPosition()
					self.unlockFinger:setPosition(posX, posY + 30)
					self.unlockFinger:addTo(parent:getParent(), 1800)
				end
			end)
			self[3] = cca.callFunc(function()
				if self.unlockFinger == nil then
					local parent = self:getParent()
					self.unlockFinger = SoraDFingerAction()
					local posX, posY = parent:getPosition()
					self.unlockFinger:setPosition(posX, posY + 30)
					self.unlockFinger:addTo(parent:getParent(), 1800)
				end
			end)
			self[4] = cca.callFunc(function()
				if self.unlockFinger == nil then
					local parent = self:getParent()
					self.unlockFinger = SoraDFingerAction()
					local posX, posY = parent:getPosition()
					self.unlockFinger:setPosition(posX, posY + 30)
					self.unlockFinger:addTo(parent:getParent(), 1800)
				end
			end)
			self[5] = cca.callFunc(function()
				if self.unlockFinger == nil then
					local parent = self:getParent()
					self.unlockFinger = SoraDFingerAction()
					local posX, posY = parent:getPosition()
					self.unlockFinger:setPosition(posX, posY + 30)
					self.unlockFinger:addTo(parent:getParent(), 1800)
				end
			end)
			self[6] = cca.callFunc(function()
				if self.unlockFinger == nil then
					local parent = self:getParent()
					self.unlockFinger = SoraDFingerAction()
					local posX, posY = parent:getPosition()
					self.unlockFinger:setPosition(posX, posY + 30)
					self.unlockFinger:addTo(parent:getParent(), 1800)
				end
			end)
			local action = cca.seq(self)
			action:setTag(FINGER_ACTION_TAG)
			self:runAction(action)
		elseif self.unlockFinger ~= nil then
			self.unlockFinger:setVisible(false)
		end
	end
end
function cityBuildMagicLamp:updateSpineNPC(aniName, _spineName2)
	self.spineAni = spineAnis[magicLampCtrl:getShowingJinn()]
	local spineName = self.spineAni[aniName][1]
	if self.spinePlayingName == spineName or self.spineAniName == aniName then
		return
	end
	local spineName2 = _spineName2 or self.spineAni[aniName][2]
	self.spineAniName = aniName
	self.spinePlayingName = spineName2 or spineName
	if self.spineNpc then
		self.spineNpc:removeFromParent()
	end
	self.spineNpc = self:createSpineNpc(spineName, spineName2 == nil)
	if spineName2 ~= nil then
		self.spineNpc:registerSpineEventHandler(function(data)
			if data.type == "complete" then
				self.spineNpc:setVisible(false)
				_ENV = nil
				;(nil)[1] = cca.delay(0)
				;(nil)[2] = cca.removeSelf()
				self.spineNpc:runAction(cca.seq(nil))
				self.spineNpc = self:createSpineNpc(spineName2, true)
				self.spineAniName = nil
			end
		end, sp.EventType.ANIMATION_COMPLETE)
	end
end
function cityBuildMagicLamp:createSpineNpc(spineName, loop)
	local spineNpc = sp.SkeletonAnimation:create("spine/magiclamp/" .. spineName .. ".skel", "spine/magiclamp/" .. spineName .. ".atlas", 1)
	spineNpc:addTo(self, 7)
	spineNpc:setPosition(10, 100)
	spineNpc:setAnimation(0, spineName, loop)
	return spineNpc
end
function cityBuildMagicLamp:updateBubble()
	if not self.isLampUnlock then
		return
	end
	self:stopActionByTag(BUBBLE_ACTION_TAG)
	local func = function()
		local bubbleType, jumpJinnType
		if not self.isLampCooling then
			bubbleType, jumpJinnType = magicLampCtrl:getShowBubbleType()
			self.jumpJinnType = jumpJinnType
		end
		if bubbleType ~= nil then
			self:showBubble(bubbleType)
			return
		end
		local magicLampSkillLotteryCtrl = SoraDGetCtrl("magicLampSkillLotteryCtrl")
		self.jumpMagicPoolId = magicLampSkillLotteryCtrl:getIsShowFreeBubble()
		if self.jumpMagicPoolId ~= nil then
			bubbleType = "pray"
			self:showBubble(bubbleType)
			return
		end
		local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
		local isCanGetReward, jumpHatchType = magicLampHatchCtrl:getIsCanGetReaward()
		if isCanGetReward then
			bubbleType = "hatch_gift"
			self.jumpHatchType = jumpHatchType
			self:showBubble(bubbleType)
			return
		end
		local isCanHatchUp, jumpHatchType = magicLampHatchCtrl:getIsCanHatchUp()
		if isCanHatchUp then
			bubbleType = "hatch_up"
			self.jumpHatchType = jumpHatchType
			self:showBubble(bubbleType)
			return
		end
		local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
		if magicLampSkillCtrl:checkMergeItemEnough() then
			bubbleType = "merge"
			self:showBubble(bubbleType)
			return
		end
		self:showBubble(nil)
	end
	magicLampCtrl = BUBBLE_ACTION_TAG
	BUBBLE_ACTION_TAG[1] = cca.delay(1.0)
	BUBBLE_ACTION_TAG[2] = cca.callFunc(func)
	BUBBLE_ACTION_TAG[3] = cca.callFunc(func)
	local action = cca.seq(BUBBLE_ACTION_TAG)
	action:setTag(BUBBLE_ACTION_TAG)
	self:runAction(action)
end
function cityBuildMagicLamp:showBubble(bubbleType)
	if bubbleType == nil then
	end
	local icon = bubbleIcons[bubbleType]
	bubbleIcons = nil
	;(nil).msg = "MESSAGE_MAGICLAMP_TOPTIP_UPDATE"
	;(nil).bubbleType = bubbleType
	;(nil).bubbleIcon = icon
	;(nil).jumpMagicPoolId = self.jumpMagicPoolId
	;(nil).jumpHatchType = self.jumpHatchType
	;(nil).jumpJinnType = self.jumpJinnType
	SoraDSendMessage(nil)
end
function cityBuildMagicLamp:updateFireJinnUnlock()
	if SoraDIsGameGuide() then
		return
	end
	local jinnData = magicLampCtrl:getJinnByType(gJinnType.JINN_TWO)
	if jinnData then
		_UPVALUE3_ = gJinnType.JINN_TWO
		gJinnType.JINN_TWO[1] = jinnData
		gJinnType.JINN_TWO[2] = jinnData.lock
		gJinnType.JINN_TWO[3] = jinnData.canUnLock
		dump(gJinnType.JINN_TWO, "jinnData and jinnData.lock and jinnData.canUnLock")
	end
	if jinnData and jinnData.lock and jinnData.canUnLock then
		if uiManager:getProxy("MagicLampHatch") then
			_ENV = uiManager
			uiManager.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
			uiManager.step = 941099
			SoraDSendMessage(uiManager)
		else
			_ENV = uiManager
			uiManager.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
			uiManager.step = 941100
			SoraDSendMessage(uiManager)
		end
	end
end
function cityBuildMagicLamp:checkShowBuildTimer(isShowBuild)
	if isShowBuild then
		if self.showBuildTimer ~= nil then
			SoraDManagerRemoveTimer(self, self.showBuildTimer)
			self.showBuildTimer = nil
		end
	elseif self.showBuildTimer == nil then
		self.showBuildTimer = SoraDCreateTimerEx(self, handler(self, self.updateShowBuilderTime), 5)
	end
end
function cityBuildMagicLamp:updateShowBuilderTime()
	local isShowBuild = magicLampCtrl:getIsBuildShow()
	if isShowBuild then
		self:updateView()
	end
end
return cityBuildMagicLamp
