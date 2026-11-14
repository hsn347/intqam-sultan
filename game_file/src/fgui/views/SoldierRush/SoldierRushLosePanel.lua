local soldierRushRead = include("soldierRushRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SoldierRushLosePanel = class("SoldierRushLosePanel", baseFguiPanel)
function SoldierRushLosePanel:ctor(...)
	self.super.ctor(self, ...)
	print("SoldierRushLosePanel:ctor", self.viewName)
end
function SoldierRushLosePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SoldierRushLosePanel:onInit()
	print("=======SoldierRushLosePanel:onInit")
	self.chapter = self.param.chapter
	self.gate = self.param.gate
	self.id = self.param.id
	self.fields.Text_tip:setString(i18n("soldier_rush_text_55"))
	self.fields.List_target:setItemRenderer(handler(self, self.onTargetRenderer))
	self.fields.Btn_try:setString(i18n("soldier_rush_text_23"))
	self.fields.Btn_try:addClickListener(handler(self, self.onBtnRestartClick))
	self.fields.Btn_back:setString(i18n("soldier_rush_text_24"))
	self.fields.Btn_back:addClickListener(handler(self, self.onBtnOutClick))
	self.fields.Btn_try:fixPos()
	self.fields.Btn_back:fixPos()
	SoraDPlaySound("huntSound", "hunt_lost")
end
function SoldierRushLosePanel:onTargetRenderer(index, obj)
	obj:initData(self.conditionList[index + 1], index + 1)
end
function SoldierRushLosePanel:onShow()
	print("=======SoldierRushLosePanel:onShow")
	SoraDPlaySound("huntSound", "hunt_lost")
	self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.fields.Usm_1:setEffectPath("sp_sszzsb_001.usm", false)
	self.fields.lose_sp:setURL(SoraDFIsRA() and "FONT_shibai_ar.png" or "FONT_shibai.png")
	local self.conditionList, _ENV, isShowHero = "Send_Soldier_Loss_Tips", "Send_Soldier_Loss_Tips", soldierRushRead.getConstantVal("Send_Soldier_Loss_Tips") ~= 0
	_ENV = false
	;(false).des = i18n("soldier_rush_text_56")
	;(false).handle = handler(self, self.upgradeCastle)
	table.insert(self.conditionList, false)
	if isShowHero then
		_ENV = false
		;(false).des = i18n("soldier_rush_text_57")
		;(false).handle = handler(self, self.recruitHero)
		table.insert(self.conditionList, false)
		_ENV = false
		;(false).des = i18n("soldier_rush_text_58")
		;(false).handle = handler(self, self.trainHero)
		table.insert(self.conditionList, false)
	end
	self.fields.List_target:setNumItems(#self.conditionList)
end
function SoldierRushLosePanel:upgradeCastle()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	if SoraDGetCastleLv() < CASTLE_MAXLV_NEW_WAR then
		_ENV = nil
		;(nil).bid = BUILDID.CASTLE
		;(nil).lv = SoraDGetCastleLv() + 1
		mildGuideManager:starToUpgrade(nil)
	else
		_ENV = nil
		;(nil).bid = BUILDID.CASTLE
		mildGuideManager:starToUpgradeStar(nil)
	end
	SoraDRemoveAllPanelFromManager()
end
function SoldierRushLosePanel:recruitHero()
	SoraDRemoveAllPanelFromManager()
	uiManager:show("newHeroListView")
end
function SoldierRushLosePanel:trainHero()
	SoraDRemoveAllPrePanelFromManager(self)
	_ENV = nil
	;(nil).jumpToBestHero = true
	uiManager:show("newHeroListView", nil)
end
function SoldierRushLosePanel:onBtnRestartClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_SOLDIERRUSH_UI_RESTART_GAME"
	;(nil).id = self.id
	;(nil).chapter = self.chapter
	;(nil).gate = self.gate
	SoraDSendMessage(nil)
	self:close()
end
function SoldierRushLosePanel:onBtnOutClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("soldier_rush_text_20")
	;(nil).confirmString = i18n("common_text_204")
	;(nil).cancelString = i18n("common_text_185")
	;(nil).confirmFunc = function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SOLDIERRUSH_UI_END_GAME"
		;(nil).id = self.id
		;(nil).chapter = self.chapter
		;(nil).gate = self.gate
		SoraDSendMessage(nil)
		self:close()
	end
	uiManager:show("MessageBox", nil)
end
function SoldierRushLosePanel:onClickClose()
	_ENV = nil
	;(nil).msg = "MESSAGE_SOLDIERRUSH_UI_END_GAME"
	;(nil).id = self.id
	;(nil).chapter = self.chapter
	;(nil).gate = self.gate
	SoraDSendMessage(nil)
	self:close()
end
return SoldierRushLosePanel
