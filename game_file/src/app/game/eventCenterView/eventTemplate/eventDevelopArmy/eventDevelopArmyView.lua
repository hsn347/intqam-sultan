local gametop = gModuleMgr.getObject("gametop")
local newActivityCtrl = gametop.playertop_:getModule("newActivityCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local eventDevelopArmyView = class("eventDevelopArmyView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventDevelopArmyView")
	end
	return target
end)
function eventDevelopArmyView:ctor()
	self.dir = 1
	if SoraDFIsRA() then
		self.dir = -1
	end
	self.tabRewardData, _ENV, self.dataInfo = SoraDFIsRA(), SoraDFIsRA(), nil
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_eventPerson")
	self.ccs_title:setTitle(i18n("common_text_2645"))
	self.Image_eventBg = SoraDGetChildByName(self, "Image_eventBg")
	self.Image_eventBg:loadTexture(SoraDCheckPNG("bg_Development_army.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	self.node_time = SoraDGetChildByName(self, "Node_time")
	self.node_time:setVisible(false)
	self.text_leftTime = SoraDGetChildByName(self.node_time, "Text_leftTime")
	self.text_leftTime:setString(i18n("common_text_943"))
	self.text_time = SoraDGetChildByName(self.node_time, "Text_time")
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.btn_help = SoraDGetChildByName(self, "Button_help")
	self.btn_help:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	self.text_des = SoraDGetChildByName(self, "Text_des")
	self.text_des:setString(i18n("common_text_2727"))
	self.text_reward = SoraDGetChildByName(self, "Text_reward")
	self.text_reward:setString(i18n("common_text_2646"))
	self.loadingBar = SoraDGetChildByName(self, "LoadingBar")
	self.sprite_bar = SoraDGetChildByName(self, "point_progressbar")
	self.btn_look = SoraDGetChildByName(self, "Button_look")
	self.btn_look:setTitleText(i18n("common_text_1776"))
	self.btn_look:addTouchEventListener(handler(self, self.btnLookClickCallBack))
	self.text_rank = SoraDGetChildByName(self, "Text_rank")
	self.text_myPoint = SoraDGetChildByName(self, "Text_myPoint")
	self.icon_soldier = SoraDGetChildByName(self, "icon_soldier")
	self.text_getPoint = SoraDGetChildByName(self, "Text_toGetPoint")
	self.text_getPoint:setString(i18n("common_text_2647"))
	self.scroll = SoraDGetChildByName(self, "Bottom_Size_ScrollView")
	SoraDGetChildByName(self, "Size_Tile_bg"):setFillType(1)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_DEVELOP_ARMY_REFRESH", handler(self, self.initData))
	newActivityCtrl:sendGetDevelopArmamentInfo()
	self:initScroll()
end
function eventDevelopArmyView:initData(target, data)
	self.dataInfo = newActivityCtrl:getDevelopArmamentInfo()
	local activityTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.DEVELOP_ARMAMENT_ACTIVITY)
	if activityTime then
		self.node_time:setVisible(true)
		self.text_time:beginTime(activityTime.timerNode.timer:getRemainTime())
		SoraDToCenter(self.node_time)
	end
	local rank = self.dataInfo.rank < 1 and "5000+" or self.dataInfo.rank
	self.text_rank:setString(i18n("common_text_851") .. ":" .. rank)
	local score = self.dataInfo.score
	newActivityCtrl = activityTime.timerNode.timer:getRemainTime()
	activityTime.timerNode.timer:getRemainTime().point = string.formatnumberthousands(score)
	self.text_myPoint:setString(i18n("common_text_2706", activityTime.timerNode.timer:getRemainTime()))
	self.icon_soldier:setPositionX(self.text_myPoint:getPositionX() + (self.text_myPoint:getContentSize().width + 20) * self.dir)
	self:initPoints()
end
function eventDevelopArmyView:initPoints()
	local newActivityCtrl, boxes
	local newActivityCtrl, graduations
	local newActivityCtrl, text_point
	local data = newActivityCtrl:getDevelopArmyReward()
	local stage = newActivityCtrl:getDevelopArmamentStage()
	for k, v in pairs(data) do
		self.tabRewardData[v.stage] = v
	end
	local posX = 480 / #self.tabRewardData
	for i = 1, #self.tabRewardData do
		boxes[i] = SoraDGetExtendChildFromCCSByName(self, "CCS_eventPersonRewardBox_" .. i)
		boxes[i]:setVisible(false)
		if boxes[i] then
			boxes[i]:setScale(0.7)
			boxes[i]:setVisible(true)
			boxes[i]:setBoxStatus(i > stage)
			boxes[i]:setTag(i)
			boxes[i]:setBoxHandler(handler(self, self.showBoxReward))
			if #self.tabRewardData == 3 then
				boxes[i]:setPositionX(-SoraDFSign((i - 2) * posX))
			else
				boxes[i]:setPositionX(-SoraDFSign((i - 3) * posX))
			end
			text_point[i] = SoraDGetChildByName(self, "Text_point_" .. i)
			SoraDSetTextWidthHeight(text_point[i], cc.size(80, 60))
			text_point[i]:setString(string.formatnumberthousands(self.tabRewardData[i].needscore))
			text_point[i]:setPositionX(-SoraDFSign(posX * i))
		end
		graduations[i] = SoraDGetChildByName(self, "progressbar_cumu_recharge_line_" .. i)
		if graduations[i] then
			graduations[i]:setPositionX(-SoraDFSign(posX * i))
		end
	end
	local percent = 0
	local perStage = 1 / #self.tabRewardData
	if 0 <= self.dataInfo.score and self.dataInfo.score <= self.tabRewardData[1].needscore then
		percent = 100 * (self.dataInfo.score / self.tabRewardData[1].needscore) * perStage
	elseif self.dataInfo.score > self.tabRewardData[1].needscore and self.dataInfo.score <= self.tabRewardData[2].needscore then
		local dt_score_1 = self.dataInfo.score - self.tabRewardData[1].needscore
		local dt_score_2 = self.tabRewardData[2].needscore - self.tabRewardData[1].needscore
		percent = 100 * (perStage + perStage * dt_score_1 / dt_score_2)
	elseif self.dataInfo.score > self.tabRewardData[2].needscore and self.dataInfo.score <= self.tabRewardData[3].needscore then
		local dt_score_1 = self.dataInfo.score - self.tabRewardData[2].needscore
		local dt_score_2 = self.tabRewardData[3].needscore - self.tabRewardData[2].needscore
		percent = 100 * (perStage * 2 + perStage * dt_score_1 / dt_score_2)
	elseif self.tabRewardData[4] and self.dataInfo.score > self.tabRewardData[3].needscore and self.dataInfo.score <= self.tabRewardData[4].needscore then
		local dt_score_1 = self.dataInfo.score - self.tabRewardData[3].needscore
		local dt_score_2 = self.tabRewardData[4].needscore - self.tabRewardData[3].needscore
		percent = 100 * (perStage * 3 + perStage * dt_score_1 / dt_score_2)
	elseif self.tabRewardData[4] and self.dataInfo.score > self.tabRewardData[4].needscore and self.dataInfo.score <= self.tabRewardData[5].needscore then
		local dt_score_1 = self.dataInfo.score - self.tabRewardData[4].needscore
		local dt_score_2 = self.tabRewardData[5].needscore - self.tabRewardData[4].needscore
		percent = 100 * (perStage * 4 + perStage * dt_score_1 / dt_score_2)
	elseif self.dataInfo.score >= self.tabRewardData[#self.tabRewardData].needscore then
		percent = 100
	end
	self.loadingBar:setPercent(percent)
	self.sprite_bar:setPositionX(self.dir * self.loadingBar:getContentSize().width * (percent / 100))
end
function eventDevelopArmyView:initScroll()
	local cofig = newActivityCtrl:getDevelopArmyConfig()
	local scrollH = math.max(self.scroll:getContentSize().height, 50 * #cofig)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	for i = 1, #cofig do
		local single = include("eventPersonPointSingle").new()
		single:setAnchorPoint(cc.p(0, 0))
		single:setPosition(cc.p(0, scrollH - 50 * i))
		single:initData(cofig[i])
		single:addTo(self.scroll)
	end
end
function eventDevelopArmyView:btnHelpClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("common_text_2727"))
	end
end
function eventDevelopArmyView:btnLookClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("eventDevelopArmyHeroRank"):show()
	end
end
function eventDevelopArmyView:showBoxReward(target)
	SoraDPlaySound()
	local panel = SoraDCreatePanel("eventPersonStageReward")
	panel:initData(self.tabRewardData[target:getTag()], gActivityTimeActivityID.DEVELOP_ARMAMENT_ACTIVITY)
	panel:show()
end
function eventDevelopArmyView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.DEVELOP_ARMAMENT_ACTIVITY) then
		self:removeFromParent()
	end
end
return eventDevelopArmyView
