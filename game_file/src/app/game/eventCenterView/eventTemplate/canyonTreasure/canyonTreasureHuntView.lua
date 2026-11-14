local canyonTreasureHuntView = class("canyonTreasureHuntView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("canyonTreasureHuntView")
	end
	return target
end)
local canyonTreasureHuntRead = include("canyonTreasureHuntRead")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local canyonTreasureCtrl = SoraDGetCtrl("canyonTreasureCtrl")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local canyonTreasureHuntRead = include("canyonTreasureHuntRead")
local MAX_AWARD_NUM = 12
function canyonTreasureHuntView:ctor()
	self.activityID = gActivityTimeActivityID.CANYON_TREASURE_HUNT
	self.canyouType = gCanyonTreasureHuntType.NORMAL
	self.hasChoosed = false
	self.isPlayAnimation = true
	self:initControls()
	self:initNoChoosedFrame()
	self:initLightEffect()
	self:fitDevice()
	canyonTreasureCtrl:reqInitData()
	SoraDShowLoading(self)
end
function canyonTreasureHuntView:initLightEffect()
	self.lightEffect = SoraDCreatAnimation("Node_canyonTreasure_light", nil, true)
	self.lightEffect:setPosition(cc.p(-320, display.height / 2))
	self.lightEffect:addTo(self.Top_Node)
	local particle01 = SoraDGetChildByName(self.lightEffect, "Particle_6")
	particle01:setLocalZOrder(-1)
	if particle01.setAutoCull then
		particle01:setAutoCull(false)
	end
end
function canyonTreasureHuntView:initSingleGetEffect(isplay, parent, pos)
	if isplay then
		if parent.effectGet then
			parent.effectGet:setVisible(true)
			SoraDResetEffectNode(parent.effectGet)
			parent.effectGet.action:gotoFrameAndPlay(0, 52, false)
		else
			parent.effectGet = SoraDCreatAnimationEx("Node_canyonTreasure_Single", nil, false)
			parent.effectGet:setPosition(pos)
			parent.effectGet:addTo(parent, 2)
		end
	elseif parent.effectGet then
		parent.effectGet:setVisible(false)
	end
end
function canyonTreasureHuntView:initFdjEffect(isplay)
	if isplay then
		if self.effectFdj then
			self.effectFdj:setVisible(true)
			SoraDResetEffectNode(self.effectFdj)
			self.effectFdj.action:gotoFrameAndPlay(0, 254, false)
		else
			self.effectFdj = SoraDCreatAnimationEx("Node_canyonTreasure_fdj", nil, false)
			local panelShadow = SoraDGetChildByName(self.effectFdj, "Panel_1")
			panelShadow:setContentSize(cc.size(640, display.height))
			self.effectFdj:setPosition(cc.p(320, display.height / 2))
			self.effectFdj:addTo(self, 2)
		end
	elseif self.effectFdj then
		self.effectFdj:setVisible(false)
	end
