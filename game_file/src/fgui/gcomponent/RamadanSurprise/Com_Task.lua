local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local ramadanSurpriseCtrl = SoraDGetCtrl("ramadanSurpriseCtrl")
local ramadanSurpriseltCtrl = include("ramadanSurpriseltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RamadanSurprise/Com_Task", Com_Task)
function Com_Task:onInit()
	self:fixChildrenPos()
	self.desColor = "#E2AF27"
	self.desBgColor = "#FFEBB9"
	self.scheduBgColor = "#FFEBB9"
	self.scheduColor = "#CE0000"
	self.scheduValeColor = "#FFEBB9"
	self.taskStatus = gBtnTargetStatusDef.GO
	self.fields.Button_Task:addClickListener(handler(self, self.onClickTask))
	self.fields.Button_delete:addClickListener(handler(self, self.onClickDelTask))
	self.fields.txt_got:setString(i18n("common_text_1892"))
	SoraDCreateTimerLabel(self, self.fields.Text_refreshTime)
end
function Com_Task:initData(data)
	dump(data, "fjksdfslfklsklkl")
	self.data = data
	self.taskStatus = data.taskStatus
	local str = clone(self.data.taskDes)
	for i, v in pairs(str) do
		if tolua.type(i) == "string" then
			_ENV = nil
			;(nil).color = self.desColor
			;(nil).i = "true"
			str[i] = SoraDWrapHtmlTagByStyle(v, nil)
		end
	end
	_ENV = str
	str.color = self.desBgColor
	self.fields.Task_Des:setString(SoraDWrapHtmlTagByStyle(i18n(str), str))
	self:setScheduleText()
	if data.isAct == 0 and self.taskStatus == gBtnTargetStatusDef.GO then
		self.taskStatus = gBtnTargetStatusDef.NONE
	end
	self.controllers.status:setSelectedIndex(self.taskStatus)
	self:setBtnStatus()
	local num = fguiHelper.getColorString("#FFDF2D", ramadanSurpriseltCtrl.getTaskScoreByQuestId(self.data.taskID))
	_ENV = ramadanSurpriseltCtrl.getTaskScoreByQuestId(self.data.taskID)
	ramadanSurpriseltCtrl.getTaskScoreByQuestId(self.data.taskID).num = num
	local colorStr = i18n("ramadan_surprise_07", ramadanSurpriseltCtrl.getTaskScoreByQuestId(self.data.taskID))
	colorStr = string.gsub(colorStr, "%+", fguiHelper.getColorString("#FFDF2D", "+"))
	self.fields.Text_get:setString(colorStr)
	if data.taskIndex ~= 1 then
		self.fields.Button_delete:setVisible(false)
		self.fields.Button_Task:setVisible(false)
		return
	else
		self.fields.Button_Task:setVisible(true)
	end
	if self.taskStatus == gBtnTargetStatusDef.GO or self.taskStatus == gBtnTargetStatusDef.NONE then
		self.fields.Button_delete:setTitle(i18n("common_text_697"))
		self.fields.Button_delete:setVisible(true)
		if SoraDGetDefaultLanguage() == "ar" then
			self.fields.Button_Task:setPositionX(self.fields.Button_delete:getPositionX() + 170)
		else
			self.fields.Button_Task:setPositionX(self.fields.Button_delete:getPositionX() - 170)
		end
	else
		self.fields.Button_delete:setVisible(false)
		self.fields.Button_Task:setPositionX(self.fields.Button_delete:getPositionX())
	end
end
function Com_Task:setBtnStatus()
	self.fields.Button_Task:getController("c1"):setSelectedIndex(self.taskStatus == gBtnTargetStatusDef.GO and 2 or 0)
	if self.taskStatus ~= gBtnTargetStatusDef.NONE and self.taskStatus ~= gBtnTargetStatusDef.GOT then
		self.fields.Button_Task:setTitle(self.taskStatus == gBtnTargetStatusDef.GO and i18n("common_text_477") or self.taskStatus == gBtnTargetStatusDef.GET and i18n("common_text_1146"))
	end
