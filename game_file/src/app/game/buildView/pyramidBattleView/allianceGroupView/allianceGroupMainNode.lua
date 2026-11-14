local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local pyramidClientModule = include("pyramidClientModule")
local rankingsCtrl = gametop.playertop_:getModule("rankingsCtrl")
local pyramidWarltCtrl = include("pyramidWarltCtrl")
local allianceDesRead = include("allianceDesRead")
local AllianceGroupMainNode = class("allianceGroupMainNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceGroupMainNode")
	end
	return target
end)
function AllianceGroupMainNode:ctor()
	self.nodeBg = SoraDGetChildByName(self, "Node_bg")
	self.imgBlackBg = SoraDGetChildByName(self, "Image_blackBg")
	self.imgBlackBottom = SoraDGetChildByName(self, "Iamge_blackBottom")
	self.spriteBg = SoraDGetChildByName(self, "Sprite_bg")
	self.nodeCreateGroup = SoraDGetChildByName(self, "Node_createGroup")
	self.btnCreateGroup = SoraDGetChildByName(self, "Button_createGroup")
	self.labelCreate1 = SoraDGetChildByName(self, "Text_create_1")
	self.labelCreate2 = SoraDGetChildByName(self, "Text_create_2")
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.nodeTimeCooling = SoraDGetChildByName(self, "Node_timeCooling")
	self.frameLegendaryKingCountdown12 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12")
	self.frameLegendaryKingCountdown13 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_13")
	self.frameLegendaryKingCountdown14 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_14")
	self.frameLegendaryKingCountdown15 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_15")
	self.frameLegendaryKingCountdown16 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_16")
	self.frameLegendaryKingCountdown17 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_17")
	self.frameLegendaryKingCountdown18 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_18")
	self.labelTime1 = SoraDGetChildByName(self, "Text_time_1")
	self.labelTime2 = SoraDGetChildByName(self, "Text_time_2")
	self.labelApply = SoraDGetChildByName(self, "Text_apply")
	self.btnApply = SoraDGetChildByName(self, "Button_apply")
	self.nodeEnter = SoraDGetChildByName(self, "Node_enter")
	self.btnEnter = SoraDGetChildByName(self, "Button_enter")
	self.labelOther = SoraDGetChildByName(self, "Text_other")
	self.labelOtherName = SoraDGetChildByName(self, "Text_otherName")
	self.labelOtherMember = SoraDGetChildByName(self, "Text_otherMember")
	self.labelGroupInfo = SoraDGetChildByName(self, "Text_groupInfo")
	self.nodeAllianceFlag = SoraDGetChildByName(self, "Node_otherFlag")
	self.nodePowerRank = SoraDGetChildByName(self, "Node_powerRank")
	self.labelPowerRank = SoraDGetChildByName(self, "Text_powerRank")
	self.labelTime3 = SoraDGetChildByName(self, "Text_time_3")
	self.labelTime4 = SoraDGetChildByName(self, "Text_time_4")
	self.labelMember = SoraDGetChildByName(self, "Text_member")
	self.labelEmpty = SoraDGetChildByName(self, "Text_empty")
	self.btnCreateGroup:setTitleText(i18n("pyramid_btn_02"))
	self.labelCreate1:setString(i18n("pyramid_text_09"))
	self.labelCreate2:setString(i18n("pyramid_text_10"))
	self.btnApply:setTitleText(i18n("common_text_3315"))
	self.labelOther:setString(i18n("common_text_3319"))
	self.btnEnter:setTitleText(i18n("common_text_3318"))
	SoraDChangeTextToHtml(self.labelGroupInfo)
	_ENV, _ENV, _ENV = i18n("common_text_3318")
	i18n("common_text_3318").__default, i18n("common_text_3318").u = i18n("common_text_3318")
	self.labelGroupInfo:setString(i18n_html("pyramid_btn_04", i18n("common_text_3318")))
	self.labelGroupInfo:setTouchEnabled(true)
	self.labelGroupInfo:addTouchEventListener(handler(self, self.btnClickText))
	self.labelPBLInfo = SoraDGetChildByName(self, "Text_pblinfo")
	SoraDChangeTextToHtml(self.labelPBLInfo)
	_ENV, _ENV, _ENV = handler(self, self.btnClickText)
	handler(self, self.btnClickText).__default, handler(self, self.btnClickText).u = handler(self, self.btnClickText)
	self.labelPBLInfo:setString(i18n_html("common_text_1720", handler(self, self.btnClickText)))
	self.labelPBLInfo:setTouchEnabled(true)
	self.labelPBLInfo:addTouchEventListener(handler(self, self.btnPBLInfoClickText))
	_UPVALUE6_ = self.labelPBLInfo.addTouchEventListener
	self.timePadding, self.labelPBLInfo.addTouchEventListener[1] = self.labelPBLInfo.addTouchEventListener, 56
	self.timePadding, self.labelPBLInfo.addTouchEventListener[2] = self.labelPBLInfo.addTouchEventListener, 56
	self.timePadding, self.labelPBLInfo.addTouchEventListener[3] = self.labelPBLInfo.addTouchEventListener, 90
	self.timePadding, self.labelPBLInfo.addTouchEventListener[4] = self.labelPBLInfo.addTouchEventListener, 45
	self.timePadding, self.labelPBLInfo.addTouchEventListener[5] = self.labelPBLInfo.addTouchEventListener, 86
	self.timePadding, self.labelPBLInfo.addTouchEventListener[6] = self.labelPBLInfo.addTouchEventListener, 50
	self.activity_time = self:createTimeNode(7, 259200, self.timePadding)
	self.activity_time:addTo(self.nodeTimeCooling)
	self.activity_time:setPosition(cc.p(-345, 0))
	self.activity_time:setLocalZOrder(10)
	self.btnApply:addTouchEventListener(handler(self, self.btnApplyClick))
	self.btnCreateGroup:addTouchEventListener(handler(self, self.btnCreateGroupClick))
	self.btnEnter:addTouchEventListener(handler(self, self.btnEnterClick))
	self:initData()
	SoraDTestButton(self, function(...)
		self:initView()
	end)
