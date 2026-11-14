local buildLogic = include("buildLogic")
local buildRead = include("buildDescribeRead")
local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local cityltCtrl = include("cityltCtrl")
local resurrectionCtrl = gametop.playertop_:getModule("resurrectionCtrl")
local buildTipButton = class("buildTipButton", function(target)
	local view = include("baseView")
	return view.new(cc.size(0, 0), false)
end)
function buildTipButton:ctor()
	self.opType = nil
	self.buildEntity = nil
	self.handler = nil
	self.isActive = true
	self:createUI()
	self.isActive = true
end
function buildTipButton:createUI()
	local button = ccui.Button:create()
	button:setTouchEnabled(true)
	button:loadTextures("frame_common_round.png", "frame_common_round.png", "frame_common_round.png", ccui.TextureResType.plistType)
	button:setPressedActionEnabled(true)
	button:addTo(self)
	self.button = button
	local icon = ccui.ImageView:create()
	icon:ignoreContentAdaptWithSize(false)
	icon:setContentSize(cc.size(110, 110))
	icon:setPosition(cc.p(49, 49))
	icon:loadTexture("icon_building_levelup.png", ccui.TextureResType.plistType)
	icon:addTo(self.button)
	icon.isGray = 0
	self.icon = icon
	local textTopBg = display.newNode()
	textTopBg:addTo(button)
	textTopBg:setPosition(cc.p(49, 110))
	self.textTopBg = textTopBg
	local imgLeft = ccui.ImageView:create()
	imgLeft:loadTexture("frame_sheer_black_07.png", ccui.TextureResType.plistType)
	imgLeft:ignoreContentAdaptWithSize(false)
	imgLeft:setContentSize(cc.size(49, 24))
	imgLeft:setAnchorPoint(cc.p(1, 0.5))
	imgLeft:setPosition(cc.p(0, 0))
	imgLeft:addTo(textTopBg)
	local imgRight = ccui.ImageView:create()
	imgRight:loadTexture("frame_sheer_black_07.png", ccui.TextureResType.plistType)
	imgRight:ignoreContentAdaptWithSize(false)
	imgRight:setContentSize(cc.size(49, 24))
	imgRight:setAnchorPoint(cc.p(1, 0.5))
	imgRight:setPosition(cc.p(0, 0))
	imgRight:setFlippedX(true)
	imgRight:addTo(textTopBg)
	local iconSmall = display.newSprite("#icon_small_gold.png")
	iconSmall:addTo(button)
	iconSmall:setPosition(cc.p(17, 110))
	iconSmall:setScale(0.85)
	self.iconSmall = iconSmall
	local textMiddle = ccui.Text:create()
	textMiddle:setName("textMiddle")
	textMiddle:enableOutline(cc.c3b(44, 26, 3), 2)
	textMiddle:enableShadow()
	textMiddle:setFontSize(22)
	textMiddle:setColor(cc.c3b(215, 175, 20))
	textMiddle:setPosition(cc.p(49, 76))
	textMiddle:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	textMiddle:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	textMiddle:addTo(button)
	self.textMiddle = textMiddle
	local textTop = ccui.Text:create()
	textTop:setName("textTop")
	textTop:enableOutline(cc.c3b(44, 26, 3), 2)
	textTop:enableShadow()
	textTop:setFontSize(22)
	textTop:setColor(cc.c3b(215, 175, 20))
	textTop:setPosition(cc.p(84, 110))
	textTop:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	textTop:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	textTop:addTo(button)
	self.textTop = textTop
	local textBg = display.newNode()
	textBg:addTo(button)
	textBg:setPosition(cc.p(49, 1.5))
	self.textBg = textBg
	local imgBg = ccui.ImageView:create()
	imgBg:loadTexture("frame_sheer_black_01.png", ccui.TextureResType.plistType)
	imgBg:ignoreContentAdaptWithSize(false)
	imgBg:setContentSize(cc.size(148, 26))
	imgBg:setAnchorPoint(cc.p(0.5, 1))
	imgBg:setPosition(cc.p(0, 12))
	imgBg:addTo(self.textBg)
	self.imgBg = imgBg
	local text = ccui.Text:create()
	text:setFontSize(21)
	text:setColor(cc.c3b(240, 230, 210))
	text:setAnchorPoint(cc.p(0.5, 1))
	text:setPosition(cc.p(49, 12))
	text:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	text:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	text:addTo(button)
	self.text = text
	self.text:enableOutline(cc.c3b(0, 0, 0), 2)
	self.text:enableShadow()
	local textBottomBg = display.newNode()
	textBottomBg:addTo(button)
	textBottomBg:setPosition(cc.p(49, 27))
	self.textBottomBg = textBottomBg
	local imgBtLeft = ccui.ImageView:create()
	imgBtLeft:loadTexture("frame_sheer_black_07.png", ccui.TextureResType.plistType)
	imgBtLeft:ignoreContentAdaptWithSize(false)
	imgBtLeft:setContentSize(cc.size(49, 24))
	imgBtLeft:setAnchorPoint(cc.p(1, 0.5))
	imgBtLeft:setPosition(cc.p(0, 0))
	imgBtLeft:addTo(textBottomBg)
	local imgBtRight = ccui.ImageView:create()
	imgBtRight:loadTexture("frame_sheer_black_07.png", ccui.TextureResType.plistType)
	imgBtRight:ignoreContentAdaptWithSize(false)
	imgBtRight:setContentSize(cc.size(49, 24))
	imgBtRight:setAnchorPoint(cc.p(1, 0.5))
	imgBtRight:setPosition(cc.p(0, 0))
	imgBtRight:setFlippedX(true)
	imgBtRight:addTo(textBottomBg)
	local textBottom = ccui.Text:create()
	textBottom:setFontSize(22)
	textBottom:setColor(cc.c3b(130, 210, 130))
	textBottom:setAnchorPoint(cc.p(0.5, 0.5))
	textBottom:setPosition(cc.p(53, 27))
	textBottom:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	textBottom:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	textBottom:addTo(button)
	self.textBottom = textBottom
