local allianceScience = SoraDGetCtrl("allianceScience")
local allianceProsperityRewardPopView = class("allianceProsperityRewardPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceProsperityRewardPopView")
	end
	return target
end)
function allianceProsperityRewardPopView:ctor()
	self.itemID = 725601
	self:initWidget()
	self:initData()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_PROSPERITY_CHANGE", handler(self, self.refreshProsperity))
end
function allianceProsperityRewardPopView:initWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_2078"))
	_ENV = i18n("common_text_2078")
	i18n("common_text_2078").num = string.formatnumberthousands(300)
	SoraDGetChildByName(self, "Text_tips1"):setString(i18n("alliance_prosperity_text_06", i18n("common_text_2078")))
	SoraDGetChildByName(self, "Text_tips2"):setString(i18n("alliance_prosperity_text_07"))
	self.itemAward = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward_item")
	self.itemAward:setOwnView(self)
	self.Button_receive = SoraDGetChildByName(self, "Button_receive")
	self.Button_receive:setTitleText(i18n("common_text_1146"))
	SoraDAutoSizeButtonTextByContent(self.Button_receive)
	self.Button_receive:addTouchEventListener(handler(self, self.btnReceiveCallback))
end
function allianceProsperityRewardPopView:initData()
	self.rewardsCount = allianceScience:getProsperityRewardsCount()
	self.itemAward:initData(self.itemID, self.rewardsCount)
	if self.rewardsCount <= 0 then
		self.Button_receive:setTouchEnabled(false)
		self.itemAward:setTextColor(display.COLOR_RED)
	end
end
function allianceProsperityRewardPopView:btnReceiveCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.rewardsCount > 0 then
			SoraDShowLoading()
			allianceScience:reqReceiveProsperityReward()
			self:removeFromParent()
		end
	end
end
function allianceProsperityRewardPopView:refreshProsperity(target, data)
	self:initData()
end
return allianceProsperityRewardPopView
