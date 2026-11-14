local activityCommonSignRead = include("activityCommonSignRead")
local activity_9001688_Read = include("activity_9001688_Read")
local constantRead = include("constantRead")
local activityCommonSignCtrl = SoraDGetCtrl("activityCommonSignCtrl")
local activity_9001688_Ctrl = SoraDGetCtrl("activity_9001688_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001688_AwardPanel = class("Activity_9001688_AwardPanel", baseFguiPanel)
function Activity_9001688_AwardPanel:ctor(...)
	self.isLRU = true
	Activity_9001688_AwardPanel.super.ctor(self, ...)
	print("Activity_9001688_AwardPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.DAILY_SALUTE
end
function Activity_9001688_AwardPanel:onInit()
	print("=======Activity_9001688_AwardPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("common_text_2078"), handler(self, self.onClickClose))
	self.fields.Lab_base:setString(i18n("daily_salute_text23"))
	self.fields.Lab_extra:setString(i18n("daily_salute_text40"))
	self.fields.Text_val:setString(i18n("daily_salute_text25"))
	self.fields.Text_reward:setString(i18n("daily_salute_text24"))
	self.fields.List_sign:setVirtual()
	self.fields.List_sign:setItemRenderer(handler(self, self.onSignRenderer))
	self.fields.List_total:setItemRenderer(handler(self, self.onSignCumuRenderer))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankRenderer))
	self.fields.List_base:setItemRenderer(handler(self, self.onBaseRenderer))
	self.fields.List_stage:setVirtual()
	self.fields.List_stage:setItemRenderer(handler(self, self.onStageRenderer))
	self.fields.Text_val:fixPos()
	self.fields.Text_reward:fixPos()
end
function Activity_9001688_AwardPanel:onSignRenderer(index, obj)
	obj:initData(self.signCfg[index + 1], index + 1)
end
function Activity_9001688_AwardPanel:onSignCumuRenderer(index, obj)
	obj:initData(self.signCuumCfg[index + 1])
end
function Activity_9001688_AwardPanel:onRankRenderer(index, obj)
	obj:initData(self.rankCfg[index + 1])
end
function Activity_9001688_AwardPanel:onBaseRenderer(index, obj)
	obj:initData(self.baseCfg[index + 1].id, self.baseCfg[index + 1].count)
end
function Activity_9001688_AwardPanel:onStageRenderer(index, obj)
	obj:initData(self.stageCfg[index + 1])
end
function Activity_9001688_AwardPanel:endShow()
	print("=======Activity_9001688_AwardPanel:endShow")
	self.tag = 1
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("login_title_02")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("daily_salute_text20")
	_ENV, self.tag[2], (nil).tag = nil, nil, 2
	;(nil).title = i18n("daily_salute_text19")
	;(nil).tabsetArray, self.tag[3], (nil).tag = self.tag, nil, 3
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.Com_title:initTab(nil)
end
function Activity_9001688_AwardPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:initView()
end
function Activity_9001688_AwardPanel:initView()
	if self.tag == 1 then
		self.signCfg = clone(activityCommonSignRead.getRewardConfig(self.activityID))
		self.fields.List_sign:setNumItems(#self.signCfg)
		local cumuDay = activityCommonSignCtrl:getTotalSignDay(self.activityID)
		_ENV = activityCommonSignRead.getRewardConfig(self.activityID)
		activityCommonSignRead.getRewardConfig(self.activityID).num = cumuDay
		self.fields.Text_signTotal:setString(i18n("daily_salute_text22", activityCommonSignRead.getRewardConfig(self.activityID)))
		local signCuumCfg = activityCommonSignRead.getCumuDayArray(self.activityID)
		self.signCuumCfg, _ENV = self.activityID, self.activityID
		for k, v in ipairs(signCuumCfg) do
			_ENV = i18n("daily_salute_text22", activityCommonSignRead.getRewardConfig(self.activityID))
			i18n("daily_salute_text22", activityCommonSignRead.getRewardConfig(self.activityID)).day = v
			self.signCuumCfg[k], i18n("daily_salute_text22", activityCommonSignRead.getRewardConfig(self.activityID)).activityID = i18n("daily_salute_text22", activityCommonSignRead.getRewardConfig(self.activityID))
		end
		self.fields.List_total:setNumItems(#self.signCuumCfg)
	elseif self.tag == 2 then
		self.rankCfg = activity_9001688_Read.getRankCfg()
		self.fields.List_rank:setNumItems(#self.rankCfg)
	elseif self.tag == 3 then
		activityCommonSignCtrl = "DAILY_SALUTE_BASE_REWARD"
		;("DAILY_SALUTE_BASE_REWARD")[1] = "id"
		;("DAILY_SALUTE_BASE_REWARD")[2] = "count"
		self.baseCfg = serviceFunctions.tableFormat(constantRead.getConstValueArray("DAILY_SALUTE_BASE_REWARD"), "DAILY_SALUTE_BASE_REWARD")
		self.fields.List_base:setNumItems(#self.baseCfg)
		self.stageCfg = activity_9001688_Read.getStageCfg()
		self.fields.List_stage:setNumItems(#self.stageCfg)
	end
	local stageSignNum = activity_9001688_Ctrl:getStageSignNum()
	local signNum = activity_9001688_Ctrl:getSignGoldNum()
	self.fields.Com_title:setBtnRedDot(1, 0 < stageSignNum + signNum, stageSignNum + signNum)
end
return Activity_9001688_AwardPanel