end
function buildTipButton:reset()
	self.opType = nil
	self.buildEntity = nil
	self.handler = nil
	self.isActive = true
	self.icon:setScale(1.0)
	self.textMiddle:setColor(cc.c3b(215, 175, 20))
	self.textMiddle:setPosition(cc.p(49, 76))
	if self.icon.isGray == 1 then
		self.icon:getVirtualRenderer():setState(0)
		self.icon.isGray = 0
	end
	self.icon:setPosition(cc.p(49, 49))
	self:endTime()
	if self.isShowLifeTreeEffect then
		self:hideLiftTreeEffect(false)
	end
	if self.isShowPremiumVipEffect then
		self:hidePremiumVipEffect(false)
	end
	if self.isShowPavilionEffect then
		self:hidePavilionEffect(false)
	end
	if self.isShowDecorateEffect then
		self:hideDecorateEffect(false)
	end
	if self.isShowPyramidEffect then
		self:removePyramidEntranceEfftct()
	end
	if self.isShowLowGuide then
		self:hideLowGuideEffect(false)
	end
	self.icon:setFlippedX(false)
	self.text:setString("")
	gModuleMgr.sharedMgr("mildGuideManager"):deleteRunEffect(self)
end
function buildTipButton:initWithData(data)
	if nil == data or nil == data.opType then
		return
	end
	local nationCtrl = SoraDGetCtrl("factionCtrl")
	self.opType = nationCtrl:getBuildTipButtonCfgById(data.opType.btnId)
	if self.opType == nil then
		return
	end
	self.buildEntity = data.buildEntity
	self.handler = data.handler
	local iconFile = self.opType.PicFile
	local bid = tonumber(self.buildEntity:getBuildBid())
	if self.opType.OpName == BOP_NAME.BOP_BOOST_BY_TOOL then
		if bid == BUILDID.FARM then
			iconFile = "icon_building_up_food.png"
		elseif bid == BUILDID.SAWMILL then
			iconFile = "icon_building_up_wood.png"
		elseif bid == BUILDID.IRON_MINE then
			iconFile = "icon_building_up_iron.png"
		elseif bid == BUILDID.STEEL then
			iconFile = "icon_building_up_silver.png"
		elseif bid == BUILDID.CRYSTAL_MINE then
			iconFile = "icon_building_up_crystal.png"
		end
	elseif self.opType.OpName == BOP_NAME.BOP_COLLECT then
		if bid == BUILDID.FARM then
			iconFile = "icon_middle_food.png"
		elseif bid == BUILDID.SAWMILL then
			iconFile = "icon_middle_wood.png"
		elseif bid == BUILDID.IRON_MINE then
			iconFile = "icon_middle_iron.png"
		elseif bid == BUILDID.STEEL then
			iconFile = "icon_middle_silver.png"
		elseif bid == BUILDID.CRYSTAL_MINE then
			iconFile = "icon_middle_crystal.png"
		end
	elseif self.opType.OpName == BOP_NAME.BOP_PET_EXCHANGE then
		iconFile = "icon_building_exchange_enter.png"
	end
	self.icon:loadTexture(iconFile, ccui.TextureResType.plistType)
	self.icon:ignoreContentAdaptWithSize(true)
	self.text:ignoreContentAdaptWithSize(true)
	self.text:setTextAreaSize(cc.size(0, 0))
	self.text:setString(i18n(self.opType.Desc))
	if bid == BUILDID.STAR_BRAVE_STATUE and self.opType.OpName == BOP_NAME.BOP_STARSPEEDUP then
		self.text:setString(i18n("common_text_018"))
	end
	self.textBottom:setVisible(false)
	self.textBottomBg:setVisible(false)
	self.textTop:setVisible(false)
	self.textTopBg:setVisible(false)
	self.iconSmall:setVisible(false)
	self.textMiddle:setVisible(false)
	if self.redPoint then
		self.redPoint:setVisible(false)
	end
	if self.opType.OpName == BOP_NAME.BOP_DISCUSS then
		self:showLowGuideEffect()
	elseif self.opType.OpName == BOP_NAME.BOP_SUPPORT then
		if userSDKManager.sdkMessageCount and 0 < userSDKManager.sdkMessageCount.serviceCount then
			self:showPremiumVipEffect()
		end
	elseif self.opType.OpName == BOP_NAME.BOP_NAVINOTICE then
		if userSDKManager.unreadCount and 0 < userSDKManager.unreadCount then
			self:showPremiumVipEffect()
		end
	elseif self.opType.OpName == BOP_NAME.BOP_FOREIGN_PAVILION then
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXOTIC_PAVILION_ACTIVITY) and not SoraDGetCtrl("exoticPavilionCtrl"):getIsGetDailyReward() and SoraDGetCastleLv() >= CASTLE_LV4_LIMITED then
			self:showPavilionEffect()
		end
	elseif self.opType.OpName == BOP_NAME.BOP_HEROWEAPON then
		local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
		local ret, map = heroWeaponCtrl:isHaveMergeEnable()
		if ret then
			self:showPavilionEffect()
		else
			self:hidePavilionEffect()
		end
	elseif self.opType.OpName == BOP_NAME.BOP_CITY_DECORATE then
		local dressCtrl = SoraDGetCtrl("dressCtrl")
		if dressCtrl:isShowMenuRed() then
			self:showDecorateEffect()
		end
	elseif self.opType.OpName == BOP_NAME.BOP_SPEED_UP_BY_GOLD then
		self.textMiddle:setVisible(true)
		self.textMiddle:setPosition(cc.p(49, self.textMiddle:getPositionY() + 5))
		self:beginTime()
	elseif self.opType.OpName == BOP_NAME.BOP_SPEED_UP_BY_TOOL or self.opType.OpName == BOP_NAME.BOP_STARSPEEDUP then
		self.icon:setFlippedX(not SoraDFIsRA())
		local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
		local tableItemData = backpackCtrl:getSpeedUpItemList(gAbbrSpeedUpType.BUILD_UPGRADE)
		if 0 < #tableItemData then
			self:showLowGuideEffect()
		end
	elseif self.opType.OpName == BOP_NAME.BOP_PYRAMID then
		self:beginTime()
	elseif self.opType.OpName == BOP_NAME.BOP_COLLECT then
		self:beginTime()
	elseif self.opType.OpName == BOP_NAME.BOP_BOOST then
		if true == self.buildEntity:getHasBuff() then
			self:beginTime()
		else
			self:updateBoostGold()
		end
	elseif self.opType.OpName == BOP_NAME.BOP_BOOST_BY_TOOL then
		self:updateBoostTool()
	elseif self.opType.OpName == BOP_NAME.BOP_WAR_GEM then
		self:updateTime()
	elseif self.opType.OpName == BOP_NAME.BOP_ARTIFACT then
		self:updateTime()
	elseif self.opType.OpName == BOP_NAME.BOP_RESUSCITATE then
		self:beginTime()
	elseif self.opType.OpName == BOP_NAME.BOP_PREMIUM_VIP_MALL then
		_ENV = self.showLowGuideEffect
		self.showLowGuideEffect.byUID = true
		local clickPremiumVipMall = SoraDConfigGet("Game:MainCityView:clickPremiumVipMallBtn~integer", self.showLowGuideEffect)
		if clickPremiumVipMall == 0 or not serviceFunctions.isSameDay(clickPremiumVipMall) then
			self:showPremiumVipEffect()
		end
	elseif self.opType.OpName == BOP_NAME.BOP_PET_EXCHANGE then
		_ENV = self
		self.byUID = true
		local clickPetExchange = SoraDConfigGet("Game:MainCityView:clickPetExchangeBtn~integer", self)
		if clickPetExchange == 0 or not serviceFunctions.isSameDay(clickPetExchange) then
			local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
			local ret = backpackCtrl:getPetPointItemList()
			if ret and 0 < #ret then
				self:showLowGuideEffect()
			else
				self:hideLowGuideEffect(false)
			end
		else
			self:hideLowGuideEffect(false)
		end
	elseif self.opType.OpName == BOP_NAME.BOP_CITY_GIFT or self.opType.OpName == BOP_NAME.BOP_CITY_LEVEL_GIFT then
		self:updateCastleGift()
	elseif self.opType.OpName == BOP_NAME.BOP_FRIEND then
		local contactCtrl = gametop.playertop_:getModule("contactCtrl")
		local inviteMap = contactCtrl:getRecvInviteMap()
		self:showRedPoint(next(inviteMap))
	elseif self.opType.OpName == BOP_NAME.BOP_SHELTER then
		self:showRedPoint(SoraDGetCtrl("warShelterCtrl"):hasNewInviteRecvRed())
	elseif self.opType.OpName == BOP_NAME.BOP_UPGRADE or self.opType.OpName == BOP_NAME.BOP_WAR then
		if self.buildEntity and self.buildEntity.isCanUpgrade then
			self:showLowGuideEffect()
		end
	elseif self.opType.OpName == BOP_NAME.BOP_STARUPGRADE then
		if self.buildEntity and self.buildEntity.isCanUpgradeStar then
			self:showLowGuideEffect()
		end
	elseif self.opType.OpName == BOP_NAME.BOP_MAGICLAMP_SKILL then
		local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
		if magicLampSkillCtrl:checkMergeItemEnough() then
			self:addPyramidEntranceEfftct()
		end
	end
	self.button:addTouchEventListener(handler(self, self.btnClickCallBack))
	if self.text:getContentSize().width > 180 then
		self.text:setScale(0.8)
	else
		self.text:setScale(1.0)
	end
	if self.text:getContentSize().width > 120 then
		SoraDGetAutoHeightLabel(self.text, 120)
	end
	self.imgBg:setContentSize(cc.size(148, self.text:getContentSize().height + 6))
