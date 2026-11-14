local badgeExchangeRead = include("badgeExchangeRead")
local publicRead = include("publicRead")
local badgeExchangeCtrl = SoraDGetCtrl("badgeExchangeCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local badgeExchangeViewPanel = class("badgeExchangeViewPanel", baseFguiPanel)
function badgeExchangeViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("badgeExchangeViewPanel:ctor", self.viewName)
end
function badgeExchangeViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function badgeExchangeViewPanel:onInit()
	print("=======badgeExchangeViewPanel:onInit")
	self.fields.Button_yes:setString(i18n("common_text_204"))
	self.fields.Button_yes:addClickListener(handler(self, self.okClick))
	self.fields.Button_no:setString(i18n("common_text_185"))
	self.fields.Button_no:addClickListener(handler(self, self.noClick))
	self.fields.Lab_res:fixPos()
	self.fields.Lab_target:fixPos()
	self.fields.Button_yes:fixPos()
	self.fields.Button_no:fixPos()
	self.fields.jt:setRotation(SoraDFIsRA() and 0 or 180)
end
function badgeExchangeViewPanel:onShow()
	print("=======badgeExchangeViewPanel:onShow")
	self.exchangeResID = self.param.resID
	self.resNum = self.param.resNum
	self.exchangeNum = self.param.exchangeNum
	self.badgeType = self.param.tabPage
	self.rewardNum = self.param.rewardNum
	self.targetID = self.param.targetID
	_ENV = nil
	;(nil).resource = publicRead.getName(self.exchangeResID)
	;(nil).name = publicRead.getName(self.targetID)
	self.fields.Text_content:setString(i18n("common_text_1908", nil))
	self.fields.Lab_res:initData(self.exchangeResID, self.resNum)
	self.fields.Lab_target:initData(self.targetID, self.exchangeNum * self.rewardNum)
end
function badgeExchangeViewPanel:okClick()
	SoraDPlaySound()
	badgeExchangeCtrl:sendExchange(self.exchangeResID, self.exchangeNum, self.badgeType)
	self:close()
end
function badgeExchangeViewPanel:noClick()
	SoraDPlaySound()
	self:close()
end
return badgeExchangeViewPanel