end
function AllianceGroupMainNode:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_MAINSTATECHANGE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_GROUP_UPDATE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_RANKINGS_SUCCESS", handler(self, self.updateRank))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_OPPOINFOBACK", handler(self, self.initInWar))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_ENTERBATTLEFAIL", handler(self, self.closeLoading))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_CREATE_SUCCESS", handler(self, self.initGroupCreate))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SCIENCE_POINT_UPDATE", handler(self, self.initGroupCreate))
end
function AllianceGroupMainNode:closeLoading(target, redata)
	SoraDCloseLoading(self)
end
function AllianceGroupMainNode:updateRank(target, data)
	if pyramidWarCtrl:getOwnLegion() then
		if data.rank and data.rank.data and data.rank.league then
			if data.rank.league > 0 then
				pyramidWarCtrl = nil
				;(nil).num = data.rank.league
				self.labelPowerRank:setString(i18n("pyramid_text_13", nil))
			else
				pyramidWarCtrl = i18n("pyramid_text_13", nil)
				i18n("pyramid_text_13", nil).num = i18n("rides_btn_01")
				self.labelPowerRank:setString(i18n("pyramid_text_13", i18n("pyramid_text_13", nil)))
			end
		end
	else
		self.labelPowerRank:setString(i18n("pyramid_text_12"))
	end
	SoraDToCenter(self.nodePowerRank, 10)
end
function AllianceGroupMainNode:initData(...)
	self:initView()