end
function buildTipButton:updateGodEquipType()
	local gametop = gModuleMgr.getObject("gametop")
	local godArmsCtrl = gametop.playertop_:getModule("godArmsCtrl")
	if godArmsCtrl:isCanUnlock() or godArmsCtrl:isCanFreeRefine() then
		self:addPyramidEntranceEfftct()
	else
		self:removePyramidEntranceEfftct()
	end
end
function buildTipButton:updateResuscitate()
	if self.opType.OpName ~= BOP_NAME.BOP_RESUSCITATE then
		return
	end
	local resuscitateState = resurrectionCtrl:getResurrectionState()
	if resuscitateState == gResurrectionActivityState.OPEN then
		if self.showLifeTreeEffect then
			self:showLifeTreeEffect()
		end
	elseif self.hideLiftTreeEffect then
		self:hideLiftTreeEffect(false)
	end
end
function buildTipButton:updateBoostGold()
	local needGold = self.buildEntity:getBoostGold()
	self.textTop:setString(tostring(needGold))
	self.iconSmall:setVisible(true)
	self.textTop:setVisible(true)
	self.textTopBg:setVisible(true)
	self.textTop:setAnchorPoint(cc.p(0, 0.5))
	self.textTop:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self.textTop:setPositionX(self.iconSmall:getPositionX() + 20)
	self.textTop:setPositionY(110)
	local buffTime = 86400
	local strTime = SoraDConverSecondToDate(buffTime)
	self.textBottom:setString(strTime)
	self.textBottom:setVisible(true)
	self.textBottomBg:setVisible(true)
