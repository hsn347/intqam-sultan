local activity_9001737_Read = include("activity_9001737_Read")
local activity_9001737_Ctrl = SoraDGetCtrl("activity_9001737_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001737_MainPanel = class("Activity_9001737_MainPanel", baseFguiPanel)
function Activity_9001737_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001737_MainPanel.super.ctor(self, ...)
	print("Activity_9001737_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY
end
function Activity_9001737_MainPanel:onInit()
	print("=======Activity_9001737_MainPanel:onInit")
	self.fields.List_camp:setItemRenderer(handler(self, self.itemRenderer_List_camp))
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_camp:setTitle(i18n("troublemaker_text_03"))
	self.fields.Button_camp:addClickListener(handler(self, self.onClick_Button_camp))
	self.fields.Button_campRank:setTitle(i18n("flames_dunes_text21"))
	self.fields.Button_campRank:addClickListener(handler(self, self.onClick_Button_campRank))
	self.fields.Button_go:setTitle(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onClick_Button_go))
	self.fields.Text_tip:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("troublemaker_text_11", nil)
	end)
	self.fields.Text_tip:setTimeEndListener(function()
		self.fields.Text_tip:beginTime(3600)
	end)
	self.fields.Com_boxList:setBarColor(3)
end
function Activity_9001737_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("troublemaker_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001737_MainPanel:endShow()
	print("=======Activity_9001737_MainPanel:endShow")
	self.myCamp = activity_9001737_Ctrl:getMyCamp()
	self.controllers.c1:setSelectedIndex(self.myCamp > 0 and 1 or 0)
	self.stageData = self:initStageData()
	if self.myCamp > 0 then
		activity_9001737_Ctrl:sendReqInitDataMsg()
		SoraDShowLoading(self)
	end
end
function Activity_9001737_MainPanel:initStageData()
	local activity_9001737_Read, stageData
	local stageCfg = activity_9001737_Read.getStageRewardCfg()
	for __, cfg in ipairs(stageCfg) do
		activity_9001737_Read = nil
		;(nil).stage = cfg.stage
		;(nil).point = cfg.point
		;(nil).rewards = cfg.reward
		table.insert(stageData, nil)
	end
	activity_9001737_Read = ipairs(stageCfg)
	ipairs(stageCfg).activityID = self.activityID
	ipairs(stageCfg).stageMax = #stageData
	self.fields.Com_boxList:initData(ipairs(stageCfg))
	return stageData
end
function Activity_9001737_MainPanel:initAssign(target, data)
	print("=======Activity_9001737_MainPanel:initAssign")
	SoraDCloseLoading(self)
	self.myCamp = activity_9001737_Ctrl:getMyCamp()
	self.controllers.c1:setSelectedIndex(self.myCamp > 0 and 1 or 0)
	activity_9001737_Ctrl:sendReqInitDataMsg()
	SoraDShowLoading(self)
end
function Activity_9001737_MainPanel:initView(target, data)
	print("=======Activity_9001737_MainPanel:initView")
	SoraDCloseLoading(self)
	self.myCamp = activity_9001737_Ctrl:getMyCamp()
	if self.myCamp <= 0 then
		self.controllers.c1:setSelectedIndex(0)
		return
	end
	self.fields.Com_mine:initData()
	local point = activity_9001737_Ctrl:getPoint()
	_ENV = nil
	;(nil).point = fguiHelper.getColorString("#FFDF2D", string.formatnumberthousands(point))
	self.fields.Lab_score:setString(i18n("troublemaker_text_10", nil))
	self.otherCampList = activity_9001737_Ctrl:getCampRankList(true)
	self.fields.List_camp:setNumItems(#self.otherCampList)
	for __, data in ipairs(self.stageData) do
		data.state = activity_9001737_Ctrl:getStageBoxStatues(data.stage, data.point)
	end
	_ENV = ipairs(self.stageData)
	ipairs(self.stageData).score = point
	ipairs(self.stageData).stageData = self.stageData
	self.fields.Com_boxList:updateData(ipairs(self.stageData))
	local time = serviceFunctions.getNextHourTime()
	self.fields.Text_tip:beginTime(time)
end
function Activity_9001737_MainPanel:itemRenderer_List_camp(index, obj)
	local data = self.otherCampList[index + 1]
	obj:initData(data)
end
function Activity_9001737_MainPanel:onClick_Button_camp(context)
	SoraDPlaySound()
	activity_9001737_Ctrl:reqAssignCamp()
	SoraDShowLoading(self)
end
function Activity_9001737_MainPanel:onClick_Button_campRank(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001737_Rank")
end
function Activity_9001737_MainPanel:onClick_Button_go(context)
	SoraDPlaySound()
	SoraDRemoveAllPanelFromManager()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	_ENV = nil
	;(nil).activityID = self.activityID
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_MONSTER, nil)
end
return Activity_9001737_MainPanel