end
function AllianceGroupMainNode:initView(...)
	self:hiddleAll()
	self.groupType = gRegularSeasonAllianceState.NOT_APPLY
	self.seasonState = pyramidWarCtrl.regularSeasonState
	self.legionList = pyramidWarCtrl:getLegionInfoList()
	self.ownlegion = pyramidWarCtrl:getOwnLegion()
	if self.ownlegion then
		self.groupType = self.ownlegion.regularSeasonAllianceState
	end
	if not allianceMgr:hasJoinAlliance() or self.legionList == nil or #self.legionList == 0 then
		self:initGroupCreate()
	elseif self.groupType == gRegularSeasonAllianceState.NOT_APPLY or self.groupType == gRegularSeasonAllianceState.FINISH then
		print("未报名")
		if self.seasonState == gRegularSeasonState.WAIT_APPLY_NEXT then
			print("等待下一轮报名")
			self:initWaitApply()
		elseif self.seasonState == gRegularSeasonState.APPLY_ING then
			print("开始报名")
			self:initStarApply()
		end
	elseif self.groupType == gRegularSeasonAllianceState.APPLY_ED then
		print("已报名")
		self:initStarApply()
	elseif self.groupType == gRegularSeasonAllianceState.NOT_MATCH then
		self:initWaitApply()
	elseif self.groupType == gRegularSeasonAllianceState.PREPARE then
		print("准备，等待本联盟战场开始")
		self:initInWar()
	elseif self.groupType == gRegularSeasonAllianceState.RUNNING then
		print("进行中，等待本联盟战场结束")
		self:initInWar()
	end
end
function AllianceGroupMainNode:openTimeUp()
	if self.nodeTime:isVisible() then
		local nowTimeLeft = pyramidWarCtrl:getLeftTime(self.seasonState)
		if nowTimeLeft then
			self.activity_time:setTime(nowTimeLeft)
		end
	end
	if self.labelPBLInfo:isVisible() then
		self.activity_time:setTime(pyramidWarCtrl:getLeftTime(gPinnacleSeasonState.WAIT_OPEN))
	elseif self.labelTime4:isVisible() and self.ownlegion then
		local data = self.ownlegion.queue[tostring(self.groupType)]
		local leftTime = 0
		if data then
			leftTime = data.starttime + data.totaltime - serviceFunctions.systemTime()
		end
		if self.groupType == gRegularSeasonAllianceState.PREPARE then
			pyramidWarCtrl = pyramidWarCtrl:getLeftTime(gPinnacleSeasonState.WAIT_OPEN)
			pyramidWarCtrl:getLeftTime(gPinnacleSeasonState.WAIT_OPEN).time = SoraDConvertSecondToString(leftTime)
			self.labelTime4:setString(i18n("common_text_3308", pyramidWarCtrl:getLeftTime(gPinnacleSeasonState.WAIT_OPEN)))
		elseif self.groupType == gRegularSeasonAllianceState.RUNNING then
			pyramidWarCtrl = i18n("common_text_3308", pyramidWarCtrl:getLeftTime(gPinnacleSeasonState.WAIT_OPEN))
			i18n("common_text_3308", pyramidWarCtrl:getLeftTime(gPinnacleSeasonState.WAIT_OPEN)).time = SoraDConvertSecondToString(leftTime)
			self.labelTime4:setString(i18n("common_text_3309", i18n("common_text_3308", pyramidWarCtrl:getLeftTime(gPinnacleSeasonState.WAIT_OPEN))))
		end
	elseif self.ownlegion and self.groupType == gRegularSeasonAllianceState.APPLY_ED and self.seasonState == gRegularSeasonState.WAIT_APPLY_NEXT then
		local data = self.ownlegion.queue[tostring(self.groupType)]
		local leftTime = 0
		if data then
			leftTime = data.starttime + data.totaltime - serviceFunctions.systemTime()
			self.activity_time:setTime(leftTime)
		end
	end
end
function AllianceGroupMainNode:initGroupCreate()
	if not allianceMgr:hasJoinAlliance() or self.legionList == nil or #self.legionList == 0 then
		self.nodeCreateGroup:setVisible(true)
		local canTouch = allianceMgr:hasJoinAlliance() and pyramidWarCtrl:getGroupManagerRank() >= 2 and pyramidWarCtrl:checkLeftLegionNum()
		self.btnCreateGroup:setTouchEnabled(canTouch)
		self.btnCreateGroup:setBright(canTouch)
	end
