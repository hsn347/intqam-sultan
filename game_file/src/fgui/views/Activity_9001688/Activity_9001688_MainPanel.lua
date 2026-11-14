local constantRead = include("constantRead")
local activityTimeRead = include("activityTimeRead")
local activity_9001688_Read = include("activity_9001688_Read")
local activity_9001688_Ctrl = SoraDGetCtrl("activity_9001688_Ctrl")
local activity_9001689_Ctrl = SoraDGetCtrl("activity_9001689_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001688_MainPanel = class("Activity_9001688_MainPanel", baseFguiPanel)
function Activity_9001688_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001688_MainPanel.super.ctor(self, ...)
	print("Activity_9001688_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.DAILY_SALUTE
end
function Activity_9001688_MainPanel:onInit()
	print("=======Activity_9001688_MainPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(activityTimeRead.getActivityShowName(self.activityID), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_tip:setString(i18n("daily_salute_text17"))
	self.fields.Button_reward:setString(i18n("decrypt_text_03"))
	self.fields.Button_reward:addClickListener(handler(self, self.btnRewardClick))
	self.fields.Button_rank:setString(i18n("daily_salute_text15"))
	self.fields.Button_rank:addClickListener(handler(self, self.btnRankClick))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_nextTime)
	self.fields.List:setItemRenderer(handler(self, self.onTaskRenderer))
	self.fields.Com_boxList:setBarColor(3)
	self.Text_time:setTimeEndListener(function()
		self:initView()
	end)
	self.fields.Button_reward:fixPos()
	self.fields.Button_rank:fixPos()
	self.fields.Com_today:fixPos()
	self.fields.Com_fire:fixPos()
end
function Activity_9001688_MainPanel:onTaskRenderer(index, obj)
	obj:initData(self.taskCfg[index + 1], index + 1)
end
function Activity_9001688_MainPanel:endShow()
	print("=======Activity_9001688_MainPanel:endShow")
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	local _ENV, stageData = self.fields.Com_title.initCommonActivityTime, self.fields.Com_title.initCommonActivityTime
	local stageConfig = activity_9001688_Read.getStageCfg()
	for index, cfg in ipairs(stageConfig) do
		_ENV = nil
		;(nil).stage = index
		;(nil).point = cfg.score
		;(nil).rewards = cfg.reward
		table.insert(stageData, nil)
	end
	self.stageData = stageData
	_ENV = ipairs(stageConfig)
	ipairs(stageConfig).activityID = self.activityID
	ipairs(stageConfig).stageMax = #self.stageData
	ipairs(stageConfig).gap = 30
	self.fields.Com_boxList:initData(ipairs(stageConfig))
	self.tag = 1
	_ENV = ipairs(stageConfig)
	_ENV, _ENV, ipairs(stageConfig).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("daily_reward_name_13")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("daily_salute_text07")
	ipairs(stageConfig).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	ipairs(stageConfig).callback = handler(self, self.onTabClick)
	self.fields.Com_title:initTab(ipairs(stageConfig))
	activity_9001688_Ctrl:sendReqInitDataMsg()
	SoraDShowLoading(self)
end
function Activity_9001688_MainPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:initView()
end
function Activity_9001688_MainPanel:initView()
	SoraDCloseLoading(self)
	local value = activity_9001688_Ctrl:getGlobalScore()
	_ENV = nil
	;(nil).num = fguiHelper.getColorString("#FFDF2D", string.formatnumberthousands(value))
	self.fields.Text_value:setString(i18n("daily_salute_text06", nil))
	for __, data in ipairs(self.stageData) do
		data.state = value >= data.point and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	end
	_ENV = ipairs(self.stageData)
	ipairs(self.stageData).score = value
	ipairs(self.stageData).stageData = self.stageData
	self.fields.Com_boxList:updateData(ipairs(self.stageData))
	self.fields.Com_today:initData(1)
	self.fields.Com_fire:initData(2)
	local stageSignNum = activity_9001688_Ctrl:getStageSignNum()
	self.fields.Button_reward:setReddot(0 < stageSignNum)
	local status, leftTime = activity_9001688_Ctrl:getCycleState()
	self.fields.Button_go:setString(status == 0 and i18n("daily_salute_text10") or i18n("daily_salute_text13"))
	self.Text_time:setTimeLast(function(strTime)
		if status == 0 then
			status = nil
			;(nil).time = strTime
			if i18n("daily_salute_text12", nil) then
				goto lbl_16
			end
		end
		status = nil
		;(nil).time = strTime
		::lbl_16::
		return (i18n("daily_salute_text11", nil))
	end)
	if 0 < leftTime then
		self.Text_time:setVisible(true)
		self.Text_time:beginTime(leftTime)
	else
		self.Text_time:setVisible(false)
	end
	if self.tag == 2 then
		self.taskCfg = activity_9001688_Read.getTaskCfg()
		self.fields.List:setNumItems(#self.taskCfg)
	end
	local stageNum = activity_9001688_Ctrl:getStageSignNum()
	local signNum = activity_9001688_Ctrl:getSignGoldNum()
	self.fields.Button_reward:setReddot(0 < stageNum + signNum, stageNum + signNum)
	self.fields.Com_title:setBtnRedDot(1, 0 < stageNum + signNum, stageNum + signNum)
end
function Activity_9001688_MainPanel:btnRewardClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001688_Award")
end
function Activity_9001688_MainPanel:btnRankClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001688_Rank")
end
function Activity_9001688_MainPanel:btnGoClick()
	SoraDPlaySound()
	SoraDGotoWorldMapPoint(activity_9001689_Ctrl:getBuildPos())
	SoraDRemoveAllPanelFromManager()
end
function Activity_9001688_MainPanel:onClickHelp()
	SoraDPlaySound()
	local num1 = constantRead.getConstValue("DAILY_SALUTE_BRIBE_PICKUP_NUM")
	local num2 = constantRead.getConstValue("DAILY_SALUTE_BRIBE_NUM")
	_ENV = nil
	_ENV = nil
	;(nil).num1 = num1
	;(nil).num2 = num2
	;(nil).content = i18n("daily_salute_text05", nil)
	uiManager:show("RuleView", nil)
end
return Activity_9001688_MainPanel
