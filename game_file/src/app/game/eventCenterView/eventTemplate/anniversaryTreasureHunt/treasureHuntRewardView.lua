local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local anniversaryTreasureHuntCtrl = gametop.playertop_:getModule("anniversaryTreasureHuntCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local anniversaryTreasureHuntRead = include("anniversaryTreasureHuntRead")
local treasureHuntRewardView = class("treasureHuntRewardView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("treasureHuntRewardView")
	end
	return target
end)
local singleNodeH = 270
function treasureHuntRewardView:ctor()
	self:initControls()
	self:initScroll()
end
function treasureHuntRewardView:initControls()
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_event")
	self.scroll = SoraDGetChildByName(self, "Top_Size_scroll")
	self.nodeSingle = SoraDGetChildByName(self, "node_single")
	self.btnHelpButton = SoraDGetChildByName(self, "btn_help_tip")
	self.btnHelpButton:setVisible(false)
	self.ccs_title:setTitle(i18n("anniversary_dice_text_08"))
	self.taskList = anniversaryTreasureHuntCtrl:getSortedTaskList()
end
function treasureHuntRewardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_TREASURE_GET_REWARD_BACK", function(target, data)
		SoraDCloseLoading(self)
		self.taskList = anniversaryTreasureHuntCtrl:getSortedTaskList()
		self:initScroll()
	end)
end
function treasureHuntRewardView:initScroll()
	self.scroll:removeAllChildren()
	local scrollH = math.max(self.scroll:getContentSize().height, singleNodeH * #self.taskList)
	self.scroll:setInnerContainerSize(cc.size(640, scrollH))
	for i, v in ipairs(self.taskList) do
		local cell = self.nodeSingle:clone()
		cell:setPosition(320, scrollH - (i - 1) * singleNodeH)
		cell:addTo(self.scroll)
		local txtTask = SoraDGetChildByName(cell, "Text_7")
		local loadingBar = SoraDGetChildByName(cell, "LoadingBar_progress")
		local txtProgress = SoraDGetChildByName(cell, "text_progress")
		local btnGet = SoraDGetChildByName(cell, "Button_15")
		local cellScroll = SoraDGetChildByName(cell, "ScrollView_2")
		local cellSprite = SoraDGetChildByName(cell, "Image_16")
		local cellSpriteBg = SoraDGetChildByName(cell, "Image_15")
		local comStr = ""
		local progressStr = ""
		local taskImage = ""
		local taskImageBg = ""
		local percent = 0
		local curCount = 0
		if v.type == gAchievementTaskType.TOTAL_THROW_DICE_TIME then
			comStr = i18n("anniversary_dice_text_09") .. "：" .. v.require
			curCount = anniversaryTreasureHuntCtrl:getTotalThrowTimes()
			taskImage = "icon_znxb_task_03.png"
			taskImageBg = "frame_znxb_cellbg_blue.png"
		elseif v.type == gAchievementTaskType.TOTAL_STEP_COUNT then
			comStr = i18n("anniversary_dice_text_10") .. "：" .. v.require
			curCount = anniversaryTreasureHuntCtrl:getTotalStepCount()
			taskImage = "icon_znxb_task_01.png"
			taskImageBg = "frame_znxb_cellbg_green.png"
		elseif v.type == gAchievementTaskType.TOTAL_ROUND_COUNT then
			comStr = i18n("anniversary_dice_text_11") .. "：" .. v.require
			curCount = anniversaryTreasureHuntCtrl:getTotalRoundCount()
			taskImage = "icon_znxb_task_02.png"
			taskImageBg = "frame_znxb_cellbg_purple.png"
		end
		progressStr = curCount .. "/" .. v.require
		percent = curCount * 100 / v.require
		txtTask:setString(comStr)
		txtProgress:setString(progressStr)
		loadingBar:setPercent(percent)
		cellSprite:loadTexture(taskImage, ccui.TextureResType.plistType)
		cellSpriteBg:loadTexture(taskImageBg, ccui.TextureResType.plistType)
		btnGet:setTitleText(curCount >= v.require and anniversaryTreasureHuntCtrl:isRewardClaimed(v.index) and i18n("common_text_1892") or i18n("common_text_677"))
		btnGet:setTouchEnabled(curCount >= v.require and not anniversaryTreasureHuntCtrl:isRewardClaimed(v.index))
		btnGet:setBright(curCount >= v.require and not anniversaryTreasureHuntCtrl:isRewardClaimed(v.index))
		btnGet:setTag(v.index)
		btnGet:addTouchEventListener(handler(self, self.buttonGetRewardCallBack))
		anniversaryTreasureHuntCtrl = handler(self, self.buttonGetRewardCallBack)
		handler(self, self.buttonGetRewardCallBack)[1] = "id"
		handler(self, self.buttonGetRewardCallBack)[2] = "count"
		local rewardList = serviceFunctions.tableFormat(v.reward, handler(self, self.buttonGetRewardCallBack))
		cellScroll:removeAllChildren()
		local sSize = cellScroll:getContentSize()
		local sH = math.max(math.ceil(#rewardList / 6) * 100, sSize.height)
		cellScroll:setInnerContainerSize(cc.size(sH, 125))
		for j, m in ipairs(rewardList) do
			local cellReward = include("commonItemAward").new()
			cellReward:setOwnView(self)
			if SoraDFIsRA() then
				cellReward:setPosition(550 - (j - 1) * 110, 65)
			else
				cellReward:setPosition(60 + (j - 1) * 110, 65)
			end
			cellReward:initData(m.id, m.count)
			cellReward:addTo(cellScroll, 10)
		end
	end
end
function treasureHuntRewardView:buttonGetRewardCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local index = 0
		local taskType = 0
		for i, v in ipairs(self.taskList) do
			if v.index == button:getTag() then
				index = v.index
				taskType = v.type
				break
			end
		end
		if index ~= 0 and taskType ~= 0 then
			anniversaryTreasureHuntCtrl:reqGetRewardMsg(taskType, index)
			SoraDShowLoading(self)
		end
	end
end
return treasureHuntRewardView
