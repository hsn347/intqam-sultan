local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local lordLocalData = include("lordLocalData")
local lordLevelUpView = class("lordLevelUpView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("lordLevelUpView")
	end
	return target
end)
function lordLevelUpView:ctor()
	if display.height < 960 then
		local scale = display.height / 960
		self._ccsView:setScale(scale)
		self._ccsView:setPosition((640 - 640 * scale) / 2, (960 - display.height) / 2)
	end
	self.isAddToPopManager = true
	self:setBackGround(204.0)
	self.lordLevel = 0
	self.rewards, _ENV, self.minShareLv = self.setBackGround, self.setBackGround, 5
	self.panel_cut = SoraDGetChildByName(self, "Center_node")
	self.btnClose = SoraDGetChildByName(self, "Button_closeBtn")
	self.btnClose:addTouchEventListener(handler(self, self.closeView))
	self.text_Count = SoraDGetChildByName(self, "Font_lv")
	self.labSkillPoint = SoraDGetChildByName(self, "Text_skill")
	self.labSkillPointDes = SoraDGetChildByName(self, "Text_skill_0")
	self.labSkillPointDes:setString(i18n("common_text_532"))
	self.labPower = SoraDGetChildByName(self, "Text_power")
	self.labPowerDes = SoraDGetChildByName(self, "Text_power_0")
	self.labPowerDes:setString(i18n("common_text_090"))
	self.btnShare = SoraDGetChildByName(self, "Button_share")
	self.btnShare:setOpacity(0)
	self.btnShare:addTouchEventListener(handler(self, self.shareLevelUp))
	self.text_share = SoraDGetChildByName(self, "Text_share")
	self.text_share:setString(i18n("common_text_533"))
	self.text_tip = SoraDGetChildByName(self, "Text_tips")
	self.text_tip:setString(i18n("common_text_1024"))
	self.text_tip:setVisible(false)
	SoraDPlaySound("uicontrol", 52)
	self:bandWidget()
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", handler(self, self.shareFacebookSuccess))
end
function lordLevelUpView:showAction()
	SoraDCreatAnimation(self.__cname, self, false)
	local effect_show, effectAction = SoraDCreatAnimation("lordLevelAll", nil, false, "start")
	effect_show:addTo(self.panel_cut)
	local lang = SoraDGetDefaultLanguage()
	local langNodeEN = SoraDGetChildByName(effect_show, "Node_en")
	local langNodeAR = SoraDGetChildByName(effect_show, "Node_ar")
	langNodeEN:setVisible(lang ~= "ar")
	langNodeAR:setVisible(lang == "ar")
	SoraDGetChildByName(self, "framer_levelup_ar_2"):setSpriteFrame("framer_levelup_ar.png")
	SoraDGetChildByName(self, "wenzi_9"):setSpriteFrame("framer_levelup_en.png")
	self.spine_bg = sp.SkeletonAnimation:create("spine/shengji.skel", "spine/shengji.atlas", 1)
	self.spine_bg:addTo(SoraDGetChildByName(effect_show, "Node_spine"), -1)
	self.spine_bg:setAnimation(0, "animation", false)
	self.spine_bg:setPositionY(-530)
	_UPVALUE1_ = "animation"
	;("animation")[1] = cca.delay(1.65)
	;("animation")[2] = cca.callFunc(function()
		effectAction:gotoFrameAndPlay(101, 201, true)
	end)
	;("animation")[3] = cca.callFunc(function()
		effectAction:gotoFrameAndPlay(101, 201, true)
	end)
	self:runAction(cca.seq("animation"))
end
function lordLevelUpView:bandWidget()
	local lordInfo = lordInfoCtrl:getBaseInfo()
	local curLevel = lordInfo.leve
	self.lordLevel = curLevel
	local lang = userSDKManager.getChannel()
	if curLevel >= self.minShareLv and lang ~= "fa" then
		self.btnShare:setVisible(true)
		self.text_tip:setVisible(true)
	else
		self.btnShare:setVisible(false)
		self.text_tip:setVisible(false)
	end
	self.text_Count:setString(curLevel)
	self.levelUpData = lordLocalData.rankData[curLevel]
	if SoraDFIsRA() then
		self.labSkillPoint:setString(self.levelUpData.skillPoint .. "+")
		self.labPower:setString(curLevel * 10 .. "+")
	else
		self.labSkillPoint:setString("+" .. self.levelUpData.skillPoint)
		self.labPower:setString("+" .. curLevel * 10)
	end
	self:initData(self.levelUpData.rewards)
	self:showAction()