end
function AllianceGroupMainNode:initWaitApply()
	self.nodeBg:setVisible(true)
	self.nodeTime:setVisible(true)
	self.nodePowerRank:setVisible(true)
	self.labelTime2:setVisible(true)
	if self.ownlegion then
		self.labelMember:setVisible(true)
		_ENV = nil
		;(nil).cur = table.nums(self.ownlegion.memberList)
		;(nil).max = ALLIANCE_GROUP_MEMBER_MAX
		self.labelMember:setString(i18n("common_text_3408", nil))
	end
	self.labelApply:setVisible(false)
	self.btnApply:setVisible(false)
	self.labelTime1:setString(i18n("pyramid_text_103"))
	self.labelTime2:setString(i18n("pyramid_text_11"))
	if self.groupType == gRegularSeasonAllianceState.NOT_MATCH then
		self.labelEmpty:setVisible(true)
		self.labelEmpty:setString(i18n("common_text_3320"))
	end
	rankingsCtrl:getRankings(lordRankingsDef.allianceLegionPower)
	if pyramidWarCtrl.pinnacleSeasonState == gPinnacleSeasonState.WAIT_OPEN then
		local nowTimeLeft = pyramidWarCtrl:getLeftTime(pyramidWarCtrl.pinnacleSeasonState)
		if nowTimeLeft and 0 < nowTimeLeft and nowTimeLeft <= 604800 then
			_ENV = i18n("common_text_3320")
			i18n("common_text_3320").num = pyramidWarCtrl.peakSeasonNo
			self.labelTime2:setString(i18n("pyramid_text_16", i18n("common_text_3320")))
			self.labelPBLInfo:setVisible(true)
		end
	end
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
end
function AllianceGroupMainNode:initStarApply()
	self.nodeBg:setVisible(true)
	self.nodeTime:setVisible(true)
	self.labelTime3:setVisible(true)
	if self.ownlegion then
		self.labelMember:setVisible(true)
		_ENV = nil
		;(nil).cur = table.nums(self.ownlegion.memberList)
		;(nil).max = ALLIANCE_GROUP_MEMBER_MAX
		self.labelMember:setString(i18n("common_text_3408", nil))
	end
	self.labelApply:setVisible(false)
	self.btnApply:setVisible(true)
	self.labelTime1:setString(i18n("pyramid_text_106"))
	self.labelTime3:setString(i18n("pyramid_text_14"))
	if self.groupType == gRegularSeasonAllianceState.APPLY_ED then
		self.labelApply:setVisible(true)
		local showTime = pyramidWarltCtrl.getWeedTimeStr(self.ownlegion.number, self.seasonState ~= gRegularSeasonState.WAIT_APPLY_NEXT)
		self.labelApply:setString(i18n("pyramid_text_15") .. " " .. showTime)
		if self.seasonState == gRegularSeasonState.WAIT_APPLY_NEXT then
			self.labelTime1:setString(i18n("pyramid_text_105"))
			self.btnApply:setVisible(false)
		elseif pyramidWarCtrl:getGroupManagerRank() <= 0 then
			self.btnApply:setVisible(false)
		end
	end
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
end
function AllianceGroupMainNode:changeBg(isEnter)
	local offsetY = 0
	if isEnter then
		offsetY = 190
	end
	self.nodeBg:setPositionY(0 + offsetY)
	self.imgBlackBottom:setPositionY(-160 - offsetY)
	self.imgBlackBg:setContentSize(cc.size(800, 280 + offsetY))
