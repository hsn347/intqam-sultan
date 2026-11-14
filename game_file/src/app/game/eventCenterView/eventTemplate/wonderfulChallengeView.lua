local greateChallengeRead = include("greateChallengeRead")
local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local greatChallengeCtrl = gametop.playertop_:getModule("greatChallengeCtrl")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local wonderfulChallengeView = class("wonderfulChallengeView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("wonderfulChallengeView")
	end
	return target
end)
_ENV, _UPVALUE8_ = function(target)
	if target == nil then
		return SoraDCreateBasePanel("wonderfulChallengeView")
	end
	return target
end, "wonderfulChallengeView"
_ENV, (function(target)
	if target == nil then
		return SoraDCreateBasePanel("wonderfulChallengeView")
	end
	return target
end).aid = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_1, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_1
_ENV, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_1.aid = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_2, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_2
_ENV, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_2.aid = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_3, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_3
_ENV, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_3.aid = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_4, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_4
_ENV, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_4.aid = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_5, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_5
_ENV, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_5.aid = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_6, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_6
_ENV, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_6.aid = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_7, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_7
gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_7.aid = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_8
;("wonderfulChallengeView")[1] = function(target)
	if target == nil then
		return SoraDCreateBasePanel("wonderfulChallengeView")
	end
	return target
end
;("wonderfulChallengeView")[2] = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_1
;("wonderfulChallengeView")[3] = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_2
;("wonderfulChallengeView")[4] = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_3
;("wonderfulChallengeView")[5] = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_4
;("wonderfulChallengeView")[6] = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_5
;("wonderfulChallengeView")[7] = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_6
local ("wonderfulChallengeView")[8], activityIDTable = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_7, "wonderfulChallengeView"
function wonderfulChallengeView:ctor()
	self:initControls()
	self:initDownScroll()
end
function wonderfulChallengeView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_rechargeGold")
	self.Image_bg:setFillType(1)
	self.nodeTitle:setTitle(i18n("Challenge_name_title"))
	self.curPanelCenter, _ENV, self.curRedPoint, _ENV, self.curText, _ENV, self.closeTbl, _ENV, self.openTbl, _ENV, self.sortTbl, _ENV, self.rewardTable, _ENV, self.initialState, _ENV, self.curFinishCount = self.nodeTitle.setTitle, self.nodeTitle.setTitle, self.nodeTitle.setTitle, self.nodeTitle.setTitle, self.nodeTitle.setTitle, self.nodeTitle.setTitle, self.nodeTitle.setTitle, self.nodeTitle.setTitle, self.nodeTitle.setTitle, self.nodeTitle.setTitle, self.nodeTitle.setTitle, self.nodeTitle.setTitle, self.nodeTitle.setTitle, self.nodeTitle.setTitle, self.nodeTitle.setTitle, self.nodeTitle.setTitle, 0
	self:getActivitiesState()
	self:divideRewards(self.initialID)
	self:refreshBtnAndText(self.initialID)
end
function wonderfulChallengeView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WONDERFUL_CHALLENGE_GET_REWARD_SUCCESS", handler(self, self.refreshPages))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function wonderfulChallengeView:beginTime()
	if self.timeHandler then
		self:endTime()
	end
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function wonderfulChallengeView:updateTime()
	if self.queue then
		_ENV = nil
		;(nil).time = SoraDConvertSecondToString(self.queue.timerNode.timer:getRemainTime())
		self.text_time:setString(i18n("common_text_607", nil))
	else
		self.queue = activityShowCtrl:getTimeInfoByID(self.initialID)
		if self.queue then
			_ENV = i18n("common_text_607", nil)
			i18n("common_text_607", nil).time = SoraDConvertSecondToString(self.queue.timerNode.timer:getRemainTime())
			self.text_time:setString(i18n("common_text_607", i18n("common_text_607", nil)))
		end
	end
end
function wonderfulChallengeView:sortButtons(activityId, state)
	local Aqueue = activityShowCtrl:getTimeInfoByID(activityId)
	local time = 0
	print("wlejrlkwekjrlkew", activityId, state)
	if Aqueue then
		time = Aqueue.timerNode.timer:getRemainTime()
	end
	if state == gActivityState.OPEN then
		activityShowCtrl = activityId
		activityId.aid = activityId
		activityId.leftTime = time
		table.insert(self.openTbl, activityId)
	elseif state == gActivityState.PREPARE then
		activityShowCtrl = activityId
		activityId.aid = activityId
		activityId.leftTime = time
		table.insert(self.closeTbl, activityId)
	end
	table.sort(self.openTbl, function(l, r)
		return l.leftTime < r.leftTime
	end)