end
function buildTipButton:getOpType()
	return self.opType
end
function buildTipButton:getOpName()
	return self.opType and self.opType.OpName or ""
end
function buildTipButton:updateBoostTool()
	local itemNum = self.buildEntity:getBoostToolNum()
	_ENV = nil
	;(nil).num = itemNum
	self.textTop:setString(i18n("common_text_531", nil))
	self.textTop:setAnchorPoint(cc.p(0.5, 0.5))
	self.textTop:setPositionX(49)
	self.textTop:setPositionY(110)
	self.iconSmall:setVisible(false)
	self.textTop:setVisible(true)
	self.textTopBg:setVisible(true)
	local buffTime = 86400
	local strTime = SoraDConverSecondToDate(buffTime)
	self.textBottom:setString(strTime)
	self.textBottom:setVisible(true)
	self.textBottomBg:setVisible(true)
end
function buildTipButton:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		local hasSpecialSound = false
		if not self.opType then
			return
		end
		if self.opType and self.opType.OpName then
			if gSoundDataList.buildopsound[self.opType.OpName] then
				SoraDPlaySound("buildopsound", self.opType.OpName)
				hasSpecialSound = true
			elseif self.opType.OpName == BOP_NAME.BOP_COLLECT then
				local bid = self.buildEntity:getBuildBid()
				local key = BOP_NAME.BOP_COLLECT .. bid
				if gSoundDataList.buildopsound[key] then
					SoraDPlaySound("buildopsound", key)
					hasSpecialSound = true
				end
			end
		end
		local isIgnoreSound = false
		local _ENV, ignoreOPList = BOP_NAME.BOP_COLLECT .. bid, BOP_NAME.BOP_COLLECT .. bid
		if ignoreOPList[self.opType.OpName] then
			isIgnoreSound = true
		end
		if not hasSpecialSound and not isIgnoreSound then
			SoraDPlaySound(nil, nil, 0.6)
		end
		if self.isActive == false then
			print("非活动状态------")
			_ENV = "非活动状态------"
			;("非活动状态------").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
			SoraDSendMessage("非活动状态------")
			return
		end
		if not self.opType then
			return
		end
		if self.opType.OpName == BOP_NAME.BOP_SPEED_UP_BY_GOLD then
			if self.buildEntity and self.buildEntity:getHasSpeedUpCooling() then
				_ENV = 0.6
				;(0.6).time = SoraDConvertSecondToString(self.buildEntity:getSpeedUpCoolingTime())
				SoraDShowMsgTip(i18n("common_text_3251", 0.6))
			else
				self:doSpeedUpByGold()
			end
		elseif self.opType.OpName == BOP_NAME.BOP_SPEED_UP_BY_TOOL then
			self:doSpeedUpByTool()
		elseif self.opType.OpName == BOP_NAME.BOP_BOOST then
			self:doBoost()
		elseif self.opType.OpName == BOP_NAME.BOP_BOOST_BY_TOOL then
			self:doBoostByTool()
		end
		if self.handler then
			self.handler(button, type)
		else
			print("self.handler == nil")
		end
	end
