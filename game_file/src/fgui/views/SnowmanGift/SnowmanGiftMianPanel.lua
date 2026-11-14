local snowmanGiftCtrl = SoraDGetCtrl("snowmanGiftCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SnowmanGiftMianPanel = class("SnowmanGiftMianPanel", baseFguiPanel)
function SnowmanGiftMianPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SnowmanGiftMianPanel:ctor", self.viewName)
end
function SnowmanGiftMianPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SnowmanGiftMianPanel:onInit()
	print("=======SnowmanGiftMianPanel:onInit")
	self.activityID = gActivityTimeActivityID.SNOW_MAN_GIFT_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001477"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Award_Box:addClickEventListener(handler(self, self.onClickAwardBox))
	self.fields.Award_Box:setString(i18n("snowmangift_text_03"))
	self.fields.Usm_2:setVisible(false)
end
function SnowmanGiftMianPanel:onShow()
	print("=======SnowmanGiftMianPanel:onShow")
	snowmanGiftCtrl:sendReqInitDataMsg()
	for i = 1, 7 do
		self.fields["part" .. i]:initData(i)
	end
end
function SnowmanGiftMianPanel:updateView()
	self.fields.Award_Box:updateBox()
	self.fields.List:updateView()
end
function SnowmanGiftMianPanel:playSuccessAnimation(day)
	if day then
		self.fields.Usm_2:setVisible(true)
		self.fields.Usm_2:play()
		self.fields["part" .. day]:playFadeIn()
	end
end
function SnowmanGiftMianPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("snowmangift_text_02")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function SnowmanGiftMianPanel:onClickAwardBox()
	SoraDPlaySound()
	_ENV = nil
	;(nil).type = 1
	;(nil).day = 7
	uiManager:show("SnowmanGiftBoxReward", nil)
end
return SnowmanGiftMianPanel