end
function wonderfulChallengeView:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
	self.queue = nil
end
function wonderfulChallengeView:divideRewards(activityId)
	self.rewardTable = greatChallengeCtrl:getChallengeDataByActivityID(activityId)
	self.curFinishCount = greatChallengeCtrl:getCurFinishCount(activityId)
	self:beginTime()
	self:updateTime()
	self.text_count:setString(i18n(greateChallengeRead.getActivityContent(activityId)) .. " " .. self.curFinishCount)
end
function wonderfulChallengeView:getActivitiesState()
	local initNum = 0
	for i, v in ipairs(activityIDTable) do
		self.initialState[v.aid] = activityShowCtrl:getStateByID(v.aid)
		if self.initialState[v.aid] == gActivityState.OPEN or self.initialState[v.aid] == gActivityState.PREPARE then
			initNum = initNum + 1
		end
		self:sortButtons(v.aid, self.initialState[v.aid])
	end
	for i, v in ipairs(self.openTbl) do
		table.insert(self.sortTbl, v)
	end
	for i, v in ipairs(self.closeTbl) do
		table.insert(self.sortTbl, v)
	end
	self.initialID = self.sortTbl[1].aid
	self:initTopScroll(initNum)
end
function wonderfulChallengeView:initTopScroll(totalNum)
	local scrollH = math.max(totalNum * 185, self.Top_ScrollView_choose:getContentSize().width)
	self.Top_ScrollView_choose:setInnerContainerSize(cc.size(scrollH, self.Top_ScrollView_choose:getContentSize().height))
	self.Top_ScrollView_choose:setBounceEnabled(3 < totalNum)
	for i = 1, #self.sortTbl do
		local cell = self.panel_button:clone()
		cell:addTo(self.Panel_long)
		cell:setPosition(cc.p(185 * (i - 1), self.Panel_long:getContentSize().height / 2))
		local buttonActivity = SoraDGetChildByName(cell, "btn_activity")
		local text = SoraDGetChildByName(cell, "text_btnName")
		local image = SoraDGetChildByName(cell, "Image_5")
		local redPoint = SoraDGetChildByName(cell, "Image_redPoint")
		local rNum = SoraDGetChildByName(redPoint, "Text_num")
		local isOpen, redNum = greatChallengeCtrl:getReceiveStatusAndNum2(self.sortTbl[i].aid)
		redPoint:setVisible(0 < redNum)
		rNum:setString(redNum)
		table.insert(self.curRedPoint, redPoint)
		text:setTag(self.sortTbl[i].aid)
		text:setString(i18n(greateChallengeRead.getActivityName(self.sortTbl[i].aid)))
		buttonActivity:setTag(self.sortTbl[i].aid)
		table.insert(self.curText, text)
		if i == 1 then
			text:setColor(cc.c3b(250, 210, 40))
		end
		if self.initialState[self.sortTbl[i].aid] == gActivityState.OPEN then
			buttonActivity:loadTextureNormal(greateChallengeRead.getactivityButtonImg(self.sortTbl[i].aid), ccui.TextureResType.plistType)
			buttonActivity:loadTexturePressed(greateChallengeRead.getactivityButtonImg(self.sortTbl[i].aid), ccui.TextureResType.plistType)
			buttonActivity:setContentSize(cc.size(150, 147))
			buttonActivity:setEnabled(true)
			image:setVisible(true)
			text:setVisible(true)
		elseif self.initialState[self.sortTbl[i].aid] == gActivityState.PREPARE then
			buttonActivity:loadTextureNormal("icon_challenge_wh.png", ccui.TextureResType.plistType)
			buttonActivity:loadTexturePressed("icon_challenge_wh.png", ccui.TextureResType.plistType)
			buttonActivity:setContentSize(cc.size(89, 120))
			buttonActivity:setEnabled(false)
			image:setVisible(false)
			text:setVisible(false)
		else
			cell:setVisible(false)
		end
		buttonActivity:addTouchEventListener(handler(self, self.ActivityClickCallBack))
		if i < 5 then
			local sprite = self.frame_czh_zs_1:clone()
			sprite:addTo(self.Panel_long, 2)
			sprite:setPosition(cc.p(cell:getPositionX() + cell:getContentSize().width / 2 + sprite:getContentSize().width / 2 + 12, self.Top_ScrollView_choose:getContentSize().height))
		end
	end
	if totalNum <= 3 then
		for i = 1, 4 - totalNum do
			local bg = self.panel_button:clone()
			local buttonActivity = SoraDGetChildByName(bg, "btn_activity")
			local text = SoraDGetChildByName(bg, "text_btnName")
			local image = SoraDGetChildByName(bg, "Image_5")
			local redPoint = SoraDGetChildByName(bg, "Image_redPoint")
			local rNum = SoraDGetChildByName(redPoint, "Text_num")
			bg:addTo(self.Panel_long)
			bg:setPosition(cc.p(185 * (i + totalNum - 1), self.Top_ScrollView_choose:getContentSize().height / 2))
			text:setVisible(false)
			image:setVisible(false)
			redPoint:setVisible(false)
			rNum:setVisible(false)
			buttonActivity:setVisible(false)
			local sp = self.frame_czh_zs_1:clone()
			sp:addTo(self.Panel_long, 2)
			sp:setPosition(cc.p(bg:getPositionX() + bg:getContentSize().width / 2 + bg:getContentSize().width / 2 - 35, self.Top_ScrollView_choose:getContentSize().height))
		end
	end