end
function Com_Task:setScheduleText()
	local count = self.data.progress
	local total = self.data.aim
	count = math.min(count, total)
	if self.taskStatus == gBtnTargetStatusDef.GOT then
		scheduTotalColor = self.scheduBgColor
		scheduCountColor = self.scheduBgColor
	elseif self.taskStatus == gBtnTargetStatusDef.GO then
		scheduTotalColor = self.scheduBgColor
		scheduCountColor = self.scheduColor
	elseif self.taskStatus == gBtnTargetStatusDef.GET then
		scheduTotalColor = self.scheduValeColor
		scheduCountColor = self.scheduValeColor
	end
	_ENV = count
	count.color = scheduCountColor
	local countStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(count), count)
	_ENV = "/%s"
	;("/%s").color = scheduTotalColor
	local totalStr = SoraDWrapHtmlTagByStyle(string.format("/%s", string.formatnumberthousands(total)), "/%s")
	local value = string.format("%s%s", countStr, totalStr)
	value = _pq(value)
	_ENV = string.formatnumberthousands(total)
	_ENV, _ENV, string.formatnumberthousands(total).value = string.formatnumberthousands(total)
	string.formatnumberthousands(total).__default, string.formatnumberthousands(total).color = string.formatnumberthousands(total)
	self.fields.Task_Scedule:setString(_G.i18n_html("complete_text_05", string.formatnumberthousands(total)))
	if self.data.statsRuleID and self.data.statsRuleID == 200 then
		self.fields.Task_Scedule:setUBBEnabled(true)
		if self.taskStatus == gBtnTargetStatusDef.GO then
			self.fields.Task_Scedule:setString(fguiHelper.getColorString(scheduCountColor, 0) .. "/" .. fguiHelper.getColorString(scheduTotalColor, "1"))
		else
			self.fields.Task_Scedule:setString(fguiHelper.getColorString(scheduCountColor, 1) .. "/" .. fguiHelper.getColorString(scheduTotalColor, "1"))
		end
	end
end
function Com_Task:onItemRender(index, object)
	local item = self.data.award[index + 1]
	object:initData(item.id, item.count)
end
function Com_Task:onClickTask()
	SoraDPlaySound(nil, nil, true)
	if self.taskStatus == gBtnTargetStatusDef.GET then
		if self.getAwardHandler then
			self.getAwardHandler(self.data.taskID)
		else
			dump(self.data.taskID, "fsjkfjkdfjkdfjkdf")
			ramadanSurpriseCtrl:sendRewardMsg(self.data.taskID)
		end
	elseif self.taskStatus == gBtnTargetStatusDef.GO then
		if self.skipToHandler then
			self.skipToHandler(self.data.guideId, self.data.taskDes)
		else
			self:onClickGo(self.data.guideId, self.data.taskDes)
		end
	end
end
function Com_Task:onClickDelTask()
	if self.taskStatus == gBtnTargetStatusDef.GO then
		_ENV = nil
		;(nil).content = i18n("ramadan_surprise_06")
		;(nil).confirmFunc = function()
			ramadanSurpriseCtrl:sendDelTaskMsg(self.data.taskIndex)
		end
		;(nil).cancelFunc = function()
		end
		uiManager:show("MessageBox", nil)
	end
end
function Com_Task:onClickGo(guideId, taskDes)
	dump(guideId, "Com_Task:onClickGo guideId")
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local tbParam = mildGuideManager:splitGuideParam(guideId)
	if tbParam.id == gNewPLayerTaskType.POP_TIP then
		SoraDShowMsgTip(i18n(taskDes))
	end
	if guideId then
		local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
		if not notNeedClose then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function Com_Task:setHandler(getAwardHandler, skipToHandler)
	self.skipToHandler = skipToHandler
	self.getAwardHandler = getAwardHandler
end
function Com_Task:setTip(str)
	self.fields.Text_noSelect:setString(i18n("ramadan_surprise_04"))
	self.controllers.status:setSelectedIndex(5)
end
function Com_Task:setInWaiting(time)
	self.fields.Text_refreshTime:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = fguiHelper.getColorString("#FFFFFF", strTime)
		local str = i18n("ramadan_surprise_05", nil)
		return str
	end)
	self.fields.Text_refreshTime:beginTime(time - serviceFunctions.systemTime())
	self.controllers.status:setSelectedIndex(4)
end
function Com_Task:onShow()
end
return Com_Task