end
function buildTipButton:doBoost()
	local bid = self.buildEntity:getBuildBid()
	local blv = self.buildEntity:getBuildLv()
	local strMsg = ""
	local _ENV, msgParams
	if bid == BUILDID.FARM then
		_ENV, strMsg = BUILDID.FARM, "common_text_535"
		BUILDID.FARM.num = 1
		msgParams, BUILDID.FARM.name = BUILDID.FARM, i18n("bulidDyf_title_1002")
	elseif bid == BUILDID.SAWMILL then
		_ENV, strMsg = BUILDID.SAWMILL, "common_text_535"
		BUILDID.SAWMILL.num = 1
		msgParams, BUILDID.SAWMILL.name = BUILDID.SAWMILL, i18n("bulidDyf_title_1003")
	elseif bid == BUILDID.IRON_MINE then
		_ENV, strMsg = BUILDID.IRON_MINE, "common_text_535"
		BUILDID.IRON_MINE.num = 1
		msgParams, BUILDID.IRON_MINE.name = BUILDID.IRON_MINE, i18n("bulidDyf_title_1004")
	elseif bid == BUILDID.STEEL then
		_ENV, strMsg = BUILDID.STEEL, "common_text_535"
		BUILDID.STEEL.num = 1
		msgParams, BUILDID.STEEL.name = BUILDID.STEEL, i18n("bulidDyf_title_1005")
	elseif bid == BUILDID.CRYSTAL_MINE then
		_ENV, strMsg = BUILDID.CRYSTAL_MINE, "common_text_535"
		BUILDID.CRYSTAL_MINE.num = 1
		msgParams, BUILDID.CRYSTAL_MINE.name = BUILDID.CRYSTAL_MINE, i18n("common_text_3969")
	end
	local needGold = self.buildEntity:getBoostGold()
	print("needGold:", needGold)
	_ENV = "needGold:"
	_ENV, ("needGold:").msgKey = needGold, strMsg
	needGold.num = 1
	;("needGold:").msgParams, needGold.name = needGold, i18n("bulidDyf_title_1002")
	;("needGold:").gold = needGold
	;("needGold:").title = i18n("common_text_054")
	;("needGold:").handle = handler(self.buildEntity, self.buildEntity.doBoostCallBack)
	;("needGold:").canBuy = true
	SoraDShowBuyBoxNew("needGold:")
end
function buildTipButton:doBoostByTool()
	self.buildEntity:doRequestBoostByTool()
	self.buildEntity:showAnimBoost()
end
function buildTipButton:speedUpBoxCallBack(type)
	if type == MSGBOX_CALLBACK_SPEEDUP then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(nil)
	end
end
function buildTipButton:doSpeedUpByGold()
	local queue = self:getQueue()
	if queue == nil then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(nil)
		return
	end
	local isGameGuide = SoraDIsGameGuide()
	if isGameGuide then
		queueCtrl:speedUpQueueReq(queue.qtype, SPEEDUP_TYPE.GOLD)
		_ENV = queueCtrl
		queueCtrl.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(queueCtrl)
		return
	end
	SoraDShowSpeedUpBox(queue, nil)
	_ENV = queue
	queue.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
	SoraDSendMessage(queue)
end
function buildTipButton:doSpeedUpByTool()
	local queue = self:getQueue()
	if queue == nil then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(nil)
		return
	end
	if tonumber(queue.qtype) == gQueueTypeDef.radiance_war_hostpital_queue then
		local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
		local speedUpItemList = backpackCtrl:getSpeedUpItemList(gAbbrSpeedUpType.CURE_WAR)
		if #speedUpItemList <= 0 then
			SoraDShowSpeedUpByItemBox(gQueueTypeDef.radiance_war_hostpital_queue)
			SoraDShowMsgTip(i18n("brightWar_text_48"))
			return
		end
	end
	SoraDShowSpeedUpByItemBox(queue.qtype)
