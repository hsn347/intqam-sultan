local baseFguiPanel = require("fgui.base.baseFguiPanel")
local heroTrialViewPanel = class("heroTrialViewPanel", baseFguiPanel)
function heroTrialViewPanel:ctor(...)
	heroTrialViewPanel.super.ctor(self, ...)
	print("heroTrialViewPanel:ctor", self.viewName)
end
function heroTrialViewPanel:onInit()
	print("=======heroTrialViewPanel:onInit")
	self.isAddToPopManager = true
	self.fields.Com_title:initData(i18n("common_text_1697"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Usm_bg:setPrivewImage("SingleBg/heroTrial_bg.png", cc.size(852, 1386), true)
	self.fields.Text_tip:setString(i18n("common_text_1701") .. " " .. i18n("common_text_1702"))
	self.fields.challengeBtn:setString(i18n("common_text_1698"))
	self.fields.challengeBtn:addClickListener(handler(self, self.onChallenge))
	self.fields.rankBtn:setString(i18n("common_text_4872"))
	self.fields.rankBtn:addClickListener(handler(self, self.onRank))
	self.fields.praiseBtn:setString(i18n("common_text_4873"))
	self.fields.praiseBtn:addClickListener(handler(self, self.onPraise))
	self.fields.rankBtn:fixPos()
	self.fields.praiseBtn:fixPos()
end
function heroTrialViewPanel:onShow()
	print("=======heroTrialViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
end
function heroTrialViewPanel:onChallenge()
	SoraDPlaySound()
	uiManager:show("heroTrialArea")
end
function heroTrialViewPanel:onRank()
	SoraDPlaySound()
	_ENV = nil
	;(nil).enum = lordRankingsDef.htStage
	uiManager:show("rankingsScrollView", nil)
end
function heroTrialViewPanel:onPraise()
	SoraDPlaySound()
	_ENV = nil
	;(nil).enum = lordRankingsDef.htLike
	uiManager:show("rankingsScrollView", nil)
end
function heroTrialViewPanel:onClickHelp()
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.HERO_TRIAL)
end
function heroTrialViewPanel:gameGuide_getTarget(itemName, parameters)
	return self.fields[itemName]
end
return heroTrialViewPanel
