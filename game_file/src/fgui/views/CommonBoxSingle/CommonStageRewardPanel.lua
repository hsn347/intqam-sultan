local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonStageRewardPanel = class("CommonStageRewardPanel", baseFguiPanel)
function CommonStageRewardPanel:ctor(...)
	CommonStageRewardPanel.super.ctor(self, ...)
	print("CommonStageRewardPanel:ctor", self.viewName)
	self.debug = true
end
function CommonStageRewardPanel:onInit()
	print("=======CommonStageRewardPanel:onInit")
	if SoraDFIsRA() then
		self.fields.Image_title:setURL("font_yfct_ar.png")
	else
		self.fields.Image_title:setURL("font_yfct_en.png")
	end
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_get:addClickListener(handler(self, self.onClickButtonGet))
	self.fields.Text_notify:setString(i18n("Bright_fireworks_05"))
end
function CommonStageRewardPanel:onShow()
	print("=======CommonStageRewardPanel:onShow")
	if not self.param then
		_ENV = self.param
	end
	self:initData(self.param)
end
function CommonStageRewardPanel:onItemRenderer(index, obj)
	local data = self.rewardList[index + 1]
	obj:initData(data.id, data.count)
end
function CommonStageRewardPanel:onClickButtonGet()
	SoraDPlaySound()
	print("self.activityID=====", self.activityID, self.stage)
	if self.activityID == gActivityTimeActivityID.MAGIC_FLIP_ACTIVITY then
		local magicFlipCtrl = SoraDGetCtrl("magicFlipCtrl")
		magicFlipCtrl:reqMagicFlipStageReward(self.stage)
		self:closePanel()
		return
	elseif self.activityID == gActivityTimeActivityID.NEBULA_FURNACE_ACTIVITY then
		local activity_9001651_Ctrl = SoraDGetCtrl("activity_9001651_Ctrl")
		activity_9001651_Ctrl:sendStageRewardMsg(self.stage)
		self:closePanel()
		return
	elseif self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001665 then
		local activity_9001665_Ctrl = SoraDGetCtrl("activity_9001665_Ctrl")
		activity_9001665_Ctrl:reqReceive(self.stage)
		self:closePanel()
		return
	elseif self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001665_BOOK then
		local activity_9001665_Ctrl = SoraDGetCtrl("activity_9001665_Ctrl")
		activity_9001665_Ctrl:reqFishReward(self.stage)
		self:closePanel()
		return
	elseif self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001666 then
		local activity_9001666_Ctrl = SoraDGetCtrl("activity_9001666_Ctrl")
		activity_9001666_Ctrl:reqSnowCompetitionAchievementStageReward(self.stage)
		self:closePanel()
		return
	elseif self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001705 then
		local activity_9001705_Ctrl = SoraDGetCtrl("activity_9001705_Ctrl")
		activity_9001705_Ctrl:reqSnowCompetitionAchievementStageReward(self.stage)
		self:closePanel()
		return
	elseif self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001669 or self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
		local activityCommonKitchenCtrl = SoraDGetCtrl("activityCommonKitchenCtrl")
		activityCommonKitchenCtrl:reqStageReward(self.activityID, self.stage)
		self:closePanel()
		return
	elseif self.activityID == gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY then
		local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
		roaringFlameWarCtrl:reqTurnStage(self.stage)
		self:closePanel()
		return
	elseif self.activityID == gActivityTimeActivityID.DONATE_METERIAL_ACTIVITY then
		local activity_9001684_Ctrl = SoraDGetCtrl("activity_9001684_Ctrl")
		activity_9001684_Ctrl:reqStageReward(self.otherData.stageType, self.stage)
		self:closePanel()
		return
	elseif self.activityID == gActivityTimeActivityID.SULTAN_COIN_PRESENT_ACTIVITY then
		local activity_9001706_Ctrl = SoraDGetCtrl("activity_9001706_Ctrl")
		activity_9001706_Ctrl:sendStageReward(self.stage)
		self:closePanel()
		return
	elseif self.activityID == gActivityTimeActivityID.BALLOON_HUNTER_ACTIVITY then
		local activity_9001703_Ctrl = SoraDGetCtrl("activity_9001703_Ctrl")
		activity_9001703_Ctrl:reqStageReward(self.stage)
		self:closePanel()
		return
	elseif self.activityID == gActivityTimeActivityID.MAGIC_CARPET then
		local activity_9001719_Ctrl = SoraDGetCtrl("activity_9001719_Ctrl")
		activity_9001719_Ctrl:reqStageReward(self.stage)
		self:closePanel()
		return
	elseif self.activityID == gActivityTimeActivityID.LAMP_WISH_ACTIVITY then
		local activityCommonDrawCtrl = SoraDGetCtrl("activityCommonDrawCtrl")
		activityCommonDrawCtrl:reqStageReward(self.activityID, self.stage)
		self:closePanel()
		return
	elseif self.activityID == gActivityTimeActivityID.MAGIC_DRAW_ACTIVITY then
		local magicLampSkillLotteryCtrl = SoraDGetCtrl("magicLampSkillLotteryCtrl")
		magicLampSkillLotteryCtrl:reqStageReward(self.otherData.stageType, self.stage)
		self:closePanel()
		return
	elseif self.activityID == gActivityTimeActivityID.CRESCENT_TREASURE_ACTIVITY then
		local activity_9001729_Ctrl = SoraDGetCtrl("activity_9001729_Ctrl")
		activity_9001729_Ctrl:reqStageRewardMsg(self.stage)
		self:closePanel()
		return
	elseif self.activityID == gActivityTimeActivityID.FLYING_CHESS_ACTIVITY then
		local activity_9001731_Ctrl = SoraDGetCtrl("activity_9001731_Ctrl")
		activity_9001731_Ctrl:reqQuest(self.stage)
		self:closePanel()
		return
	elseif self.activityID == gActivityTimeActivityID.FREE_KICK_MASTER_ACTIVITY then
		local activity_9001735_Ctrl = SoraDGetCtrl("activity_9001735_Ctrl")
		activity_9001735_Ctrl:reqStage(self.stage)
		self:closePanel()
		return
	elseif self.activityID == gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY then
		local activity_9001737_Ctrl = SoraDGetCtrl("activity_9001737_Ctrl")
		activity_9001737_Ctrl:reqClaimReward(self.stage)
		self:closePanel()
		return
	else
		self:closePanel()
	end
