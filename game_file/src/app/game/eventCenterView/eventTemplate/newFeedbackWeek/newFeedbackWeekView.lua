local gametop = gModuleMgr.getObject("gametop")
local newFeedbackWeekRead = include("newFeedbackWeekRead")
local newFeedbackWeekCtrl = SoraDGetCtrl("newFeedbackWeekCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
_ENV = "activityShowCtrl"
;("activityShowCtrl").noClaim = 1
;("activityShowCtrl").noReach = 2
local ("activityShowCtrl").claimed, giftStatus = 3, "activityShowCtrl"
local newFeedbackWeekView = class("newFeedbackWeekView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("newFeedbackWeekView")
end)
function newFeedbackWeekView:ctor(properties)
	self.pointTbl, _ENV = nil, nil
	self.activityID = gActivityTimeActivityID.RECHARGE_NEW_USER
	newFeedbackWeekCtrl:resetRed()
	SoraDShowLoading(self)
	newFeedbackWeekCtrl:reqInitData()
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.scroll:setContentSize(cc.size(600, 430))
	self.Node_tip = SoraDGetChildByName(self, "Node_tip")
	self.Btn_reward = SoraDGetChildByName(self, "Btn_reward")
	self.Text_All = SoraDGetChildByName(self, "Text_All")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	_UPVALUE2_, self.Text_icon = SoraDGetChildByName(self, "Text_icon"), SoraDGetChildByName(self, "Text_icon")
	self.rewardEffects, SoraDGetChildByName(self, "Text_icon")[1] = SoraDGetChildByName(self, "Text_icon"), SoraDGetChildByName(self, "Sprite_5")
	self.rewardEffects, SoraDGetChildByName(self, "Text_icon")[2] = SoraDGetChildByName(self, "Text_icon"), SoraDGetChildByName(self, "Sprite_6")
	self.rewardEffects, SoraDGetChildByName(self, "Text_icon")[3] = SoraDGetChildByName(self, "Text_icon"), SoraDGetChildByName(self, "Particle_3")
	self.rewardEffects, SoraDGetChildByName(self, "Text_icon")[4] = SoraDGetChildByName(self, "Text_icon"), SoraDGetChildByName(self, "Particle_3")
	self.rewardEffects, SoraDGetChildByName(self, "Text_icon")[5] = SoraDGetChildByName(self, "Text_icon"), SoraDGetChildByName(self, "Particle_3")
	self.rewardEffects, SoraDGetChildByName(self, "Text_icon")[6] = SoraDGetChildByName(self, "Text_icon"), SoraDGetChildByName(self, "Particle_3")
	self.rewardEffects, SoraDGetChildByName(self, "Text_icon")[7] = SoraDGetChildByName(self, "Text_icon"), SoraDGetChildByName(self, "Particle_3")
	self.rewardEffects, SoraDGetChildByName(self, "Text_icon")[8] = SoraDGetChildByName(self, "Text_icon"), SoraDGetChildByName(self, "Particle_3")
	self.rewardEffects, SoraDGetChildByName(self, "Text_icon")[9] = SoraDGetChildByName(self, "Text_icon"), SoraDGetChildByName(self, "Particle_3")
	self.rewardEffects, SoraDGetChildByName(self, "Text_icon")[10] = SoraDGetChildByName(self, "Text_icon"), SoraDGetChildByName(self, "Particle_3")
	self.rewardEffects, SoraDGetChildByName(self, "Text_icon")[11] = SoraDGetChildByName(self, "Text_icon"), SoraDGetChildByName(self, "Particle_3")
	self.effectBg = SoraDGetChildByName(self, "dh_xwjyd_01_16")
	self.effectSL = SoraDGetChildByName(self, "Sprite_6")
	local lang = SoraDGetDefaultLanguage()
	_UPVALUE2_ = SoraDGetChildByName(self, "Particle_3")
	SoraDGetChildByName(self, "Particle_3")[1] = "ar"
	SoraDGetChildByName(self, "Particle_3")[2] = "en"
	local bgName = SoraDGetImageNameByLang("frame_xwzhk_title_%s.png", SoraDGetChildByName(self, "Particle_3"))
	local spTitle = SoraDGetChildByName(self, "img_title")
	spTitle:setSpriteFrame(bgName)
	local leftImg = SoraDGetChildByName(self, "Image_15")
	local rightImg = SoraDGetChildByName(self, "Image_15_0")
	if lang ~= "ar" then
		spTitle:setContentSize(cc.size(202, 27))
		leftImg:setPosition(-68, 18)
		rightImg:setPosition(270, 18)
		leftImg:setContentSize(cc.size(100, 10))
		rightImg:setContentSize(cc.size(100, 10))
	else
		spTitle:setContentSize(cc.size(346, 41))
		leftImg:setPosition(-46, 18)
		rightImg:setPosition(399, 18)
		leftImg:setContentSize(cc.size(70, 7))
		rightImg:setContentSize(cc.size(70, 7))
	end
	self.Text_icon:setString(i18n("common_text_2669"))
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setPositionY(-214)
	self.scroll:setSingleCCS("feedbackWeekTaskItem")
	_ENV = i18n("common_text_2669")
	i18n("common_text_2669").scroll = self.scroll
	i18n("common_text_2669").view = self
	self.scroll:updateScrollView(cc.size(522, 140), self.taskList, 1, i18n("common_text_2669"))
	self.Btn_reward:addTouchEventListener(handler(self, self.btnClick))
	SoraDCreatAnimation(self.__cname, self, true)
end
function newFeedbackWeekView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_NEW_KING_RECHARGE_INIT", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_NEW_KING_RECHARGE_ERR", handler(self, self.getError))
	SoraDAddMessage(self, "MESSAGE_NEW_KING_RECHARGE_CHANGE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_NEW_KING_RECHARGE_CLAIM_REWARD", handler(self, self.getClaimReward))
