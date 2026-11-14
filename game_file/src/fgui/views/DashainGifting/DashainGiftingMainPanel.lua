local eidSignCtrl = SoraDGetCtrl("eidSignCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local signRewadRead = include("signRewadRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DashainGiftingMainPanel = class("DashainGiftingMainPanel", baseFguiPanel)
function DashainGiftingMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DashainGiftingMainPanel:ctor", self.viewName)
end
function DashainGiftingMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DashainGiftingMainPanel:onInit()
	print("=======DashainGiftingMainPanel:onInit")
	self.activityID = gActivityTimeActivityID.EID_SIGN_ACTIVITY
	self.fields.Com_title:initData(i18n("eidaladha_sign_text_01"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Com_Box:addClickListener(handler(self, self.onClickBox))
	self.awardConfig = signRewadRead.getEidaladhaSignCfg(activityShowCtrl:getParamClassType(self.activityID))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function DashainGiftingMainPanel:onShow()
	print("=======DashainGiftingMainPanel:onShow")
	eidSignCtrl:sendReqInitDataMsg()
	self:updateView()
end
function DashainGiftingMainPanel:updateView()
	self.fields.List:setNumItems(#self.awardConfig)
	print("eidSignCtrl:getShowIndex()", eidSignCtrl:getShowIndex())
	self.fields.List:scrollToView(eidSignCtrl:getShowIndex() - 1)
	self.status = eidSignCtrl:getExtraStatusByDay(7)
	self.fields.Usm_1:setVisible(self.status == gIceCrazyNightStatus.RECEIVE)
	self.fields.Com_Box:getController("c1"):setSelectedIndex(self.status)
	if self.status == gIceCrazyNightStatus.RECEIVE then
		self.fields.Com_Box:setString(i18n("common_text_1146"))
	elseif self.status == gIceCrazyNightStatus.RECEIVED then
		self.fields.Com_Box:setString(i18n("common_text_1892"))
	elseif self.status == gIceCrazyNightStatus.UNREACH then
		self.fields.Com_Box:setString(i18n("eidaladha_sign_text_05"))
	end
end
function DashainGiftingMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("eidaladha_sign_text_03")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function DashainGiftingMainPanel:onClickBox()
	SoraDPlaySound()
	uiManager:show("DashainGiftingPop"):setOwnerKey(key)
end
function DashainGiftingMainPanel:onItemRederer(index, target)
	target:initData(self.awardConfig[index + 1])
end
return DashainGiftingMainPanel
