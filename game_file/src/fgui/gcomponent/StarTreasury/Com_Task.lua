local baseComponent = require("fgui.base.baseComponent")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local Com_Task = fgui.extension_class(fgui.GComponent, baseComponent)
local Com_Task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarTreasury/Com_Task", Com_Task)
function Com_Task:onInit()
	self:fixChildrenPos()
	self.desColor = "#E2AF27"
	self.desBgColor = "#FFEBB9"
	self.scheduBgColor = "#FFEBB9"
	self.scheduColor = "#CE0000"
	self.scheduValeColor = "#FFEBB9"
	self.taskStatus = gBtnTargetStatusDef.GO
	self.fields.Award_Scroll:setItemRenderer(handler(self, self.onItemRender))
	self.fields.Button_Task:addClickListener(handler(self, self.onClickTask))
	self.fields.txt_got:setString(i18n("common_text_1892"))
	self.fields.group_got:fixPos()
	if self.fields.n14 then
		self.fields.n14:fix()
	end
end
function Com_Task:initData(data, style)
	if style ~= nil then
		self.controllers.style:setSelectedIndex(style)
	end
	self.desBgColor = data.desBgColor or self.desBgColor
	self.scheduBgColor = data.scheduBgColor or self.scheduBgColor
	self.scheduColor = data.scheduColor or self.scheduColor
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
	if self.taskStatus == gBtnTargetStatusDef.GOT and data.needBuyBoxType ~= 0 then
		self.controllers.status:setSelectedIndex(gBtnTargetStatusDef.GO)
	else
		self.controllers.status:setSelectedIndex(self.taskStatus)
	end
	self:setBtnStatus()
	self.fields.Award_Scroll:setNumItems(#self.data.award)
	if IsArClient and 0 < #self.data.award then
		self.fields.Award_Scroll:scrollToView(0)
	end
end
function Com_Task:setBtnStatus()
	_UPVALUE2_ = nil
	;(nil)[1] = self.taskStatus == gBtnTargetStatusDef.GOT
	;(nil)[2] = self.data.needBuyBoxType
	dump(nil, "self.taskStatus == gBtnTargetStatusDef.GOT and self.data.needBuyBoxType")
	if self.taskStatus == gBtnTargetStatusDef.GOT and self.data.needBuyBoxType ~= 0 then
		self.fields.Button_Task:getController("c1"):setSelectedIndex(2)
		self.fields.Button_Task:setTitle(i18n("common_text_477"))
	else
		self.fields.Button_Task:getController("c1"):setSelectedIndex(self.taskStatus == gBtnTargetStatusDef.GO and 2 or 0)
		if self.taskStatus ~= gBtnTargetStatusDef.NONE and self.taskStatus ~= gBtnTargetStatusDef.GOT then
			self.fields.Button_Task:setTitle(self.taskStatus == gBtnTargetStatusDef.GO and i18n("common_text_477") or self.taskStatus == gBtnTargetStatusDef.GET and i18n("common_text_1146"))
		end
	end
end
function Com_Task:setScheduleText()
	local count = self.data.progress or self.data.count
	local total = self.data.aim or self.data.total
	count = math.min(count, total)
	local scheduTotalColor, scheduCountColor
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
	if self.data.str then
		_ENV = "%s"
		;("%s").color = scheduTotalColor
		totalStr = SoraDWrapHtmlTagByStyle(string.format("%s", string.formatnumberthousands(total)), "%s")
		_ENV = string.formatnumberthousands(total)
		string.formatnumberthousands(total).var = countStr
		_ENV, _ENV, string.formatnumberthousands(total).var1 = string.formatnumberthousands(total)
		string.formatnumberthousands(total).__default, string.formatnumberthousands(total).color = string.formatnumberthousands(total)
		self.fields.Task_Scedule:setString(_G.i18n_html("alliance_stronghold_text_070", string.formatnumberthousands(total)))
	end
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
	if item.lock then
		object:setItemStatus(item.lock)
	end
end
function Com_Task:onClickTask()
	SoraDPlaySound(nil, nil, true)
	if self.taskStatus == gBtnTargetStatusDef.GET then
		if self.getAwardHandler then
			self.getAwardHandler(self.data.taskID)
		else
			activityTaskComponentCtrl:reqRuestClaimReward(self.data.taskID, self.data.activityID)
		end
	elseif self.taskStatus == gBtnTargetStatusDef.GO then
		if self.skipToHandler then
			self.skipToHandler(self.data.guideId, self.data.taskDes)
		else
			self:onClickGo(self.data.guideId, self.data.taskDes)
		end
	elseif self.taskStatus == gBtnTargetStatusDef.GOT and self.data.needBuyBoxType ~= 0 and self.buyBoxHandler then
		self.buyBoxHandler(self.data.needBuyBoxType)
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
function Com_Task:setHandler(getAwardHandler, skipToHandler, buyBoxHandler)
	self.skipToHandler = skipToHandler
	self.getAwardHandler = getAwardHandler
	self.buyBoxHandler = buyBoxHandler
end
return Com_Task
