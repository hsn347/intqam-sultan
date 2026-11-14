local allianceScience = SoraDGetCtrl("allianceScience")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceProsperityRewardPopPanel = class("AllianceProsperityRewardPopPanel", baseFguiPanel)
function AllianceProsperityRewardPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceProsperityRewardPopPanel:ctor", self.viewName)
end
function AllianceProsperityRewardPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceProsperityRewardPopPanel:onInit()
	print("=======AllianceProsperityRewardPopPanel:onInit")
	self.itemID = 725601
	self.fields.Panel_bg:setString(i18n("common_text_2078"))
	_ENV = i18n("common_text_2078")
	i18n("common_text_2078").num = string.formatnumberthousands(300)
	self.fields.Text_tips1:setString(i18n("alliance_prosperity_text_06", i18n("common_text_2078")))
	self.fields.Text_tips2:setString(i18n("alliance_prosperity_text_07"))
	self.fields.Button_receive:setString(i18n("common_text_1146"))
	self.fields.Button_receive:addClickListener(handler(self, self.btnReceiveCallback))
end
function AllianceProsperityRewardPopPanel:onShow()
	print("=======AllianceProsperityRewardPopPanel:onShow")
	self:initData()
end
function AllianceProsperityRewardPopPanel:initData()
	self.rewardsCount = allianceScience:getProsperityRewardsCount()
	self.fields.Com_Item:initData(self.itemID, self.rewardsCount)
	self.fields.Com_Item:setNumText(self.rewardsCount)
	if self.rewardsCount <= 0 then
		self.fields.Button_receive:setEnabled(false)
		self.fields.Com_Item:setNumColor(display.COLOR_RED)
	else
		self.fields.Com_Item:setNumColor(display.COLOR_WHITE)
	end
end
function AllianceProsperityRewardPopPanel:btnReceiveCallback(button, type)
	SoraDPlaySound()
	if self.rewardsCount > 0 then
		SoraDShowLoading()
		allianceScience:reqReceiveProsperityReward()
		self:removeFromParent()
	end
end
return AllianceProsperityRewardPopPanel