end
function CommonStageRewardPanel:initData(data)
	self.activityID = data.activityID
	if not data.rewards then
		_ENV = data.rewards
	end
	self.rewardList = data.rewards
	if not data.otherData then
		_ENV = data.otherData
	end
	self.otherData = data.otherData
	if self.activityID == gActivityTimeActivityID.PHOENIX_ARRIVAL then
		self.fields.Text_point:setVisible(false)
		self.fields.Button_get:setVisible(false)
		local point = data.point or 0
		_ENV = nil
		;(nil).num = string.formatnumberthousands(point)
		local tipStr = i18n("phoenix_arrival_text_04", nil)
		local rewardDes = data.rewardDes
		if rewardDes and next(rewardDes) then
			tipStr = tipStr .. "\n" .. i18n(rewardDes)
		end
		self.fields.Text_tip:setString(tipStr)
	elseif self.activityID == gActivityTimeActivityID.MAGIC_FLIP_ACTIVITY then
		local point = data.point or 0
		_ENV = tipStr
		tipStr.num = string.formatnumberthousands(point)
		self.fields.Text_tip:setString(i18n("magic_flip_14", tipStr))
		local state = data.state or gBtnTargetStatusDef.GO
		self:updateButtonGet(state)
		self.stage = data.stage
		local magicFlipCtrl = SoraDGetCtrl("magicFlipCtrl")
		local flipCount = magicFlipCtrl:getFlipCount()
		_ENV = i18n("magic_flip_14", tipStr)
		i18n("magic_flip_14", tipStr).num = string.formatnumberthousands(flipCount)
		self.fields.Text_point:setString(i18n("magic_flip_8", i18n("magic_flip_14", tipStr)))
	elseif self.activityID == gActivityTimeActivityID.NEBULA_FURNACE_ACTIVITY then
		local point = data.point or 0
		self.stage = point
		_ENV = self.fields.Text_point
		self.fields.Text_point.num = string.formatnumberthousands(point)
		self.fields.Text_tip:setString(i18n("weapon_creating_15", self.fields.Text_point))
		local state = data.state or gBtnTargetStatusDef.GO
		self:updateButtonGet(state)
		self.fields.Text_point:setVisible(false)
	elseif self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001665 then
		local point = data.point or 0
		self.stage = data.stage
		_ENV = i18n("weapon_creating_15", self.fields.Text_point)
		i18n("weapon_creating_15", self.fields.Text_point).num = string.formatnumberthousands(point)
		self.fields.Text_tip:setString(i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point)))
		local state = data.state or gBtnTargetStatusDef.GO
		self:updateButtonGet(state)
		self.fields.Text_point:setVisible(false)
	elseif self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001665_BOOK then
		local point = data.point or 0
		self.stage = data.stage
		_ENV = i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point))
		i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point)).num = string.formatnumberthousands(point)
		self.fields.Text_tip:setString(i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point))))
		local state = data.state or gBtnTargetStatusDef.GO
		self:updateButtonGet(state)
		_ENV = i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point)))
		i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point))).num = string.formatnumberthousands(data.score)
		self.fields.Text_point:setString(i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point)))))
	elseif self.activityID == gActivityTimeActivityID.DONATE_METERIAL_ACTIVITY then
		local point = data.point or 0
		if self.otherData.stageType == 1 then
			_ENV = i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point))))
			i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point)))).num = string.formatnumberthousands(point)
			self.fields.Text_tip:setString(i18n("collect_activity_039", i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point))))))
			_ENV = i18n("collect_activity_039", i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point)))))
			i18n("collect_activity_039", i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point))))).num = string.formatnumberthousands(data.score)
			self.fields.Text_point:setString(i18n("collect_activity_030", i18n("collect_activity_039", i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point)))))))
		else
			_ENV = i18n("collect_activity_030", i18n("collect_activity_039", i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point))))))
			i18n("collect_activity_030", i18n("collect_activity_039", i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point)))))).num = string.formatnumberthousands(point)
			self.fields.Text_tip:setString(i18n("collect_activity_040", i18n("collect_activity_030", i18n("collect_activity_039", i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point))))))))
			_ENV = i18n("collect_activity_040", i18n("collect_activity_030", i18n("collect_activity_039", i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point)))))))
			i18n("collect_activity_040", i18n("collect_activity_030", i18n("collect_activity_039", i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point))))))).num = string.formatnumberthousands(data.score)
			self.fields.Text_point:setString(i18n("collect_activity_019", i18n("collect_activity_040", i18n("collect_activity_030", i18n("collect_activity_039", i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point)))))))))
		end
		local state = data.state or gBtnTargetStatusDef.GO
		self:updateButtonGet(state)
		self.stage = data.stage
	elseif self.activityID == gActivityTimeActivityID.SULTAN_COIN_PRESENT_ACTIVITY then
		local point = data.point or 0
		self.stage = data.stage
		_ENV = i18n("collect_activity_019", i18n("collect_activity_040", i18n("collect_activity_030", i18n("collect_activity_039", i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point))))))))
		i18n("collect_activity_019", i18n("collect_activity_040", i18n("collect_activity_030", i18n("collect_activity_039", i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point)))))))).num = string.formatnumberthousands(point)
		self.fields.Text_tip:setString(i18n("Sultan_present_text_06", i18n("collect_activity_019", i18n("collect_activity_040", i18n("collect_activity_030", i18n("collect_activity_039", i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point))))))))))
		local state = data.state or gBtnTargetStatusDef.GO
		self:updateButtonGet(state)
		local activity_9001706_Ctrl = SoraDGetCtrl("activity_9001706_Ctrl")
		local costSultanCoin = activity_9001706_Ctrl:getCostSultanCoin()
		_ENV = i18n("Sultan_present_text_06", i18n("collect_activity_019", i18n("collect_activity_040", i18n("collect_activity_030", i18n("collect_activity_039", i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point)))))))))
		i18n("Sultan_present_text_06", i18n("collect_activity_019", i18n("collect_activity_040", i18n("collect_activity_030", i18n("collect_activity_039", i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point))))))))).num = fguiHelper.getColorString("#FFDF2D", string.formatnumberthousands(costSultanCoin))
		self.fields.Text_point:setString(i18n("Sultan_present_text_07", i18n("Sultan_present_text_06", i18n("collect_activity_019", i18n("collect_activity_040", i18n("collect_activity_030", i18n("collect_activity_039", i18n("fishingmaster_text_27", i18n("fishingmaster_text_26", i18n("fishingmaster_text_03", i18n("weapon_creating_15", self.fields.Text_point)))))))))))
	elseif self.activityID == gActivityTimeActivityID.LAMP_WISH_ACTIVITY then
		local point = data.point or 0
		self.stage = data.stage
		_ENV = self.fields.Text_point
		self.fields.Text_point.num = string.formatnumberthousands(point)
		self.fields.Text_tip:setString(i18n("prayer_lamp_004", self.fields.Text_point))
		local state = data.state or gBtnTargetStatusDef.GO
		self:updateButtonGet(state)
		local activityCommonDrawCtrl = SoraDGetCtrl("activityCommonDrawCtrl")
		local activityData = activityCommonDrawCtrl:getActivityData(self.activityID)
		local needNum = point - activityData.totalTimes
		self.fields.Text_point:setVisible(0 < needNum)
		if 0 < needNum then
			_ENV = i18n("prayer_lamp_004", self.fields.Text_point)
			i18n("prayer_lamp_004", self.fields.Text_point).num = fguiHelper.getColorString("#FFDF2D", string.formatnumberthousands(needNum))
			self.fields.Text_point:setString(i18n("prayer_lamp_005", i18n("prayer_lamp_004", self.fields.Text_point)))
		end
	elseif self.activityID == gActivityTimeActivityID.FLYING_CHESS_ACTIVITY then
		local point = data.point or 0
		self.stage = data.stage
		_ENV = self.fields.Text_point.setString
		self.fields.Text_point.setString.num = string.formatnumberthousands(point)
		self.fields.Text_tip:setString(i18n("Ludo_test_010", self.fields.Text_point.setString))
		local state = data.state or gBtnTargetStatusDef.GO
		self:updateButtonGet(state)
		_ENV = i18n("Ludo_test_010", self.fields.Text_point.setString)
		i18n("Ludo_test_010", self.fields.Text_point.setString).num = string.formatnumberthousands(data.score)
		self.fields.Text_point:setString(i18n("Ludo_test_036", i18n("Ludo_test_010", self.fields.Text_point.setString)))
	elseif self.activityID == gActivityTimeActivityID.FREE_KICK_MASTER_ACTIVITY then
		local point = data.point or 0
		self.stage = data.point
		_ENV = i18n("Ludo_test_036", i18n("Ludo_test_010", self.fields.Text_point.setString))
		i18n("Ludo_test_036", i18n("Ludo_test_010", self.fields.Text_point.setString)).num = string.formatnumberthousands(point)
		self.fields.Text_tip:setString(i18n("pet_flip_text_04", i18n("Ludo_test_036", i18n("Ludo_test_010", self.fields.Text_point.setString))))
		local state = data.state or gBtnTargetStatusDef.GO
		self:updateButtonGet(state)
		_ENV = i18n("pet_flip_text_04", i18n("Ludo_test_036", i18n("Ludo_test_010", self.fields.Text_point.setString)))
		i18n("pet_flip_text_04", i18n("Ludo_test_036", i18n("Ludo_test_010", self.fields.Text_point.setString))).num = string.formatnumberthousands(data.score)
		self.fields.Text_point:setString(i18n("Bubble_Bobble_text_02", i18n("pet_flip_text_04", i18n("Ludo_test_036", i18n("Ludo_test_010", self.fields.Text_point.setString)))))
	else
		if data.tipStr then
			self.fields.Text_tip:setString(data.tipStr)
		else
			local point = data.point or 0
			_ENV = i18n("Bubble_Bobble_text_02", i18n("pet_flip_text_04", i18n("Ludo_test_036", i18n("Ludo_test_010", self.fields.Text_point.setString))))
			i18n("Bubble_Bobble_text_02", i18n("pet_flip_text_04", i18n("Ludo_test_036", i18n("Ludo_test_010", self.fields.Text_point.setString)))).num = string.formatnumberthousands(point)
			self.fields.Text_tip:setString(i18n("pet_flip_text_04", i18n("Bubble_Bobble_text_02", i18n("pet_flip_text_04", i18n("Ludo_test_036", i18n("Ludo_test_010", self.fields.Text_point.setString))))))
		end
		if data.pointStr then
			self.fields.Text_point:setString(data.pointStr)
		else
			local point = data.score
			_ENV = i18n("pet_flip_text_04", i18n("Bubble_Bobble_text_02", i18n("pet_flip_text_04", i18n("Ludo_test_036", i18n("Ludo_test_010", self.fields.Text_point.setString)))))
			i18n("pet_flip_text_04", i18n("Bubble_Bobble_text_02", i18n("pet_flip_text_04", i18n("Ludo_test_036", i18n("Ludo_test_010", self.fields.Text_point.setString))))).num = string.formatnumberthousands(point)
			self.fields.Text_point:setString(i18n("Bubble_Bobble_text_02", i18n("pet_flip_text_04", i18n("Bubble_Bobble_text_02", i18n("pet_flip_text_04", i18n("Ludo_test_036", i18n("Ludo_test_010", self.fields.Text_point.setString)))))))
		end
		local state = data.state or gBtnTargetStatusDef.GO
		self:updateButtonGet(state)
		self.stage = data.stage
	end
	self.fields.List_reward:setNumItems(#self.rewardList)
	if #self.rewardList > 0 then
		self.fields.List_reward:scrollToView(0)
	end
end
function CommonStageRewardPanel:updateButtonGet(state)
	if state == gBtnTargetStatusDef.GOT then
		if self.activityID == gActivityTimeActivityID.DAILY_SALUTE then
			self.fields.Button_get:setString(i18n("common_text_2210"))
		else
			self.fields.Button_get:setString(i18n("common_text_1892"))
		end
		self.fields.Button_get:setEnabled(false)
	elseif state == gBtnTargetStatusDef.GET then
		self.fields.Button_get:setString(i18n("common_text_1146"))
	elseif state == gBtnTargetStatusDef.GO then
		if self.activityID == gActivityTimeActivityID.FLYING_CHESS_ACTIVITY then
			self.fields.Button_get:setString(i18n("PrideRebate_text_13"))
		elseif self.activityID == gActivityTimeActivityID.FREE_KICK_MASTER_ACTIVITY then
			self.fields.Button_get:setString(i18n("common_text_1146"))
		else
			self.fields.Button_get:setString(i18n("common_text_2139"))
		end
		self.fields.Button_get:setEnabled(false)
	end
end
return CommonStageRewardPanel
