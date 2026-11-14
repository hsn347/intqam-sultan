local pickupStarsAgainCtrl = SoraDGetCtrl("pickupStarsAgainCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
_ENV = "fgui.base.baseFguiPanel"
;("fgui.base.baseFguiPanel").PERSON = 1
local ("fgui.base.baseFguiPanel").GLOBAL, REWARDTYPE = 2, "fgui.base.baseFguiPanel"
local PickupStarsAgainRewardPanel = class("PickupStarsAgainRewardPanel", baseFguiPanel)
function PickupStarsAgainRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("PickupStarsAgainRewardPanel:ctor", self.viewName)
end
function PickupStarsAgainRewardPanel:onInit()
	print("=======PickupStarsAgainRewardPanel:onInit")
	self.fields.panel_normal:setString(i18n("pickup_star_006"))
	self.fields.Com_got:setString(i18n("common_text_1892"))
	self.rewardCfg = self.proxy.param.rewardCfg
	local myScore = pickupStarsAgainCtrl:getMyScore()
	self.fields.txt_not:setString(i18n("friend_back_text18"))
	self.fields.btn_get:setString(i18n("common_text_854"))
	_ENV = i18n("common_text_854")
	i18n("common_text_854").num = self.rewardCfg.NeedNum
	self.fields.txt_need:setString(i18n_html("pickup_star_007", i18n("common_text_854")))
	self.fields.scroll:setItemRenderer(handler(self, self.onNormalItemRenderer))
	self.fields.btn_get:addClickEventListener(handler(self, self.onBtnClick))
end
function PickupStarsAgainRewardPanel:onShow()
	self.rewards = self.rewardCfg.Reward
	self.fields.scroll:setNumItems(#self.rewards / 2)
	local isGot = pickupStarsAgainCtrl:isRewardGot(REWARDTYPE.PERSON, self.rewardCfg.Rank)
	if isGot then
		self.controllers.c1:setSelectedIndex(2)
	else
		local myScore = pickupStarsAgainCtrl:getMyScore()
		self.controllers.c1:setSelectedIndex(myScore < self.rewardCfg.NeedNum and 0 or 1)
	end
end
function PickupStarsAgainRewardPanel:onNormalItemRenderer(index, obj)
	obj:initData(self.rewards[2 * index + 1], self.rewards[2 * index + 2])
end
function PickupStarsAgainRewardPanel:onBtnClick()
	pickupStarsAgainCtrl:reqAnnivColossusTakeReward(self.rewardCfg.Rank)
end
return PickupStarsAgainRewardPanel
