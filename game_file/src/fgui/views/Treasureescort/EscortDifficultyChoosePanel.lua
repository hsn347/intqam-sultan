local allianceEscortCtrl = SoraDGetCtrl("allianceEscortCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EscortDifficultyChoosePanel = class("EscortDifficultyChoosePanel", baseFguiPanel)
function EscortDifficultyChoosePanel:ctor(...)
	self.super.ctor(self, ...)
	print("EscortDifficultyChoosePanel:ctor", self.viewName)
	self.curSelectIndex = nil
	self.maxDifficulty = allianceEscortCtrl:getEscortData().maxDifficulty
end
function EscortDifficultyChoosePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function EscortDifficultyChoosePanel:onInit()
	print("=======EscortDifficultyChoosePanel:onInit")
	self.fields.Panel_bg:setString(i18n("treasureEscort_text25"))
	self.fields.List_difficulty:setItemRenderer(handler(self, self.onDifficultyItemRenderer))
	self.fields.List_difficulty:setNumItems(allianceEscortCtrl:getDifficultyCount())
	self.fields.List_difficulty:setScrollEnable(false)
	local count = allianceEscortCtrl:getEscortTimes()
	local countColor = 0 < count and "#FFFFFF" or "#FF2E00"
	_ENV = allianceEscortCtrl:getDifficultyCount()
	_ENV, _ENV, allianceEscortCtrl:getDifficultyCount().count = allianceEscortCtrl:getDifficultyCount()
	allianceEscortCtrl:getDifficultyCount().count, allianceEscortCtrl:getDifficultyCount().color = allianceEscortCtrl:getDifficultyCount()
	self.fields.Text_count:setString(i18n_html("common_text_1673", allianceEscortCtrl:getDifficultyCount()))
	self.fields.Text_tips:setString(i18n("treasureEscort_text44"))
	self.fields.Button_sure:setString(i18n("common_text_204"))
	self.fields.Button_sure:addClickListener(handler(self, self.onClickBtnSure))
	self.fields.Button_cancel:setString(i18n("common_text_185"))
	self.fields.Button_cancel:addClickListener(handler(self, self.onClickClose))
end
function EscortDifficultyChoosePanel:onShow()
	print("=======EscortDifficultyChoosePanel:onShow")
end
function EscortDifficultyChoosePanel:onDifficultyItemRenderer(index, obj)
	local difficulty = index + 1
	local difficultyName = allianceEscortCtrl:getDifficultyName(difficulty)
	obj:getChild("Text_name"):setString(difficultyName)
	obj:addClickListener(handler(self, self.onClickDifficulty))
	obj:getController("c_difficulty"):setSelectedIndex(index)
	if difficulty > self.maxDifficulty + 1 then
		obj:getChild("n1"):setVisible(false)
		obj:getController("button"):setSelectedIndex(1)
		obj:getController("c_state"):setSelectedIndex(2)
	else
		obj:getController("c_state"):setSelectedIndex(1)
	end
end
function EscortDifficultyChoosePanel:onClickDifficulty(EventContext)
	SoraDPlaySound()
	local selectIndex = self.fields.List_difficulty:getSelectedIndex()
	local difficulty = selectIndex + 1
	if difficulty > self.maxDifficulty + 1 then
		_ENV = nil
		;(nil).name = allianceEscortCtrl:getDifficultyName(difficulty - 1)
		local tips = i18n("treasureEscort_text49", nil)
		SoraDShowMsgTip(tips)
		if self.curSelectIndex then
			self.fields.List_difficulty:setSelectedIndex(self.curSelectIndex)
		else
			self.fields.List_difficulty:removeSelection(selectIndex)
		end
		EventContext:getSender():getController("button"):setSelectedIndex(1)
	else
		if not self.curSelectIndex then
			self.controllers.c_state:setSelectedIndex(1)
		end
		self.curSelectIndex = selectIndex
	end
end
function EscortDifficultyChoosePanel:onClickBtnSure()
	SoraDPlaySound()
	local selectIndex = self.fields.List_difficulty:getSelectedIndex()
	if selectIndex == -1 then
		SoraDShowMsgTip(i18n("treasureEscort_text44"))
		return
	end
	local difficulty = selectIndex + 1
	if difficulty > self.maxDifficulty + 1 then
		_ENV = i18n("treasureEscort_text44")
		i18n("treasureEscort_text44").name = allianceEscortCtrl:getDifficultyName(difficulty - 1)
		SoraDShowMsgTip(i18n("treasureEscort_text49", i18n("treasureEscort_text44")))
		return
	end
	if not self:checkOpenCondition() then
		self:closePanel()
		return
	end
	local difficultyName = allianceEscortCtrl:getDifficultyName(difficulty)
	local constantRead = include("constantRead")
	local time = constantRead.getConstValue("TreasureEscort_Prepare_Time", 0)
	_ENV = i18n("treasureEscort_text49", i18n("treasureEscort_text44"))
	i18n("treasureEscort_text49", i18n("treasureEscort_text44")).var = difficultyName
	i18n("treasureEscort_text49", i18n("treasureEscort_text44")).time = math.floor(time / 3600)
	local showMsg = i18n("treasureEscort_text33", i18n("treasureEscort_text49", i18n("treasureEscort_text44")))
	SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			if self:checkOpenCondition() then
				allianceEscortCtrl:reqPrepare(difficulty)
			end
			self:closePanel()
		end
	end)
end
function EscortDifficultyChoosePanel:checkOpenCondition(...)
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	if not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("tips_place_noUnion"))
		return
	end
	local allianceDesRead = include("allianceDesRead")
	if not allianceDesRead.checkRank(gAllianceRank.R4, true, i18n("treasureEscort_text02")) then
		return
	end
	if not allianceEscortCtrl:checkOpenTime() then
		return
	end
	return true
end
return EscortDifficultyChoosePanel
