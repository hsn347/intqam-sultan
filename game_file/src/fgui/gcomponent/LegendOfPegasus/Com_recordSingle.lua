local eventQuestRead = include("eventQuestRead")
local notBeginTaskColor = cc.c3b(166, 175, 183)
local doingTaskColor = cc.c3b(243, 182, 20)
local finishTaskColor = cc.c3b(255, 1, 1)
local completeTaskColor = cc.c3b(64, 232, 36)
local snowWolfLostRead = include("snowWolfLostRead")
local legendOfPegasusCtrl = SoraDGetCtrl("legendOfPegasusCtrl")
_UPVALUE7_ = "legendOfPegasusCtrl"
;("legendOfPegasusCtrl")[1] = "lost_ruins_text_06"
;("legendOfPegasusCtrl")[2] = "lost_ruins_text_08"
;("legendOfPegasusCtrl")[3] = "lost_ruins_text_07"
;("legendOfPegasusCtrl")[4] = "lost_ruins_text_10"
;("legendOfPegasusCtrl")[5] = "common_text_1892"
;("legendOfPegasusCtrl")[6] = "lost_ruins_text_09"
local ("legendOfPegasusCtrl")[7], taskStateStr = "togetherTeam_text_68", "legendOfPegasusCtrl"
local baseComponent = require("fgui.base.baseComponent")
local Com_recordSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://LegendOfPegasus/Com_recordSingle", Com_recordSingle)
function Com_recordSingle:onInit()
	self.txt_time = SoraDCreateTimerLabel(self, self.fields.Text_Time2)
	self.fields.btnGo:setString(i18n("common_text_1720"))
	self.fields.btnGo:addClickListener(handler(self, self.btnGoClick))
	self.fields.Text_Pos:setTouchEnabled(true)
	self.fields.Text_Pos:setSwallowTouches(false)
	self.fields.Text_Pos:addClickListener(handler(self, self.btnClickText))
	self:fixChildrenPos()
end
function Com_recordSingle:onShow()
end
function Com_recordSingle:initData(data)
	dump(data, "Com_recordSingle:initData")
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
	self.fields.Text_Title:setString(i18n("Legends_of_Pegasus_text_05"))
	_ENV = i18n("Legends_of_Pegasus_text_05")
	_ENV, _ENV, i18n("Legends_of_Pegasus_text_05").commonStr = "X:%d Y:%d", string.format("X:%d Y:%d", self.point.x, self.point.y), string.format("X:%d Y:%d", self.point.x, self.point.y)
	;("X:%d Y:%d").u = "true"
	;("X:%d Y:%d").c = "true"
	string.format("X:%d Y:%d", self.point.x, self.point.y).commonStr, ("X:%d Y:%d").name = "X:%d Y:%d", "posXY"
	self.fields.Text_Pos:setString(i18n_html("common_text_034", i18n("Legends_of_Pegasus_text_05")))
	self.fields.Text_Des:setString(i18n(eventQuestRead.getDes(data.questId)))
end
function Com_recordSingle:initActivityTime(isRunTime)
	local totalTime = snowWolfLostRead.getLegendOfPegasusTaskTimeByQuestId(self.questInfo.questId)
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
		local leftTime = math.max(0, totalTime - (serviceFunctions.systemTime() - legendOfPegasusCtrl:getRunningQuestInfo().startTime))
		self.txt_time:beginTime(leftTime)
	else
		self.txt_time:endTime()
		snowWolfLostRead = legendOfPegasusCtrl
		legendOfPegasusCtrl.time = SoraDConvertSecondToString(totalTime)
		self.txt_time:setString(i18n("lost_ruins_text_15", legendOfPegasusCtrl))
	end
end
function Com_recordSingle:btnGoClick()
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
function Com_recordSingle:btnClickText()
	SoraDPlaySound()
	SoraDGotoWorldMapPoint(self.point, true)
	SoraDRemoveAllPanelFromManager()
end
return Com_recordSingle
