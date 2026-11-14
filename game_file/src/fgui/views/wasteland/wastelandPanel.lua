local activityTimeRead = include("activityTimeRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local wastelandCtrl = SoraDGetCtrl("wastelandCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local wastelandPanel = class("wastelandPanel", baseFguiPanel)
function wastelandPanel:ctor(...)
	self.super.ctor(self, ...)
	print("wastelandPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.WASTELAND
end
function wastelandPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "wasteland"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function wastelandPanel:onInit()
	print("=======wastelandPanel:onInit")
	local activityName = activityTimeRead.getActivityNameByID(self.activityID)
	self.fields.Com_title:initData(i18n(activityName), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	local Text_time = self.fields.Com_time:getChild("Text_time")
	Text_time = SoraDCreateTimerLabel(self, Text_time)
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		Text_time:beginTime(leftTime)
		local icon_time = self.fields.Com_time:getChild("icon_time")
		icon_time:setPositionX(Text_time:getPositionX() + Text_time:getContentSize().width + 7)
	end
	local Button_rank = self.fields.Button_rank
	Button_rank:addClickListener(handler(self, self.onBtnRankClick))
	self.showRankRed = self.proxy:getShowRankRed()
	Button_rank:setReddot(self.showRankRed)
	self.Text_rank = Button_rank:getChild("Text_rank")
	self.Text_rank:setString(i18n("common_text_827"))
	fguiHelper.SoraDChangeTextToHtml(self.fields.Text_count1)
	local countStr = wastelandCtrl:getMonsterCountStr()
	self.fields.Text_count1:setString(countStr)
	fguiHelper.SoraDChangeTextToHtml(self.fields.Text_count2)
	local countStr = wastelandCtrl:getBossCountStr()
	self.fields.Text_count2:setString(countStr)
	self.fields.Text_des:setString(i18n("wasteland_text_006"))
	self.fields.btn_kill:setText(i18n("wasteland_text_008"))
	self.fields.btn_kill:addClickListener(handler(self, self.onBtnKillClick))
	self.reward = worldMapDefine.getWorldBossReward(gBossType.wastelandBoss, 1)
	local Com_tip = self.fields.Com_tip
	local Text_des = Com_tip:getChild("Text_des")
	Text_des:setString(i18n("wasteland_text_007"))
	local List_rewards = Com_tip:getChild("List_rewards")
	List_rewards:setItemRenderer(handler(self, self.onNormalItemRenderer))
	List_rewards:setNumItems(#self.reward)
	if display.height > 1303 then
		local offset = display.height - 1303
		activityShowCtrl = #self.reward
		;(#self.reward)[1] = self.fields.Sprite_bg
		;(#self.reward)[2] = self.fields.Usm_bg
		for i, widget in ipairs(#self.reward) do
			widget:setPositionY(widget:getPositionY() + offset)
		end
	elseif display.height < 1000 then
		local offset = (1013 - display.height) / 2
		activityShowCtrl = ipairs(#self.reward)
		ipairs(#self.reward)[1] = self.fields.Sprite_bg
		ipairs(#self.reward)[2] = self.fields.Usm_bg
		for i, widget in ipairs(ipairs(#self.reward)) do
			widget:setPositionY(widget:getPositionY() - offset)
		end
	end
end
function wastelandPanel:onShow()
	print("=======wastelandPanel:onShow")
	wastelandCtrl:reqAllianceScoreRank(1, 1)
end
function wastelandPanel:onClickHelp()
	SoraDPlaySound()
	uiManager:show("wastelandHelp")
end
function wastelandPanel:onBtnRankClick()
	SoraDPlaySound()
	uiManager:show("wastelandRank")
	if self.showRankRed then
		self.fields.Button_rank:setReddot(false)
		self.proxy:cleanRankRed()
	end
end
function wastelandPanel:onBtnKillClick()
	SoraDPlaySound()
	SoraDRemoveAllPanelFromManager()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	_ENV = nil
	;(nil).chooseIndex = 19
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_MONSTER, nil)
end
function wastelandPanel:onNormalItemRenderer(index, obj)
	obj:initData(self.reward[index + 1])
end
function wastelandPanel:refreshMyRank(myRank)
	if myRank and myRank < 150 then
		_ENV = nil
		;(nil).var = myRank
		self.Text_rank:setString(i18n("wasteland_text_004", nil))
	else
		self.Text_rank:setString(i18n("common_text_827"))
	end
end
return wastelandPanel
