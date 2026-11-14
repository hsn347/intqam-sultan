local gametop = gModuleMgr.getObject("gametop")
local cavalryRiseCtrl = SoraDGetCtrl("cavalryRiseCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local cavalryRiseUtil = include("cavalryRiseUtil")
local cavalryRiseRead = include("cavalryRiseRead")
local cavalryRiseMainAwardView = class("cavalryRiseMainAwardView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	return target
end)
function cavalryRiseMainAwardView:ctor()
	self.txtLevel = SoraDGetChildByName(self, "Text_level")
	self.imgLevel = SoraDGetChildByName(self, "Image_level")
	if SoraDFIsRA() then
		self.imgLevelOffset = self.imgLevel:getPositionX() - (self.txtLevel:getPositionX() + self.txtLevel:getContentSize().width)
	else
		self.imgLevelOffset = self.imgLevel:getPositionX() - (self.txtLevel:getPositionX() - self.txtLevel:getContentSize().width)
	end
	self.txtProgress = SoraDGetChildByName(self, "Text_progress")
	self.txtScrollTitleLevel = SoraDGetChildByName(self, "Text_scroll_title_level")
	self.txtScrollTitleNormal = SoraDGetChildByName(self, "Text_scroll_title_normal")
	self.txtScrollTitleGod = SoraDGetChildByName(self, "Text_scroll_title_god")
	self.txtScrollTitleLevel:setString(i18n("common_text_748"))
	self.txtScrollTitleNormal:setString(i18n("cavalryrise_text_04"))
	self.Sprite_lock = SoraDGetChildByName(self, "Sprite_lock")
	self.txtScrollTitleGod:setString(i18n("cavalryrise_text_05"))
	_UPVALUE2_ = 136
	;(136)[1] = self.Sprite_lock
	;(136)[2] = self.txtScrollTitleGod
	activityShowCtrl = self.txtScrollTitleGod
	self.txtScrollTitleGod[1] = 5
	SoraDAlignNodeArrayOnCenterX(SoraDFPosX(136), 136, SoraDFIsRA(), self.txtScrollTitleGod)
	self.Node_efffec1 = SoraDGetChildByName(self, "Node_effect1")
	self.Node_efffec2 = SoraDGetChildByName(self, "Node_effect2")
	self.Node_unlockEffect = SoraDGetChildByName(self, "Node_unlockEffect")
	self.Node_unlockEffect:setPositionX(self.Node_unlockEffect:getPositionX() - 1.5)
	self.Node_goldenEffect = SoraDGetChildByName(self, "Node_goldenEffect")
	self.Node_bronzeEffect = SoraDGetChildByName(self, "Node_bronzeEffect")
	self.nodeSingle = SoraDGetChildByName(self, "Node_single")
	self.nodeSingle:setVisible(false)
	self.nodeSingleView = SoraDGetChildByName(self, "Node_single_view")
	self.nodeSingleView = include("cavalryRiseMainAwardSingle").new(self.nodeSingleView)
	self.nodeSingleView:setSpecialSinle()
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_award")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setScrollMoveFun(handler(self, self.scrollMove))
	self.addNum = math.ceil(self.scroll:getContentSize().height / 100)
	self.nodeProBarPreview = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_preview")
	self.nodeProBarPreview:setActionDelay(0.5)
	self.nodeBottom = SoraDGetChildByName(self, "Bottom_Node")
	self.btnResurgence = SoraDGetChildByName(self, "Button_resurgence")
	self.btnExp = SoraDGetChildByName(self, "Button_exp")
	self.btnAwardPreview = SoraDGetChildByName(self, "Button_award_preview")
	self.btnReward = SoraDGetChildByName(self, "Button_reward")
	self.btnActivite = SoraDGetChildByName(self, "Button_activite")
	self.Text_active = SoraDGetChildByName(self.btnActivite, "Text_active")
	self.Text_active:setString(i18n("cavalryrise_text_03"))
	local btnActiveWidth = self.btnActivite:getContentSize().width
	local textLen = self.Text_active:getContentSize().width + 30
	if btnActiveWidth < textLen then
		self.btnActivite:setContentSize(textLen, self.btnActivite:getContentSize().height)
		self.Text_active:setPositionX(textLen / 2)
	end
	self:setButtonSize()
	self.btnExp:addTouchEventListener(handler(self, self.onClick_btnExp))
	self.btnAwardPreview:addTouchEventListener(handler(self, self.onClick_btnAwardPreview))
	self.btnAwardPreview:setTitleText(i18n("cavalryrise_text_08"))
	self.btnReward:addTouchEventListener(handler(self, self.onClick_btnReward))
	self.btnActivite:addTouchEventListener(handler(self, self.onClick_btnActivite))
	self.isGoldClass = false
	self.text_activity_time = SoraDGetChildByName(self, "Text_activiey_time")
	self.activityID = gActivityTimeActivityID.CAVALRY_RISE_ACTIVITY
	self.text_activity_time = SoraDCreateTimerLabel(self, self.text_activity_time)
	self.text_activity_time:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = strTime
		return i18n("common_text_607", nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		_ENV = handler(self, self.onClick_btnActivite)
		handler(self, self.onClick_btnActivite).time = SoraDConvertSecondToString(leftTime)
		self.text_activity_time:setString(i18n("common_text_607", handler(self, self.onClick_btnActivite)))
		self.text_activity_time:beginTime(leftTime)
	end
	local animationShowNode = SoraDCreatAnimationEx(self.__cname, self, false, nil, 0, 35)
	activityShowCtrl = nil
	;(nil)[1] = cca.delay(0.6)
	;(nil)[2] = cca.callFunc(function()
		print("出场动画结束")
		self.actionShowPlayEnd = true
		animationShowNode.action:gotoFrameAndPlay(100, 200, true)
		self:showUnlockAnimation()
	end)
	;(nil)[3] = cca.callFunc(function()
		print("出场动画结束")
		self.actionShowPlayEnd = true
		animationShowNode.action:gotoFrameAndPlay(100, 200, true)
		self:showUnlockAnimation()
	end)
	self:runAction(cca.seq(nil))
	self.Button_detail = SoraDGetChildByName(self, "Button_detail")
	self.Button_detail:addTouchEventListener(handler(self, self.onClick_btnDetail))
end
function cavalryRiseMainAwardView:setButtonSize()
end
function cavalryRiseMainAwardView:onMessageListener()
	print("cavalryRiseMainAwardView:onMessageListener=======")
	SoraDAddMessage(self, "MESSAGE_CAVALRY_RISE_GOLD", handler(self, self.init))
	SoraDAddMessage(self, "MESSAGE_CAVALRY_RISE_LV", handler(self, self.init))
	SoraDAddMessage(self, "MESSAGE_CAVALRY_RISE_EXP", handler(self, self.init))
	SoraDAddMessage(self, "MESSAGE_CAVALRY_RISE_AWARD", handler(self, self.init))
end
function cavalryRiseMainAwardView:init()
	SoraDCloseLoading(self)
	self:initViewGold()
	self.index = nil
	self:initScroll()
	self:initLvInfo()
	self:showUnlockAnimation()
end
function cavalryRiseCtrl:onIntoPanel()
	print("重新回到铁骑界面")
	self:showUnlockAnimation()
end
function cavalryRiseMainAwardView:showUnlockAnimation()
	if not cavalryRiseCtrl:getWillShowUnlockAnimation() then
		return
	end
	if not self:isVisible() then
		print("铁骑崛起界面不显示，不做解锁表现！！！")
		return
	end
	if not self.actionShowPlayEnd then
		print("出场动画未结束")
		return
	end
	if self.isShowUnlocking then
		return
	end
	self.isShowUnlocking = true
	print("正在解锁中！！！！！！！！！！！")
	local unlockAnimation = SoraDCreatAnimationEx("cavalryRiseMainAwardEffect", nil, false)
	unlockAnimation:addTo(self.Node_unlockEffect)
	unlockAnimation.action:setFrameEventCallFunc(function(frameEventName)
		local frameEvent = frameEventName:getEvent()
		print("解锁动画event", frameEvent)
		if frameEvent == "ShowFlag" then
			print("显示金色特效！！！！！")
			self.Node_efffec1:setVisible(true)
			self.Node_goldenEffect:setVisible(true)
		elseif frameEvent == "EndAnimation" then
			print("解锁动画成功！！！！！")
			self.isShowUnlocking = false
			cavalryRiseCtrl:resetWillShowUnlockAnimation()
			self:initBtnStatus()
			self.Node_unlockEffect:removeAllChildren(true)
		end
	end)
end
function cavalryRiseMainAwardView:initViewGold()
	self.isGoldClass = cavalryRiseCtrl:isActiveGold()
	self:initBtnStatus()
end
function cavalryRiseMainAwardView:jumpToCurLevel()
	local lv = cavalryRiseCtrl:getCurLevel()
	local sSize = self.scroll:getContentSize()
	local scrollToIdx = math.min(#self.levelList, math.max(1, lv))
	local scrollHeight = -sSize.height + self.scroll:getInnerContainerSize().height
	local scrollPercent = 109 * (scrollToIdx - 1) / scrollHeight
	if 1 < scrollPercent then
		scrollPercent = 1
	end
	if scrollToIdx ~= 1 and 0 < scrollPercent then
		self.scroll:stopAllActions()
		_ENV = math.max(1, lv)
		math.max(1, lv)[1] = cca.delay(0.25)
		math.max(1, lv)[2] = cca.callFunc(function()
			self.scroll:scrollToPercentVertical(scrollPercent * 100, 3.5 * scrollPercent, true)
		end)
		math.max(1, lv)[3] = cca.callFunc(function()
			self.scroll:scrollToPercentVertical(scrollPercent * 100, 3.5 * scrollPercent, true)
		end)
		self.scroll:runAction(cca.seq(math.max(1, lv)))
	end
	self:scrollMove()
end
function cavalryRiseMainAwardView:initBtnStatus()
	self.isGoldClass = cavalryRiseCtrl:isActiveGold()
	local bWillShowUnlockAnimation = cavalryRiseCtrl:getWillShowUnlockAnimation()
	self.btnActivite:setVisible(not self.isGoldClass)
	if not self.isGoldClass then
		local giftData = cavalryRiseUtil:getGoldenRechargeGift()
		self.btnActivite:setBright(giftData and tonumber(giftData.extraData) > 0)
	end
	self.Sprite_lock:setVisible(not self.isGoldClass or not not bWillShowUnlockAnimation)
	self.Node_goldenEffect:setVisible(self.isGoldClass and not bWillShowUnlockAnimation)
	self.Node_bronzeEffect:setVisible(not self.isGoldClass or not not bWillShowUnlockAnimation)
	if self.isGoldClass and not bWillShowUnlockAnimation then
		self.btnResurgence:loadTextureNormal("frame_tjjx_hz_02.png", ccui.TextureResType.plistType)
	else
		self.btnResurgence:loadTextureNormal("frame_tjjx_hz_01.png", ccui.TextureResType.plistType)
	end
	self.btnResurgence:setTouchEnabled(false)
	self.btnResurgence:setBright(true)
	local enable, num = cavalryRiseCtrl:getAwardReceiveStatusAndCount()
	if 1 < num then
		self.btnReward:setTitleText(i18n("summoned_btn_01"))
	else
		self.btnReward:setTitleText(i18n("common_text_1146"))
	end
	self.btnReward:setTouchEnabled(enable)
	self.btnReward:setBright(enable)
end
function cavalryRiseMainAwardView:initLvInfo()
	local lv = cavalryRiseCtrl:getCurLevel()
	self.txtLevel:setString(lv)
	if SoraDFIsRA() then
		self.imgLevel:setPositionX(self.txtLevel:getPositionX() + self.txtLevel:getContentSize().width + self.imgLevelOffset)
	else
		self.imgLevel:setPositionX(self.txtLevel:getPositionX() - self.txtLevel:getContentSize().width + self.imgLevelOffset)
	end
	local cur = cavalryRiseCtrl:getCurLevelExp()
	local maxExp = cavalryRiseRead:getMaxExp(cavalryRiseCtrl:getClassType(), lv)
	print("修改等级或经验", lv, cur)
	self.nodeProBarPreview:stopAllActions()
	self.nodeProBarPreview:setInitState(false)
	cavalryRiseCtrl = false
	;(false).maxValue = maxExp
	;(false).curValue = cur
	self.nodeProBarPreview:setProgressDate(false)
	self.nodeProBarPreview:setInitState(true)
	self:jumpToCurLevel()
end
function cavalryRiseMainAwardView:initScroll()
	self.levelList = cavalryRiseRead:getLevelList(cavalryRiseCtrl:getClassType())
	local view = self:getParent():getParent()
	if self.playSingleAnimation == nil then
		self.playSingleAnimation = true
	end
	cavalryRiseRead = cavalryRiseCtrl:getClassType()
	cavalryRiseCtrl:getClassType().scroll = self.scroll
	cavalryRiseCtrl:getClassType().view = self
	self.scroll:updateScrollView(cc.size(640, 109), self.levelList, 1, cavalryRiseCtrl:getClassType())
	print("scroll children num:", #self.scroll:getChildren())
	self.playSingleAnimation = false
end
local STEP = 6
function cavalryRiseMainAwardView:scrollMove()
	if not self.levelList then
		return
	end
	local index = self.scroll:getTopIndex()
	local newIndex = math.ceil((index + self.addNum) / STEP) * STEP
	if newIndex >= #self.levelList then
		newIndex = #self.levelList
	end
	local scrollInner = self.scroll:getInnerContainer()
	if 0 < index and index ~= self.index then
		self.index = index
		_ENV = nil
		;(nil).view = self
		self.nodeSingleView:initData(self.levelList[newIndex], nil)
	end
end
function cavalryRiseMainAwardView:createSingle(index)
	local ocx = self.nodeSingle:clone()
	local single = include("cavalryRiseMainAwardSingle").new(ocx)
	single:setVisible(true)
	return single
end
function cavalryRiseMainAwardView:onClick_btnExp(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		cavalryRiseUtil:buyExp()
	end
end
function cavalryRiseMainAwardView:onClick_btnAwardPreview(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("cavalryRiseAwardPreviewView")
		panel:setTitle()
		panel:show()
	end
end
function cavalryRiseMainAwardView:onClick_btnReward(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		cavalryRiseCtrl:reqActivityGetAllLevelReward()
		local panel = SoraDShowLoading(self, nil, nil, true, 3)
		panel:setPositionY(-panel:getPositionY())
	end
end
function cavalryRiseMainAwardView:onClick_btnActivite(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local giftData = cavalryRiseUtil:getGoldenRechargeGift()
		if giftData and tonumber(giftData.extraData) > 0 then
			local cavalryRiseUtil = include("cavalryRiseUtil")
			cavalryRiseUtil:buyGolden()
		else
			SoraDShowMsgTip(i18n("common_text_778"))
		end
	end
end
function cavalryRiseMainAwardView:onClick_btnDetail(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgTip(i18n("cavalryrise_text_22"))
	end
end
return cavalryRiseMainAwardView