end
function buildTipButton:beginTime()
	if self.timeHandler then
		self:endTime()
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function buildTipButton:updateTime()
	if self.opType.OpName == BOP_NAME.BOP_SPEED_UP_BY_GOLD then
		local queue = self:getQueue()
		if queue == nil then
			local buildIndex
			if self.buildEntity and self.buildEntity.buildIndex then
				buildIndex = self.buildEntity:getBuildIndex()
			end
			_ENV = self.buildEntity
			self.buildEntity.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
			self.buildEntity.buildIndex = buildIndex
			SoraDSendMessage(self.buildEntity)
			return
		end
		if self.buildEntity and self.buildEntity:getHasSpeedUpCooling() then
			local timeSpeedUpCooling = self.buildEntity:getSpeedUpCoolingTime()
			self.textMiddle:setString(SoraDConverSecondToDate(timeSpeedUpCooling))
			self.textMiddle:setColor(cc.c3b(230, 230, 230))
			self.icon:getVirtualRenderer():setState(1)
			self.icon.isGray = 1
			return
		else
			self.textMiddle:setColor(cc.c3b(215, 175, 20))
			self.icon:getVirtualRenderer():setState(0)
			self.icon.isGray = 0
		end
		local leftTime = queue.timerNode.timer:getRemainTime()
		local armyLogic = include("armyLogic")
		local isArmy = armyLogic.isArmyQueueType(queue.qtype)
		local timeToGold = serviceFunctions.timeConvertToGold(leftTime, isArmy)
		self.textMiddle:setString(tostring(timeToGold))
		if leftTime <= 0 then
			self:endTime()
			local buildIndex
			if self.buildEntity then
				buildIndex = self.buildEntity:getBuildIndex()
			end
			_ENV = self.buildEntity
			self.buildEntity.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
			self.buildEntity.buildIndex = buildIndex
			SoraDSendMessage(self.buildEntity)
		end
	elseif self.opType.OpName == BOP_NAME.BOP_COLLECT then
		local buildEntity = self.buildEntity
		local currentRes = buildEntity:getCurrentHarvest()
		if currentRes == 0 then
			self.icon:getVirtualRenderer():setState(1)
			self.icon.isGray = 1
			if self.isActive == true then
				self.isActive = false
			end
		else
			self.icon:getVirtualRenderer():setState(0)
			self.icon.isGray = 0
			if self.isActive == false then
				self.isActive = true
			end
		end
	elseif self.opType.OpName == BOP_NAME.BOP_BOOST then
		local remainTime = self.buildEntity:getBuffRemainTime()
		if remainTime == 0 then
			self.text:setString(self.opType.Desc)
			self.imgBg:setContentSize(cc.size(148, self.text:getContentSize().height + 6))
			self.icon:getVirtualRenderer():setState(0)
			self.icon.isGray = 0
			if self.isActive == false then
				self.isActive = true
			end
			self:updateBoostGold()
		else
			local time = SoraDConverSecondToDate(remainTime)
			_ENV = cc.size(148, self.text:getContentSize().height + 6)
			cc.size(148, self.text:getContentSize().height + 6).time = time
			local strMsg = i18n("common_text_536", cc.size(148, self.text:getContentSize().height + 6))
			self.text:setString(strMsg)
			self.imgBg:setContentSize(cc.size(148, self.text:getContentSize().height + 6))
			self.icon:getVirtualRenderer():setState(1)
			self.icon.isGray = 1
			if self.isActive == true then
				self.isActive = false
			end
			self.iconSmall:setVisible(false)
			self.textTop:setVisible(false)
			self.textTopBg:setVisible(false)
			self.textBottom:setVisible(false)
			self.textBottomBg:setVisible(false)
		end
	elseif self.opType.OpName == BOP_NAME.BOP_PYRAMID then
		self:updatePyramidActivity()
	elseif self.opType.OpName == BOP_NAME.BOP_WAR_GEM then
		self:updateWarGem()
	elseif self.opType.OpName == BOP_NAME.BOP_RESUSCITATE then
		self:updateResuscitate()
	elseif self.opType.OpName == BOP_NAME.BOP_ARTIFACT then
		self:updateGodEquipType()
	end
end
function buildTipButton:endTime()
	self.textTop:setVisible(false)
	self.textTopBg:setVisible(false)
	SoraDManagerRemoveTimer(self, self.timeHandler)
	self.timeHandler = nil
end
function buildTipButton:getQueue()
	local buildEntity = self.buildEntity
	if nil ~= buildEntity then
	end
	return buildEntity:getQueue()