end
function lordLevelUpView:initData(param)
	local ok, data = SoraDchangeToMap(param)
	if ok then
		for i = 1, 6 do
			if data[i] then
				local cowl = i % 3
				if cowl == 0 then
					cowl = 3
				end
				local line = math.ceil(i / 3)
				self.rewards[i] = include("rewardItemRound").new()
				_ENV = "rewardItemRound"
				;("rewardItemRound").itemID = data[i].key
				;("rewardItemRound").num = data[i].value
				self.rewards[i]:initData("rewardItemRound")
				self.rewards[i]:setItemStyle(3)
				self.rewards[i]:setTag(data[i].key)
				self.rewards[i]:setItemCallBack(handler(self, self.removeItemDes))
				self.rewards[i]:setItemTouchBeginHandle(handler(self, self.showItemDes))
				self.rewards[i]:setPosition(cc.p(0, 0))
				self.rewards[i]:setCascadeOpacityEnabled(true)
				self.rewards[i]:addTo(SoraDGetChildByName(self, string.format("xiaoyuan0%d_%d", i, i + 1)), 9)
			end
		end
	end
end
function lordLevelUpView:showItemDes(target)
	if self.tips then
		self.tips:removeFromParent()
		self.tips = nil
	end
	self.tips = SoraDCreatePanel("commonItemTips")
	self.tips:initData(target:getTag())
	local dt = 140
	if not SoraDFIsRA() then
		dt = -140
	end
	local posY = 300
	if target:getPositionY() == 210 then
		posY = 400
	end
	self.tips:setPosition(cc.p(self.panel_cut:getContentSize().width / 2 + dt, posY))
	self.tips:addTo(SoraDGetChildByName(self, "Center_node_1"), 99)
end
function lordLevelUpView:removeItemDes(target)
	if self.tips then
		self.tips:removeFromParent()
		self.tips = nil
	end
end
function lordLevelUpView:showGetRewards()
	local _ENV, listItem
	for i = 1, #self.levelUpData.rewards - 1, 2 do
		listItem[tostring(self.levelUpData.rewards[i])] = self.levelUpData.rewards[i + 1]
	end
	SoraDMailGainItems(listItem)
end
function lordLevelUpView:closeView(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).selfClose = true
		userSDKManager.logEvent(gSDKDef.TDonEvent.upgrade_share_log, nil)
		self:showGetRewards()
		lordInfoCtrl:sendUpgradePopLvMsg()
		self:removeFromParent()
		local gametop = gModuleMgr.getObject("gametop")
		local guideCtrl = gametop.playertop_:getModule("guideCtrl")
		guideCtrl:updateNewGuide()
	end
end
function lordLevelUpView:shareFacebookSuccess(...)
	SoraDShowMsgTip(i18n("common_text_1124"))
	_ENV = i18n("common_text_1124")
	i18n("common_text_1124").channel = gSDKDef.shareChannel.facebook
	userSDKManager.logEvent(gSDKDef.TDonEvent.lord_levelup_share_success, i18n("common_text_1124"))
	local facebookShareCtrl = gametop.playertop_:getModule("facebookShareCtrl")
	facebookShareCtrl:receiveLordLvUpShareReward()
	_ENV = gSDKDef.shareChannel.facebook
	gSDKDef.shareChannel.facebook.uptype = 1
	gSDKDef.shareChannel.facebook.level = lordInfoCtrl:getLevel()
	gSDKDef.shareChannel.facebook.uid = gametop.playertop_:getPlayerID()
	gSDKDef.shareChannel.facebook.kid = gametop.playertop_:getKingdomID()
	gSDKDef.shareChannel.facebook.shareResult = 1
	userSDKManager.logEvent(gSDKDef.TDonEvent.upgrade_share_log, gSDKDef.shareChannel.facebook)
	self:showGetRewards()
	lordInfoCtrl:sendUpgradePopLvMsg()
	self:removeFromParent()
	local gametop = gModuleMgr.getObject("gametop")
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	guideCtrl:updateNewGuide()
end
function lordLevelUpView:shareLevelUp(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).channel = gSDKDef.shareChannel.facebook
		userSDKManager.logEvent(gSDKDef.TDonEvent.lord_levelup_share_begin, nil)
		print("进入facebook分享界面")
		_ENV = nil
		;(nil).isClickShareFB = true
		userSDKManager.logEvent(gSDKDef.TDonEvent.upgrade_share_log, nil)
		local lordLv = SoraDGetCtrl("lordInfoCtrl"):getBaseInfo().leve
		_ENV = nil
		;(nil).level = lordLv
		local _url = SoraGetGameShareUrl("upgrade", gGameInvitePlatform.FACEBOOK, nil)
		userSDKManager.shareFacebookLinkContent(_url)
	end
end
return lordLevelUpView