end
function AllianceGroupMainNode:initInWar(target, data)
	self:changeBg(true)
	if data and data.info then
		self.groupType = gRegularSeasonAllianceState.NOT_APPLY
		self.seasonState = pyramidWarCtrl.regularSeasonState
		self.legionList = pyramidWarCtrl:getLegionInfoList()
		self.ownlegion = pyramidWarCtrl:getOwnLegion()
		if self.ownlegion then
			self.groupType = self.ownlegion.regularSeasonAllianceState
		end
		if self.groupType ~= gRegularSeasonAllianceState.RUNNING and self.groupType ~= gRegularSeasonAllianceState.PREPARE then
			self:initData()
			return
		end
		if self.ownlegion == nil then
			self:initData()
			return
		end
		local otherData = data.info[tostring(self.ownlegion.legionId)]
		if otherData == nil then
			self:initData()
			return
		end
		self.nodeBg:setVisible(true)
		self.nodeEnter:setVisible(true)
		self.labelTime4:setVisible(true)
		self.labelMember:setVisible(true)
		if self.groupType == gRegularSeasonAllianceState.PREPARE then
			self.btnEnter:setVisible(false)
		else
			self.btnEnter:setVisible(true)
		end
		_ENV = true
		;(true).abbr = _q(otherData.abbr)
		;(true).name = otherData.legionName
		local name = i18n("common_text_186", true)
		self.nodeAllianceFlag:removeAllChildren()
		allianceDesRead.getFlagWithParticle(otherData.flag, self.nodeAllianceFlag)
		self.labelOtherName:setString(name .. " " .. "#" .. otherData.kid)
		_ENV = "#"
		;("#").cur = otherData.curmem
		;("#").max = otherData.totalmem
		self.labelOtherMember:setString(i18n("common_text_3408", "#"))
		_ENV = i18n("common_text_3408", "#")
		i18n("common_text_3408", "#").cur = table.nums(self.ownlegion.memberList)
		i18n("common_text_3408", "#").max = ALLIANCE_GROUP_MEMBER_MAX
		self.labelMember:setString(i18n("common_text_3408", i18n("common_text_3408", "#")))
	else
		pyramidWarCtrl:regularSeasonGetMatchAllianceInfoReq()
	end
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
end
function AllianceGroupMainNode:hiddleAll()
	self.nodeCreateGroup:setVisible(false)
	self.nodeBg:setVisible(false)
	self.nodeTime:setVisible(false)
	self.nodeEnter:setVisible(false)
	self.nodePowerRank:setVisible(false)
	self.labelTime2:setVisible(false)
	self.labelTime3:setVisible(false)
	self.labelTime4:setVisible(false)
	self.labelMember:setVisible(false)
	self.labelEmpty:setVisible(false)
	self.labelPBLInfo:setVisible(false)
end
function AllianceGroupMainNode:createTimeNode(numOfChar, initTime, paddingArray)
	local nodeParent = display.newNode()
	local getCharNode = function()
		local numChar = cc.Label:createWithCharMap("fonts/icon_acitivity_num.png", 35, 46, 48)
		numChar:setAnchorPoint(cc.p(0.5, 0.5))
		numChar:setPosition(0, 0)
		return numChar
	end
	local _ENV, numArray
	for i = 1, numOfChar do
		local numChar = getCharNode()
		numChar:addTo(nodeParent)
		numChar:setContentSize(cc.size(35, 46))
		numChar:setFontSize(46)
		numArray[i] = numChar
	end
	SoraDAlignNodeArray(numArray, false, paddingArray)
	local nodeTimeCooling = self.nodeTimeCooling
	local frame_LegendaryKing_countdown_12 = self.frameLegendaryKingCountdown12
	function nodeParent:setTime(secTime)
		local timeStr = SoraDConvertSecondToStringNoDay(secTime)
		local splitTime = string.split(timeStr, ":")
		if string.len(splitTime[1]) >= 3 then
			if tonumber(splitTime[1]) and tonumber(splitTime[1]) > 999 then
				splitTime[1] = tostring(999)
			end
			frame_LegendaryKing_countdown_12:setVisible(true)
			numArray[1]:setVisible(true)
			nodeTimeCooling:setPositionX(344)
			_UPVALUE6_ = nodeTimeCooling.setPositionX
			nodeTimeCooling.setPositionX[1] = string.sub(timeStr, 1, 1)
			nodeTimeCooling.setPositionX[2] = string.sub(timeStr, 2, 2)
			nodeTimeCooling.setPositionX[3] = string.sub(timeStr, 3, 3)
			nodeTimeCooling.setPositionX[4] = string.sub(timeStr, 5, 5)
			nodeTimeCooling.setPositionX[5] = string.sub(timeStr, 6, 6)
			nodeTimeCooling.setPositionX[6] = string.sub(timeStr, 8, 8)
			nodeTimeCooling.setPositionX[7] = string.sub(timeStr, 9, 9)
			nodeTimeCooling.setPositionX[8] = string.sub(timeStr, 9, 9)
			nodeTimeCooling.setPositionX[9] = string.sub(timeStr, 9, 9)
			local nodeTimeCooling.setPositionX[10], strArray = string.sub(timeStr, 9, 9)
			for i = 1, #strArray do
				if numArray[i] then
					numArray[i]:setString(strArray[i])
				end
			end
		else
			nodeTimeCooling:setPositionX(320)
			frame_LegendaryKing_countdown_12:setVisible(false)
			numArray[1]:setVisible(false)
			_UPVALUE5_ = numArray[1].setVisible
			numArray[1].setVisible[1] = string.sub(timeStr, 1, 1)
			numArray[1].setVisible[2] = string.sub(timeStr, 2, 2)
			numArray[1].setVisible[3] = string.sub(timeStr, 4, 4)
			numArray[1].setVisible[4] = string.sub(timeStr, 5, 5)
			numArray[1].setVisible[5] = string.sub(timeStr, 7, 7)
			numArray[1].setVisible[6] = string.sub(timeStr, 8, 8)
			numArray[1].setVisible[7] = string.sub(timeStr, 8, 8)
			numArray[1].setVisible[8] = string.sub(timeStr, 8, 8)
			numArray[1].setVisible[9] = string.sub(timeStr, 8, 8)
			local numArray[1].setVisible[10], strArray = string.sub(timeStr, 8, 8)
			for i = 1, #strArray do
				if numArray[i + 1] then
					numArray[i + 1]:setString(strArray[i])
				end
			end
		end
	end
	if initTime then
		nodeParent:setTime(initTime)
	end
	return nodeParent