end
function canyonTreasureHuntView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_friend")
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.Text_timeHunt1 = SoraDCreateTimerLabel(self, self.Text_timeHunt1)
	self.Text_timeHunt1 = SoraDChangeTextToHtml(self.Text_timeHunt1)
	self.tableOpenReward = SoraDGetChildsArrayByName(self.Node_rewardList, "btn_reward_", 8, 1)
	for i, v in ipairs(self.tableOpenReward) do
		v:addTouchEventListener(handler(self, self.OnTreasureClick))
	end
	self.CheckBox:setSelected(false)
	self.CheckBox:addTouchEventListener(handler(self, self.btnChioceClickCallBack))
	self.tableOpacityNode = SoraDGetChildsArrayByName(self.Node_rewardList, "Node_reward_", 8, 1)
	self.tableImageNode = SoraDGetChildsArrayByName(self.Node_rewardList, "Image_reward_", 8, 1)
	self.tableImageEffect = SoraDGetChildsArrayByName(self.Node_rewardList, "image_effect_", 8, 1)
	self.tableText = SoraDGetChildsArrayByName(self.Node_rewardList, "text_reward_num_", 8, 1)
	self.ccs_title:setTitle(i18n("Canyon_Treasur_text_01"))
	self.btn_choose:setTitleText(i18n("treasure_crystal_btn_02"))
	_ENV = i18n("treasure_crystal_btn_02")
	i18n("treasure_crystal_btn_02").num = 1
	self.Text_hunt1:setString(i18n("Canyon_Treasur_text_15", i18n("treasure_crystal_btn_02")))
	_ENV = i18n("Canyon_Treasur_text_15", i18n("treasure_crystal_btn_02"))
	i18n("Canyon_Treasur_text_15", i18n("treasure_crystal_btn_02")).num = 5
	self.Text_hunt2:setString(i18n("Canyon_Treasur_text_15", i18n("Canyon_Treasur_text_15", i18n("treasure_crystal_btn_02"))))
	self.text_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("gift_send_text_04", nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		_ENV = i18n("Canyon_Treasur_text_15", i18n("Canyon_Treasur_text_15", i18n("treasure_crystal_btn_02")))
		i18n("Canyon_Treasur_text_15", i18n("Canyon_Treasur_text_15", i18n("treasure_crystal_btn_02"))).time = leftTime
		self.text_time:setString(i18n("gift_send_text_04", i18n("Canyon_Treasur_text_15", i18n("Canyon_Treasur_text_15", i18n("treasure_crystal_btn_02")))))
		self.text_time:beginTime(leftTime)
	end
	self.icon_hourglass_43:setPositionX(self.text_time:getPositionX() + SoraDFSign(self.text_time:getContentSize().width / 2) + SoraDFSign(30))
	self.Node_reward_choosed:setPositionY(self.Node_reward_choosed:getPositionY() + 20)
	self.btn_choose:addTouchEventListener(handler(self, self.OnChooseClick))
	self.btn_rewardLook:addTouchEventListener(handler(self, self.OnRewardLookClick))
	self.btn_discountLook:addTouchEventListener(handler(self, self.OnDiscountLookClick))
	self.btn_hunt1:addTouchEventListener(handler(self, self.OnHuntClick))
	self.btn_hunt2:addTouchEventListener(handler(self, self.OnHuntClick))
	self.btn_help_tip:addTouchEventListener(handler(self, self.btnTipClick))
	self.btn_jumpPackage:addTouchEventListener(handler(self, self.btnJumpClick))
	self.Button_refresh:addTouchEventListener(handler(self, self.OnChooseClick))
	self.text_check_tip:setString(i18n("Canyon_Treasur_text_27"))
	_ENV = i18n("Canyon_Treasur_text_27")
	i18n("Canyon_Treasur_text_27").tabNum = table.nums(gCanyonTreasureHuntType)
	_ENV, i18n("Canyon_Treasur_text_27").defaultClick = gCanyonTreasureHuntType.NORMAL, gCanyonTreasureHuntType.NORMAL
	_ENV = i18n("Canyon_Treasur_text_27")
	i18n("Canyon_Treasur_text_27").title = i18n("Canyon_Treasur_text_02")
	gCanyonTreasureHuntType.NORMAL[gCanyonTreasureHuntType.NORMAL], i18n("Canyon_Treasur_text_27").handle = i18n("Canyon_Treasur_text_27")
	_ENV = i18n("Canyon_Treasur_text_27")
	i18n("Canyon_Treasur_text_27").title = i18n("Canyon_Treasur_text_03")
	i18n("Canyon_Treasur_text_27").tabsetArray, gCanyonTreasureHuntType.NORMAL[gCanyonTreasureHuntType.HIGH], i18n("Canyon_Treasur_text_27").handle = gCanyonTreasureHuntType.NORMAL, i18n("Canyon_Treasur_text_27")
	self.ccs_tab:initView(i18n("Canyon_Treasur_text_27"))
	self.Text_timeHunt1:setTimeEndListener(function(...)
		self.Node_disCount1:setVisible(false)
		self.Node_gold1:setVisible(true)
		self.Text_timeHunt1:setVisible(false)
	end)
	self.btn_choose:setVisible(false)
	self.Node_hunt2:setVisible(true)
	self.Node_hunt1:setVisible(true)
	self.isPlayChoosed = false
end
function canyonTreasureHuntView:fitDevice()
	if math.floor(display.height) == 960 then
		self.Node_rewardList:setScale(0.7)
		self.Node_rewardList:setPositionY(self.Node_rewardList:getPositionY() + 70)
	elseif math.floor(display.height) == 853 then
		self.Node_rewardList:setScale(0.6)
		self.Bottom_Node:setScale(0.8)
		self.Bottom_Node:setPositionX(self.Bottom_Node:getPositionX() + 70)
		self.Node_rewardList:setPositionY(self.Node_rewardList:getPositionY() + 100)
	end
end
function canyonTreasureHuntView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_CANYON_TREASURE_INIT", function(target, data)
		SoraDCloseLoading(self)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_CANYON_TREASURE_OPTIONAL_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		self.isPlayChoosed = true
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_CANYON_TREASURE_HUNT_BACK", function(target, data)
		SoraDCloseLoading(self)
		local huntData = canyonTreasureCtrl:getHuntData()
		local commonData = canyonTreasureCtrl:getCommonData()
		if commonData and huntData then
			if self.isPlayAnimation then
				_UPVALUE6_ = nil
				;(nil)[1] = cca.callFunc(function(...)
					self:initFdjEffect(true)
				end)
				;(nil)[2] = cca.delay(2.0)
				;(nil)[3] = cca.callFunc(function(...)
					self:initFdjEffect(false)
				end)
				;(nil)[4] = cca.delay(0.3)
				;(nil)[5] = cca.callFunc(function(...)
					if self.eightConfig and next(self.eightConfig) then
						if #commonData.rewards == 1 then
							for i, v in ipairs(self.eightConfig) do
								self:initSingleGetEffect(v.id == commonData.rewards[1].id, self.tableOpacityNode[i], cc.p(0, 30))
							end
						else
							for i = 1, #self.eightConfig do
								local isPlaying = false
								for j = 1, #commonData.rewards do
									if self.eightConfig[i].id == commonData.rewards[j].id then
										isPlaying = true
									end
								end
								self:initSingleGetEffect(isPlaying, self.tableOpacityNode[i], cc.p(0, 30))
							end
						end
					end
				end)
				;(nil)[6] = cca.delay(1.0)
				;(nil)[7] = cca.callFunc(function(...)
					local panel = SoraDCreatePanel("canyonTreasureGetRewardPopView")
					panel:initData(commonData, huntData)
					panel:show()
				end)
				;(nil)[8] = cca.callFunc(function(...)
					local panel = SoraDCreatePanel("canyonTreasureGetRewardPopView")
					panel:initData(commonData, huntData)
					panel:show()
				end)
				self.Top_Node:runAction(cca.seq(nil))
			else
				local panel = SoraDCreatePanel("canyonTreasureGetRewardPopView")
				panel:initData(commonData, huntData)
				panel:show()
			end
		end
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", function(target, data)
		self:refreshRollCount()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function canyonTreasureHuntView:initData()
	self:refreshOptionalReward()
	self:refreshPrice()
	self:refreshDisCount()
	self:refreshRollCount()
end
function canyonTreasureHuntView:initOptionalRewardScroll()
	self.scroll_reward:removeAllChildren()
	self.awardArray, _ENV = self.scroll_reward.removeAllChildren, self.scroll_reward.removeAllChildren
	local scrollW = math.max(self.scroll_reward:getContentSize().width, 1080)
	self.scroll_reward:setInnerContainerSize(cc.size(scrollW, self.scroll_reward:getContentSize().height))
	for k, v in ipairs(self.optionalRewardList) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setOwnView(self)
			self.awardArray[k]:setPosition(50 + 120 * (k - 1), self.scroll_reward:getContentSize().height / 2)
			self.awardArray[k]:addTo(self.scroll_reward)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.count)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
		end
	end
	if #self.awardArray > #self.optionalRewardList then
		for k = #self.awardArray, #self.optionalRewardList + 1, -1 do
			self.awardArray[k]:setVisible(false)
		end
	end
	if SoraDFIsRA() then
		self.scroll_reward:jumpToRight()
	end
