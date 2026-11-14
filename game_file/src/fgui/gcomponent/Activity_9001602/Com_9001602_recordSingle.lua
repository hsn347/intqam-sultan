local eventQuestRead = include("eventQuestRead")
local notBeginTaskColor = cc.c3b(166, 175, 183)
local doingTaskColor = cc.c3b(243, 182, 20)
local finishTaskColor = cc.c3b(255, 1, 1)
local completeTaskColor = cc.c3b(64, 232, 36)
local snowWolfLostRead = include("snowWolfLostRead")
local activity_9001602_Ctrl = SoraDGetCtrl("activity_9001602_Ctrl")
local activity_9001696_Ctrl = SoraDGetCtrl("activity_9001696_Ctrl")
_UPVALUE7_ = "activity_9001696_Ctrl"
;("activity_9001696_Ctrl")[1] = "lost_ruins_text_06"
;("activity_9001696_Ctrl")[2] = "lost_ruins_text_08"
;("activity_9001696_Ctrl")[3] = "lost_ruins_text_07"
;("activity_9001696_Ctrl")[4] = "lost_ruins_text_10"
;("activity_9001696_Ctrl")[5] = "common_text_1892"
;("activity_9001696_Ctrl")[6] = "lost_ruins_text_09"
local ("activity_9001696_Ctrl")[7], taskStateStr = "togetherTeam_text_68", "activity_9001696_Ctrl"
local baseComponent = require("fgui.base.baseComponent")
local Com_9001602_recordSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001602/Com_9001602_recordSingle", Com_9001602_recordSingle)
_ENV = fgui.register_extension
fgui.register_extension[gActivityTimeActivityID.NORMAL_ACTIVITY_9001602] = activity_9001602_Ctrl
local fgui.register_extension[gActivityTimeActivityID.NORMAL_ACTIVITY_9001696], activityCtrl = activity_9001696_Ctrl, fgui.register_extension
function Com_9001602_recordSingle:onInit()
	self.txt_time = SoraDCreateTimerLabel(self, self.fields.Text_Time2)
	self.fields.btnGo:setString(i18n("common_text_1720"))
	self.fields.btnGo:addClickListener(handler(self, self.btnGoClick))
	self.fields.Text_Pos:setTouchEnabled(true)
	self.fields.Text_Pos:setSwallowTouches(false)
	self.fields.Text_Pos:addClickListener(handler(self, self.btnClickText))
	self:fixChildrenPos()
end
function Com_9001602_recordSingle:onShow()
end
function Com_9001602_recordSingle:initData(data, activityID)
	dump(data, "Com_9001602_recordSingle:initData")
	self.activityID = activityID
	self.state = data.state
	_ENV, self.questInfo = data.state, data
	data.state.x = data.x - 1
	self.point, data.state.y = data.state, data.y - 1
	local color = finishTaskColor
	self.fields.btnGo:setVisible(data.state == gLosRuinsStatus.NOT_RECIEVE or data.state == gLosRuinsStatus.RECIEVED)
	if data.state == gLosRuinsStatus.NOT_RECIEVE then
		color = notBeginTaskColor
		self:initActivityTime(false)
	elseif data.state == gLosRuinsStatus.RECIEVED then
		color = doingTaskColor
		self:initActivityTime(true)
	elseif data.state == gLosRuinsStatus.COMPLETE or data.state == gLosRuinsStatus.RECIEVED_REWARD then
		color = completeTaskColor
		self:initActivityTime(false)
	end
	self.fields.Text_Status:setColor(color)
	self.fields.Text_Status:setString(i18n(taskStateStr[data.state]))
	self.fields.Text_Time:setString(SoraDConverTimeStr(data.time))
	self.fields.Text_Title:setString(i18n("firedragon_of_anger_text5"))
	_ENV = i18n("firedragon_of_anger_text5")
	_ENV, _ENV, i18n("firedragon_of_anger_text5").commonStr = "X:%d Y:%d", string.format("X:%d Y:%d", self.point.x, self.point.y), string.format("X:%d Y:%d", self.point.x, self.point.y)
	;("X:%d Y:%d").u = "true"
	;("X:%d Y:%d").c = "true"
	string.format("X:%d Y:%d", self.point.x, self.point.y).commonStr, ("X:%d Y:%d").name = "X:%d Y:%d", "posXY"
	self.fields.Text_Pos:setString(i18n_html("common_text_034", i18n("firedragon_of_anger_text5")))
	self.fields.Text_Des:setString(i18n(eventQuestRead.getDes(data.questId)))
end
function Com_9001602_recordSingle:initActivityTime(isRunTime)
	local totalTime = snowWolfLostRead.getActivityTaskTimeByQuestId(self.questInfo.questId, self.activityID)
	if isRunTime then
		self.txt_time:setTimeEndListener(handler(self, function()
			_ENV = nil
			;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
			SoraDSendMessage(nil)
		end))
		self.txt_time:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("lost_ruins_text_15", nil)
		end)
		local leftTime = math.max(0, totalTime - (serviceFunctions.systemTime() - activityCtrl[self.activityID]:getRunningQuestInfo().startTime))
		self.txt_time:beginTime(leftTime)
	else
		self.txt_time:endTime()
		snowWolfLostRead = activityCtrl[self.activityID]
		activityCtrl[self.activityID].time = SoraDConvertSecondToString(totalTime)
		self.txt_time:setString(i18n("lost_ruins_text_15", activityCtrl[self.activityID]))
	end
end
function Com_9001602_recordSingle:btnGoClick()
	SoraDPlaySound()
	if self.state == gLosRuinsStatus.RECIEVED then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		local guideId = eventQuestRead.getGuideId(self.questInfo.questId)
		local tbParam = mildGuideManager:splitGuideParam(guideId)
		if tbParam.id == gNewPLayerTaskType.POP_TIP then
			SoraDShowMsgTip(i18n(eventQuestRead.getDes(self.questInfo.questId)))
			return
		end
		if guideId then
			local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
			if not notNeedClose then
				SoraDRemoveAllPanelFromManager()
			end
		end
	else
		SoraDGotoWorldMapPoint(self.point, true)
		SoraDRemoveAllPanelFromManager()
	end
end
function Com_9001602_recordSingle:btnClickText()
	SoraDPlaySound()
	SoraDGotoWorldMapPoint(self.point, true)
	SoraDRemoveAllPanelFromManager()
end
return Com_9001602_recordSingle