end
function newFeedbackWeekView:getError()
	print("getError")
end
function newFeedbackWeekView:getClaimReward(target, data)
	local reward = data.data
	local _ENV, itemData
	for i, v in ipairs(reward) do
		_ENV = nil
		;(nil).id = v.id
		;(nil).count = v.count
		table.insert(itemData, nil)
	end
	SoraDMailGainItems(itemData, true)
end
function newFeedbackWeekView:initData()
	SoraDCloseLoading(self)
	self:initTime()
	self:ininScroll()
	self:updateBoxStatus()
end
function newFeedbackWeekView:initTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	local str
	str = SoraDConvertSecondToString(newFeedbackWeekCtrl:getNextResetTime() - serviceFunctions.systemTime())
	self.Text_time:setString(str)
	self:beginTime()
end
function newFeedbackWeekView:ininScroll()
	local data = newFeedbackWeekCtrl:getTaskData()
	newFeedbackWeekCtrl = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(522, 140), data, 1, nil)
end
function newFeedbackWeekView:btnClick(target, eventType)
	giftStatus = nil
	;(nil)[giftStatus.noReach] = function()
		SoraDCreatePanel("feedbackRewardPopView"):show()
	end
	;(nil)[giftStatus.noClaim] = function()
		SoraDCreatePanel("feedbackRewardPopView"):show()
	end
	local (nil)[giftStatus.claimed], switch = function()
		SoraDCreatePanel("feedbackRewardPopView"):show()
	end, nil
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		switch[newFeedbackWeekCtrl:getBigRewardStatus()]()
		newFeedbackWeekCtrl:boxClicked()
		self:updateBoxStatus()
	end
end
function newFeedbackWeekView:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function newFeedbackWeekView:updateTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	local str
	if not eventTime then
		self:endTime()
		if self.Text_time then
			self.Text_time:setString("00:00:00")
		end
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
	str = SoraDConvertSecondToString(newFeedbackWeekCtrl:getNextResetTime() - serviceFunctions.systemTime())
	if self.Text_time then
		self.Text_time:setString(str)
	end
end
function newFeedbackWeekView:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
function newFeedbackWeekView:updateBoxStatus()
	local isBoxClicked = newFeedbackWeekCtrl:getIsBoxClicked()
	local bigRewardStatus = newFeedbackWeekCtrl:getBigRewardStatus()
	self.Btn_reward:stopAllActions()
	self.Btn_reward:setRotation(0)
	self.effectBg:setVisible(bigRewardStatus == giftStatus.noClaim)
	self.effectSL:setVisible(bigRewardStatus ~= giftStatus.noReach)
	if not isBoxClicked and bigRewardStatus ~= giftStatus.claimed then
		self:boxShake()
	elseif bigRewardStatus == giftStatus.claimed then
		for i, v in ipairs(self.rewardEffects) do
			v:setVisible(false)
		end
		self.Btn_reward:loadTextures("frame_xwzhk_openBox.png", "frame_xwzhk_openBox.png", "frame_xwzhk_openBox.png", ccui.TextureResType.plistType)
		self.Btn_reward:setContentSize(cc.size(120, 168))
		self.Btn_reward:setPositionY(233)
	else
		self.Btn_reward:loadTextures("8532.png", "8532.png", "8532.png", ccui.TextureResType.plistType)
		self.Btn_reward:setContentSize(cc.size(120, 120))
		self.Btn_reward:setPositionY(211)
		for i, v in ipairs(self.rewardEffects) do
			v:setVisible(true)
		end
	end
end
function newFeedbackWeekView:boxShake()
	local rotateByRight = cca.rotateBy(0.1, 15)
	local rotateByToLeft = cca.rotateBy(0.2, -30)
	local rotateBack = cca.rotateBy(0.1, 15)
	local rotateByRight2 = cca.rotateBy(0.08, 8)
	local rotateByToLeft2 = cca.rotateBy(0.16, -16)
	local rotateBack2 = cca.rotateBy(0.08, 8)
	local rotateByRight3 = cca.rotateBy(0.05, 5)
	local rotateByToLeft3 = cca.rotateBy(0.1, -10)
	local rotateBack3 = cca.rotateBy(0.05, 5)
	local delayTime = cca.delay(2.5)
	_UPVALUE10_ = nil
	;(nil)[1] = rotateByRight
	;(nil)[2] = rotateByToLeft
	;(nil)[3] = rotateBack
	;(nil)[4] = rotateByRight2
	;(nil)[5] = rotateByToLeft2
	;(nil)[6] = rotateBack2
	;(nil)[7] = rotateByRight3
	;(nil)[8] = rotateByToLeft3
	;(nil)[9] = rotateBack3
	;(nil)[10] = delayTime
	local seqA = cca.seq(nil)
	local repeatA = cca.repeatForever(seqA)
	self.Btn_reward:runAction(repeatA)
end
return newFeedbackWeekView
