local activity_9001684_Ctrl = SoraDGetCtrl("activity_9001684_Ctrl")
local activity_9001684_Read = include("activity_9001684_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001684_MainPanel = class("Activity_9001684_MainPanel", baseFguiPanel)
function Activity_9001684_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001684_MainPanel.super.ctor(self, ...)
	print("Activity_9001684_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.DONATE_METERIAL_ACTIVITY
end
function Activity_9001684_MainPanel:onInit()
	print("=======Activity_9001684_MainPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("collect_activity_031"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List_tabTask:setItemRenderer(handler(self, self.onTabRender))
	self.fields.List_tabTask:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onTabClick))
	self.fields.List_task:setVirtual()
	self.fields.List_task:setItemRenderer(handler(self, self.onTaskRenderer))
	self.fields.Button_rank:setString(i18n("collect_activity_004"))
	self.fields.Button_rank:addClickListener(handler(self, self.btnRankClick))
	self.fields.Button_dmgRank:setString(i18n("collect_activity_017"))
	self.fields.Button_dmgRank:addClickListener(handler(self, self.btnDmgRankClick))
	self.fields.Button_collect:setString(i18n("collect_activity_008"))
	self.fields.Button_collect:addClickListener(handler(self, self.btnCollectClick))
	self.fields.Button_attack:setString(i18n("collect_activity_027"))
	self.fields.Button_attack:addClickListener(handler(self, self.btnAttackClick))
	self.fields.Label_timeMonster:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = fguiHelper.getColorString("#FFDF2D", time)
		return i18n("collect_activity_018", nil)
	end)
	self.fields.Label_timeMonster:setTimeEndListener(function()
		self:initView()
	end)
	self.fields.List_dmg:setItemRenderer(handler(self, self.onDmgRenderer))
	self.fields.Button_rank:fixPos()
	self.fields.Button_dmgRank:fixPos()
end
function Activity_9001684_MainPanel:onTaskRenderer(index, obj)
	obj:initData(self.taskList[index + 1], self.taskTag == 3)