end
function canyonTreasureHuntView:initNoChoosedFrame()
	for i = 1, 3 do
		local cell = self.Node_Optional:clone()
		cell:setPosition(165 + (i - 1) * 150, 210)
		cell:addTo(self.Node_noChoose)
		local btnChooseEx = SoraDGetChildByName(cell, "Button_add")
		btnChooseEx:addTouchEventListener(handler(self, self.OnChooseClick))
	end
end
function canyonTreasureHuntView:initChoosedReward()
	self.Node_reward_choosed:removeAllChildren()
	for k, v in ipairs(self.optionalRewardList) do
		local single = self.Node_crSingle:clone()
		single:addTo(self.Node_reward_choosed)
		single:setPosition(cc.p(0, 0))
		local item = SoraDCreatePanel("commonItemAward")
		self:initSingleGetEffect(self.isPlayChoosed, item, cc.p(0, 0))
		item:addTo(single, -1)
		item:setOwnView(self)
		item:setPosition(cc.p(0, 0))
		item:initData(v.id, v.count)
	end
	SoraDToCenter(self.Node_reward_choosed, 140, SoraDFIsRA())
end
function canyonTreasureHuntView:onBtnClick(tag, name)
	if tag ~= self.canyouType then
		self.canyouType = tag
		self:refreshDisCount()
	end
	self.isPlayChoosed = false
	self:refreshOptionalReward()
	self:refreshPrice()
	self:refreshRollCount()
