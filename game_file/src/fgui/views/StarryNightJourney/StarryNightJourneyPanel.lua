local dailyRemindManager = include("dailyRemindManager")
local starryNightJourneyCtrl = SoraDGetCtrl("starryNightJourneyCtrl")
local ramadanAccuRechargeltCtrl = include("ramadanAccuRechargeltCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarryNightJourneyPanel = class("StarryNightJourneyPanel", baseFguiPanel)
function StarryNightJourneyPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarryNightJourneyPanel:ctor", self.viewName)
end
function StarryNightJourneyPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "AnnivColossusActivity"
		self._packageList, self._packageList[2] = self._packageList, "TheGoldMarket"
		self._packageList, self._packageList[3] = self._packageList, "DecryptionNew"
	end
	return self._packageList
end
function StarryNightJourneyPanel:onInit()
	print("=======StarryNightJourneyPanel:onInit")
	self:fixChildrenPos()
	self.fields.List_reward:fixPos()
	self.fields.Com_progress:fixPos()
	starryNightJourneyCtrl:sendReqInitDataMsg()
	self.activityID = gActivityTimeActivityID.STARRY_NIGHT_JOURNEY
	self.fields.Com_title:initData(i18n("activity_name_9001429"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self:setActivityTime()
	self.controllers.c1:setSelectedIndex(SoraDGetDefaultLanguage() == "ar" and 0 or 1)
	self.fields.Text_desc:setString(i18n("StarryNight_text_02"))
	self.fields.Button_go:setTitleText(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickGo))
	self.classType = activityShowCtrl:getParamByID(self.activityID).classtype
	self.configs = ramadanAccuRechargeltCtrl.getStarryNightJourneyReward(self.classType)
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.maxScore = self.configs[table.nums(self.configs)].score
end
function StarryNightJourneyPanel:initData()
	self.fields.List_reward:setNumItems(table.nums(self.configs))
	_ENV = table.nums(self.configs)
	table.nums(self.configs).num1 = starryNightJourneyCtrl:getCurScore()
	table.nums(self.configs).num2 = self.maxScore
	self.fields.Text_point:setString(i18n("StarryNight_03", table.nums(self.configs)))
	self.fields.Com_progress:setValue(starryNightJourneyCtrl:getCurScore(), self.maxScore)
end
function StarryNightJourneyPanel:onItemRenderer(index, object)
	object:initData(index + 1, self.configs[index + 1])
end
function StarryNightJourneyPanel:onClickGo()
	SoraDPlaySound()
	local key = dailyRemindManager.REMIND_TYPE.starryNightJounry
	if dailyRemindManager.checkNeedRemind(key) and starryNightJourneyCtrl:getCurScore() >= self.maxScore then
		dailyRemindManager.addRemindToManager(key)
		SoraDShowMsgBox(i18n("StarryNight_text_01"), i18n("common_text_477"), nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				SoraDRemoveAllPanelFromManager()
				local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
				_ENV = nil
				;(nil).chooseIndex = 20
				mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_MONSTER, nil)
			end
		end)
		return
	end
	SoraDRemoveAllPanelFromManager()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	function _ENV(callBack)
		if callBack == MSGBOX_CALLBACK_YES then
			SoraDRemoveAllPanelFromManager()
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			_ENV = nil
			;(nil).chooseIndex = 20
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_MONSTER, nil)
		end
	end
	;(function(callBack)
		if callBack == MSGBOX_CALLBACK_YES then
			SoraDRemoveAllPanelFromManager()
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			_ENV = nil
			;(nil).chooseIndex = 20
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_MONSTER, nil)
		end
	end).chooseIndex = 20
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_MONSTER, function(callBack)
		if callBack == MSGBOX_CALLBACK_YES then
			SoraDRemoveAllPanelFromManager()
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			_ENV = nil
			;(nil).chooseIndex = 20
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_MONSTER, nil)
		end
	end)
end
function StarryNightJourneyPanel:setActivityTime()
	self.fields.Label_time:setUbbOn()
	self.fields.Label_time:setTimeLast(function(strTime)
		local str = fguiHelper.getColorString("#FFC864", i18n("common_text_2669")) .. fguiHelper.getColorString("#FFFFFF", strTime)
		return str
	end)
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		self.fields.Label_time:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
end
function StarryNightJourneyPanel:onClickHelp()
	SoraDPlaySound()
	uiManager:show("StarryNightJourneyDetail"):setOwnerKey(self)
end
function StarryNightJourneyPanel:onShow()
	print("=======StarryNightJourneyPanel:onShow")
end
return StarryNightJourneyPanel