end
function buildTipButton:updateWarGem()
	if self.opType.OpName ~= BOP_NAME.BOP_WAR_GEM then
		return
	end
	local warGemCtrl = gametop.playertop_:getModule("warGemCtrl")
	local ret = warGemCtrl:isHasEmptyPanel()
	if ret then
		self:addPyramidEntranceEfftct()
	else
		self:removePyramidEntranceEfftct()
	end
end
function buildTipButton:updatePyramidActivity()
	if self.opType.OpName ~= BOP_NAME.BOP_PYRAMID then
		return
	end
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local ret = activityShowCtrl:isActivityOpen(gActivityTimeActivityID.PYRAMIDACTIVITY)
	if ret then
		self:addPyramidEntranceEfftct()
	else
		self:removePyramidEntranceEfftct()
	end
end
function buildTipButton:updateCastleGift()
	self:showLowGuideEffect()
end
function buildTipButton:addPyramidEntranceEfftct(...)
	self.isShowPyramidEffect = true
	if self:getChildByName("et_pyramid_entrance") then
		return
	end
	local sprite = display.newSprite("#dh_pyramid_active_01.png")
	sprite:setPosition(0, 0)
	sprite:setName("et_pyramid_entrance")
	sprite:addTo(self, 2)
	_ENV, _ENV = sprite, sprite.addTo
	_ENV, sprite.addTo[1], sprite.plist = sprite, sprite, "et_pyramid_active_01.plist"
	sprite.addTo[2], sprite.plist = sprite, "et_pyramid_active_01.plist"
	local param = sprite.addTo
	local et_node1 = SoraDCreateEffectNode(param)
	et_node1:setPosition(cc.p(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2))
	et_node1:setScale(1.2)
	et_node1:addTo(sprite)
	local et_node2 = SoraDCreateEffectNode(param)
	et_node2:setPosition(cc.p(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2))
	et_node2:setScale(1.2)
	et_node2:setRotation(180)
	et_node2:addTo(sprite)
	sprite:runAction(cc.RepeatForever:create(cca.rotateBy(3, 360)))
end
function buildTipButton:removePyramidEntranceEfftct(...)
	if self:getChildByName("et_pyramid_entrance") then
		self:removeChildByName("et_pyramid_entrance", true)
	end
	self.isShowPyramidEffect = false
end
function buildTipButton:showLifeTreeEffect()
	self.isShowLifeTreeEffect = true
	local et_node = self:getChildByName("et_lifeTree")
	if et_node then
		et_node:setVisible(true)
		return
	end
	_ENV, _ENV = et_node, et_node.setVisible
	et_node.plist = "et_anniulvdian_01.plist"
	et_node.setVisible[1], et_node.scale = et_node, 1.47
	local param = et_node.setVisible
	local et_node = SoraDCreateEffectNode(param)
	et_node:setName("et_lifeTree")
	et_node:addTo(self, 3)
end
function buildTipButton:hideLiftTreeEffect(isRemove)
	self.isShowLifeTreeEffect = false
	local et_node = self:getChildByName("et_lifeTree")
	if et_node then
		et_node:setVisible(false)
		if isRemove then
			et_node:removeFromParent()
		end
	end
end
function buildTipButton:showPavilionEffect()
	self.isShowPavilionEffect = true
	if self:getChildByName("et_effect_vip") then
		self:getChildByName("et_effect_vip"):setVisible(true)
		return
	end
	local sprite = display.newSprite("#dh_pyramid_active_01.png")
	sprite:setName("et_effect_vip")
	sprite:setPosition(0, 0)
	sprite:addTo(self, 2)
	_ENV, _ENV = sprite, sprite.addTo
	_ENV, sprite.addTo[1], sprite.plist = sprite, sprite, "et_pyramid_active_01.plist"
	sprite.addTo[2], sprite.plist = sprite, "et_pyramid_active_01.plist"
	local param = sprite.addTo
	local et_node1 = SoraDCreateEffectNode(param)
	et_node1:setPosition(cc.p(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2))
	et_node1:setScale(1.2)
	et_node1:addTo(sprite)
	local et_node2 = SoraDCreateEffectNode(param)
	et_node2:setPosition(cc.p(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2))
	et_node2:setScale(1.2)
	et_node2:setRotation(180)
	et_node2:addTo(sprite)
	sprite:runAction(cc.RepeatForever:create(cca.rotateBy(3, 360)))