end
function wonderfulChallengeView:initDownScroll()
	self.Top_Size_ScrollView_content:removeAllChildren()
	self.curPanelCenter, _ENV = self.Top_Size_ScrollView_content.removeAllChildren, self.Top_Size_ScrollView_content.removeAllChildren
	local scrollH = math.max(#self.rewardTable * 170, self.Top_Size_ScrollView_content:getContentSize().height)
	self.Top_Size_ScrollView_content:setInnerContainerSize(cc.size(display.width, scrollH))
	for i = 1, #self.rewardTable do
		local cell = self.Panel_center:clone()
		cell:addTo(self.Top_Size_ScrollView_content)
		cell:setPosition(cc.p(display.width / 2, scrollH - 170 * (i - 1)))
		local textGet = SoraDGetChildByName(cell, "text_get")
		local btnGet = SoraDGetChildByName(cell, "btn_get")
		local textGold = SoraDGetChildByName(cell, "text_gold")
		local text_own = SoraDGetChildByName(cell, "text_own")
		local text_plan = SoraDGetChildByName(cell, "text_plan")
		local Image_8 = SoraDGetChildByName(cell, "Image_8")
		local Image_9 = SoraDGetChildByName(cell, "Image_9")
		textGet:setString(i18n(greateChallengeRead.getActivityDes(self.initialID)))
		text_own:setString(self.curFinishCount)
		table.insert(self.curPanelCenter, cell)
		if SoraDFIsRA() then
			textGold:setString(i18n("common_text_3780"))
			text_plan:setString("/" .. self.rewardTable[i].amount)
			text_plan:setPositionX(textGold:getPositionX() - textGold:getContentSize().width - 5)
			text_own:setPositionX(text_plan:getPositionX() - text_plan:getContentSize().width)
		else
			text_plan:setString("/" .. self.rewardTable[i].amount)
			textGold:setString(i18n("common_text_3780"))
			text_own:setPositionX(textGold:getPositionX() + textGold:getContentSize().width + 5)
			text_plan:setPositionX(text_own:getPositionX() + text_own:getContentSize().width)
		end
		if self.curFinishCount < self.rewardTable[i].amount then
			text_own:setColor(cc.c3b(255, 0, 0))
		else
			text_own:setColor(cc.c3b(240, 230, 210))
		end
		btnGet:setEnabled(not self.rewardTable[i].receive)
		btnGet:setBright(not self.rewardTable[i].receive)
		btnGet:setTag(i)
		btnGet:addTouchEventListener(handler(self, self.getRewardClickCallBack))
		if self.rewardTable[i].receive then
			btnGet:setTitleText(i18n("common_text_1892"))
		elseif self.curFinishCount < self.rewardTable[i].amount then
			btnGet:setTitleText(i18n("common_text_477"))
		else
			btnGet:setTitleText(i18n("common_text_1146"))
		end
		Image_8:setVisible(i == #self.rewardTable)
		Image_9:setVisible(i == #self.rewardTable)
		for j = 1, #self.rewardTable[i].reward do
			local singleItem = include("itemSingleView").new()
			singleItem:setRechargeUse(true)
			singleItem:setButtonTag(self.rewardTable[i].reward[j].itemID)
			singleItem:setScroll(self.scroll)
			singleItem:sendParentToButton(self)
			singleItem:setScale(0.5)
			singleItem:setTag(j)
			singleItem:addTo(cell)
			if SoraDFIsRA() then
				singleItem:setPosition(cc.p(525 - (j - 1) * 85, 100))
			else
				singleItem:setPosition(cc.p(25 + (j - 1) * 85, 100))
			end
			singleItem:initRechargeForRewardData(self.rewardTable[i].reward[j].itemID, self.rewardTable[i].reward[j].num)
		end
	end
	local _ENV, sortList = (for index), 1
	for i = 1, #self.curPanelCenter do
		local reTag = self.rewardTable[i].receive and 1 or 0
		_ENV = SoraDGetChildByName(cell, "text_own")
		SoraDGetChildByName(cell, "text_own").idx = i
		SoraDGetChildByName(cell, "text_own").isReceive = reTag
		table.insert(sortList, (SoraDGetChildByName(cell, "text_own")))
	end
	table.sort(sortList, function(l, r)
		if l.isReceive == r.isReceive then
			return l.idx < r.idx
		else
			return l.isReceive < r.isReceive
		end
	end)
	local scrollH = math.max(#self.rewardTable * 170, self.Top_Size_ScrollView_content:getContentSize().height)
	for i, v in ipairs(sortList) do
		self.curPanelCenter[v.idx]:setPosition(cc.p(display.width / 2, scrollH - 170 * (i - 1)))
	end
end
function wonderfulChallengeView:ActivityClickCallBack(button, type)
	local tag = button:getTag()
	self.rewardTable, _ENV = button, button
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.initialID = tag
		self:divideRewards(tag)
		self:initDownScroll()
		self:refreshBtnAndText(tag)
	end
end
function wonderfulChallengeView:refreshBtnAndText(tag)
	for k, v in pairs(self.curText) do
		if tag == v:getTag() then
			v:setColor(cc.c3b(250, 210, 40))
		else
			v:setColor(cc.c3b(215, 195, 155))
		end
	end
	for i, v in ipairs(self.curRedPoint) do
		local isOpen, redNum = greatChallengeCtrl:getReceiveStatusAndNum2(self.sortTbl[i].aid)
		local rNum = SoraDGetChildByName(v, "Text_num")
		v:setVisible(0 < redNum)
		rNum:setString(redNum)
	end
end
function wonderfulChallengeView:getRewardClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.rewardTable = greatChallengeCtrl:getChallengeDataByActivityID(self.initialID)
		if self.curFinishCount < self.rewardTable[button:getTag()].amount then
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			if self.initialID == gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_1 then
				_ENV = nil
				mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.MAKE_A_WISH, nil)
			elseif self.initialID == gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_2 then
				mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.ESCORT)
			elseif self.initialID == gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_3 then
				_ENV = nil
				;(nil).lv = 1
				mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.KILL_MONSTER, nil)
			elseif self.initialID == gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_4 then
				mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.MYSTICAL_STORE)
			elseif self.initialID == gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_5 then
				mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.ALLIANCE_DONATE)
			elseif self.initialID == gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_6 then
				mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.ADD_FRIENDS)
			elseif self.initialID == gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_7 then
				if heroCtrl:getMaxBattleHeroNum() <= 0 then
					SoraDShowMsgTip(i18n("tip_text_01"))
				else
					uiManager:show("newHeroListView")
				end
			elseif self.initialID == gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_8 then
				if SoraDGetCastleLv() < CASTLE_LV16_LIMITED then
					SoraDShowMsgTip(i18n("tip_text_02"))
				else
					_ENV = i18n("tip_text_02")
					i18n("tip_text_02").index = 1
					uiManager:show("ArtifactView", i18n("tip_text_02"))
				end
			end
			if self.initialID ~= gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_7 and self.initialID ~= gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_8 then
				SoraDRemoveAllPanelFromManager()
			else
				self:removeFromParent()
			end
		else
			greatChallengeCtrl:sendReceiveReward(self.initialID, button:getTag())
		end
	end
end
function wonderfulChallengeView:refreshPages()
	self.rewardTable, _UPVALUE0_ = nil, nil
	self:divideRewards(self.initialID)
	self:initDownScroll()
	self:refreshBtnAndText(self.initialID)
end
function wonderfulChallengeView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityCenterUIEnum.GREAT_CHALLENGE) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return wonderfulChallengeView
