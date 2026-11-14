local allianceMgr = SoraDGetCtrl("allianceMgr")
local activity_9001643_Ctrl = SoraDGetCtrl("activity_9001643_Ctrl")
local activity_9001643_Read = include("activity_9001643_Read")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local constantRead = include("constantRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_listTask = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001643/Com_listTask", Com_listTask)
function Com_listTask:onInit()
	self.fields.Text_none:setString(i18n("eidal_celebration_text13"))
	self.fields.Text_time:setTimeUpdateListener(handler(self, self.timeUpdate))
	self.fields.Text_pos:setTouchEnabled(true)
	self.fields.Text_pos:addClickListener(handler(self, self.btnGoPosClick))
	self.fields.Btn_share:addClickListener(handler(self, self.btnShareClick))
	self.fields.Btn_help:setString(i18n("eidal_celebration_text35"))
	self.fields.Btn_help:addClickListener(handler(self, self.btnHelpClick))
	self:fixChildrenPos()
	self.fields.Bar:setScaleX(SoraDFIsRA() and 1 or -1)
end
function Com_listTask:onShow()
end
function Com_listTask:timeUpdate(time)
	self.fields.Bar:setValue(self.times - time)
end
function Com_listTask:initData(data)
	self.data = data
	self.controllers.c1:setSelectedIndex(1)
	self.taskID = self.data.data.taskID
	self.fields.Com_head:setHeadSprite(self.data.iconID, self.data.avatar)
	self.fields.Com_head:setPlayerID(self.data.uid)
	self.fields.Text_name:setString(self.data.nickName)
	local taskCfg = activity_9001643_Read.getTaskCfg(self.taskID)
	activity_9001643_Read = nil
	;(nil).taskname = i18n(taskCfg.task_name)
	self.fields.Text_taskName:setString(i18n("eidal_celebration_text19", nil))
	self.times = taskCfg.times
	local leftTime = self.data.leftTime
	if 0 < leftTime then
		self.fields.Bar:setMax(self.times)
		self.fields.Text_time:beginTime(leftTime)
	end
	activity_9001643_Read = i18n("eidal_celebration_text19", nil)
	i18n("eidal_celebration_text19", nil).num = self.data.curHp
	i18n("eidal_celebration_text19", nil).max = constantRead.getConstValue("EIDAL_CELEBRATION_TASK_HELPED_NUM")
	self.fields.Text_helpCount:setString(i18n("eidal_celebration_text22", i18n("eidal_celebration_text19", nil)))
	self.isHelped = self.data.isHelped
	self.fields.Btn_help:setBright(not self.isHelped)
end
function Com_listTask:initMyData()
	local taskID = activity_9001643_Ctrl:isTaskDoIng()
	self.controllers.c1:setSelectedIndex(taskID and 0 or 2)
	if taskID then
		self.taskID = taskID
		self.fields.Com_head:setSelfHead()
		local info = lordInfoCtrl:getBaseInfo()
		self.fields.Text_name:setString(info.nickName)
		local taskCfg = activity_9001643_Read.getTaskCfg(self.taskID)
		self.fields.Text_taskName:setString(i18n(taskCfg.task_name))
		self.times = taskCfg.times
		local leftTime = activity_9001643_Ctrl:getTaskLeftTime(self.taskID)
		if 0 < leftTime then
			self.fields.Bar:setMax(self.times)
			self.fields.Text_time:beginTime(leftTime)
		end
		local byHelpCount = activity_9001643_Ctrl:getTaskByHelpCount(self.taskID)
		local times = constantRead.getConstValue("EIDAL_CELEBRATION_HELP_TIMES") * byHelpCount / 60
		activity_9001643_Ctrl = i18n(taskCfg.task_name)
		i18n(taskCfg.task_name).times = times
		self.fields.Text_reduce:setString(i18n("eidal_celebration_text16", i18n(taskCfg.task_name)))
		local objPos = activity_9001643_Ctrl:getMapObjPos()
		activity_9001643_Ctrl = i18n("eidal_celebration_text16", i18n(taskCfg.task_name))
		i18n("eidal_celebration_text16", i18n(taskCfg.task_name)).x = objPos.x
		i18n("eidal_celebration_text16", i18n(taskCfg.task_name)).y = objPos.y
		activity_9001643_Ctrl = "common_text_2155"
		;("common_text_2155").u = true
		self.fields.Text_pos:setString(SoraDWrapHtmlTagByStyle(i18n("common_text_2155", i18n("eidal_celebration_text16", i18n(taskCfg.task_name))), "common_text_2155"))
	end
end
function Com_listTask:btnGoPosClick()
	SoraDPlaySound()
	local pos = activity_9001643_Ctrl:getMapObjPos()
	if pos then
		SoraDGotoWorldMapPoint(pos, true)
		SoraDRemoveAllPanelFromManager()
	end
end
function Com_listTask:btnShareClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).taskID = self.taskID
	uiManager:show("Activity_9001643_SharePop", nil)
end
function Com_listTask:btnHelpClick()
	SoraDPlaySound()
	if self.isHelped then
		SoraDShowMsgTip(i18n("eidal_celebration_text39"))
		return
	end
	if activity_9001643_Ctrl:getHelpCount() <= 0 then
		SoraDShowMsgTip(i18n("eidal_celebration_text20"))
		return
	end
	activity_9001643_Ctrl:reqHelp(self.data.uid, self.taskID)
end
return Com_listTask
