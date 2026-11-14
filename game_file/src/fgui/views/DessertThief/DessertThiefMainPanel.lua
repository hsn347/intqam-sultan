local baseFguiPanel = require("fgui.base.baseFguiPanel")
local dessertThiefCtrl = SoraDGetCtrl("dessertThiefCtrl")
local DessertThiefMainPanel = class("DessertThiefMainPanel", baseFguiPanel)
function DessertThiefMainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("DessertThiefMainPanel:ctor", self.viewName)
end
function DessertThiefMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DessertThiefMainPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======DessertThiefMainPanel:onInit")
	self.activityID = gActivityTimeActivityID.SWEET_MEAT_ROBBER_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001540"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.btn_reward:setTitle(i18n("decrypt_text_03"))
	self.fields.btn_reward:addClickEventListener(handler(self, self.onRewardClick))
	self.fields.btn_call:setTitle(i18n("Dessert_Thief_05"))
	self.fields.btn_call:addClickEventListener(handler(self, self.onCallClick))
	self.fields.btn_go:setTitle(i18n("common_text_477"))
	self.fields.btn_go:addClickEventListener(handler(self, self.onGoClick))
	self.fields.btn_teams:setTitle(i18n("Dessert_Thief_03"))
	self.fields.btn_teams:addClickEventListener(handler(self, self.onTeamsClick))
	dessertThiefCtrl:sendInitMsg()
end
function DessertThiefMainPanel:onShow()
	print("=======DessertThiefMainPanel:onShow")
	self:updateView()
end
function DessertThiefMainPanel:updateView()
	local redDot, num = dessertThiefCtrl:getReceiveStatusAndNum()
	self.fields.btn_teams:setReddot(redDot, num)
	local bossData = dessertThiefCtrl:getBossData()
	self.fields.btn_call:setVisible(bossData == nil)
	self.fields.btn_go:setVisible(bossData ~= nil)
end
function DessertThiefMainPanel:onRewardClick()
	SoraDPlaySound()
	uiManager:show("DessertThiefReward"):setOwnerKey(self)
end
function DessertThiefMainPanel:onCallClick()
	SoraDPlaySound()
	uiManager:show("DessertThieFummon"):setOwnerKey(self)
end
function DessertThiefMainPanel:onGoClick()
	SoraDPlaySound()
	local x, y = dessertThiefCtrl:getBossPosition()
	SoraDRemoveAllPanelFromManager()
	SoraDGotoWorldMapPoint(cc.p(x, y), true)
end
function DessertThiefMainPanel:onTeamsClick()
	SoraDPlaySound()
	local panel = uiManager:show("AllianceWarView")
	panel.view:tabChange(gAllianceQueueClassType.pve)
end
function DessertThiefMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Dessert_Thief_01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return DessertThiefMainPanel