end
function canyonTreasureHuntView:btnTipClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "Canyon_Treasur_text_18"
		;("Canyon_Treasur_text_18").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("Canyon_Treasur_text_18"), "Canyon_Treasur_text_18")
	end
end
function canyonTreasureHuntView:refreshRollCount()
	local rollCount = backpackCtrl:getItemCount(726101)
	local iconImage = "icon_canyon_ordinary.png"
	if self.canyouType == gCanyonTreasureHuntType.HIGH then
		rollCount = backpackCtrl:getItemCount(726201)
		iconImage = "icon_canyon_advanced.png"
	end
	self.txt_rollNum:setString(rollCount)
	self.Image_gold_1_1_0:loadTexture(iconImage, ccui.TextureResType.plistType)
	self.Image_gold_1_1_0:setPositionX(self.txt_rollNum:getPositionX() + SoraDFSign(self.txt_rollNum:getContentSize().width) + SoraDFSign(20))
	self.btn_jumpPackage:setPositionX(self.txt_rollNum:getPositionX() - SoraDFSign(self.txt_rollNum:getContentSize().width) - SoraDFSign(20))
end
function canyonTreasureHuntView:refreshDisCount()
	local discountEndTime1 = canyonTreasureCtrl:getEndTimeByType(self.canyouType, 1)
	local disCountNum1 = canyonTreasureCtrl:getDisCountByType(self.canyouType, 1)
	local remainTime1 = discountEndTime1 - serviceFunctions.systemTime()
	local price1 = canyonTreasureHuntRead.getTreasureCost(self.canyouType, 1)
	local rollCount = backpackCtrl:getItemCount(726101)
	local discountEndTime2 = canyonTreasureCtrl:getEndTimeByType(self.canyouType, 1)
	local disCountNum2 = canyonTreasureCtrl:getDisCountByType(self.canyouType, 1)
	local remainTime2 = discountEndTime2 - serviceFunctions.systemTime()
	local price2 = canyonTreasureHuntRead.getTreasureCost(self.canyouType, 5)
	if self.canyouType == gCanyonTreasureHuntType.HIGH then
		rollCount = backpackCtrl:getItemCount(726201)
	end
	self.text_originalPrice1:setString(price1)
	self.text_originalPrice2:setString(price2)
	self.text_nowPrice1:setString(tostring(math.ceil(price1 * disCountNum1 / 100)))
	self.text_nowPrice2:setString(tostring(math.ceil(price2 * disCountNum2 / 100)))
	self.text_nowPrice1:setColor(rollCount >= math.ceil(price1 * disCountNum1 / 100) and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	self.text_nowPrice2:setColor(rollCount >= math.ceil(price2 * disCountNum2 / 100) and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	if 1 < remainTime1 then
		self.Text_timeHunt1:setTimeLast(function(time)
			_ENV = nil
			_ENV, _ENV, (nil).time = nil, nil, time
			_ENV, (nil).time, (nil).color = nil, nil, "#FF0000"
			;(nil).__default, (nil).color = nil, "#FFFFFF"
			return i18n_html("Canyon_Treasur_text_25", nil, nil)
		end)
		self.Text_timeHunt1:setString(remainTime1)
		self.Text_timeHunt1:beginTime(remainTime1)
		self.Text_timeDisCountNo:setVisible(false)
		self.Text_timeHunt1:setVisible(true)
		self.btn_discountLook:setPositionX(self.Text_timeHunt1:getPositionX() + SoraDFSign(self.Text_timeHunt1:getContentSize().width / 2) + SoraDFSign(20))
	else
		self.Text_timeHunt1:setVisible(false)
		self.Text_timeDisCountNo:setVisible(true)
		self.Text_timeDisCountNo:setString(i18n("lucky_text_05"))
		self.btn_discountLook:setPositionX(self.Text_timeDisCountNo:getPositionX() + SoraDFSign(self.Text_timeDisCountNo:getContentSize().width / 2) + SoraDFSign(30))
	end
	local isFreeUsed = canyonTreasureCtrl:isFreeUsed()
	print("slkjfskdjflksdjf", isFreeUsed)
	self.Node_gold1:setVisible(remainTime1 <= 0 or disCountNum1 == 100)
	self.Node_disCount1:setVisible(0 < remainTime1 and disCountNum1 ~= 100)
	self.btn_hunt1:setTitleText("")
	self.Text_hunt1:setVisible(true)
	if gCanyonTreasureHuntType.NORMAL == self.canyouType then
		self.Text_hunt1:setVisible(not isFreeUsed)
		self.btn_hunt1:setTitleText(isFreeUsed and i18n("common_text_049") or "")
		if isFreeUsed then
			self.Node_gold1:setVisible(false)
			self.Node_disCount1:setVisible(false)
		end
	end
	self.Node_gold2:setVisible(remainTime2 <= 0 or disCountNum2 == 100)
	self.Node_disCount2:setVisible(0 < remainTime2 and disCountNum2 ~= 100)
end
function canyonTreasureHuntView:refreshOptionalReward()
	self.hasChoosed = false
	self.optionalRewards = canyonTreasureCtrl:getOptinalRewardsByType(self.canyouType)
	if self.optionalRewards and next(self.optionalRewards) then
		self.optionalRewardList, canyonTreasureCtrl, self.hasChoosed = next(self.optionalRewards), next(self.optionalRewards), true
		for i, v in ipairs(self.optionalRewards) do
			local config = canyonTreasureHuntRead.getCtrConfigByID(v)
			canyonTreasureCtrl = nil
			;(nil).id = config.item
			;(nil).count = config.num
			table.insert(self.optionalRewardList, nil)
		end
		self.btn_hunt2:setEnabled(true)
		self.btn_hunt2:setBright(true)
		self.btn_hunt1:setEnabled(true)
		self.btn_hunt1:setBright(true)
		self.Node_noChoose:setVisible(false)
		self.Text_rewardTitle:setString(i18n("Canyon_Treasur_text_05"))
		self:initChoosedReward()
		self.Node_reward_choosed:setVisible(true)
		self.Button_refresh:setVisible(true)
		self.Image_refresh:setVisible(true)
		self:stopAllActions()
		SoraDCreatAnimation(self.__cname, self, true)
		for i, v in ipairs(self.tableImageEffect) do
			v:setVisible(true)
		end
	else
		self.btn_hunt2:setEnabled(false)
		self.btn_hunt2:setBright(false)
		self.btn_hunt1:setEnabled(false)
		self.btn_hunt1:setBright(false)
		self.Node_noChoose:setVisible(true)
		self.Text_rewardTitle:setString(i18n("Canyon_Treasur_text_05"))
		self.Node_reward_choosed:setVisible(false)
		self.Button_refresh:setVisible(false)
		self.Image_refresh:setVisible(false)
		self:stopAllActions()
		for i, v in ipairs(self.tableImageEffect) do
			v:setVisible(false)
		end
	end
	for i, v in ipairs(self.tableOpacityNode) do
		v:setOpacity(self.hasChoosed and 255 or 178.5)
	end
	self:refreshRewardImage()
	local iconImage = "icon_canyon_ordinary.png"
	if self.canyouType == gCanyonTreasureHuntType.HIGH then
		iconImage = "icon_canyon_advanced.png"
	end
	self.Image_gold1:loadTexture(iconImage, ccui.TextureResType.plistType)
	self.Image_gold2:loadTexture(iconImage, ccui.TextureResType.plistType)
	self.Image_gold_0_0:loadTexture(iconImage, ccui.TextureResType.plistType)
	self.Image_gold_0:loadTexture(iconImage, ccui.TextureResType.plistType)
	self.Image_gold_1:loadTexture(iconImage, ccui.TextureResType.plistType)
	self.Image_gold_1_1:loadTexture(iconImage, ccui.TextureResType.plistType)
end
function canyonTreasureHuntView:refreshRewardImage()
	if self.optionalRewards and next(self.optionalRewards) then
		self.eightConfig, _ENV = next(self.optionalRewards), next(self.optionalRewards)
		local tempFixed = canyonTreasureHuntRead.getTreasureOptionalReward(self.canyouType, gcanyonTreasureRewardType.FIXED)
		for i, v in ipairs(self.optionalRewardList) do
			table.insert(self.eightConfig, v)
		end
		for i, v in ipairs(tempFixed) do
			table.insert(self.eightConfig, v)
		end
		for i, v in ipairs(self.tableImageNode) do
			v:setContentSize(cc.size(90, 90))
			v:loadTexture(publicRead.getIcon(self.eightConfig[i].id), ccui.TextureResType.plistType)
		end
		for i, v in ipairs(self.tableOpenReward) do
			v:setEnabled(true)
			v:setTag(self.eightConfig[i].id)
		end
		for i, v in ipairs(self.tableText) do
			v:setString(self.eightConfig[i].count)
		end
	else
		for i, v in ipairs(self.tableImageNode) do
			v:setContentSize(cc.size(54, 81))
			v:loadTexture("icon_xgxb_wh.png", ccui.TextureResType.plistType)
		end
		for i, v in ipairs(self.tableText) do
			v:setString("")
		end
	end
end
function canyonTreasureHuntView:refreshPrice()
	local price1 = canyonTreasureHuntRead.getTreasureCost(self.canyouType, 1)
	local rollCount = backpackCtrl:getItemCount(726101)
	self.Text_gold1:setString(tostring(price1))
	local price2 = canyonTreasureHuntRead.getTreasureCost(self.canyouType, 5)
	self.Text_gold2:setString(tostring(price2))
	self.Text_gold1:setColor(price1 <= rollCount and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	self.Text_gold2:setColor(rollCount >= price2 and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	if self.canyouType == gCanyonTreasureHuntType.HIGH then
		rollCount = backpackCtrl:getItemCount(726201)
		self.Text_gold1:setColor(price1 <= rollCount and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
		self.Text_gold2:setColor(price2 <= rollCount and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	end
end
function canyonTreasureHuntView:OnTreasureClick(button, eventType)
	if self.optionalRewards and next(self.optionalRewards) then
		if eventType == ccui.TouchEventType.ended then
			SoraDCloseCommonTips()
		elseif eventType == ccui.TouchEventType.began then
			SoraDPlaySound()
			SoraDShowCommonTips(button, button:getTag())
		end
	elseif eventType == ccui.TouchEventType.ended then
		SoraDShowMsgTip(i18n("Canyon_Treasur_text_20"))
	end
end
function canyonTreasureHuntView:OnChooseClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("canyonTreasureRewardChoose")
		_ENV = nil
		;(nil).type = self.canyouType
		panel:initData(nil)
		panel:show()
	end
end
function canyonTreasureHuntView:OnRewardLookClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("canyonTreasureRewardPreview")
		_ENV = nil
		;(nil).type = self.canyouType
		panel:initData(nil)
		panel:show()
	end
end
function canyonTreasureHuntView:OnDiscountLookClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("canyonTreasureHuntMoreView")
		_ENV = nil
		;(nil).type = self.canyouType
		panel:initData(nil)
		panel:show()
	end
end
function canyonTreasureHuntView:btnChioceClickCallBack(button, type)
	SoraDPlaySound(nil, nil, true)
	print("skjdfklsjdflksj", self.CheckBox:isSelected())
	self.isPlayAnimation = self.CheckBox:isSelected()
end
function canyonTreasureHuntView:OnHuntClick(button, eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if not self.hasChoosed then
		return
	end
	local rollCount = backpackCtrl:getItemCount(726101)
	local needCount = canyonTreasureHuntRead.getTreasureCost(self.canyouType, 1)
	local disCountNum = canyonTreasureCtrl:getDisCountByType(self.canyouType, 1)
	local isFreeUsed = canyonTreasureCtrl:isFreeUsed()
	local remainTime = canyonTreasureCtrl:getEndTimeByType(self.canyouType, 1) - serviceFunctions.systemTime()
	if self.canyouType == gCanyonTreasureHuntType.HIGH then
		rollCount = backpackCtrl:getItemCount(726201)
		isFreeUsed = true
	end
	if button == self.btn_hunt2 then
		needCount = canyonTreasureHuntRead.getTreasureCost(self.canyouType, 5)
		disCountNum = canyonTreasureCtrl:getDisCountByType(self.canyouType, 5)
		remainTime = canyonTreasureCtrl:getEndTimeByType(self.canyouType, 5) - serviceFunctions.systemTime()
		isFreeUsed = true
	end
	if 0 < remainTime then
		needCount = math.ceil(needCount * disCountNum / 100)
	end
	if rollCount < needCount and not isFreeUsed then
		local msgBoxPanel = SoraDShowMsgBox(i18n("Canyon_Treasur_text_16"), i18n("common_text_477"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				local packageID = 13944
				if self.canyouType == gCanyonTreasureHuntType.HIGH then
					packageID = 13946
				end
				if GLOBAL_GAME_RECHARGE_MODE then
					_ENV = nil
					;(nil).rechargeID = packageID
					uiManager:show("rechargeView", nil)
				else
					local panel = SoraDCreatePanel("rechargeView")
					panel:expect2SelectTabEx(gRechargeCenterCategory.HOTGIFT, packageID)
					panel:show()
				end
			end
		end)
		return
	end
	SoraDShowLoading()
	self.isPlayChoosed = false
	if button == self.btn_hunt1 then
		local discountEndTime1 = canyonTreasureCtrl:getEndTimeByType(self.canyouType, 1)
		local remainTime1 = discountEndTime1 - serviceFunctions.systemTime()
		local isDiscount1 = 0 < remainTime1 and true or false
		canyonTreasureCtrl:reqLottery(self.canyouType, 1, isDiscount1)
	elseif button == self.btn_hunt2 then
		local discountEndTime2 = canyonTreasureCtrl:getEndTimeByType(self.canyouType, 5)
		local remainTime2 = discountEndTime2 - serviceFunctions.systemTime()
		local isDiscount2 = 0 < remainTime2 and true or false
		canyonTreasureCtrl:reqLottery(self.canyouType, 5, isDiscount2)
	end
end
function canyonTreasureHuntView:btnJumpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local packageID = 13944
		if self.canyouType == gCanyonTreasureHuntType.HIGH then
			packageID = 13946
		end
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).rechargeID = packageID
			uiManager:show("rechargeView", nil)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:expect2SelectTabEx(gRechargeCenterCategory.HOTGIFT, packageID)
			panel:show()
		end
	end
end
function canyonTreasureHuntView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return canyonTreasureHuntView
