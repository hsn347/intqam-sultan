local eventQuestRead = include("eventQuestRead")
local heroNewTrialCtrl = SoraDGetCtrl("heroNewTrialCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroNewTrialTaskPanel = class("HeroNewTrialTaskPanel", baseFguiPanel)
function HeroNewTrialTaskPanel:ctor(...)
	HeroNewTrialTaskPanel.super.ctor(self, ...)
	print("HeroNewTrialTaskPanel:ctor", self.viewName)
end
function HeroNewTrialTaskPanel:onInit()
	print("=======HeroNewTrialTaskPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
end
function HeroNewTrialTaskPanel:onShow()
	print("=======HeroNewTrialTaskPanel:onShow")
	self.stage = self.param and self.param.stage
	self.taskId = self.param and self.param.taskId
	_ENV = nil
	;(nil).num = self.stage
	self.fields.Panel_bg:setString(i18n("hero_experience_02", nil))
	local taskDes = eventQuestRead.getDesNew(self.taskId)
	self.fields.Text_des:setString(taskDes)
	self.rewardList = eventQuestRead.getReward(self.taskId)
	self.fields.List:setNumItems(#self.rewardList)
	local aim = eventQuestRead.getAim(self.taskId)
	self.fields.bar:setMax(aim)
	local progress = heroNewTrialCtrl:getQuestComponent():getTaskProgress(self.taskId)
	progress = math.min(progress, aim)
	self.fields.bar:setValue(progress)
	local progressStr = string.formatnumberthousands(progress)
	if aim > progress then
		_ENV = i18n("hero_experience_02", nil)
		i18n("hero_experience_02", nil).color = "#ff0000"
		progressStr = SoraDWrapHtmlTagByStyle(progressStr, i18n("hero_experience_02", nil))
	end
	local aimStr = string.formatnumberthousands(aim)
	_ENV = i18n("hero_experience_02", nil)
	i18n("hero_experience_02", nil).member = progressStr
	i18n("hero_experience_02", nil).total = aimStr
	local barStr = i18n("common_text_155", i18n("hero_experience_02", nil))
	self.fields.bar:getChild("Text_bar"):setString(barStr)
	self.taskStatus = heroNewTrialCtrl:getQuestComponent():getTaskState(self.taskId)
	if self.taskStatus == gBtnTargetStatusDef.GET then
		self.fields.Button_go:setEnabled(true)
		self.fields.Button_go:setString(i18n("sheepFeed_text_12"))
	elseif self.taskStatus == gBtnTargetStatusDef.GO then
		if eventQuestRead.checkIsAct(self.taskId) then
			self.fields.Button_go:setString(i18n("common_text_477"))
		else
			self.fields.Button_go:setEnabled(false)
			self.fields.Button_go:setString(i18n("common_text_2139"))
		end
	elseif self.taskStatus == gBtnTargetStatusDef.GOT then
		self.fields.Button_go:setEnabled(false)
		self.fields.Button_go:setString(i18n("common_text_1892"))
	end
end
function HeroNewTrialTaskPanel:onItemRenderer(index, obj)
	local data = self.rewardList[index + 1]
	obj:initData(data.id, data.count)
end
function HeroNewTrialTaskPanel:onClickBtnGo(...)
	SoraDPlaySound()
	if self.taskStatus == gBtnTargetStatusDef.GET then
		heroNewTrialCtrl:reqCliam(self.taskId)
		self:closePanel()
	elseif self.taskStatus == gBtnTargetStatusDef.GO then
		self:taskJump(self.taskId)
	end
end
function HeroNewTrialTaskPanel:taskJump(taskId)
	self:closePanel()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	_ENV = nil
	;(nil).gameSource = "heroNewTrial"
	mildGuideManager:commonTaskJump(taskId, nil)
end
return HeroNewTrialTaskPanel