end
function Activity_9001684_MainPanel:onDmgRenderer(index, obj)
	obj:initData(self.dmgList[index + 1], index + 1, #self.dmgList)
end
function Activity_9001684_MainPanel:endShow()
	print("=======Activity_9001684_MainPanel:endShow")
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	local _ENV, stageData = self.fields.Label_time.initCommonActivityTime, self.fields.Label_time.initCommonActivityTime
	local stageConfig = activity_9001684_Read.getStageCfg(1)
	for __, cfg in ipairs(stageConfig) do
		_ENV = nil
		;(nil).stage = cfg.stageLevel
		;(nil).point = cfg.stageNum
		;(nil).rewards = cfg.rewards
		;(nil).stageType = 1
		;(nil).stageLevel = cfg.stageLevel
		table.insert(stageData, nil)
	end
	self.stageData = stageData
	_ENV = ipairs(stageConfig)
	ipairs(stageConfig).activityID = self.activityID
	ipairs(stageConfig).stageMax = #self.stageData
	ipairs(stageConfig).gap = 30
	self.fields.Com_wzBoxList:initData(ipairs(stageConfig))
	local _ENV, stagetfData = self.fields.Com_wzBoxList.initData, self.fields.Com_wzBoxList.initData
	local stagetfConfig = activity_9001684_Read.getStageCfg(2)
	for __, cfg in ipairs(stagetfConfig) do
		_ENV = nil
		;(nil).stage = cfg.stageLevel
		;(nil).point = cfg.stageNum
		;(nil).rewards = cfg.rewards
		;(nil).stageType = 2
		;(nil).stageLevel = cfg.stageLevel
		table.insert(stagetfData, nil)
	end
	self.stagetfData = stagetfData
	_ENV = ipairs(stagetfConfig)
	ipairs(stagetfConfig).activityID = self.activityID
	ipairs(stagetfConfig).stageMax = #self.stagetfData
	ipairs(stagetfConfig).gap = 30
	self.fields.Com_tfBoxList:initData(ipairs(stagetfConfig))
	self.taskTag = 1
	_ENV, _ENV, self.preTaskTag = self.fields.Com_tfBoxList, self.taskTag, self.taskTag
	self.fields.Com_tfBoxList.title = i18n("collect_activity_005")
	_ENV, self.taskTag[1], self.fields.Com_tfBoxList.tag = self.fields.Com_tfBoxList, self.fields.Com_tfBoxList, 1
	self.fields.Com_tfBoxList.title = i18n("collect_activity_006")
	_ENV, self.taskTag[2], self.fields.Com_tfBoxList.tag = self.fields.Com_tfBoxList, self.fields.Com_tfBoxList, 2
	self.fields.Com_tfBoxList.title = i18n("collect_activity_007")
	self.taskTabCfg, self.taskTag[3], self.fields.Com_tfBoxList.tag = self.taskTag, self.fields.Com_tfBoxList, 3
	self.taskItemWidth = (self.fields.List_tabTask:getWidth() - self.fields.List_tabTask:getColumnGap() * (#self.taskTabCfg - 1)) / #self.taskTabCfg
	self.fields.List_tabTask:setNumItems(#self.taskTabCfg)
	self.fields.List_tabTask:setSelectedIndex(self.taskTag - 1)
	self.tag = 1
	_ENV = self.taskTag - 1
	_ENV, _ENV, (self.taskTag - 1).defaultClick = stageData, self.tag, self.tag
	stageData.title = i18n("collect_activity_009")
	_ENV, self.tag[1], stageData.tag = stageData, stageData, 1
	stageData.title = i18n("collect_activity_029")
	;(self.taskTag - 1).tabsetArray, self.tag[2], stageData.tag = self.tag, stageData, 2
	;(self.taskTag - 1).callback = handler(self, self.onClickTab)
	self.fields.Com_Tab:initView(self.taskTag - 1)
end
function Activity_9001684_MainPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:initView()
end
function Activity_9001684_MainPanel:onTabRender(index, obj)
	obj:setTitle(self.taskTabCfg[index + 1].title)
	obj:setWidth(self.taskItemWidth)
	local num = activity_9001684_Ctrl:getTaskStatusAndNum(index + 1)
	obj:setReddot(0 < num, num)
end
function Activity_9001684_MainPanel:onTabClick(tag)
	SoraDPlaySound()
	self.taskTag = self.fields.List_tabTask:getSelectedIndex() + 1
	if self.preTaskTag ~= self.taskTag then
		self:updateTask()
		self.preTaskTag = self.taskTag
	end
end
function Activity_9001684_MainPanel:updateTask()
	self.taskList = self.taskTag == 3 and clone(activity_9001684_Read.getInfiniityTaskCfg()) or clone(activity_9001684_Read.getTaskCfg(self.taskTag))
	self:sortTask()
	self.fields.List_task:setNumItems(#self.taskList)
end
function Activity_9001684_MainPanel:sortTask()
	for k, v in ipairs(self.taskList) do
		v.status = activity_9001684_Ctrl:getTaskStatus(v.taskId or v.taskType, self.taskTag == 3)
	end
	table.sort(self.taskList, function(a, b)
		if a.status == b.status then
			return (a.taskId or a.taskType) < (b.taskId or b.taskType)
		else
			return a.status < b.status
		end
	end)
end
function Activity_9001684_MainPanel:initView()
	SoraDCloseLoading(self)
	local ret, num = activity_9001684_Ctrl:getReceiveStatusAndNum()
	local meterialNum = activity_9001684_Ctrl:getMeterialNum()
	if self.tag == 1 then
		for __, data in ipairs(self.stageData) do
			data.state = activity_9001684_Ctrl:getStageBoxStatues(data.stageType, data.stageLevel)
		end
		_ENV = ipairs(self.stageData)
		ipairs(self.stageData).score = meterialNum
		_ENV, ipairs(self.stageData).stageData = self.stageData, self.stageData
		ipairs(self.stageData).otherData, self.stageData.stageType = self.stageData, self.tag
		self.fields.Com_wzBoxList:updateData(ipairs(self.stageData))
		_ENV = self.tag
		self.tag.num = fguiHelper.getColorString("#FFDF2D", string.formatnumberthousands(meterialNum))
		self.fields.Lab_meterial:setString(i18n("collect_activity_030", self.tag))
		self:updateTask()
		self.fields.Button_collect:setReddot(ret)
		self.fields.Button_collect:setBright(ret)
		self.fields.List_tabTask:setNumItems(#self.taskTabCfg)
	else
		local leftTime = activity_9001684_Ctrl:getBossChallengeTime()
		self.fields.Button_attack:setVisible(0 < leftTime)
		if 0 < leftTime then
			self.fields.Label_timeMonster:beginTime(leftTime)
		else
			self.fields.Label_timeMonster:setString(i18n("collect_activity_035"))
		end
		local bossDmg = activity_9001684_Ctrl:getBossDmg()
		_ENV = i18n("collect_activity_035")
		i18n("collect_activity_035").num = fguiHelper.getColorString("#70C723", string.formatnumberthousands(bossDmg))
		self.fields.Text_dmgBest:setString(i18n("collect_activity_019", i18n("collect_activity_035")))
		local factor, toNext = activity_9001684_Read.getDamageFactor(meterialNum)
		_ENV, _ENV = i18n("collect_activity_019", i18n("collect_activity_035"))
		i18n("collect_activity_019", i18n("collect_activity_035")).des = i18n("collect_activity_012")
		self.dmgList, i18n("collect_activity_019", i18n("collect_activity_035"))[1], i18n("collect_activity_019", i18n("collect_activity_035")).num = i18n("collect_activity_019", i18n("collect_activity_035"))
		if 0 < toNext then
			_ENV = string.formatnumberthousands(meterialNum)
			string.formatnumberthousands(meterialNum).des = i18n("collect_activity_037")
			string.formatnumberthousands(meterialNum).num = string.formatnumberthousands(toNext)
			table.insert(self.dmgList, (string.formatnumberthousands(meterialNum)))
		end
		_ENV = string.formatnumberthousands(meterialNum)
		string.formatnumberthousands(meterialNum).des = i18n("collect_activity_036")
		string.formatnumberthousands(meterialNum).num = factor / 10 .. "%"
		table.insert(self.dmgList, (string.formatnumberthousands(meterialNum)))
		self.fields.List_dmg:setNumItems(#self.dmgList)
		for __, data in ipairs(self.stagetfData) do
			data.state = activity_9001684_Ctrl:getStageBoxStatues(data.stageType, data.stageLevel)
		end
		_ENV = ipairs(self.stagetfData)
		ipairs(self.stagetfData).score = bossDmg
		_ENV, ipairs(self.stagetfData).stageData = self.stagetfData, self.stagetfData
		ipairs(self.stagetfData).otherData, self.stagetfData.stageType = self.stagetfData, self.tag
		self.fields.Com_tfBoxList:updateData(ipairs(self.stagetfData))
	end
	self.fields.Com_Tab:setBtnRedDot(1, ret, num)
end
function Activity_9001684_MainPanel:findBoss(target, data)
	SoraDCloseLoading(self)
	self.bossPos = data.pos
	SoraDGotoWorldMapPoint(self.bossPos, true)
	SoraDRemoveAllPanelFromManager()
end
function Activity_9001684_MainPanel:btnRankClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).rankType = self.tag
	uiManager:show("Activity_9001684_Rank", nil)
end
function Activity_9001684_MainPanel:btnDmgRankClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).rankType = self.tag
	uiManager:show("Activity_9001684_Rank", nil)
end
function Activity_9001684_MainPanel:btnCollectClick()
	SoraDPlaySound()
	local ret, num = activity_9001684_Ctrl:getReceiveStatusAndNum()
	if not ret then
		SoraDShowMsgTip(i18n("collect_activity_001"))
		return
	end
	activity_9001684_Ctrl:reqGetAllReward()
	SoraDShowLoading(self)
end
function Activity_9001684_MainPanel:btnAttackClick()
	SoraDPlaySound()
	if worldMapDefine.isInWar() or not SoraDGetCtrl("lordInfoCtrl"):isInSelfKid() then
		SoraDShowMsgTip(i18n("collect_activity_020"))
		return
	end
	self.bossPos = activity_9001684_Ctrl:getBossPos()
	if self.bossPos then
		SoraDGotoWorldMapPoint(self.bossPos, true)
		SoraDRemoveAllPanelFromManager()
	else
		activity_9001684_Ctrl:reqGetBossPos()
		SoraDShowLoading(self)
	end
end
function Activity_9001684_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("collect_activity_003")
	uiManager:show("RuleView", nil)
end
return Activity_9001684_MainPanel
