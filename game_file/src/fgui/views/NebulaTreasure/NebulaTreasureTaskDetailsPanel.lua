local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaTreasureTaskDetailsPanel = class("NebulaTreasureTaskDetailsPanel", baseFguiPanel)
local eventQuestRead = include("eventQuestRead")
local nebulaTreasureRead = include("nebulaTreasureRead")
local nebulaTreasureCtrl = SoraDGetCtrl("nebulaTreasureCtrl")
_ENV = "nebulaTreasureCtrl"
;("nebulaTreasureCtrl").FINISH = 1
;("nebulaTreasureCtrl").UNCOMPLETE = 2
local ("nebulaTreasureCtrl").RECEIVE, TaskStatus = 3, "nebulaTreasureCtrl"
function NebulaTreasureTaskDetailsPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaTreasureTaskDetailsPanel:ctor", self.viewName)
end
function NebulaTreasureTaskDetailsPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaTreasureTaskDetailsPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	_ENV = self.view.fixChildrenPos
	self.view.fixChildrenPos[1] = "ForeignPShootGame"
	_ENV, self.gameTypes, self.view.fixChildrenPos[2] = self.view.fixChildrenPos, self.view.fixChildrenPos, "LinkLinkView"
	self.view.fixChildrenPos[1] = "exitic_pavillion_text_0103"
	self.help, self.view.fixChildrenPos[2] = self.view.fixChildrenPos, "exitic_pavillion_text_0111"
	print("=======NebulaTreasureTaskDetailsPanel:onInit")
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.taskID = self.param.taskID
	self.fields.Text_des:setString(eventQuestRead.getDesEx(tonumber(self.taskID)))
	self.fields.Text_title:setString(i18n(nebulaTreasureRead.getTitle(tonumber(self.taskID))))
	self.fields.icon:setIcon(nebulaTreasureRead.getIcon(self.taskID))
	self.fields.text_tips:setString(i18n("common_text_4458"))
	self.fields.Btn_go:addClickListener(handler(self, self.onButtonClick))
	self.fields.Btn_start:addClickListener(handler(self, self.onButtonClick))
	self.fields.btn_help:addClickListener(handler(self, self.onHelpClick))
	self.fields.Btn_start:setTitle(i18n("common_text_1139"))
	self.fields.txt_all_tip:setString(i18n("StarTreasure_text_24"))
	self.fields.txt_got:setString(i18n("common_text_1892"))
end
function NebulaTreasureTaskDetailsPanel:onShow()
	print("=======NebulaTreasureTaskDetailsPanel:onShow")
	self.rewards = eventQuestRead.getReward(tonumber(self.taskID))
	self.fields.List_award:setNumItems(#self.rewards)
	self:updateView()
end
function NebulaTreasureTaskDetailsPanel:updateView()
	print("=======NebulaTreasureTaskDetailsPanel:updateView")
	self.questType = nebulaTreasureRead.getQuestType(self.taskID)
	self.minGame = self.gameTypes[self.questType]
	self.fields.btn_help:setVisible(self.minGame ~= nil)
	local progress = nebulaTreasureCtrl:getTaskProgress(self.taskID)
	local targetStr = eventQuestRead.getAim(tonumber(self.taskID))
	if type(targetStr) == "number" then
		if progress > targetStr then
			progress = targetStr
		end
		targetStr = string.formatnumberthousands(targetStr)
	end
	_ENV = tonumber(self.taskID)
	tonumber(self.taskID).count = string.formatnumberthousands(progress)
	tonumber(self.taskID).total = targetStr
	self.fields.text_progress:setString(i18n("common_text_3683", tonumber(self.taskID)))
	if nebulaTreasureCtrl:getLastDailyCompleteCount() <= 0 then
		self.controllers.c1:setSelectedIndex(3)
		return
	end
	self.status = nebulaTreasureCtrl:getTaskStatus(self.taskID)
	if self.status == TaskStatus.UNCOMPLETE then
		self.controllers.c1:setSelectedIndex(0)
		if self.minGame then
			self.fields.Btn_start:setString(i18n("common_text_1139"))
		else
			self.fields.Btn_start:setTitle(i18n("common_text_477"))
		end
	elseif self.status == TaskStatus.FINISH then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Btn_go:setString(i18n("common_text_854"))
	else
		self.controllers.c1:setSelectedIndex(2)
	end
end
function NebulaTreasureTaskDetailsPanel:onItemRenderer(index, obj)
	local award = self.rewards[index + 1]
	obj:initData(award.id, award.count)
end
function NebulaTreasureTaskDetailsPanel:onButtonClick()
	SoraDPlaySound()
	if self.status == TaskStatus.FINISH then
		local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
		activityTaskComponentCtrl:reqRuestClaimReward(tonumber(self.taskID), gActivityTimeActivityID.NEBULA_TREASURE_ACTIVITY)
		self:close()
		return
	end
	if self.minGame == nil then
		local guideId = eventQuestRead.getGuideId(tonumber(self.taskID))
		if guideId and guideId ~= "" then
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			local tbParam = mildGuideManager:splitGuideParam(guideId)
			if tbParam.id == gNewPLayerTaskType.POP_TIP then
				SoraDShowMsgTip(i18n(taskDes))
			end
			local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
			if not notNeedClose then
				SoraDRemoveAllPanelFromManager()
			end
		end
	else
		_ENV = mildGuideManager:starMildByNewPlayerStringParam(guideId)
		mildGuideManager:starMildByNewPlayerStringParam(guideId).resultCallback = function(isWin)
			_ENV = nil
			;(nil).isWin = isWin
			;(nil).gameType = self.questType
			uiManager:show("NebulaTreasureResult", nil)
		end
		uiManager:show(self.minGame, mildGuideManager:starMildByNewPlayerStringParam(guideId))
	end
end
function NebulaTreasureTaskDetailsPanel:onHelpClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n(self.help[self.questType])
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return NebulaTreasureTaskDetailsPanel