end
function buildTipButton:showDecorateEffect()
	self.isShowDecorateEffect = true
	if self:getChildByName("et_effect_vip") then
		self:getChildByName("et_effect_vip"):setVisible(true)
		return
	end
	local sprite = display.newSprite("#dh_pyramid_active_01.png")
	sprite:setName("et_effect_vip")
	sprite:setPosition(0, 0)
	sprite:addTo(self, 2)
	_ENV, _ENV = sprite, sprite.addTo
	_ENV, sprite.addTo[1], sprite.plist = sprite, sprite, "et_pyramid_active_01.plist"
	sprite.addTo[2], sprite.plist = sprite, "et_pyramid_active_01.plist"
	local param = sprite.addTo
	local et_node1 = SoraDCreateEffectNode(param)
	et_node1:setPosition(cc.p(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2))
	et_node1:setScale(1.2)
	et_node1:addTo(sprite)
	local et_node2 = SoraDCreateEffectNode(param)
	et_node2:setPosition(cc.p(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2))
	et_node2:setScale(1.2)
	et_node2:setRotation(180)
	et_node2:addTo(sprite)
	sprite:runAction(cc.RepeatForever:create(cca.rotateBy(3, 360)))
end
function buildTipButton:showPremiumVipEffect()
	self.isShowPremiumVipEffect = true
	if self:getChildByName("et_effect_vip") then
		self:getChildByName("et_effect_vip"):setVisible(true)
		return
	end
	local sprite = display.newSprite("#dh_pyramid_active_01.png")
	sprite:setName("et_effect_vip")
	sprite:setPosition(0, 0)
	sprite:addTo(self, 2)
	_ENV, _ENV = sprite, sprite.addTo
	_ENV, sprite.addTo[1], sprite.plist = sprite, sprite, "et_pyramid_active_01.plist"
	sprite.addTo[2], sprite.plist = sprite, "et_pyramid_active_01.plist"
	local param = sprite.addTo
	local et_node1 = SoraDCreateEffectNode(param)
	et_node1:setPosition(cc.p(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2))
	et_node1:setScale(1.2)
	et_node1:addTo(sprite)
	local et_node2 = SoraDCreateEffectNode(param)
	et_node2:setPosition(cc.p(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2))
	et_node2:setScale(1.2)
	et_node2:setRotation(180)
	et_node2:addTo(sprite)
	sprite:runAction(cc.RepeatForever:create(cca.rotateBy(3, 360)))
end
function buildTipButton:hidePremiumVipEffect(isRemove)
	self.isShowPremiumVipEffect = false
	local et_node = self:getChildByName("et_effect_vip")
	if et_node then
		et_node:setVisible(false)
		if isRemove then
			et_node:removeFromParent()
		end
	end
end
function buildTipButton:hidePavilionEffect(isRemove)
	self.isShowPavilionEffect = false
	local et_node = self:getChildByName("et_effect_vip")
	if et_node then
		et_node:setVisible(false)
		if isRemove then
			et_node:removeFromParent()
		end
	end
end
function buildTipButton:hideDecorateEffect(isRemove)
	self.isShowDecorateEffect = false
	local et_node = self:getChildByName("et_effect_vip")
	if et_node then
		et_node:setVisible(false)
		if isRemove then
			et_node:removeFromParent()
		end
	end
end
function buildTipButton:showRedPoint(ret)
	if ret then
		if not self.redPoint then
			self.redPoint = display.newSprite("#common_mail_hongdian.png")
			self.redPoint:setPosition(25, 25)
			self.redPoint:addTo(self, 5)
		else
			self.redPoint:setVisible(true)
		end
	elseif self.redPoint then
		self.redPoint:setVisible(false)
	end
end
function buildTipButton:showLowGuideEffect()
	self.isShowLowGuide = true
	if self:getChildByName("et_effect_lowguide") ~= nil then
		self:getChildByName("et_effect_lowguide"):setVisible(true)
		return
	end
	local effectNode = self
	local et_guide_effect = display.newNode()
	et_guide_effect:addTo(effectNode, 2)
	local sprite = display.newSprite("#dh_pyramid_active_01.png")
	sprite:setPosition(0, 0)
	sprite:addTo(et_guide_effect, 2)
	sprite:runAction(cc.RepeatForever:create(cca.rotateBy(3, 360)))
	_ENV, _ENV = sprite, sprite.runAction
	sprite.runAction[1], sprite.plist = sprite, "et_xwjyd_01.plist"
	local param1 = sprite.runAction
	local et_node1 = SoraDCreateEffectNode(param1)
	et_node1:addTo(et_guide_effect, 1)
	_ENV, _ENV = et_node1, et_node1.addTo
	et_node1.addTo[1], et_node1.plist = et_node1, "et_xwjyd_02.plist"
	local param2 = et_node1.addTo
	local et_node1 = SoraDCreateEffectNode(param2)
	et_node1:addTo(et_guide_effect, 3)
	et_guide_effect:setName("et_effect_lowguide")
	return et_guide_effect
end
function buildTipButton:hideLowGuideEffect(isRemove)
	self.isShowLowGuide = false
	local et_node = self:getChildByName("et_effect_lowguide")
	if et_node then
		et_node:setVisible(false)
		if isRemove then
			et_node:removeFromParent()
		end
	end
end
return buildTipButton
