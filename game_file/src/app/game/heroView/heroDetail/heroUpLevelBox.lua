local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local buffCtrl = gametop.playertop_:getModule("buffCtrl")
local HeroUpLevelBox = class("heroUpLevelBox", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("heroUpLevelBox")
	end
	return target
end)
function HeroUpLevelBox:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.btnBuy = SoraDGetChildByName(self, "Button_buy")
	self.txtDownBuy = SoraDGetChildByName(self.btnBuy, "Text_title")
	self.txtUpBuy = SoraDGetChildByName(self.btnBuy, "Text_gold")
	self.btnUse = SoraDGetChildByName(self, "Button_use")
	self.txtDownUse = SoraDGetChildByName(self.btnUse, "Text_title")
	self.txtUpUse = SoraDGetChildByName(self.btnUse, "Text_gold")
	self.txtMsg = SoraDGetChildByName(self, "Text_msg")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("hero_text_66"))
	self.btnBuy:addTouchEventListener(handler(self, self.btnBuyClick))
	self.btnUse:addTouchEventListener(handler(self, self.btnUseClick))
	self.txtDownBuy:setString(i18n("hero_text_67"))
	self.txtDownUse:setString(i18n("hero_btn_01"))
	self.txtMsg:setString(i18n("hero_text_68"))
end
function HeroUpLevelBox:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STARTUPGRADE", function(...)
		self:removeFromParent()
	end)
end
function HeroUpLevelBox:initData(heroID)
	self.heroID = heroID
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.heroUpgradedInfo = heroltCtrl:getUpgradeInfo(self.heroID, self.heroInfo.quality + 1)
	self:initView()
end
function HeroUpLevelBox:initView(...)
	print("self.heroUpgradedInfo.upgradeTime=", self.heroUpgradedInfo.upgradeTime)
	local achiReduceTime = buffCtrl:getBuffEffect(gBuffEffect.HERO_UPGRADE_SPEED, gBuffSource.ACHIEVEMENT) or 0
	print("achiReduceTime=", achiReduceTime)
	self.realUpgradeTime = self.heroUpgradedInfo.upgradeTime * (1 / (1 + achiReduceTime / 1000))
	self.txtUpBuy:setString(serviceFunctions.timeConvertToGold(self.realUpgradeTime))
	self.txtUpUse:setString(SoraDConvertSecondToString(self.realUpgradeTime))
end
function HeroUpLevelBox:btnBuyClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if SoraDEnoughGold(serviceFunctions.timeConvertToGold(self.realUpgradeTime)) then
			heroCtrl:upgradeHeroReq(self.heroID, gHeroUpgradeType.IMMEDIATE)
			_ENV = self.heroID
			self.heroID.byUID = true
			local guideData = SoraDConfigGet("Game:heroList:guide~table", self.heroID)
			if not guideData.heroUpQuality then
				guideData.heroUpQuality = true
				_ENV = serviceFunctions.timeConvertToGold(self.realUpgradeTime)
				serviceFunctions.timeConvertToGold(self.realUpgradeTime).byUID = true
				SoraDConfigSet("Game:heroList:guide~table", guideData, serviceFunctions.timeConvertToGold(self.realUpgradeTime))
			end
		end
	end
end
function HeroUpLevelBox:btnUseClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		heroCtrl:upgradeHeroReq(self.heroID, gHeroUpgradeType.NORMAL)
		_ENV = self.heroID
		self.heroID.byUID = true
		local guideData = SoraDConfigGet("Game:heroList:guide~table", self.heroID)
		if not guideData.heroUpQuality then
			guideData.heroUpQuality = true
			_ENV = nil
			;(nil).byUID = true
			SoraDConfigSet("Game:heroList:guide~table", guideData, nil)
		end
	end
end
return HeroUpLevelBox
