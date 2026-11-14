local publicRead = include("publicRead")
local sinbadTreasureRead = include("sinbadTreasureRead")
local sinbadTreasureCtrl = SoraDGetCtrl("sinbadTreasureCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local sinbadTreasurePrepareView = class("sinbadTreasurePrepareView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("sinbadTreasurePrepareView")
	end
	return target
end)
function sinbadTreasurePrepareView:createTimeNode(numOfChar, initTime, paddingArray)
	local nodeParent = display.newNode()
	local getCharNode = function()
		local numChar = cc.Label:createWithCharMap("fonts/icon_acitivity_num.png", 35, 46, 48)
		numChar:setAnchorPoint(cc.p(0, 0))
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
	local time_node_cooling = self.time_node_cooling
	local frame_LegendaryKing_countdown_12 = self.frame_LegendaryKing_countdown_12
	function nodeParent:setTime(secTime)
		local timeStr = SoraDConvertSecondToStringNoDay(secTime)
		local splitTime = string.split(timeStr, ":")
		if string.len(splitTime[1]) >= 3 then
			if tonumber(splitTime[1]) > 999 then
				splitTime[1] = tostring(999)
			end
			frame_LegendaryKing_countdown_12:setVisible(true)
			_UPVALUE6_ = frame_LegendaryKing_countdown_12.setVisible
			frame_LegendaryKing_countdown_12.setVisible[1] = string.sub(splitTime[1], 1, 1)
			frame_LegendaryKing_countdown_12.setVisible[2] = string.sub(splitTime[1], 2, 2)
			frame_LegendaryKing_countdown_12.setVisible[3] = string.sub(splitTime[1], 3, 3)
			frame_LegendaryKing_countdown_12.setVisible[4] = string.sub(splitTime[2], 1, 1)
			frame_LegendaryKing_countdown_12.setVisible[5] = string.sub(splitTime[2], 2, 2)
			frame_LegendaryKing_countdown_12.setVisible[6] = string.sub(splitTime[3], 1, 1)
			frame_LegendaryKing_countdown_12.setVisible[7] = string.sub(splitTime[3], 2, 2)
			frame_LegendaryKing_countdown_12.setVisible[8] = string.sub(splitTime[3], 2, 2)
			frame_LegendaryKing_countdown_12.setVisible[9] = string.sub(splitTime[3], 2, 2)
			local frame_LegendaryKing_countdown_12.setVisible[10], strArray = string.sub(splitTime[3], 2, 2)
			for i = 1, #strArray do
				if numArray[i] then
					numArray[i]:setString(strArray[i])
				end
			end
		else
			frame_LegendaryKing_countdown_12:setVisible(false)
			_UPVALUE5_ = frame_LegendaryKing_countdown_12.setVisible
			frame_LegendaryKing_countdown_12.setVisible[1] = string.sub(splitTime[1], 1, 1)
			frame_LegendaryKing_countdown_12.setVisible[2] = string.sub(splitTime[1], 2, 2)
			frame_LegendaryKing_countdown_12.setVisible[3] = string.sub(splitTime[2], 1, 1)
			frame_LegendaryKing_countdown_12.setVisible[4] = string.sub(splitTime[2], 2, 2)
			frame_LegendaryKing_countdown_12.setVisible[5] = string.sub(splitTime[3], 1, 1)
			frame_LegendaryKing_countdown_12.setVisible[6] = string.sub(splitTime[3], 2, 2)
			frame_LegendaryKing_countdown_12.setVisible[7] = string.sub(splitTime[3], 2, 2)
			frame_LegendaryKing_countdown_12.setVisible[8] = string.sub(splitTime[3], 2, 2)
			frame_LegendaryKing_countdown_12.setVisible[9] = string.sub(splitTime[3], 2, 2)
			local frame_LegendaryKing_countdown_12.setVisible[10], strArray = string.sub(splitTime[3], 2, 2)
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
function sinbadTreasurePrepareView:ctor()
	self:initControls()
	self:initScroll()
end
function sinbadTreasurePrepareView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SINBAD_TREASURE_PREPARE_FINISH", function(target, data)
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function sinbadTreasurePrepareView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_event")
	self.ccs_title:setTitle(i18n("activity_name_9001349"))
	self.Text_status:setString(i18n("common_text_608"))
	self.activityID = gActivityTimeActivityID.SINBAD_TREASURE
	_UPVALUE6_, self.time_node_cooling.oriPos = self.time_node_cooling, cc.p(self.time_node_cooling:getPosition())
	self.timePadding, self.time_node_cooling[1] = self.time_node_cooling, 25
	self.timePadding, self.time_node_cooling[2] = self.time_node_cooling, 25
	self.timePadding, self.time_node_cooling[3] = self.time_node_cooling, 33
	self.timePadding, self.time_node_cooling[4] = self.time_node_cooling, 26
	self.timePadding, self.time_node_cooling[5] = self.time_node_cooling, 34
	self.timePadding, self.time_node_cooling[6] = self.time_node_cooling, 25
	self.activity_time = self:createTimeNode(7, 259200, self.timePadding)
	self.activity_time:addTo(self.time_node_cooling)
	self.activity_time:setPosition(cc.p(115, 730))
	self.activity_time:setLocalZOrder(10)
	self.time_node_cooling:setPositionX(self.time_node_cooling:getPositionX() - 30)
	self.btnHelpTip:addTouchEventListener(handler(self, self.btnTipClick))
	self:beginTime()
	self:activityLastTime()
