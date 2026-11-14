local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local buffCtrl = gametop.playertop_:getModule("buffCtrl")
local heroAwakePopChooseView = class("heroAwakePopChooseView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("heroAwakePopChooseView")
	end
	return target
end)
function heroAwakePopChooseView:ctor()
	self:initControls()
end
function heroAwakePopChooseView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STARTUPGRADE", function(...)
		self:removeFromParent()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_DRESS_UPDATE", function()
		self:initData(self.heroID, self.upgradeType)
	end)
end
function heroAwakePopChooseView:initControls()
	self.btnInstance = SoraDGetChildByName(self, "btn_instance")
	self.btnUpgrade = SoraDGetChildByName(self, "btn_upgrade")
	self.txtInstance = SoraDGetChildByName(self, "text_instance")
	self.txtUpgrade = SoraDGetChildByName(self, "text_upgrade")
	self.txtInstanceGold = SoraDGetChildByName(self, "text_instanceNum")
	self.txtUpgradeTime = SoraDGetChildByName(self, "text_upgradeTime")
	self.txtInstruction = SoraDGetChildByName(self, "text_instruction")
	self.nodeNow = SoraDGetExtendChildFromCCSByName(self, "CCS_heroShowItem_now")
	self.nodeNext = SoraDGetExtendChildFromCCSByName(self, "CCS_heroShowItem_next")
	self.Node_arrow = SoraDGetChildByName(self, "Node_arrow")
	self.Node_time = SoraDGetChildByName(self.btnUpgrade, "Node_time")
	_ENV, self.tableArrowOpacity, _ENV, self.Node_gold = SoraDGetChildByName(self.btnInstance, "Node_gold"), SoraDGetChildByName(self.btnInstance, "Node_gold"), SoraDGetChildByName(self.btnInstance, "Node_gold"), SoraDGetChildByName(self.btnInstance, "Node_gold")
	SoraDGetChildByName(self.btnInstance, "Node_gold")[1] = SoraDGetChildByName(self, "Sprite_arrow_1")
	SoraDGetChildByName(self.btnInstance, "Node_gold")[2] = SoraDGetChildByName(self, "Sprite_arrow_2")
	self.tableArrow, SoraDGetChildByName(self.btnInstance, "Node_gold")[3] = SoraDGetChildByName(self.btnInstance, "Node_gold"), SoraDGetChildByName(self, "Sprite_arrow_3")
	self.btnInstance:addTouchEventListener(handler(self, self.btnInstanceClickCallBack))
	self.btnUpgrade:addTouchEventListener(handler(self, self.btnUpgradeClickCallBack))
end
function heroAwakePopChooseView:flashingAnimation()
	local delay = isQuick and 0.2 or 1
	for i, v in ipairs(self.tableArrow) do
		table.insert(self.tableArrowOpacity, v:getOpacity() / 255)
	end
	for i, v in ipairs(self.tableArrow) do
		v:stopAllActions()
		v:setOpacity(self.tableArrowOpacity[i])
		_UPVALUE3_ = nil
		;(nil)[1] = cca.delay((i - 1) * 0.2 * delay)
		;(nil)[2] = cca.fadeTo(0.1 * delay, self.tableArrowOpacity[i])
		;(nil)[3] = cca.delay((#self.tableArrow - i) * 0.2 * delay + 0.3 * delay)
		;(nil)[4] = cca.fadeTo(0.2 * delay, 0)
		;(nil)[5] = cca.fadeTo(0.2 * delay, 0)
		;(nil)[6] = cca.fadeTo(0.2 * delay, 0)
		v:runAction(cca.repeatForever(cca.seq(nil)))
	end
end
function heroAwakePopChooseView:initData(heroID, upgradeType)
	self.heroID = heroID
	self.upgradeType = upgradeType or gHeroSysUpType.UPGRADE
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.heroUpgradedInfo = heroltCtrl:getUpgradeInfo(self.heroID, self.heroInfo.quality + 1)
	self:initView()
end
function heroAwakePopChooseView:initView(...)
	local costTime = 0
	if self.upgradeType == gHeroSysUpType.UPGRADE then
		self.Node_arrow:setVisible(true)
		self.nodeNext:setVisible(true)
		self:flashingAnimation()
		self.nodeNext:initData(self.heroID)
		self.nodeNext:setHeadBg(self.heroInfo.quality + 1)
		self.txtInstruction:setString(i18n("hero_text_68"))
		self.txtUpgrade:setString(i18n("hero_btn_01"))
		self.txtInstance:setString(i18n("hero_text_67"))
		costTime = self.heroUpgradedInfo.upgradeTime
	else
		self.Node_arrow:setVisible(false)
		self.nodeNext:setVisible(false)
		self.nodeNow:setPositionX(0)
		self.txtInstruction:setString(i18n("heroskill_text_02"))
		self.txtUpgrade:setString(i18n("hero_btn_04"))
		self.txtInstance:setString(i18n("hero_btn_05"))
		costTime = heroltCtrl:getAwakeInfo(self.heroID).time
	end
	local achiReduceTime = buffCtrl:getBuffEffect(gBuffEffect.HERO_UPGRADE_SPEED, gBuffSource.ACHIEVEMENT) or 0
	self.realUpgradeTime = costTime * (1 / (1 + achiReduceTime / 1000))
	self.txtInstanceGold:setString(serviceFunctions.timeConvertToGold(self.realUpgradeTime))
	self.txtUpgradeTime:setString(SoraDConvertSecondToString(self.realUpgradeTime))
	SoraDToCenter(self.Node_time)
	SoraDToCenter(self.Node_gold)
	self.nodeNow:initData(self.heroID)
	self.nodeNow:setHeadBg(self.heroInfo.quality)
end
function heroAwakePopChooseView:btnInstanceClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if SoraDEnoughGold(serviceFunctions.timeConvertToGold(self.realUpgradeTime)) then
			heroCtrl:upgradeHeroReq(self.heroID, gHeroUpgradeType.IMMEDIATE, self.upgradeType)
			_ENV = self.heroID
			self.heroID.byUID = true
			local guideData = SoraDConfigGet("Game:heroList:guide~table", self.heroID)
			if not guideData.heroUpQuality then
				guideData.heroUpQuality = true
				_ENV = self.upgradeType
				self.upgradeType.byUID = true
				SoraDConfigSet("Game:heroList:guide~table", guideData, self.upgradeType)
			end
		end
	end
end
function heroAwakePopChooseView:btnUpgradeClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local obj, upgradeType = heroCtrl:getUpgradeQueue()
		local ret = obj and obj ~= self.heroID
		if ret then
			if upgradeType == gHeroSysUpType.UPGRADE then
				SoraDShowMsgTip(i18n("hero_text_09"))
			else
				SoraDShowMsgTip(i18n("hero_text_107"))
			end
		else
			heroCtrl:upgradeHeroReq(self.heroID, gHeroUpgradeType.NORMAL, self.upgradeType)
			_ENV = self.heroID
			self.heroID.byUID = true
			local guideData = SoraDConfigGet("Game:heroList:guide~table", self.heroID)
			if not guideData.heroUpQuality then
				guideData.heroUpQuality = true
				_ENV = self.upgradeType
				self.upgradeType.byUID = true
				SoraDConfigSet("Game:heroList:guide~table", guideData, self.upgradeType)
			end
		end
	end
end
return heroAwakePopChooseView