end
function AllianceGroupMainNode:btnApplyClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if pyramidWarCtrl:getGroupManagerRankEX() <= 0 then
			SoraDShowMsgTip(i18n("pyramid_tips_11"))
			return
		end
		local canSelect = false
		for i, v in ipairs(self.legionList) do
			if pyramidWarCtrl:isCanApplyByAid(v.legionId) then
				canSelect = true
				break
			end
		end
		if canSelect then
			SoraDCreatePanel("allianceGroupSelectTimeView"):show()
		else
			SoraDShowMsgTip(i18n("common_text_3254"))
		end
	end
end
function AllianceGroupMainNode:btnCreateGroupClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("allianceGroupCreateView")
		panel:initCreate()
		panel:show()
	end
end
function AllianceGroupMainNode:btnPBLInfoClickText(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.PYRAMID_BATTLE)
	end
end
function AllianceGroupMainNode:btnClickText(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("allianceGroupMatchView")
		panel:show()
	end
end
function AllianceGroupMainNode:btnEnterClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local enterWarCondition = function(...)
			local gametop = gModuleMgr.getObject("gametop")
			local armyCtrl = gametop.playertop_:getModule("armyCtrl")
			if armyCtrl:getTotalWoundedArmyCount() > 0 then
				SoraDShowMsgBox(i18n("common_text_3261"), i18n("common_text_402"), nil, function(eventType)
					if eventType == MSGBOX_CALLBACK_YES then
						local worldMapWarDef = include("worldMapWarDef")
						worldMapWarDef.openHospitalView()
					end
				end)
				return false
			end
			local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
			if kingdomMapCtrl.kingdomMapCell:hasWoundedQueueArmy() then
				SoraDShowMsgTip(i18n("common_text_3498"))
				return false
			end
			if kingdomMapCtrl:isHasMassQueue() then
				SoraDShowMsgTip(i18n("common_text_3262"))
				return false
			end
			return true
		end
		local enterBattle = function()
			if enterWarCondition() then
				SoraDShowLoading(self)
				pyramidWarCtrl:pyramidwarEnterReq()
			end
		end
		pyramidClientModule.popSelectMenu(enterBattle)
	end
end
return AllianceGroupMainNode
