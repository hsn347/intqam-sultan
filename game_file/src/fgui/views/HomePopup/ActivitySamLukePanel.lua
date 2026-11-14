local activityTimeRead = include("activityTimeRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ActivitySamLukePanel = class("ActivitySamLukePanel", baseFguiPanel)
function ActivitySamLukePanel:ctor(...)
	self.super.ctor(self, ...)
	print("ActivitySamLukePanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.SEMLUK_EXPERIENCE_BALL
	self.totalKill = include("constantRead").getConstValue("SEMRUK_DAY_KILLMAX")
end
function ActivitySamLukePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ActivitySamLukePanel:onInit()
	print("=======ActivitySamLukePanel:onInit")
	local activityname = activityTimeRead.getActivityNameByID(self.activityID)
	self.fields.Com_title:initData(i18n(activityname), handler(self, self.onClickClose))
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		_ENV = "common_text_2669"
		;("common_text_2669").color = "#FFC864"
		local timePrefix = SoraDWrapHtmlTagByStyle(i18n("common_text_2669"), "common_text_2669")
		self.fields.Label_time:setTimeLast(function(time)
			return timePrefix .. time
		end)
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.fields.Label_time:beginTime(leftTime)
	end
	local proxy = uiManager:getOrCreateProxy("HomePopup")
	local data = proxy:getConfigData(self.activityID)
	local artWord = SoraDFIsRA() and data.artWord_ar or data.artWord_en
	self.fields.Load_title:setURL(artWord)
	local timeStr = "15:00:00、18:00:00、21:00:00、23:00:00"
	if not IsArClient then
		timeStr = "00:00:00、04:00:00、08:00:00、12:00:00、16:00:00、20:00:00"
	end
	_ENV = handler(self, self.onClickClose)
	handler(self, self.onClickClose).time = timeStr
	self.fields.Text_des:setString(i18n("Semruk_text_02", handler(self, self.onClickClose)))
	local Com_buttonGo = self.fields.Com_buttonGo
	Com_buttonGo:getChild("Text_go1"):setString(i18n("common_text_3553"))
	self.Button_go = Com_buttonGo:getChild("Button_go")
	self.Button_go:addClickListener(handler(self, self.onKillGoClick))
	self.Text_refresh = SoraDCreateTimerLabel(self, self.fields.Text_refresh)
	self.Text_refresh:setTimeLast(function(time)
		return i18n("Endless_trial_text_07") .. time
	end)
	self.Text_refresh:setTimeEndListener(handler(self, self.refreshRemainTime))
	self:refreshRemainTime()
	self:initAwards()
end
function ActivitySamLukePanel:onShow()
	print("=======ActivitySamLukePanel:onShow")
	lordInfoCtrl:reqkillSemlukNum(gMapObjTypeDef.mapTypeSemluk)
	SoraDShowLoading()
end
function ActivitySamLukePanel:initData(...)
	local curKill = lordInfoCtrl:getKillSemlukNum()
	local Text_go2 = self.fields.Com_buttonGo:getChild("Text_go2")
	Text_go2:setColor(curKill >= self.totalKill and cc.c3b(255, 0, 0) or cc.c3b(255, 200, 50))
	lordInfoCtrl = 200
	;(200).num1 = curKill
	;(200).num2 = self.totalKill
	Text_go2:setString(i18n("Semruk_text_03", 200))
	self.Button_go:setEnabled(curKill < self.totalKill)
end
function ActivitySamLukePanel:refreshRemainTime(...)
	local monstersRefreshTime = self.proxy:getRefreshRemainTime()
	if 0 < monstersRefreshTime then
		self.Text_refresh:beginTime(monstersRefreshTime)
	end
end
function ActivitySamLukePanel:initAwards(...)
	local rewardItem = worldMapDefine.getMonsterReward(3126)
	local scroll = self.fields.List_rewards
	scroll:setItemRenderer(function(index, obj)
		local itemID = rewardItem[index + 1]
		obj:getChild("Com_item"):initData(itemID)
	end)
	scroll:setNumItems(#rewardItem)
end
function ActivitySamLukePanel:onKillGoClick(EventContext)
	SoraDPlaySound()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if currentView.__cname ~= "worldMapView" then
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINSCEN_ONSHOW"
			;(nil).viewType = VIEW_TYPE_MAP
			SoraDSendMessage(nil)
		end
	end
	SoraDRemoveAllPanelFromManager()
	local panel = SoraDCreatePanel("worldMapMonsterSearch")
	panel:setActivityId(gActivityTimeActivityID.SEMLUK_EXPERIENCE_BALL)
	panel:show()
end
return ActivitySamLukePanel
