local beastCanyonCtrl = SoraDGetCtrl("beastCanyonCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BeastCanyon/Com_Task", Com_Task)
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
function Com_Task:onShow()
end
function Com_Task:initData(data)
	self.activityID = data.activityID
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
	self.controllers.status:setSelectedIndex(self.taskStatus)
	self:setBtnStatus()
	self.fields.Award_Scroll:setNumItems(#self.data.award)
	if IsArClient and #self.data.award > 0 then
		self.fields.Award_Scroll:scrollToView(0)
	end
end
function Com_Task:setBtnStatus()
	if self.taskStatus ~= gBtnTargetStatusDef.NONE and self.taskStatus ~= gBtnTargetStatusDef.GOT then
		self.fields.Button_Task:setTitle(self.taskStatus == gBtnTargetStatusDef.GO and i18n("common_text_477") or self.taskStatus == gBtnTargetStatusDef.GET and i18n("common_text_1146"))
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
end
function Com_Task:onItemRender(index, object)
	local item = self.data.award[index + 1]
	object:initData(item.id, item.count)
end
function Com_Task:onClickTask()
	SoraDPlaySound()
	if self.taskStatus == gBtnTargetStatusDef.GET then
		beastCanyonCtrl:reqDivineBeastCanyonWeekReward(self.activityID, self.data.Index)
	elseif self.taskStatus == gBtnTargetStatusDef.GO then
		_ENV = gBtnTargetStatusDef.GO
		gBtnTargetStatusDef.GO.msg = "MESSAGE_ACTIVITY_9001547_UPDATE"
		gBtnTargetStatusDef.GO.subMsg = "taskClose"
		SoraDSendMessage(gBtnTargetStatusDef.GO)
	end
end
return Com_Task