end
function sinbadTreasurePrepareView:activityLastTime()
	local startTime = activityShowCtrl:getBeginTimeSecond(self.activityID)
	local endTime = activityShowCtrl:getEndTimeSecond(self.activityID)
	self.Text_time:setString(string.format("%s-%s", os.date("!%Y.%m.%d", startTime), os.date("!%Y.%m.%d", endTime)))
end
function sinbadTreasurePrepareView:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function sinbadTreasurePrepareView:updateTime()
	local eventLeftTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventLeftTime then
		local timerNode = eventLeftTime.timerNode
		if timerNode then
			self.activity_time:setTime(timerNode.timer:getRemainTime())
		end
	end
end
function sinbadTreasurePrepareView:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
function sinbadTreasurePrepareView:getTimePeriod(time1, time2)
	local time1 = tonumber(time1)
	local time2 = tonumber(time2)
	if time1 > time2 then
		return 0
	end
	local remainTime = math.ceil((time2 - time1) / 86400)
	return remainTime
end
function sinbadTreasurePrepareView:initScroll()
	self.Top_Size_scrollTreasure:removeAllChildren()
	local activityData = activityShowCtrl:getActivityData(self.activityID)
	dump(activityData, "slkdjfslkdjfl")
	activityShowCtrl, _UPVALUE3_ = activityData, dump
	activityData.png = "bg_xbdmc_hdzy01.png"
	activityData.name = "Sinbad_text_01"
	activityData.des = "Sinbad_text_27"
	activityShowCtrl, activityData.tInfo = self:getTimePeriod(activityData.begintime, activityData.stagetimes[1]), self:getTimePeriod(activityData.begintime, activityData.stagetimes[1])
	self:getTimePeriod(activityData.begintime, activityData.stagetimes[1]).png = "bg_xbdmc_hdzy02.png"
	self:getTimePeriod(activityData.begintime, activityData.stagetimes[1]).name = "Sinbad_text_02"
	self:getTimePeriod(activityData.begintime, activityData.stagetimes[1]).des = "Sinbad_text_28"
	activityShowCtrl, self:getTimePeriod(activityData.begintime, activityData.stagetimes[1]).tInfo = self:getTimePeriod(activityData.stagetimes[1], activityData.stagetimes[2]), self:getTimePeriod(activityData.stagetimes[1], activityData.stagetimes[2])
	self:getTimePeriod(activityData.stagetimes[1], activityData.stagetimes[2]).png = "bg_xbdmc_hdzy03.png"
	self:getTimePeriod(activityData.stagetimes[1], activityData.stagetimes[2]).name = "Sinbad_text_03"
	self:getTimePeriod(activityData.stagetimes[1], activityData.stagetimes[2]).des = "Sinbad_text_29"
	self:getTimePeriod(activityData.stagetimes[1], activityData.stagetimes[2]).tInfo = self:getTimePeriod(activityData.stagetimes[2], activityData.endtime)
	dump[1] = activityData
	dump[2] = self:getTimePeriod(activityData.begintime, activityData.stagetimes[1])
	local dump[3], imgTable = self:getTimePeriod(activityData.stagetimes[1], activityData.stagetimes[2]), dump
	local scrollH = math.max(self.Top_Size_scrollTreasure:getContentSize().height, 290 * #imgTable)
	self.Top_Size_scrollTreasure:setInnerContainerSize(cc.size(640, scrollH))
	for i, v in ipairs(imgTable) do
		local cell = self.Node_single:clone()
		cell:setPosition(self.Top_Size_scrollTreasure:getContentSize().width / 2, scrollH - (i - 1) * 290)
		cell:addTo(self.Top_Size_scrollTreasure)
		local img = SoraDGetChildByName(cell, "single_bg")
		local title = SoraDGetChildByName(cell, "single_txt_title")
		local ins = SoraDGetChildByName(cell, "single_txt_ins")
		local timeStr = SoraDGetChildByName(cell, "single_txt_time")
		timeStr:setFontSize(16)
		img:setSpriteFrame(v.png)
		title:setString(i18n(v.name))
		ins:setString(i18n(v.des))
		activityShowCtrl = i18n(v.des)
		i18n(v.des).num = v.tInfo
		timeStr:setString(i18n("palace_text_04", i18n(v.des)))
	end
end
function sinbadTreasurePrepareView:btnTipClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "Sinbad_text_04"
		;("Sinbad_text_04").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("Sinbad_text_04"), "Sinbad_text_04")
	end
end
function sinbadTreasurePrepareView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return sinbadTreasurePrepareView
