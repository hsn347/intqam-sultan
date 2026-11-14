local publicRead = include("publicRead")
local activity_9001651_Read = include("activity_9001651_Read")
local activity_9001651_Ctrl = SoraDGetCtrl("activity_9001651_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001651_MainPanel = class("Activity_9001651_MainPanel", baseFguiPanel)
function Activity_9001651_MainPanel:ctor(...)
	Activity_9001651_MainPanel.super.ctor(self, ...)
	print("Activity_9001651_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NEBULA_FURNACE_ACTIVITY
	self.exchangeID = gActivityTimeActivityID.NEBULA_FURNACE_ACTIVITY
	self.classType = SoraDGetActivityClassType(self.activityID)
end
function Activity_9001651_MainPanel:onInit()
	print("=======Activity_9001651_MainPanel:onInit")
	self.tag = 1
	self.shopList, _ENV, self.isSkip = print, print, false
	self.fields.mv_fire:setAllFrameName("xyrl_loop_%.2d.png", 1)
	self.fields.mv_boom:setAllFrameName("G_xyrl_boom_%.2d.png", 1)
	self.fields.mv_boom:setVisible(false)
	fguiHelper.SoraDSetComFields(self)
	self.fields.Com_title:initData(i18n("weapon_creating_01"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_spReward:getChildByName("Text_name"):setString(i18n("weapon_creating_12"))
	self.fields.Com_spReward:setVisible(false)
	self.fields.Btn_task:setString(i18n("weapon_creating_04"))
	self.fields.Btn_task:addClickListener(handler(self, self.btnTaskClick))
	self.fields.Btn_reward:setString(i18n("weapon_creating_05"))
	self.fields.Btn_reward:addClickListener(handler(self, self.btnRewardClick))
	self.fields.Btn_one:setString(i18n("weapon_creating_08"))
	self.fields.Btn_one:addClickListener(handler(self, self.btnOneClick))
	self.fields.Btn_ten:setString(i18n("weapon_creating_09"))
	self.fields.Btn_ten:addClickListener(handler(self, self.btnTenClick))
	self.fields.Text_skip:setString(i18n("weapon_creating_10"))
	self.fields.Check_tick:setSelected(self.isSkip)
	self.fields.Check_tick:addClickListener(handler(self, self.tickClick))
	self.fields.Text_skip:setVisible(false)
	self.fields.Check_tick:setVisible(false)
	self.fields.Com_spReward:fixPos()
	self.fields.Mod_Right:fixPos()
end
function Activity_9001651_MainPanel:onShow()
	print("=======Activity_9001651_MainPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	local _ENV, stageData = self.fields.Com_bg.setGradientColor, self.fields.Com_bg.setGradientColor
	local stageConfig = activity_9001651_Read.getStageConfig(self.classType)
	for __, cfg in ipairs(stageConfig) do
		_ENV = nil
		;(nil).stage = cfg.index
		;(nil).point = cfg.accumulate
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		;(nil).rewards = serviceFunctions.tableFormat(cfg.accumulateReward, nil)
		table.insert(stageData, nil)
	end
	self.stageData = stageData
	_ENV = ipairs(stageConfig)
	ipairs(stageConfig).activityID = self.activityID
	ipairs(stageConfig).stageMax = #self.stageData
	ipairs(stageConfig).gap = 30
	self.fields.Com_boxList:initData(ipairs(stageConfig))
	_ENV = ipairs(stageConfig)
	_ENV, _ENV, ipairs(stageConfig).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("weapon_creating_02")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("weapon_creating_03")
	ipairs(stageConfig).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	ipairs(stageConfig).callback = handler(self, self.onTabClick)
	self.fields.Com_tab:initView(ipairs(stageConfig))
end
function Activity_9001651_MainPanel:onTabClick(tag)
	self.tag = tag
	if self.tag == 1 then
		self.transitions.t0:play(1, 0)
		self:updateView()
	elseif clientEventMgr.judgeIsOpen(self.exchangeID, true) then
		include("commonExchangeUtil").openView(self.exchangeID)
		self:close()
	else
		self.fields.Com_tab:setToTab(1)
	end
end
function Activity_9001651_MainPanel:updateView(target, data)
	SoraDCloseLoading(self)
	if self.tag == 1 then
		self.fields.Label_time:initCommonActivityTime(self.activityID)
		local times = activity_9001651_Ctrl:getLotteryTimes()
		_ENV = nil
		;(nil).num = fguiHelper.getColorString("#FFDF2D", times)
		self.fields.Text_times:setString(i18n("weapon_creating_06", nil))
		for __, data in ipairs(self.stageData) do
			data.state = activity_9001651_Ctrl:getStageBoxStatues(data.point)
		end
		_ENV = ipairs(self.stageData)
		ipairs(self.stageData).score = times
		ipairs(self.stageData).stageData = self.stageData
		self.fields.Com_boxList:updateData(ipairs(self.stageData))
		self.costItem = activity_9001651_Read.getCostItem(self.classType, times)
		self.haveItem = backpackCtrl:getItemCount(self.costItem)
		self.fields.Com_have:initData(self.costItem)
		_ENV = i18n("weapon_creating_06", nil)
		i18n("weapon_creating_06", nil).count = string.formatnumberthousands(self.haveItem)
		self.fields.Com_have:updateNumTitle(i18n("common_text_1377", i18n("weapon_creating_06", nil)))
		self.fields.Btn_one:setCostIcon(publicRead.getIcon(self.costItem))
		self.fields.Btn_one:setNumTotal2(self.haveItem, 1, "#E02B2B")
		self.fields.Btn_ten:setCostIcon(publicRead.getIcon(self.costItem))
		self.fields.Btn_ten:setNumTotal2(self.haveItem, 10, "#E02B2B")
		if target then
			self.fields.mv_boom:setVisible(true)
			self.fields.mv_boom:setPlaySettings(0, -1, 1, -1, function()
				self.fields.mv_boom:setVisible(false)
			end)
		end
		local taskRedNum = activity_9001651_Ctrl:getTaskRedNum()
		self.fields.Btn_task:setRedVisible(0 < taskRedNum, taskRedNum)
	end
	local exchangeNum = activity_9001651_Ctrl:getExchangeNum()
	self.fields.Com_tab:setBtnRedDot(2, 0 < exchangeNum, exchangeNum)
end
function Activity_9001651_MainPanel:tickClick()
	SoraDPlaySound()
	self.isSkip = not self.isSkip
end
function Activity_9001651_MainPanel:btnOneClick()
	SoraDPlaySound()
	if self.haveItem >= 1 then
		activity_9001651_Ctrl:sendLotteryMsg(1)
		SoraDShowLoading(self)
	else
		_ENV = nil
		;(nil).itemID = self.costItem
		uiManager:show("CommonSourceGuide", nil)
	end
end
function Activity_9001651_MainPanel:btnTenClick()
	SoraDPlaySound()
	if self.haveItem >= 10 then
		activity_9001651_Ctrl:sendLotteryMsg(10)
		SoraDShowLoading(self)
	else
		_ENV = nil
		;(nil).itemID = self.costItem
		uiManager:show("CommonSourceGuide", nil)
	end
end
function Activity_9001651_MainPanel:btnTaskClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001651_Task")
end
function Activity_9001651_MainPanel:btnRewardClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001651_Reward")
end
function Activity_9001651_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("CombineServers_2")
	;(nil).content = i18n("weapon_creating_11")
	uiManager:show("RuleView", nil)
end
return Activity_9001651_MainPanel
